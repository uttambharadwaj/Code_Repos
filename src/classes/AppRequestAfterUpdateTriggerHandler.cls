/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        appReqAfterUpdateCreditDecision((List<Application_Request__c>) tp.newList, (Map<Id,Application_Request__c>) tp.oldMap);

    }

    private static void appReqAfterUpdateCreditDecision(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        Set<Id> arids = AppRequestAndFinallyTriggerHandler.appsForCreditDecision;

        for (Application_Request__c ar : appRequestList) {
            Application_Request__c old = arOldMap.get(ar.Id);

            if (!System.IsBatch() && !System.isFuture() && AppRequestHelper.compareFields(ar, old)){
                arids.add(ar.Id); // pass to the andFinally handler for processing in an effort to avoid the off chance of performing two decisions consecutively.
            }
        }
    }

}