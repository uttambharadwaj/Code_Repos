public class CampaignBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        assignCampaignCoupon((List<Campaign>) tp.newList); // Assign Campaign a code for Coupon_Code__c
    }
    private void assignCampaignCoupon(List<Campaign> campaignsList) {

        for (Campaign campaign : campaignsList) {
            campaign.Coupon_Code__c = CampaignCodeGenerator.getCampaignCode();
        }
    }
}