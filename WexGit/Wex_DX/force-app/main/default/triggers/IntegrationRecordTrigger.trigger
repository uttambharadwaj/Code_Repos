trigger IntegrationRecordTrigger on IntegrationRecord__c (before insert, after insert, after update) {
    List<IntegrationRecord__c> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore == true) {
        if(trigger.isInsert == true) {
            IntegrationRecordTriggerHandler.createContact(records);
        } /* else if(trigger.isUpdate == true) {
        }  else if(trigger.isDelete == true) {
        } */
    } else if(trigger.isAfter == true) {
        if(trigger.isInsert == true) {
            IntegrationRecordTriggerHandler.updateContact(records, trigger.oldMap);
        } else if(trigger.isUpdate == true) {
            IntegrationRecordTriggerHandler.updateContact(records, trigger.oldMap);
        } /*else if(trigger.isDelete == true) {
        } else if(trigger.isUndelete == true) {
        } */
    }
}