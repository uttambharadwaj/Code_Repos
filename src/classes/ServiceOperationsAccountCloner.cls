/**
 * Created by W083158 on 11/21/2019.
 */

global with sharing class ServiceOperationsAccountCloner {

    //todo: Proper exception handling throughout
    static Id serviceOperationsAccountRecordTypeId;
    static Id serviceOperationsContactRecordTypeId;

    public static void init() {
        if (serviceOperationsAccountRecordTypeId == null) {
            serviceOperationsAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
        }

        if (serviceOperationsContactRecordTypeId == null) {
            serviceOperationsContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
        }
    }


    @InvocableMethod(Label='CloneAccountAndContacts' Description='Param is Sales Account ID')
    public static List<Id> cloneAccountAndContacts(List<Id> otrAccountIds) {
        List<Id> result = new List<Id>();
        if (otrAccountIds == null || otrAccountIds.isEmpty()) {
            return null;
        } else {
            for (Id otrAccountId : otrAccountIds) {
                Id serviceOperationsAccountId = cloneAccountAndContacts(otrAccountId);
                result.add(serviceOperationsAccountId);
            }
        }
        return result;
    }

    @AuraEnabled
    public static Id cloneAccountAndContacts(Id otrAccountId) {
        System.debug('*** Entering ServiceOperationsAccountCloner.cloneAccountAndContacts for Id: ' + otrAccountId);
        Id serviceOperationsAccountId;
        try {
            serviceOperationsAccountId = cloneAccount(otrAccountId);

            //bugfix - contacts are duplicated each time this function is called, need to check for contacts first
            List<Contact> existingServiceOperationsAccountContacts = [SELECT Id, Contact_Type__c  FROM Contact WHERE AccountId =: serviceOperationsAccountId];
            if(!existingServiceOperationsAccountContacts.isEmpty()){
                System.debug('*** Service Operations account contacts already exist for serviceOperationsAccountId: ' + serviceOperationsAccountId + ', returning without copying contacts.');
                return serviceOperationsAccountId;
            }

            List<Contact> contactList = [SELECT Id, Contact_Type__c  FROM Contact WHERE AccountId =: otrAccountId];

            if (contactList.isEmpty()){
                System.debug('*** OTR account contacts do not exist for otrAccountId: ' + otrAccountId + ', no contacts cloned for serviceOperationsAccountId:'+ serviceOperationsAccountId +'. Returning without copying contacts.');
                return serviceOperationsAccountId;
            }

            List<Id> newContacts = new List<Id>();

            for (Contact contact : contactList) {
                Id newId = cloneContact(contact.Id, serviceOperationsAccountId);
                newContacts.add(newId);
            }

        } catch (Exception e) {
            String errorCode = logError(e);
            System.debug('*** ERROR Occurred while cloning account '+otrAccountId+': ' + errorCode);
        }
        return serviceOperationsAccountId;
    }

    public static Id cloneAccount(Id otrAccountId) {
        init();
        Id serviceOperationsAccountId;
        try {
            Account otrAccount =  [SELECT Id, Customer_Segmentation__c, CurrencyIsoCode, Status__c, Program__c, Name, Phone, Fax, RecordTypeId, Acct_Row_Id__c, Wex_Account__c, Sponsor_Acct__c, ParentId, PFS_REP__c, Priority_Level__c, Priority_Level_Update_Date__c, Funder__c, Platform__c, Line_of_Business__c, Online_Application_URL__c, Account_Instructions__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Primary_Contact_TXT__c, Shipping_Contact_TXT__c, Billing_Contact_TXT__c, Mailing_Contact_TXT__c, Admin_Contact_TXT__c, Carrier_ID__c, Member_ID__c, EDGE_Account_Number__c FROM Account WHERE Id =:otrAccountId LIMIT 1];

            if (serviceOperationsAccountRecordTypeId.equals(otrAccount.RecordTypeId)) //already cloned.
            {
                System.debug('*** Service Operations account already exists, serviceOperationsAccountId: ' + otrAccount + ', returning without cloning account.');
                return otrAccountId;
            }

            List<Sales_to_Service_Account_Relationship__c> serviceIdList = [SELECT Service_Account__c FROM Sales_to_Service_Account_Relationship__c WHERE Sales_Account__c =: otrAccountId];
            if (!(serviceIdList.isEmpty())) {
                return serviceIdList[0].Service_Account__c;
            }

            String carrierId = otrAccount.Carrier_ID__c;
            if(carrierId != null && (carrierId.startsWith('9999') ||
                    carrierId.startsWith('9998') ||
                    carrierId.startsWith('4500') ||
                    carrierId.startsWith('4000'))){
                carrierId = carrierId.substring(4);
            }
            System.debug('*** CarrierId - 2: ' + carrierId);
            Account serviceOperationsAccount = new Account();

            System.debug('*** serviceOperationsAccountRecordTypeId='+serviceOperationsAccountRecordTypeId);

            if (serviceOperationsAccountRecordTypeId != null) {
                serviceOperationsAccount.RecordTypeId = serviceOperationsAccountRecordTypeId;
            }

            serviceOperationsAccount.Customer_Segmentation__c = otrAccount.Customer_Segmentation__c;
            serviceOperationsAccount.CurrencyIsoCode = otrAccount.CurrencyIsoCode;
            String status = otrAccount.Status__c;
            status = status != null ? status.remove('Member') : '';
            serviceOperationsAccount.Status__c = status;
            serviceOperationsAccount.Program__c = otrAccount.Program__c;
            serviceOperationsAccount.Name = otrAccount.Name;
            serviceOperationsAccount.Phone = otrAccount.Phone;
            serviceOperationsAccount.Fax = otrAccount.Fax;
            serviceOperationsAccount.Sponsor_Acct__c = carrierId;
            serviceOperationsAccount.Member_ID__c = otrAccount.Member_ID__c;
            serviceOperationsAccount.EDGE_Account_Number__c = otrAccount.EDGE_Account_Number__c;
            serviceOperationsAccount.PFS_REP__c = otrAccount.PFS_REP__c;
            serviceOperationsAccount.Priority_Level__c = otrAccount.Priority_Level__c;
            serviceOperationsAccount.Priority_Level_Update_Date__c = otrAccount.Priority_Level_Update_Date__c;
            serviceOperationsAccount.Funder__c = otrAccount.Funder__c;
            serviceOperationsAccount.Online_Application_URL__c = otrAccount.Online_Application_URL__c;
            serviceOperationsAccount.Account_Instructions__c = otrAccount.Account_Instructions__c;
            serviceOperationsAccount.BillingStreet = otrAccount.BillingStreet;
            serviceOperationsAccount.BillingCity = otrAccount.BillingCity;
            serviceOperationsAccount.BillingState = otrAccount.BillingState;
            serviceOperationsAccount.BillingCountry = otrAccount.BillingCountry;
            serviceOperationsAccount.BillingPostalCode = otrAccount.BillingPostalCode;
            serviceOperationsAccount.ShippingStreet = otrAccount.ShippingStreet;
            serviceOperationsAccount.ShippingCity = otrAccount.ShippingCity;
            serviceOperationsAccount.ShippingState = otrAccount.ShippingState;
            serviceOperationsAccount.ShippingCountry = otrAccount.ShippingCountry;
            serviceOperationsAccount.ShippingPostalCode = otrAccount.ShippingPostalCode;

            //todo: determine other source fields to copy
            serviceOperationsAccount.Platform__c = ( otrAccount.Platform__c != null ? otrAccount.Platform__c : otrAccount.Line_of_Business__c);

            if (otrAccount.ParentId != null) {
                Id parentAccountId = cloneAccount(otrAccount.ParentId); //ooooh recursion!
                serviceOperationsAccount.ParentId = parentAccountId;
            }
            insert serviceOperationsAccount;

            serviceOperationsAccountId = serviceOperationsAccount.Id;

            serviceOperationsAccount.Acct_Row_Id__c = serviceOperationsAccountId;
            update serviceOperationsAccount;

            createSalesToServiceJunction(otrAccountId, serviceOperationsAccountId, otrAccount.CurrencyIsoCode);
        } catch (Exception e) {
            String errorCode = logError(e);
            System.debug('*** ERROR Occurred: '+errorCode);
        }

        return serviceOperationsAccountId;

    }

    public static Id createSalesToServiceJunction(Id otrAccountId, Id serviceAccountId, String currencyIsoCode) {
        Sales_to_Service_Account_Relationship__c junctionObject = new Sales_to_Service_Account_Relationship__c();
        try {
            junctionObject.Sales_Account__c = otrAccountId;
            junctionObject.Service_Account__c = serviceAccountId;
            junctionObject.CurrencyIsoCode = currencyIsoCode;
            insert junctionObject;
        } catch (Exception e) {
            String errorCode = logError(e);
            System.debug('*** ERROR Occurred: in createSalesToServiceJunction '+errorCode);
            e.setMessage('Unable to create Sales to Service Junction; '+e.getMessage());
            throw e;
        }
        return junctionObject.Id;
    }

    public static Id cloneContact(Id otrContactId, Id serviceOperationsAccountId) {
        System.debug('*** Entering ServiceOperationsAccountCloner.cloneContact for otrContactId: '+ otrContactId +' and serviceOperationsAccountId: '+serviceOperationsAccountId);
        init();
        Contact otrContact = [SELECT Id, FirstName, LastName, Email, Fax, Phone, WEX_Contact_ID__c, AccountId, RecordTypeId, Contact_Type__c, Line_of_Business__c, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode FROM Contact WHERE Id =: otrContactId];

        Contact serviceOperationsContact = new Contact();
        Id serviceOperationsContactId;

        try {
            if (serviceOperationsContactRecordTypeId != null) {
                //seems redundant since variable has been referenced twice already
                serviceOperationsContact.RecordTypeId = serviceOperationsContactRecordTypeId;
            }

            serviceOperationsContact.FirstName = otrContact.FirstName;
            serviceOperationsContact.LastName = otrContact.LastName;
            serviceOperationsContact.Email = otrContact.Email;
            serviceOperationsContact.Fax = otrContact.Fax;
            serviceOperationsContact.Phone = otrContact.Phone;
            serviceOperationsContact.Contact_Type__c = otrContact.Contact_Type__c;
            if (String.isEmpty(serviceOperationsContact.Contact_Type__c)) {
                serviceOperationsContact.Contact_Type__c = 'CONTACT';
            }
            serviceOperationsContact.MailingStreet = otrContact.MailingStreet;
            serviceOperationsContact.MailingCity = otrContact.MailingCity;
            serviceOperationsContact.MailingState = otrContact.MailingState;
            serviceOperationsContact.MailingCountry = otrContact.MailingCountry;
            serviceOperationsContact.MailingPostalCode = otrContact.MailingPostalCode;

            serviceOperationsContact.AccountId = serviceOperationsAccountId;

            insert serviceOperationsContact;
            System.debug('*** Inserted serviceOperationsContact with Id '+ serviceOperationsContact.Id);
            serviceOperationsContactId = serviceOperationsContact.Id;

            //serviceOperationsContact.WEX_Contact_ID__c = serviceOperationsContactId; //this is used to store an external id like siebel contact id
            serviceOperationsContact.Contact_Row_Id__c = serviceOperationsContactId;

            update serviceOperationsContact;
            System.debug('*** Updated serviceOperationsContact with Id '+ serviceOperationsContact.Id);

            IntegrationRecord__c integrationRecord = new IntegrationRecord__c();
            integrationRecord.First_Name__c = serviceOperationsContact.FirstName;
            integrationRecord.Last_Name__c = serviceOperationsContact.LastName;
            integrationRecord.Email__c = serviceOperationsContact.Email;
            integrationRecord.Fax__c = serviceOperationsContact.Fax;
            integrationRecord.Phone__c = serviceOperationsContact.Phone;
            integrationRecord.Contact_Type__c = serviceOperationsContact.Contact_Type__c;
            integrationRecord.Account__c = serviceOperationsContact.AccountId;
            //integrationRecord.Contact_Row_Id__c = serviceOperationsContact.WEX_Contact_ID__c;
            integrationRecord.Contact_Row_Id__c = serviceOperationsContact.Contact_Row_Id__c;

            insert integrationRecord;
            System.debug('*** Inserted integrationRecord with Id '+ integrationRecord.Id);

        } catch (Exception e) {
            String errorCode = logError(e);
            System.debug('*** ERROR Occurred: in cloneContact '+errorCode);
            e.setMessage('Error cloning contact '+otrContactId + '; '+e.getMessage());
            throw e;
        }

        return serviceOperationsContactId;
    }

    private static String logError(Exception e) {

        try {
            System.debug('*** ERROR: '+e.getMessage());
            System.debug('***   : '+String.valueOf(e));
            System.debug('***   Line #: '+e.getLineNumber());
            System.debug('***   Cause: '+e.getCause());
            System.debug('*** '+String.valueOf(e.getStackTraceString()));
            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Fleet Account Cloning';

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

            System.debug('Error logging exception.. Skipping..' + String.valueOf(f));

            return '';

        }
    }

}