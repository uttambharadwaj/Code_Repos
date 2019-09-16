/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        updateRelatedFERecords((List<Application_Request__c>) tp.newList, (Map<Id,Application_Request__c>) tp.oldMap);

    }

    private static void updateRelatedFERecords(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        Map<Id, Application_Request__c> arUpdatedMap = new Map<Id, Application_Request__c>();
        for (Application_Request__c ar : appRequestList) {
            if (ar.Sales_Stage__c != arOldMap.get(ar.Id).Sales_Stage__c) {
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
                        fe.Debug_Application_Parameter__c = arToOpptyMap.get(fe.Opportunity__c);
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

}