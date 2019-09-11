public class CampaignBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        assignCampaignCoupon((List<Campaign>) tp.newList); // Assign Campaign a code for Coupon_Code__c
    }
    private void assignCampaignCoupon(List<Campaign> campaignsList) {

        List<String> campaignCodes = CampaignCodeGenerator.createCampaignCodes(campaignsList.size());

        if (campaignCodes.size() >= campaignsList.size()) {

            for (Integer i = 0; i < campaignsList.size(); i++) {

                if (campaignsList[i].Coupon_Code__c == null) {
                    campaignsList[i].Coupon_Code__c = campaignCodes[i];
                }

            }
        }
    }
}