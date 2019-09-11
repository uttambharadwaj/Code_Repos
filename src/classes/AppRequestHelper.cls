/**
 * Created by mfarrell on 2019-09-07.
 *
 */

public class AppRequestHelper {

    public static void appReqBeforeInsert(List<Application_Request__c> appRequestList) {

        Map<Id, Id> arToOpptyMap = new Map<Id, Id>();
        Map<Id, Id> feToOpptyMap = new Map<Id, Id>();

        for (Application_Request__c ar : appRequestList) {
            arToOpptyMap.put(ar.Opportunity__c, ar.Id);
        }

        for (FleetEnrollment__c fe : [SELECT Id, Opportunity__c FROM FleetEnrollment__c WHERE Opportunity__c IN :arToOpptyMap.keySet()]) {
            feToOpptyMap.put(fe.Opportunity__c, fe.Id);
        }

        for (Application_Request__c applicationRequest : appRequestList) {

            if (applicationRequest.Sales_Person__c == null) {
                applicationRequest.Sales_Person__c = UserInfo.getUserId();
            }
            if (applicationRequest.Fleet_Enrollment__c == null && feToOpptyMap.size() > 0) {
                applicationRequest.Fleet_Enrollment__c = feToOpptyMap.get(applicationRequest.Opportunity__c);
            }
        }
    }

    public static void updateRelatedFERecords(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        Map<Id, Application_Request__c> arUpdatedMap = new Map<Id, Application_Request__c>();
        for (Application_Request__c ar : appRequestList) {
            if (ar.Siebel_Oppty__c != arOldMap.get(ar.Id).Siebel_Oppty__c) {
                arUpdatedMap.put(ar.Id, ar);
            }
        }

        if (arUpdatedMap.size() > 0) {

            Map<Id, Id> arToOpptyMap = new Map<Id, Id>();
            List<FleetEnrollment__c> feUpdateList = new List<FleetEnrollment__c>();

            for (Application_Request__c ar : arUpdatedMap.values()) {
                arToOpptyMap.put(ar.Opportunity__c, ar.Id);
            }

            for (FleetEnrollment__c fe : [
                    SELECT Id, Opportunity__c, Opportunity_Number__c, Application_Request__c, Debug_Application_Parameter__c
                    FROM FleetEnrollment__c
                    WHERE Opportunity__c IN :arToOpptyMap.keySet()])
            {
                feUpdateList.add(fe);
            }

            if (feUpdateList.size() > 0 ) {
                for (FleetEnrollment__c fe : feUpdateList) {
                    if (fe.Opportunity_Number__c == null) {
                        fe.Opportunity_Number__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Siebel_Oppty__c;
                    }
                    if (fe.Application_Request__c == null) {
                        fe.Application_Request__c = arToOpptyMap.get(fe.Opportunity__c);
                    }
                    if (fe.Debug_Application_Parameter__c == null) {
                        fe.Debug_Application_Parameter__c =arToOpptyMap.get(fe.Opportunity__c);
                    }
                }

                try {
                    upsert feUpdateList;
                } catch (DmlException e) {
                    System.debug('Error Inserting FleetEnrollment Records: ' + e.getMessage());
                }
            }
        }
    }

    public static void appReqAfterInsertCreditDecision(List<Application_Request__c> appRequestList) {

        for (Application_Request__c applicationRequest : appRequestList) {
            if (System.IsBatch() == false && System.isFuture() == false && applicationRequest.Forward_Application_to_Credit__c != null && (applicationRequest.Forward_Application_to_Credit__c).equals('Yes')) {
                CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
            }
        }

    }

    public static void appReqAfterUpdateCreditDecision(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

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

    public static void communityUserStampData(List<Application_Request__c> records) {

        // from existing UApplicationRequest Class
        Set<Id> scopeoppIds = new Set<Id>();
        for(Application_Request__c a : records) {
            if(a.Opportunity__c != null) scopeoppIds.add(a.Opportunity__c);
        }

        if(scopeoppIds.isEmpty()) return;

        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([
                SELECT Id, External_Referred_By_Account_Name__c, External_Referred_By__c
                FROM Opportunity
                WHERE Id IN :scopeoppIds
        ]);

        if(opps.isEmpty()) return;

        for(Application_Request__c ar : records) {
            if(!opps.containsKey(ar.Opportunity__c)) continue;

            Opportunity o = opps.get(ar.Opportunity__c);
            ar.External_Referred_by__c = o.External_Referred_By_Account_Name__c;
            ar.External_Referring_Contact__c = o.External_Referred_By__c;

        }

    }
}