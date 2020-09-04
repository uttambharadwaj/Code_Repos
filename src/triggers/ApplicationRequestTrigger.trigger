trigger ApplicationRequestTrigger on Application_Request__c (before insert, before update, after insert, after update) {
    TriggerFactory.createTriggerDispatcher(Application_Request__c.sObjectType);
}
