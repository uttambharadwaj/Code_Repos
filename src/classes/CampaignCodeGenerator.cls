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
        Integer size;
        Integer indexOfAlphaStart = chars.indexOf('A');
        Integer sequentialAlphaCount = 0;

        while (randomCode.length() < codeLength) {

            // Do not have more than 2 alpha characters together
            size = sequentialAlphaCount < 2 ? chars.length() : indexOfAlphaStart;

            Integer randomNumber = Math.mod(Math.abs(Crypto.getRandomInteger()), size);

            // First character must be alpha
            if (randomCode.length() == 0 && randomNumber < indexOfAlphaStart) {
                randomNumber += indexOfAlphaStart;
            }

            if (randomNumber >= indexOfAlphaStart) {
                sequentialAlphaCount = sequentialAlphaCount >= 2 ? 0 : sequentialAlphaCount + 1;
            }

            randomCode += chars.substring(randomNumber, randomNumber + 1);
        }
        return randomCode;
    }
}