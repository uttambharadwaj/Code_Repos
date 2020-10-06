/**
 * Created by mfarrell on 2019-10-25.
 */

public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UOpportunity.echoAfter(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.createCommission(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunityShare.communityCheckSharing (tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.createTasks(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        
    }

}