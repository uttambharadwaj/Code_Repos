@isTest
public class ConsoleAlertControllerTest {
	@testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testController()
	{
		Service_Alerts__c alert = new Service_Alerts__c();
		alert.Subject__c = 'test';
		alert.Color__c = 'ban';
		alert.Start_Date__c = Datetime.now();
		alert.End_Date__c = Datetime.now().addDays(1);
		insert alert;

		Test.startTest();
		Service_Alerts__c response = ConsoleAlertController.checkForAlertServ();
		Test.stopTest();

		System.assertEquals(response.Id, alert.Id);
	}
}