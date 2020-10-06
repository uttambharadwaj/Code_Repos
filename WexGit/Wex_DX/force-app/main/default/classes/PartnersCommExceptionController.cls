/*

    Name: PartnersCommExceptionController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommExceptionController extends APartnersComm 
{	
    public PartnersCommExceptionController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
    private static testMethod void test1()
    {
    	PartnersCommExceptionController controller = new PartnersCommExceptionController();
    	
    	Community__c settings = controller.Settings;
    }
}