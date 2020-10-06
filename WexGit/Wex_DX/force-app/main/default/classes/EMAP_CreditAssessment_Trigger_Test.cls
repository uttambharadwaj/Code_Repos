@istest
private class EMAP_CreditAssessment_Trigger_Test{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testMethod void CreditAssessmentValidate(){
        
        User user= TestDatatUtility.createUser();
        //insert user;
        
        Account acc =TestDatatUtility.getAccount();
        insert acc;
        
        AU_Application_Request__c AUApp = TestDatatUtility.getAUAppReq();
        AUApp.Account__c = acc.id;
        insert AUApp;
        
        acc.AU_Application_Request__c = AUApp.id;
        acc.ownerId = user.id;
        update acc;
             
        Credit_Assessment__c creAss=TestDatatUtility.getCredit_Assessment();
        creAss.account__c=acc.id;
        creAss.Final_Judgement__c = '';
        creAss.Assessment_Sub_Status__c = 'In Progress';
        creAss.Nird__c = System.today();
        creAss.ownerId = user.id;
        insert creAss; 
        
        Test.startTest();
        
        System.runAs(user){
            creAss.Assessment_Sub_Status__c = 'Hold';
            creAss.Hold_Expiration_Date__c = System.today() + 10;
            update creAss;
            
            creAss.Hold_Expiration_Date__c = System.today() - 10;
            //creAss.Revert_To_Status__c = 'In Progress';
            update creAss;
            
            creAss.Final_Judgement__c = 'Cancelled';
            creAss.Credit_Assessment_Decline_Reason__c='Incomplete application';
            creAss.Risk_Level__c = 'High';
            creAss.Credit_Limit_Lcy__c = 1000;
            creAss.Credit_Limit_Requested__c = 3000;
            creAss.Total_Exposure_Limit_LCY__c = 4000;
            creAss.Total_Exposure_Limit_USD__c = 5000;
            creAss.Aggregated_Tel_USD__c = 6000;
            creAss.Aggregated_TEL_LCY__c = 7000;
            creAss.Approved_Credit_Limit_USD__c = 8000;
            update creAss;
        }
        
        Test.stopTest();

    }

}