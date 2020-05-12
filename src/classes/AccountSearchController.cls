public with sharing class AccountSearchController {

	public class SearchResultsWrapper {
		@AuraEnabled
		public List<SearchResultsColumn> fields { get; set; }
		@AuraEnabled
		public List<SearchResultsRow> results { get; set; }
		@AuraEnabled
		public String errorMessage { get; set; }
		@AuraEnabled
		public Boolean otrSearch { get; set; }
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

		// OTR Searches go down a different rabbit hole
		Boolean otrSearch = isOTRSearch(searchType);
		srWrapper.otrSearch = otrSearch;

		System.debug('Search param: ' + searchType + ' otrSearch:' + otrSearch);

		List<SearchResultsColumn> searchColumns = new List<SearchResultsColumn> ();
		SearchResultsColumn action = new SearchResultsColumn();
		action.Label = 'Action';
		action.Name = 'Action';
		searchColumns.add(action);
		//todo: update the column list calculation for OTR
		for (Service_Search_Columns__mdt c :[SELECT MasterLabel, DeveloperName, SortOrder__c FROM Service_Search_Columns__mdt ORDER BY SortOrder__c ASC]) {
			Boolean addColumn = true;
			if ( c.DeveloperName.equalsIgnoreCase('CustomAcctNbr') || c.DeveloperName.equalsIgnoreCase('OnlineUserNm')) {
				if ((c.DeveloperName.equalsIgnoreCase('CustomAcctNbr') && !(searchType.equalsIgnoreCase('CUSTOMACCTNBR')))
						|| (c.DeveloperName.equalsIgnoreCase('OnlineUserNm') && !(searchType.equalsIgnoreCase('ONLINEID')) )) {
					addColumn = false;
				} //Next are columns only used for GTAG search
			} else if (!searchType.equalsIgnoreCase('GTAG')) {
				if (c.DeveloperName.equalsIgnoreCase('vehicleNbr') || c.DeveloperName.equalsIgnoreCase('pdDepartment'))  {
					addColumn = false;
				}
			}
			// Don't show any OTR Columns for a NA Fleet search
			if (!otrSearch && (c.DeveloperName.equalsIgnoreCase('CarrierId') ||
					c.DeveloperName.equalsIgnoreCase('CompanyName') ||
					c.DeveloperName.equalsIgnoreCase('MemberID') ||
					c.DeveloperName.equalsIgnoreCase('PhoneNumber') ||
					c.DeveloperName.equalsIgnoreCase('ARNumber') ||
					c.DeveloperName.equalsIgnoreCase('Platform')
			)){
				addColumn = false;
			}
			// for OTR search we want to show the search column for the search type
			if(otrSearch && (c.DeveloperName.equalsIgnoreCase('CarrierId') ||
					c.DeveloperName.equalsIgnoreCase('CompanyName') ||
					c.DeveloperName.equalsIgnoreCase('MemberID') ||
					c.DeveloperName.equalsIgnoreCase('PhoneNumber') ||
					c.DeveloperName.equalsIgnoreCase('ARNumber') ||
					c.DeveloperName.equalsIgnoreCase('Platform') ||
					c.DeveloperName.equalsIgnoreCase('SpnrAcctNbr') ||
					c.DeveloperName.equalsIgnoreCase('PgmRowId'))){
				addColumn = false;
				if(c.DeveloperName.equalsIgnoreCase('CompanyName') && 'Account_Name_OTR'.equals(searchType)){
					addColumn = true;
				}else if(c.DeveloperName.equalsIgnoreCase('ARNumber') && 'AR_Number'.equals(searchType)){
					addColumn = true;
				}else if(c.DeveloperName.equalsIgnoreCase('PhoneNumber') && 'Account_Phone_OTR'.equals(searchType)){
					addColumn = true;
				}else if(c.DeveloperName.equalsIgnoreCase('MemberID') && 'Member_ID'.equals(searchType)){
					addColumn = true;
				}else if(c.DeveloperName.equalsIgnoreCase('Platform')){
					addColumn = true;
				}else if (c.DeveloperName.equalsIgnoreCase('SpnrAcctNbr') && 'Account_Number_OTR'.equals(searchType)){
					addColumn = true;
				}if(c.DeveloperName.equalsIgnoreCase('CarrierId') && ('Carrier_ID'.equals(searchType) ||
						'Account_Name_OTR'.equals(searchType) ||
						'Account_Phone_OTR'.equals(searchType) ||
						'Member_ID'.equals(searchType) ||
						'AR_Number'.equals(searchType)
				)){
					addColumn = true;
				}
				if(c.DeveloperName.equalsIgnoreCase('CarrierId') && 'AR_Number'.equals(searchType)){
					addColumn = true;
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
		request.searchField = searchType;
		request.searchData = searchKeyword;

		List<SearchResultsRow> results = new List<SearchResultsRow> ();
		AccountSearchTypes.accountSearchResult response = new AccountSearchTypes.accountSearchResult();

		try {
			if (otrSearch) {
				// TODO pass back the response with any errors
				response = searchOTR(searchType, searchKeyword);

			} else {
				response = getNaFleetSOAPResponse(request);
			}
			if (String.isNotEmpty(response.errorMsg)) {
				srWrapper.errorMessage = response.errorMsg;
			}

			if (response.accountList != null) {

				Set<String> pgmIds = new Set<String> ();

				for (AccountSearchTypes.accountSearchDTO dto : response.accountList) {
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

				for (AccountSearchTypes.accountSearchDTO dto : response.accountList) {
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
								if (caseinstvMap.containsKey('accountid')) {
									acctRowId = (String) caseinstvMap.get('accountid');
								} else if (caseinstvMap.containsKey('acctrowid')) {
									acctRowId = (String) caseinstvMap.get('acctrowid');
								}
								String contactId = '';
								if (caseinstvMap.containsKey('primarycontactrowid')) {
									contactId = (String) caseinstvMap.get('primarycontactrowid');
								}
								String pdRowId = '';
								if (caseinstvMap.containsKey('pdrowid')) {
									pdRowId = (String) caseinstvMap.get('pdrowid');
								}

								String carrierId = '';
								if (caseinstvMap.containsKey('carrierid')) {
									carrierId = (String) caseinstvMap.get('carrierid');
								}


								resultColumns.put(col.Name, accNum + '|' + acctRowId + '|' + contactId + '|' + pdRowId + '|'+otrSearch);
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
			System.debug('Error - ' + e.getStackTraceString());
			srWrapper.errorMessage = e.getMessage();
		}

		srWrapper.results = results;
		return srWrapper;
	}

	private static Boolean isOTRSearch(String searchType) {
		if (searchType.equalsIgnoreCase('Check_Number_OTR') ||
				searchType.equalsIgnoreCase('Money_Code') ||
				searchType.equalsIgnoreCase('Check_Number') ||
				searchType.equalsIgnoreCase('Account_Number_OTR') ||
				searchType.equalsIgnoreCase('AR_Number') ||
				searchType.equalsIgnoreCase('Account_Phone_OTR') ||
				searchType.equalsIgnoreCase('Member_ID') ||
				searchType.equalsIgnoreCase('Card_Number_OTR') ||
				searchType.equalsIgnoreCase('Account_Name_OTR') ||
				searchType.equalsIgnoreCase('Carrier_ID')) {
			return true;

		}else{
			return false;
		}
	}

	@AuraEnabled
	public static AccountSearchTypes.accountSearchResult searchOTR(String searchType, String searchKeyword) {

		AccountSearchTypes.accountSearchResult response = new AccountSearchTypes.accountSearchResult();
		boolean isWildCardSearch = searchKeyword.contains('*');
		boolean isOTRSearch = isOTRSearch(searchType);
		List<AccountSearchTypes.AccountSearchDTO> dtoList = new List<AccountSearchTypes.AccountSearchDTO> ();
		List<Account> accountListService = new List<Account>();
		List<Contract__c> contractIds = new List<Contract__c>();

		System.debug('searchOTR with searchType:  ' + searchType + ' searchKeyword: ' + searchKeyword);

		// We need to filter and RecordType.Name = 'Fleet Account' accounts otherwise we will get dups in the result list
		if ('Carrier_ID'.equals(searchType) || 'Member_ID'.equals(searchType)) {
			try {
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and Sponsor_Acct__c LIKE :searchKeyword];
				} else {
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and Sponsor_Acct__c = :searchKeyword];
				}
			} catch (Exception e) {
				System.debug('Error - ' + e.getMessage());
				response.errorMsg = e.getMessage();
				return response;
			}

		} else if ('Account_Number_OTR'.equals(searchType)) {
			try {
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Platform__c IN ('TCHEK','TCHEK_MC','PINNACLE')  AND Sponsor_Acct__c LIKE :searchKeyword];
				} else {
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Platform__c IN ('TCHEK','TCHEK_MC','PINNACLE')  AND Sponsor_Acct__c = :searchKeyword];
				}
			} catch (Exception e) {
				System.debug('Error - ' + e.getMessage());
				response.errorMsg = e.getMessage();
				return response;
			}

		} else if('AR_Number'.equals(searchType)){
			Set<Id> accountsIds = new Set<Id>();
			try {
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					contractIds = [SELECT Id,Account__c, AR_Number__c FROM Contract__c WHERE AR_Number__c LIKE :searchKeyword];
				}else {
					contractIds = [SELECT Id,Account__c, AR_Number__c FROM Contract__c WHERE AR_Number__c = :searchKeyword];
				}
				System.debug('Contracts found: ' + contractIds.size());
				for(Contract__c contract : contractIds){
					accountsIds.add(contract.Account__c);
				}
				accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone,	BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c,(select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), (SELECT AR_Number__c FROM Contracts__r), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and Id IN : accountsIds ];

				System.debug('Accounts found: ' + accountListService.size());

			} catch (Exception e) {
				System.debug('Error - ' + e.getMessage());
				response.errorMsg = e.getMessage();
				return response;
			}

		}else if('Account_Name_OTR'.equals(searchType)){
			try {
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and Name Like :searchKeyword];
				}else {
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and Name = :searchKeyword];
				}
			} catch (Exception e) {
				System.debug('Error - ' + e.getMessage());
				response.errorMsg = e.getMessage();
				return response;
			}

		}else if('Money_Code'.equals(searchType)){
			response.errorMsg = 'Money Code search is not yet implemented';
			return response;

		}else if('Account_Phone_OTR'.equals(searchType)){
			if(searchKeyword.length() != 10 || !searchKeyword.isNumeric()){
				response.errorMsg = 'The Phone Number search requires 10 digits';
				return response;
			}
			String phoneNumber = '(' + searchKeyword.substring(0,3) + ') ' + searchKeyword.substring(3,6) + '-' + searchKeyword.substring(6,10);
			String phoneNumber2 = searchKeyword.substring(0,3) + '-' + searchKeyword.substring(3,6) + '-' + searchKeyword.substring(6,10);
			try {
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and (Phone LIKE :phoneNumber or Phone LIKE :phoneNumber2)];
				}else {
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' and (Phone = :phoneNumber  or Phone = :phoneNumber2)];
				}
			} catch (Exception e) {
				System.debug('Error - ' + e.getMessage());
				response.errorMsg = e.getMessage();
				return response;
			}
			/*  - Commented out as I don't have approval to implement the contact phone search
			if (accountListService.isEmpty()) {
				Set<Id> accountsIds = new Set<Id>();
				List<Contact> contactsByPhone;
				if (isWildCardSearch) {
					searchKeyword = searchKeyword.replace('*', '%');
					contactsByPhone = [SELECT Id, Account.Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND (Phone LIKE :phoneNumber OR Phone LIKE :phoneNumber2)];
				}else {
					contactsByPhone = [SELECT Id, Account.Id FROM Contact WHERE RecordType.Name = 'Service Operations' AND (Phone = :phoneNumber OR Phone = :phoneNumber2)];
				}
				if (!contactsByPhone.isEmpty()) {
					for(Contact contact : contactsByPhone){
						accountsIds.add(contact.Account.Id);
					}
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Id IN : accountsIds ];
				}
			}
		*/

		}else if('Check_Number'.equals(searchType)){
			response.errorMsg = 'Check Number search is not yet implemented';
			return response;

		} else if ('Card_Number_OTR'.equals(searchType)) {
			//Nifty Hack Part 1: T-Chek card numbers are the only ones we have that are 12 digits
			if(searchKeyword.length() != 12 || !searchKeyword.isNumeric()){
				//EFS card search will go here
				response.errorMsg = 'Card Number search is only configured for T-Chek platforms at this time';
				return response;
			} else {
				//Nifty Hack part 2: Account number is the first 5 digits of the T-Chek card number
				String accountNumber = searchKeyword.left(5);
				System.debug('Searching for accountNumber '+accountNumber);
				try
				{
					accountListService = [SELECT Member_ID__c, Id, Name,Sponsor_Acct__c, Account_Status__c, Status__c,  Primary_Contact__c, Account_Number__c, Phone, BillingCity, BillingState, Wex_Account__c, Carrier_Id__c, Acct_Row_Id__c, (select name, Phone, Contact_Type__c, RecordType.Name from Contacts where Contact_Type__c = 'PRIMARY'), Platform__c, Program__c, Program__r.Service_Program_Name__c, Program__r.Service_Program_Website__c, Program__r.WEX_Platform__c FROM Account WHERE RecordType.Name = 'Service Operations' AND Platform__c IN ('TCHEK','TCHEK_MC','PINNACLE') AND Sponsor_Acct__c = :accountNumber];
				} catch (Exception e) {
					System.debug('Error - ' + e.getMessage());
					response.errorMsg = e.getMessage();
					return response;
				}
			}
		}

		for (Account acct : accountListService) {
			if (!(acct.Acct_Row_Id__c.equals(acct.Id))) { //We no longer want the old, cloned records where the AcctRowId was the Id of the record

				AccountSearchTypes.AccountSearchDTO dto1 = new AccountSearchTypes.AccountSearchDTO();
				String carrierId = acct.Carrier_ID__c;
				dto1.acctNm = acct.Name;
				dto1.accountId = acct.Id;
				//This was the place where we would assign the Id to Acct_Row_Id__c; not doing that anymore
				dto1.acctRowId = acct.Acct_Row_Id__c;

				dto1.memberId = acct.Member_ID__c;
				dto1.pgmRowId = acct.Program__r.Service_Program_Name__c;

				dto1.wexAcctNbr = acct.Wex_Account__c;
				String status = acct.Status__c != null ? acct.Status__c : '';
				dto1.acctSts = status.replace('Member', '');
				dto1.primaryContactPhoneNbr = acct.Phone;
				dto1.mainPhone = acct.Phone;
				dto1.spnrAcctNbr = acct.Sponsor_Acct__c;

				dto1.carrierId = carrierId;
				dto1.platform = acct.Program__r.WEX_Platform__c != null ? acct.Program__r.WEX_Platform__c : (acct.Platform__c != null ? acct.Platform__c : 'OTR');
				if (isOTRSearch) {
					for (Contract__c contract : contractIds) {
						if (contract.Account__c == acct.Id) {
							dto1.arNumber = contract.AR_Number__c;
						}
					}
				}

				dto1.addrCity = acct.BillingCity;
				dto1.addrStateProvCd = acct.BillingState;
				for (Contact contact : acct.Contacts) {
					if ('PRIMARY'.equals(contact.Contact_Type__c)) {
						dto1.primaryContactNm = contact.Name;
						dto1.primaryContactPhoneNbr = contact.Phone;
					}
				}

				dtoList.add(dto1);
			}
		}

		response.accountList = dtoList;
		if(dtoList.size() < 1){
			response.errorMsg = 'No results found.';
		}
		return response;
	}

	private static AccountSearchTypes.accountSearchResult getNaFleetSOAPResponse(AccountSearchTypes.accountSearchRequest request) {
		AccountSearchStub.CustomerDetailsSOAPQSPort client = new AccountSearchStub.CustomerDetailsSOAPQSPort();
		client.endpoint_x = 'callout:Customer_Details';
		client.timeout_x = 120000;
		AccountSearchTypes.accountSearchResult response = client.accountSearch(request);
		if (response.accountList != null) {
			System.debug('accountList.size - ' + response.accountList.size());
		}
		System.debug('errorMsg - ' + response.errorMsg);
		return response;
	}

}