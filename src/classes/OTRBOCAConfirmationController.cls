public class OTRBOCAConfirmationController {

    public final static String APPLICATION_NAME = 'OTRConfirmation';
    
    // Get all program information
	public Program__c program { get; set; }

    public Campaign campaign { get; set; }

    public OnlineApplication__c onlineApplication { get; set; }
    
    // Get the branding utility
    public BOCA_res__c brandingUtility { get; set; }
    
    public String applicationNumber { get; set; }

    public OnlineApplicationOffer__c offer { get; set; }

    public String creditAppId {
        get {
            return ApexPages.CurrentPage().getParameters().get('id');
        }
    }

    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

    public String customerParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('customer');
        }
    }
    
    public String languageCode {
        get {
            String languageParam = ApexPages.CurrentPage().getParameters().get('lang');
            
            if(languageParam != null) {
                List<BOCA_res__c> brandingUtility = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];
                
                if(brandingUtility.size() > 0) { return languageParam; }
            }
            return 'en_us';
        }
    }
    
    public Boolean savedApplication { 
        get {
            if(ApexPages.CurrentPage().getParameters().get('saved') != null) {
                return true;
            }
            return false;
        }
    }
    
    // Get the branding logo
    public Id brandingLogo { get; set; }
    
    // Get the branding card
    public Id brandingCard { get; set; }

    public Boolean decisioningCompleted { get; set; }

    public Boolean creditApproved { get; set; }

    public Integer creditLineApproved { get; set; }

    public Integer numberOfPolls { get; set; }

    public String completionMessage { get; set; }

    public class creditApplicationException extends Exception { }
    
	public PageReference init() {

        numberOfPolls = 0;
        decisioningCompleted = false;
        creditApproved = false;

        PageReference otrBOCAError = null;

        try {

            if (customerParameter != null) {

                if(UserInfo.getSessionId() != null && !Test.isRunningTest()) {
                    PageReference bocaAttachment = Page.BOCAAttachment;
                    bocaAttachment.getParameters().put('applicationId', customerParameter);
                    bocaAttachment.getParameters().put('pgm', programParameter);
                    return bocaAttachment;
                }

                List<OnlineApplication__c> onlineApplications = [SELECT Id, Name, Offer__c, Program__c, Number_of_Trucks__c, Opportunity__r.Campaign_Program__c FROM OnlineApplication__c WHERE Id =: customerParameter];

                if(onlineApplications.size() > 0) {

                    onlineapplication = onlineApplications[0];

                    program = WexBrandingController.getProgram(onlineApplication.Program__c);

                    offer = WexBrandingController.getOnlineApplicationOfferById(onlineApplication.Offer__c);

                    brandingLogo = WexBrandingController.getLogoId(onlineApplication.Program__c);
                    brandingCard = WexBrandingController.getCreditCardImageId(onlineApplication.Program__c);

                    campaign = WexBrandingController.getCampaignByCampaignProgram(onlineApplication.Opportunity__r.Campaign_Program__c);

                    if(onlineApplication.Number_of_Trucks__c <= 5) {
                        completionMessage = offer.Small_Fleet_Completion_Message__c;
                    }
                    else {
                        completionMessage = offer.Large_Fleet_Completion_Message__c;
                    }

                    applicationNumber = onlineApplication.Name;

                }
                else {
                    throw new creditApplicationException('Unable to find specified application.');
                }

            }
            else {
                throw new creditApplicationException('No customer ID received.');
            }

        }
        catch(Exception e) {

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            otrBOCAError = Page.ExternalApplicationError;
            otrBOCAError.getParameters().put('errorCode', errorNumber);
            if(program != null) {
                otrBOCAError.getParameters().put('pgm', program.Brand_Short_Name__c);
            }
            otrBOCAError.setRedirect(true);
            return otrBOCAError;

        }

        return null;
        
    }

    public PageReference checkStatusOfApplication() {

        numberOfPolls++;

        if(numberOfPolls >= 6) {
            decisioningCompleted = true;
            creditApproved = false;
            return null;
        }

        List<OnlineApplication__c> onlineApplication = [SELECT Id, Credit_Line_Recommendation__c, Credit_Recommendation__c FROM OnlineApplication__c WHERE Id =: customerParameter LIMIT 1];

        if(onlineApplication.size() > 0) {

            if(onlineApplication[0].Credit_Recommendation__c != null && (onlineApplication[0].Credit_Recommendation__c).equalsIgnoreCase('Recommend Approve')) {

                creditApproved = true;
                decisioningCompleted = true;

                creditLineApproved = Integer.valueOf(onlineApplication[0].Credit_Line_Recommendation__c);

            }
           else if(onlineApplication[0].Credit_Recommendation__c != null && !(onlineApplication[0].Credit_Recommendation__c).equalsIgnoreCase('Recommend Approve')) {

                creditApproved = false;
                decisioningCompleted = true;

            }

        }

        return null;

    }
    
}