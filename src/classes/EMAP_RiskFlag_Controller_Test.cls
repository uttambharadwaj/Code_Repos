@isTest
private class EMAP_RiskFlag_Controller_Test {

    static testMethod void myUnitTest() {
      
      Account acc =TestDatatUtility.getAccount();
      insert acc;
      
      Risk_Flag__c riskFlag=TestDatatUtility.getRiskFlag();
      riskFlag.account__c=acc.id;
      riskFlag.Status__c = 'Initiated';
      riskFlag.Closed_Date__c=System.today();
      
      Pagereference pageRef = new Pagereference('/apex/EMAP_RiskFlag_Page?accId=' + acc.id +'&retURL=%2F=' + acc.id);
      Test.setCurrentPageReference(pageRef);
      
      Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(riskFlag);
      
      EMAP_RiskFlag_Controller riskFlagController = new EMAP_RiskFlag_Controller(stdController);
      
      stdController = new Apexpages.Standardcontroller(riskFlag);
      
      Test.startTest();
        
      riskFlagController = new EMAP_RiskFlag_Controller(stdController);
      
      riskFlagController.SaveAndNew();
      
      Test.stopTest();
      
    }
}