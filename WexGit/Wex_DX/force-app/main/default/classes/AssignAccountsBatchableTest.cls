@isTest
private class AssignAccountsBatchableTest {
    @testSetup static void setupData(){
        UtilityTestLoader.setAutomation(false);
        
        Id contactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Label.AccServiceOpRecordType).getRecordTypeId();
        Contact newCon = new Contact();
        newCon.RecordTypeId = contactRecId;
        newCon.Acct_Row_Id__c = '1-69UBD78';
        newCon.Contact_Row_Id__c = '1-69UBD7C';
        newCon.LastName = 'Ilag';
        newCon.Phone = '1234567890';
        //newCon.AccountId = newAcc.Id;
        insert newCon;
        
        IntegrationRecord__c integ = new IntegrationRecord__c();
        integ.CurrencyIsoCode = 'USD';
        integ.Acct_Row_Id__c = '1-69UBD78';
        integ.Contact_Row_Id__c = '1-69UBD7C';
        integ.Contact__c = newCon.Id;
        insert integ;
        
        Id accountRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.AccServiceOpRecordType).getRecordTypeId();
        Account newAcc = new Account();
        newAcc.Name = 'Check Assign Accounts Batch';
        newAcc.RecordTypeId = accountRecId;
        newAcc.Acct_Row_Id__c = '1-69UBD78';
        insert newAcc;
    }
    
    @isTest static void runBatch(){
        Test.startTest();
            AssignAccountsSchedulable sh1 = new AssignAccountsSchedulable();
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Assign Account Clean Sweep', sch, sh1); 
        Test.stopTest();
    }
}