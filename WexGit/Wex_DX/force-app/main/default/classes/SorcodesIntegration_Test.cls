@isTest
  public class SorcodesIntegration_Test 
{
  string EndPoint='https://api.iban.com/clients/api/v4/sort/';
    public  static testmethod void testsorcodesintegration() 
     {
        Account acc1 = new Account();
        acc1.Name = 'test123';
        insert acc1;

        Id rectypeid = [SELECT Id FROM RecordType WHERE sObjectType = 'WES_Application_Request__c' AND DeveloperName = 'WES_Limited_Company' LIMIT 1].Id;

        WES_Application_Request__c obj = new WES_Application_Request__c();
        obj.Account__c = acc1.Id;
        obj.RecordTypeId = rectypeid;
        obj.bankIdentifier__c='401000';
        obj.bankAccountNumber__c='91805762';
        
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        test.startTest(); 
        Apexpages.StandardController sc = new Apexpages.StandardController(obj);
        SorcodesIntegration myobj=new SorcodesIntegration(sc);
        myobj.sortcode='401000';
        myobj.account='91805762';
        myobj.api_Key='54ac699cdd4680310ba9c7ca56b0053c';
        myobj.EndPoint='https://api.iban.com/clients/api/v4/sort';
        test.stopTest();
        System.assertEquals(myobj.sort_found1,'{code=002, message=Sort Code found in bank directory}');
        System.assertEquals(myobj.modulus,'{code=001, message=Modulus Success: Check digit is valid}');
        System.assertEquals(myobj.dd, 'YES');     
   }
}