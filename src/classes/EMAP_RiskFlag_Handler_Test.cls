@isTest
private class EMAP_RiskFlag_Handler_Test {

    static testMethod void RiskFlag_HandlerTest() {
        
            Program__c prog = TestDatatUtility.getProgram1();
            insert prog;
            
            Account parentAcc = TestDatatUtility.getAccount();
            parentAcc.Program__c = prog.id;
            parentAcc.Hierarchy_Level__c = '03';
            parentAcc.Status__c = '1 - Active';
            insert parentAcc;
            
            Risk_Flag__c riskFlag = new Risk_Flag__c();
            riskFlag.Risk_Flag_Value__c = 'EMTC Referral';
            riskFlag.Account__c = parentAcc.id;
            riskFlag.Status__c = 'Initiated';
            insert riskFlag;
            
            Account acc = TestDatatUtility.getAccount();
            acc.Program__c = prog.id;
            acc.Status__c = '1 - Active';
            acc.Hierarchy_Level__c = '03';
            acc.Security_Expiry__c = System.today() + 10;
            acc.Business_Expiry_Date__c = System.today() + 10;
            acc.Temporary_Credit_Limit__c = 500;
            acc.Temporary_Credit_Expire_Date__c = System.today() + 5;
            acc.Temporary_Credit_Reason__c = 'Temporary usage increase';
            acc.Credit_Limit_Lcy__c = 500;
            acc.parentId = parentAcc.id;
            acc.Account_Controller__c = 'WEX';
            insert acc;
                        
            Accounts_Receivable__c testAR = TestDatatUtility.getAccountReceivable();
            testAR.Account__c = acc.id;
            insert testAR;
            
            acc.Accounts_Receivable__c = testAR.id;
            acc.Temporary_Credit_Limit__c = 600;
                        
            Test.startTest();
            
            update acc;
            
            Test.stopTest();
            
    }
}