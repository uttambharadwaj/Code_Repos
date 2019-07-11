/**
 * Created by mbickford on 9/13/2018.
 */

public with sharing class Winter19Controller  {
    public class customerDetailsException extends Exception {}

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

        return 0;

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

            List<Case> cases = [SELECT Id, CaseNumber, Subject, Contact.Name, Status, LastModifiedDate, Owner.Name FROM Case WHERE Account.Wex_Account__c =: accountNumber AND RecordType.Name = 'Service Operations'];

            return cases;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve list of existing cases for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static CustomerDetailsWSUtilv2.customerDetails getCustomerDetails(String accountNumber, String accountRecordId) {

        CustomerDetailsWSUtilv2.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtilv2.getCustomerDetailsResponse();

        responseElement.return_x = new CustomerDetailsWSUtilv2.customerDetails();


            System.debug('### Winter19Controller: Calling getCustomerDetails for accountNumber '+accountNumber);


            if((accountNumber).equalsIgnoreCase('9100000000000')) {
                
                responseElement.return_x.accountNbrType = 'Internal';
                responseElement.return_x.accountNm = 'Wheel of Cheese of Idaho Inc';
                responseElement.return_x.accountSinceDt = (Datetime)JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountSts = 'A';
                responseElement.return_x.accountStsDt = (Datetime)JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountStatusReason = 'Active';
                responseElement.return_x.customerSegmentation = '3';
                responseElement.return_x.onlineApplication = 'WOL NP';
                responseElement.return_x.specialInstructions = 'THIS IS A TEST APPLICATION';
                responseElement.return_x.billingAccountId = '9100000000000';
                responseElement.return_x.billtoAccountNm = 'Wheel of Cheese of Idaho Inc';
                responseElement.return_x.driverCount = 99;
                responseElement.return_x.dIDLength = 4;
                responseElement.return_x.vehicleCount = 99;
                responseElement.return_x.salesRepCode = 'AB123123';
                responseElement.return_x.pfsRepNm = '000 - Tom';
                responseElement.return_x.srsCodeAndName = '00';
                responseElement.return_x.customerId = '4715696';
                responseElement.return_x.customerIdentifier = '4715696';
                responseElement.return_x.customerNm = 'Wheel of Cheese of Idaho Inc';
                responseElement.return_x.customerSinceDt = (Datetime)JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.daysToPay = 26;
                responseElement.return_x.programId = '1-12N3P99';
                responseElement.return_x.programNm = 'WEX DIRECT UNIVERSAL';
                responseElement.return_x.sourceSys = 'SIEBEL';
                responseElement.return_x.spnrAccountNbr = '0496000000000';
                responseElement.return_x.wexAccountNbr = '9100000000000';
                responseElement.return_x.description = 'Test account!';
            }
            else {

                responseElement.return_x.errorMsg = 'Could not find specified account!';
            }
            return responseElement.return_x;

    }

    @AuraEnabled
    public static List<CustomerDetailsWSUtilv2.contact> getCustomerContacts(String accountNumber) {

        try {
            CustomerDetailsWSUtilv2.contacts customerContactsResponse = dummyGetContacts(accountNumber);

            System.debug('### ' + customerContactsResponse);

            if(!String.isEmpty(customerContactsResponse.errorMsg)) {
                throw new customerDetailsException('Unable to retrieve account contacts.');
            }

            return customerContactsResponse.contacts;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve account contacts for account. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    private static CustomerDetailsWSUtilv2.contacts dummyGetContacts (String accountNumber) {
        CustomerDetailsWSUtilv2.getContactsResponse responseElement = new CustomerDetailsWSUtilv2.getContactsResponse();

        responseElement.return_x = new CustomerDetailsWSUtilv2.contacts();
        if((accountNumber).equalsIgnoreCase('9100000000000')) {

            CustomerDetailsWSUtilv2.contact contact = new CustomerDetailsWSUtilv2.contact();

            contact.role = 'Contact';
            contact.contactType = 'Contact';
            contact.emailAddr = 'test@wexinc.com';
            contact.faxNbr = '207-555-5555';
            contact.firstNm = 'Test';
            contact.middleNm = 'E';
            contact.lastNm = 'McTesterson';
            contact.phoneNbr = '207-555-5555';
            contact.rowId = '1-1ZZZZZ';

            CustomerDetailsWSUtilv2.address MailingAddress = new CustomerDetailsWSUtilv2.address();
            MailingAddress.addr1 = '123 Darling Ave';
            MailingAddress.addr2 = 'Filler';
            MailingAddress.addr3 = 'Filler';
            MailingAddress.addr4 = 'Filler';
            MailingAddress.city = 'South Portland';
            MailingAddress.state = 'ME';
            MailingAddress.country = 'US';
            MailingAddress.orgName = 'WEX';
            MailingAddress.postalCode = '04106';

            contact.address = MailingAddress;

            responseElement.return_x.contacts = new CustomerDetailsWSUtilv2.contact[]{};

            responseElement.return_x.contacts.add(contact);

            return responseElement.return_x;
        }
        else {
            responseElement.return_x.errorMsg = 'Could not find specified account!';

        }
        return responseElement.return_x;

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
    public static String getContactId(String accountId, String contactRowId) {

        try {

            List<Contact> serviceOperationsContacts = [SELECT Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND Account.Id =: accountId AND WEX_Contact_Id__c =: contactRowId];

            System.debug('### ' + serviceOperationsContacts);

            if(serviceOperationsContacts.size() > 0) {

                return serviceOperationsContacts[0].Id;

            }
            else {

                throw new customerDetailsException('Unable to retrieve contact ID.');

            }

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to retrieve contact ID. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static Id upsertAccount(String customerDetailsJSON) {

        try {

            CustomerDetailsWSUtilv2.customerDetails customerDetails = (CustomerDetailsWSUtilv2.customerDetails)JSON.deserialize(customerDetailsJSON, CustomerDetailsWSUtilv2.customerDetails.class);

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

                    }

                    // Tie our account to a program in SFDC, if it exists
                    List<Program__c> programs = [SELECT Id FROM Program__c WHERE Siebel_Program_Row_Id__c =: customerDetails.programId];

                    if(programs.size() > 0) {
                        serviceOperationsAccount.Program__c = programs[0].Id;
                    }
                    else {
                        serviceOperationsAccount.Program__c = genericProgram;
                    }

                    // Update all the fields of the account, even if it exists
                    serviceOperationsAccount.Name = customerDetails.accountNm;
                    serviceOperationsAccount.RecordTypeId = serviceOperationsAccountRecordTypeId;
                    serviceOperationsAccount.Acct_Row_Id__c = customerDetails.acctRowId;
                    serviceOperationsAccount.Wex_Account__c = customerDetails.wexAccountNbr;
                    serviceOperationsAccount.Sponsor_Acct__c = customerDetails.spnrAccountNbr;
                    serviceOperationsAccount.PFS_REP__c = customerDetails.pfsRepNm;

                    if(customerDetails.customerSegmentation != null && (customerDetails.customerSegmentation).isNumeric()) {
                        serviceOperationsAccount.Customer_Segmentation__c = Integer.valueOf(customerDetails.customerSegmentation);
                    }

                    if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('A')) {
                        serviceOperationsAccount.Status__c = 'Active';
                    }
                    else if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('T')) {
                        serviceOperationsAccount.Status__c = 'Terminated';
                    }
                    else if(customerDetails.accountSts != null && (customerDetails.accountSts).equalsIgnoreCase('S')) {
                        serviceOperationsAccount.Status__c = 'Suspended';
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

                    upsert serviceOperationsAccount;

                    System.debug('### AcctId ' + serviceOperationsAccount.Id);

                    return serviceOperationsAccount.Id;

                }
                else {

                    throw new customerDetailsException('Unable to find Serivce Operations record type when upserting account.');

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

                if(existingServiceOperationsContacts != null && existingServiceOperationsContacts.containsKey(customerContact.ContactType + '#' + customerContact.RowId)) {
                    contact.Id = existingServiceOperationsContacts.get(customerContact.ContactType + '#' + customerContact.RowId);
                }

                contact.FirstName = customerContact.FirstNm;
                contact.LastName = customerContact.LastNm;

                if(checkEmailFormat(customerContact.EmailAddr)) {
                    System.debug('### Email is valid');
                    contact.Email = customerContact.EmailAddr;
                }
                contact.Fax = customerContact.FaxNbr;
                contact.Phone = customerContact.PhoneNbr;
                contact.WEX_Contact_ID__c = customerContact.ContactType + '#' + customerContact.RowId;
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
                Support_Operation_Settings__c sos = getSupportOperationsSettings();
                List<String> dummyContactList = new List<String>();
                dummyContactList.add(sos.ContactDriverRecordID__c);
                dummyContactList.add(sos.ContactMerchantRecordID__c);
                dummyContactList.add(sos.ContactAlternateBillingRecordID__c);
                focusedContact = [SELECT Id FROM Contact WHERE WEX_Contact_Id__c =: contactRowId AND WEX_Contact_Id__c in :dummyContactList AND RecordType.Name = 'Service Operations'];
                if(focusedContact.size() > 0) {
                    return focusedContact[0].Id;
                } else {
                    return null;
                }
            }
        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to upsert contacts. (Error Tracking Code: ' + errorCode + ')');

        }

    }

    @AuraEnabled
    public static String attachToCase(String caseId, String contactRowId, String customerDetailsJSON, String customerContactsJSON) {

        try {

            // Upsert the account and contacts
            Id accountId = upsertAccount(customerDetailsJSON);

            Id contactId = upsertContacts(accountId, customerContactsJSON, contactRowId);

            Id serviceOperationsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Case serviceOperationsCase = new Case();

            serviceOperationsCase.RecordTypeId = serviceOperationsCaseRecordTypeId;
            //serviceOperationsCase.Status = 'Working';
            serviceOperationsCase.Status = 'Open';

            if(!String.isEmpty(caseId) && !caseId.equalsIgnoreCase('undefined')) {
                serviceOperationsCase.Id = (ID)caseId;
            }

            if(!String.isEmpty(accountId)) {
                serviceOperationsCase.AccountId = (ID)accountId;
            }

            if(!String.isEmpty(contactId)) {
                serviceOperationsCase.ContactId = (ID)contactId;
            }

            upsert serviceOperationsCase;

            return serviceOperationsCase.Id;

        }
        catch(Exception e) {

            String errorCode = logError(e);

            throw new AuraHandledException('Unable to attach to case. (Error Tracking Code: ' + errorCode + ')');

        }

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