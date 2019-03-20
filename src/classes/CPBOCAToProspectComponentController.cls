public class CPBOCAToProspectComponentController {

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

    public CP_Application_Request__c cpApplicationRequest { get; set; }

    public User salesRep { get; set; }

    public Id programId {
        get {
            if(bocaToProspect != null) {
                return bocaToProspect.CorporatePayments_Application_Request__r.Program__c;
            }
            return null;
        }
    }

    public String primaryBrandingCard { get; set; }

    public BOCA_res__c primaryBrandingUtility { get; set; }

    public String primaryURL {
        get {
            return 'https://' + Label.External_Instance_URL + '/creditapplication/' + primaryBrandingUtility.Program__r.Form_Template__c + '?pgm=' + primaryBrandingUtility.Program__r.Brand_Short_Name__c + '&customer=' + cpApplicationRequest.Id;
        }
    }

    public String primaryLearnMoreURL {
        get {
            if(cpApplicationRequest.Program__c != null && cpApplicationRequest.Program__r.BOCA_Sell_Sheet__c != null) {
                return 'https://' + Label.External_Instance_URL + '/creditapplication/BocaToProspectTracking?customer=' + cpApplicationRequest.Id + '&action=learnMore';
            }
            return null;
        }
    }

    public CPBOCAToProspectComponentController() {
        initialized = false;
    }

    public void init() {

        List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Always_Require_PG__c, Disable_PG__c, CorporatePayments_Application_Request__c, CorporatePayments_Application_Request__r.Program__c, CorporatePayments_Application_Request__r.Program__r.BOCA_Type__c, Additional_Programs__c, Custom_Message__c, Contact__r.FirstName, Opportunity__r.Owner.FirstName FROM BOCA_To_Prospect__c WHERE Id = :bocaToProspectId LIMIT 1];

        System.debug('### ' + bocaToProspects);

        if(bocaToProspects.size() > 0) {
            bocaToProspect = bocaToProspects[0];

        }

        if(bocaToProspect != null && programId != null) {

            List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c, Program__r.BOCA_Sell_Sheet__c FROM CP_Application_Request__c WHERE Id = :bocaToProspect.CorporatePayments_Application_Request__c LIMIT 1];

            if(cpApplicationRequests.size() > 0) {
                cpApplicationRequest = cpApplicationRequests[0];
            }

            List<BOCA_res__c> brandingUtilities = [SELECT Id, Program_Name__c, Primary_Program_Benefits__c, Secondary_Program_Benefits__c, Program__r.Form_Template__c, Program__r.Brand_Short_Name__c FROM BOCA_res__c WHERE Program__c =: programId and (ISO_code__c = 'en_us' or ISO_code__c = 'en_ca') LIMIT 1];

            if(brandingUtilities.size() > 0) {
                primaryBrandingUtility = brandingUtilities[0];
            }

            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = 'ui-credit-card.png'];

            if(card != null) {
                primaryBrandingCard = card.Id;
            }

            salesRep = [SELECT Id, Name, Title, Email, Phone, Fax FROM USER WHERE Id =: bocaToProspect.Opportunity__r.OwnerId];
        }
    }

}