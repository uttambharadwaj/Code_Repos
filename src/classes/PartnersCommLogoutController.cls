/*

    Name: PartnersCommLogoutController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public class PartnersCommLogoutController extends APartnersComm 
{	
	public String ServerName {get; private set;}
	public String CommunityName {get; private set;}	

    public PartnersCommLogoutController() 
    {    	
		loadSettings();
    }
    
    private void loadSettings()
    {
    	String prefix = 'Customer Portal';
    	
    	try
    	{
    		this.ServerName = Setting__c.getInstance(prefix + ' Server Name').Value__c;
    		this.CommunityName = Setting__c.getInstance(prefix + ' Community Name').Value__c;    		    	
    	}
    	catch(Exception e)
    	{
    		System.debug('EXCEPTION: ' + e);
    	}
    }  
    
    private static testMethod void test1()
    {
    	Integer testNumber = 1;
    	
    	Deployment_PartnersCommunity d = new Deployment_PartnersCommunity(Deployment_PartnersCommunity.Environment.DEV);
	    
	    d.run();
    	
    	PartnersCommLoginController controllerIn = new PartnersCommLoginController();
    	
    	PartnersCommLogoutController controllerOut = new PartnersCommLogoutController();
    	
    	System.assertEquals(controllerIn.ServerName, controllerOut.ServerName, UTestData.getAssertMessage(testNumber, 1));
    	System.assertEquals(controllerIn.ServerName, controllerOut.ServerName, UTestData.getAssertMessage(testNumber, 2));
    }
    
    public class CustomException extends Exception {}
}