/*
	Created By : Phillip Southern (GearsCRM)
	Created Date: 11.21.2013
	Notes: Utility class for campaign program object.

*/


public class UCampaignProgram {
	
	public static void setDefaultProgram(List<Campaign_Program__c> records, Map<Id,Campaign_Program__c> oldmap)
	{
		boolean isinsert = (oldmap == null);
		Set<Id> campaignScope = new Set<Id>();
		for(campaign_program__c cc : records)
		{
			if(cc.campaign__c != null) campaignscope.add(cc.campaign__c);
		}
		Map<Id,Campaign> campaignReference = new Map<Id,Campaign>([Select Id, Default_Program__c from Campaign Where Id IN :campaignscope]);
		
		Map<Id,Campaign> campaignstoupdate = new map<Id,campaign>();
		for(Campaign_Program__c cp : records)
		{
			if(cp.Campaign__c != null && cp.Program__c !=null && campaignreference.get(cp.campaign__c).default_program__c == null
			//cp.Campaign__r.Default_Program__c == null
			//&& (isinsert || cp.Campaign__c != oldmap.get(cp.Id).Campaign__c || cp.Program__c != oldmap.get(cp.Id).Program__c)
			)
			{
				Campaign c = new Campaign(Id = cp.Campaign__c, Default_Program__c = cp.Program__c, Default_Campaign_Program__c = cp.Id);
				campaignstoupdate.put(c.Id,c);
			}
		}
		
		if(campaignstoupdate.size()>0) update campaignstoupdate.values();
	}

}