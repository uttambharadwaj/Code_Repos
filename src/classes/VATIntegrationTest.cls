@isTest
private class VATIntegrationTest {
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testVATIntegration() {

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'WES_Accounts' LIMIT 1].Id;

        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.RecordTypeId = rectypeid;
        acc1.WES_ISO_Country_Code__c = 'GB';
        acc1.WES_VAT_Reg_Num__c = '123456';

        Test.setMock(WebServiceMock.class, new MockResponseGenerator());

        Test.startTest();
        insert acc1;
        Test.stopTest();

        acc1 = [SELECT VAT_Check__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals('Pass', acc1.VAT_Check__c);
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
            VATCheckTypes.checkVatResponse_element res = new VATCheckTypes.checkVatResponse_element();
            res.valid = true;
            response.put('response_x', res);
        }
    }
}