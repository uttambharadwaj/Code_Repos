@isTest
private class EMAP_Accounts_Receivable_Trigger_Test {

    static testMethod void AccountReceivableTriggerTest() {
    	
    	Program__c prog = TestDatatUtility.getProgram1();
    	prog.AOT_Amount__c = 250;
    	insert prog;
    	
    	Account parentAcc = TestDatatUtility.getAccount();
    	parentAcc.Program__c = prog.id;
    	parentAcc.Hierarchy_Level__c = '03';
    	insert parentAcc;
    	
        Account acc = TestDatatUtility.getAccount();
    	acc.Program__c = prog.id;
    	acc.Hierarchy_Level__c = '03';
        acc.parentId = parentAcc.id;
        insert acc;
        
        Account acc2 = TestDatatUtility.getAccount();
    	acc2.Program__c = prog.id;
    	acc2.Hierarchy_Level__c = '03';
        acc2.parentId = parentAcc.id;
        insert acc2;

    	Invoice__c invoice = TestDatatUtility.getInvoice();
    	invoice.Account__c = acc.id;
    	insert invoice;
		
    	Accounts_Receivable__c testAR = TestDatatUtility.getAccountReceivable();
    	testAR.Account__c = acc.id;
    	testAR.Current_Balance__c = 1000;
        testAR.Total_Overdue__c = 300;
    	
    	Accounts_Receivable__c testAR2 = TestDatatUtility.getAccountReceivable();
    	testAR2.Account__c = acc2.id;
    	testAR2.Current_Balance__c = 1500;
        testAR2.Total_Overdue__c = 350;

		Test.startTest();
		
    	insert testAR;
    	insert testAR2;
    	
    	Test.stopTest();
    }
}