@IsTest
public class AccountSearchControllerTest {

	@testSetup
	static void setup(){
	   UtilityTestLoader.setAutomation(false);

		//OTR data
		Account otrAccount = new Account();

		Id serviceOpsAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
		Id serviceOpsContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

		Account parentOtrAccount = new Account();
		parentOtrAccount.Customer_Segmentation__c = 0;
		parentOtrAccount.CurrencyIsoCode = 'USD';
		parentOtrAccount.Status__c = 'Active';
		parentOtrAccount.Name = 'Test Parent Account';
		parentOtrAccount.Phone = '207-775-4321';
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
		parentOtrAccount.RecordTypeId = serviceOpsAccountRecordTypeId;

		parentOtrAccount.Sponsor_Acct__c = '123457';
		parentOtrAccount.Acct_Row_Id__c = 'EFSLLC-123457';

		insert parentOtrAccount;
		Id parentOtrAccountId = parentOtrAccount.Id;

		otrAccount.Customer_Segmentation__c = 0;
		otrAccount.CurrencyIsoCode = 'USD';
		otrAccount.Status__c = 'X';
		otrAccount.Name = 'Test Account';
		otrAccount.Phone = '207-523-7171';
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
		otrAccount.RecordTypeId = serviceOpsAccountRecordTypeId;
		otrAccount.ParentId = parentOtrAccountId;
		otrAccount.Acct_Row_Id__c = 'EFSLLC-123456';

		otrAccount.Sponsor_Acct__c = '123456';

		insert otrAccount;

		Id otrAccountId = otrAccount.Id;

		Contract__c otrContract = new Contract__c();
		otrContract.Account__c = otrAccountId;
		otrContract.Status__c = 'A';
		otrContract.Name = '777777';
		otrContract.AR_Number__c = '0001234567890';

		insert otrContract;

		Contact otrContact = new Contact();
		otrContact.RecordTypeId = serviceOpsContactRecordTypeId;
		otrContact.FirstName = 'Generic';
		otrContact.LastName = 'Boss';
		otrContact.Phone = '207-773-8171';
		otrContact.AccountId = otrAccountId;
		otrContact.Contact_Type__c = 'PRIMARY';
		insert otrContact;
		Id otrContactId = otrContact.Id;
		otrContact.Contact_Row_Id__c = otrContactId;
		update otrContact;

	}

	@IsTest
	static void testController() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper = AccountSearchController.searchServ('ACCTNM', 'test acct');

		Test.stopTest();

		System.assertEquals(3, resultsWrapper.results.size());
	}

	@IsTest
	static void testControllerForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Carrier_ID', '123');

		Test.stopTest();

		System.assertEquals(0, resultsWrapper2.results.size());
	}

	@IsTest
	static void testCarrierIdSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Carrier_ID', '123456');

		Test.stopTest();

		System.assertEquals(1, resultsWrapper2.results.size());
	}

	@IsTest
	static void testCarrierIdWildcardSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Carrier_ID', '12345*');

		Test.stopTest();

		System.assertEquals(2, resultsWrapper2.results.size());
	}

	@IsTest
	static void testARNumberSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('AR_Number', '0001234567890');

		Test.stopTest();

		System.assertEquals(1, resultsWrapper2.results.size());
	}

	@IsTest
	static void testARNumberWildcardSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('AR_Number', '0001234*');

		Test.stopTest();

		System.assertEquals(1, resultsWrapper2.results.size());
	}

	@IsTest
	static void testAccountNameSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Account_Name_OTR', 'Test Account');

		Test.stopTest();

		System.assertEquals(1, resultsWrapper2.results.size());
	}

	@IsTest
	static void testAccountNameWildcardSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Account_Name_OTR', 'Test*');

		Test.stopTest();

		System.assertEquals(2, resultsWrapper2.results.size());
	}

	@IsTest
	static void testAccountPhoneSearchForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Account_Phone_OTR', '2075237171');

		Test.stopTest();

		System.assertEquals(1, resultsWrapper2.results.size());
	}

	@IsTest
	static void testUnimplementedSearchesForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper = AccountSearchController.searchServ('Money_Code', '2075237171');

		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Check_Number', '0000012345');

		Test.stopTest();

		System.assertEquals(0, resultsWrapper.results.size());
		System.assert(resultsWrapper.errorMessage.length() > 0);

		System.assertEquals(0, resultsWrapper2.results.size());
		System.assert(resultsWrapper2.errorMessage.length() > 0);
	}

	public class MockResponseGenerator implements WebServiceMock {

		public void doInvoke(
		                     Object stub,
		                     Object request,
		                     Map<String, Object> response,
		                     String endpoint,
		                     String soapAction,
		                     String requestName,
		                     String responseNS,
		                     String responseName,
		                     String responseType) {
			AccountSearchTypes.accountSearchResponse res = new AccountSearchTypes.accountSearchResponse();
			AccountSearchTypes.accountSearchResult result = new AccountSearchTypes.accountSearchResult();
			AccountSearchTypes.AccountSearchDTO dto1 = new AccountSearchTypes.AccountSearchDTO();
			dto1.AcctNm = 'test acct1';
			AccountSearchTypes.AccountSearchDTO dto2 = new AccountSearchTypes.AccountSearchDTO();
			dto2.AcctNm = 'test acct2';
			AccountSearchTypes.AccountSearchDTO dto3 = new AccountSearchTypes.AccountSearchDTO();
			dto3.AcctNm = 'test acct3';
			dto3.spnrAcctNbr = '123';
			List<AccountSearchTypes.AccountSearchDTO> dtoList = new List<AccountSearchTypes.AccountSearchDTO> ();
			dtoList.add(dto1);
			dtoList.add(dto2);
			dtoList.add(dto3);
			result.AccountList = dtoList;
			res.return_x = result;
			response.put('response_x', res);
		}
	}
}