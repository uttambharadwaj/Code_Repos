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

        try {

            List<Case> cases = [SELECT Id FROM Case WHERE Account.Wex_Account__c =: accountNumber AND CreatedDate = TODAY AND RecordType.Name IN: caseTypesToDisplay];

            System.debug(cases.size());

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

        try {

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, toLabel(Status), LastModifiedDate, toLabel(Origin), Owner.Name, Department__c, RecordType.Name FROM Case WHERE Account.Wex_Account__c =: accountNumber AND RecordType.Name IN: caseTypesToDisplay ORDER BY LastModifiedDate DESC];

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

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, Status, LastModifiedDate, Origin, Owner.Name, Department__c, RecordType.Name FROM Case WHERE Account.Wex_Account__c =: accountNumber AND RecordType.Name IN: caseTypesToDisplay AND IsClosed = FALSE ORDER BY LastModifiedDate DESC LIMIT 5];
            System.debug('### getExistingOpenCases found '+cases.size());

            return cases;
        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.customerDetails getCustomerDetails(String accountNumber, String accountRecordId, String pdRowIdString) {

        try {

            if(String.isEmpty(accountNumber) && !String.isEmpty(accountRecordId)) {
                accountNumber = getAccountNumber(accountRecordId);
            }

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

            if (!String.isEmpty(pdRowIdString)) {
                customerDetailsRequest.pdRowId = pdRowIdString;
            }

            CustomerDetailsWSUtilv2.customerDetails customerDetails = customerDetailsCallout.getCustomerDetails(customerDetailsRequest);

            System.debug('### ' + customerDetails);

            if(String.isEmpty(customerDetails.pfsRepNm)) {
                customerDetails.pfsRepNm = 'N/A';
            }

            if(String.isEmpty(customerDetails.accountNm)) {
                throw new customerDetailsException('Unable to retrieve account information.');
            }

            return customerDetails;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account details. (Error Tracking Code: ' + errorCode + ')');

        }

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

            System.debug('### ' + authSearchResult);

            return authSearchResult.authLog;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent declined transactions. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.payments getPayments(String accountNumber, String sourceSys) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.payments payments = customerDetailsCallout.getPayments(accountNumber, sourceSys);

			//CustomerDetailsWSUtilv2.payments payments = CustomerDetailsController.getDummyPayments(accountNumber);

            System.debug('### ' + payments);

            return payments;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent payments. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.invoices getInvoices(String accountNumber, String sourceSys) {

        try {

            CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            System.debug('### CDS ' + CDS );

            // Some damage control - we don't want that value to be below the default threshold
            if(CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            CustomerDetailsWSUtilv2.invoices invoices = customerDetailsCallout.getInvoices(accountNumber, sourceSys);

            System.debug('### ' + invoices);

            return invoices;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve recent payments. (Error Tracking Code: ' + errorCode + ')');

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
    public static String getAccountNumber(String accountRecordId) {

        try {

            List<Account> serviceOperationsAccount = [SELECT Id, Wex_Account__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Id =: accountRecordId];

            if(serviceOperationsAccount.size() > 0) {

                return serviceOperationsAccount[0].Wex_Account__c;

            }
            else {

                throw new customerDetailsException('Unable to retrieve account number.');

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account number for given account ID. (Error Tracking Code: ' + errorCode + ')');

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
        try {
            String contactRowIdToUse = contactRowId;
            if (contactRowId.contains('#')) {
                contactRowIdToUse = contactRowId.split('#').get(0);
            }
            //todo: fix in downstream env
            //List<Contact> serviceOperationsContacts = [SELECT Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND Account.Id =: accountId AND WEX_Contact_Id__c =: contactRowId];
            //List<IntegrationRecord__c> serviceOperationsContacts = [SELECT Contact__r.ID FROM IntegrationRecord__c WHERE Contact_Row_ID__c =: contactRowIdToUse];

            List<Contact> serviceOperationsContacts = [SELECT Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND Account.Id =: accountId AND WEX_Contact_Id__c =: contactRowId];

            System.debug('### ' + serviceOperationsContacts);

            if(serviceOperationsContacts.size() > 0) {

                return serviceOperationsContacts[0].Id;
                //Future once integration records are implemented
                //return serviceOperationsContacts[0].Contact__r.ID;

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

                if(serviceOperationsAccountRecordTypeId != null) {

                    // We only want to select an existing account that is of the 'Service Operations' record type
                    List<Account> existingAccount = [SELECT Id FROM Account WHERE Wex_Account__c =: customerDetails.wexAccountNbr AND RecordTypeId =: serviceOperationsAccountRecordTypeId LIMIT 1];

                    Account serviceOperationsAccount = null;

                    if(existingAccount.size() > 0) {

                        serviceOperationsAccount = existingAccount[0];

                    }
                    else {

                        serviceOperationsAccount = new Account();
                        accountNewToSalesforce = true;
                    }

                    if(customerDetails.customerSegmentation != null && (customerDetails.customerSegmentation).isNumeric()) {
                        serviceOperationsAccount.Customer_Segmentation__c = Integer.valueOf(customerDetails.customerSegmentation);
                    }

                    // Update all the fields of the account, if it didn't exist in Salesforce
                    if (accountNewToSalesforce) {
                    // Tie our account to a program in SFDC, if it exists
                    List<Program__c> programs = [SELECT Id FROM Program__c WHERE Siebel_Program_Row_Id__c =: customerDetails.programId];

                    if(programs.size() > 0) {
                            serviceOperationsAccount.Program__c = programs.get(0).Id;
                    }
                    else {
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

                    if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('A')) {
                        serviceOperationsAccount.Status__c = 'Active';    
                    }
                    else if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('T')) {
                        serviceOperationsAccount.Status__c = 'Terminated';    
                    }
                    else if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('S')) {
                        serviceOperationsAccount.Status__c = 'Suspended';    
                        } //If we sent the full-word status, use it
                        else if(customerDetails.accountSts != null && !(String.isEmpty(customerDetails.accountSts))) {
                            serviceOperationsAccount.Status__c = customerDetails.accountSts;
                    }

                    serviceOperationsAccount.Platform__c = customerDetails.sourceSys;
                    serviceOperationsAccount.Online_Application_URL__c = customerDetails.onlineApplication;
                    serviceOperationsAccount.Account_Instructions__c = customerDetails.specialInstructions;

                    if(customerDetails.billingAddress != null) {
                        serviceOperationsAccount.BillingStreet = customerDetails.billingAddress.addr1;

                        if(customerDetails.billingAddress.addr2 != null) {
                            serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr2;
                        }
                        if(customerDetails.billingAddress.addr3 != null) {
                            serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr3;
                        }
                        if(customerDetails.billingAddress.addr4 != null) {
                            serviceOperationsAccount.BillingStreet += '\n' + customerDetails.billingAddress.addr4;
                        }

                        serviceOperationsAccount.BillingCity = customerDetails.billingAddress.city;
                        serviceOperationsAccount.BillingState = customerDetails.billingAddress.state;
                        serviceOperationsAccount.BillingCountry = customerDetails.billingAddress.country;
                        serviceOperationsAccount.BillingPostalCode = customerDetails.billingAddress.postalCode;
                    }

                    if(customerDetails.mailingAddress != null) {
                        serviceOperationsAccount.ShippingStreet = customerDetails.mailingAddress.addr1;

                        if(customerDetails.billingAddress.addr2 != null) {
                            serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr2;
                        }
                        if(customerDetails.billingAddress.addr3 != null) {
                            serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr3;
                        }
                        if(customerDetails.billingAddress.addr4 != null) {
                            serviceOperationsAccount.ShippingStreet += '\n' + customerDetails.mailingAddress.addr4;
                        }

                        serviceOperationsAccount.ShippingCity = customerDetails.mailingAddress.city;
                        serviceOperationsAccount.ShippingState = customerDetails.mailingAddress.state;
                        serviceOperationsAccount.ShippingCountry = customerDetails.mailingAddress.country;
                        serviceOperationsAccount.ShippingPostalCode = customerDetails.mailingAddress.postalCode;
                    }
                    } //accountNewToSalesforce

                    //Upsert for convenience; if the account is new to Salesforce it will be an Insert, otherwise an Update but
                    //we only update segmentation.
                    upsert serviceOperationsAccount;

                    System.debug('### AcctId ' + serviceOperationsAccount.Id);

                    return serviceOperationsAccount.Id;

                }
                else {

                    throw new customerDetailsException('Unable to find Service Operations record type when upserting account.');

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

    private static CustomerDetailsWSUtilv2.customerDetails getCustomerDetailsFromJson(String customerDetailsJSON) {
        CustomerDetailsWSUtilv2.customerDetails customerDetails = (CustomerDetailsWSUtilv2.customerDetails) JSON.deserialize(customerDetailsJSON, CustomerDetailsWSUtilv2.customerDetails.class);
        return customerDetails;
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

                updatedServiceOperationsContacts.add(contact);

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
    public static String attachToCase(String caseId, String contactRowId, String customerDetailsJSON) {

        try {

            // Upsert the account (but not the contacts anymore)
            Id accountId = upsertAccount(customerDetailsJSON);

            Id contactId = getContactId(accountId, contactRowId);

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

    private static String logError(Exception e) {

        try { 

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Service Console - Customer Details';

            insert error;

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