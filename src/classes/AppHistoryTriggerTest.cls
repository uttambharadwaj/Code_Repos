/**
 * Created by lhowland on 9/1/2020.
 */

@IsTest
public with sharing class AppHistoryTriggerTest {

    public static void test_updateEndDate() {

        Opportunity oppty = [SELECT Id FROM Opportunity WHERE Name='Test Oppty 10' LIMIT 1];
        Application_Request__c appRequest = [SELECT Id, Name FROM Application_Request__c WHERE Opportunity__c = :oppty.Id];
        System.debug('TEMP app request: ' + appRequest.Name);

        Test.startTest();
        appRequest.Credit_Info_Status__c = 'Info Needed';
        upsert appRequest;

        Application_History__c appHistory = [SELECT Id, End_Date__c FROM Application_History__c WHERE NA_Fleet_App__c = :appRequest.Id LIMIT 1];
        System.assert(appHistory != null, 'Expected an App History record to be created.');

        appRequest.Credit_Info_Status__c = 'Info Returned';
        upsert appRequest;

        List<Application_History__c> appHistories = [SELECT Id, End_Date__c FROM Application_History__c WHERE NA_Fleet_App__c = :appRequest.Id];
        System.debug('TEMP app histories: ' + appHistories);
        System.assert(appHistories.size() == 2, 'Expected 2 Application History records.');
        for (Application_History__c history : appHistories) {
            // find the record with the end date set. This should be the most recently created record.
            if (history.End_Date__c != null) appHistory = history;
        }
        System.assert(appHistory.End_Date__c != null, 'Expected end date to be set on the newly created record.');

        Test.stopTest();

    }
}