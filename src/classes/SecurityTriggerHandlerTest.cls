@isTest
private class SecurityTriggerHandlerTest {

    static testMethod void DepositConversionTest() {
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        Security__c security = new Security__c(Account__c = acc.id,Security_Type__c = 'Cash Deposit');
        insert security;
        
        security.Security_Type__c = 'Bank Guarantee';
        update security;
        
        acc = [select Deposit_Guarantee_Conversion__c,Deposit_Guarantee_Conversion_Date__c from Account where id = : acc.id];
        System.assert(acc.Deposit_Guarantee_Conversion__c);
        System.assertEquals(acc.Deposit_Guarantee_Conversion_Date__c,date.today());
        
        security.Security_Type__c = 'Cash Deposit';
        update security;
        
        acc = [select Deposit_Guarantee_Conversion__c,Deposit_Guarantee_Conversion_Date__c from Account where id = : acc.id];
        System.assert(!acc.Deposit_Guarantee_Conversion__c);
        
    }
}