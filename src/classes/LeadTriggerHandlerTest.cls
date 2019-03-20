@isTest
private class LeadTriggerHandlerTest {
    static testmethod void testRelatedTaskAndNote() {
        Id leadRT = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WES_Lead').getRecordTypeId();
        Lead l = new lead(company='test',lastname='test',Call_Outcome__c='test',Call_Outcome_Comments__c='test',recordtypeid=leadRT);

        Test.startTest();
        insert l;
        Test.stopTest();

        List<Task> tskList = [SELECT Id FROM Task WHERE WhoId =: l.Id];
        List<ContentDocumentLink> cdlList = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :l.Id];

        System.assertEquals(1, tskList.size());
        System.assertEquals(1, cdlList.size());
    }
}