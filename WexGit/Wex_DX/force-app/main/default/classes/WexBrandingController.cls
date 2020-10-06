/*
*
* This class provides standard access to the following branding/Marketing elements:
*
* - Partners (i.e. CircleK)
* - Program (i.e. CircleK Universal) & Attachments
* - Branding Utility (i.e. French Language Support, Default English Branding)
* - Program Template Accounts (Account Setup)
* - Campaign
* - Campaign Program
*
*/
public class WexBrandingController {

    /** Branding **/
    public static Id getProgramIdByBrandShortName(String brandShortName) {

        List<Program__c> programs = [SELECT Id FROM Program__c WHERE Brand_Short_Name__c = :brandShortName];

        if (programs.size() == 1) {
            return programs[0].Id;
        }

        return null;

    }

    public static Program__c getProgram(Id programId) {

        DescribeSObjectResult describeResult = programId.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

        String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' id = :programId ' + ' LIMIT 1 ';

        System.debug(query);

        List<Program__c> programs = Database.query(query);

        if (programs.size() == 1) {

            return programs[0];

        }

        return null;

    }


    // Get the branding utility RECORD for a given program id
    public static BOCA_res__c getBrandingUtilRecordByProgramId(Id programId) {
        return getBrandingUtilRecordByProgramId(programId, null);
    }
    public static BOCA_res__c getBrandingUtilRecordByProgramId(Id programId, String language) {
        //List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_Res__c WHERE Program__c = :program.Id and BOCA_Default__c = true];
        //List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];
        String query = UtilityClass.selectStar('BOCA_Res__c') + 'WHERE Program__c = :programId AND ';
        query += language != null ? 'ISO_Code__c = :language' : 'BOCA_Default__c = true';

        List<BOCA_res__c> brandingUtilities = Database.query(query);
        if (brandingUtilities.isEmpty()) {
            query = UtilityClass.selectStar('BOCA_Res__c') + 'WHERE Program__c = :programId AND BOCA_Default__c = true';
            brandingUtilities = Database.query(query);
        }

        return brandingUtilities.isEmpty() ? null : brandingUtilities[0];
    }

    public static Id getBrandingUtilityByProgramId(Id programId, String languageCode) {

        List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :programId AND ISO_code__c = :languageCode];

        if (brandingUtilities.size() == 1) {

            return brandingUtilities[0].Id;

        } else {

            brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :programId AND ISO_code__c = 'en_us'];

            if (brandingUtilities.size() == 1) {

                return brandingUtilities[0].Id;

            }

        }

        return null;

    }

    public static BOCA_res__c getBrandingUtility(Id brandingUtilityId) {

        DescribeSObjectResult describeResult = brandingUtilityId.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

        String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Id = :brandingUtilityId ' + ' LIMIT 1 ';

        List<BOCA_res__c> brandingUtilities = Database.query(query);

        if (brandingUtilities.size() == 1) {

            return brandingUtilities[0];

        }

        return null;

    }

    public static String getAvailableLanguages(Id programId) {

        List<String> availableLanguageCodes = new List<String>();

        for (BOCA_res__c brandingUtilities : [SELECT Id, ISO_code__c FROM BOCA_res__c WHERE Program__c = :programId]) {

            availableLanguageCodes.add(brandingUtilities.ISO_code__c);

        }

        return String.join(availableLanguageCodes, ';');

    }

    public static Id getLogoId(Id programId) {

        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = :'ui-logo.png'];

            return logo.Id;

        } catch (Exception e) {

            System.debug('### ERROR - Cannot find \'ui-logo.png\' (Attachments) for Program: ' + programId);

        }

        return null;

    }

    public static Id getCreditCardImageId(Id programId) {

        System.debug('### ' + programId);

        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = :'ui-credit-card.png'];

            return logo.Id;

        } catch (Exception e) {

            System.debug('### ERROR - Cannot find \'ui-credit-card.png\' for Program: ' + programId);

        }

        return null;

    }

    public static Id getCreditCardNotTextImageId(Id programId) {

        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = :'ui-credit-card-no-text.png'];

            return logo.Id;

        } catch (Exception e) {

            System.debug('### ERROR - Cannot find \'ui-credit-card-no-text.png\' for Program: ' + programId);

        }

        return null;

    }

    public static Id getCreditCardOneToOne(Id programId){
        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = :'ui-credit-card-one-to-one.png' LIMIT 1];
            system.debug(logo);
            if(logo != null)
                return logo.Id;



        } catch (Exception e) {

            return getCreditCardNotTextImageId(programId);

        }

        return null;
    }

    public static Id getBPAVLogoId(Id programId) {

        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = :'ui-bpav-logo.png'];

            return logo.Id;

        } catch (Exception e) {

            System.debug('### ERROR - Cannot find \'ui-bpav-logo.png\' for Program: ' + programId);

        }

        return null;

    }

    public static Id getPartnerLogoId(Id partnerId) {

        try {

            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :partnerId AND Name = :'ui-logo.png'];

            return logo.Id;

        } catch (Exception e) {

            System.debug('### ERROR - Cannot find \'ui-logo.png\' for Program: ' + partnerId);

        }

        return null;

    }

    public static Id getPartnerByPartnerKey(String partnerKey) {

        try {

            List<Partner__c> partners = [SELECT Id FROM Partner__c WHERE Partner_Key__c =: partnerKey];

            if(partners.size() == 1) {
                return partners[0].Id;
            }

        }
        catch(Exception e) {

            System.debug('### ERROR - Unable to find partner given key: ' + partnerKey);

        }

        return null;

    }

    /** NA FLEET Fleet Enrollment **/
    public static Id getDefaultAccountTemplateByProgram(Id programId) {

        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id FROM Program_Template_Account__c WHERE Program__c = :programId AND Program_Default__c = TRUE LIMIT 1];

        if (programTemplateAccounts.size() > 0) {
            return programTemplateAccounts[0].Id;
        }

        return null;

    }

    public static Program_Template_Account__c getProgramTemplateAccount(Id programTemplateAccountId) {

        DescribeSObjectResult describeResult = Program_Template_Account__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

        String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Id = :programTemplateAccountId LIMIT 1 ';

        List<Program_Template_Account__c> programTemplateAccounts = Database.query(query);

        if (!programTemplateAccounts.isEmpty()) {
            return programTemplateAccounts[0];
        }

        return null;

    }

    /** Campaign Resolution **/
    public static Campaign_Program__c getDefaultCampaignProgramByProgram(Id programId, String languageCode) {

        DescribeSObjectResult describeResult = Campaign_Program__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

        String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Program__c = :programId AND Default__c = true AND Language_Code__c = :languageCode ' + ' LIMIT 1 ';

        List<Campaign_Program__c> defaultCampaignPrograms = Database.query(query);

        if (defaultCampaignPrograms.isEmpty()) {
            query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Program__c = :programId AND Default__c = true ' + ' LIMIT 1 ';

            defaultCampaignPrograms = Database.query(query);

        }

        if (!defaultCampaignPrograms.isEmpty()) {
            return defaultCampaignPrograms[0];
        }

        return null;

    }

    public static Campaign_Program__c getCampaignProgramByCouponCode(Id programId, String couponCode, String languageCode) {

        List<Campaign> campaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Coupon_Code__c = :couponCode];

        if (!campaigns.isEmpty()) {
            DescribeSObjectResult describeResult = Campaign_Program__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

            String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Program__c = :programId AND Campaign__c = \'' + campaigns[0].Id + '\' AND Language_Code__c = :languageCode ' + ' LIMIT 1 ';

            List<Campaign_Program__c> campaignPrograms = Database.query(query);

            if (campaignPrograms.isEmpty()) {
                query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Program__c = :programId AND Campaign__c = \'' + campaigns[0].Id + '\' LIMIT 1 ';

                campaignPrograms = Database.query(query);
            }

            if (!campaignPrograms.isEmpty()) {
                return campaignPrograms[0];
            }
        }

        return null;

    }

    public static Campaign getCampaignByCampaignProgram(Id campaignProgramId) {

        List<Campaign_Program__c> campaignPrograms = [SELECT Id, Campaign__c FROM Campaign_Program__c WHERE Id =: campaignProgramId LIMIT 1];

        if(campaignPrograms.size() > 0) {

            DescribeSObjectResult describeResult = Campaign.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

            String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Id = \'' + campaignPrograms[0].Campaign__c + '\' LIMIT 1 ';

            List<Campaign> campaigns = Database.query(query);

            if (!campaigns.isEmpty()) {
                return campaigns[0];
            }

        }

        return null;

    }

    public static OnlineApplicationOffer__c getOnlineApplicationOfferById(Id onlineApplicationOfferId) {

        List<OnlineApplicationOffer__c> onlineApplicationOffers = [SELECT Id FROM OnlineApplicationOffer__c WHERE Id =: onlineApplicationOfferId LIMIT 1];

        if(onlineApplicationOffers.size() > 0) {

            DescribeSObjectResult describeResult = OnlineApplicationOffer__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

            String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Id = \'' + onlineApplicationOffers[0].Id + '\' LIMIT 1 ';

            List<OnlineApplicationOffer__c> onlineApplicationOffer = Database.query(query);

            if (!onlineApplicationOffer.isEmpty()) {
                return onlineApplicationOffer[0];
            }

        }

        return null;

    }

    public static OnlineApplicationOffer__c getDefaultOnlineApplicationOfferByProgramId(Id programId) {

        List<OnlineApplicationOffer__c> onlineApplicationOffers = [SELECT Id FROM OnlineApplicationOffer__c WHERE BOCA_Default_Offer__c = true and Program__c =: programId LIMIT 1];

        if(onlineApplicationOffers.size() > 0) {

            DescribeSObjectResult describeResult = OnlineApplicationOffer__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

            String query = ' SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE ' + ' Id = \'' + onlineApplicationOffers[0].Id + '\' LIMIT 1 ';

            List<OnlineApplicationOffer__c> onlineApplicationOffer = Database.query(query);

            if (!onlineApplicationOffer.isEmpty()) {
                return onlineApplicationOffer[0];
            }

        }

        return null;

    }

}