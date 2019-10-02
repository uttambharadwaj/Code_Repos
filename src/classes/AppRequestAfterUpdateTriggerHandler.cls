/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        afterUpdateAppReqToCreditDecisionEngine((List<Application_Request__c>) tp.newList, (Map<Id,Application_Request__c>) tp.oldMap);

    }

    private static void afterUpdateAppReqToCreditDecisionEngine(List<Application_Request__c> appRequestList, Map<Id,Application_Request__c> arOldMap) {

        Set<Id> arids = AppRequestTriggerDispatcher.appsForCreditDecision;

        for (Application_Request__c ar : appRequestList) {
            Application_Request__c old = arOldMap.get(ar.Id);

            if (!System.IsBatch() && !System.isFuture() && AppRequestHelper.compareFields(ar, old)) {
                arids.add(ar.Id);   // pass to a set in the TriggerDispatcher for processing.
                                    // This is to avoid the possibility of an AfterInsert and AfterUpdate entering the credit engine twice in the same execution.
            }
        }

    }

}