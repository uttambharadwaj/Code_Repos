@isTest
private class EMAP_Bank_Trade_ReferenceTriggerHan_Test {
	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}
    static testMethod void myUnitTest() {
    	Account varAcc  = TestDatatUtility.getAccount();
    	insert varAcc;
    	
    	Bank_Reference__c varBankRef = TestDatatUtility.getBankReference();
    	varBankRef.Account__c = varAcc.Id;
    	insert varBankRef;
    	
    	Trade_Reference__c varTradeRef = TestDatatUtility.getTradeReference();
    	varTradeRef.Account__c = varAcc.Id;
    	insert varTradeRef;
    	
    	Trade_Reference__c varTradeRef1 = TestDatatUtility.getTradeReference();
    	varTradeRef1.Account__c = varAcc.Id;
    	insert varTradeRef1;
    	    	
    	AU_Application_Request__c varAuApp = TestDatatUtility.getAUAppReq();
    	varAuApp.Account__c = varAcc.Id;
    	varAuApp.Bank_Reference__c = varBankRef.ID;
    	varAuApp.Trade_Reference__c = varTradeRef.Id;
    	varAuApp.Trade_Reference1__c =  varTradeRef1.Id;
    	varAuApp.Application_Status__c = 'Pending Approval';
    	insert varAuApp;
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isApplication = false;
    	
    	varBankRef.AU_Application_Request__c = varAuApp.Id;
    	update varBankRef;
    	
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isBank = false;
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isApplication = false;
    	
    	varTradeRef.AU_Application_Request__c = varAuApp.Id;
    	update varTradeRef;
    	
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isTrade = false;
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isApplication = false;
    	
    	varTradeRef1.AU_Application_Request__c = varAuApp.Id;
    	update varTradeRef1;
    	
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isTrade = false;
    	EMAP_Bank_Trade_ReferenceTriggerHandler.isApplication = false;

    	varAuApp.Application_Status__c = 'RPS Pending';
    	update varAuApp;
    	
    }
}