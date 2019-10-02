/**
 * Created by mfarrell on 2019-09-07.
 *
 */

public class AppRequestHelper {

    public static Boolean compareFields(Application_Request__c ar, Application_Request__c old) {

        if (System.IsBatch() == false
                && System.isFuture() == false
                &&  (
                        (old.Compliance_Decision__c != null && !(old.Compliance_Decision__c).equalsIgnoreCase(ar.Compliance_Decision__c))
                        || (old.Fraud_Decision__c != null && !(old.Fraud_Decision__c).equalsIgnoreCase(ar.Fraud_Decision__c))
                    )
                    && (ar.Application_Stage__c).equalsIgnoreCase('Adjudication')
                    && (ar.Status__c).equalsIgnoreCase('Pending Decision')
                    && CreditDecisionEngineNA.decisionEngineRunning == false
            ) {
            return true;
        } return false;
    }

}