@istest
private class EMAP_CreditSecurity_Trigger_Test{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }
    static testMethod void CreditSecurityTest(){
        Account acc = TestDatatUtility.getAccount();
        //insert acc;
        
        Account acc2 = TestDatatUtility.getAccount();
        //insert acc2;
        
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(acc2);
        insert accList;
        
        Credit_Security__c credSec = TestDatatUtility.getCreditSecurity();
        Credit_Security__c credSec1 = TestDatatUtility.getCreditSecurity();
        List<Credit_Security__c> credSecList = new List<Credit_Security__c>();
        
        credSec.Account__c = acc.id;
        credSec1.Account__c = acc2.Id;
        
        credSecList.add(credSec);
        credSecList.add(credSec1);
        insert credSecList;
        
        credSec.Security_Expiry__c = System.today() + 10;
        update credSec;
        
        credSec.Security_Effective_Date__c = System.today() - 10;
        update credSec;
        
        credSec1.Security_Expiry__c = System.today() + 10;
        update credSec;
        
        credSec1.Security_Effective_Date__c = System.today() - 10;
        update credSec1;
        
        
        
        Account acc1 = [Select Id, Name, Security_Expiry__c From Account Where Id =: acc.Id];
        //System.assertEquals(acc1.Security_Expiry__c, credSec.Security_Expiry__c);
        
        EMAP_Credit_Security_TriggerHandler.updateCreditSecurityExpiry_OnAccount(credSecList);
        EMAP_Credit_Security_TriggerHandler.updateCurrency(credSecList);
        
    }
}