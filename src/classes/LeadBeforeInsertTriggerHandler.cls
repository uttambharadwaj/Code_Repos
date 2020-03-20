/**
 * Created by mfarrell on 3/20/20.
 */

public class LeadBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        ULead.updateCountryCode(tp.newList, (Map<Id, Lead>) tp.oldMap); // Update Mobile Phone country code based on associated program
        ULead.setVehicleCount(tp.newList, (Map<Id, Lead>) tp.oldMap); // look at moving to process builder
        ULead.linktoContactAccount(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.findCampaignByCouponCode(tp.newList);
        ULead.communityUserStampData(tp.newList);
        LeadHelper.sfIdtoCardId(tp.newList);
        LeadHelper.V2SA_UpdatePrimaryCampaignLeadUpload(tp.newList);
        LeadHelper.auValidateSuburbPostcode(tp.newList);

    }

}