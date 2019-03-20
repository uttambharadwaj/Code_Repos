/**
 * Created by lhowland on 8/8/2018.
 */

trigger CPApplicationTrigger on CP_Application_Request__c (before insert, before update, after update, after insert) {

    for (CP_Application_Request__c cpApp : Trigger.new) {

        if (cpApp != null) {
            if (Trigger.isAfter && Trigger.isUpdate) {

                CP_Application_Request__c old = Trigger.oldMap.get(cpApp.Id);

                if (old.Application_Stage__c != null && !(old.Application_Stage__c).equalsIgnoreCase('Adjudication') && cpApp.Application_Stage__c != null && (cpApp.Application_Stage__c).equalsIgnoreCase('Adjudication')
                        && cpApp.Status__c != null && (cpApp.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineCP.decisionEngineRunning == false) {

                    System.debug('Running CP Credit Decision Engine...');
                    CreditDecisionEngineCP.runCPDecisioningProcessFuture(cpApp.Id);
                }
            }

            if (Trigger.isAfter && Trigger.isInsert) {

                if (cpApp.Application_Stage__c != null && (cpApp.Application_Stage__c).equalsIgnoreCase('Adjudication')
                        && cpApp.Status__c != null && (cpApp.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineCP.decisionEngineRunning == false) {

                    System.debug('Running CP Credit Decision Engine...');
                    CreditDecisionEngineCP.runCPDecisioningProcessFuture(cpApp.Id);
                }
            }
        }
    }
}