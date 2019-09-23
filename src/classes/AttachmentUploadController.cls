public with sharing class AttachmentUploadController {

    public final static String APPLICATION_NAME = 'AttachmentUploader';

    public String confirmUpload {
        get {
            return ApexPages.CurrentPage().getParameters().get('confirmUpload');
        }
    }

    public String parentRecordId {
        get {
            return ApexPages.CurrentPage().getParameters().get('parentRecordId');
        }
    }

    public String parentRecordType {
        get {
            if(parentRecordId != null) {
                return (Id.valueOf(parentRecordId)).getSobjectType().getDescribe().getLabel();
            }
            return null;
        }
    }

    public String recordName {
        get {
            if(parentRecordId != null) {
                SObject record = Database.query('SELECT Name FROM ' + (Id.valueOf(parentRecordId)).getSobjectType().getDescribe().getName() + ' WHERE Id = :parentRecordId');

                return String.valueOf(record.get('Name'));
            }
            return null;
        }
    }

    public String attachmentName { get; set; }

    public Blob attachmentBody { get; set; }

    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }

    public AttachmentUploadController() {

    }

    public void init() {

        if(confirmUpload != null && !String.isEmpty(confirmUpload)) {

            if(confirmUpload.equals('true')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Attachment Uploaded!'));
            }
            else {
                String errorCode = ApexPages.CurrentPage().getParameters().get('errorCode');

                if(errorCode != null) {
                    List<Internal_Application_Error__c> error = [SELECT Id, Error_Message__c FROM Internal_Application_Error__c WHERE Name =: errorCode];

                    String errorCodeDescription = 'General Fault';

                    if(error.size() > 0) {
                        errorCodeDescription = error[0].Error_Message__c;
                    }

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorCodeDescription + '  <br><br>The support organization has been notified. Your error tracking number is: ' + errorCode));
                }

            }

        }
        else {

        }

    }

    public PageReference uploadFile() {

        if(attachmentName != null && attachmentBody != null) {

            Attachment applicationAttachment = new Attachment();

            applicationAttachment.Body = attachmentBody;
            applicationAttachment.Name = attachmentName;
            applicationAttachment.ParentId = parentRecordId;

            try {
                insert applicationAttachment;

                PageReference refresh = Page.AttachmentUpload;
                refresh.getParameters().put('confirmUpload', 'true');
                refresh.getParameters().put('parentRecordId', parentRecordId);
                refresh.setRedirect(true);
                return refresh;
            }
            catch (Exception e) {
                String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), UserInfo.getUserId(), e);

                PageReference error = Page.AttachmentUpload;
                error.getParameters().put('confirmUpload', 'false');
                error.getParameters().put('errorCode', errorCode);
                return error;
            }

        }

        return null;

    }

}