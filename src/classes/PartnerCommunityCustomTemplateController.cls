public with sharing class PartnerCommunityCustomTemplateController {
	@AuraEnabled
    public static String getLogoServ()
    {
        return PartnersCommunityLogos__c.getInstance().Filename__c;
    }
}