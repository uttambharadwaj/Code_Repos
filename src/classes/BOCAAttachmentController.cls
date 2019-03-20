public class BOCAAttachmentController {

    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

    public String applicationId {
        get {
            return ApexPages.CurrentPage().getParameters().get('applicationId');
        }
    }

    public String selectedFile {
        get {
            return ApexPages.CurrentPage().getParameters().get('selectedFile');
        }
        set;
    }

    public String attachmentName { get; set; }

    public Blob attachmentBody { get; set; }

    // Program for the BOCA
    public Program__c program { get; set; }

    // Language Code for the BOCA
    public String languageCode { get; set; }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    public List<Attachment> existingAttachments {
        get {
            if(UserInfo.getSessionId() != null && applicationId != null) {
                List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE CreatedById =: UserInfo.getUserId() and ParentId =: applicationId];

                return attachments;
            }
            return null;
        }
    }

    public Integer existingAttachmentsSize {
        get {
            return existingAttachments.size();
        }
    }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    public BOCAAttachmentController() {

        languageCode = 'en_us';

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

        return null;

    }

    public PageReference deleteFile() {

        if(selectedFile != null) {

            List<Attachment> selectedAttachment = [SELECT Id, Name FROM Attachment WHERE CreatedById =: UserInfo.getUserId() and ParentId =: applicationId and Id =: selectedFile];

            if(selectedAttachment.size() == 1) {

                delete selectedAttachment;

            }

        }

        PageReference refresh = Page.BOCAAttachment;
        refresh.getParameters().put('pgm', programParameter);
        refresh.getParameters().put('applicationId', applicationId);
        refresh.setRedirect(true);
        return refresh;

    }

    public PageReference uploadFile() {

        if(attachmentName != null && attachmentBody != null) {

            Attachment applicationAttachment = new Attachment();

            applicationAttachment.Body = attachmentBody;
            applicationAttachment.Name = attachmentName;
            applicationAttachment.ParentId = applicationId;

            try {
                insert applicationAttachment;

                PageReference refresh = Page.BOCAAttachment;
                refresh.getParameters().put('pgm', programParameter);
                refresh.getParameters().put('applicationId', applicationId);
                refresh.setRedirect(true);
                return refresh;
            }
            catch (Exception e) {
                System.debug(e);
            }
            finally {
                applicationAttachment.Body = null;
            }
        }

        return null;

    }

}