@istest
public class AccountSearchControllerTest {

	static testmethod void testController() {
		Test.setMock(WebServiceMock.class, new MockResponseGenerator());

		Test.startTest();
		AccountSearchController.SearchResultsWrapper resultsWrapper = AccountSearchController.searchServ('ACCTNM', 'test acct');
		Test.stopTest();

		System.assertEquals(2, resultsWrapper.results.size());
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
			List<AccountSearchTypes.AccountSearchDTO> dtoList = new List<AccountSearchTypes.AccountSearchDTO> ();
			dtoList.add(dto1);
			dtoList.add(dto2);
			result.AccountList = dtoList;
			res.return_x = result;
			response.put('response_x', res);
		}
	}
}