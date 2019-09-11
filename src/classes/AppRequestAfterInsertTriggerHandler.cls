/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        AppRequestHelper.appReqAfterInsertCreditDecision((List<Application_Request__c>) tp.newList);

    }

}