/*

    Name: PartnersCommInMaintenanceController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommInMaintenanceController extends APartnersComm 
{		
    public PartnersCommInMaintenanceController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
	private static testMethod void test1()
    {
    	PartnersCommInMaintenanceController controller = new PartnersCommInMaintenanceController();
    	
    	Community__c settings = controller.Settings;
    }    
}