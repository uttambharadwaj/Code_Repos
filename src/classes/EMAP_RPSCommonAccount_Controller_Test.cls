@isTest
private class EMAP_RPSCommonAccount_Controller_Test{
    
    static testMethod void checkRPSMatch()
    {
        
        Restricted_Account__c RestrictedAccount = TestDatatUtility.getRestrictedCommonAccount();
        RestrictedAccount.name = 'Test Restricted Account';
        RestrictedAccount.Type__c ='Restricted Account';
        RestrictedAccount.country__c = 'India';
        insert RestrictedAccount;
        
        Account acc = TestDatatUtility.getAccount();
        acc.name = 'Test Restricted Account';
        acc.shippingcountry = 'India';
        insert acc;
        
        Credit_Assessment__c credAssess = TestDatatUtility.getCredit_Assessment();
        credAssess.Account__c = acc.id;
        insert credAssess;
        
        Pagereference pageRef = new Pagereference('/apex/RPSCommaonAccountPage?id='+credAssess.Id+'&IsRPSButton=yes&IsCommonAccButton=No');
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(credAssess);
        
        EMAP_RPSCommonAccount_Controller controller = new EMAP_RPSCommonAccount_Controller(stdController);

        controller.populateAccountList();

        controller.selectedAcc = 'Test Restricted Account';
        
        Test.startTest();
        
        controller.matchRecord();
        
        Test.stopTest();
        
        Credit_Assessment__c CheckMatch = [select id, RPS_Outcome__c From Credit_Assessment__c where id =: credAssess.id];
        system.assertEquals('Test Restricted Account', CheckMatch.RPS_Outcome__c);
    
    }
    
    static testMethod void checkRPSNOMatch()
    {
        
        Restricted_Account__c RestrictedAccount = TestDatatUtility.getRestrictedCommonAccount();
        RestrictedAccount.name = 'Test Restricted Account';
        RestrictedAccount.Type__c ='Restricted Account';
        insert RestrictedAccount;
        
        Account acc = TestDatatUtility.getAccount();
        acc.name = 'Test Restricted Account';
        insert acc;
        
        Credit_Assessment__c credAssess = TestDatatUtility.getCredit_Assessment();
        credAssess.Account__c = acc.id;
        insert credAssess;
        
        Pagereference pageRef = new Pagereference('/apex/RPSCommaonAccountPage?id='+credAssess.Id+'&IsRPSButton=yes&IsCommonAccButton=No');
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(credAssess);
        
        EMAP_RPSCommonAccount_Controller controller = new EMAP_RPSCommonAccount_Controller(stdController);
        
        controller.populateAccountList();

        Test.startTest();

        controller.nomatchRecord();
        
        Test.stopTest();
        
        Credit_Assessment__c CheckMatch = [select id, RPS_Outcome__c From Credit_Assessment__c where id =: credAssess.id];
        system.assertEquals('No Match', CheckMatch.RPS_Outcome__c);
        
        
    }
    
    static testMethod void checkCommonMatch()
    {
        
        Restricted_Account__c RestrictedAccount = TestDatatUtility.getRestrictedCommonAccount();
        RestrictedAccount.name = 'Test Common Account';
        RestrictedAccount.Type__c ='Common Account';
        insert RestrictedAccount;
        
        Account acc = TestDatatUtility.getAccount();
        acc.name = 'Test Restricted Account 123456';
        insert acc;
        
        Account acc1 = TestDatatUtility.getAccount();
        acc1.name = 'Test Restricted Account 12345678';
        insert acc1;

        
        Credit_Assessment__c credAssess = TestDatatUtility.getCredit_Assessment();
        credAssess.Account__c = acc.id;
        insert credAssess;
        
        Pagereference pageRef = new Pagereference('/apex/RPSCommaonAccountPage?id='+credAssess.Id+'&IsRPSButton=No&IsCommonAccButton=Yes');
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(credAssess);
        
        EMAP_RPSCommonAccount_Controller controller = new EMAP_RPSCommonAccount_Controller(stdController);
        
        controller.populateAccountList();

        List<EMAP_RPSCommonAccount_Controller.checkWrapper> CommonAccList = new List<EMAP_RPSCommonAccount_Controller.checkWrapper>();
        
        EMAP_RPSCommonAccount_Controller.checkWrapper cw = new EMAP_RPSCommonAccount_Controller.checkWrapper(RestrictedAccount, true);
        CommonAccList.add(cw);
        
        controller.restrictedCommonList = new List<EMAP_RPSCommonAccount_Controller.checkWrapper>();
        controller.restrictedCommonList.add(cw);

        Test.startTest();
        
        controller.matchRecordNew();
        
        Test.stopTest();
        
        Credit_Assessment__c CheckMatch = [select id, Common_Account_Check__c from Credit_Assessment__c where id =: credAssess.id];
        //system.assertEquals('Test Common Account', CheckMatch.Common_Account_Check__c);
    }
    
    static testMethod void checkCommonNoMatch()
    {
        
        Restricted_Account__c RestrictedAccount = TestDatatUtility.getRestrictedCommonAccount();
        RestrictedAccount.name = 'Test Common Account';
        RestrictedAccount.Type__c ='Common Account';
        insert RestrictedAccount;
        
        Account acc = TestDatatUtility.getAccount();
        acc.name = 'Test Common Account';
        insert acc;
        
        Credit_Assessment__c credAssess = TestDatatUtility.getCredit_Assessment();
        credAssess.Account__c = acc.id;
        insert credAssess;
        
        Pagereference pageRef = new Pagereference('/apex/RPSCommaonAccountPage?id='+credAssess.Id+'&IsRPSButton=No&IsCommonAccButton=Yes');
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(credAssess);
        
        EMAP_RPSCommonAccount_Controller controller = new EMAP_RPSCommonAccount_Controller(stdController);

        controller.populateAccountList();
        
        Test.startTest();
        
        controller.nomatchRecord();
        
        Test.stopTest();
        
        Credit_Assessment__c CheckMatch = [select id, Common_Account_Check__c from Credit_Assessment__c where id =: credAssess.id];
        system.assertEquals('No Match', CheckMatch.Common_Account_Check__c);
    }

    static testMethod void otherMethods()
    {
        Restricted_Account__c RestrictedAccount = TestDatatUtility.getRestrictedCommonAccount();
        RestrictedAccount.name = 'Test Restricted Account';
        RestrictedAccount.Type__c ='Restricted Account';
        insert RestrictedAccount;
        
        Account acc = TestDatatUtility.getAccount();
        acc.name = 'Test Restricted Account';
        insert acc;
        
        Credit_Assessment__c credAssess = TestDatatUtility.getCredit_Assessment();
        credAssess.Account__c = acc.id;
        credAssess.RPS_Outcome__c = 'No match';
        credAssess.Common_Account_Check__c = 'No match';
        insert credAssess;
        
        Pagereference pageRef = new Pagereference('/apex/RPSCommaonAccountPage?id='+credAssess.Id+'&IsRPSButton=yes&IsCommonAccButton=yes');
        Test.setCurrentPageReference(pageRef);
        
        Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller(credAssess);
        
        EMAP_RPSCommonAccount_Controller controller = new EMAP_RPSCommonAccount_Controller(stdController);
        
        Test.startTest();
        
        controller.creditAssessment = credAssess;        
        
        controller.populateAccountList();
        
        controller.clearPrevResults();
        
        Test.stopTest();
        
        Credit_Assessment__c CheckMatch = [select id, RPS_Outcome__c, Common_Account_Check__c 
        from Credit_Assessment__c where id =: credAssess.id];
        system.assertEquals(null, CheckMatch.RPS_Outcome__c);
        system.assertEquals(null, CheckMatch.Common_Account_Check__c);
    }
   

}