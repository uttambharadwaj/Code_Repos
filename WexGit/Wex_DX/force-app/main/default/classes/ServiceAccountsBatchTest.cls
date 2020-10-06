@isTest
private class ServiceAccountsBatchTest {
    @testSetup
    static void setup(){
       UtilityTestLoader.setAutomation(false);
    }
    static testmethod void testContactRoles() {

        Id accRectypeid = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service_Operations').getRecordTypeId();

        Account acc1 = new Account(Name = 'test1',
                                   Primary_Contact_TXT__c='A-123456',
                                   Billing_Contact_TXT__c='A-123456',
                                   Admin_Contact_TXT__c='A-123456',
                                   Mailing_Contact_TXT__c='B-123456',
                                   Shipping_Contact_TXT__c='B-123456',
                                   Siebel_Fleet_Contact_TXT__c='B-123456',
                                   RecordTypeId = accRectypeid);
        insert acc1;

        Account acc2 = new Account(Name = 'test2', RecordTypeId = accRectypeid);
        insert acc2;

        Id ctRectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;

        Contact c1 = new Contact();
        c1.AccountId = acc1.Id;
        c1.FirstName = 'John';
        c1.LastName = 'Doe';
        c1.RecordTypeId = ctRectypeid;
        insert c1;

        Contact c2 = new Contact();
        c2.AccountId = acc1.Id;
        c2.FirstName = 'Jane';
        c2.LastName = 'Doe';
        c2.RecordTypeId = ctRectypeid;
        insert c2;

        Contact c3 = new Contact();
        c3.AccountId = acc2.Id;
        c3.FirstName = 'Peter';
        c3.LastName = 'Doe';
        c3.RecordTypeId = ctRectypeid;
        insert c3;

        insert new AccountContactRelation(ContactId=c3.Id, AccountId=acc1.Id, Roles='Shared Contact');

        IntegrationRecord__c int1 = new IntegrationRecord__c();
        int1.Contact__c = c1.Id;
        int1.Contact_Row_Id__c = 'A-123456';
        insert int1;

        IntegrationRecord__c int2 = new IntegrationRecord__c();
        int2.Contact__c = c2.Id;
        int2.Contact_Row_Id__c = 'B-123456';
        insert int2;

        Test.startTest();
        Database.executeBatch(new ServiceAccountsBatch());
        Test.stopTest();

        AccountContactRelation acr1 = [SELECT Roles FROM AccountContactRelation WHERE ContactId = :c1.Id AND AccountId = :acc1.Id];
        String[] roles1 = acr1.Roles.split(';');
        System.assertEquals(3, roles1.size());
        System.assert(roles1.contains('Primary Contact'));
        System.assert(roles1.contains('Billing Contact'));
        System.assert(roles1.contains('Admin Contact'));

        AccountContactRelation acr2 = [SELECT Roles FROM AccountContactRelation WHERE ContactId = :c2.Id AND AccountId = :acc1.Id];
        String[] roles2 = acr2.Roles.split(';');
        System.assertEquals(3, roles2.size());
        System.assert(roles2.contains('Mailing Contact'));
        System.assert(roles2.contains('Shipping Contact'));
        System.assert(roles2.contains('Fleet Contact'));

        AccountContactRelation acr3 = [SELECT Roles FROM AccountContactRelation WHERE ContactId = :c3.Id AND AccountId = :acc1.Id];
        String[] roles3 = acr3.Roles.split(';');
        System.assertEquals(1, roles3.size());
        System.assert(roles3.contains('Shared Contact'));
    }
}