@isTest
private class IFCSIntegrationTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testIFCSIntegration() {
        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.WES_ISO_Country_Code__c = 'GB';
        acc1.Company_registration_number__c = '00000006';
        insert acc1;

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.RecordTypeId = rectypeid;

        Test.setMock(WebServiceMock.class, new MockResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new WESAppReq_MockHttpResponseGenerator());
        new WexRadiusCustomerOnboarding.PricingOverrideType();
        new WexRadiusCustomerOnboarding.FuelCardDetailType();

        Test.startTest();
        insert req;
        IFCSIntegration.sendApplicationToIFCS(new Set<Id> {req.Id});
        Test.stopTest();

        req = [SELECT IFCS_Response__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals('success', req.IFCS_Response__c);
    }

    class MockResponseGenerator implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            WexRadiusCustomerOnboarding.OnboardCustomerResponseType res = new  WexRadiusCustomerOnboarding.OnboardCustomerResponseType();
            res.status = 'success';
            response.put('response_x', res);
        }
    }

}