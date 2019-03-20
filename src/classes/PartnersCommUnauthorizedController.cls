/*

    Name: PartnersCommUnauthorizedController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommUnauthorizedController extends APartnersComm 
{		
    public PartnersCommUnauthorizedController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommUnauthorizedController controller = new PartnersCommUnauthorizedController();
    	
    	Community__c settings = controller.Settings;
    }    
}