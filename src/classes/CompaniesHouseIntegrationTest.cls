@isTest
private class CompaniesHouseIntegrationTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testCompaniesIntegration() {
        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'WES_Accounts' LIMIT 1].Id;

        Account acct = new Account();
        acct.Name = 'test acct';
        acct.RecordTypeId = rectypeid;
        acct.Company_registration_number__c = '05376709';

        Test.setMock(HttpCalloutMock.class, new WESAppReq_MockHttpResponseGenerator());

        Test.startTest();
        insert acct;
        Test.stopTest();

        acct = [SELECT WES_CompaniesHouseInfo__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('GREENFIELD PLANT LIMITED, Regency House, 61a Walton Street, Walton On The Hill, Surrey, KT20 7RZ', acct.WES_CompaniesHouseInfo__c);
    }
}