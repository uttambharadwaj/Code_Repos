/**
 * Created by mfarrell on 3/20/20.
 */

public with sharing class LeadAfterDeleteTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        DeletedRecordsStageClass.processDelete(tp.oldList);

    }

}