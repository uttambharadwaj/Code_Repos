/**
 * Created by W083158 on 2/27/2020.
 */

@IsTest
private class FleetAccountMaintenaneWS_MainTest {
    @TestSetup
    static void setup() {
        UtilityTestLoader.setAutomation(false);
        Id taskRecordType = Schema.SObjectType.Account_Maintenance_Task__c.getRecordTypeInfosByName().get('NA Fleet - Driver Maintenance').getRecordTypeId();

        Program__c program = new Program__c();
        program.Name = 'WEX Testing Program';
        program.DID_Length__c = '4';
        program.Service_Program_Website__c = 'https://www.test.com';
        insert program;
        Id programId = program.Id;

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

        Account_Maintenance_Task__c task = new Account_Maintenance_Task__c();
        task.Status__c = 'New';
        task.RecordTypeId = taskRecordType;
        task.Driver_First_Name__c = 'Test';
        task.Driver_Last_Name__c = 'Test';
        task.Driver_PIN__c = '2345';
        task.Account__c = accountId;
        task.Case__c = testCaseId;

        insert task;

    }
    @IsTest
    static void testBehavior() {
        UtilityTestLoader.setAutomation(false);
        Test.startTest();
        FleetAccountMaintenanceWS_Main.getTasks();

        List<Account_Maintenance_Task__c> taskList = [SELECT Id, Status__c FROM Account_Maintenance_Task__c WHERE Status__c = 'New'];
        for (Account_Maintenance_Task__c task : taskList) {
            FleetAccountMaintenanceWS_Main.updateTask(task.Id, true, '');
        }

        FleetAccountMaintenanceWS_Main.updateTask('BadId', false, 'Error');

        Test.stopTest();
    }
}