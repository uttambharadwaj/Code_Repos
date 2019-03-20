/*

    Name: PartnersCommBandwidthExceededController
    Created By: Jason McCormack (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class PartnersCommBandwidthExceededController extends APartnersComm 
{		
    public PartnersCommBandwidthExceededController()
    {
		super();
    }    
    
    public class CustomException extends Exception {}
    
    private static testMethod void test1()
    {
    	PartnersCommBandwidthExceededController controller = new PartnersCommBandwidthExceededController();
    	
    	Community__c settings = controller.Settings;
    }
}