@isTest
private class EMAP_Credit_Assessment_Controller_Test {

    static testMethod void myUnitTest() {
        
        Account acc =TestDatatUtility.getAccount();
        insert acc;
        
        Credit_Assessment__c creAss=TestDatatUtility.getCredit_Assessment();
        creAss.account__c=acc.id;
        creAss.Final_Judgement__c = '';
        creAss.Assessment_Sub_Status__c = 'In Progress';
        creAss.Nird__c = System.today();
        
        Pagereference pageRef = new Pagereference('/apex/EMAP_CreditAssessment_Page?retURL=%2F' + acc.id +'&accId=' + acc.id);
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(creAss);
        
        EMAP_Credit_Assessment_Controller credAssController = new EMAP_Credit_Assessment_Controller(stdController);
        
        stdController = new Apexpages.Standardcontroller(creAss);
        
        Test.startTest();
        
        credAssController = new EMAP_Credit_Assessment_Controller(stdController);
        
        credAssController.SaveAndNew();
        
        Test.stopTest();
        
    }
    
    static testMethod void myUnitTest2() {        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='AU System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@wexaustralia.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@wexaustralia.com');

        System.runAs(u) {
            Account acc =TestDatatUtility.getAccount();
            insert acc;
            
            Credit_Assessment__c creAss= new Credit_Assessment__c ();        
            creAss.Nird__c=System.today();
            creAss.RPS_Outcome__c = 'None';
            creAss.Common_Account_Check__c ='None';        
            creAss.account__c=acc.id;
            creAss.Final_Judgement__c = 'Approved';
            creAss.Assessment_Sub_Status__c = 'In Progress';        
            insert creAss;
            
            Pagereference pageRef = new Pagereference('/apex/EMAP_CreditAssessment_Page?retURL=%2F' + acc.id +'&accId=' + acc.id);
            Test.setCurrentPageReference(pageRef);
            
            Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(creAss);
            
            EMAP_Credit_Assessment_Controller credAssController = new EMAP_Credit_Assessment_Controller(stdController);
            
            stdController = new Apexpages.Standardcontroller(creAss);        
        }       
    }
    
}