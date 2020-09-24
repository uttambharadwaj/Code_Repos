/**
 * Created by W501611 on 9/11/2020.
 */

trigger CreditLineTrigger on Credit_Line_Adjustment__c (after insert, after update) {
    TriggerFactory.createTriggerDispatcher(Credit_Line_Adjustment__c.SObjectType);
}