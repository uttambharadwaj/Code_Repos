/**
 * Created by lhowland on 8/31/2020.
 */

trigger AppHistoryTrigger on Application_History__c (before insert) {
TriggerFactory.createTriggerDispatcher(Application_History__c.SObjectType);
}