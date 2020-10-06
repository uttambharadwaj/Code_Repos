/**
 * Created by mfarrell on 2019-10-25.
 */

public class OpportunityAfterDeleteTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        DeletedRecordsStageClass.processDelete(tp.oldList);
        
    }

}