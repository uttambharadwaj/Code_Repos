@isTest
private class EMAP_RiskFlagBatchJob_Test{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';


    static testmethod void RiskFlagBatchJob_Test() {
        
        Program__c prog = TestDatatUtility.getProgram1();
        prog.AOT_Amount__c = 250;
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
        
        Risk_Flag__c riskFlag1 = new Risk_Flag__c();
        riskFlag1.Risk_Flag_Value__c = 'NIRD Expiry';
        riskFlag1.Account__c = acc.id;
        riskFlag1.Status__c = 'Initiated';
        insert riskFlag1;

        Account acc1 = TestDatatUtility.getAccount();
        acc1.Program__c = prog.id;
        acc1.Hierarchy_Level__c = '03';
        insert acc1;

        Accounts_Receivable__c testAR = TestDatatUtility.getAccountReceivable();
        testAR.Account__c = acc.id;
        testAR.Total_Overdue__c = 300;
        insert testAR;

        List<Invoice__c> invoiceList = TestDatatUtility.getInvoiceList();
        
        List<Invoice__c> invoiceData = new List<Invoice__c>();
        for(Integer i=1; i<=50; i++){
            Invoice__c tmpInv =  invoiceList.get(i);
            tmpInv.Account__c = acc.id;
            invoiceData.add(tmpInv);
        }
        
        for(Integer j=51; j<100; j++){
            Invoice__c tmpInv =  invoiceList.get(j);
            tmpInv.Account__c = acc1.id;
            invoiceData.add(tmpInv);
        }
        
        insert invoiceData;

       Test.startTest();
              
       EMAP_RiskFlag_BatchJob riskFlagBatch = new EMAP_RiskFlag_BatchJob();
       String scheduleStr2 = '0 0 23 * * ?';
       system.schedule('RiskFlag_BatchJob', scheduleStr2, riskFlagBatch );
       
       Test.stopTest();
       

    }
}