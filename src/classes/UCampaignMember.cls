public class UCampaignMember {
	
	public static void setParentLead (List <CampaignMember> cms)
	{
		
		GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
		
		set <id> leadIds = new set <id>();
		
		for(CampaignMember cm : cms)
		{
			if(cm.leadId != null)
			{
				leadIds.add(cm.leadId);
			}
		}
		
		if(leadIds.size() == 0)
		{
			return;
		}
		
		Map <id, boolean> parentLeadMap = new Map <id, boolean>();
		
		for(Lead l : [select id, recordTypeId from lead where id in :leadIds and recordTypeId = :setting.Parent_Lead_Record_Type_Id__c])
		{
			parentLeadMap.put(l.id, true);
		}
		
		for(CampaignMember cm : cms)
		{
			if(cm.leadId != null && parentLeadMap.containsKey(cm.leadId) && parentLeadMap.get(cm.leadId) == true)
			{
				cm.Parent_Lead__c = true;	
			}
		}
		
	}
	
	public static void checkAssociations (List <CampaignMember> cms)
	{
		
		system.debug('------checkAssociations');
		
		set <id> leadIds = new set <id>();
		
		for(CampaignMember cm : cms)
		{
			if(cm.leadId != null && cm.contactId == null)
			{
				system.debug('------ here');
				leadIds.add(cm.leadId);
			}
		}
		
		if(LeadIds.size() == 0)
		{
			return;
		}
		
		set <id> parentLeadIds = new set <id>();
		
		for(Lead l : [select parent_lead__c from lead where id in :leadIds and parent_lead__c != null])
		{
			system.debug('------ here2');
			parentLeadIds.add(l.parent_lead__c);	
		}
		
		if(parentLeadIds.size() > 0)
		{
			system.debug('------ here3');
			reevaluateAssociations(parentLeadIds);	
		}
		
		
		
	}

	public static void reevaluateAssociations (set <id> parentLeads)
	{
		
		system.debug('-------reevaluateAssociations');
		
		
		
		Map <string, CampaignMember> existingChildData = new Map <string, CampaignMember>();
		
		for(Lead l : [select id, parent_lead__c,
					         (select campaignId, status
					          from CampaignMembers
					          Where isDeleted = false) 
					  from Lead 
					  where parent_lead__c in :parentleads
					  and parent_lead__c != null])
		{
			
			for(CampaignMember cm : l.CampaignMembers)
			{
				existingChildData.put(l.parent_lead__c + '-' + cm.campaignId, cm);
				system.debug('-----' + l.parent_lead__c + '-' + cm.campaignId);
			}			  	
		}
	
		Map <string, CampaignMember> existingParentData = new Map <string, CampaignMember>();
		
		for(CampaignMember cm : [select campaignId, leadId 
						         from CampaignMember 
						         where leadId in :parentLeads
						         and isdeleted = false])
		{
			existingParentData.put(cm.leadId + '-' + cm.campaignId, cm);
			system.debug('-----' + cm.leadId + '-' + cm.campaignId);
		}
		
		List <CampaignMember> cmsToCreate= new List <CampaignMember>();
		List <CampaignMember> cmsToDelete= new List <CampaignMember>();
		
		for(string x : existingChildData.keySet())
		{
			if(!existingParentData.containsKey(x))
			{
				system.debug('------add it');
				
				CampaignMember cm = new CampaignMember();
				cm.LeadId = x.substring(0,x.indexOf('-'));
				cm.CampaignId = existingChildData.get(x).campaignId;
				cm.Status = existingChildData.get(x).status;
				cmsToCreate.add(cm);	
			}
		}
		
		for(string x : existingParentData.keySet())
		{
			if(!existingChildData.containsKey(x))
			{
				system.debug('------delete it');
				cmsToDelete.add(existingParentData.get(x));
			}
		}
		
		if(cmsToCreate.size() > 0)
		{
			insert cmsToCreate;
		}
		
		if(cmsToDelete.size() > 0)
		{
			delete cmsToDelete;
		}
		
		
	
	}

	public static void setOpportunity (List <Lead> leads, Map <id, Lead> oldMap)
	{
		
		system.debug('-------------------------------');
		set <id> leadIds = new set <id>();
		
		for(Lead l : leads)
		{
			if(l.isConverted == true && oldMap.get(l.id).isConverted == false)
			{
				leadIds.add(l.id);
			}
		}
		
		if(leadIds.size() == 0)
		{
			return;
		}
		
		List <CampaignMember> cmsToUpdate = new List <CampaignMember>();
		
		set <string> parentLeads = new set <string>();
		set <id> parentLeadIds = new set <id>();
		
		for(Lead l : [select id, parent_lead__c,
					         (select CampaignId From CampaignMembers) 
					  from Lead where id in :leadIds and isdeleted = false])
		{
			
			for(CampaignMember cm : l.CampaignMembers)
			{
				cm.Converted_to_Oppty__c = true;
				cmsToUpdate.add(cm);
				
				// get the parent record
				if(l.parent_lead__c != null)
				{
					string parentLead = (id)l.parent_lead__c;
					parentLead = parentLead.substring(0,15);
				
					string campaignId = (id)cm.CampaignId;
					campaignId = campaignId.substring(0,15);
				
					parentLeads.add(parentLead + '-' + campaignId);
					parentLeadIds.add(l.parent_lead__c);
				
					system.debug('-----' + parentLeads);
					system.debug('-----' + parentLeadIds);
				}
					
			}	
			
			
		}
		
		
		// update the parent
		if(parentLeadIds.size() > 0)
		{
			for(CampaignMember cm : [select id, leadId, Converted_to_Oppty__c, campaignId 
									 from campaignMember
									 where leadId in :parentLeadIds 
									 and LeadCampaign__c in :parentLeads
									 and isdeleted = false])
			{
				system.debug('------' + cm.leadId);
				system.debug('------' + cm.campaignId);
				
				cm.Converted_to_Oppty__c = true;
				cmsToUpdate.add(cm);	
			}
		}
		
		
		if(cmsToUpdate.size() > 0)
		{
			update cmsToUpdate;
		}
	
	}


	public static void updateCounts (List <CampaignMember> records)
	{
		set <id> cIds = new set <id>();
		
		for(CampaignMember cm : records)
		{
			cIds.add(cm.campaignId);
		}		
		
		UCampaign.countUniqueLeads(cIds);
	}

	public static void linkParentLead (List <CampaignMember> records)
	{
		
		// when a lead is added, needs to see if it has a parent and add that lead as well
		
		Map <id, CampaignMember> leadMap = new Map <id, CampaignMember>();
			
		for(CampaignMember cm : records)
		{
			if(cm.LeadId != null && cm.contactId == null)
			{
				system.debug('-----LeadMap ' + cm.leadId);
				leadMap.put(cm.leadId, cm);	
			}
		}
		
		if(leadMap.size() == 0)
		{
			return;
		}
		
		Map <string, id> parentLeadCampaignMap = new Map <string, id>();
		set <id> parentLeadIds = new set <id>();
		
		for(lead l : [select id, Parent_Lead__c, parent_lead__r.isConverted 
		              from Lead 
		              where id in :leadMap.keySet() 
		              and parent_lead__c != null
		              and parent_lead__r.isConverted = false])
		{
			
			// formula field only has 15 character ids
			string parentLead = (string)l.parent_lead__c;
			parentLead = parentLead.substring(0,15);
			
			string campaignId = (string)leadMap.get(l.id).campaignId;
			campaignId = campaignId.substring(0,15);
			
			system.debug('-----' + parentLead + '-' + campaignId);
			system.debug('-----' + l.parent_lead__c);
			
			parentLeadCampaignMap.put(parentLead + '-' + campaignId, l.id);
			parentLeadIds.add(l.parent_lead__c);
		}
		
		if(parentLeadCampaignMap.size() == 0)
		{
			return;
		}
		
		set <string> parentExists = new set <string>();
		
		for(CampaignMember cm : [select id, leadId, leadCampaign__c
							     from Campaignmember 
							     where leadCampaign__c in :parentLeadCampaignMap.keySet()
							     and leadId in :parentLeadIds
							     and isdeleted = false])
		{
			parentExists.add(cm.leadCampaign__c);	
		}
		
		List <CampaignMember> cmsToCreate = new List <CampaignMember>();
		
		
		for(string parentCampaign : parentLeadCampaignMap.keySet())
		{
			// if it already exists, do nothing
			if(!parentExists.contains(parentCampaign))
			{
				//break out the data	
				id originalLeadId = parentLeadCampaignMap.get(parentCampaign);
				CampaignMember originalCM = leadMap.get(originalLeadId);
				id parentLeadId =  parentCampaign.substring(0,parentCampaign.indexOf('-'));
				
				CampaignMember cm = new CampaignMember();
				cm.LeadId = parentLeadId;
				cm.CampaignId = originalCM.campaignId;
				cm.Status = originalCM.status;
				cmsToCreate.add(cm);
				
				// if two in the same batch
				parentExists.add(parentLeadId + '-' + cm.campaignId);
			}
		}
		
		if(cmsToCreate.size() > 0)
		{
			insert cmsToCreate;
		}
		
	}

}