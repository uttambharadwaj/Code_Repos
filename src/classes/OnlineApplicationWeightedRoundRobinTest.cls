@isTest
private class OnlineApplicationWeightedRoundRobinTest 
{
	static testMethod void test1() 
    {
        LeadRoundRobinQueue__c rrq = new LeadRoundRobinQueue__c();
        rrq.Name = 'Test';
        rrq.Standard_Queue_Id__c = [SELECT QueueId
                                    FROM QueueSobject q
                                    WHERE SObjectType = 'OnlineApplication__c' limit 1].QueueId;
        rrq.Next_Position__c = 1;
        insert rrq;

        LeadRoundRobinQueueMember__c rrm = new LeadRoundRobinQueueMember__c();
        rrm.Lead_Round_Robin_Queue__c = rrq.Id;
        rrm.Member__c = [SELECT Id FROM User WHERE isActive = TRUE LIMIT 1].Id;
        rrm.Position__c = 1;
        insert rrm;

        Account acc1 = new Account(Name = 'Test Acc');
        insert acc1;
        
        OnlineApplicationOffer__c oao = new OnlineApplicationOffer__c (
            Name = 'TestOffer-01',
            Application_Title__c = 'TestTitle',
            Complete_Later_Text__c = 'Test',
            EchoSign_User_Email__c = 'test@test.com',
            Terms_and_Conditions_Version__c = 'TestVersion-01'
        );
        
        insert oao;
        
        OnlineApplication__c req = new OnlineApplication__c();
        req.Account__c = acc1.Id;
        req.Offer__c = oao.Id;
        //req.Opportunity__c = opp.Id;
        insert req;

        req.OwnerId = [SELECT 
                       		Lead_Round_Robin_Queue__r.Standard_Queue_Id__c 
                       FROM 
                       		LeadRoundRobinQueueMember__c 
                       WHERE 
                       		Lead_Round_Robin_Queue__r.isActive__c = TRUE LIMIT 1].Lead_Round_Robin_Queue__r.Standard_Queue_Id__c;

        update req;

        Lead_RR_Queue_Member_Assignments__c ll = new Lead_RR_Queue_Member_Assignments__c();
        ll.weight__c = 4;
        ll.Member__c = [select id from user where isActive = true limit 1].id;
        ll.Lead_Round_Robin_Queue__c = rrq.id;
        insert ll;

        Lead_RR_Queue_Member_Assignments__c ll2 = new Lead_RR_Queue_Member_Assignments__c();
        ll2.weight__c = 3;
        ll2.Member__c = [select id from user where isActive = true and id != :rrm.member__c limit 1].id;
        ll2.Lead_Round_Robin_Queue__c = rrq.id;
        insert ll2;

        RoundRobinDistribution.loadDistribution(rrq.id);
    }
}