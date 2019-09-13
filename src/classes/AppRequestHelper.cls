/**
 * Created by mfarrell on 2019-09-07.
 *
 */

public class AppRequestHelper {

    public static void appReqToCreditDecisionEngine(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        Set<Id> arids = AppRequestTriggerDispatcher.appsForCreditDecision;

        for (Application_Request__c ar : appRequestList) {
            Application_Request__c old = arOldMap.get(ar.Id);

            if (!System.IsBatch() && !System.isFuture() && compareFields(ar, old)){
                arids.add(ar.Id);   // pass to a set in the TriggerDispatcher for processing.
                // This is to avoid the possibility of an AfterInsert and AfterUpdate entering the credit engine twice in the same execution.
            }
        }
    }

    private static Boolean compareFields(Application_Request__c ar, Application_Request__c old) {

        if (System.IsBatch() == false
                && System.isFuture() == false
                &&  (
                        (
                            (ar.Forward_Application_to_Credit__c != null
                                    && (ar.Forward_Application_to_Credit__c).equals('Yes')
                            )
                        )
                    ||
                        (
                            (
                                (old.Compliance_Decision__c != null && !(old.Compliance_Decision__c).equalsIgnoreCase(ar.Compliance_Decision__c))
                                || (old.Fraud_Decision__c != null && !(old.Fraud_Decision__c).equalsIgnoreCase(ar.Fraud_Decision__c))
                            )
                            && (ar.Application_Stage__c).equalsIgnoreCase('Adjudication')
                            && (ar.Status__c).equalsIgnoreCase('Pending Decision')
                            && CreditDecisionEngineNA.decisionEngineRunning == false
                        )
                    )
            ) {
            return true;
        } return false;
    }

}
