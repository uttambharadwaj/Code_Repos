public class CampaignCodeGenerator {

    public static List<Campaign_Code__c> getCampaignCode() {
        return getCampaignCode(1);
    }
    public static List<Campaign_Code__c> getCampaignCode(Integer numberOfCodes) {
        List<Campaign_Code__c> usedCampaignCodes = new List<Campaign_Code__c>();
        List<Campaign_Code__c> campaignCodes = [
                    SELECT Id, Code_Used__c, Name
                    FROM Campaign_Code__c
                    WHERE Code_Used__c = FALSE AND Name != NULL
                    LIMIT :numberOfCodes
            ];

        if (campaignCodes.size() < numberOfCodes) {
            createCampaignCodes(); // This should only get called once.
            return Limits.getQueries() == Limits.getLimitQueries() ? null : getCampaignCode(numberOfCodes);
        }

        for (Campaign_Code__c campaignCode : campaignCodes) {
            campaignCode.Code_Used__c = true;
            usedCampaignCodes.add(campaignCode);
        }

        update usedCampaignCodes;
        return usedCampaignCodes;

    }

    private static void createCampaignCodes() {

        Campaign_Code_Generator__c ccgSettings = Campaign_Code_Generator__c.getInstance();

        List<Campaign_Code__c> campaignCodes = new List<Campaign_Code__c>();
        Set<String> generatedCampaignCodes = new Set<String>();
        Set<String> existingCampaignCodes = new Set<String>();

        for (Integer i = 0; i < ccgSettings.Quantity__c; i++) {
            generatedCampaignCodes.add(generateCode((Integer) ccgSettings.Code_Length__c, ccgSettings.Characters__c));
        }

        for (Campaign_Code__c campaignCode : [
                SELECT Id, Code_Used__c, Name
                FROM Campaign_Code__c
                WHERE Name IN :generatedCampaignCodes
        ]) {
            existingCampaignCodes.add(campaignCode.Name);
        }

        // Remove any existing codes from the generated list. Case sensitive.
        generatedCampaignCodes.removeAll(existingCampaignCodes);

        for (String code : generatedCampaignCodes) {
            campaignCodes.add(new Campaign_Code__c(Name = code));
        }
        insert campaignCodes;
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

            else if (randomNumber >= indexOfAlphaStart) {
                sequentialAlphaCount = sequentialAlphaCount >= 2 ? 0 : sequentialAlphaCount + 1;
            }

            randomCode += chars.substring(randomNumber, randomNumber + 1);
        }
        return randomCode;
    }
}