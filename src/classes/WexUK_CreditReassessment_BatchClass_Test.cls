@isTest
private class WexUK_CreditReassessment_BatchClass_Test{

        
        static testmethod void CreditReassessment_BatchClass_Test() {
        
        //List<Account> acc = TestDatatUtility.getWexUKAccountList();
        Schema.RecordTypeInfo accRecordType = TestDatatUtility.getRecordTypeInfo('Account', 'WES Accounts');
        Account acc = new Account();
            acc.RecordTypeId = accRecordType.getRecordTypeId();
            acc.Name ='Test Accountaaaa';
            acc.Account_Type__c='Prospect';
            acc.Auth_Node_Indicator__c = 'Y';
            acc.Credit_Limit_Status__c = 'Approved';
            acc.account_id__c = '1001nnnnnnnaaaa' ;
            
            
            acc.Credit_Utilization__c =76;
            acc.Nird__c=System.Today();
        insert acc;
        Wex_UK_Configurable__c configVals = new Wex_UK_Configurable__c(Account_Dates__c=-90 ,Confidence_Threshold_DNB__c=-1 ,Confidence_Threshold_EFX__c=-1 ,Credit_Limit_Threshold__c=12500    ,Credit_Util_threshold__c=75    ,CurrencyIsoCode='USD'   ,Expiry_date_lower__c=24    ,Expiry_Date_upper__c=12    ,High_Cred_Util_limit__c=50 ,HLA_Threshold__c=80        ,Name='Wex UK'    ,Nird_Review__c=30  ,Overall_Cred_Lmt_threshold__c=10000    ,Pre_HLA_Lower__c=75    ,Pre_HLA_Upper__c=80);
        insert configVals ;
        Currency_Conversion__c cc = new Currency_Conversion__c(Currency_Value_Euro__c = 100, Client_Id__c = '1001');
        insert cc;
       Test.startTest();
       WexUK_CreditReassessment_BatchClass CreditReassessmentBatch= new WexUK_CreditReassessment_BatchClass ();
       Database.executeBatch(CreditReassessmentBatch,1);
       Test.stopTest();
       

    }
}