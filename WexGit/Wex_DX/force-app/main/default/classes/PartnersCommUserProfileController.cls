/*

	Name: PartnersCommUserProfileController
	Created By: Jason McCormack (GearsCRM)
	Created Date: 
	Description: 
    
	Modified By: 
	Modified Date: 
	Description: 

*/

public with sharing class PartnersCommUserProfileController extends APartnersComm 
{	
    private User user;
    private boolean isEdit = false;
    
    public User getUser() 
    {
        return user;
    }

    public PartnersCommUserProfileController() 
    {
        user = getUserRecord(); 
                
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') 
        {
            throw new NoAccessException();
        }
    }
    
    private User getUserRecord()
    {
    	List<User> users = [select 
			        				Id, 
			        				Email, 
			        				Username, 
			        				UserType, 
			        				CommunityNickname, 
			        				TimezoneSidKey, 
			        				LanguageLocaleKey, 
			        				FirstName, 
			        				LastName, 
			        				Phone, 
			        				Title,
			                		Street, 
			                		City, 
			                		Country, 
			                		PostalCode, 
			                		State, 
			                		LocaleSidKey, 
			                		MobilePhone, 
			                		Extension, 
			                		Fax, 
			                		Contact.Email
			                	from 
			                		User
			                	where 
			                		Id = :UserInfo.getUserId()];
			                		
		if(users != null && users.size() == 1)
		{
			return users[0];
		}			        
		else
		{
		 	throw new CustomException('ERROR: Could not retrieve user (User Id: ' + UserInfo.getUserId() + ')');
		}    
		
		return null;   		
    }
        
    public Boolean getIsEdit() 
    {
        return isEdit;
    }
    
    public void edit() 
    {
        isEdit = true;
    }    
    
    public void save() 
    {
        if (user.contact != null) 
        {              
            setContactFields(user.contact, user);
        }
        
        try 
        {
            update user;
            
            if(user.contact != null) 
            { 
                update user.contact;
            }
            
            isEdit=false;
        } 
        catch(DmlException e) 
        {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference changePassword() 
    {
        return Page.PartnersCommChangePassword;
    }
    
    public void cancel() 
    {
        isEdit=false;
        
        user = getUserRecord();
    }
    
    private static void setContactFields(Contact c, User u) 
    {
        c.Title = u.Title;
        c.FirstName = u.FirstName;
        c.LastName = u.LastName;
        c.Email = u.Email;
        c.Phone = u.Phone;
        c.MobilePhone = u.MobilePhone;
        c.Fax = u.Fax;
        c.MailingStreet = u.Street;
        c.MailingCity = u.City;
        c.MailingState = u.State;
        c.MailingPostalCode = u.PostalCode;
        c.MailingCountry = u.Country;
    }

    @IsTest(SeeAllData=true) static void testSave() 
    {         
        // Modify the test to query for a portal user that exists in your org
        List<User> existingPartnersCommUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='PartnerSuccess'];

        if (existingPartnersCommUsers.isEmpty()) 
        {
            User currentUser = [select id, title, firstname, lastname, email, phone, mobilephone, fax, street, city, state, postalcode, country
                                FROM User WHERE id =: UserInfo.getUserId()];
                                
            PartnersCommUserProfileController controller = new PartnersCommUserProfileController();
            
            System.assertEquals(currentUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.isEdit == false, 'isEdit should default to false');
            
            controller.edit();
            
            System.assert(controller.isEdit == true);
            
            controller.cancel();
            
            System.assert(controller.isEdit == false);
            
            Contact c = new Contact();
            
            c.LastName = 'TestContact';
            
            insert c;
            
            setContactFields(c, currentUser);
            
            controller.save();
            
            System.assert(Page.PartnersCommChangePassword.getUrl().equals(controller.changePassword().getUrl()));
        } 
        else 
        {
            User existingPartnersCommUser = existingPartnersCommUsers[0];
            
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            
            System.runAs(existingPartnersCommUser) 
            {
                PartnersCommUserProfileController controller = new PartnersCommUserProfileController();
                
                System.assertEquals(existingPartnersCommUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
                System.assert(controller.isEdit == false, 'isEdit should default to false');
                
                controller.edit();
                
                System.assert(controller.isEdit == true);
                
                controller.cancel();
                
                System.assert(controller.isEdit == false);
                
                controller.getUser().Fax = randFax;
                
                controller.save();
                
                System.assert(controller.isEdit == false);
            }
            
            // verify that the user and contact were updated
            existingPartnersCommUser = [Select id, fax, Contact.Fax from User where id =: existingPartnersCommUser.Id];
            
            System.assert(existingPartnersCommUser.fax == randFax);
            System.assert(existingPartnersCommUser.Contact.fax == randFax);
        }
    }

	public class CustomException extends Exception {}
}