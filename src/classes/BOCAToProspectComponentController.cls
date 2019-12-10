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

                    List<BOCA_res__c> brandingUtilities = [SELECT Id, BOCA_Default__c, Program__c, Program__r.BOCA_Type__c, Program__r.Partner__r.Default_DM_Flex_Code__c, Program__r.Partner__r.Default_DM_Fuel_Code__c, Program__r.Brand_Short_Name__c, Program__r.Form_Template__c, Program_Name__c, Primary_Program_Benefits__c, Secondary_Program_Benefits__c, ISO_code__c FROM BOCA_res__c WHERE Program__c =: additionalProgram ];

                    if(brandingUtilities.size() > 0) {
                        BOCA_res__c brandingUtility = getBrandingUtilityFromList(brandingUtilities);
                        SecondaryProgram secondaryProgram = new SecondaryProgram();
                        
                        String couponCode = weFormObject.Promotional_Code__c;

                        if(bocaToProspect.WeFormObject__r.Program__r.BOCA_Type__c != null && !(bocaToProspect.WeFormObject__r.Program__r.BOCA_Type__c).equalsIgnoreCase(brandingUtility.Program__r.BOCA_Type__c)) {
                        	if((brandingUtility.Program__r.BOCA_Type__c).equalsIgnoreCase('Revolver Card') && brandingUtility.Program__r.Partner__r.Default_DM_Flex_Code__c != null) {
	                    		couponCode = brandingUtility.Program__r.Partner__r.Default_DM_Flex_Code__c;
                       		}
                        	else if((brandingUtility.Program__r.BOCA_Type__c).equalsIgnoreCase('Fuel Card') && brandingUtility.Program__r.Partner__r.Default_DM_Fuel_Code__c != null) {
                           		couponCode = brandingUtility.Program__r.Partner__r.Default_DM_Fuel_Code__c;
                        	}
                        }
                        
                        secondaryProgram.name = brandingUtility.Program_Name__c;
                        secondaryProgram.benefits = brandingUtility.Secondary_Program_Benefits__c;
                        secondaryProgram.bocaURL = 'https://' + Label.External_Instance_URL + '/creditapplication/' + brandingUtility.Program__r.Form_Template__c + '?pgm=' + brandingUtility.Program__r.Brand_Short_Name__c + '&priority=true&customer=' + weFormObject.Id + '&salescode=' + weFormObject.Sales_Id__c + '&cc=' + couponCode + '&pg=' + pgValue + '&lang=' + languageCode;
                        
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
            return 'https://' + Label.External_Instance_URL + '/creditapplication/' + primaryBrandingUtility.Program__r.Form_Template__c + '?pgm=' + primaryBrandingUtility.Program__r.Brand_Short_Name__c + '&priority=true&customer=' + weFormObject.Id + '&salescode=' + weFormObject.Sales_Id__c + '&cc=' + weFormObject.Promotional_Code__c + '&pg=' + pgValue + '&lang=' + languageCode + '&utm_medium=sales&utm_source=b2p%20link';
        }
    }

    public String languageCode {
        get {
            if (weFormObject.Branding_Utility__c != null) {
                return weFormObject.Branding_Utility__r.ISO_Code__c;
            }
            return null;
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

    private BOCA_res__c getBrandingUtilityFromList(List<BOCA_res__c> brandingUtilities) {

        Map<String, BOCA_res__c> brandingUtilityLanguageMap = new Map<String, BOCA_res__c>(); // Language Code, BOCA_res__c
        BOCA_res__c defaultBrandingUtility;

        for (BOCA_res__c brandingUtility : brandingUtilities) {

            if (brandingUtilityLanguageMap.get(brandingUtility.ISO_code__c) == null) brandingUtilityLanguageMap.put(brandingUtility.ISO_code__c, brandingUtility);
            if (brandingUtility.BOCA_Default__c) defaultBrandingUtility = brandingUtility;

        }

        if (languageCode != null && brandingUtilityLanguageMap.get(languageCode) != null) return brandingUtilityLanguageMap.get(languageCode);
        else if (defaultBrandingUtility != null) return defaultBrandingUtility;
        else return brandingUtilities[0];


    }
    
    public void init() {

        List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Always_Require_PG__c, Disable_PG__c, WeFormObject__c, WeFormObject__r.Program__c, WeFormObject__r.Program__r.BOCA_Type__c, WeFormObject__r.Branding_Utility__c, Additional_Programs__c, Custom_Message__c, Contact__r.FirstName, Opportunity__r.Owner.FirstName FROM BOCA_To_Prospect__c WHERE Id = :bocaToProspectId LIMIT 1];
        System.debug('### ' + bocaToProspects);
        
        if(bocaToProspects.size() > 0) {
            bocaToProspect = bocaToProspects[0];
            
        }
        
        if(bocaToProspect != null && programId != null) {
            
            List<WeFormObject__c> weFormObjects = [SELECT Id, Branding_Utility__r.ISO_Code__c, Opportunity__r.Campaign_Response_Methods__c, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c, Program__r.BOCA_Sell_Sheet__c, Sales_Id__c, Promotional_Code__c FROM WeFormObject__c WHERE Id = :bocaToProspect.WeFormObject__c LIMIT 1];
            
            if(weFormObjects.size() > 0) {
                weFormObject = weFormObjects[0];
            }

            List<BOCA_res__c> brandingUtilities = [SELECT Id, BOCA_Default__c, Program_Name__c, Primary_Program_Benefits__c, Secondary_Program_Benefits__c, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c, ISO_Code__c FROM BOCA_res__c WHERE Program__c = :programId ];

            if (brandingUtilities.size() > 0) {
                primaryBrandingUtility = getBrandingUtilityFromList(brandingUtilities);
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