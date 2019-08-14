public class OTRBOCAToProspectComponentController {
    
    public Boolean initialized { get; set; }

    public String bocaToProspectId {
        get;
        set {
            bocaToProspectId = value;
            if(!initialized) {
                init();
                initialized = true;
            }
        } 
    }
    
    public BOCA_To_Prospect__c bocaToProspect { get; set; }

    public User salesRep { get; set; }
    
    public String primaryBrandingCard { get; set; }
    
    public String pgValue {
        get {
            if(bocaToProspect.Disable_PG__c) {
                return 'n';
            }
            else if(bocaToProspect.Always_Require_PG__c) {
                return 'a';
            }
            else {
                return 'c';
            }
        }
    }

    public BOCA_res__c primaryBrandingUtility { get; set; }
    
    public OTRBOCAToProspectComponentController() {
        initialized = false;
    }
    
    public void init() {
        
        List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Online_Application__r.Program__c, Online_Application_Offer__c, Always_Require_PG__c, Disable_PG__c, WeFormObject__c, WeFormObject__r.Program__c, WeFormObject__r.Program__r.BOCA_Type__c, Additional_Programs__c, Custom_Message__c, Contact__r.FirstName, Opportunity__r.Owner.FirstName, Online_Application__r.External_Application_URL__c FROM BOCA_To_Prospect__c WHERE Id = :bocaToProspectId LIMIT 1];
        
        System.debug('### ' + bocaToProspects);
        
        if(bocaToProspects.size() > 0) {
            bocaToProspect = bocaToProspects[0];
            
        }
        
        if(bocaToProspect != null && bocaToProspect.Online_Application__r.Program__c != null) {

            primaryBrandingUtility = WexBrandingController.getBrandingUtility(WexBrandingController.getBrandingUtilityByProgramId(bocaToProspect.Online_Application__r.Program__c, 'en_us'));

            primaryBrandingCard = WexBrandingController.getCreditCardImageId(bocaToProspect.Online_Application__r.Program__c);
            
            salesRep = [SELECT Id, Name, Title, Email, Phone, Fax, Territory_Code__c FROM USER WHERE Id =: bocaToProspect.Opportunity__r.OwnerId];
        }
    }
    
}