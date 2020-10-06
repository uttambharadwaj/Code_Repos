trigger OpportunityContactRole on OpportunityContactRole (after insert, after update) {

    TriggerFactory.createTriggerDispatcher(OpportunityContactRole.SObjectType);


}