/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityAfterInsertTriggerHandler extends TriggerHandlerBase{

    public override void mainEntry(TriggerParameters tp) {

        OpportunityHelper.createFleetEnrollment((List<Opportunity>) tp.newList); // create fleet enrollment record.

    }

}