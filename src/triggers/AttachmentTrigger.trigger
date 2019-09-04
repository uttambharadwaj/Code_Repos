trigger AttachmentTrigger on Attachment (after insert) {
    TriggerFactory.createTriggerDispatcher(Attachment.SObjectType);
}