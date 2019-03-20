public class UCampaign {
	
	public static void countUniqueLeads (set <id> campaignIds)
	{
		GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
		Map <id, integer> cCounts = new Map <id, integer>();
		
		for(id cId : campaignIds)
		{
			cCounts.put(cId, 0);
		}
		
		for(Campaign c : [select id, of_Unique_Leads__c,
								 (Select Lead.parent_lead__c 
								  From CampaignMembers
								  where Lead.RecordTypeId = :gs.Parent_Lead_Record_Type_Id__c //Lead.parent_lead__c = null
								  and contactId = null
								  and leadId != null)
						  from Campaign 
						  where id in :campaignIds])
		{
			for(CampaignMember cm : c.CampaignMembers)
			{
				cCounts.put(c.id, cCounts.get(c.id) + 1);
			}
		}		
		
		List <Campaign> campaignsToUpdate = new List <Campaign>();
		
		for(id cId : campaignIds)
		{
			Campaign c = new Campaign(id=cId);
			c.of_Unique_Leads__c = cCounts.get(cId);
			campaignsToUpdate.add(c);
		}
		
		update campaignsToUpdate;
		
	}

}