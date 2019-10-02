/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        afterInsertappReqToCreditDecisionEngine((List<Application_Request__c>) tp.newList);

    }

    private static void afterInsertappReqToCreditDecisionEngine(List<Application_Request__c> appRequestList) {

        Set<Id> arids = AppRequestTriggerDispatcher.appsForCreditDecision;

        for (Application_Request__c ar : appRequestList) {
            if (System.IsBatch() == false && System.isFuture() == false && (ar.Forward_Application_to_Credit__c != null && (ar.Forward_Application_to_Credit__c).equals('Yes'))) {
                arids.add(ar.Id);   // pass to a set in the TriggerDispatcher for processing.
                                    // This is to avoid the possibility of an AfterInsert and AfterUpdate entering the credit engine twice in the same execution.
            }
        }

    }

}