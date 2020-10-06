/*

    Name: PartnersCommUnderConstructionController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommUnderConstructionController extends APartnersComm
{		
    public PartnersCommUnderConstructionController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommUnderConstructionController controller = new PartnersCommUnderConstructionController();
    	
    	Community__c settings = controller.Settings;
    }    
}