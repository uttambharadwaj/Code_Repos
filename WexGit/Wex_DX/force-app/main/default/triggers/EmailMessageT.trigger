trigger EmailMessageT on EmailMessage (before delete, before insert, after insert, after update) {
    EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();
    List<EmailMessage> messages = Trigger.new;

    if(trigger.isDelete) {
        messages = Trigger.old;
        UEmailMessage.DontDeleteCollectionsEmails(messages);
    }

    if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
        return;
    }

    if(trigger.isBefore == true) {
        if(trigger.isInsert == true) {
            UEmailMessage.filterDiscards(messages);
        }
    } else if(trigger.isAfter == true) {
        EmailMessageTriggerHelper.updateSurveySentField(messages, Trigger.oldMap);
    }
}