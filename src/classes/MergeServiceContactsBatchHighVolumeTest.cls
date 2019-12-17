@isTest
private class MergeServiceContactsBatchHighVolumeTest {
    @testSetup
    static void setup(){
       UtilityTestLoader.setAutomation(false);
    }
    static testmethod void testMerge() {

        Contact_Merge_Settings__c cms = new Contact_Merge_Settings__c();
        cms.Name = 'Integration Record';
        cms.Object__c = 'IntegrationRecord__c';
        cms.Active__c = true;
        cms.Field__c = 'Contact__c';
        insert cms;

        Account acc1 = new Account(Name = 'test1');
        Account acc2 = new Account(Name = 'test2');
        insert new Account[] {acc1, acc2};

        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.Phone = '111-222-3333';
        c1.HomePhone = '111-222-4444';
        c1.Email = 'john.doe@test.com';
        c1.RecordTypeId = rectypeid;
        c1.SourceLastModifiedDate__c = Datetime.now().addDays(-5);
        insert c1;

        Contact c2 = new Contact();
        c2.AccountId = acc1.Id;
        c2.FirstName = 'John';
        c2.LastName = 'Doe';
        c2.Phone = '111-222-4444';
        c2.Email = 'john.doe1@test.com';
        c2.RecordTypeId = rectypeid;
        c2.SourceLastModifiedDate__c = Datetime.now();
        insert c2;

        Contact c3 = new Contact();
        c3.AccountId = acc2.Id;
        c3.FirstName = 'John';
        c3.LastName = 'Doe';
        c3.Phone = '111-222-5555';
        c3.Email = 'john.doe@test.com';
        c3.RecordTypeId = rectypeid;
        c3.SourceLastModifiedDate__c = Datetime.now();
        insert c3;

        Contact c4 = new Contact();
        c4.FirstName = 'Jane';
        c4.LastName = 'Doe';
        c4.Phone = '111-222-5555';
        c4.Email = 'jane.doe@test.com';
        c4.RecordTypeId = rectypeid;
        c4.SourceLastModifiedDate__c = Datetime.now();
        insert c4;

        Contact c5 = new Contact();
        c5.AccountId = acc1.Id;
        c5.FirstName = 'John';
        c5.LastName = 'Doe';
        c5.Phone = '111-222-3333';
        c5.HomePhone = '111-222-4444';
        c5.Email = 'john.doe@test.com';
        c5.RecordTypeId = rectypeid;
        c5.SourceLastModifiedDate__c = Datetime.now().addDays(-2);
        insert c5;

        Contact c6 = new Contact();
        c6.AccountId = acc1.Id;
        c6.FirstName = 'John';
        c6.LastName = 'Doe';
        c6.Phone = '111-222-3333';
        c6.HomePhone = '111-222-4444';
        c6.Email = 'john.doe@test.com';
        c6.RecordTypeId = rectypeid;
        c6.SourceLastModifiedDate__c = Datetime.now();
        insert c6;

        Contact c7 = new Contact();
        c7.AccountId = acc1.Id;
        c7.FirstName = 'John';
        c7.LastName = 'Doe';
        c7.Phone = '111-222-3333';
        c7.HomePhone = '111-222-4444';
        c7.Email = 'john.doe@test.com';
        c7.RecordTypeId = rectypeid;
        c7.SourceLastModifiedDate__c = Datetime.now();
        insert c7;

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact__c = c1.Id;
        int1.Account__c = acc1.Id;
        int1.Contact_Type__c = 'Admin';
        insert int1;

        IntegrationRecord__c int2 = new IntegrationRecord__c();
        int2.Contact__c = c1.Id;
        insert int2;

        IntegrationRecord__c int3 = new IntegrationRecord__c();
        int3.Contact__c = c2.Id;
        int3.Account__c = acc1.Id;
        int3.Contact_Type__c = 'Billing';
        int3.Phone__c = '333-333-3333';
        int3.Mobile_Phone__c = '333-333-3334';
        int3.Email__c = 'int3@test.com';
        insert int3;

        IntegrationRecord__c int4 = new IntegrationRecord__c();
        int4.Contact__c = c3.Id;
        int4.Account__c = acc2.Id;
        int4.Contact_Type__c = 'Mailing';
        int4.Phone__c = '444-444-4444';
        int4.Mobile_Phone__c = '444-444-4445';
        int4.Email__c = 'int4@test.com';
        insert int4;

        IntegrationRecord__c int5 = new IntegrationRecord__c();
        int5.Contact__c = c4.Id;
        insert int5;

        IntegrationRecord__c int6 = new IntegrationRecord__c();
        int6.Contact__c = c5.Id;
        insert int6;

        IntegrationRecord__c int7 = new IntegrationRecord__c();
        int7.Contact__c = c5.Id;
        insert int7;

        IntegrationRecord__c int8 = new IntegrationRecord__c();
        int8.Contact__c = c6.Id;
        insert int8;

        Test.startTest();
        Database.executeBatch(new MergeServiceContactsBatchHighVolume(new String[]{'john doe'}, false, 200));
        Test.stopTest();

        List<Contact> ctList = [SELECT Id, MobilePhone, OtherPhone, Phone2__c, Phone3__c, Email_Address_2__c, Email_Address_3__c, (SELECT Id FROM Integration_Record__r)
                                FROM Contact ORDER BY Name, Id];

        System.assertEquals(2, ctList.size());
    }
}