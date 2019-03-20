trigger QuoteDocumentTrigger on SBQQ__QuoteDocument__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        QuoteDocumentTriggerHandler.createApplications(Trigger.newMap);
    }
}