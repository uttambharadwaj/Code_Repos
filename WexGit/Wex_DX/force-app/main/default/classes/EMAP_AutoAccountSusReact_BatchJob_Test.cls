@isTest
private class EMAP_AutoAccountSusReact_BatchJob_Test {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testMethod void AutoAccountSusReact_BatchJob_Test() {

        Program__c SPProg = TestDatatUtility.getProgram2();
        SPProg.AOT_Amount__c = 100;
        SPProg.Client_Id__c = '30';
        insert SPProg;
        
        Program__c SGProg = TestDatatUtility.getProgram3();
        SGProg.AOT_Amount__c = 100;
        SGProg.Client_Id__c = '33';
        insert SGProg;
        
        Program__c HKProg = TestDatatUtility.getProgram4();
        HKProg.AOT_Amount__c = 100;
        HKProg.Client_Id__c = '32';
        insert HKProg;
        
        Account acc = TestDatatUtility.getAccount();
        acc.Program__c = SPProg.id;
        acc.Status__c = '3 - Stopped (blocked)';
        acc.Account_Sub_Status__c = 'R - Delinquent (man.)';
        acc.Customer_Type__c = '3 - Standard';
        acc.Risk_Grade__c = '0 - Limited Assessment';
        acc.Credit_Limit_Lcy__c = 1500;
        insert acc;
        
        Account acc1 = TestDatatUtility.getAccount();
        acc1.Program__c = SGProg.id;
        acc1.Status__c = '1 - Active';
        acc1.Customer_Type__c = '3 - Standard';
        insert acc1;
        
        Account acc2 = TestDatatUtility.getAccount();
        acc2.Program__c = HKProg.id;
        acc2.Status__c = '1 - Active';
        acc2.Customer_Type__c = '3 - Standard';
        insert acc2;
        
        Accounts_Receivable__c AR = TestDatatUtility.getAccountReceivable();
        AR.Total_Overdue__c = 50;
        AR.Overdue_Days__c = 10;
        AR.Account__c = acc.id;
        insert AR;
        
        Accounts_Receivable__c AR1 = TestDatatUtility.getAccountReceivable();
        AR1.Total_Overdue__c = 150;
        AR1.Overdue_Days__c = 10;
        AR1.Account__c = acc1.id;
        insert AR1;
        
        Accounts_Receivable__c AR2 = TestDatatUtility.getAccountReceivable();
        AR2.Total_Overdue__c = 150;
        AR2.Overdue_Days__c = 10;
        AR2.Account__c = acc2.id;
        insert AR2;
        
        Credit_Security__c credSec = TestDatatUtility.getCreditSecurity();
        credSec.Account__c = acc.id;
        credSec.Security_Expiry__c = System.today() + 10;
        credSec.Security_Effective_Date__c = System.today() - 10;
        credSec.Type__c = 'Bank Guarantee';
        credSec.Status__c = 'Active';
        credSec.Security_Value__c = 1500;
        insert credSec;
        
        List<CronTrigger> cronJobs = [Select Id, CronJobDetail.Name 
                    From CronTrigger 
                    Where CronJobDetail.Name IN ('EMAP_AutoAccountSusReact_GMSP_BatchJob', 'EMAP_AutoAccountSusReact_SG_BatchJob', 'EMAP_AutoAccountSusReact_HK_BatchJob')];
        
        for(CronTrigger cronObj: cronJobs){
            System.abortJob(cronObj.id);
        }
        
       Test.startTest();

       // CRON expression: midnight on March 14, 15, 16.
       // Because this is a test, job executes immediately after Test.stopTest().  
            
       EMAP_AutoAccountSusReact_GMSP_BatchJob GMSPBatch = new EMAP_AutoAccountSusReact_GMSP_BatchJob();
       String scheduleGMSP = '0 0 0 14 3 ? 2026';
       system.schedule('EMAP_AutoAccountSusReact_GMSP_BatchJob', scheduleGMSP, GMSPBatch);
       
       EMAP_AutoAccountSusReact_HK_BatchJob HKBatch = new EMAP_AutoAccountSusReact_HK_BatchJob();
       String scheduleHK = '0 0 0 15 3 ? 2026';
       system.schedule('EMAP_AutoAccountSusReact_HK_BatchJob', scheduleHK, HKBatch);
       
       EMAP_AutoAccountSusReact_SG_BatchJob SGBatch = new EMAP_AutoAccountSusReact_SG_BatchJob();
       String scheduleSG = '0 0 0 16 3 ? 2026';
       system.schedule('EMAP_AutoAccountSusReact_SG_BatchJob', scheduleSG, SGBatch);
       
       Test.stopTest();

    }
}