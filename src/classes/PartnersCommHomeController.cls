/*

    Name: PartnersCommHomeController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommHomeController extends APartnersComm
{		
    public PartnersCommHomeController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommHomeController controller = new PartnersCommHomeController();
    	
    	Community__c settings = controller.Settings;
    }    
}