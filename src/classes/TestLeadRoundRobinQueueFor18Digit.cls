public with sharing class TestLeadRoundRobinQueueFor18Digit {

   static testMethod void domainExists(){
      LeadRoundRobinQueue__c l = new LeadRoundRobinQueue__c();
      l.Standard_Queue_Id__c = [Select QueueId, Id, CreatedById From QueueSobject where sobjecttype = 'Lead' limit 1].id;
      l.next_position__c = 1;
      l.isActive__c = false;
      insert l;
   }

}