/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        appReqAfterUpdateCreditDecision((List<Application_Request__c>) tp.newList, (Map<Id,Application_Request__c>) tp.oldMap);

    }

    private static void appReqAfterUpdateCreditDecision(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        for (Application_Request__c applicationRequest : appRequestList) {
            Application_Request__c old = arOldMap.get(applicationRequest.Id);

            if (System.IsBatch() == false && System.isFuture() == false && (old.Forward_Application_to_Credit__c == null || !(old.Forward_Application_to_Credit__c).equalsIgnoreCase('Yes')) && applicationRequest.Forward_Application_to_Credit__c != null && (applicationRequest.Forward_Application_to_Credit__c).equals('Yes')) {
                CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
            }

            // if Compliance of Fraud had to make a decision on the application, then decisioing needs to be re-run
            if (System.IsBatch() == false && System.isFuture() == false && ((old.Compliance_Decision__c != null && !(old.Compliance_Decision__c).equalsIgnoreCase(applicationRequest.Compliance_Decision__c)) || (old.Fraud_Decision__c != null && !(old.Fraud_Decision__c).equalsIgnoreCase(applicationRequest.Fraud_Decision__c)))
                    && (applicationRequest.Application_Stage__c).equalsIgnoreCase('Adjudication')
                    && (applicationRequest.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineNA.decisionEngineRunning == false) {

                CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
            }
        }
    }

}