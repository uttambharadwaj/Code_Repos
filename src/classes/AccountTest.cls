@isTest
public with sharing class AccountTest {
    public static void test_OTR_AccountInsert()
    {
        Id acctRecordTypeId = UtilityClass.getRecTypeByDevName('Account','Service_Operations');

        //'EFSLLC', 'TCHEK', 'TCHEK_MC', 'IRVING', 'EFSTS', 'Shell', 'IMPERIAL OIL', 'PINNACLE', 'FLEETONE'
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

        test.startTest();
        insert acct01;
        insert acct02;
        insert acct03;
        insert acct04;
        insert acct05;
        insert acct06;
        insert acct07;
        insert acct08;
        test.stopTest();

        System.assert(acct01.Program__r.Name == 'EFSLLC');
        System.assert(acct02.Program__r.Name == 'EFSLLC');
        System.assert(acct03.Program__r.Name == 'IMPERIAL');
        System.assert(acct04.Program__r.Name == 'TChek');
        System.assert(acct05.Program__r.Name == 'FLEETONE');
        System.assert(acct06.Program__r.Name == 'Shell');
        System.assert(acct07.Program__c  == null);
        System.assert(acct08.Program__c  == null);
    }
}