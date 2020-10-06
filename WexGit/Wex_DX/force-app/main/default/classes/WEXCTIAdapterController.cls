public class WEXCTIAdapterController {

    public class WEXCTIAdapterException extends Exception {}

    public enum matchType {MULTI, SINGLE, NONE}
    public enum matchedOn {ACCOUNT, CARD, ANI}

    @AuraEnabled
    public static User getUserInformation() {

        User user  = [SELECT Id, ACD_Id__c FROM User WHERE Id =: UserInfo.getUserId()];

        return user;

    }
    
	@AuraEnabled
    public static CTI_POP_Settings__c getCTIPOPSettings() {

        return CTI_POP_Settings__c.getInstance();

    }
    
	@AuraEnabled
    public static void cacheFinesseLogin(String username, String password) {

        System.debug('### cacheFinesseLogin username: ' + username + ' | password: ' + password);
        if(!String.isBlank(username)){
        	Cache.Session.put('local.CTIUserData.finesseUsername', username);
        }
        if(!String.isBlank(password)){
        	Cache.Session.put('local.CTIUserData.finessePassword', password);
        }
    }
    
	@AuraEnabled
    public static FinesseUserResult getCachedFinesseUser() {

        WEXCTIAdapterController.FinesseUserResult finesseUser = new WEXCTIAdapterController.FinesseUserResult();

    		finesseUser.username = 'user';
            finesseUser.password = 'password'; 

        if (Cache.Session.contains('local.CTIUserData.finesseUsername')){
            String user = (String)Cache.Session.get('local.CTIUserData.finesseUsername');
            String password = (String)Cache.Session.get('local.CTIUserData.finessePassword');    
    		finesseUser.username = user;
            finesseUser.password = password;            
        } else{
    		finesseUser.username = '';
            finesseUser.password = '';            
        }
		
        return finesseUser;        
    }
    
 	@AuraEnabled
    public static WEXCTIAdapterController.CustomerSearchResult accountAndContactSearch(String accountNumber, String cardNumber, String ani) {

        System.debug('### Searching account: ' + accountNumber + '/card: ' + cardNumber + '/ani: ' + ani);
        
        WEXCTIAdapterController.CustomerSearchResult customerSearchResult = new WEXCTIAdapterController.CustomerSearchResult();

        Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

        CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

        customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

        // Some damage control - we don't want that value to be below the default threshold
        if (CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
            customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
        }

        if(!String.isBlank(accountNumber)) {

            List<List<SObject>> accountSearch = [FIND :accountNumber IN ALL FIELDS RETURNING Account(Name, Wex_Account__c WHERE RecordType.Name = 'Service Operations' LIMIT 1)];

            List<Account> accounts = (List<Account>)accountSearch[0];

            if(accounts.size() > 1) {
                customerSearchResult.searchDisposition = 'Multiple Match - Account';
                customerSearchResult.matchType = matchType.MULTI.name();
				customerSearchResult.matchedOn = matchedOn.ACCOUNT.name();                
            }
            
            if(accounts.size() == 1) {

                customerSearchResult.searchDisposition = 'Single Match - Account';
                customerSearchResult.matchType = matchType.SINGLE.name();
				customerSearchResult.matchedOn = matchedOn.ACCOUNT.name();
                
                System.debug('### Account found locally');

                customerSearchResult.companyName = accounts[0].Name;
                customerSearchResult.wexAccountNumber = accounts[0].Wex_Account__c;

                return customerSearchResult;

            }
            else {

                CustomerDetailsWSUtilv2.accountSearchRequest accountSearchRequest = new CustomerDetailsWSUtilv2.accountSearchRequest();

                accountSearchRequest.searchData = accountNumber.substring(0, 13);
                accountSearchRequest.searchField = 'CUSTOMERACCTNBR';

                CustomerDetailsWSUtilv2.accountSearchResult accountSearchResult = customerDetailsCallout.accountSearch(accountSearchRequest);

                System.debug(accountSearchResult);

                if (accountSearchResult.accountList != null && accountSearchResult.accountList.size() == 1) {
                    
                    customerSearchResult.searchDisposition = 'Single Match - Account';
                    customerSearchResult.matchType = matchType.SINGLE.name();
					customerSearchResult.matchedOn = matchedOn.ACCOUNT.name();

                    System.debug('### Account found via CustomerDetails search');

                    customerSearchResult.companyName = accountSearchResult.accountList[0].acctNm;
                    customerSearchResult.wexAccountNumber = accountSearchResult.accountList[0].wexAcctNbr;

                    return customerSearchResult;

                }

            }

        }

        if(!String.isBlank(cardNumber)) {
        
            CustomerDetailsWSUtilv2.accountSearchRequest accountSearchRequest = new CustomerDetailsWSUtilv2.accountSearchRequest();

                accountSearchRequest.searchData = cardNumber;
                accountSearchRequest.searchField = 'EMBOSSEDPDNBR';

                CustomerDetailsWSUtilv2.accountSearchResult accountSearchResult = customerDetailsCallout.accountSearch(accountSearchRequest);

                System.debug(accountSearchResult);

                if (accountSearchResult.accountList != null && accountSearchResult.accountList.size() == 1) {
                    
                    customerSearchResult.searchDisposition = 'Single Match - Card Number';
                    customerSearchResult.matchType = matchType.SINGLE.name();
					customerSearchResult.matchedOn = matchedOn.CARD.name();

                    System.debug('### Account found via CustomerDetails search');

                    customerSearchResult.companyName = accountSearchResult.accountList[0].acctNm;
                    customerSearchResult.wexAccountNumber = accountSearchResult.accountList[0].wexAcctNbr;

                    return customerSearchResult;

                }
            
        }
        
        if(!String.isBlank(ani)) {

			List<List<SObject>> accountSearch = [FIND :ani IN ALL FIELDS RETURNING Account(Name, Wex_Account__c WHERE RecordType.Name = 'Service Operations')];

            List<Account> accounts = (List<Account>)accountSearch[0];

            if(accounts.size() > 1) {
                customerSearchResult.searchDisposition = 'Multiple Match - ANI';
                customerSearchResult.matchType = matchType.MULTI.name();
				customerSearchResult.matchedOn = matchedOn.ANI.name();
            }
            
            if(accounts.size() == 1) {

                customerSearchResult.searchDisposition = 'Single Match - ANI';
                customerSearchResult.matchType = matchType.SINGLE.name();
				customerSearchResult.matchedOn = matchedOn.ANI.name();
                
                System.debug('### Account found locally');

                customerSearchResult.companyName = accounts[0].Name;
                customerSearchResult.wexAccountNumber = accounts[0].Wex_Account__c;

                return customerSearchResult;

            }       
            // If we didn't find the ani under the account then look in contacts            
            List<List<SObject>> aniSearch = [FIND :ani IN ALL FIELDS RETURNING Contact(Account.Name, Account.Wex_Account__c WHERE RecordType.Name = 'Service Operations')];

            List<Contact> contacts = (List<Contact>)aniSearch[0];
            
            if(contacts.size() > 1) {
            	customerSearchResult.searchDisposition = 'Multiple Match - ANI';
                customerSearchResult.matchType = matchType.MULTI.name();
				customerSearchResult.matchedOn = matchedOn.ANI.name();
            }

            if(contacts.size() == 1) {

                customerSearchResult.searchDisposition = 'Single Match - ANI';
                customerSearchResult.matchType = matchType.SINGLE.name();
				customerSearchResult.matchedOn = matchedOn.ANI.name();
                
                System.debug('### Contact found locally attached to Account');

                customerSearchResult.companyName = contacts[0].Account.Name;
                customerSearchResult.wexAccountNumber = contacts[0].Account.Wex_Account__c;

                return customerSearchResult;

            }
            else {

                // If no account - then phone search
                CustomerDetailsWSUtilv2.accountSearchRequest accountSearchRequest = new CustomerDetailsWSUtilv2.accountSearchRequest();

                accountSearchRequest.searchData = ani.replaceAll('[^0-9]', '');
                accountSearchRequest.searchField = 'PHONE';

                CustomerDetailsWSUtilv2.accountSearchResult accountSearchResult = customerDetailsCallout.accountSearch(accountSearchRequest);

                System.debug(accountSearchResult);

                if (accountSearchResult.accountList != null && accountSearchResult.accountList.size() == 1) {

                    customerSearchResult.searchDisposition = 'Single Match - ANI';
                    customerSearchResult.matchType = matchType.SINGLE.name();
				    customerSearchResult.matchedOn = matchedOn.ANI.name();
                    
                    System.debug('### Contact found via CustomerDetails search');

                    customerSearchResult.companyName = accountSearchResult.accountList[0].acctNm;
                    customerSearchResult.wexAccountNumber = accountSearchResult.accountList[0].wexAcctNbr;

                    return customerSearchResult;

                }
                else if(accountSearchResult.accountList != null && accountSearchResult.accountList.size() > 1) {
                    customerSearchResult.searchDisposition = 'Multiple Match - ANI';
                    customerSearchResult.matchType = matchType.MULTI.name();
     				customerSearchResult.matchedOn = matchedOn.ANI.name();
                }

            }

        }
        
        if(String.isBlank(customerSearchResult.searchDisposition)) {
        	customerSearchResult.searchDisposition = 'No Matches Found';
            customerSearchResult.matchType = matchType.NONE.name();
			customerSearchResult.matchedOn = 'NA';
        }

        return customerSearchResult;

    }

    @AuraEnabled
    public static Boolean persistIVRCallData(String externalAccountNumber, String cardNumber, String iVROption,
                                             String iVRPayload, String lob, String matchedOn, String matchType, 
                                             String sessionId, String ani){
	
                 System.debug('### Debug: Helper: PersistIVRData ExternalAccountNumber:' + externalAccountNumber + '  CardNumber: ' + cardNumber
                    + ' IVROption: ' + iVROption
                   + ' LOB: ' + lob
                   + ' MatchedOn: ' + matchedOn
                   + ' MatchType: ' + matchType
                   + ' SessionId: ' + sessionId
                   + ' ANI: ' + ani
                   + ' IVRPayload: ' + iVRPayload);
                                                 
        IVRCaptureData__c callData = new IVRCaptureData__c();
        
      	try {
        		callData.ANI__c = ani;
                callData.CardNumber__c = cardNumber;
                //callData.CreatedById
                callData.ExternalAccountNumber__c = externalAccountNumber;	
                callData.IVROption__c = iVROption;
                callData.IVRPayload__c = iVRPayload;
                callData.LOB__c = lob;
                callData.MatchedOn__c = matchedOn;
                callData.MatchType__c = matchType;
                callData.SessionId__c = sessionId;
                callData.User__c = UserInfo.getUserId();
          		
          		insert callData;       
          		System.debug('### Persist IVR Data Success ###');
            	return true;   
      	} catch (Exception e) {
            System.debug('### Persist IVR Data Failed ###');
            return false;
        }      
    }
    
    public class CustomerSearchResult {

        @AuraEnabled public String searchDisposition { get; set; }
        @AuraEnabled public String matchType { get; set; }
        @AuraEnabled public String matchedOn { get; set; }
        @AuraEnabled public String wexAccountNumber { get; set; }
        @AuraEnabled public String companyName { get; set; }
        

        public CustomerSearchResult() {

        }

    }

	public class FinesseUserResult {

        @AuraEnabled public String username { get; set; }
        @AuraEnabled public String password { get; set; }
       
        public FinesseUserResult() {

        }

    }
    
}