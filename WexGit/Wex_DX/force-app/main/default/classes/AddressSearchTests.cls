@isTest
public class AddressSearchTests {
	
    
    @testSetup
    static void setup(){
       UtilityTestLoader.setAutomation(false);
    }

    public static testmethod void testShippingAddressSearchController(){
        
        PageReference pageRef = Page.PrepareNewQuote;
        Test.setCurrentPage(pageRef);
        
        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Proposal', CloseDate = System.today());
        
        insert opp;
        
        Account acc = createAccount();
        insert acc;
        
        Wex__c wexSetting = createWexSetting();
        insert wexSetting;
        
        //Testing if ID is on controller
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        
        ApexPages.currentPage().getParameters().put('oppid', opp.Id);
        
        ApexPages.currentPage().getParameters().put('useSecondaryAccount', null);
        ApexPages.currentPage().getParameters().put('quoteid', null);
        
        ApexPages.currentPage().getParameters().put('AccountNumber', '001');
        
        Test.startTest();
        
        ShippingAddressSearchController shipAddressController = new ShippingAddressSearchController(sc);
        
        ApexPages.currentPage().getParameters().put('searchText', 'Name');
        
        shipAddressController = new ShippingAddressSearchController(sc);
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        shipAddressController.chosenSearchCriteria = 'Number';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        
        shipAddressController.chosenSearchCriteria = 'ContactFirst';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        shipAddressController.chosenSearchCriteria = 'ContactLast';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        shipAddressController.chosenSearchCriteria = 'Sponsor';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
       	shipAddressController.chosenSearchCriteria = 'Email';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        shipAddressController.chosenSearchCriteria = 'Phone';
        shipAddressController.searchShippingAccount();
        shipAddressController.searchAccount();
        
        Test.stopTest();
        
        System.assert(shipAddressController.opp == null);
        System.assert(shipAddressController.acc == null);
        System.assert(shipAddressController.initFailed != null);
        System.assert(shipAddressController.selectedAccountType == null);
        System.assert(shipAddressController.selectedAccount == null);
        System.assert(shipAddressController.selectedSubscription == null);
        System.assert(shipAddressController.selectedSubscriptionType  == null);
        System.assert(shipAddressController.selectedAmendmentType == null);
        System.assert(shipAddressController.billingAccountList == null);
        System.assert(shipAddressController.subscriptionList == null);
        
        System.assert(shipAddressController.inputValue == null);
        System.assert(shipAddressController.quote == null);
        System.assert(shipAddressController.contact == null);
        System.assert(shipAddressController.accountName == null);
        System.assert(shipAddressController.accountNumber == null);
        System.assert(shipAddressController.source == null);
        System.assert(shipAddressController.sponsor == null);
        System.assert(shipAddressController.shipment != null);
        
        System.assert(shipAddressController.accountNameBol == null);
        System.assert(shipAddressController.chosenSearchCriteria != null);
        System.assert(shipAddressController.searchText != null);
        System.assert(shipAddressController.L1AccountNumber != null);
        System.assert(shipAddressController.sfdcAccount != null);
        System.assert(shipAddressController.accountsList != null);
        System.assert(shipAddressController.shippingAccountsList != null);
        System.assert(shipAddressController.listEmpty != null);
        
    }
    
    public static testmethod void testAccountsearchPart2(){
        
        AccountsearchPart2.AccountSearchRequestRecordType accountSearchRequest = new AccountsearchPart2.AccountSearchRequestRecordType();
        
        AccountsearchPart2.WexGeneralFault_element genElement = new AccountsearchPart2.WexGeneralFault_element();
        
        AccountsearchPart2.AccountAddressType addressType = new AccountsearchPart2.AccountAddressType();
        addressType.AddressLine1 = '3535 Piedmont';
        addressType.AddressLine2 = 'Suite 310';
        addressType.City = 'Atlanta';
        addressType.State = 'GA';
        addressType.PostalCode = '30319';
        addressType.Country = 'USA';
        
        AccountsearchPart2.AccountContactType contactType = new AccountsearchPart2.AccountContactType();
        contactType.FirstName = '';
        contactType.LastName = '';
        contactType.Phone = '';
        contactType.Email = '';
        
        AccountsearchPart2.AccountSearchResponseRecordType accountSearchResponse = new AccountsearchPart2.AccountSearchResponseRecordType();
        accountSearchResponse.OrderingAccountNumber = '';
        accountSearchResponse.OrderingAccountName = '';    
        accountSearchResponse.Sponsor = '';
        accountSearchResponse.BillingAccountNumber = '';
        accountSearchResponse.BillingAccountName = '';
        accountSearchResponse.AccountSource = '';
        accountSearchResponse.CreditLimit = '';
        accountSearchResponse.AccountStatus = '';
        accountSearchResponse.AccountStatusChangeDate = '';
        accountSearchResponse.TaxExemptionStatus = '';
        
        AccountsearchPart2.AccountSearchRequestType requestType = new AccountsearchPart2.AccountSearchRequestType();
        
        AccountsearchPart2.AccountSearchRecords_element accSearchElement = new AccountsearchPart2.AccountSearchRecords_element();
        
        AccountsearchPart2.ShippingAccountRecords_element shippingSearchElement = new AccountsearchPart2.ShippingAccountRecords_element();
        
        AccountsearchPart2.ShippingAddressSearchResponseRecordType shippingAddressSearchResponseRecordType = new AccountsearchPart2.ShippingAddressSearchResponseRecordType();
    	shippingAddressSearchResponseRecordType.AccountNumber = '';
        shippingAddressSearchResponseRecordType.Sponsor = '';
        shippingAddressSearchResponseRecordType.AccountName = '';
        shippingAddressSearchResponseRecordType.AccountStatus = '';
        shippingAddressSearchResponseRecordType.AccountStatusChangeDate = '';
        shippingAddressSearchResponseRecordType.AccountSource = '';
        
        AccountsearchPart2.AccountSearchRequestRecordType accSearchRequestRecordType = new AccountsearchPart2.AccountSearchRequestRecordType();
    	
        AccountsearchPart2.ShippingAccountSearchResponseType shippingAccountSearchResponseType = new AccountsearchPart2.ShippingAccountSearchResponseType();
    
        AccountsearchPart2.ShippingAccountSearchRequestType shippingAccountSearchRequestType = new AccountsearchPart2.ShippingAccountSearchRequestType();
    
        AccountsearchPart2.AccountSearchResponseType accountSearchResponseType = new AccountsearchPart2.AccountSearchResponseType();
    
    }
    
    public static Account createAccount(){
        Account acc = new Account();
        
        acc.Name = 'Testing Account';
        acc.Wex_Account__c = '001';
        acc.Status__c = 'Active';
        acc.AccountNumber = '001';
        acc.Tax_Exempt__c = false;
        
        return acc;
    }
    
    public static Wex__c createWexSetting(){
        Wex__c w = new Wex__c();
        
        w.Account_Search_Endpoint__c = '';
        w.Shipping_Account_Search_Endpoint__c = '';
       	w.API_Timeout_ms__c = Decimal.valueOf('800.00');
        
        return w;
    }
    
}