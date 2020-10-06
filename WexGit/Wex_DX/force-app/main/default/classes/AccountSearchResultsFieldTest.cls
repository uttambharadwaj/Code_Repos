/**
 * Created by Sara Schmidt (WEX) on 1/7/2020.
 */
@istest
public with sharing class AccountSearchResultsFieldTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    // Happy path test with accountNumber passed in
    // Expect a new Service Operations account to be created
    static testMethod void cloneOTRAccountIfNeeded_createsNewAccount() {
        RecordType fleetAccountRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Fleet_Account' AND SobjectType = 'Account'];

        Account a = new Account(
                Name = 'Tests: cloneOTRAccountIfNeeded_accountNumber',
                RecordTypeId = fleetAccountRecordType.Id,
                Carrier_ID__c = '9876543210', Status__c = 'Active',
                BillingStreet = '75 Darling Avenue', BillingCity = 'South Portland', BillingState = 'ME', BillingCountry = 'United States', BillingPostalCode = '04106',
                ShippingStreet = '95 Darling Avenue', ShippingCity = 'South Portland', ShippingState = 'ME', ShippingCountry = 'United States', ShippingPostalCode = '04106',
                Platform__c = 'OTR' );
        insert a;

        Test.startTest();
        Id result = AccountSearchResultsFieldController.cloneOTRAccountIfNeeded(null, a.id);
        Test.stopTest();

        System.assert(result != a.id);
        System.assert(String.isNotBlank(result));

    }

    // Happy path test with accountRecordId passed in
    // Expect existing Service Operations account id to be returned
    static testMethod void cloneOTRAccountIfNeeded_doesNotCreateNewAccount() {
        RecordType fleetAccountRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Fleet_Account' AND SobjectType = 'Account'];
        RecordType serviceOperationsRecordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Service_Operations' AND SobjectType = 'Account'];

        Account a = new Account(
                Name = 'Tests: cloneOTRAccountIfNeeded_accountNumber',
                RecordTypeId = fleetAccountRecordType.Id,
                Carrier_ID__c = '11223344', Status__c = 'Active',
                BillingStreet = '75 Darling Avenue', BillingCity = 'South Portland', BillingState = 'ME', BillingCountry = 'United States', BillingPostalCode = '04106',
                ShippingStreet = '95 Darling Avenue', ShippingCity = 'South Portland', ShippingState = 'ME', ShippingCountry = 'United States', ShippingPostalCode = '04106',
                Platform__c = 'OTR' );
        insert a;

        Account b = new Account(
                Name = 'Tests: cloneOTRAccountIfNeeded_accountNumber',
                RecordTypeId = serviceOperationsRecordType.Id,
                Carrier_ID__c = '11223344', Status__c = 'Active',
                BillingStreet = '75 Darling Avenue', BillingCity = 'South Portland', BillingState = 'ME', BillingCountry = 'United States', BillingPostalCode = '04106',
                ShippingStreet = '95 Darling Avenue', ShippingCity = 'South Portland', ShippingState = 'ME', ShippingCountry = 'United States', ShippingPostalCode = '04106',
                Platform__c = 'OTR' );
        insert b;

        Test.startTest();
        Id result = AccountSearchResultsFieldController.cloneOTRAccountIfNeeded(null, b.id);
        Test.stopTest();

        System.assert(result != a.id);
        System.assert(result == b.id);
        System.assert(String.isNotBlank(result));

    }

    // Happy path test with accountRecordId passed in
    static testMethod void cloneOTRAccountIfNeeded_DoesntNeedClone() {
        Account a = new Account(
                Name = 'Tests: cloneOTRAccountIfNeeded_accountNumber',
                Account_Number__c = '01234567890',
                Carrier_ID__c = '11223344', Status__c = 'Active',
                BillingStreet = '75 Darling Avenue', BillingCity = 'South Portland', BillingState = 'ME', BillingCountry = 'United States', BillingPostalCode = '04106',
                ShippingStreet = '95 Darling Avenue', ShippingCity = 'South Portland', ShippingState = 'ME', ShippingCountry = 'United States', ShippingPostalCode = '04106',
                Platform__c = 'OTR' );
        insert a;

        Test.startTest();
        Id result = AccountSearchResultsFieldController.cloneOTRAccountIfNeeded(a.Account_Number__c, null);
        Test.stopTest();

        System.assert(String.isBlank(result));

    }
}