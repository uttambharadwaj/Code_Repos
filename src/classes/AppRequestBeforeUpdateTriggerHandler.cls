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
                    SELECT Id, Opportunity__c, Opportunity_Number__c, Application_Request__c, Debug_Application_Parameter__c,
                            Billing_Address_Line_1__c, Billing_Address_Line_2__c, Billing_City__c, Billing_State__c, Billing_Postal_Code__c
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
                    //NAFONBOARD-95 - get the billing address from the application instead of the oppty and set it to the fleet enrollment record to keep the bots happy.
                    if (arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Street__c != null && fe.Billing_Address_Line_1__c == null) {
                        fe.Billing_Address_Line_1__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Street__c;
                    }
                    if (arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Street_Line_2__c != null && fe.Billing_Address_Line_2__c == null) {
                        fe.Billing_Address_Line_2__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Street_Line_2__c;
                    }
                    if (arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_City__c != null && fe.Billing_City__c == null) {
                        fe.Billing_City__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_City__c;
                    }
                    if (arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_State__c != null && fe.Billing_State__c == null) {
                        fe.Billing_State__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_State__c;
                    }
                    if (arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Zip_Postal_Code__c != null && fe.Billing_Postal_Code__c == null) {
                        fe.Billing_Postal_Code__c = arUpdatedMap.get(arToOpptyMap.get(fe.Opportunity__c)).Billing_Zip_Postal_Code__c;
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