/*
 * 
 *  CustomerDashboardTest
 * 
 *  This is the main test class for the CustomerDashboard
 * 
 */

@isTest
public class CustomerDashboardTest {
    
    public static void generateTestAuditData() {

       
        
    }

    static testMethod void testCustomerDashboardViewAccount() {

        Test.startTest();
        
        // Set call-out mock
        Test.setMock(WebServiceMock.class, new CustomerDashboardWSUtil_Mock()); 
        
        PageReference customerDashboard = Page.CustomerDashboard;
		Test.setCurrentPage(customerDashboard);
        
        CustomerDashboardController cdc = new CustomerDashboardController();
        
        // These will never really change upon the initalization
        // of the class, unless ServiceCloud
        System.assert(cdc.AccountTypeOptions != null);
        System.assert(cdc.recentAccounts != null);
        System.assert(cdc.recentAccounts.size() <= 6);
        System.assert(cdc.accountNumberParameter == null);
        System.assert(cdc.accountNumberTypeParameter == null);
        
        cdc.initCustomerDashboard();
        
        // Perform a new account search
        cdc.AccountNumber = '0000';
        cdc.AccountNumberType = 'Internal';
        
        cdc.viewAccount();
        
        Test.stopTest();

    }
   
    
	static testMethod void testAgingHistory() {

        // Generate some random audit data
        generateTestAuditData();
        
        Test.startTest();
        
        // Set call-out mock
        Test.setMock(WebServiceMock.class, new CustomerDashboardWSUtil_Mock()); 

        PageReference customerDashboardPaymentHistory = Page.CustomerDashboardPaymentHistory;
        customerDashboardPaymentHistory.getParameters().put('accountNumber', '0000');
        customerDashboardPaymentHistory.getParameters().put('accountNumberType', 'Internal');
		Test.setCurrentPage(customerDashboardPaymentHistory);

        CustomerDashboardController cdc = new CustomerDashboardController();
        
        System.assert(cdc.accountNumberParameter != null);
        System.assert(cdc.accountNumberTypeParameter != null);
        
        cdc.initPaymentHistory();
        
        System.assert(cdc.agingHistory != null);
        
        System.assert(cdc.cycleAgingData != null);
        System.assert(cdc.cycleAgingDates != null);
        
        Test.stopTest();

    }
    
    static testMethod void testExceptionHandling() {

        // It's not obvious, but here we just don't set the mock
        // web service call-out. In tests, you cannot perform
        // a call-out unless it is mocked, so here, it will fail to 
        // make the call-out and trigger a logged exception
        
        // Generate some random audit data
        generateTestAuditData();
        
        Test.startTest();
        
        PageReference customerDashboard = Page.CustomerDashboard;
		Test.setCurrentPage(customerDashboard);
        
        CustomerDashboardController cdc = new CustomerDashboardController();
        
        PageReference customerDashboardPaymentHistory = Page.CustomerDashboardPaymentHistory;
        customerDashboardPaymentHistory.getParameters().put('accountNumber', '0000');
        customerDashboardPaymentHistory.getParameters().put('accountNumberType', 'Internal');
		Test.setCurrentPage(customerDashboardPaymentHistory);

        System.assert(cdc.accountNumberParameter != null);
        System.assert(cdc.accountNumberTypeParameter != null);
        
        cdc.initPaymentHistory();
        
        Test.stopTest();

    }
    
}