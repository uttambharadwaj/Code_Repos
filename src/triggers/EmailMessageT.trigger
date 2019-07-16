trigger EmailMessageT on EmailMessage (before insert, after insert, after update) {
    EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();

    if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
        return;
    }

    List<EmailMessage> messages = Trigger.new;

    if(trigger.isBefore == true) {
        if(trigger.isInsert == true) {
            UEmailMessage.filterDiscards(messages);
        }
    } else if(trigger.isAfter == true) {
        EmailMessageTriggerHelper.updateSurveySentField(messages, Trigger.oldMap);
    }
}