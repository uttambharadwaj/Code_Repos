/**
 * Created by mfarrell on 9/24/20.
 */

trigger CollectionsTrigger on Collections__c (before update) {
    TriggerFactory.createTriggerDispatcher(Collections__c.SObjectType);
}