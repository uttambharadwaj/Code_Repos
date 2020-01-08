/**
 * Created by W083158 on 11/21/2019.
 */

@IsTest
private class ServiceOperationsAccountClonerTest {
    @testSetup
    static void setupTestData() {
        UtilityTestLoader.setAutomation(false);

        Account otrAccount = new Account();

        Id fleetAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId();
        Id fleetContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();

        Account parentOtrAccount = new Account();
        parentOtrAccount.Customer_Segmentation__c = 0;
        parentOtrAccount.CurrencyIsoCode = 'USD';
        parentOtrAccount.Status__c = 'Active';
        parentOtrAccount.Name = 'Test Parent Account';
        parentOtrAccount.BillingStreet = '1 Hancock St';
        parentOtrAccount.BillingCity = 'Portland';
        parentOtrAccount.BillingState = 'ME';
        parentOtrAccount.BillingCountry = 'USA';
        parentOtrAccount.BillingPostalCode = '04101';
        parentOtrAccount.ShippingStreet = '97 Darling Ave';
        parentOtrAccount.ShippingCity = 'S Portland';
        parentOtrAccount.ShippingState = 'ME';
        parentOtrAccount.ShippingCountry = 'USA';
        parentOtrAccount.ShippingPostalCode = '04106';
        parentOtrAccount.RecordTypeId = fleetAccountRecordTypeId;

        otrAccount.Carrier_ID__c = '123457';

        insert parentOtrAccount;
        Id parentOtrAccountId = parentOtrAccount.Id;

        otrAccount.Customer_Segmentation__c = 0;
        otrAccount.CurrencyIsoCode = 'USD';
        otrAccount.Status__c = 'Active';
        otrAccount.Name = 'Test Account';
        otrAccount.BillingStreet = '1 Hancock St';
        otrAccount.BillingCity = 'Portland';
        otrAccount.BillingState = 'ME';
        otrAccount.BillingCountry = 'USA';
        otrAccount.BillingPostalCode = '04101';
        otrAccount.ShippingStreet = '97 Darling Ave';
        otrAccount.ShippingCity = 'S Portland';
        otrAccount.ShippingState = 'ME';
        otrAccount.ShippingCountry = 'USA';
        otrAccount.ShippingPostalCode = '04106';
        otrAccount.RecordTypeId = fleetAccountRecordTypeId;
        otrAccount.ParentId = parentOtrAccountId;

        otrAccount.Carrier_ID__c = '123456';

        insert otrAccount;

        Id otrAccountId = otrAccount.Id;

        Contact otrContact = new Contact();
        otrContact.RecordTypeId = fleetContactRecordTypeId;
        otrContact.FirstName = 'Generic';
        otrContact.LastName = 'Boss';
        otrContact.Phone = '207-773-8171';
        otrContact.AccountId = otrAccountId;
        insert otrContact;
    }


    @IsTest
    static void testBehavior() {
        List<Account> otrAccounts = [SELECT Id FROM Account WHERE RecordType.Name = 'Fleet Account' AND Carrier_ID__c = '123456'];
        List<Id> otrAccountIds = new List<Id>();
        for (Account account : otrAccounts) {
            otrAccountIds.add(account.Id);
        }
        List<Id> serviceAccountIds = ServiceOperationsAccountCloner.cloneAccountAndContacts(otrAccountIds);
        System.assert(!(serviceAccountIds.isEmpty()), 'No Service Accounts Returned');
        Integer i=0;
        Boolean triedToCloneServiceAccount = false;
        for (Id serviceId : serviceAccountIds) {
            Account serviceAccount = [SELECT Id, Acct_Row_Id__c, Carrier_ID__c, Name, Phone, Fax, CurrencyIsoCode,  Status__c,  BillingStreet,  BillingCity,  BillingState,  BillingCountry,  BillingPostalCode,  ShippingStreet,  ShippingCity,  ShippingState,  ShippingCountry,  ShippingPostalCode FROM Account WHERE Id =: serviceId];
            Id otrAccountId = otrAccountIds.get(i);
            Account otrAccount = [SELECT Id, Acct_Row_Id__c, Carrier_ID__c, Name, Phone, Fax, CurrencyIsoCode,  Status__c,  BillingStreet,  BillingCity,  BillingState,  BillingCountry,  BillingPostalCode,  ShippingStreet,  ShippingCity,  ShippingState,  ShippingCountry,  ShippingPostalCode FROM Account WHERE Id =: otrAccountId];

            System.assertNotEquals(null, otrAccount, 'OTR Account was null for Id '+otrAccountId);
            System.assertEquals(serviceAccount.Id, serviceAccount.Acct_Row_Id__c);
            System.assertEquals(otrAccount.Carrier_ID__c, serviceAccount.Carrier_ID__c);
            System.assertEquals(otrAccount.Name, serviceAccount.Name);
            System.assertEquals(otrAccount.Phone, serviceAccount.Phone);
            System.assertEquals(otrAccount.Fax, serviceAccount.Fax);
            System.assertEquals(otrAccount.CurrencyIsoCode, serviceAccount.CurrencyIsoCode);
            System.assertEquals(otrAccount.Status__c, serviceAccount.Status__c);
            System.assertEquals(otrAccount.BillingStreet, serviceAccount.BillingStreet);
            System.assertEquals(otrAccount.BillingCity, serviceAccount.BillingCity);
            System.assertEquals(otrAccount.BillingState, serviceAccount.BillingState);
            System.assertEquals(otrAccount.BillingCountry, serviceAccount.BillingCountry);
            System.assertEquals(otrAccount.BillingPostalCode, serviceAccount.BillingPostalCode);
            System.assertEquals(otrAccount.ShippingStreet, serviceAccount.ShippingStreet);
            System.assertEquals(otrAccount.ShippingCity, serviceAccount.ShippingCity);
            System.assertEquals(otrAccount.ShippingState, serviceAccount.ShippingState);
            System.assertEquals(otrAccount.ShippingCountry, serviceAccount.ShippingCountry);
            System.assertEquals(otrAccount.ShippingPostalCode, serviceAccount.ShippingPostalCode);
            i++;

            if (!triedToCloneServiceAccount) {
                List<Id> tempAccountIds = new List<Id>();
                tempAccountIds.add(serviceId);
                List<Id> failedCloneIds = ServiceOperationsAccountCloner.cloneAccountAndContacts(tempAccountIds);
                triedToCloneServiceAccount = true;
                System.assertEquals(tempAccountIds.size(), failedCloneIds.size());
                Integer j=0;
                for (Id tempId : tempAccountIds) {
                    System.assertEquals(failedCloneIds.get(j), tempId);
                    j++;
                }
            }
        }
    }

    @IsTest
    static void testExceptionHandler() {
        Id testId = null;
        List<Id> otrAccountIds = new List<Id>();
        otrAccountIds.add(testId);
        List<Id> serviceAccountIds = ServiceOperationsAccountCloner.cloneAccountAndContacts(otrAccountIds);
        System.assertNotEquals(null, serviceAccountIds);
        System.assertEquals(1, serviceAccountIds.size());
        System.assertEquals(null, serviceAccountIds.get(0));
    }

    @IsTest
    static void testNullResult() {
        List<Id> otrAccountIds = new List<Id>();
        List<Id> serviceAccountIds = ServiceOperationsAccountCloner.cloneAccountAndContacts(otrAccountIds);
        System.assertEquals(serviceAccountIds, null);
    }
}