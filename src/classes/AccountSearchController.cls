public with sharing class AccountSearchController {

	public class SearchResultsWrapper {
		@AuraEnabled
		public List<SearchResultsColumn> fields { get; set; }
		@AuraEnabled
		public List<SearchResultsRow> results { get; set; }
		@AuraEnabled
		public String errorMessage { get; set; }
	}

	public class SearchResultsColumn {
		@AuraEnabled
		public String Name { get; set; }
		@AuraEnabled
		public String Label { get; set; }
	}

	public class SearchResultsRow {
		@AuraEnabled
		public Map<String, String> resultColumns { get; set; }
	}


	@AuraEnabled
	public static List<Service_Search_Type__mdt> getSearchTypesServ() {
		return[SELECT DeveloperName, Selection_Label__c, Search_Case__c, Sort__c FROM Service_Search_Type__mdt ORDER BY Sort__c ASC];
	}

	@AuraEnabled
	public static SearchResultsWrapper searchServ(String searchType, String searchKeyword) {
		SearchResultsWrapper srWrapper = new SearchResultsWrapper();
		List<SearchResultsColumn> searchColumns = new List<SearchResultsColumn> ();
		SearchResultsColumn action = new SearchResultsColumn();
		action.Label = 'Action';
		action.Name = 'Action';
		searchColumns.add(action);
		for (Service_Search_Columns__mdt c :[SELECT MasterLabel, DeveloperName, SortOrder__c FROM Service_Search_Columns__mdt ORDER BY SortOrder__c ASC]) {
			Boolean addColumn = true;
			if ( c.DeveloperName.equalsIgnoreCase('CustomAcctNbr') || c.DeveloperName.equalsIgnoreCase('OnlineUserNm')) {
				if ((c.DeveloperName.equalsIgnoreCase('CustomAcctNbr') && !(searchType.equalsIgnoreCase('CUSTOMACCTNBR')))
						|| (c.DeveloperName.equalsIgnoreCase('OnlineUserNm') && searchType.equalsIgnoreCase('CUSTOMACCTNBR') )) {
					addColumn = false;
				}
			}
			if (addColumn) {
				SearchResultsColumn column = new SearchResultsColumn();
				column.Label = c.MasterLabel;
				column.Name = c.DeveloperName;
				searchColumns.add(column);
			}
		}
		srWrapper.fields = searchColumns;

		AccountSearchTypes.accountSearchRequest request = new AccountSearchTypes.accountSearchRequest();
		request.SearchField = searchType;
		request.SearchData = searchKeyword;

		List<SearchResultsRow> results = new List<SearchResultsRow> ();

		try {
			AccountSearchStub.CustomerDetailsSOAPQSPort client = new AccountSearchStub.CustomerDetailsSOAPQSPort();
			client.endpoint_x = 'callout:Customer_Details';
			client.timeout_x = 120000;
			AccountSearchTypes.accountSearchResult response = client.accountSearch(request);
			if (response.AccountList != null) {
				System.debug('accountList.size - ' + response.AccountList.size());
			}
			System.debug('errorMsg - ' + response.ErrorMsg);
			srWrapper.errorMessage = response.ErrorMsg;

			if (response.AccountList != null) {

				Set<String> pgmIds = new Set<String> ();

				for (AccountSearchTypes.AccountSearchDTO dto : response.AccountList) {
					String jsonStr = JSON.serialize(dto);
					Map<String, Object> dtoMap = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
					Map<String, Object> caseinstvMap = new Map<String, Object> ();
					for (String s : dtoMap.keySet()) {
						caseinstvMap.put(s.toLowerCase(), dtoMap.get(s));
					}

					if (caseinstvMap.containsKey('pgmrowid')) {
						String pgmId = (String) caseinstvMap.get('pgmrowid');
						pgmIds.add(pgmId);
					}
				}

				Map<String, String> pgmMap = new Map<String, String> ();
				for (Program__c pgm :[SELECT Name, Siebel_Program_Row_Id__c FROM Program__c WHERE Siebel_Program_Row_Id__c IN :pgmIds]) {
					pgmMap.put(pgm.Siebel_Program_Row_Id__c, pgm.Name);
				}

				for (AccountSearchTypes.AccountSearchDTO dto : response.AccountList) {
					SearchResultsRow resultRow = new SearchResultsRow();
					Map<String, String> resultColumns = new Map<String, String> ();
					String jsonStr = JSON.serialize(dto);
					Map<String, Object> dtoMap = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
					Map<String, Object> caseinstvMap = new Map<String, Object> ();
					for (String s : dtoMap.keySet()) {
						caseinstvMap.put(s.toLowerCase(), dtoMap.get(s));
					}

					for (SearchResultsColumn col : searchColumns) {
						if (col.Name == 'Action') {
							if (caseinstvMap.containsKey('wexacctnbr')) {
								String accNum = (String) caseinstvMap.get('wexacctnbr');
								String acctRowId = '';
								if (caseinstvMap.containsKey('acctrowid')) {
									acctRowId = (String) caseinstvMap.get('acctrowid');
								}
								String contactId = '';
								if (caseinstvMap.containsKey('primarycontactrowid')) {
									contactId = (String) caseinstvMap.get('primarycontactrowid');
								}

								resultColumns.put(col.Name, accNum + '|' + acctRowId + '|' + contactId);
							}
							else {
								resultColumns.put(col.Name, '');
							}
						} else if (col.Name == 'PgmRowId') {
							if (caseinstvMap.containsKey('pgmrowid')) {
								String pgmId = (String) caseinstvMap.get('pgmrowid');
								String pgmName = pgmMap.get(pgmId);
								resultColumns.put(col.Name, (pgmName != null ? pgmName : pgmId));
							}
							else {
								resultColumns.put(col.Name, '');
							}
						} else {
							String key = col.Name.toLowerCase();
							if (caseinstvMap.containsKey(key)) {
								resultColumns.put(col.Name, (String) caseinstvMap.get(key));
							} else {
								resultColumns.put(col.Name, '');
							}
						}
					}
					resultRow.resultColumns = resultColumns;
					results.add(resultRow);
				}
			}
		}
		catch(Exception e) {

			Internal_Application_Error__c err = new Internal_Application_Error__c();
			err.User__c = UserInfo.getUserId();
			err.Error_Message__c = e.getMessage();
			err.Error_Location__c = e.getStackTraceString();
			err.Application__c = 'Service Search Integration';
			insert err;

			System.debug('Error - ' + e.getMessage());
			srWrapper.errorMessage = e.getMessage();
		}

		srWrapper.results = results;
		return srWrapper;
	}
}