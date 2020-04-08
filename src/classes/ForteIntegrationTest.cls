@isTest
private class ForteIntegrationTest {

//	@testSetup
//    static void setup(){
//        UtilityTestLoader.setAutomation(false);
//    }
//
//    private static testmethod void testIntegration() {
//
//		Test.setMock(HttpCalloutMock.class, new UOnlineApplicationTest());
//
//		OnlineApplicationOffer__c offer1 = UOnlineApplicationTest.createCompleteSavedOffer(OnlineApplication.LOCAL);
//		OnlineApplication__c app1 = UOnlineApplicationTest.getOnlineApplication(offer1.Id);
//
//		Test.startTest();
//		insert app1;
//		Test.stopTest();
//
//		app1 = [select Forte_Response_Code__c, Forte_Response_Type__c, Forte_Response_Message__c from OnlineApplication__c where Id = :app1.Id];
//		System.assertEquals('A01', app1.Forte_Response_Code__c);
//		System.assertEquals('A', app1.Forte_Response_Type__c);
//		System.assertEquals('APPROVED', app1.Forte_Response_Message__c);
//	}
//
//	private static testmethod void testIntegrationButton() {
//
//		Test.setMock(HttpCalloutMock.class, new UOnlineApplicationTest());
//
//		OnlineApplicationOffer__c offer1 = UOnlineApplicationTest.createCompleteSavedOffer(OnlineApplication.LOCAL);
//		OnlineApplication__c app1 = UOnlineApplicationTest.getOnlineApplication(offer1.Id);
//		insert app1;
//
//		Test.startTest();
//		ForteIntegrationButton.verifyAcctRtNos(app1.Id);
//		Test.stopTest();
//
//		app1 = [select Forte_Response_Code__c, Forte_Response_Type__c, Forte_Response_Message__c from OnlineApplication__c where Id = :app1.Id];
//		System.assertEquals('A01', app1.Forte_Response_Code__c);
//		System.assertEquals('A', app1.Forte_Response_Type__c);
//		System.assertEquals('APPROVED', app1.Forte_Response_Message__c);
//	}
//
//	private static testmethod void testBulk() {
//
//		Test.setMock(HttpCalloutMock.class, new UOnlineApplicationTest());
//
//		List<OnlineApplication__c> appList = new List<OnlineApplication__c> ();
//
//		OnlineApplicationOffer__c offer1 = UOnlineApplicationTest.createCompleteSavedOffer(OnlineApplication.LOCAL);
//
//		for (Integer i = 0; i< 50; i++) {
//			appList.add(UOnlineApplicationTest.getOnlineApplication(offer1.Id));
//		}
//
//		Test.startTest();
//		insert appList;
//		Test.stopTest();
//
//		appList = [select Forte_Response_Code__c, Forte_Response_Type__c, Forte_Response_Message__c from OnlineApplication__c];
//		for (Integer i = 0; i< 50; i++) {
//			System.assertEquals('A01', appList[i].Forte_Response_Code__c);
//			System.assertEquals('A', appList[i].Forte_Response_Type__c);
//			System.assertEquals('APPROVED', appList[i].Forte_Response_Message__c);
//		}
//	}
}