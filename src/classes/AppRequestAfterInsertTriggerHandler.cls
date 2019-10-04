/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        afterInsertFleetEnrollmentUpdate((List<Application_Request__c>) tp.newList);

        afterInsertAppReqToCreditDecisionEngine((List<Application_Request__c>) tp.newList);

    }

    private static void afterInsertFleetEnrollmentUpdate (List<Application_Request__c> appRequestList ) {
        Map<Id, Id> arToOpptyMap = new Map<Id, Id>();

        //set app requests to map for opportunity matching
        for (Application_Request__c ar : appRequestList) {
            arToOpptyMap.put(ar.Opportunity__c, ar.Id);
        }

        //check for fleet enrollment record with an opportunity that matches the app request.
        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Opportunity__c, Application_Request__c, Debug_Application_Parameter__c FROM FleetEnrollment__c WHERE Opportunity__c IN :arToOpptyMap.keySet()];

        //if we find fleet enrollment records, we want to update them with the app request ID.
        if (fleetEnrollments.size() > 0) {
            List<FleetEnrollment__c> feToUpdate = new List<FleetEnrollment__c>();

            for (FleetEnrollment__c fe : fleetEnrollments) {

                if (fe.Application_Request__c == null) {
                    fe.Application_Request__c = arToOpptyMap.get(fe.Opportunity__c);

                    if (fe.Debug_Application_Parameter__c == null) {
                        fe.Debug_Application_Parameter__c = arToOpptyMap.get(fe.Opportunity__c);
                    }

                    feToUpdate.add(fe);
                }
            }

            if (feToUpdate.size() > 0) {
                try {
                    update feToUpdate;
                } catch (DmlException e) {
                    System.debug('Error Updating FleetEnrollment Records: ' + e.getMessage());
                }
            }
        }

    }

    private static void afterInsertAppReqToCreditDecisionEngine(List<Application_Request__c> appRequestList) {

        Set<Id> arids = AppRequestTriggerDispatcher.appsForCreditDecision;

        for (Application_Request__c ar : appRequestList) {
            if (System.isBatch() == false && System.isFuture() == false && (ar.Forward_Application_to_Credit__c != null && (ar.Forward_Application_to_Credit__c).equals('Yes'))) {
                arids.add(ar.Id);   // pass to a set in the TriggerDispatcher for processing.
                // This is to avoid the possibility of an AfterInsert and AfterUpdate entering the credit engine twice in the same execution.
            }
        }

    }

}