/*
 * 
 *  CustomerDashboardController
 * 
 *  This is the main controller for the CustomerDashboard(.vfp)
 * 
 *  Test Class: CustomerDashboardTest.apxc
 * 
 */
public class CustomerDashboardController {

    // Getters for URL parameters (used by PaymentHistory)
    public String accountNumberParameter { 
        get {
            return ApexPages.currentPage().getParameters().get('accountNumber');
        }
    }
    
    public String accountNumberTypeParameter { 
    	get {
            return ApexPages.currentPage().getParameters().get('accountNumberType');
        }
    }
    
    public Boolean hrflg { 
    	get {
            return Boolean.valueOf(ApexPages.currentPage().getParameters().get('hrflg'));
        }
    }
    
    // Getters/Setters For VF Page Inputs
    public String accountNumber { get; set; }
    
    public String accountNumberType { get; set; }

    public String selectedRecentAccount { get; set; }

    public List<SelectOption> AccountTypeOptions { 
        get {
        	List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Internal', 'Int. Account Number'));
            options.add(new SelectOption('External', 'Ext. Account Number'));
            return options;
    	}
	}

    public List<SelectOption> recentAccounts {
        get {
            // This is our distinct work around
            Set<String> addedAccountOptions = new Set<String>();
            
            List<SelectOption> recentAccountOptions = new List<SelectOption>();

            recentAccountOptions.add(new SelectOption('#', 'Recently Viewed'));
            
            // We only want to select the accounts that were found within the scope of this session
            List<Customer_Dashboard_Audit__c> auditEntries = [SELECT Id, Account_Name__c, Account_Number__c
                                                              FROM Customer_Dashboard_Audit__c 
                                                              WHERE User__c = :UserInfo.getUserId() and Session_Id__c = :UserInfo.getSessionId() and Account_Found__c = true
                                                              ORDER BY Timestamp__c DESC];
            
            if(!auditEntries.isEmpty()) {
	            for(Customer_Dashboard_Audit__c entry : auditEntries) {
                    if(recentAccountOptions.size() == 6) { break; }
                    
                    System.debug(entry);
                    
                    if(!addedAccountOptions.contains(entry.Account_Number__c) && !String.isEmpty(entry.Account_Name__c)) {
						recentAccountOptions.add(new SelectOption(entry.Id, entry.Account_Number__c + ' - ' + (entry.Account_Name__c).unescapeHtml4()));
                    	addedAccountOptions.add(entry.Account_Number__c);
                    }
            	}                
            }
                                 
            return recentAccountOptions;

        }
    }
    
    // WSDL2APEX Objects
    public CustomerDashboardWSUtil.CustomerDetails customerDetails { get; set; }
    
    public CustomerDashboardWSUtil.AgingHistory agingHistory { get; set; }
    
    // Converting Payment History to JSON
    // for ease of use in the Javascript
    public String cycleAgingData {
        get {
			Map<Integer, Integer> billingCycleAging = new Map<Integer, Integer>();
            
            billingCycleAging.put(0,agingHistory.DaysPastDueCnt00);
			billingCycleAging.put(1,agingHistory.DaysPastDueCnt01);
			billingCycleAging.put(2,agingHistory.DaysPastDueCnt02);
			billingCycleAging.put(3,agingHistory.DaysPastDueCnt03);
			billingCycleAging.put(4,agingHistory.DaysPastDueCnt04);
			billingCycleAging.put(5,agingHistory.DaysPastDueCnt05);
			billingCycleAging.put(6,agingHistory.DaysPastDueCnt06);
			billingCycleAging.put(7,agingHistory.DaysPastDueCnt07);
			billingCycleAging.put(8,agingHistory.DaysPastDueCnt08);
			billingCycleAging.put(9,agingHistory.DaysPastDueCnt09);
			billingCycleAging.put(10,agingHistory.DaysPastDueCnt10);
			billingCycleAging.put(11,agingHistory.DaysPastDueCnt11);
			billingCycleAging.put(12,agingHistory.DaysPastDueCnt12);
			billingCycleAging.put(13,agingHistory.DaysPastDueCnt13);
			billingCycleAging.put(14,agingHistory.DaysPastDueCnt14);
			billingCycleAging.put(15,agingHistory.DaysPastDueCnt15);
			billingCycleAging.put(16,agingHistory.DaysPastDueCnt16);
			billingCycleAging.put(17,agingHistory.DaysPastDueCnt17);
			billingCycleAging.put(18,agingHistory.DaysPastDueCnt18);
			billingCycleAging.put(19,agingHistory.DaysPastDueCnt19);
			billingCycleAging.put(20,agingHistory.DaysPastDueCnt20);
			billingCycleAging.put(21,agingHistory.DaysPastDueCnt21);
			billingCycleAging.put(22,agingHistory.DaysPastDueCnt22);
			billingCycleAging.put(23,agingHistory.DaysPastDueCnt23);
			billingCycleAging.put(24,agingHistory.DaysPastDueCnt24);
			billingCycleAging.put(25,agingHistory.DaysPastDueCnt25);
            
            return String.valueOf(JSON.serialize(billingCycleAging));
        }
    }
    
    public String cycleAgingDates {
        get {
			Map<Integer, DateTime> cycleAgingDates = new Map<Integer, DateTime>();
            
            cycleAgingDates.put(0,agingHistory.CycleCloseDt00);
			cycleAgingDates.put(1,agingHistory.CycleCloseDt01);
			cycleAgingDates.put(2,agingHistory.CycleCloseDt02);
			cycleAgingDates.put(3,agingHistory.CycleCloseDt03);
			cycleAgingDates.put(4,agingHistory.CycleCloseDt04);
			cycleAgingDates.put(5,agingHistory.CycleCloseDt05);
			cycleAgingDates.put(6,agingHistory.CycleCloseDt06);
			cycleAgingDates.put(7,agingHistory.CycleCloseDt07);
			cycleAgingDates.put(8,agingHistory.CycleCloseDt08);
			cycleAgingDates.put(9,agingHistory.CycleCloseDt09);
			cycleAgingDates.put(10,agingHistory.CycleCloseDt10);
			cycleAgingDates.put(11,agingHistory.CycleCloseDt11);
			cycleAgingDates.put(12,agingHistory.CycleCloseDt12);
			cycleAgingDates.put(13,agingHistory.CycleCloseDt13);
			cycleAgingDates.put(14,agingHistory.CycleCloseDt14);
			cycleAgingDates.put(15,agingHistory.CycleCloseDt15);
			cycleAgingDates.put(16,agingHistory.CycleCloseDt16);
			cycleAgingDates.put(17,agingHistory.CycleCloseDt17);
			cycleAgingDates.put(18,agingHistory.CycleCloseDt18);
			cycleAgingDates.put(19,agingHistory.CycleCloseDt19);
			cycleAgingDates.put(20,agingHistory.CycleCloseDt20);
			cycleAgingDates.put(21,agingHistory.CycleCloseDt21);
			cycleAgingDates.put(22,agingHistory.CycleCloseDt22);
			cycleAgingDates.put(23,agingHistory.CycleCloseDt23);
			cycleAgingDates.put(24,agingHistory.CycleCloseDt24);
			cycleAgingDates.put(25,agingHistory.CycleCloseDt25);
            
            return String.valueOf(JSON.serialize(cycleAgingDates));
        }
    }
    
    // Internal error framework variables
    private String applicationURL {
        get {
    		return URL.getSalesforceBaseUrl().toExternalForm() + ApexPages.currentPage().getUrl();
        }
	}

    // Main constructor
    public CustomerDashboardController() {
        
        // Set the default for the accountNumberType radio button
        accountNumberType = 'Internal';
   
    }
    
    // Initialize the Customer Dashboard
    public void initCustomerDashboard() {

    }

    // Initialize the Payment History
    public void initPaymentHistory() {
        
        // The account number and type is passed through the URL
        if(!String.isEmpty(accountNumberParameter) && !String.isEmpty(accountNumberTypeParameter)) {
            accountNumber = accountNumberParameter;
            accountNumberType = accountNumberTypeParameter;
            
            viewPaymentHistory();
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No account information found. Please close this window and try again.'));
        }
        
    }
    
    // Retrieves the selected recent account 
    // from the Dashboard dropdown
    public void viewRecentAccount() {
        
        try { 
        
            // # is the default option with label "Recently Viewed"
        	if(!selectedRecentAccount.equalsIgnoreCase('#')) {
            
            	Customer_Dashboard_Audit__c selectedAccount = [SELECT Id, Account_Number__c, Account_Number_Type__c FROM Customer_Dashboard_Audit__c WHERE Id = :selectedRecentAccount];
            
            	if(selectedAccount != null) {
                
            		accountNumber = selectedAccount.Account_Number__c;
                	accountNumberType = selectedAccount.Account_Number_Type__c;
                
                	viewAccount();
                
            	}

        	}
            
        } catch (Exception e) {
            
            String errorTrackingCode = logError(e);
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'An error occurred while performing this search (Error Tracking Code: ' + errorTrackingCode + ')'));
            
        }
        
    }
    
    // Retrieves the account via the WSDL2APEX call
    public void viewAccount() {  
        
        try {
            
        	if(String.isBlank(accountNumber)) {
                
	            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter an account number.'));
                
    	    }
        	else {           
                
                // Get the custom settings for the endpoint configuration
            	Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();
                
                CustomerDashboardWSUtil.customerDetailsRequest customerDetailsRequest = new CustomerDashboardWSUtil.customerDetailsRequest();
                customerDetailsRequest.accountID = accountNumber;
                customerDetailsRequest.accountIdType = accountNumberType;
                
                CustomerDashboardWSUtil.CustomerDetailsSOAP customerDetailsCallout = new CustomerDashboardWSUtil.CustomerDetailsSOAP();
                
                // Set the endpoint configuration (TODO - Add authentication)
                customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;
                
                customerDetails = customerDetailsCallout.getCustomerDetails(customerDetailsRequest);
                
                System.debug(customerDetails);
                

                
                // TODO - Add error handling around search
            	if(String.isEmpty(customerDetails.wexAccountNbr)) {
	                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'The account entered does not match a value in the system. Please confirm the account number was entered correctly and submit again. '));
    	        }
                else {
                    
                    // If the account is a non-billing account, add a page message
                    if(!(customerDetails.wexAccountNbr).equalsIgnoreCase(customerDetails.billingAccountId)) {
                    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'The account that you have selected is not a billing account. You will not see any credit related fields in the dashboard. If you need to obtain credit information please search on the parent account for this relationship.'));
                	}

                    // If there is a description pass through from DW_ACCT, then display
                    // the notes as a page message
                	if(!String.isEmpty(customerDetails.description)) {
                    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, '<b>Account Notes:</b> ' + customerDetails.description));
                	}
                }

				// Insert audit record for the search
	        	Customer_Dashboard_Audit__c auditRecord = new Customer_Dashboard_Audit__c();
    	    	auditRecord.User__c = UserInfo.getUserId();
        		auditRecord.Session_Id__c = UserInfo.getSessionId();
	        	auditRecord.Account_Name__c = customerDetails.accountNm;
    	    	auditRecord.Account_Number__c = accountNumber;
        		auditRecord.Account_Number_Type__c = accountNumberType;
                auditRecord.Account_Found__c = String.isEmpty(customerDetails.wexAccountNbr) ? false : true;
        		auditRecord.Timestamp__c = System.now();
                
    	    	insert auditRecord;
                
        	}
            
        } catch (Exception e) {
            
            String errorTrackingCode = logError(e);
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'An error occurred while performing this search: "' + String.valueOf(e) + '" (Error Tracking Code: ' + errorTrackingCode + ')'));
            
        }
        
    }
    
    // Retrieves the payment history via the WSDL2APEX call
    public void viewPaymentHistory() {  
        
        try {
            
            // Get the custom settings for the WS endpoints
            Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();
            
            agingHistory = new CustomerDashboardWSUtil.AgingHistory();
            
            CustomerDashboardWSUtil.customerDetailsRequest agingHistoryRequest = new CustomerDashboardWSUtil.customerDetailsRequest();
            agingHistoryRequest.accountID = accountNumber;
            agingHistoryRequest.accountIdType = accountNumberType;
                
            CustomerDashboardWSUtil.CustomerDetailsSOAP agingHistoryCallout = new CustomerDashboardWSUtil.CustomerDetailsSOAP();
                
            // Set the endpoint configuration (TODO - Add authentication)
            agingHistoryCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;
                
            System.debug('### ' + agingHistoryRequest);
            
            agingHistory = agingHistoryCallout.getAgingHistory(agingHistoryRequest);
            
        } catch (Exception e) {
            
            String errorTrackingCode = logError(e);
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'An error occurred while retrieving payment history: "' + String.valueOf(e) + '" (Error Tracking Code: ' + errorTrackingCode + ')'));
            
        }
        
    }
    
    private String logError(Exception e) {
        
        try { 
            
            Internal_Application_Error__c error = new Internal_Application_Error__c();
                
            error.User__c = UserInfo.getUserId();
            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Customer Dashboard';
            error.Application_URL__c = applicationURL;
                
        	insert error;
            
            return [SELECT Name FROM Internal_Application_Error__c WHERE Id = :error.Id].Name;
            
        }
        catch(Exception f) {
            
        	System.debug('Error logging exception.. Skipping..');
            
            return 'Logging Error';
            
		}
    }
    
}