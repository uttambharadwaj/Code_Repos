/**
 * Created by mfarrell on 2019-09-07.
 */

public class AppRequestBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        AppRequestHelper.communityUserStampData((List<Application_Request__c>) tp.newList);

        AppRequestHelper.appReqBeforeInsert((List<Application_Request__c>) tp.newList);

    }

}