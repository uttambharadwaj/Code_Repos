/**
 * Created by W083158 on 2/26/2020.
 */

@IsTest
private class AccountMaintenanceControllerTest {
    @TestSetup
    static void testSetup() {
        UtilityTestLoader.setAutomation(false);
        Program__c program = new Program__c();
        program.Name = 'WEX Testing Program';
        program.DID_Length__c = '4';
        program.Service_Program_Website__c = 'https://www.test.com';
        insert program;
        Id programId = program.Id;

        BOCA_res__c branding = new BOCA_res__c();
        branding.Program__c = programId;
        branding.ISO_code__c = 'en_us';
        branding.Program_Name__c = program.Name;

        insert branding;


        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        Id CaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        List<User> userList = [SELECT Id, Name FROM User WHERE IsActive = TRUE LIMIT 1];

        List<User> ownerList = [SELECT Id, Name, Role_Name__c FROM User WHERE IsActive = TRUE AND Role_Name__c <> NULL LIMIT 1];

        Id owner = ownerList[0].Id;

        insert new VProfileId__c(Virtual_User__c = false);

        Account account = new Account(Name='TestAccount',RecordTypeId=AccountRecordType, Program__c =  programId);
        insert account;
        Id accountId = account.Id;

        Case testCase = new Case(AccountId = accountId, Subject = 'TestCase', RecordTypeId = CaseRecordType, OwnerId = owner);
        insert testCase;
        Id testCaseId = testCase.Id;
        String caseKey = testCase.Secondary_Key__c;
    }
    @IsTest
    static void testBehavior() {
        UtilityTestLoader.setAutomation(false);

        Account testAccount = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        List<Case> testCases = [SELECT Id, Secondary_Key__c FROM Case WHERE AccountId =: testAccount.Id LIMIT 1];
        Case testCase = testCases[0];
        Test.setCurrentPage(new PageReference('Page.AccountMaintenance'));
        ApexPages.currentPage().getParameters().put('lang', 'en_us');
        ApexPages.currentPage().getParameters().put('recordId', testCase.Id);
        ApexPages.currentPage().getParameters().put('key', testCase.Secondary_Key__c);
        ApexPages.currentPage().getParameters().put('c__action', 'driver');

        Test.startTest();
        AccountMaintenanceController controller = new AccountMaintenanceController();
        controller.init();
        system.assertEquals(false, controller.isBroken, 'Controller was broken :( ');
        Test.stopTest();
    }
}