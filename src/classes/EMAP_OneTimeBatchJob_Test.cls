@isTest
private class EMAP_OneTimeBatchJob_Test {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testMethod void OneTimeBatchJob_Test() {
        
        Program__c program = TestDatatUtility.getProgram4();
        insert program;
        
        List<Account> accList = TestDatatUtility.getAccountList();
        
        List<Account> accInsert = new List<Account>();
        
        for(Integer i=1; i<=100; i++){
            Account parentAcc = accList.get(i);
            parentAcc.Program__c = program.id;
            parentAcc.Client_Name__c = 'ExxonMobil Hong Kong';
            parentAcc.IFCS__c = '123456789';
            accInsert.add(parentAcc);
        }
        
        for(Integer i=101; i < accList.size(); i++){
            Account childAcc = accList.get(i);
            childAcc.Program__c = program.id;
            childAcc.Client_Name__c = 'ExxonMobil Hong Kong';
            childAcc.Parent_Account_IFCS_Id_integration__c = '123456789';
            accInsert.add(childAcc);
        }

        insert accInsert;
        
        Test.startTest();
                
        //Risk flag web service class Test
        EMAP_RiskFlag_Webservice riskFlag = new EMAP_RiskFlag_Webservice();
        riskFlag.parameter = 'test param';

        //Credit Decision Batch Test        
        //EMAP_RiskFlag_Webservice.startCreditDecisionBatchJob();
        
        EMAP_RiskFlag_Webservice.startHKCreditDecisionBatchJob();
        
        //IFCS Parent Account Sync Batch Test
        EMAP_RiskFlag_Webservice.startIFCSParentAccountSyncJob();
       
        Test.stopTest();
    }
}