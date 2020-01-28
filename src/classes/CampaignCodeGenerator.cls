public class CampaignCodeGenerator {

    public static List<String> createCampaignCodes(Integer requestedAmount) {

        Campaign_Code_Generator__c ccgSettings = Campaign_Code_Generator__c.getInstance();
        if (ccgSettings.Quantity__c == null || ccgSettings.Code_Length__c == null || ccgSettings.Characters__c == null) return new List<String>();

        Set<String> generatedCampaignCodes = new Set<String>();
        Set<String> existingCampaignCodes = new Set<String>();
        Integer codeQuantity = (Integer) ccgSettings.Quantity__c + requestedAmount;

        for (Integer i = 0; i < codeQuantity; i++) {
            generatedCampaignCodes.add(generateCode((Integer) ccgSettings.Code_Length__c, ccgSettings.Characters__c));
        }

        for (Campaign campaign : [
                SELECT Id, Coupon_Code__c
                FROM Campaign
                WHERE Coupon_Code__c IN :generatedCampaignCodes
        ]) {
            existingCampaignCodes.add(campaign.Coupon_Code__c);
        }

        // Remove any existing codes from the generated list. Case sensitive.
        generatedCampaignCodes.removeAll(existingCampaignCodes);
        return new List<String>(generatedCampaignCodes);
    }

    @TestVisible
    private static String generateCode(Integer codeLength, String chars) {

        String randomCode = '';
        Integer randomNumber;
        Integer indexOfAlphaStart = chars.indexOfAnyBut('0123456789');
        Integer size = chars.length() - indexOfAlphaStart;

        while (randomCode.length() < codeLength) {

            randomNumber = Math.mod(Math.abs(Crypto.getRandomInteger()), size);

            if (randomCode.length() == 0) {
                randomNumber += indexOfAlphaStart; // First character should be alpha.
                size = chars.length() - (chars.length() - indexOfAlphaStart); // The rest should be numeric
            }

            randomCode += chars.substring(randomNumber, randomNumber + 1);
        }
        return randomCode;
    }
}