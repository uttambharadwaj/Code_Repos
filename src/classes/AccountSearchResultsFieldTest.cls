/**
 * Created by Sara Schmidt (WEX) on 1/7/2020.
 */
@istest
public with sharing class AccountSearchResultsFieldTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    // Happy path test with accountNumber passed in
    // Expect a new Service Operations account to be created
    static testMethod void cloneOTRAccountIfNeeded_accountNumber() {
        Account a = new Account(Name = 'Tests: cloneOTRAccountIfNeeded_accountNumber', Carrier_ID__c = '');
        insert a;

        Test.startTest();
        //String result = AccountSearchResultsFieldController.cloneOTRAccountIfNeeded(a.id.toString(), null);
        Test.stopTest();


    }

    // Happy path test with accountRecordId passed in
    static testMethod void cloneOTRAccountIfNeeded_accountRecordId() {
        String result = AccountSearchResultsFieldController.cloneOTRAccountIfNeeded(null, 'accountRecordId');

    }

    /*sample test method
    	Case c = new Case(Subject = 'test', Status = 'Unread', Description = 'test desc', Previously_Closed__c = true);
		insert c;

		Test.startTest();
		Boolean response = AutoCaseStatusController.checkCaseStatusServ(c.Id);
		Test.stopTest();

		c = [SELECT Status FROM Case WHERE Id = :c.Id];
		System.assertEquals(true, response);
		System.assertEquals('Closed', c.Status);
     */
}