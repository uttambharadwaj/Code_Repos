/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        appReqAfterInsertCreditDecision((List<Application_Request__c>) tp.newList);

    }

    private static void appReqAfterInsertCreditDecision(List<Application_Request__c> appRequestList) {

        for (Application_Request__c applicationRequest : appRequestList) {
            if (System.IsBatch() == false && System.isFuture() == false && applicationRequest.Forward_Application_to_Credit__c != null && (applicationRequest.Forward_Application_to_Credit__c).equals('Yes')) {
                CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
            }
        }
    }

}