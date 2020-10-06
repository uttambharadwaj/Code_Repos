@isTest
private class IntegrationRecordTriggerHandlerTest {

    static testmethod void testCreateContactExists() {
        Automation_Settings__c setting = new Automation_Settings__c();
        setting.Disable_Contact_Trigger__c = false;
        insert setting;

        Account acc1 = new Account(Name = 'test1', Acct_Row_Id__c='ACT1_ROWID');
        Account acc2 = new Account(Name = 'test2');
        insert new Account[] {acc1, acc2};

        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.Contact_Row_Id__c = 'CT1_ROWID';
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.Phone = '111-222-3333';
        c1.HomePhone = '111-222-4444';
        c1.Email = 'john.doe@test.com';
        c1.RecordTypeId = rectypeid;
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

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact_Row_Id__c = 'CT1_ROWID';
        int1.Acct_Row_Id__c = 'ACT1_ROWID';
        int1.Contact_Type__c = 'Mailing';
        int1.Phone__c = '444-444-4444';
        int1.Mobile_Phone__c = '444-444-4445';
        int1.Email__c = 'int1@test.com';
        int1.Last_Name__c = 'Test';

        Test.startTest();
        insert int1;
        Test.stopTest();

        int1 = [SELECT Contact__c, Account__c FROM IntegrationRecord__c WHERE Id = :int1.Id];

        c1 = [SELECT Id, MobilePhone, OtherPhone, Phone2__c, Phone3__c, Email_Address_2__c, Email_Address_3__c
              FROM Contact WHERE Id = :c1.Id];

        System.assertEquals(c1.Id, int1.Contact__c);
        System.assertEquals(acc1.Id, int1.Account__c);
        System.assert(c1.Phone2__c != null);
        System.assert(c1.Phone3__c != null);
        System.assert(c1.Email_Address_2__c != null);
    }

    static testmethod void testCreateContactNew() {
        Automation_Settings__c setting = new Automation_Settings__c();
        setting.Disable_Contact_Trigger__c = false;
        insert setting;

        Account acc1 = new Account(Name = 'test1', Acct_Row_Id__c='ACT1_ROWID');
        Account acc2 = new Account(Name = 'test2');
        insert new Account[] {acc1, acc2};

        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.Contact_Row_Id__c = 'CT1_ROWID';
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.Phone = '111-222-3333';
        c1.HomePhone = '111-222-4444';
        c1.Email = 'john.doe@test.com';
        c1.RecordTypeId = rectypeid;
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

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact_Row_Id__c = 'CT3_ROWID';
        int1.First_Name__c = 'Jane';
        int1.Last_Name__c = 'Doe';
        int1.Contact_Type__c = 'Billing';
        int1.SourceCreatedDate__c = Datetime.now();
        int1.Acct_Row_Id__c = 'ACT1_ROWID';
        int1.Phone__c = '444-444-4444';
        int1.Mobile_Phone__c = '444-444-4445';
        int1.Email__c = 'int1@test.com';

        Test.startTest();
        insert int1;
        Test.stopTest();


        int1 = [SELECT Contact__c, Account__c FROM IntegrationRecord__c WHERE Id = :int1.Id];

        Contact c3 = [SELECT Id, Contact_Row_Id__c, Acct_Row_Id__c, Email, Phone, MobilePhone
                      FROM Contact WHERE Name = 'Jane Doe'];

        System.assertEquals(c3.Id, int1.Contact__c);
        System.assertEquals(acc1.Id, int1.Account__c);
        System.assertEquals('CT3_ROWID', c3.Contact_Row_Id__c);
        System.assertEquals('ACT1_ROWID', c3.Acct_Row_Id__c);
        System.assertEquals('int1@test.com', c3.Email);
        System.assertEquals('444-444-4444', c3.Phone);
        System.assertEquals('444-444-4445', c3.MobilePhone);
    }

    static testmethod void testUpdateContact() {
        Automation_Settings__c setting = new Automation_Settings__c();
        setting.Disable_Contact_Trigger__c = false;
        insert setting;

        Account acc1 = new Account(Name = 'test1', Acct_Row_Id__c='ACT1_ROWID');
        Account acc2 = new Account(Name = 'test2');
        insert new Account[] {acc1, acc2};

        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.Contact_Row_Id__c = 'CT1_ROWID';
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.Phone = '111-222-3333';
        c1.HomePhone = '111-222-4444';
        c1.Email = 'john.doe@test.com';
        c1.RecordTypeId = rectypeid;
        insert c1;

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact_Row_Id__c = 'CT1_ROWID';
        int1.Acct_Row_Id__c = 'ACT1_ROWID';
        int1.Contact_Type__c = 'Mailing';
        int1.Phone__c = '444-444-4444';
        int1.Email__c = 'int1@test.com';

        IntegrationRecord__c int2 = new IntegrationRecord__c();
        int2.Contact__c = c1.Id;
        int2.Account__c = acc1.Id;
        int2.Contact_Type__c = 'Mailing';
        int2.Phone__c = '444-444-4444';
        int2.Email__c = 'int2@test.com';

        insert new List<IntegrationRecord__c> {int1, int2};

        int1 = [SELECT Id FROM IntegrationRecord__c WHERE Id = :int1.Id];
        int1.Mobile_Phone__c = '444-444-4445';
        int1.Contact_Type__c = 'Billing';

        Test.startTest();
        update int1;
        Test.stopTest();

        int1 = [SELECT Contact__c, Account__c FROM IntegrationRecord__c WHERE Id = :int1.Id];

        c1 = [SELECT Id, MobilePhone, OtherPhone, Phone2__c, Phone3__c, Email_Address_2__c, Email_Address_3__c
              FROM Contact WHERE Id = :c1.Id];

        System.assertEquals(c1.Id, int1.Contact__c);
        System.assertEquals(acc1.Id, int1.Account__c);
        System.assert(c1.Phone2__c != null);
        System.assert(c1.Phone3__c != null);
        System.assert(c1.Email_Address_2__c != null);
        System.assert(c1.Email_Address_3__c != null);
    }

    static testMethod void testUpdateIntegrationToNoLongerMatchContact(){
        Automation_Settings__c setting = new Automation_Settings__c();
        setting.Disable_Contact_Trigger__c = false;
        insert setting;
        
        Account acc1 = new Account(Name = 'test1', Acct_Row_Id__c='ACT1_ROWID');
        Account acc2 = new Account(Name = 'test2');
        insert new Account[] {acc1, acc2};

        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.Contact_Row_Id__c = 'CT1_ROWID';
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.Phone = '111-222-3333';
        c1.HomePhone = '111-222-4444';
        c1.Email = 'john.doe@test.com';
        c1.RecordTypeId = rectypeid;
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

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact_Row_Id__c = 'CT3_ROWID';
        int1.First_Name__c = 'Jane';
        int1.Last_Name__c = 'Doe';
        int1.Contact_Type__c = 'Billing';
        int1.SourceCreatedDate__c = Datetime.now();
        int1.Acct_Row_Id__c = 'ACT1_ROWID';
        int1.Phone__c = '444-444-4444';
        int1.Mobile_Phone__c = '444-444-4445';
        int1.Email__c = 'int1@test.com';
        insert int1;

        Test.startTest();
        int1.First_Name__c = 'TestNonMatch';
        int1.Last_Name__c = 'TestNonMatch';
        update int1;
        Test.stopTest();


        int1 = [SELECT Contact__c, Account__c FROM IntegrationRecord__c WHERE Id = :int1.Id];

        Contact c3 = [SELECT Id, Contact_Row_Id__c, Acct_Row_Id__c, Email, Phone, MobilePhone
                      FROM Contact WHERE Name = 'Jane Doe'];

        System.assertNotEquals(c3.Id, int1.Contact__c);
    }

}