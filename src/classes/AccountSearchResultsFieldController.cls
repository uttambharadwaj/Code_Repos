/**
 * Created by Sara Schmidt (WEX) on 12/27/2019.
 * Handles OTR account cloning and redirects when needed.
 */

public with sharing class AccountSearchResultsFieldController {
//    public class customerDetailsException extends Exception {}

    @AuraEnabled
    public static String cloneOTRAccountIfNeeded(String accountNumber, String accountRecordId) {

        try {

            if (String.isEmpty(accountNumber) && isSalesforceId(accountRecordId)) {
                Id serviceAccountId = ServiceOperationsAccountCloner.cloneAccountAndContacts(accountRecordId);

                System.debug('*** Account Cloner returns ID '+serviceAccountId + ' for OTR account '+accountRecordId);
                return serviceAccountId;

            } else {
                System.debug('*** Account not recognized as OTR account, continue without cloning');
            }

        }
        catch(Exception e) {

            if (Test.isRunningTest()) {
                throw e;
            } else {
                String errorCode = logError(e);
                throw new AuraHandledException('Unable to retrieve account details. (Error Tracking Code: ' + errorCode + ')');
            }
        }

        return accountRecordId;
    }

    /*
    private static String getAccountNumber(String accountRecordId) {

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

    private static List<CustomerDetailsWSUtilv2.contact> getCustomerContactsFromSalesforce(Id accountId, String primaryContactRowId) {
        System.debug('*** Called getCustomerContactsFromSalesforce with acct '+accountId + ' and primaryContact '+primaryContactRowId);
        List<Contact> rawContactList = [SELECT Id, Contact_Row_Id__c, WEX_Contact_ID__c, FirstName, LastName, Email, Fax, Phone, Contact_Type__c, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, AccountId  FROM Contact WHERE AccountId =: accountId];

        List<CustomerDetailsWSUtilv2.contact> contactList = new List<CustomerDetailsWSUtilv2.contact>();
        CustomerDetailsWSUtilv2.contact newContact;

        for (Contact rawContact : rawContactList) {
            newContact = new CustomerDetailsWSUtilv2.contact();
            //newContact.role = 'CONTACT'; //todo: i think this needs to be the id associated with the label
            System.debug('*** Contact row ID='+rawContact.WEX_Contact_ID__c);

            if (rawContact.WEX_Contact_ID__c != null && rawContact.WEX_Contact_ID__c.equals(primaryContactRowId)) {
                newContact.contactType = 'PRIMARY';
                newContact.role = 'PRIMARY'; //todo: i think this needs to be the id associated with the label
                System.debug('*** Assigned primary contact');
            }
            else {
                newContact.contactType = rawContact.Contact_Type__c;
            }

            //todo: i think this is unreachable due to the previous if/else
            if (newContact.contactType == null) {
                newContact.contactType = 'CONTACT';
            }

            newContact.emailAddr = rawContact.Email;
            newContact.faxNbr = rawContact.Fax;
            newContact.firstNm = rawContact.FirstName;
            newContact.lastNm = rawContact.LastName;
            newContact.phoneNbr = rawContact.Phone;
            newContact.rowId = rawContact.WEX_Contact_ID__c;
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
        return contactList;
    }

    private static CustomerDetailsWSUtilv2.customerDetails getOtrCustomerDetails(Id accountId) {
        Id serviceAccountId = ServiceOperationsAccountCloner.cloneAccountAndContacts(accountId);
        System.debug('*** Account Cloner returns ID '+serviceAccountId + ' for OTR account '+accountId);

        CustomerDetailsWSUtilv2.customerDetails customerDetails = new CustomerDetailsWSUtilv2.customerDetails();

        List<Account> serviceOperationsAccounts = [SELECT Id, Customer_Segmentation__c, CurrencyIsoCode, Status__c, Program__c, Name, Phone, Fax, Wex_Account__c, Sponsor_Acct__c, PFS_REP__c, Priority_Level__c, Priority_Level_Update_Date__c, Funder__c, Online_Application_URL__c, Account_Instructions__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Carrier_ID__c, Platform__c, Acct_Row_Id__c, Primary_Contact_TXT__c FROM Account WHERE Id =: serviceAccountId];

        if (!(serviceOperationsAccounts.isEmpty())) {
            Account serviceOperationsAccount = serviceOperationsAccounts.get(0);
            customerDetails.sfdcAcctId = serviceOperationsAccount.Id;

            customerDetails.customerSegmentation = String.valueOf(serviceOperationsAccount.Customer_Segmentation__c);
            if (serviceOperationsAccount.Status__c != null) {
                if ('Active'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'A';
                } else if ('Inactive'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'I';
                }  else if ('Suspended'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'S';
                }  else if ('Terminated'.equals(serviceOperationsAccount.Status__c)) {
                    customerDetails.accountSts = 'T';
                } else {
                    customerDetails.accountSts = serviceOperationsAccount.Status__c;
                }
            }
            customerDetails.programId = serviceOperationsAccount.Program__c;
            customerDetails.accountNm = serviceOperationsAccount.Name;

            customerDetails.wexAccountNbr = serviceOperationsAccount.Wex_Account__c;
            customerDetails.spnrAccountNbr = serviceOperationsAccount.Sponsor_Acct__c;
            customerDetails.acctRowId = serviceOperationsAccount.Acct_Row_Id__c;
            customerDetails.pfsRepNm = serviceOperationsAccount.PFS_REP__c;
            customerDetails.priorityLevel = serviceOperationsAccount.Priority_Level__c;
            customerDetails.funder = serviceOperationsAccount.Funder__c;
            customerDetails.onlineApplication = serviceOperationsAccount.Online_Application_URL__c;
            customerDetails.specialInstructions = serviceOperationsAccount.Account_Instructions__c;

            customerDetails.spnrAccountNbr = serviceOperationsAccount.Carrier_ID__c; //todo: is this correct? external account number
            //customerDetails.wexAccountNbr = serviceOperationsAccount.Carrier_ID__c; //todo: is this correct? internal account number

            customerDetails.sourceSys = serviceOperationsAccount.Platform__c;

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
            contacts.contacts = getCustomerContactsFromSalesforce(serviceAccountId, serviceOperationsAccount.Primary_Contact_TXT__c);
            customerDetails.contacts = contacts;
            for (CustomerDetailsWSUtilv2.contact contact : contacts.contacts) {
                if (contact.contactType.equalsIgnoreCase('PRIMARY')) {
                    customerDetails.primaryAddress = contact.address;
                }
            }
        }

            return customerDetails;
        }
     */

    private static Boolean isSalesforceId(String testId) {
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
            error.Application__c = 'Service Console - Account Search Results Field';

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