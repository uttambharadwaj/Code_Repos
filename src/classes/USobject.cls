/*
*	Created by: Phillip Southern (GearsCRM)
*	Date: 03/12/2014
*	Notes: Utility library to handle similar requests across objects.
*/

public class USobject {
	
	public static void mergeContactRelatedItems(Map<Id,Set<Id>> records)
	{
		system.debug('-- records: ' + records);

		//Map<string, sobject> toupdate = new Map<string,sobject>();
		//Map<string,Map<id,sobject>> recordstoprocess = new Map<string,map<id,sobject>>();
		Map<id,id> winningbylosing = new map<id,id>();
		set<id> losingcontactIds = new set<Id>();
		set<Id> winningcontactids = new set<Id>();
		
		//for(Set<Id> ids : records.values())
		for(Id winC : records.keyset())
		{
			
			losingcontactIds.addall(records.get(winC));//(ids);
			winningcontactids.add(winc);
			
			for(Id losC : records.get(winC))
			{
				winningByLosing.put(losC,winC);
			}
		}
		system.debug('-- winningbylosing: ' + winningbylosing);
		
		for(Contact_Merge_Settings__c cms : Contact_Merge_Settings__c.getall().values())
		{
			system.debug('-- cms: ' + cms);
			
			if(cms.Active__c && cms.object__c!=null && cms.field__c !=null) // && cms.relationship__c != null)
			{
				if(cms.object__c.tolowercase() == 'campaignmember')
				{
					List<CampaignMember> cmstoinsert = new List<CampaignMember>();
					Set<String> runningCMCheck  = new Set<String>();
					Map<Id,Set<Id>> contactsWithMembers = new Map<Id,Set<Id>>();
					
					for(CampaignMember cm : [Select ContactId, CampaignId from CampaignMember Where ContactId IN :winningContactIds])
					{
						set<id> campids = new set<Id>();
						if(contactswithmembers.containskey(cm.contactid)) campids = contactswithmembers.get(cm.contactid);
						campids.add(cm.campaignid);
						contactswithmembers.put(cm.contactid, campids);
					}
					
					for(CampaignMember cm2 : [Select ContactId, CampaignId, Status from CampaignMember Where ContactId IN :losingcontactids])
					{
						if(
						(contactswithmembers.containskey(winningbylosing.get(cm2.contactid))
						&& (contactswithmembers.get(winningbylosing.get(cm2.contactid))).contains(cm2.campaignid))
						|| runningCMCheck.contains(winningbylosing.get(cm2.contactid)+'-'+cm2.CampaignId)					
						) continue;
						
						CampaignMember newCM = new CampaignMember();
						newCM.CampaignId = cm2.CampaignId;
						newCM.Status = cm2.Status;
						newCM.ContactId = winningbylosing.get(cm2.contactid);
						cmstoinsert.add(newcm);
						
						runningCMCheck.add(winningbylosing.get(cm2.contactid)+'-'+cm2.CampaignId);
					}
					
					if(cmstoinsert.size()>0) insert cmstoinsert;
					
				}else if(cms.object__c.tolowercase() == 'task')
				{
					Set<String> existingTaskRelations = new Set<String>();
					for(TaskRelation trexisting : [Select RelationId, TaskId from TaskRelation Where RelationId IN: winningContactIds AND IsDeleted = false])
					{
						existingTaskRelations.add(trexisting.RelationId+'-'+trexisting.TaskId);
					}
					
					List<TaskRelation> toinsert = new List<TaskRelation>();
					
					for(TaskRelation tr : [Select RelationId, TaskId from TaskRelation Where RelationId IN :losingcontactIds AND IsDeleted = false])
					{
						if(existingTaskRelations.contains(tr.RelationId+'-'+tr.TaskId)) continue;
						
						TaskRelation newTr = new TaskRelation();
						newTr.TaskId = tr.TaskId;
						newTr.RelationId = winningbylosing.get(tr.RelationId);
						toinsert.add(newTR);
					}
					
					system.debug('-- toinsert tasks: ' + toinsert);
					
					if(toinsert.size()>0) insert toinsert;
					
					
					
				}else if(cms.object__c.tolowercase() == 'lead')
				{
					List<Lead> toupdate = new List<Lead>();
					for(Lead l : [Select Id, Related_Contact__c From Lead Where Related_Contact__c IN :losingcontactIds AND Isconverted = false])
					{
						if(!winningbylosing.containskey(l.Id)) continue;
						Lead templead = new Lead(Id=l.Id, Related_contact__c = winningbylosing.get(l.Id));
						toupdate.add(templead);
					}
					
					if(toupdate.size()>0) update toupdate;
					
				}else
				{
					//****Everything else
					List<sobject> itemstoupdate = new list<sobject>();
					
					string query = 'Select Id, ' + cms.field__c + ' from ' + cms.object__c + 
					' Where ' + cms.field__c + ' IN :losingcontactIds';
					
					
					system.debug('-- query: ' + query);
					
					for(sobject s : database.query(query))
					{
						system.debug('-- s: ' + s);
						
						id losingcontact = (Id)(s.get(cms.field__c));
						Contact c = new Contact(id=winningbylosing.get(losingcontact));
						//s.putsobject(cms.relationship__c,c);
						s.put(cms.field__c,c.id);
						itemstoupdate.add(s);
						
						system.debug('-- losing contact: ' + losingcontact);
						system.debug('-- contact: ' + c);
						system.debug('-- itemstoupdate: ' + itemstoupdate);
					}
					
					if(itemstoupdate.size()>0) update itemstoupdate;
				}
				
			}
			
		}
		
		/*for(Id winningcontact : records.keyset())
		{
			
			Contact c = new Contact(Id=winningcontact);
			for(Contact_Merge_Settings__c cms : Contact_Merge_Settings__c.getall().values())
			{
				if(cms.Active__c && cms.object__c!=null && cms.field__c !=null && cms.relationship__c != null)
				{
					if(cms.object__c.tolowercase()=='task')
					{
						
					}else
					{
						List<sobject> itemstoupdate = new list<sobject>();
						set<Id> ids = records.get(winningcontact);
						string query = 'Select Id, ' + cms.field__c + ' from ' + cms.object__c + 
						' Where ' + cms.field__c + ' IN :ids';
						
						for(sobject s : database.query(query))
						{
							//might have to do putsobject or reference key
							s.putsobject(cms.relationship__c,c);
							itemstoupdate.add(s);
						}
						
						if(itemstoupdate.size()>0) update itemstoupdate;
					}
				}
			}
		}
		*/
	}

}