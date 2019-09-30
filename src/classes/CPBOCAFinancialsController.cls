public without sharing class CPBOCAFinancialsController {

    // Credit application object
    public CP_Application_Request__c creditApp { get; set; }

    public String cpAppId {
        get {
            if(ApexPages.CurrentPage().getParameters().get('id') != null) { return ApexPages.CurrentPage().getParameters().get('id'); }
            return null;
        }
    }

    public String tmSessionId { get; set; }

    public String userSessionId {
        get {
            return UserInfo.getSessionId();
        }
    }

    public class DocumentType {
        public String fieldName {get; set;}
        public String attachmentName {get; set;}
        public transient Blob attachmentBody {get; set;}
    }

    public List<DocumentType> docTypeList { get; set;}

    // Get Template
    public String currentPageName {
        get {
            String strurl = ApexPages.currentPage().getUrl();
            strurl = strurl.replaceFirst('/apex/','');
            strurl = EncodingUtil.urlEncode(strurl, 'UTF-8');
            string[] strurlExtra = strurl.split('%3F',0);
            strurl = strurlExtra[0];

            return strurl;
        }
    }

    // If this is a preview from the Program object
    public Boolean isPreview {
        get {
            if(ApexPages.CurrentPage().getParameters().get('preview') == 'true') {
                return true;
            }
            return false;
        }
    }

    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

    // Get the IP of the applicant for ThreatMetrix
    public String ipAddress {
        get {
            return ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
    }

    // Get the full URL for the page
    private String applicationURL {
        get {
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            string[] urlValExtra = urlVal.split('%3F',0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    private String applicationViewState {
        get {
            return Apexpages.currentPage().getUrl();
        }
    }

    // Program for the BOCA
    public Program__c program { get; set; }

    // Language Code for the BOCA
    public String languageCode { get; set; }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    public Id defaultBrandingUtility {
        get {
            List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_Res__c WHERE Program__c = :program.Id and BOCA_Default__c = true];

            if(brandingUtilities.isEmpty()) {
                // If we don't get a default branding utility back, just return the first one in the list
                // This is for backwards compatability until we get the new field in place..
                List<BOCA_res__c> defaultBrandingUtility = [SELECT Id FROM BOCA_Res__c WHERE Program__c = :program.Id];
                return defaultBrandingUtility[0].Id;
            }
            else {
                // We should always have a default
                return brandingUtilities[0].Id;
            }
        }
    }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    // Campaign for the BOCA if a coupon code is used
    public Campaign campaign { get; set; }

    // Campaign program for the BOCA if a coupon code is used
    public Campaign_Program__c campaignProgram { get; set; }

    // Sales rep information if BOCA to Prospect
    public User salesRep { get; set; }

    // Pagination variables for tracking the steps
    public Integer currentStep { get; set; }
    public Integer minStep  { get; set; }
    public Integer maxStep  { get; set; }

    public CPBOCAFinancialsController() {
    }

    public PageReference init() {

        PageReference wexBOCAError = null;

        if(String.isEmpty(programParameter)) {
            wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '1');
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        }
        else {
            system.debug(programParameter);
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


            if(!String.isEmpty(cpAppId) ) {

                List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, Stock_Symbol__c, Stock_Exchange__c, Financial_Statement_Type__c, Financials_Completed_For__c, Country_of_Contacting_Entity__c,
                        Country_of_Contracting_Entity_Other__c, Direct_Debit_Form__c, Voided_Check__c, Copy_of_Driver_s_License__c, Audited_Financials__c, Account__c  FROM CP_Application_Request__c WHERE Id =: cpAppId];

                if(cpApplicationRequests.size() > 0) {

                    creditApp = cpApplicationRequests[0];

                }

                String configuredDocTypes = program.CP_BOCA_Financials_Needed__c;
                List<String> documentTypes = new List<String>();
                if (String.isNotEmpty(configuredDocTypes)) {
                    documentTypes = configuredDocTypes.split(';');
                }

                docTypeList = new List<DocumentType>();
                for (String doc : documentTypes) {
                    DocumentType docType = new DocumentType();
                    docType.fieldName = doc;
                    creditApp.put(doc, true);
                    docTypeList.add(docType);
                }
            }
        }

        return null;

    }

    public class creditApplicationException extends Exception {}

    public void clearContractingEntityCountry() {
        creditApp.Country_of_Contacting_Entity__c = '';
    }

    public void clearContractingEntityCountryOther() {
        creditApp.Country_of_Contracting_Entity_Other__c = '';
    }

    public List<SelectOption> stockExchangeList {
        get {
            List<SelectOption> optionsList = new List<SelectOption>();

            optionsList.add(new SelectOption('', '--Choose One--'));

            List<Schema.PicklistEntry> picklistEntries = CP_Application_Request__c.Stock_Exchange__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry picklistValue : picklistEntries){ optionsList.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel())); }
            return optionsList;
        }
    }

    public List<SelectOption> statementTypeList {
        get {
            List<SelectOption> optionsList = new List<SelectOption>();

            optionsList.add(new SelectOption('', '--Choose One--'));

            List<Schema.PicklistEntry> picklistEntries = CP_Application_Request__c.Financial_Statement_Type__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry picklistValue : picklistEntries){ optionsList.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel())); }
            return optionsList;
        }
    }

    public List<SelectOption> financialsCompletedForList {
        get {
            List<SelectOption> optionsList = new List<SelectOption>();

            optionsList.add(new SelectOption('', '--Choose One--'));

            List<Schema.PicklistEntry> picklistEntries = CP_Application_Request__c.Financials_Completed_For__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry picklistValue : picklistEntries){ optionsList.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel())); }
            return optionsList;
        }
    }

    public List<SelectOption> contractingEntityCountryList {
        get {
            List<SelectOption> optionsList = new List<SelectOption>();

            optionsList.add(new SelectOption('', '--Choose One--'));

            List<Schema.PicklistEntry> picklistEntries = CP_Application_Request__c.Country_of_Contacting_Entity__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry picklistValue : picklistEntries){ optionsList.add(new SelectOption(picklistValue.getValue(), picklistValue.getLabel())); }
            return optionsList;
        }
    }


    public PageReference submitApplication() {

        System.debug('in SubmitApplication method');

        try {
            System.debug('The credit application: ' + creditApp);

            Database.SaveResult result = Database.update(creditApp, false);
            System.debug('attempted to update, result was successful: ' + result.isSuccess());
            if(result.isSuccess()){
                Id creditAppId = result.getId();

                if (creditApp.Account__c!=null) {
                    Account acc = new Account(Id = creditApp.Account__c);
                    acc.TickerSymbol = creditApp.Stock_Symbol__c;
                    update acc;
                }

                System.debug('Credit App Id: ' + creditAppId);

                PageReference cpBOCAConfirmation = Page.CPBOCAConfirmation;
                CPBOCAConfirmation.getParameters().put('pgm', programParameter);
                CPBOCAConfirmation.getParameters().put('id', creditAppId);
                CPBOCAConfirmation.getParameters().put('lang', languageCode);
                CPBOCAConfirmation.setRedirect(true);
                return cpBOCAConfirmation;
            }
            else {
                throw new creditApplicationException('Critical error updating the Credit Application: ' + String.valueOf(result.getErrors()));
            }
        } catch (Exception e) {
            System.debug('Exception Encountered Submitting Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = logError(e);

            PageReference wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '2');
            wexBOCAError.getParameters().put('errorReferenceNumber', errorNumber);
            wexBOCAError.getParameters().put('pgm', programParameter);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        }
    }

    public PageReference uploadFile() {

        for (DocumentType docType : docTypeList) {
            Boolean fieldChecked = (Boolean) creditApp.get(docType.fieldName);
            if (docType.attachmentBody != null && docType.attachmentName != null && fieldChecked==true) {

                Attachment applicationAttachment = new Attachment();

                applicationAttachment.Body = docType.attachmentBody;
                applicationAttachment.Name = docType.attachmentName;
                applicationAttachment.ParentId = cpAppId;

                try {
                    insert applicationAttachment;
                }
                catch (Exception e) {
                    System.debug(e);
                }
                finally {
                    applicationAttachment.Body = null;
                }
            }
        }

        return null;
    }

    public String logError(Exception e) {
        try {
            External_Application_Error__c error = new External_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCA';
            error.Application_URL__c = applicationURL;
            error.Application_View_State__c = maskViewState(applicationViewState);

            insert error;

            List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }
        }
        catch(Exception f) {
            System.debug('Error logging exception.. Skipping..');

            return '';
        }
    }

    // This function will mask PII to ensure it's not stored in this table
    private String maskViewState(String viewState) {

        // Remove TaxPayer ID
        viewState = viewState.replaceAll('taxpayerId=(\\d{9})', 'taxpayerId=#REDACTED#');

        // Remove SSN
        viewState = viewState.replaceAll('pgSSN=(\\d{3}-\\d{2}-\\d{4})', 'pgSSN=#REDACTED#');

        // Remove DOB
        viewState = viewState.replaceAll('pgDateOfBirth=(\\d{2}%2F\\d{2}%2F\\d{4})', 'pgDOB=#REDACTED#');

        return viewState;

    }
}