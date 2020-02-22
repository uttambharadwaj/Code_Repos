/**
*
* Created by mfarrell on 2020-01-16.
*
* Controller for Page - WexBOCAFinancials
*
* Test Class - WexBOCAFinancialsControllerTest
*
* Revision History:
*
**/

public class WexBOCAFinancialsController {

    // get the application id
    public String appId {
        get {
            if (ApexPages.currentPage().getParameters().get('id') != null) {
                return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }

    // Get das program parameter
    public String programParameter {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
        }
    }

    // Get the full URL for the page
    private String applicationURL {
        get {
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = ApexPages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            String[] urlValExtra = urlVal.split('%3F',0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    // Application Objects
    public Application_Request__c appReq { get; set; }

    public WeFormObject__c weFrom { get; set; }

    public FleetEnrollment__c fleetEnrollment { get; set; }

    // sub-class to help facilitate document upload
    public class DocumentType {
        public String fieldName {get; set;}
        public String attachmentName {get; set;}
        public transient Blob attachmentBody {get; set;}
        public Boolean isUploaded { get; set; }
    }

    public List<DocumentType> docTypeList { get; set;}

    // Program for the BOCA
    public Program__c program { get; set; }

    // Language Code for the BOCA
    public String languageCode {
        get {
            if (ApexPages.currentPage().getParameters().get('lang') != null) {
                return ApexPages.currentPage().getParameters().get('lang');
            }
            return null;
        }
    }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    public Id defaultBrandingUtility {
        get {
            List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND BOCA_Default__c = TRUE];

            if(brandingUtilities.isEmpty()) {
                // If we don't get a default branding utility back, just return the first one in the list
                List<BOCA_res__c> defaultBrandingUtility = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id];
                return defaultBrandingUtility[0].Id;
            }
            else {
                // We should always have a default
                return brandingUtilities[0].Id;
            }
        }
    }

    public Boolean requireFinancials {
        get {
            if (program != null) {
                if (program.Require_Financial_Documents__c != null) {
                    return program.Require_Financial_Documents__c;
                }
            }
            return false;
        }
    }

    // get file attachments from application which were added by the existing user
    public List<Attachment> existingAttachments {
        get {
            if(appReq != null) {
                List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE CreatedById =: UserInfo.getUserId() AND ParentId =: appReq.Id];

                if (attachments.size() > 0) {
                    return attachments;
                }
            }
            return null;
        }
    }

    // get number of file attachments for use in determining if we display the file attachments section on the page
    public Integer existingAttachmentsSize {
        get {
            if (existingAttachments != null) {
                return existingAttachments.size();
            } else {
                return 0;
            }
        }
    }

    public Boolean areRequiredDocumentsUploaded {
        get {
            Integer requiredFileCount = docTypeList.size();
            System.debug('requested documents: ' + requiredFileCount);
            Integer uploadedFileCount = 0;

            if (requiredFileCount > 0) {
                for (DocumentType doc : docTypeList) {
                    if (doc.isUploaded != null && doc.isUploaded) {
                        uploadedFileCount++;
                    }
                }
            }

            System.debug ('uploaded file count: ' + uploadedFileCount);

            if (uploadedFileCount >= requiredFileCount) {
                return true;
            } else {
                return false;
            }
        }
    }

    public WexBOCAFinancialsController() {}

    public class creditApplicationException extends Exception {}

    // code for when the page is loaded
    public PageReference init() {
        PageReference wexBOCAError = null;

        if (String.isEmpty(programParameter)) {
            wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '1');
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        } else {
            System.debug(programParameter);
            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

            System.debug('program: ' + programId);

            if(programId != null) {

                program = WexBrandingController.getProgram(programId);
                System.debug('program: ' + program.Name);
                System.debug('language code ' + languageCode);
                Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);
                System.debug('branding utility id: ' + brandingUtilityId);
                if(brandingUtilityId != null) {

                    brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                }

                brandingLogo = WexBrandingController.getLogoId(programId);

                brandingCard = WexBrandingController.getCreditCardImageId(programId);

            }

            System.debug('app id: ' + appId);
            if (!String.isEmpty(appId)) {
                List<WeFormObject__c> weForms = [
                        SELECT Id, Application_Request__c, Program__c, Program__r.Brand_Short_Name__c
                        FROM WeFormObject__c
                        WHERE Id = :appId
                ];

                if (weForms.size() > 0) {
                    weFrom = weForms[0];
                }
                System.debug('weform: ' + weFrom);
                List<Application_Request__c> appReqs = [
                        SELECT Id, Direct_Debit_Form__c, Voided_Check__c, Copy_Of_Driver_s_License__c, Audited_Financials__c
                        FROM Application_Request__c
                        WHERE Id = :weForms[0].Application_Request__c
                ];

                if (appReqs.size() > 0) {
                    appReq = appReqs[0];
                }
                System.debug('app req: ' + appReq);

                List<FleetEnrollment__c> fleetEnrollments = [SELECT Id FROM FleetEnrollment__c WHERE Application_Request__c =: appReqs[0].Id];

                if (fleetEnrollments.size() > 0) {
                    fleetEnrollment = fleetEnrollments[0];
                }

                String configuredDocTypes = program.BOCA_Requested_Financial_Documents__c;
                List<String> documentTypes = new List<String>();
                if (String.isNotEmpty(configuredDocTypes)) {
                    documentTypes = configuredDocTypes.split(';');
                }

                docTypeList = new List<DocumentType>();
                for (String doc : documentTypes) {
                    DocumentType docType = new DocumentType();
                    docType.fieldName = doc;
                    docTypeList.add(docType);
                }
            }
        }
        return null;
    }

    public PageReference uploadFile() {

        for (DocumentType docType : docTypeList) {
            if (docType.attachmentBody != null && docType.attachmentName != null) {

                Attachment applicationAttachment = new Attachment();
                Attachment fleetEnrollmentAttachment = new Attachment();
                System.debug('attachment name: ' + docType.fieldName);

                applicationAttachment.Body = docType.attachmentBody;
                applicationAttachment.Name = docType.fieldName.substring(0, docType.fieldName.length()-3) + ' - ' + docType.attachmentName.replaceAll('[^a-zA-Z0-9_\\-\\.]', '');
                applicationAttachment.ParentId = appReq.Id;

                appReq.put(docType.fieldName, true);
                docType.isUploaded = true;

                try {
                    insert applicationAttachment;
                    if (attachToFleetEnrollment(docType.fieldName) && fleetEnrollment != null) {
                        System.debug('inside attach to fleet enrollment if');
                        fleetEnrollmentAttachment = applicationAttachment.clone();
                        fleetEnrollmentAttachment.ParentId = fleetEnrollment.Id;
                    }
                    if (fleetEnrollmentAttachment != null) insert fleetEnrollmentAttachment;
                }
                catch (Exception e) {
                    System.debug(e);
                }
                finally {
                    applicationAttachment.Body = null;
                    fleetEnrollmentAttachment.Body = null;
                }
            }
        }

        return null;
    }

    public PageReference submitApplication() {
        System.debug('In submitApplication Method');
        System.debug('do we have docs? ' + areRequiredDocumentsUploaded);

        try {

            Database.SaveResult result = Database.update(appReq, false);

            if (result.isSuccess()) {

                PageReference WexBocaConfirmation = Page.WexBOCAConfirmation;
                WexBocaConfirmation.getParameters().put('id', weFrom.Id);
                WexBocaConfirmation.getParameters().put('pgm', weFrom.Program__r.Brand_Short_Name__c);
                WexBocaConfirmation.getParameters().put('lang', languageCode);
                WexBocaConfirmation.setRedirect(true);
                return WexBocaConfirmation;

            } else {
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

    public String logError(Exception e) {
        try {
            External_Application_Error__c error = new External_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCA';
            error.Application_URL__c = applicationURL;

            insert error;

            List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }

        } catch (Exception epicFail) {
            System.debug('we failed to report the error... now we fail silently');

            return '';
        }

    }

    public Boolean attachToFleetEnrollment (String attachmentName) {
        System.debug('inside attach to fleet enrollment method');

        if (attachmentName.containsIgnoreCase('Direct_Debit_Form') || attachmentName.containsIgnoreCase('Voided_Check')) {
            return true;
        }

        return false;
    }
    
}