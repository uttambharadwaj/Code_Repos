/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityAfterInsertTriggerHandler extends TriggerHandlerBase{

    public override void mainEntry(TriggerParameters tp) {

        UOpportunity.createCommission(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunityShare.communityCheckSharing (tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.createTasks(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.updateProgramAccount(tp.newList, (Map<Id, Opportunity>) tp.oldMap);

        OpportunityHelper.createFleetEnrollment((List<Opportunity>) tp.newList); // create fleet enrollment record.

    }

}