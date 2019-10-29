/**
 * Created by mfarrell on 2019-10-25.
 */

public class OpportunityBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UOpportunity.getStageId(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        Uopportunity.findCampaignByCouponCode(tp.newList);
        Uopportunity.communityUserStampData(tp.newList);
        UOpportunity.executeBREeze(tp.newList, (Map<Id, Opportunity>) tp.oldMap);

    }

}