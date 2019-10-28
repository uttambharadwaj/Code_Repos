@isTest
private class SiebelLoginIdUpdate
{

    static testMethod void verifySiebelLoginIdUpdateTrigger()
    {
    
        test.startTest();

        Account acc = new Account(Name='Account 1',Industry='what',Type='hello');
        insert acc;

        Campaign cam = new Campaign(Name='Cam 1',Coupon_Code__c='test134',Type='Acquire',Status='Planned',Drop_Date__c=date.today());
        insert cam;

        List <User> UserList1 = new List <User> ([Select Id from User where Id != '00570000001Lkjs' and isActive = true LIMIT 1]);

        Opportunity opp = new Opportunity(Name='Opp 1',AccountId=acc.Id,closedate=date.today(),StageName='1) Qualified',CampaignID=cam.Id, OwnerID=UserList1[0].Id);
        insert opp;

       //Salesforce Integration Id in Sandbox = 00570000001Lkjs
       //Salesforce Integration Id in Live Org = 00570000001Lkjs

        List <User> UserList2 = new List <User> ([Select Id from User where Id = '00570000001Lkjs']);


        Task tas1 = new Task(OwnerId='00570000001Lkjs', Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
        insert tas1;

        Task tas2 = new Task(Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
        insert tas2;

        tas2.OwnerId='00570000001Lkjs';
        update tas2;

        test.stopTest();
    }
}