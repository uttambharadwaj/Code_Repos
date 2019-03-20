public class BOCAToProspectComponentController {
    
    public Boolean initialized { get; set; }
    
    // https://salesforce.stackexchange.com/a/9946
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
    
    public WeFormObject__c weFormObject { get; set; }
    
    public User salesRep { get; set; }
    
    public Id programId { 
        get {
            if(bocaToProspect != null) {
                return bocaToProspect.WeFormObject__r.Program__c;
            }
            return null;
        }
    }
    
    public String primaryBrandingCard { get; set; }
    
    public Integer secondaryProgramSize {
        get {
            return secondaryPrograms.size();
        }
    }
    
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
    
    public List<SecondaryProgram> secondaryPrograms { 
        get {
            
            List<SecondaryProgram> secondaryPrograms = new List<SecondaryProgram>();
            
            System.debug('### ' + bocaToProspect.Additional_Programs__c);
            
            if(bocaToProspect != null && bocaToProspect.Additional_Programs__c != null) {
                
                List<String> additionalPrograms = (List<String>)JSON.deserialize(bocaToProspect.Additional_Programs__c, List<String>.class);
                
                for(String additionalProgram : additionalPrograms) {
                    
                    List<BOCA_res__c> brandingUtilities = [SELECT Id, Program__c, Program__r.BOCA_Type__c, Program__r.Partner__r.Default_DM_Flex_Code__c, Program__r.Partner__r.Default_DM_Fuel_Code__c, Program__r.Brand_Short_Name__c, Program__r.Form_Template__c, Program_Name__c, Primary_Program_Benefits__c, Secondary_Program_Benefits__c FROM BOCA_res__c WHERE Program__c =: additionalProgram and ISO_code__c = 'en_us' LIMIT 1];
                    
                    if(brandingUtilities.size() > 0) {
                        
                        SecondaryProgram secondaryProgram = new SecondaryProgram();
                        
                        String couponCode = weFormObject.Promotional_Code__c;

                        if(bocaToProspect.WeFormObject__r.Program__r.BOCA_Type__c != null && !(bocaToProspect.WeFormObject__r.Program__r.BOCA_Type__c).equalsIgnoreCase(brandingUtilities[0].Program__r.BOCA_Type__c)) {
                        	if((brandingUtilities[0].Program__r.BOCA_Type__c).equalsIgnoreCase('Revolver Card') && brandingUtilities[0].Program__r.Partner__r.Default_DM_Flex_Code__c != null) {
	                    		couponCode = brandingUtilities[0].Program__r.Partner__r.Default_DM_Flex_Code__c;
                       		}
                        	else if((brandingUtilities[0].Program__r.BOCA_Type__c).equalsIgnoreCase('Fuel Card') && brandingUtilities[0].Program__r.Partner__r.Default_DM_Fuel_Code__c != null) {
                           		couponCode = brandingUtilities[0].Program__r.Partner__r.Default_DM_Fuel_Code__c;
                        	}
                        }
                        
                        secondaryProgram.name = brandingUtilities[0].Program_Name__c;
                        secondaryProgram.benefits = brandingUtilities[0].Secondary_Program_Benefits__c;
                        secondaryProgram.bocaURL = 'https://' + Label.External_Instance_URL + '/creditapplication/' + brandingUtilities[0].Program__r.Form_Template__c + '?pgm=' + brandingUtilities[0].Program__r.Brand_Short_Name__c + '&priority=true&customer=' + weFormObject.Id + '&salescode=' + weFormObject.Sales_Id__c + '&cc=' + couponCode + '&pg=' + pgValue;
                        
                        transient Attachment secondaryBrandingCard = [SELECT Id, Name, Body FROM Attachment where ParentId = :additionalProgram AND Name = 'ui-credit-card.png'];
                        
                        secondaryProgram.brandingCard = secondaryBrandingCard.Id;
                        
                        secondaryPrograms.add(secondaryProgram);
                        
                    }
                    
                }
                
            }
            
            System.debug(secondaryPrograms);
            
            return secondaryPrograms;
        }
    }
    
    public Boolean displayAssetsLinks {
        get {
            Set<String> profileNames = new Set<String>{'Field Sales', 'Regional Sales Manager (West)', 'Regional Sales Manager (East) '};

            if(salesRep != null && salesRep.UserRole.Name != null && profileNames.contains(salesRep.UserRole.Name)) {
                return false;
            }
            return true;
        }
    }
    
    public BOCA_res__c primaryBrandingUtility { get; set; }
    
    public String primaryURL {
        get {
            return 'https://' + Label.External_Instance_URL + '/creditapplication/' + primaryBrandingUtility.Program__r.Form_Template__c + '?pgm=' + primaryBrandingUtility.Program__r.Brand_Short_Name__c + '&priority=true&customer=' + weFormObject.Id + '&salescode=' + weFormObject.Sales_Id__c + '&cc=' + weFormObject.Promotional_Code__c + '&pg=' + pgValue;
        }
    }
    
    public String primaryLearnMoreURL {
        get {
            if(weFormObject.Program__c != null && weFormObject.Program__r.BOCA_Sell_Sheet__c != null) {
            	return 'https://' + Label.External_Instance_URL + '/creditapplication/BocaToProspectTracking?customer=' + weFormObject.Id + '&action=learnMore';
            }
            return null;
        }
    }
    
    public BOCAToProspectComponentController() {
        initialized = false;
    }
    
    public void init() {
        
        List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Always_Require_PG__c, Disable_PG__c, WeFormObject__c, WeFormObject__r.Program__c, WeFormObject__r.Program__r.BOCA_Type__c, Additional_Programs__c, Custom_Message__c, Contact__r.FirstName, Opportunity__r.Owner.FirstName FROM BOCA_To_Prospect__c WHERE Id = :bocaToProspectId LIMIT 1];
        
        System.debug('### ' + bocaToProspects);
        
        if(bocaToProspects.size() > 0) {
            bocaToProspect = bocaToProspects[0];
            
        }
        
        if(bocaToProspect != null && programId != null) {
            
            List<WeFormObject__c> weFormObjects = [SELECT Id, Opportunity__r.Campaign_Response_Methods__c, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c, Program__r.BOCA_Sell_Sheet__c, Sales_Id__c, Promotional_Code__c FROM WeFormObject__c WHERE Id = :bocaToProspect.WeFormObject__c LIMIT 1];
            
            if(weFormObjects.size() > 0) {
                weFormObject = weFormObjects[0];
            }
            
            List<BOCA_res__c> brandingUtilities = [SELECT Id, Program_Name__c, Primary_Program_Benefits__c, Secondary_Program_Benefits__c, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c FROM BOCA_res__c WHERE Program__c =: programId and (ISO_code__c = 'en_us' or ISO_code__c = 'en_ca') LIMIT 1];
            
            if(brandingUtilities.size() > 0) {
                primaryBrandingUtility = brandingUtilities[0];
            }
            
            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = 'ui-credit-card.png'];
            
            if(card != null) {
                primaryBrandingCard = card.Id;
            }
            
            salesRep = [SELECT Id, Name, Title, Email, Phone, Fax, UserRole.Name FROM USER WHERE Id =: bocaToProspect.Opportunity__r.OwnerId];
        }
    }
    
    public class SecondaryProgram {
        
        public String name { get; set; }
        public String benefits { get; set; }
        public String brandingCard { get; set; }
        public String bocaURL { get; set; }
        
    }
    
}