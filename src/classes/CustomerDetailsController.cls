/*
* 
*  CustomerDetailsController
* 
*  This is the main controller for the CustomerDetails(.vfp)
* 
*  Test Class: CustomerDetailsController.apxc
* 
*  D. Gilbert (WEX) / 11-2017
*
*/
public without sharing class CustomerDetailsController {
    public class customerDetailsException extends Exception {}

    private static Set<String> caseTypesToDisplay = new Set<String>{'Service Operations','VAS - Retention'};

    @AuraEnabled
    public static Customer_Dashboard_Services__c CDS { get; set; }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout { get; set; }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest { get; set; }

    public static Id genericProgram {
        get {
            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            if(CDS.Generic_Program__c != null) {
                List<Program__c> genericProgram = [SELECT Id FROM Program__c WHERE Id =: CDS.Generic_Program__c];

                if(genericProgram.size() > 0) {
                    return genericProgram[0].Id;
                }
            }

            return null;
        }
    }

    @AuraEnabled
    public static Integer getNumberOfCasesToday(String accountNumber) {
        System.debug('### entering getNumberOfCasesToday for '+accountNumber);

        try {

            List<Case> cases = [SELECT Id FROM Case WHERE Account.Wex_Account__c =: accountNumber AND CreatedDate = TODAY AND RecordType.Name IN: caseTypesToDisplay];
            System.debug('### getNumberOfCasesToday found '+cases.size());

            return cases.size();

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve number of cases today for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static Integer getNumberOfCasesTodayByAccountRecordId(String accountId) {
        System.debug('### entering getNumberOfCasesTodayByAccountRecordId for '+accountId);

        try {

            List<Case> cases = [SELECT Id FROM Case WHERE AccountId =: accountId AND CreatedDate = TODAY AND RecordType.Name IN: caseTypesToDisplay];
            System.debug('### getNumberOfCasesTodayByAccountRecordId found '+cases.size());

            return cases.size();

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve number of cases today for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static Support_Operation_Settings__c getSupportOperationsSettings() {
        System.debug('Entering getSupportOperationsSettings');
        System.debug(Support_Operation_Settings__c.getInstance());
        return Support_Operation_Settings__c.getInstance();
    }

    @AuraEnabled
    public static List<Case> getExistingCases(String accountNumber) {
        System.debug('### entering getExistingCases for '+accountNumber);

        try {

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, toLabel(Status), CreatedDate, LastModifiedDate, toLabel(Origin), Owner.Name, Department__c, RecordType.Name FROM Case WHERE Account.Wex_Account__c =: accountNumber AND RecordType.Name IN: caseTypesToDisplay ORDER BY LastModifiedDate DESC];
            System.debug('### getExistingCases found '+cases.size());

            return cases;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static List<Case> getExistingCasesByAccountRecordId(String accountId) {
        System.debug('### entering getExistingCasesByAccountRecordId for '+accountId);

        try {

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, toLabel(Status), CreatedDate, LastModifiedDate, toLabel(Origin), Owner.Name, Department__c, RecordType.Name FROM Case WHERE AccountId =: accountId AND RecordType.Name IN: caseTypesToDisplay ORDER BY LastModifiedDate DESC];
            System.debug('### getExistingCasesByAccountRecordId found '+cases.size());

            return cases;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static List<Case> getExistingOpenCases(String accountNumber) {
        System.debug('### entering getExistingOpenCases for '+accountNumber);

        try {

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, Status,  LastModifiedDate, Origin, Owner.Name, Department__c, RecordType.Name FROM Case WHERE Account.Wex_Account__c =: accountNumber AND RecordType.Name IN: caseTypesToDisplay AND IsClosed = FALSE ORDER BY LastModifiedDate DESC LIMIT 5];
            System.debug('### getExistingOpenCases found '+cases.size());

            return cases;
        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static List<Case> getExistingOpenCasesByAccountId(String accountId) {
        System.debug('### entering getExistingOpenCasesByAccountId for '+accountId);


        try {
            List<Case> cases = new List<Case>();
            if (accountId != null) {

                cases = [SELECT Id, CaseNumber, Subject, Contact.Name, Status,  LastModifiedDate, Origin, Owner.Name, Department__c, RecordType.Name FROM Case WHERE AccountId =: accountId AND RecordType.Name IN: caseTypesToDisplay AND IsClosed = FALSE ORDER BY LastModifiedDate DESC LIMIT 5];
                System.debug('### getExistingOpenCasesByAccountId found '+cases.size());
            }

            return cases;
        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.customerDetails getCustomerDetails(String accountNumber, String accountRecordId, String pdRowIdString, Boolean isOtrAccount) {
        System.debug('Entering getCustomerDetails for '+accountNumber+','+accountRecordId+','+ pdRowIdString+','+isOtrAccount);

        try {
            CustomerDetailsWSUtilv2.customerDetails customerDetails;

            if (isOtrAccount) {
                accountRecordId = getAccountIdFromAcctRowId(accountRecordId);
                customerDetails = getOtrCustomerDetails(accountRecordId);
            } else {
                customerDetails = getSoapCustomerDetails(accountNumber, pdRowIdString);
            }

            if(String.isEmpty(customerDetails.pfsRepNm)) {
                customerDetails.pfsRepNm = 'N/A';
            }

            if(String.isEmpty(customerDetails.accountNm)) {
                throw new customerDetailsException('Unable to retrieve account information: '+accountNumber + ', '+accountRecordId + ', pdRowId' +  (String.isEmpty(pdRowidString) ? ' not' : '')+' provided');
            }

            return customerDetails;

        }
        catch(Exception e) {

            if (Test.isRunningTest()) {
                throw e;
            } else {
                String errorCode = logError(e);

                throw new AuraHandledException('Unable to retrieve account details. (Error Tracking Code: ' + errorCode + ')');
            }
        }

    }

    private static CustomerDetailsWSUtilv2.customerDetails getSoapCustomerDetails(String accountNumber, String pdRowIdString) {
        CDS = Customer_Dashboard_Services__c.getOrgDefaults();

        customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

        customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

        customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

        // Some damage control - we don't want that value to be below the default threshold
        if (CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
            customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
        }

        customerDetailsRequest.accountID = accountNumber;
        customerDetailsRequest.accountIdType = 'Internal';

        if (!String.isEmpty(pdRowIdString)) {
            customerDetailsRequest.pdRowId = pdRowIdString;
        }

        CustomerDetailsWSUtilv2.customerDetails customerDetails = customerDetailsCallout.getCustomerDetails(customerDetailsRequest);
        return customerDetails;
    }

    private static CustomerDetailsWSUtilv2.customerDetails getOtrCustomerDetails(String accountId) {
        System.debug('Calling getOtrCustomerDetails with accountId '+accountId);
        CustomerDetailsWSUtilv2.customerDetails customerDetails = new CustomerDetailsWSUtilv2.customerDetails();

        List<Account> serviceOperationsAccounts = [SELECT Id, Customer_Segmentation__c, CurrencyIsoCode, Status__c, Account_Status_Date__c, Program__c, Name, Phone, Fax, Wex_Account__c, Sponsor_Acct__c, PFS_REP__c, Priority_Level__c, Priority_Level_Update_Date__c, Funder__c, Online_Application_URL__c, Account_Instructions__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Carrier_ID__c, Platform__c, Acct_Row_Id__c, Primary_Contact_TXT__c FROM Account WHERE Id =: accountId];

        if (!(serviceOperationsAccounts.isEmpty())) {
            Account serviceOperationsAccount = serviceOperationsAccounts.get(0);
            customerDetails.sfdcAcctId = serviceOperationsAccount.Id;

            customerDetails.customerSegmentation = String.valueOf(serviceOperationsAccount.Customer_Segmentation__c);
            if (serviceOperationsAccount.Status__c != null) {
                if ('Active'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'A';
                } else if ('Inactive'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'I';
                } else if ('Suspended'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'S';
                } else if ('Terminated'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'T';
                }
                  else if ('C'.equals(serviceOperationsAccount.Status__c) || 'X'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'T';
                }
                  else {
                    customerDetails.accountSts = serviceOperationsAccount.Status__c;
                }
            }
            customerDetails.accountStsDt = serviceOperationsAccount.Account_Status_Date__c;
            customerDetails.programId = serviceOperationsAccount.Program__c;
            if (serviceOperationsAccount.Program__c != null) {
                List<Program__c> programs = [SELECT Id, Service_Program_Name__c, Service_Program_Website__c FROM Program__c WHERE Id =: serviceOperationsAccount.Program__c ];
                if (programs.size() > 0) {
                    customerDetails.programNm = programs[0].Service_Program_Name__c;
                    customerDetails.onlineApplication = programs[0].Service_Program_Website__c;
                }
            }

            customerDetails.accountNm = serviceOperationsAccount.Name;

            customerDetails.wexAccountNbr = serviceOperationsAccount.Wex_Account__c;
            customerDetails.spnrAccountNbr = serviceOperationsAccount.Sponsor_Acct__c;
            customerDetails.acctRowId = serviceOperationsAccount.Acct_Row_Id__c;
            customerDetails.pfsRepNm = serviceOperationsAccount.PFS_REP__c;
            customerDetails.priorityLevel = serviceOperationsAccount.Priority_Level__c;
            customerDetails.funder = serviceOperationsAccount.Funder__c;
            customerDetails.specialInstructions = serviceOperationsAccount.Account_Instructions__c;

            if (serviceOperationsAccount.Platform__c != null)
                customerDetails.sourceSys = serviceOperationsAccount.Platform__c;
            else
                    customerDetails.sourceSys = 'OTR';

            CustomerDetailsWSUtilv2.address billingAddress = new CustomerDetailsWSUtilv2.address();
            CustomerDetailsWSUtilv2.address shippingAddress = new CustomerDetailsWSUtilv2.address();

            billingAddress.addr1 = serviceOperationsAccount.BillingStreet;
            billingAddress.city = serviceOperationsAccount.BillingCity;
            billingAddress.state = serviceOperationsAccount.BillingState;
            billingAddress.country = serviceOperationsAccount.BillingCountry;
            billingAddress.postalCode = serviceOperationsAccount.BillingPostalCode;
            shippingAddress.addr1 = serviceOperationsAccount.ShippingStreet;
            shippingAddress.city = serviceOperationsAccount.ShippingCity;
            shippingAddress.state = serviceOperationsAccount.ShippingState;
            shippingAddress.country = serviceOperationsAccount.ShippingCountry;
            shippingAddress.postalCode = serviceOperationsAccount.ShippingPostalCode;

            customerDetails.billingAddress = billingAddress;
            customerDetails.shippingAddress = shippingAddress;

            CustomerDetailsWSUtilv2.contacts contacts = new  CustomerDetailsWSUtilv2.contacts();
            contacts.contacts = getCustomerContactsFromSalesforce(accountId, serviceOperationsAccount.Primary_Contact_TXT__c);
            customerDetails.contacts = contacts;
            for (CustomerDetailsWSUtilv2.contact contact : contacts.contacts) {
                if (contact.contactType.equalsIgnoreCase('PRIMARY')) {
                    customerDetails.primaryAddress = contact.address;
                }
            }
        }
        return customerDetails;
    }

    @AuraEnabled
    public static List<CustomerDetailsWSUtilv2.contact> getCustomerContactsFromSalesforce(Id accountId, String primaryContactRowId) {
        System.debug('*** Called getCustomerContactsFromSalesforce with acct '+ accountId + ' and primaryContact '+primaryContactRowId);
        List<CustomerDetailsWSUtilv2.contact> contactList = new List<CustomerDetailsWSUtilv2.contact>();
        if (!String.isEmpty(accountId)) {
            List<Contact> rawContactList = [SELECT Id, Contact_Row_Id__c, WEX_Contact_ID__c, FirstName, LastName, Email, Fax, Phone, Contact_Type__c, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, AccountId  FROM Contact WHERE AccountId =:accountId];
            CustomerDetailsWSUtilv2.contact newContact;
            for (Contact rawContact : rawContactList) {
                newContact = new CustomerDetailsWSUtilv2.contact();
                //newContact.role = 'CONTACT';
                System.debug('*** Contact record ID='+rawContact.Id);

                if (rawContact.Contact_Row_Id__c != null && (rawContact.Contact_Row_Id__c.equals(primaryContactRowId) || rawContact.Contact_Type__c.equals('PRIMARY'))) {
                    newContact.contactType = 'PRIMARY';
                    newContact.role = 'PRIMARY';
                    System.debug('*** Primary contact identified: ' + primaryContactRowId);
                }

                if (newContact.contactType != 'PRIMARY') {
                    newContact.contactType = 'CONTACT';
                }

                newContact.emailAddr = rawContact.Email;
                newContact.faxNbr = rawContact.Fax;
                newContact.firstNm = rawContact.FirstName;
                newContact.lastNm = rawContact.LastName;
                newContact.phoneNbr = rawContact.Phone;
                newContact.rowId = rawContact.Contact_Row_Id__c ;
                if (newContact.rowId == null) {
                    newContact.rowId = rawContact.Id;
                }

                CustomerDetailsWSUtilv2.address address = new CustomerDetailsWSUtilv2.address();

                address.addr1 = rawContact.MailingStreet;
                address.city = rawContact.MailingCity;
                address.state = rawContact.MailingState;
                address.country = rawContact.MailingCountry;
                address.postalCode = rawContact.MailingPostalCode;

                newContact.address = address;
                System.debug(newContact);
                contactList.add(newContact);
            }
        }
        return contactList;
    }

    @AuraEnabled
    public static List<CustomerDetailsWSUtilv2.contact> getCustomerContacts(String accountNumber) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            customerDetailsRequest.accountID = accountNumber;
            customerDetailsRequest.accountIdType = 'Internal';

            CustomerDetailsWSUtilv2.contacts customerContactsResponse = customerDetailsCallout.getContacts(customerDetailsRequest);

            System.debug('### ' + customerContactsResponse);

            /*
            if(!String.isEmpty(customerContactsResponse.errorMsg)) {

                throw new customerDetailsException('Unable to retrieve account contacts: ');
            }
             */

            return customerContactsResponse.contacts;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account contacts for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.agingHistory getAgingHistory(String accountNumber) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsRequest = new CustomerDetailsWSUtilv2.customerDetailsRequest();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            customerDetailsRequest.accountID = accountNumber;
            customerDetailsRequest.accountIdType = 'Internal';

            CustomerDetailsWSUtilv2.agingHistory customerAgingHistoryResponse = customerDetailsCallout.getAgingHistory(customerDetailsRequest);

            System.debug('### ' + customerAgingHistoryResponse);

            if(!String.isEmpty(customerAgingHistoryResponse.errorMsg)) {
                throw new customerDetailsException('Unable to retrieve account payment history.');
            }

            return customerAgingHistoryResponse;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve payment history for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static List<CustomerDetailsWSUtilv2.authLogRecord>  getRecentDeclinedAuths(String wexAcctNbr, String sourceSys) {

        if (!isExternalPlatform(sourceSys)) {
            return new List<CustomerDetailsWSUtilv2.authLogRecord>();
        }
        //Everything from here on is effectively "else"

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.authSearchResult authSearchResult = customerDetailsCallout.getRecentDeclinedAuths(wexAcctNbr,sourceSys);

            //System.debug('### ' + authSearchResult);

            return authSearchResult.authLog;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent declined transactions. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.payments getPayments(String accountNumber, String sourceSys) {

        CustomerDetailsWSUtilv2.payments result;

        if (!isExternalPlatform(sourceSys)) {
            System.debug('getPayments for external platform: '+sourceSys);
            result = new CustomerDetailsWSUtilv2.payments();
            result.paymentDetails = new CustomerDetailsWSUtilv2.paymentDetailEntry[]{};
            result.paymentHistory = new CustomerDetailsWSUtilv2.paymentHistoryEntry[]{};
            result.pendingPayments = new CustomerDetailsWSUtilv2.pendingPaymentEntry[]{};
            return result;
        }
        //Everything from here on is effectively "else"

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            //System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.payments payments = customerDetailsCallout.getPayments(accountNumber, sourceSys);

            //CustomerDetailsWSUtilv2.payments payments = CustomerDetailsController.getDummyPayments(accountNumber);

            //System.debug('### ' + payments);

            return payments;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent payments. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.invoices getInvoices(String accountNumber, String sourceSys) {

        CustomerDetailsWSUtilv2.invoices result;

        if (!isExternalPlatform(sourceSys)) {
            System.debug('getInvoices for external platform: '+sourceSys);
            result= new CustomerDetailsWSUtilv2.invoices();
            result.invoices = new CustomerDetailsWSUtilv2.invoiceEntry[]{};
            return result;
        }
        //Everything from here on is effectively "else"

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            result = customerDetailsCallout.getInvoices(accountNumber, sourceSys);

            //System.debug('### ' + result);

            return result;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent invoices. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.RefundAdjustmentDTO getRefunds(String accountNumber) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.RefundAdjustmentDTO refundDTO = customerDetailsCallout.getRefunds(accountNumber);

            System.debug('### ' + refundDTO);

            return refundDTO;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent payments. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    public static CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO getRefAdjTotals(String accountNumber, String recordType) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO refundDTO = customerDetailsCallout.getRefundAdjustmentTotals(recordType, accountNumber);

            System.debug('### ' + refundDTO);

            return refundDTO;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO refundDTO = new CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO();
            refundDTO.errorMsg = e.getMessage();
            return refundDTO;

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.RefundAdjustmentDTO getAdjustments(String accountNumber) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.RefundAdjustmentDTO adjustmentDTO = customerDetailsCallout.getAdjustments(accountNumber);

            System.debug('### ' + adjustmentDTO);

            return adjustmentDTO;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent payments. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static String getAccountId(String accountNumber) {

        try {

            List<Account> serviceOperationsAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Service Operations' AND Wex_Account__c =: accountNumber];

            if(serviceOperationsAccount.size() > 0) {

                return serviceOperationsAccount[0].Id;

            }
            else {

                throw new customerDetailsException('Unable to retrieve account ID.');

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account ID. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static String getAccountIdFromAcctRowId(String acctRowId) {
        System.debug('Called getAccountIdFromAcctRowId with acctRowId '+acctRowId);
        if (isSalesforceId(acctRowId))
            return acctRowId;
        else {

            try {

                List<Account> serviceOperationsAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Service Operations' AND Acct_Row_Id__c =: acctRowId];

                if(serviceOperationsAccount.size() > 0) {

                    return serviceOperationsAccount[0].Id;

                }
                else {

                    throw new customerDetailsException('Unable to retrieve account ID.');

                }

            }
            catch(Exception e) {

                String errorCode = logError(e);

                throw new AuraHandledException('Unable to retrieve account ID. (Error Tracking Code: ' + errorCode + ')');

            }
        }

    }



    @AuraEnabled
    public static String getAccountNumber(String accountRecordId) {

        try {
            System.debug('Entering getAccountNumber for accountRecordId '+accountRecordId);
            List<Account> serviceOperationsAccount = [SELECT Id, Wex_Account__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Id =: accountRecordId];

            if(serviceOperationsAccount.size() > 0) {
                if (serviceOperationsAccount[0].Wex_Account__c.equals(''))
                    return serviceOperationsAccount[0].Id;
                else
                    return serviceOperationsAccount[0].Wex_Account__c;
            }
            else {

                throw new customerDetailsException('Unable to retrieve account number.');

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account number for given account ID: ' + accountRecordId + '. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static String getPriorityLevelServicingRule(String pgmRowId, String priorityLevel) {
        System.debug('Entering getPriorityLevelServicingRule for pgmRowId '+pgmRowId + ' and priorityLevel '+priorityLevel);
        String result = 'Servicing Rule not available; refer to documentation';
        try {
            List<Program__c> programs = [SELECT Id, Partner__c FROM Program__c WHERE Siebel_Program_Row_Id__c =: pgmRowId];
            if (programs.size() >0) {
                Id partnerId = programs[0].Partner__c;
                List<Priority_Level_Servicing_Rule__c> servicingRules = [SELECT Id, Priority_Level_Rule_Detail__c FROM Priority_Level_Servicing_Rule__c WHERE Partner__c =: partnerId AND Priority_Level__c =: priorityLevel];
                if (servicingRules.size() > 0)
                    result = servicingRules[0].Priority_Level_Rule_Detail__c;
            }

        } catch(Exception e) {

            String errorCode = logError(e);
        }
        System.debug('### getPriorityLevelServicingRule for pgmRowId '+pgmRowId + ' and priorityLevel '+priorityLevel+ ' returns: '+result);
        return result;
    }

    @AuraEnabled
    public static Id getContactId(String accountId, String contactRowId) {
        System.debug('Entering getContactId for accountId '+accountId+' and contactRowId '+contactRowId);
        if (accountId == null || contactRowId == null)
            return null;

        try {
            String contactRowIdToUse = getContactRowId(contactRowId);
            List<Contact> serviceOperationsContacts = [SELECT Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND Account.Id =: accountId AND WEX_Contact_ID__c =: contactRowId];

            if (serviceOperationsContacts.size() == 0) {
                //Contact_Row_ID__c is a unique, External ID field in Integration Record
                List<IntegrationRecord__c> serviceOperationsIntegrationRecords = [SELECT Contact__r.Id FROM IntegrationRecord__c WHERE Contact_Row_Id__c =: contactRowIdToUse];
                if (serviceOperationsIntegrationRecords.size() > 0)
                    serviceOperationsContacts.add(serviceOperationsIntegrationRecords[0].Contact__r);
            }


            System.debug('### ' + serviceOperationsContacts);

            if(serviceOperationsContacts.size() > 0) {

                return serviceOperationsContacts[0].Id;
            }
            else {

                System.debug('Unable to retrieve contact ID for rowId '+contactRowId);
                return null;
            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve contact ID. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static Id upsertAccount(String customerDetailsJSON) {
        Boolean accountNewToSalesforce = false;

        try {

            CustomerDetailsWSUtilv2.customerDetails customerDetails = getCustomerDetailsFromJson(customerDetailsJSON);

            if(customerDetails != null) {

                Id serviceOperationsAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

             if (isExternalPlatform(customerDetails.sourceSys)) {

                 if (serviceOperationsAccountRecordTypeId != null) {

                     // We only want to select an existing account that is of the 'Service Operations' record type
                     List<Account> existingAccount = [SELECT Id FROM Account WHERE Acct_Row_Id__c = :customerDetails.acctRowId AND RecordTypeId = :serviceOperationsAccountRecordTypeId LIMIT 1];

                     Account serviceOperationsAccount = null;

                     if (existingAccount.size() > 0) {

                         serviceOperationsAccount = existingAccount[0];

                     } else {

                         serviceOperationsAccount = new Account();
                         accountNewToSalesforce = true;
                     }

                     if (customerDetails.customerSegmentation != null && (customerDetails.customerSegmentation).isNumeric()) {
                         serviceOperationsAccount.Customer_Segmentation__c = Integer.valueOf(customerDetails.customerSegmentation);
                     }

                     if (customerDetails.accountSts != null) {
                         if (customerDetails.accountSts.equalsIgnoreCase('A')) {
                             serviceOperationsAccount.Status__c = 'Active';
                         } else if (customerDetails.accountSts.equalsIgnoreCase('T')) {
                             serviceOperationsAccount.Status__c = 'Terminated';
                         } else if (customerDetails.accountSts.equalsIgnoreCase('S')) {
                             serviceOperationsAccount.Status__c = 'Suspended';
                         } //If we sent the full-word status, use it
                         else if (!(String.isEmpty(customerDetails.accountSts))) {
                             serviceOperationsAccount.Status__c = customerDetails.accountSts;
                         }
                     }

                     // Update all the fields of the account, if it didn't exist in Salesforce
                     if (accountNewToSalesforce) {
                         // Tie our account to a program in SFDC, if it exists
                         List<Program__c> programs = [SELECT Id FROM Program__c WHERE Siebel_Program_Row_Id__c = :customerDetails.programId];

                         if (programs.size() > 0) {
                             serviceOperationsAccount.Program__c = programs.get(0).Id;
                         } else {
                             serviceOperationsAccount.Program__c = genericProgram;
                         }

                         serviceOperationsAccount.Name = customerDetails.accountNm;
                         serviceOperationsAccount.RecordTypeId = serviceOperationsAccountRecordTypeId;
                         serviceOperationsAccount.Acct_Row_Id__c = customerDetails.acctRowId;
                         serviceOperationsAccount.Wex_Account__c = customerDetails.wexAccountNbr;
                         serviceOperationsAccount.Sponsor_Acct__c = customerDetails.spnrAccountNbr;
                         serviceOperationsAccount.PFS_REP__c = customerDetails.pfsRepNm;

                         if (customerDetails.priorityLevel != null) {
                             serviceOperationsAccount.Priority_Level__c = customerDetails.priorityLevel;
                             serviceOperationsAccount.Priority_Level_Update_Date__c = System.now();
                         }

                         if (customerDetails.funder != null) {
                             serviceOperationsAccount.Funder__c = customerDetails.funder;
                         }

                         serviceOperationsAccount.Platform__c = customerDetails.sourceSys;
                         serviceOperationsAccount.Online_Application_URL__c = customerDetails.onlineApplication;
                         serviceOperationsAccount.Account_Instructions__c = customerDetails.specialInstructions;

                         if (customerDetails.billingAddress != null) {
                             serviceOperationsAccount.BillingStreet = customerDetails.billingAddress.addr1;

                             if (customerDetails.billingAddress.addr2 != null) {
                                 serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr2;
                             }
                             if (customerDetails.billingAddress.addr3 != null) {
                                 serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr3;
                             }
                             if (customerDetails.billingAddress.addr4 != null) {
                                 serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr4;
                             }

                             serviceOperationsAccount.BillingCity = customerDetails.billingAddress.city;
                             serviceOperationsAccount.BillingState = customerDetails.billingAddress.state;
                             serviceOperationsAccount.BillingCountry = customerDetails.billingAddress.country;
                             serviceOperationsAccount.BillingPostalCode = customerDetails.billingAddress.postalCode;
                         }

                         if (customerDetails.mailingAddress != null) {
                             serviceOperationsAccount.ShippingStreet = customerDetails.mailingAddress.addr1;

                             if (customerDetails.billingAddress.addr2 != null) {
                                 serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr2;
                             }
                             if (customerDetails.billingAddress.addr3 != null) {
                                 serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr3;
                             }
                             if (customerDetails.billingAddress.addr4 != null) {
                                 serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr4;
                             }

                             serviceOperationsAccount.ShippingCity = customerDetails.mailingAddress.city;
                             serviceOperationsAccount.ShippingState = customerDetails.mailingAddress.state;
                             serviceOperationsAccount.ShippingCountry = customerDetails.mailingAddress.country;
                             serviceOperationsAccount.ShippingPostalCode = customerDetails.mailingAddress.postalCode;
                         }
                         //Only populate primary and billing contacts for Tandem
                         if (customerDetails.contacts != null && customerDetails.contacts.contacts.size() > 0) {
                             for (CustomerDetailsWSUtilv2.contact contact : customerDetails.contacts.contacts) {
                                 if (contact.role.equalsIgnoreCase('PRIMARY')) {
                                     serviceOperationsAccount.Primary_Contact_TXT__c = getContactRowId(contact.rowId);
                                 } else if (contact.role.equalsIgnoreCase('SHIPPING') && (!customerDetails.sourceSys.equalsIgnoreCase('TANDEM'))) {
                                     serviceOperationsAccount.Shipping_Contact_TXT__c = getContactRowId(contact.rowId);
                                 } else if (contact.role.equalsIgnoreCase('BILLING')) {
                                     serviceOperationsAccount.Billing_Contact_TXT__c = getContactRowId(contact.rowId);
                                 } else if (contact.role.equalsIgnoreCase('MAILING') && (!customerDetails.sourceSys.equalsIgnoreCase('TANDEM'))) {
                                     serviceOperationsAccount.Mailing_Contact_TXT__c = getContactRowId(contact.rowId);
                                 } else if (contact.role.equalsIgnoreCase('ADMIN') && (!customerDetails.sourceSys.equalsIgnoreCase('TANDEM'))) {
                                     serviceOperationsAccount.Admin_Contact_TXT__c = getContactRowId(contact.rowId);
                                 }
                             }
                         }
                     } //accountNewToSalesforce

                     //Upsert for convenience; if the account is new to Salesforce it will be an Insert, otherwise an Update but
                     //we only update segmentation and status.
                     upsert serviceOperationsAccount;

                     System.debug('### AcctId ' + serviceOperationsAccount.Id);

                     return serviceOperationsAccount.Id;

                 } else {

                     throw new customerDetailsException('Unable to find Service Operations record type when upserting account.');

                 }
             } else {
                 System.debug('*** Searching for OTR Account Id '+customerDetails.acctRowId + ' and recordTypeId='+serviceOperationsAccountRecordTypeId);
                 Account sourceAccount = [SELECT Id FROM Account WHERE Id =: customerDetails.acctRowId AND RecordTypeId =: serviceOperationsAccountRecordTypeId];
                 if (sourceAccount.Id != null) {
                     return sourceAccount.Id;
                 } else {
                     throw new customerDetailsException('Unable to parse customer details object while locating account.');
                 }
             }
            }

            else {

                throw new customerDetailsException('Unable to parse customer details object while upserting account.');

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to upsert account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    /**
     * Returns true for SIEBEL or TANDEM, False otherwise.
     *
     * @param platform
     *
     * @return boolean
     */
    private static Boolean isExternalPlatform(String platform) {
        return ('SIEBEL'.equalsIgnoreCase(platform) || 'TANDEM'.equalsIgnoreCase(platform));
    }

    public static String getContactRowId(String inStr) {
        String contactRowIdToUse = inStr;
        if (inStr.contains('#')) {
            contactRowIdToUse = inStr.split('#').get(0);
        }
        return contactRowIdToUse;
    }

    public static String initcap(String name) {
        String result = '';
        if (name == null || ''.equals(name.trim())) {
            result = name;
        } else {
            List<String> nameArray = name.split(' ');
            String newPart;
            for (String namePart : nameArray) {
                namePart = namePart.trim();
                if (!(''.equals(namePart))) {
                    Integer len = namePart.length();
                    newPart = namePart.left(1).toUpperCase() + namePart.right(len-1).toLowerCase();
                    result = result + newPart+' ';
                }
            }
        }
        return result.trim();
    }

    private static CustomerDetailsWSUtilv2.customerDetails getCustomerDetailsFromJson(String customerDetailsJSON) {
        CustomerDetailsWSUtilv2.customerDetails customerDetails = (CustomerDetailsWSUtilv2.customerDetails) JSON.deserialize(customerDetailsJSON, CustomerDetailsWSUtilv2.customerDetails.class);
        return customerDetails;
    }

    private static List<CustomerDetailsWSUtilv2.contact> getContactsFromJson(String customerContactsJSON) {
        System.debug('Entering getContactsFromJson: '+customerContactsJSON);
        List<CustomerDetailsWSUtilv2.contact> contacts = new List<CustomerDetailsWSUtilv2.contact>();
        try {
            contacts = (List<CustomerDetailsWSUtilv2.contact>) JSON.deserialize(customerContactsJSON, List<CustomerDetailsWSUtilv2.contact>.class);
        } catch (Exception e) {
            System.debug('Unable to parse contacts, returning empty list');
        }
        return contacts;
    }

    //We only call this in a test method now, to simplify data setup.
    @AuraEnabled
    public static Id upsertContacts(Id accountId, String customerContactsJSON, String contactRowId) {

        try {

            List<CustomerDetailsWSUtilv2.Contact> customerContacts = (List<CustomerDetailsWSUtilv2.Contact>)JSON.deserialize(customerContactsJSON, List<CustomerDetailsWSUtilv2.Contact>.class);

            // Get the record type for our desired contact type
            Id serviceOperationsContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            // Convert the list of contacts to a map for cleaner matching
            Map<String, Id> existingServiceOperationsContacts = new Map<String, Id>();
            for(Contact contact : [SELECT Id, WEX_Contact_Id__c FROM Contact WHERE AccountId =: accountId AND RecordTypeId =: serviceOperationsContactRecordTypeId]) {
                existingServiceOperationsContacts.put(contact.WEX_Contact_Id__c, contact.Id);
            }

            // New list collection for the contacts we're going to upsert
            List<Contact> updatedServiceOperationsContacts = new List<Contact>();

            // Iterate through our contacts list - then upsert
            for(CustomerDetailsWSUtilv2.Contact customerContact : customerContacts) {

                Contact contact = new Contact();

                if(existingServiceOperationsContacts != null && existingServiceOperationsContacts.containsKey(customerContact.RowId)) {
                    contact.Id = existingServiceOperationsContacts.get(customerContact.RowId);
                }

                contact.FirstName = customerContact.FirstNm;
                contact.LastName = customerContact.LastNm;

                if(checkEmailFormat(customerContact.EmailAddr)) {
                    System.debug('### Email is valid');
                    contact.Email = customerContact.EmailAddr;
                }
                contact.Fax = customerContact.FaxNbr;
                contact.Phone = customerContact.PhoneNbr;
                contact.WEX_Contact_ID__c = customerContact.RowId;
                contact.AccountId = accountId;
                contact.RecordTypeId = serviceOperationsContactRecordTypeId;
                contact.Contact_Type__c = customerContact.ContactType;

                System.debug('### ' + contact.WEX_Contact_Id__c);

                if(customerContact.address != null) {

                    contact.MailingStreet = customerContact.address.addr1;

                    if(customerContact.address.addr2 != null) {
                        contact.MailingStreet += '\n' + customerContact.address.addr2;
                    }
                    if(customerContact.address.addr3 != null) {
                        contact.MailingStreet += '\n' + customerContact.address.addr3;
                    }
                    if(customerContact.address.addr4 != null) {
                        contact.MailingStreet += '\n' + customerContact.address.addr4;
                    }

                    contact.MailingCity = customerContact.address.city;
                    contact.MailingState = customerContact.address.state;
                    contact.MailingCountry = customerContact.address.country;
                    contact.MailingPostalCode = customerContact.address.postalCode;

                }

                //Don't add this contact as we want to test new contact addition
                if (!(contact.WEX_Contact_ID__c.equals('1-1ZZZZX') && Test.isRunningTest())) {
                    updatedServiceOperationsContacts.add(contact);
                }


                // Avoid the threshold for upserts
                if(updatedServiceOperationsContacts.size() == 99) {
                    upsert updatedServiceOperationsContacts;
                    updatedServiceOperationsContacts = new List<Contact>();
                }

            }

            if(updatedServiceOperationsContacts.size() > 0) {
                upsert updatedServiceOperationsContacts;
            }

            List<Contact> focusedContact = [SELECT Id FROM Contact WHERE WEX_Contact_Id__c =: contactRowId AND Account.Id =: accountId AND RecordType.Name = 'Service Operations'];

            if(focusedContact.size() > 0) {

                return focusedContact[0].Id;

            }else { // Check against the defined dummy contacts
                return getDummyContactId(contactRowId);
            }
        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to upsert contacts. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    private static Id getDummyContactId(String contactRowId) {
        System.debug('Entering getDummyContactId for rowId '+contactRowId);
        Support_Operation_Settings__c sos = getSupportOperationsSettings();
        List<String> dummyContactList = new List<String>();
        dummyContactList.add(sos.ContactDriverRecordID__c);
        dummyContactList.add(sos.ContactMerchantRecordID__c);
        dummyContactList.add(sos.ContactAlternateBillingRecordID__c);
        dummyContactList.add(sos.ContactOnlineUserRecordID__c);
        dummyContactList.add(sos.ContactSalesRepRecordId__c);

        List<Contact> focusedContact = [SELECT Id FROM Contact WHERE WEX_Contact_Id__c = :contactRowId AND WEX_Contact_Id__c in :dummyContactList AND RecordType.Name = 'Service Operations'];
        if (focusedContact.size() > 0) {
            System.debug('getDummyContactId returns '+focusedContact[0].Id);
            return focusedContact[0].Id;
        } else {
            System.debug('getDummyContactId returns null');
            return null;
        }
    }

    @AuraEnabled
    public static String attachToCase(String caseId, String contactRowId, String customerDetailsJSON, String contactsJSON) {

        try {

            // Upsert the account (but not the contacts anymore)
            Id accountId = upsertAccount(customerDetailsJSON);

            Id contactId = getContactId(accountId, contactRowId);

            if (contactId == null && accountId != null && contactsJSON != null) {
                contactId = extractContactFromJSON(accountId, contactRowId, contactsJSON);
            }

            return innerAttachToCase(caseId, accountId, contactId, customerDetailsJSON);

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to attach to case. (Error Tracking Code: ' + errorCode + ')');

        }

    }
    //We could simplify this and go to just the single attachToCase method, but that's more than I want to change for
    //initial Account-Contact golive.  MHB 5/29/2019
    @AuraEnabled
    public static String attachDummyContactToCase(String caseId, String contactRowId, String customerDetailsJSON) {

        try {
            // Upsert the account and contacts
            Id accountId = upsertAccount(customerDetailsJSON);

            Id contactId = getDummyContactId(contactRowId);

            return innerAttachToCase(caseId, accountId, contactId, customerDetailsJSON);

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to attach generic contact to case. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    private static Id extractContactFromJSON(Id accountId, String contactRowId, String contactsJSON) {
        CustomerDetailsWSUtilv2.contact[] contacts = getContactsFromJson(contactsJSON);
        if (contacts == null || contacts.size() == 0)
            return null;

        String contactRowIdToUse = getContactRowId(contactRowId);
        Account account = [SELECT Id, Acct_Row_Id__c FROM Account WHERE Id =: accountId LIMIT 1];

        IntegrationRecord__c newContact;
        Id result = null;

        if (contacts != null && !(contacts.isEmpty())) {
            try {
                for (CustomerDetailsWSUtilv2.contact contact : contacts) {
                    String currentRowId = getContactRowId(contact.rowId);
                    if (contactRowIdToUse.equalsIgnoreCase(currentRowId)) {
                        System.debug('Matched rowId '+currentRowId);
                        newContact = new IntegrationRecord__c();
                        newContact.Contact_Row_Id__c = currentRowId;
                        newContact.Contact_Type__c = contact.role;
                        if (contact.emailAddr != null)
                            newContact.Email__c = contact.emailAddr.toLowerCase();
                        newContact.Fax__c = contact.faxNbr;
                        if (contact.firstNm != null)
                            newContact.First_Name__c = contact.firstNm.toLowerCase().capitalize();
                        if (contact.lastNm != null)
                            newContact.Last_Name__c = contact.lastNm.toLowerCase().capitalize();
                        if (contact.middleNm != null)
                            newContact.Middle_Name__c = contact.middleNm.toLowerCase().capitalize();
                        newContact.Phone__c = contact.phoneNbr;
                        newContact.Account__c = accountId;
                        newContact.Acct_Row_Id__c = account.Acct_Row_Id__c;
                        insert newContact;
                        System.debug('*** Inserted Integration Record '+newContact);
                        IntegrationRecord__c newRecord = [SELECT Id, Contact__c FROM IntegrationRecord__c WHERE Id =: newContact.Id];
                        result = newRecord.Contact__c;
                        System.debug('*** Returning result '+result);
                    }
                    if (result != null) {
                        break;
                    }
                }

            } catch (Exception e){
                System.debug('*** Error creating contact: '+e.getMessage());
                logError(e);
            }
        }
        return result;
    }

    private static String innerAttachToCase(String caseId, Id accountId, Id contactId, String customerDetailsJSON) {
        Id serviceOperationsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        Case serviceOperationsCase = new Case();

        serviceOperationsCase.RecordTypeId = serviceOperationsCaseRecordTypeId;
        //serviceOperationsCase.Status = 'Working';
        serviceOperationsCase.Status = 'Open';

        if (!String.isEmpty(caseId) && !caseId.equalsIgnoreCase('undefined')) {
            serviceOperationsCase.Id = (ID) caseId;
        }

        //todo: casts to (Id) below here are probably unnecessary since the parameters are declared as Id
        if (!String.isEmpty(accountId)) {
            List<Account> priorityLevels = [SELECT Id, Priority_Level__c FROM Account WHERE Id = :accountId];
            serviceOperationsCase.AccountId = (ID) accountId;
            if (priorityLevels.size() > 0) {
                serviceOperationsCase.Priority_Level__c = priorityLevels[0].Priority_Level__c;
            }

        }

        if (!String.isEmpty(contactId)) {
            serviceOperationsCase.ContactId = (Id) contactId;
        }

        try {
            if (!String.isEmpty(customerDetailsJSON)) {
                CustomerDetailsWSUtilv2.customerDetails customerDetails = getCustomerDetailsFromJson(customerDetailsJSON);
                if (customerDetails.funder != null)
                    serviceOperationsCase.Funder_Business_Unit__c  = customerDetails.funder;
                CustomerDetailsWSUtilv2.pdAsset asset = customerDetails.pdAsset;
                if (asset != null ) {
                    serviceOperationsCase.G_Tag__c = asset.custAssetNbr;
                    serviceOperationsCase.Region__c = asset.gsaRegion;
                    serviceOperationsCase.Vehicle_Card_No__c = asset.cardNbr;
                    serviceOperationsCase.VIN__c = asset.vin;
                }
            }
        } catch (Exception e) {
            logError(e);
        }

        upsert serviceOperationsCase;

        return serviceOperationsCase.Id;
    }

    @AuraEnabled
    public static Boolean checkEmailFormat(String emailAddress) {

        try {

            Pattern emailMatchingPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})');

            Matcher matcher = emailMatchingPattern.matcher(emailAddress);

            if (matcher.matches()) {
                return true;
            }

        }
        catch(Exception e) {

            System.debug(e);

        }

        return false;

    }

    private static Boolean isSalesforceId(String testId) {
        System.debug('Checking isSalesforceId for '+testId);
        if (String.isEmpty(testId))  {
            return false;
        }
        if (testId.length() != 15 && testId.length() != 18) {
            return false;
        }
        return (Pattern.matches('[A-Za-z0-9]+',testId));
    }

    private static String logError(Exception e) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Service Console - Customer Details';

            insert error;

            if (Test.isRunningTest()) {
                System.debug('*** ERROR: '+String.valueOf(e));
                System.debug('*** LOCATION: '+String.valueOf(e.getStackTraceString()));
                System.debug(e.getMessage());
                System.debug('Error at line: '+e.getLineNumber());
                System.debug('Type: '+e.getTypeName());
            }

            List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id = :error.Id];

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
}