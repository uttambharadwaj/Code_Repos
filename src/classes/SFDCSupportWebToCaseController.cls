public with sharing class SFDCSupportWebToCaseController {

    public final static String APPLICATION_NAME = 'WEXSFDCSupport Page';

    public WEX_SFDC_Support_Portal_Setting__mdt casePortalSettings {
        get {
            List<WEX_SFDC_Support_Portal_Setting__mdt> casePortalSettings = [SELECT Id, Default_Contact_Record_Type_ID__c, Default_Account_ID__c, Default_Entitlement__c, Default_Business_Hours__c, Default_Case_Owner__c, Default_Case_Record_Type__c, Default_Currency__c FROM WEX_SFDC_Support_Portal_Setting__mdt WHERE DeveloperName = 'WEX_SFDC_Support_Settings'];

            if (casePortalSettings.size() > 0) {
                return casePortalSettings[0];
            }

            return null;
        }
    }

    public Case caseRequest { get; set; }

    public String comment { get; set; }
    
    public String currentPage {
        get {
            return ApexPages.currentPage().getParameters().get('currentStep');
        }
    }

    // home, newCase, viewCase, updateCase
    public String action {
        get {
            if (ApexPages.currentPage().getParameters().get('action') != null) {
                return ApexPages.currentPage().getParameters().get('action');
            }
            return 'home';
        }
    }

    public String caseIdParameter {
        get {
            return ApexPages.currentPage().getParameters().get('caseId');
        }
    }

    public String currentStepParameter {
        get {
            return ApexPages.currentPage().getParameters().get('currentStep');
        }
    }
    
    public String caseNumber {
        get {
            return ApexPages.currentPage().getParameters().get('caseNumber');
        }
    }

    public Case currentCase { get; set; }

    public Id currentUserId {
        get {
            return UserInfo.getUserId();
        }
    }

    public User currentUser { get; set; }

    public List<SelectOption> caseTypes { get; set; }

    public List<SelectOption> departments { get; set; }

    public List<Attachment> caseAttachments { get; set; }

    public Integer caseAttachmentsSize {
        get {
            if(caseAttachments != null) {
            	return caseAttachments.size();
            }
            return 0;
        }
    }

    public String browser {
        get {
            return ApexPages.currentPage().getHeaders().get('USER-AGENT');
        }
    }

    public Boolean isIssue {
        get {
            if (caseRequest != null) {
                if (caseRequest.Nature_of_Case__c == null || caseRequest.Nature_of_Case__c.equalsIgnoreCase('Issue')) {
                    return true;
                }
            }
            return false;
        }
    }

    public List<Case> myOpenCases { get; set; }

    public List<Case> myClosedCases { get; set; }

    public Integer sizeOfOpenCases {
        get {
            return myOpenCases.size();
        }
    }

    public Integer sizeOfClosedCases {
        get {
            return myClosedCases.size();
        }
    }

    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }

    public List<SelectOption> natureOfCaseOptions { get; set; }

    public Double offset {
        get {
            TimeZone tz = UserInfo.getTimeZone();
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }

    // Determines if the "Previous/Back" button is rendered
    public boolean previousStep {
        get {
            if(currentStep > minStep) {
                return false;
            } else {
                return true;
            }
        }
    }

    // Pagination variables for tracking the steps
    public Integer currentStep { get; set; }
    public Integer minStep  { get; set; }
    public Integer maxStep  { get; set; }
    
    // Determines if the "Next" button is rendered
    public boolean nextStep {
        get {
            if(currentStep < maxStep) {
                return false;
            } else {
                return true;
            }
        }
    }
    
    public SFDCSupportWebToCaseController() {

        // When the constructor re-fires on page load, we want to
        // set the current step to 1
        if (action != null && (action).equalsIgnoreCase('newCase')) {
            currentStep = 1;
            minStep = 1;
	        maxStep = 3;
            if(currentPage != null) {
            	currentStep = Integer.valueOf(currentPage);
        	}
        }

        if (currentStepParameter != null) {
            currentStep = Integer.valueOf(currentStepParameter);
        }
        
        System.debug(action);

    }

    public void init() {

        List<User> users = [SELECT Id, FirstName, Name, Email, Phone FROM User WHERE Id = :currentUserId];

        if (users.size() > 0) {

            currentUser = users[0];
        }

        if (action != null && (action).equalsIgnoreCase('newCase')) {

            caseRequest = new Case();
            caseRequest.RecordTypeId = casePortalSettings.Default_Case_Record_Type__c;

            // initialize attachment ability
            filesCountList = new List<SelectOption>();
            fileCount = '';
            allFileList = new List<Attachment>();

            for (Integer i = 1; i < 11; i++) {
                filesCountList.add(new SelectOption('' + i, '' + i));
            }

//            // Get default value of Nature of Case field:
//            Schema.DescribeFieldResult natureOfCaseFieldDescription = Schema.Case.Nature_of_Case__c.getDescribe();
//            // For each picklist value, a new select option created
//            for (Schema.Picklistentry picklistEntry: natureOfCaseFieldDescription.getPicklistValues()) {
//                natureOfCaseOptions.add(new SelectOption(pickListEntry.getValue(), pickListEntry.getLabel()));
//                // check default value and assign
//                if (picklistEntry.isDefaultValue()) {
//                    caseRequest.Nature_of_Case__c = picklistEntry.getValue();
//                }
//            }
        }

        if(action != null && (action).equalsIgnoreCase('home')) {
            myOpenCases = [SELECT Id, CaseNumber, Subject, Status, LastModifiedDate FROM Case WHERE RecordTypeId =: casePortalSettings.Default_Case_Record_Type__c and (CreatedById =: UserInfo.getUserId() or User__c =: UserInfo.getUserId()) and Status not in ('Closed') ORDER BY CreatedDate DESC];

            myClosedCases = [SELECT Id, CaseNumber, Subject, Status, LastModifiedDate, ClosedDate FROM Case WHERE RecordTypeId =: casePortalSettings.Default_Case_Record_Type__c and (CreatedById =: UserInfo.getUserId() or User__c =: UserInfo.getUserId()) and Status in ('Closed') ORDER BY ClosedDate DESC];
        }

        if(action != null && (action).equalsIgnoreCase('viewCase')) {
            try {
                List<Case> currentCases = [SELECT Id, CaseNumber, Subject, Description, Status FROM Case WHERE Id =: caseNumber and (CreatedById =: UserInfo.getUserId() or User__c =: UserInfo.getUserId())];

                if(currentCases.size() > 0) {
                    currentCase = currentCases[0];

                    caseAttachments = [SELECT Id, Name FROM Attachment where parentId =: currentCase.Id];

                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find specified case!'));
                }
            }
            catch(Exception e) {

            }
        }
    }

    public PageReference postFeed() {

        try {

            FeedItem post = new FeedItem();
            post.ParentId = currentCase.Id;
            post.Body = comment;
            insert post;
            comment = '';
            return null;

        } catch (Exception e) {
            System.debug('Exception Encountered submitting comment: ' + e.getStackTraceString() + ' ' + e);

            System.debug('Comment with error posting: ' + comment);

            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage(), UserInfo.getUserId(), e, true);

            PageReference errorPage = Page.InternalApplicationError;
            errorPage.getParameters().put('errorCode', errorCode);
            errorPage.setRedirect(true);
            return errorPage;

        }
    }
    
    // Step functions
    public void previousStep() {
        currentStep = currentStep - 1;
    }

    public void beginningStep() {
        currentStep = currentStep -2;
    }

    public void nextStep() {
    	currentStep = currentStep + 1;
    }

    public class webToCaseException extends Exception {}
    
    public PageReference submitCase() {

        System.debug('');

        try {

            Id caseContact = null;

            List<Contact> contacts = [SELECT Id FROM Contact WHERE RecordTypeId =: casePortalSettings.Default_Contact_Record_Type_ID__c and Email =: UserInfo.getUserEmail()];

            System.debug(contacts);

            if(contacts.size() > 0) {
                caseContact = contacts[0].Id;
            }
            else {

                Contact newContact = new Contact();

                if(casePortalSettings.Default_Contact_Record_Type_ID__c != null) {
                	newContact.RecordTypeId = casePortalSettings.Default_Contact_Record_Type_ID__c;
                }
                newContact.FirstName = UserInfo.getFirstName();
                newContact.LastName = UserInfo.getLastName();
                newContact.Email = UserInfo.getUserEmail();
                newContact.AccountId = casePortalSettings.Default_Account_ID__c;

                insert newContact;

                System.debug(newContact);

                caseContact = newContact.Id;

            }

            caseRequest.ContactId = caseContact;
            
            List<Entitlement> entitlements = [SELECT Id FROm Entitlement WHERE AccountId =: casePortalSettings.Default_Account_ID__c];
            
            if(entitlements.size() > 0) {
                caseRequest.EntitlementId = entitlements[0].Id;
            }

            caseRequest.OwnerId = casePortalSettings.Default_Case_Owner__c;
            caseRequest.BusinessHoursId = casePortalSettings.Default_Business_Hours__c;
            caseRequest.CurrencyIsoCode = casePortalSettings.Default_Currency__c;

            caseRequest.Status = 'New';
            caseRequest.Priority = 'Normal';
            caseRequest.Origin = 'Web';
            caseRequest.SuppliedName = currentUser.Name;
            caseRequest.SuppliedEmail = currentUser.Email;
            caseRequest.User__c = UserInfo.getUserId();

            System.debug('TEMP caseRequest: ' + caseRequest);
            Database.upsertResult result = Database.upsert(caseRequest, false);
            
            System.debug(result);

            // if new case is saved, redirect to viewing the newly opened case
            if (result.success) {

                System.debug(caseRequest);
                
                saveAttachments(result.getId());

                PageReference newCasePage = Page.WEXSFDCSupport;
                newCasePage.getParameters().put('action', 'viewCase');
                newCasePage.getParameters().put('caseNumber', result.getId());
                newCasePage.setRedirect(true);
                return newCasePage;
            }
            else {
                throw new webToCaseException('Issue inserting case: ' + result.getErrors());
            }

        } catch (Exception e) {
            System.debug('Exception Encountered Submitting Case: ' + e.getStackTraceString() + ' ' + e);

            System.debug('Last Case State: ' + caseRequest);
            
            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage(), UserInfo.getUserId(), e, true);

            PageReference errorPage = Page.InternalApplicationError;
			errorPage.getParameters().put('errorCode', errorCode);
            errorPage.setRedirect(true);
            return errorPage;
            
        }
    }

    /** /**
     Attachments Section
    /**  */
    public List<SelectOption> filesCountList { get; set; }

    public String fileCount {get; set; }

    public List<Attachment> allFileList { get; set; }

    public void saveAttachments(Id caseId) {

        System.debug('Inside saveAttachments, case id =' + caseId);

        if(caseId == null) {
            System.debug('No record is associated, pass in parameter');
        }

        List<Attachment> listToInsert = new List<Attachment>();

        for (Attachment a: allFileList) {
            if(a.name != '' && a.name != '' && a.body != null) {
                listToInsert.add(new Attachment(parentId = caseId, Name = a.name, Body = a.body));
            }
        }

        System.debug('Attachments: ' + allFileList);
        // Insert attachments
        if (listToInsert.size() > 0) {

            insert listToInsert;
            fileCount = '';
            System.debug('Attachments saved!');
        }
    }

    public PageReference ChangeCount()
    {
        allFileList.clear() ;
        //Adding multiple attachments instance
        for(Integer i = 1 ; i <= Integer.valueOf(fileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }
}