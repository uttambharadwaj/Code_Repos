@isTest
private class IFCSInboundServiceTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testService() {
        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.WES_ISO_Country_Code__c = 'GB';
        acc1.Company_registration_number__c = '00000006';
        insert acc1;

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.RecordTypeId = rectypeid;
        req.requestID__c = 123456;
        insert req;

        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"orderId":"123456","customerNumber":"16330004330","accessCode":"a7gpskiodw74zlrcyepw"}');
        RestContext.request = request;

        Test.setMock(HttpCalloutMock.class, new WESAppReq_MockHttpResponseGenerator());

        Test.startTest();
        IFCSInboundService.doPost();
        Test.stopTest();

        acc1 = [SELECT IFCS__c FROM Account WHERE Id = :acc1.Id];

        System.assertEquals('16330004330', acc1.IFCS__c);
    }
}