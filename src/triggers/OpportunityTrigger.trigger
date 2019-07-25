/*
 * Created by MFarrell on 7/23/2019.
 * Implementing Trigger Factory Framework for Opportunity.
 *
 */

trigger OpportunityTrigger on Opportunity (after insert, before update) {
    TriggerFactory.createTriggerDispatcher(Opportunity.sObjectType);
}