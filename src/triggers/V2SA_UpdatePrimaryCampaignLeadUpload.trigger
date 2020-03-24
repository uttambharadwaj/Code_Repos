trigger V2SA_UpdatePrimaryCampaignLeadUpload on Lead (before insert) {
//	moved to LeadHelper 20/mar/2020
//
//	if(TriggerFactory.disabledTriggers(Lead.sObjectType)) return;
//Set<Id> AU_Lead_RTs = UtilityClass.getRecTypeByDevName('Lead',new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'});
//
// 	Set<Id> SetOfIds = new Set<Id>();
//    for(Lead Leads : trigger.new)
//    {
//		 if(!AU_Lead_RTs.contains(Leads.RecordTypeId))
//		 {
//		    SetOfIds.add(Leads.Id);
//		 }
//
//    }
//
//
//	for (Integer i = 0; i < trigger.new.size(); i++)
//
//	{
//		if(!AU_Lead_RTs.contains(trigger.new[i].RecordTypeId))
//		{
//			if(trigger.new[i].Primary_Campaign__c == null && trigger.new[i].sfcampaign_id__c != null) //&& camp[k].campaignID !=null)
//				trigger.new[i].primary_campaign__c = trigger.new[i].sfcampaign_id__c;//camp[k].campaignid;
//		}
//	}
}