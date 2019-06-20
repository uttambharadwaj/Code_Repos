public class PB2PComponentController {

    public Boolean initialized { get; set; }

    public String partnerBOCAToProspectId {
        get;
        set {
            partnerBOCAToProspectId = value;
            if(!initialized) {
                init();
                initialized = true;
            }
        }
    }

    public Partner_BOCA_To_Prospect__c partnerBOCAToProspect { get; set; }

    public WeFormObject__c weFormObject { get; set; }

    public Id programId {
        get {
            if(partnerBOCAToProspect != null) {
                return Id.valueOf(partnerBOCAToProspect.Program__c);
            }
            return null;
        }
    }

    public Id brandingCard { get; set; }

    public Program__c program { get; set; }

    public BOCA_res__c brandingUtility { get; set; }

    public PB2PComponentController() {
        initialized = false;
    }

    public void init() {

        List<Partner_BOCA_To_Prospect__c> partnerBOCAToProspects = [SELECT Id, First_Name__c, Sales_Rep_First_Name__c, Sales_Rep_Last_Name__c, Sales_Rep_Phone__c, Sales_Rep_Email__c, Program__c, Online_Application__c, Online_Application_Offer__c, Online_Application__r.External_Application_URL__c, External_Application_URL__c FROM Partner_BOCA_To_Prospect__c WHERE Id =: partnerBOCAToProspectId];

        if(partnerBOCAToProspects.size() > 0) {

            partnerBOCAToProspect = partnerBOCAToProspects[0];

            program = WexBrandingController.getProgram(partnerBOCAToProspect.Program__c);

            Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(partnerBOCAToProspect.Program__c, 'en_us');

            if(brandingUtilityId != null) {
                brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);
            }

            brandingCard = WexBrandingController.getCreditCardImageId(program.Id);

        }

    }

    public static String buildApplicationParameterString(Map<String, String> parameters) {

        List<String> joinedParameters = new List<String>();

        for(String key : parameters.keySet()) {

            if(parameters.get(key) != null) {

                joinedParameters.add(key + '=' + EncodingUtil.urlEncode(parameters.get(key), 'UTF-8'));

            }

        }

        return String.join(joinedParameters, '&');

    }

}