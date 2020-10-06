/*

	Name: PartnersCommChangePasswordController
	Created By: Jason McCormack (GearsCRM)
	Created Date: 
	Description: 
    
	Modified By: 
	Modified Date: 
	Description: 

*/

public with sharing class PartnersCommChangePasswordController extends APartnersComm 
{	
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PartnersCommChangePasswordController() 
    {
    	super();
    }
    
    public PageReference changePassword() 
    {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }    
    
    public static testMethod void testPartnersCommChangePasswordController() 
    {
        // Instantiate a new controller with all parameters in the page
        PartnersCommChangePasswordController controller = new PartnersCommChangePasswordController();
        
        Community__c settings = controller.Settings;
        
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}