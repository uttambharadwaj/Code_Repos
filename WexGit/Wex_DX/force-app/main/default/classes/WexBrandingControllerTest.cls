@isTest(seeAllData=True)
public class WexBrandingControllerTest {
    
    static testMethod void testBrandingControler() {
        
        Id programId = WexBrandingController.getProgramIdByBrandShortName('Edge');
        
        Program__c program = WexBrandingController.getProgram(programId);
        
        Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, 'en_us');
        
        WexBrandingController.getBrandingUtility(brandingUtilityId);
        
        WexBrandingController.getAvailableLanguages(programId);
        
        WexBrandingController.getLogoId(programId);
        
        WexBrandingController.getCreditCardImageId(programId);
        
        WexBrandingController.getCreditCardNotTextImageId(programId);
        
        WexBrandingController.getBPAVLogoId(programId);
        
        WexBrandingController.getPartnerLogoId(null);
        
        WexBrandingController.getPartnerByPartnerKey(null);
        
        Id programTemplateAccountId = WexBrandingController.getDefaultAccountTemplateByProgram(programId);
        
        WexBrandingController.getProgramTemplateAccount(programTemplateAccountId);
        
        WexBrandingController.getDefaultCampaignProgramByProgram(programId, 'en_us');
        
        Campaign_Program__c campaignProgram = WexBrandingController.getCampaignProgramByCouponCode(programId, null, 'en_us');
        
        if(campaignProgram != null) {
        
        	WexBrandingController.getCampaignByCampaignProgram(campaignProgram.Id);
            
        }
        
        OnlineApplicationOffer__c offer = WexBrandingController.getDefaultOnlineApplicationOfferByProgramId(programId);
        
        WexBrandingController.getOnlineApplicationOfferById(offer.Id);  
        
    }
    
}