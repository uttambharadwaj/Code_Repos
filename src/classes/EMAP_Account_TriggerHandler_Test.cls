@isTest
public class EMAP_Account_TriggerHandler_Test {
    
        static testMethod void testEMAP_Account_Trigger(){
            
            Program__c prog = TestDatatUtility.getProgram1();
            insert prog;
            
            Account parentAcc = TestDatatUtility.getAccount();
            parentAcc.Program__c = prog.id;
            parentAcc.Hierarchy_Level__c = '03';
            insert parentAcc;
            
            Account acc = TestDatatUtility.getAccount();
            acc.Program__c = prog.id;
            acc.Hierarchy_Level__c = '03';
            acc.Temporary_Credit_Expire_Date__c = system.today();
            acc.Temporary_Credit_Limit__c = 123;
            acc.Temporary_Credit_Reason__c = 'ABC';
            acc.Aggregated_Tel_USD__c = 50000;
            acc.parentId = parentAcc.id;
            insert acc;
            
            Account acc2 = TestDatatUtility.getAccount();
            acc2.Program__c = prog.id;
            acc2.Hierarchy_Level__c = '03';
            acc2.Temporary_Credit_Expire_Date__c = system.today();
            acc2.Temporary_Credit_Limit__c = 124;
            acc2.Temporary_Credit_Reason__c = 'ABD';
            acc2.parentId = parentAcc.id;
            acc2.Aggregated_Tel_USD__c = 50001;
            insert acc2;
            
            Accounts_Receivable__c testAR = TestDatatUtility.getAccountReceivable();
            testAR.Account__c = acc.id;
            insert testAR;
            
            Accounts_Receivable__c testAR2 = TestDatatUtility.getAccountReceivable();
            testAR2.Account__c = acc2.id;
            testAR2.Current_Balance__c = 1500;
            insert testAR2;

            Contact con = TestDatatUtility.getContact();
            Contact con1 = TestDatatUtility.getContact();
            List<Contact> conList = new List<Contact>();
            con.AccountId = acc.Id;
            conList.add(con);
            con1.AccountId = acc2.Id;
            con1.Primary__c = true;
            conList.add(con1);

            Test.startTest();
            parentAcc.Aggregated_Tel_USD__c = 75000;
            update parentAcc;
            
            parentAcc.Aggregated_Tel_USD__c = 25000;
            update parentAcc;
            
            EMAP_Account_TriggerHandler.isChildAccountController = false;
            
            acc2.Credit_Limit__c = 2500;
            acc2.Aggregated_Tel_USD__c = 25000;
            update acc2;
           
            insert conList;
            
            EMAP_Account_TriggerHandler.AccContUpdateFlag = false;
            con.Primary__c = true;
            update con;
            
            Test.stopTest();
                        
        }
    
}