public class CPBOCAConfirmationController {

    public CP_Application_Request__c creditApp { get; set; }
    
    public Program__c program { get; set; }
    
    public BOCA_res__c brandingUtility { get; set; }
    
    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }
    
    public String creditAppId {
        get {
            return ApexPages.CurrentPage().getParameters().get('id');
        }
    }
    
    public String languageCode {
        get {
            if(ApexPages.CurrentPage().getParameters().get('lang') != null) {
                return ApexPages.CurrentPage().getParameters().get('lang');
            }
            return 'en_us';
        }
    }
    
    // Get the branding logo
    public Id brandingLogo { get; set; }
    
    // Get the branding card
    public Id brandingCard { get; set; }
    
	public PageReference init() {
        
        if(programParameter != null) {

            if(UserInfo.getSessionId() != null && !TestUtils.isRunningTest()) {
                PageReference bocaAttachment = Page.BOCAAttachment;
                bocaAttachment.getParameters().put('pgm', programParameter);
                bocaAttachment.getParameters().put('applicationId', creditAppId);
                return bocaAttachment;
            }

            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);
            
            if(programId != null) {
                
                program = WexBrandingController.getProgram(programId);
                
                Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);
                
                if(brandingUtilityId != null) {
                
                	brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);
                    
                }
                
                brandingLogo = WexBrandingController.getLogoId(programId);
                
                brandingCard = WexBrandingController.getCreditCardImageId(programId);
                
            }
            
        }
        
        if(creditAppId != null) {
            
            List<CP_Application_Request__c> creditApps = [SELECT Id, Confirmation_Number__c FROM CP_Application_Request__c WHERE Id =: creditAppId];
            
            if(creditApps.size() == 1) {
                
                creditApp = creditApps[0];
                
            }
            
        }

        return null;
        
    }
    
}