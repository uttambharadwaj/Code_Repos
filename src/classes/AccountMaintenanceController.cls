public class AccountMaintenanceController {

    public String languageCode { get; set; }
    
    public Id brandingLogo { get; set; }
    
    public BOCA_res__c brandingUtility { get; set; }

    public Program__c program { get; set; }
    
    public String recordId {
        get {
            return ApexPages.currentPage().getParameters().get('recordId');
        }
    }
    
    public String key {
        get {
            return ApexPages.currentPage().getParameters().get('key');
        }
    }
    
    public Boolean isBroken { get; set; }
    
    public String didLength { get; set; }
    
    public void init() {
        
        isBroken = false;
        
        if(!String.isEmpty(recordId)) {
            
            if(!String.isEmpty(ApexPages.CurrentPage().getParameters().get('lang'))) {
            	languageCode = (ApexPages.CurrentPage().getParameters().get('lang')).toLowerCase();
            }
            if(String.isEmpty(languageCode)) {
                languageCode = 'en_us';
            }
            
            List<Case> cases = [SELECT Id, Account.Program__c FROM Case WHERE Id =: recordId and Secondary_Key__c =: key];
            
            if(cases.size() > 0) {
                
                program = WexBrandingController.getProgram(cases[0].Account.Program__c);
                
                if(program == null) {
                    didLength = '4';
                }
                else {
                    didLength = program.DID_Length__c;
                }
                
                Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(cases[0].Account.Program__c, languageCode);

                if(brandingUtilityId != null) {

                    brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                }
                
                brandingLogo = WexBrandingController.getLogoId(cases[0].Account.Program__c);
                
            }
            else {
                isBroken = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find record.')); 
            }
            
        }
        
    }
    
}