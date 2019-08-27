trigger CampaignTrigger on Campaign (before insert) {

    TriggerFactory.createTriggerDispatcher(Campaign.SObjectType);

}