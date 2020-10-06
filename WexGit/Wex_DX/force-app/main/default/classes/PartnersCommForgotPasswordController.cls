/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class PartnersCommForgotPasswordController extends APartnersComm 
{
    public String username {get; set;}   
              
    public PartnersCommForgotPasswordController()
    {
    	super();
    }
    
    public PageReference forgotPassword() 
    {
        boolean success = Site.forgotPassword(username);

        PageReference pr = Page.PartnersCommHome; //PartnersCommForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if(success) 
        {              
            return pr;            
        }
        
        return null;
    }
        
     @IsTest(SeeAllData=true) 
     public static void testPartnersCommForgotPasswordController() 
     {
        // Instantiate a new controller with all parameters in the page
        PartnersCommForgotPasswordController controller = new PartnersCommForgotPasswordController();
        
        controller.username = 'test@salesforce.com';        
    	
    	Community__c settings = controller.Settings;
    	
        System.assertEquals(controller.forgotPassword(),null); 
    }
}