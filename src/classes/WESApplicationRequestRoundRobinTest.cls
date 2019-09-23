@istest
public class WESApplicationRequestRoundRobinTest {
//    static testMethod void test1() {
//
//        LeadRoundRobinQueue__c rrq = new LeadRoundRobinQueue__c();
//        rrq.Name = 'Test';
//        rrq.Standard_Queue_Id__c = [Select QueueId
//                                    From QueueSobject q
//                                    where sobjecttype = 'WES_Application_Request__c'
//                                            limit 1].QueueId;
//        rrq.Next_Position__c = 1;
//        insert rrq;
//
//        LeadRoundRobinQueueMember__c rrm = new LeadRoundRobinQueueMember__c();
//        rrm.Lead_Round_Robin_Queue__c = rrq.id;
//        rrm.Member__c = [select id from user where isActive = true limit 1].id;
//        rrm.Position__c = 1;
//        insert rrm;
//
//        Account acc1 = new Account(name='test1');
//        insert acc1;
//        WES_Application_Request__c req = new WES_Application_Request__c();
//        req.Account__c = acc1.Id;
//        insert req;
//
//        req.ownerid = [Select Lead_Round_Robin_Queue__r.Standard_Queue_Id__c From LeadRoundRobinQueueMember__c where Lead_Round_Robin_Queue__r.isActive__c = true limit 1].Lead_Round_Robin_Queue__r.Standard_Queue_Id__c ;
//
//        update req;
//
//        Lead_RR_Queue_Member_Assignments__c ll = new Lead_RR_Queue_Member_Assignments__c();
//        ll.weight__c = 4;
//        ll.Member__c = [select id from user where isActive = true limit 1].id;
//        ll.Lead_Round_Robin_Queue__c = rrq.id;
//        insert ll;
//
//        Lead_RR_Queue_Member_Assignments__c ll2 = new Lead_RR_Queue_Member_Assignments__c();
//        ll2.weight__c = 3;
//        ll2.Member__c = [select id from user where isActive = true and id != :rrm.member__c limit 1].id;
//        ll2.Lead_Round_Robin_Queue__c = rrq.id;
//        insert ll2;
//
//        RoundRobinDistribution.loadDistribution(rrq.id);
//    }
}