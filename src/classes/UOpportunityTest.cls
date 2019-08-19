@isTest
private class UOpportunityTest {


    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @isTest
    static void test_create_tasks() {

        SetUpAccountSettings__mdt cmdt = [ SELECT developerName, subject__c FROM SetUpAccountSettings__mdt LIMIT 1 ];

        Account acct = new Account(
            name = 'Test Account'
        );

        insert acct;

        Campaign cmpn = new Campaign(
            name = 'Test Campaign',
            isActive = true,
            coupon_code__c = cmdt.developerName
        );

        insert cmpn;

        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);

        Test.setMock( HttpCalloutMock.class, new GenericHttpCalloutMockImpl( response ) );

        Test.startTest();

        Opportunity oppty = new Opportunity(
            name = 'Test Opportunity',
            recordTYpeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId(),
            accountId = acct.id,
            closeDate = Date.today(),
            amount = 100,
            stageName = '5) Signed',
            campaignId = cmpn.id,
            error_log__c = 'Success'
        );

        insert oppty;

        update oppty;

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM Task WHERE whatId = :oppty.id AND subject = :cmdt.subject__c ] );

    }

}