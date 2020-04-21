@istest
public class AccountSearchControllerTest {

	@testSetup
	static void setup(){
	   UtilityTestLoader.setAutomation(false);
	}

	static testmethod void testController() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper = AccountSearchController.searchServ('ACCTNM', 'test acct');

		Test.stopTest();

		System.assertEquals(3, resultsWrapper.results.size());
	}

	static testmethod void testControllerForOTR() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper2 = AccountSearchController.searchServ('Carrier_ID', '123');

		Test.stopTest();

		System.assertEquals(0, resultsWrapper2.results.size());
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