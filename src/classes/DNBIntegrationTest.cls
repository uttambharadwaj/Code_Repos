@isTest
private class DNBIntegrationTest {
    static testmethod void testDNBIntegration() {
        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.WES_ISO_Country_Code__c = 'GB';
        acc1.Company_registration_number__c = '00000006';
        insert acc1;

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.RecordTypeId = rectypeid;
        req.Companies_House_Check__c = 'Pass';

        Test.setMock(HttpCalloutMock.class, new WESAppReq_MockHttpResponseGenerator());
        
        String dnbDUNSResponse = '{"MatchResponse": {"MatchResponseDetail": {"MatchCandidate": [{"DUNSNumber": "1234567890"} ] } } }';
        DNBDUNSNumberResponse.parse(dnbDUNSResponse);

        Test.startTest();
        insert req;
        DNBIntegration.getFailureScoreAndRisk(new Set<Id>{req.Id});
        Test.stopTest();

        req = [SELECT DNB_Risk__c, DNB_Failure_Score__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        System.assertEquals(4, req.DNB_Risk__c);
        System.assertEquals(9, req.DNB_Failure_Score__c);
    }

    static testmethod void testCreditDetails() {
        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.WES_ISO_Country_Code__c = 'GB';
        acc1.Company_registration_number__c = '00000006';
        insert acc1;

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c req = new WES_Application_Request__c();
        req.Account__c = acc1.Id;
        req.RecordTypeId = rectypeid;
        req.Companies_House_Check__c = 'Pass';

        Test.setMock(HttpCalloutMock.class, new WESAppReq_MockHttpResponseGenerator());

        Test.startTest();
        insert req;
        DNBIntegration.getFailureScoreAndRisk(new Set<Id>{req.Id});
        Test.stopTest();

        req = [SELECT WES_Credit_Details__c FROM WES_Application_Request__c WHERE Id = :req.Id];
        ContentDocumentLink cdLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :req.WES_Credit_Details__c];
        System.assert(req.WES_Credit_Details__c!=null);
        System.assert(cdLink.ContentDocumentId!=null);
    }
}