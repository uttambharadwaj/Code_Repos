/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        AppRequestHelper.appReqToCreditDecisionEngine((List<Application_Request__c>) tp.newList, (Map<Id,Application_Request__c>) tp.oldMap);

    }

}
