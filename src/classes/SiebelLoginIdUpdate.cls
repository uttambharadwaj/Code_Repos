/*

    Revision History:       20Jul2020       MFarrell        updated UserList1 and 2 so they pulled the correct type of user.

*/

@isTest
private class SiebelLoginIdUpdate
{

    static testMethod void verifySiebelLoginIdUpdateTrigger()
    {

        // TODO - rewrite this test
        test.startTest();

        Account acc = new Account(Name='Account 1',Industry='what',Type='hello');
        insert acc;

        Campaign cam = new Campaign(Name='Cam 1',Coupon_Code__c='test134',Type='Acquire',Status='Planned',Drop_Date__c=date.today());
        insert cam;

        List <User> UserList1 = new List <User> ([SELECT Id FROM User WHERE Alias != 'sinte' AND IsActive = TRUE AND Profile.Name = 'IS Sales' LIMIT 1]);

        Opportunity opp = new Opportunity(Name='Opp 1',AccountId=acc.Id,closedate=date.today(),StageName='1) Qualified',CampaignID=cam.Id, OwnerID=UserList1[0].Id);
        insert opp;

        List <User> UserList2 = new List <User> ([SELECT Id FROM User WHERE Alias = 'Sinte' LIMIT 1]);

        Task tas1 = new Task(OwnerId=UserList2[0].Id, Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
        insert tas1;

        Task tas2 = new Task(Subject='Call', Activity_Type__c='Email', ActivityDate=date.today(), Status='Not Started', Priority='3-Medium',WhatID=opp.Id);
        insert tas2;

        tas2.OwnerId=UserList2[0].Id;
        update tas2;

        test.stopTest();
    }
}