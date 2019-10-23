public class CampaignBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        assignCampaignCoupon((List<Campaign>) tp.newList); // Assign Campaign a code for Coupon_Code__c
    }
    private void assignCampaignCoupon(List<Campaign> campaignsList) {

        Campaign_Code_Generator__c ccgSettings = Campaign_Code_Generator__c.getInstance();
        if (ccgSettings.Quantity__c == null || ccgSettings.Code_Length__c == null || ccgSettings.Characters__c == null || ccgSettings.Enabled_Record_Types__c == null) return;

        List<String> enabledRecordTypes = ccgSettings.Enabled_Record_Types__c.split(';');
        List<String> campaignCodes = CampaignCodeGenerator.createCampaignCodes(campaignsList.size());

        if (campaignCodes.size() >= campaignsList.size()) {

            for (Integer i = 0; i < campaignsList.size(); i++) {

                if (campaignsList[i].Coupon_Code__c == null && enabledRecordTypes.contains(campaignsList[i].RecordTypeId)) {
                    campaignsList[i].Coupon_Code__c = campaignCodes[i];
                }

            }
        }
    }
}