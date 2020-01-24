/**
 * Created by lhowland on 1/2/2020.
 */

public class UploadDocToCreditLensController {

    public Id appId {
        get {
            if (ApexPages.currentPage().getParameters().get('id') != null) {
                return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }

    public Boolean uploadSuccess {
        get {
            if (ApexPages.CurrentPage().getParameters().get('uploadStatus') == 'true') {
                return true;
            }
            return false;
        }

        set;
    }

    public String errorMessage {
        get {
            if (ApexPages.currentPage().getParameters().get('errorMessage') != null) {
                return ApexPages.currentPage().getParameters().get('errorMessage');
            }
            return null;
        }

        set;
    }

    public UploadDocToCreditLensController() {

    }

    public UploadDocToCreditLensController(ApexPages.StandardController controller) {

    }

   /**
    * Holds all Attachments and ContentDocumentLinks from the credit application
    */
    public Map<Id, GenericFile> allFiles {

        get {
            Map<Id, GenericFile> allFilesInfo = makeAllFilesGeneric();
            return allFilesInfo;
        }
    }

    public List<SelectOption> getItems() {

        List<SelectOption> options = new List<SelectOption>();
        for (Id id : allFiles.keySet()) {
            GenericFile file = allFiles.get(id);
            // so annoying - Attachments have the file ext in the name and ContentDocuments do not
            if (file.objectType.equalsIgnoreCase('Attachment')) {
                options.add(new SelectOption(id, file.fileName));
            } else {
                options.add(new SelectOption(id, file.fileName + '.' + file.fileExtension));
            }
        }
        return options;
    }
    // **********code for multiple file upload*********
//    public Id[] getSelectedFiles() {
//        return selectedFiles;
//    }
//
//    public void setSelectedFiles(Id[] selectedFiles) {
//        this.selectedFiles = selectedFiles;
//    }
//    Id[] selectedFiles = new Id[]{};
    // **********code for multiple file upload*********

    public Id getSelectedFile() {
        return selectedFile;
    }

    public void setSelectedFile(Id selectedFile) {
        this.selectedFile = selectedFile;
    }
    Id selectedFile = null;


    /**
      * Because the BOCA saves files as type Attachment and inside SF, uploading a file is saved as a ContentDocument,
      * for the purpose of displaying all the files, we combine them.
      *
      * @return
      */
    public Map<Id, GenericFile> makeAllFilesGeneric() {

        Map<Id, GenericFile> allFilesGeneric = new Map<Id, GenericFile>();

        List<Attachment> currentAttachments = currentAttachments;
        List<ContentDocumentLink> currentDocs = currentDocuments;

        if (currentAttachments != null && currentAttachments.size() > 0) {
            for (Attachment attachment : currentAttachments) {
                GenericFile genericFile = new GenericFile();
                genericFile.id = attachment.Id;
                genericFile.fileName = attachment.Name;
                genericFile.body = attachment.Body;
                genericFile.fileType = attachment.ContentType;
                genericFile.MIMEType = GenericFile.mapFileExtToMIMEType((attachment.Name).substringAfterLast('.'));
                genericFile.objectType = 'Attachment';
                if ((attachment.Name).Contains('.')) { genericFile.fileExtension = (attachment.Name).substringAfterLast('.'); }
                allFilesGeneric.put(attachment.Id, genericFile);
            }
        }

        if (currentDocs != null && currentDocs.size() > 0) {
            for (ContentDocumentLink document : currentDocs) {
                GenericFile genericFile = new GenericFile();
                ContentDocument contentDocument = document.ContentDocument;
                genericFile.id = contentDocument.Id;
                genericFile.fileName = contentDocument.Title;
                genericFile.fileType = contentDocument.FileType;
                genericFile.fileExtension = contentDocument.FileExtension;
                genericFile.MIMEType = GenericFile.mapFileExtToMIMEType(contentDocument.FileExtension);
                genericFile.objectType = 'ContentDocument';
                ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId =: contentDocument.Id];
                genericFile.body = contentVersion.VersionData;

                allFilesGeneric.put(contentDocument.Id, genericFile);
            }
        }
        return allFilesGeneric;
    }

    public Integer allFilesSize {

        get {
            if (allFiles != null && allFiles.size() > 0) {
                return allFiles.size();
            }
            return 0;
        }
    }

    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }

    public List<Attachment> currentAttachments {

        get {
            if (appId != null) {
                List<Attachment> currentAttachments = [SELECT Id, Name, ContentType, Body FROM Attachment WHERE ParentId = :appId];
                return currentAttachments;
            }
            return null;
        }
    }

    public List<ContentDocumentLink> currentDocuments {

        get {
            if (appId != null) {
                List<ContentDocumentLink> currentDocuments = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :appId];
                return currentDocuments;
            }
            return null;
        }
    }


    public PageReference init() {

        if (appId == null) { //appId only passed in during press of button, so don't display these if the window was just launched
            if (uploadSuccess) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ' Your file(s) have been uploaded!'));
            } else if (errorMessage != null && errorMessage.equalsIgnoreCase('badFileType')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have selected an unsupported file type. The following files are accepted: txt, odt, doc, docx, rtf, csv, xls, xlsx, ods, pdf'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Unable to upload your file(s) to Credit Lens.'));
            }
        }
        return null;
    }

    public PageReference uploadDocuments() {

        List<String> docIds = null;

        String error = null;
        Boolean success = false;

        List<GenericFile> files = new List<GenericFile>();
        // need to pass the rest of the file, not just the ID
        // **********code for multiple file upload*********
//         if (selectedFiles.size() > 0) {
//             for (Id id : selectedFiles) {
//                 GenericFile file = allFiles.get(id);
//                 if (file.MIMEType == null) error = 'badFileType';
//                 files.add(file);
//             }
        // **********code for multiple file upload*********
           if (selectedFile != null) {
               GenericFile file = allFiles.get(selectedFile);
               if (file.MIMEType == null) error = 'badFileType';
               files.add(file);

             if (errorMessage == null) docIds = CreditWS_CreditLens.uploadDocuments(files);
         }

        if (docIds != null) {
            success = CreditWS_CreditLens.linkDocToEntity(appId, docIds);
        }

        PageReference redirect = Page.UploadDocToCreditLens;
        redirect.getParameters().put('uploadStatus', String.valueOf(success));
        if (error != null) redirect.getParameters().put('errorMessage', error);
        redirect.setRedirect(true);
        return redirect;
    }
}