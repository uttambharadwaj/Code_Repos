/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        appReqBeforeInsert((List<Application_Request__c>) tp.newList);

    }

    private static void appReqBeforeInsert(List<Application_Request__c> appRequestList) {

        Map<Id, Id> arToOpptyMap = new Map<Id, Id>();
        Map<Id, Id> feToOpptyMap = new Map<Id, Id>();

        for (Application_Request__c ar : appRequestList) {
            if(ar.Opportunity__c!=null)arToOpptyMap.put(ar.Opportunity__c, ar.Id);
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
    
}