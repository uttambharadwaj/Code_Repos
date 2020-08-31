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
                        Name = 'test_OTR_AccountInsert-SHELL_NAV',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'SHELL_NAV'
                );
        Account acct03 = new Account
                (
                        Name = 'test_OTR_AccountInsert-SFJ_SHELL',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'SFJ_SHELL'
                );
        Account acct04 = new Account
                (
                        Name = 'test_OTR_AccountInsert-NotAMatch',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = 'NotAMatch'
                );
        Account acct05 = new Account
                (
                        Name = 'test_OTR_AccountInsert-NullPlatform',
                        RecordTypeId = acctRecordTypeId,
                        Platform__c = null
                );

        insert acct01;
        insert acct02;
        insert acct03;
        insert acct04;
        insert acct05;

    }
}