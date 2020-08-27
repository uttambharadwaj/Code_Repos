/**
 * Created by lhowland on 8/18/2020.
 */

@IsTest
public with sharing class CaseTriggerTest {

    public static void testSetCardsCreatedAfterUpdate() {

        Application_Request__c appRequest = [SELECT Id, Name, Cards_Created__c, Opportunity__c FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 7' LIMIT 1];
        Id recordTypeId = UtilityClass.getRecTypeByDevName('Case', 'Fleet_Implementation');
        User user = [SELECT Id, UserRole.Name FROM User WHERE UserRole.Name = 'Admin' AND IsActive = TRUE LIMIT 1];
        Case c = new Case(RecordTypeId = recordTypeId, Status = 'Working', Type = 'Data Entry', Cards__c = 2, OwnerId = user.Id, Subject = '2 Cards', Opportunity__c = appRequest.Opportunity__c, App_Request_This_Case__c = appRequest.Id, Description = 'Don\'t eat white baneberries');
        insert c;

        Test.startTest();

        System.assert(appRequest.Cards_Created__c == null, 'Expected Cards Created to be null');
        System.assert(c.Id != null, 'Expected Case to be created');

        c.Status = 'Closed';
        upsert c;

        appRequest = [SELECT Id, Name, Cards_Created__c FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 7' LIMIT 1];

        System.assert(appRequest.Cards_Created__c != null, 'Expected Cards Created set to the Close Date from the Case.');
        Test.stopTest();
    }

}