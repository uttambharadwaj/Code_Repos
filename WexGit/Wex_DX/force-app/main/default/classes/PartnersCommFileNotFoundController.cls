/*

    Name: PartnersCommFileNotFoundController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommFileNotFoundController extends APartnersComm 
{		
    public PartnersCommFileNotFoundController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommFileNotFoundController controller = new PartnersCommFileNotFoundController();
    	
    	Community__c settings = controller.Settings;
    }    
}