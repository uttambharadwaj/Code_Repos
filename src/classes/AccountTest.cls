@isTest
public with sharing class AccountTest {
    public static void test_OTR_AccountInsert()
    {
        Id acctRecordTypeId = UtilityClass.getRecTypeByDevName('Account','Service_Operations');

        //'EFSLLC', 'TChek', 'TCHEK_MC', 'IRVING', 'EFSTS', 'Shell', 'IMPERIAL OIL', 'PINNACLE', 'FLEETONE'
        Account acct01 = new Account
                (
                        Name = 'test_OTR_AccountInsert-EFSLLC',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'EFSLLC'
                );
        Account acct02 = new Account
                (
                        Name = 'test_OTR_AccountInsert-EFS LLC',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'EFS LLC'
                );
        Account acct03 = new Account
                (
                        Name = 'test_OTR_AccountInsert-IMPERIAL',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'IMPERIAL'
                );
        Account acct04 = new Account
                (
                        Name = 'test_OTR_AccountInsert-TChek',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'TChek'
                );
        Account acct05 = new Account
                (
                        Name = 'test_OTR_AccountInsert-FLEETONE',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'FLEETONE'
                );
        Account acct06 = new Account
                (
                        Name = 'test_OTR_AccountInsert-SFJ_SHELL',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'SFJ_SHELL'
                );
        Account acct07 = new Account
                (
                        Name = 'test_OTR_AccountInsert-NotAMatch',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'OTR'
                );
        Account acct08 = new Account
                (
                        Name = 'test_OTR_AccountInsert-NullPlatform',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = null
                );

        List<Account> accounts = new List<Account>{acct01,acct02,acct03,acct04,acct05,acct06,acct07,acct08};
        test.startTest();
        insert accounts;
        test.stopTest();

        //update the accounts
        Account a01 = [SELECT Program__r.Name from Account WHERE Id = :acct01.Id];
        Account a02 = [SELECT Program__r.Name from Account WHERE Id = :acct02.Id];
        Account a03 = [SELECT Program__r.Name from Account WHERE Id = :acct03.Id];
        Account a04 = [SELECT Program__r.Name from Account WHERE Id = :acct04.Id];
        Account a05 = [SELECT Program__r.Name from Account WHERE Id = :acct05.Id];
        Account a06 = [SELECT Program__r.Name from Account WHERE Id = :acct06.Id];
        Account a07 = [SELECT Program__r.Name from Account WHERE Id = :acct07.Id];
        Account a08 = [SELECT Program__r.Name from Account WHERE Id = :acct08.Id];

        System.assert(a01.Program__r.Name.equalsIgnoreCase('EFSLLC'), 'Expected Account.Program__r.Name to be EFSLLC');
        System.assert(a02.Program__r.Name.equalsIgnoreCase('EFSLLC'), 'Expected Account.Program__r.Name to be EFSLLC');
        System.assert(a03.Program__r.Name.startsWith('IMPERIAL'), 'Expected Account.Program__r.Name to start with IMPERIAL');
        System.assert(a04.Program__r.Name.equalsIgnoreCase('TChek'), 'Expected Account.Program__r.Name to be TChek');
        System.assert(a05.Program__r.Name.equalsIgnoreCase('FLEETONE'), 'Expected Account.Program__r.Name to be FLEETONE');
        System.assert(a06.Program__r.Name.equalsIgnoreCase('Shell'), 'Expected Account.Program__r.Name to be Shell');
        System.assert(a07.Program__c == null, 'Expected Account.Program__r.Name to be null');
        System.assert(a08.Program__c == null, 'Expected Account.Program__r.Name to be null');
    }
}