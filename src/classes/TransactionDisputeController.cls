/**
 *
 */

global without sharing class TransactionDisputeController {

    public final static String APPLICATION_NAME = 'Transaction Dispute Form';

    public String action {
        get {
            if (ApexPages.currentPage().getParameters().get('action') != null) {
                return ApexPages.currentPage().getParameters().get('action');
            }
            return 'home';
        }
    }

    public String claimIdParameter {
        get {
            return ApexPages.currentPage().getParameters().get('id');
        }
    }

    public String attachmentName { get; set; }

    public Blob attachmentBody { get; set; }

    public List<Attachment> claimAttachments {
        get {
            if (UserInfo.getSessionId() != null && claim != null && claim.Id != null) {
                List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE CreatedById = :UserInfo.getUserId() and ParentId =: claim.Id];

                return attachments;
            }
            return null;
        }
    }

    public Integer sizeOfClaimAttachments {
        get {
            if(claimAttachments != null) {
                return claimAttachments.size();
            }
            return 0;
        }
    }

    public String selectedFile {
        get {
            return ApexPages.CurrentPage().getParameters().get('selectedFile');
        }
        set;
    }

    public Claim__c claim { get; set; }

    public String claimNumber {
        get {
            if(claim != null) {
                List<Claim__c> claims = [SELECT Id, Name FROM Claim__c WHERE Id =: claim.Id];

                if(claims.size() > 0) {
                    return claims[0].Name;
                }
            }
            return null;
        }
    }

    public TransactionDispute transactionDispute { get; set; }

    public CustomerDetailsWSUtilv2.customerDetails customerDetails { get; set; }

    public CustomerDetailsWSUtilv2.contacts customerContacts { get; set; }

    public Integer sizeOfFraudPurchaseDevices {
        get {
            if(transactionDispute != null && transactionDispute.fraudPurchaseDevices != null) {
                return transactionDispute.fraudPurchaseDevices.size();
            }
            return 0;
        }
    }

    public String selectedAsset { get; set; }

    public String accountNumber { get; set; }

    public static String currentUserRole {
        get {
            List<User> user = [SELECT Id, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];

            return user[0].UserRole.Name;
        }
    }

    public String authorizedUserFullName {
        get {
            return UserInfo.getName();
        }
    }

    public String authorizedUserEmail {
        get {
            return UserInfo.getUserEmail();
        }
    }
    
    public String authorizedUserPhone {
        get {
            List<User> user = [SELECT Id, Phone FROM User WHERE Id =: UserInfo.getUserId()];

            return user[0].Phone;
        }
    }

    public String todaysDate {
        get {
            DateTime todaysDate = Datetime.now();

            return todaysDate.format('MM/dd/YYYY');
        }
    }

    public String physicalAddress {
        get {
            if(customerDetails != null && customerDetails.primaryAddress != null) {
                String address = (customerDetails.primaryAddress.addr1).trim() + '\n';

                if((customerDetails.primaryAddress.addr2).trim() != '') { address = address + (customerDetails.primaryAddress.addr2).trim() + '\n'; }
                if((customerDetails.primaryAddress.addr3).trim() != '') { address = address + (customerDetails.primaryAddress.addr3).trim() + '\n'; }
                if((customerDetails.primaryAddress.addr4).trim() != '') { address = address + (customerDetails.primaryAddress.addr4).trim() + '\n'; }

                address = address + (customerDetails.primaryAddress.city).trim() + ', ' + (customerDetails.primaryAddress.state).trim() + '\n';
                address = address + (customerDetails.primaryAddress.postalCode).trim() + '\n';

                return address;
            }
            return null;
        }
    }

    public CustomerDetailsWSUtilv2.address primaryAddress {
        get {
            if(customerDetails != null && customerDetails.primaryAddress != null) {
                return customerDetails.primaryAddress;
            }
            return null;
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

    public TransactionDisputeController() {

        minStep = 1;
        maxStep = 4;
        currentStep = 1;

        transactionDispute = new TransactionDispute();

    }

    public PageReference init() {

        try {
            if (!String.isEmpty(action)) {
                if ((action).equalsIgnoreCase('attachFiles') && claimIdParameter != null) {
                    List<Claim__c> claims = [SELECT Id FROM Claim__c WHERE Id =: claimIdParameter];

                    if(claims.size() > 0) {
                        claim = claims[0];
                        currentStep = 6;
                    }
                }
            }
        }
        catch(Exception e) {
            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage(), UserInfo.getUserId(), e, true);

            PageReference errorPage = Page.InternalApplicationError;
            errorPage.getParameters().put('errorCode', errorCode);
            errorPage.setRedirect(true);
            return errorPage;
        }

        return null;
    }

    public void getCustomerDetails() {

        // Get the account associated - need this later for the upsert of the account
        Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

        CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

        CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

        customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

        // Some damage control - we don't want that value to be below the default threshold
        if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
            customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
        }

        customerDetailsRequest.accountID = accountNumber;
        customerDetailsRequest.accountIdType = 'External';

        customerDetails = customerDetailsCallout.getCustomerDetails(customerDetailsRequest);

        // Get the contacts associated - need this later for the upsert of contacts
        customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

        customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

        customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

        // Some damage control - we don't want that value to be below the default threshold
        if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
            customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
        }

        customerDetailsRequest.accountID = accountNumber;
        customerDetailsRequest.accountIdType = 'External';

        customerContacts = customerDetailsCallout.getContacts(customerDetailsRequest);

    }

    @RemoteAction
    global static Boolean checkIfAccountExists(String accountNumber) {

        Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

        CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

        CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

        customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

        // Some damage control - we don't want that value to be below the default threshold
        if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
            customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
        }

        customerDetailsRequest.accountID = accountNumber;
        customerDetailsRequest.accountIdType = 'External';

        CustomerDetailsWSUtilv2.customerDetails customerDetails = customerDetailsCallout.getCustomerDetails(customerDetailsRequest);

        System.debug('### ' + customerDetails.programId);

        Set<String> programRowIDs = new Set<String>{'1-5UJ7D7','1-3PR9L6W','1-5VD2FQ','1-3FJ9JP1'};
        
        if(customerDetails != null && customerDetails.programId != null && programRowIDs.contains(customerDetails.programId)) {
            return true;
        }
        else { 
        	return false;
        }
        
        /*
        if(!String.isEmpty(customerDetails.wexAccountNbr)) {

            customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            customerDetailsRequest.accountID = accountNumber;
            customerDetailsRequest.accountIdType = 'External';

            CustomerDetailsWSUtilv2.contacts customerContacts = customerDetailsCallout.getContacts(customerDetailsRequest);

            for(CustomerDetailsWSUtilv2.contact contact : customerContacts.contacts) {

                if((contact.emailAddr != null && (contact.emailAddr).equalsIgnoreCase(UserInfo.getUserEmail())) || !(UserInfo.getUserType()).equalsIgnoreCase('Partner')) {
                    return true;
                }

            }

            return false;

        }
        else {
            return false;
        }
		*/

    }

    // Step functions
    public void previousStep() {
        currentStep = currentStep - 1;
    }

    public void beginningStep() {
        currentStep = currentStep -2;
    }

    public void nextStep() {
        if(currentStep == 1) {
            getCustomerDetails();
        }
        currentStep = currentStep + 1;
    }

    public String selectedStep { get; set; }

    public void goToSelectedStep() {
        if(selectedStep != null) {
            currentStep = Integer.valueOf(selectedStep);
        }
    }

    public PageReference addAsset() {
        if(transactionDispute != null && transactionDispute.fraudPurchaseDevices != null) {
            transactionDispute.fraudPurchaseDevices.add(new FraudPurchaseDevice());
        }

        return null;
    }

    public PageReference removeAsset() {

        if(transactionDispute != null && transactionDispute.fraudPurchaseDevices != null && transactionDispute.fraudPurchaseDevices[Integer.valueOf(selectedAsset)] != null) {
            transactionDispute.fraudPurchaseDevices.remove(Integer.valueOf(selectedAsset));
        }

        return null;

    }

    public PageReference deleteFile() {

        if(selectedFile != null) {

            List<Attachment> selectedAttachment = [SELECT Id, Name FROM Attachment WHERE CreatedById =: UserInfo.getUserId() and ParentId =: claim.Id and Id =: selectedFile];

            if(selectedAttachment.size() == 1) {

                delete selectedAttachment;

            }

        }

        PageReference refresh = Page.TransactionDisputeForm;
        refresh.getParameters().put('id', claim.Id);
        refresh.getParameters().put('action', 'attachFiles');
        refresh.setRedirect(true);
        return refresh;

    }

    public PageReference uploadFile() {

        if(attachmentName != null && attachmentBody != null) {

            Attachment claimAttachment = new Attachment();

            claimAttachment.Body = attachmentBody;
            claimAttachment.Name = attachmentName;
            claimAttachment.ParentId = claim.Id;

            try {
                insert claimAttachment;

                PageReference refresh = Page.TransactionDisputeForm;
                refresh.getParameters().put('id', claim.Id);
                refresh.getParameters().put('action', 'attachFiles');
                refresh.setRedirect(true);
                return refresh;
            }
            catch (Exception e) {
                String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage(), UserInfo.getUserId(), e, true);

                PageReference errorPage = Page.InternalApplicationError;
                errorPage.getParameters().put('errorCode', errorCode);
                errorPage.setRedirect(true);
                return errorPage;
            }
            finally {
                claimAttachment.Body = null;
            }
        }

        return null;

    }

    public PageReference submitForm() {

        try {

            System.debug(transactionDispute);

            // Upsert Account
            Id accountId = CustomerDetailsController.upsertAccount(JSON.serialize(customerDetails));

            // Need to find the contact
            String focusedContactRowId = '1-NOTFOUND';

            List<CustomerDetailsWSUtilv2.contact> contacts = new List<CustomerDetailsWSUtilv2.contact>();

            for (CustomerDetailsWSUtilv2.contact contact : customerContacts.contacts) {

                if (contact.rowId != null && (contact.emailAddr).equalsIgnoreCase(UserInfo.getUserEmail())) {
                    focusedContactRowId = contact.rowId;
                }

                contacts.add(contact);

            }

            // Upsert Contacts
            Id contactId = CustomerDetailsController.upsertContacts(accountId, JSON.serialize(contacts), focusedContactRowId);

            // Create Case

            Case serviceOperationsCase = new Case();

            if (Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations') != null) {
                serviceOperationsCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
            }

            serviceOperationsCase.Status = 'Open';
            serviceOperationsCase.Type = 'Transaction Dispute Form';
            serviceOperationsCase.Subject = 'Transaction Dispute Form';
            serviceOperationsCase.Origin = 'Transaction Dispute Form';
            serviceOperationsCase.OwnerId = '00G0g000004LbIh';
            serviceOperationsCase.AccountId = (ID) accountId;
            //serviceOperationsCase.ContactId = (ID) contactId;

            System.debug('### ' + serviceOperationsCase);
            
            upsert serviceOperationsCase;

            List<Account> claimAccount = [SELECT Id, Name, Wex_Account__c, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE Id = :accountId];

            claim = new Claim__c();

            claim.Case__c = serviceOperationsCase.Id;

            if (claimAccount.size() > 0) {
                claim.Account_Name__c = claimAccount[0].Name;
                claim.Account_Oppty_Number__c = claimAccount[0].Wex_Account__c;
                claim.WEX_Account__c = claimAccount[0].Wex_Account__c;
                claim.Account_Address_1__c = claimAccount[0].ShippingStreet;
                claim.Account_City__c = claimAccount[0].ShippingCity;
                claim.Account_State__c = claimAccount[0].ShippingState;
                claim.Account_Zip__c = claimAccount[0].ShippingPostalCode;
            }

            claim.Account_Contact_Name__c = UserInfo.getName();
            claim.Account_Contact_Email__c = UserInfo.getUserEmail();

            if(transactionDispute.driverName != null) claim.Driver_Name__c = transactionDispute.driverName;
            if(!String.isEmpty(transactionDispute.lostOrStolenDate)) claim.Dispute_Reported_Date__c = Date.parse(transactionDispute.lostOrStolenDate);
            if(!String.isEmpty(transactionDispute.driverEmploymentStartDate)) claim.Driver_Employment_Start_Date__c = Date.parse(transactionDispute.driverEmploymentStartDate);
            if(!String.isEmpty(transactionDispute.driverEmploymentEndDate)) claim.Driver_Employment_End_Date__c = Date.parse(transactionDispute.driverEmploymentEndDate);

            claim.Dispute_Form_Comments__c = transactionDispute.additionalComments;

            if(transactionDispute.disputeWhitePlastic) {
				claim.Dispute_Type__c = 'White Plastic (Skimmed)';
            }
            else if(transactionDispute.disputeStolenLost) {
                claim.Dispute_Type__c = 'Lost/Stolen';
            }
            else if(transactionDispute.disputeDriverName || transactionDispute.disputeDriverNameDate) {
                claim.Dispute_Type__c = 'Driver';
            }
            else {
                claim.Dispute_Type__c = 'Undetermined';
            }

            claim.Dispute_Reported_Date__c = Date.today();
            claim.Agency_1__c = transactionDispute.agencyName1;
            claim.Personnel_Taking_Report_1__c = transactionDispute.personnelName1;
            if(!String.isEmpty(transactionDispute.dateOfReport1)) claim.Date_of_Report_1__c = Date.parse(transactionDispute.dateOfReport1);
            claim.Report_Number_1__c = transactionDispute.reportNumber1;
            claim.Agency_Phone_Number_1__c = transactionDispute.agencyPhone1;
            claim.Agency_Email_1__c = transactionDispute.agencyEmail1;

            claim.Agency_2__c = transactionDispute.agencyName2;
            claim.Personnel_Taking_Report_2__c = transactionDispute.personnelName2;
            if(!String.isEmpty(transactionDispute.dateOfReport2)) claim.Date_of_Report_2__c = Date.parse(transactionDispute.dateOfReport2);
            claim.Report_Number_2__c = transactionDispute.reportNumber2;
            claim.Agency_Phone_Number_2__c = transactionDispute.agencyPhone2;
            claim.Agency_Email_2__c = transactionDispute.agencyEmail2;
            
            claim.Prosecution_Assistance_By_Customer__c = transactionDispute.prosecutionAssistanceByCustomer;
            claim.Reported_To_Law_Enforcement_By_Customer__c = transactionDispute.reportedToLawEnforcementByCustomer;
            claim.Law_Enforcement_Report_Filed__c = transactionDispute.lawEnforcementReportFiled;
            claim.Information_Release_Authorized__c = transactionDispute.informationReleasedAuthorized;

            insert claim;

            for(FraudPurchaseDevice fraudPurchaseDevice : transactionDispute.fraudPurchaseDevices) {
                if(!String.isEmpty(fraudPurchaseDevice.vehicleCardNumber)) {
                    Fraud_Purchase_Device__c newFraudPurchaseDevice = new Fraud_Purchase_Device__c();

                    newFraudPurchaseDevice.Claim__c = claim.Id;
                    newFraudPurchaseDevice.Case__c = serviceOperationsCase.Id;

                    newFraudPurchaseDevice.Vehicle_Card__c = fraudPurchaseDevice.vehicleCardNumber;
                    newFraudPurchaseDevice.CO_ID_STD_EMB_GTag__c = fraudPurchaseDevice.gTag;
                    newFraudPurchaseDevice.Date_Abuse_Started__c = Date.parse(fraudPurchaseDevice.dateAbuseBegan);
                    newFraudPurchaseDevice.Date_Abuse_Ended__c = Date.parse(fraudPurchaseDevice.dateAbuseEnded);
                    newFraudPurchaseDevice.Amount_Value_of_Abuse__c = Decimal.valueOf(fraudPurchaseDevice.amountOfAbuse);

                    insert newFraudPurchaseDevice;
                }
            }

            currentStep = 5;

            System.debug(serviceOperationsCase);

        }
        catch(Exception e) {
            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage(), UserInfo.getUserId(), e, true);

            PageReference errorPage = Page.InternalApplicationError;
            errorPage.getParameters().put('errorCode', errorCode);
            errorPage.setRedirect(true);
            return errorPage;
        }

        return null;

    }

    public class TransactionDispute {

        public Boolean disputeWhitePlastic { get; set; }
        public Boolean disputeStolenLost { get; set; }
        public Boolean disputeDriverName { get; set; }
        public Boolean disputeDriverNameDate { get; set; }
        public Boolean disputeUnknown { get; set; }

        public String lostOrStolenDate { get; set; }

        public String driverName { get; set; }
        public String driverEmploymentStartDate { get; set; }
        public String driverEmploymentEndDate { get; set; }

        public String additionalComments { get; set; }

        public String agencyName1 { get; set; }
        public String personnelName1 { get; set; }
        public String dateOfReport1 { get; set; }
        public String reportNumber1 { get; set; }
        public String agencyPhone1 { get; set; }
        public String agencyEmail1 { get; set; }

        public String agencyName2 { get; set; }
        public String personnelName2 { get; set; }
        public String dateOfReport2 { get; set; }
        public String reportNumber2 { get; set; }
        public String agencyPhone2 { get; set; }
        public String agencyEmail2 { get; set; }

        public Boolean prosecutionAssistanceByCustomer { get; set; }
        public Boolean informationReleasedAuthorized { get; set; }
        public Boolean reportedToLawEnforcementByCustomer { get; set; }
        public Boolean lawEnforcementReportFiled { get; set; }

        public List<FraudPurchaseDevice> fraudPurchaseDevices { get; set; }

        public TransactionDispute() {

            fraudPurchaseDevices = new List<FraudPurchaseDevice>{new FraudPurchaseDevice()};

			this.disputeWhitePlastic = false;
            this.disputeStolenLost = false;
            this.disputeDriverName = false;
            this.disputeDriverNameDate = false;
            this.disputeUnknown = true;
            this.prosecutionAssistanceByCustomer = true;
            this.informationReleasedAuthorized = true;
            this.reportedToLawEnforcementByCustomer = false;
            this.lawEnforcementReportFiled = false;

        }

    }

    public class FraudPurchaseDevice {

        public String vehicleCardNumber { get; set; }
        public String gTag { get; set; }
        public String dateAbuseBegan { get; set; }
        public String dateAbuseEnded { get; set; }
        public String amountOfAbuse { get; set; }

        public FraudPurchaseDevice() {

        }

    }

}