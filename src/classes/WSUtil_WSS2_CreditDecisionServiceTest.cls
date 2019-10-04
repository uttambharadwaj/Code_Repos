@isTest
public class WSUtil_WSS2_CreditDecisionServiceTest{

	public static void testGoodUpdate(){
		
		AU_Application_Request__c ar = [SELECT Id FROM AU_Application_Request__c WHERE WSS2_APPLICATION_ID__C = '12345' LIMIT 1];
		List<AU_Card_Details__c> cdList = [SELECT Id FROM AU_Card_Details__c];

		Test.startTest();
		Test.setMock(WebServiceMock.class, new MockServiceGenerator('WSS2_good')); //set mock
		WSUtil_WSS2_CreditDecisionService cds = new WSUtil_WSS2_CreditDecisionService();
		WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse myResponse = cds.UpdateApplicationStatus(ar,cdList,'123');
		Test.stopTest();

		system.assert(myResponse.Result,'It is not true.');
		system.assertEquals(null, myResponse.DataObject.Error,'It is not null.');

	}

	public static void testBadUpdate(){
		
		AU_Application_Request__c ar = [SELECT Id FROM AU_Application_Request__c WHERE WSS2_APPLICATION_ID__C = '12345' LIMIT 1];
		List<AU_Card_Details__c> cdList = [SELECT Id FROM AU_Card_Details__c];

		Test.startTest();
		Test.setMock(WebServiceMock.class, new MockServiceGenerator('WSS2_bad')); //set mock
		WSUtil_WSS2_CreditDecisionService cds = new WSUtil_WSS2_CreditDecisionService();
		WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse myResponse = cds.UpdateApplicationStatus(ar,cdList,'123');
		Test.stopTest();

		String expectError='Problem with web service - please contact system administrator. Error message: Unable to contact WSS, please try again later';

		system.assert(!myResponse.Result,'It is true.');
		system.assertEquals(1, myResponse.DataObject.Error.size(),'It is not one.');
		system.assertEquals(expectError, myResponse.DataObject.Error[0].Description,'The error has errored');

	}

}