public class ULeadShare {
	
	public static void communityCheckSharing (List<Lead> records, Map<Id, Lead> oldmap)
	{
		Set<Id> contactIds = new Set<Id>();
		Set<Id> leadIds = new Set<Id>();

		List<LeadShare> leadshares = new List<LeadShare>();
		List<LeadShare> leadsharesDelete = new List<LeadShare>();
		
		GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
		
		Boolean isinsert = (oldmap==null);

		for(Lead l : records)
		{	
			/*Modified by Trekbin for the Case 00024683 on 21 Dec, 2015*/
			if(
				(isinsert && l.EReferred_By__c != null && l.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c)
				||
				(!isinsert && l.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c &&
				(l.EReferred_By__c != oldmap.get(l.Id).EReferred_By__c
				|| l.OwnerId != oldmap.get(l.Id).OwnerId)
				)
			)
			{
				
				if(l.EReferred_By__c != null) contactIds.add(l.EReferred_By__c);
				else if(oldmap.get(l.Id).EReferred_By__c != null) contactIds.add(oldmap.get(l.id).EReferred_By__c);

				leadIds.add(l.Id);
			}
		}
		
		//system.debug('--* run insert-contactids: ' + isinsert + ' : ' + contactIds);

		if(contactIds.isEmpty()) return;

		Map<Id, Id> communityUsers = new Map<Id,Id>();
		Set<Id> userIds = new Set<Id>();

		for(User u : [Select Id, ContactId from User where ContactId IN :contactIds])
		{
			communityUsers.put(u.ContactId,u.Id);
			userIds.add(u.Id);
		}
		
		if(communityUsers.isEmpty()) return;

		Map<String, LeadShare> existingLeadShares = new Map<String, LeadShare>();

		for(LeadShare ls : [Select LeadId, UserOrGroupId
								from LeadShare
								Where LeadId IN :leadids AND UserOrGroupId IN :userIds]) //:contactIds])
		{
			existingLeadShares.put(ls.leadid+'-'+ls.userorgroupid,ls);
		}

		//system.debug('--* existingleadshares-insert: ' + isinsert + ' ' + existingLeadShares);
		
		for(Lead l2 : records)
		{

			if(!communityUsers.containsKey(l2.EReferred_By__c)
				&& (l2.EReferred_By__c==null && !communityUsers.containsKey(oldmap.get(l2.Id).EReferred_By__c))) continue;
			
			/*Modified by Trekbin for the Case 00024683 on 21 Dec, 2015*/
			if(l2.EReferred_By__c != null && l2.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c &&
				(isinsert || 
				(l2.EReferred_By__c != oldmap.get(l2.Id).EReferred_By__c || l2.OwnerId != oldmap.get(l2.Id).OwnerId)
				)
			&& !existingLeadShares.containsKey(l2.Id+'-'+communityUsers.get(l2.EReferred_By__c))
			)
			{
				LeadShare ls = new LeadShare();
				ls.LeadId = l2.Id;
				ls.LeadAccessLevel = 'Read';
				ls.UserOrGroupId = communityUsers.get(l2.EReferred_By__c);
				leadshares.add(ls);
			}
			
			/*Modified by Trekbin for the Case 00024683 on 21 Dec, 2015*/
			if(!isinsert && l2.EReferred_By__c != oldmap.get(l2.Id).EReferred_By__c
				&& oldmap.get(l2.id).EReferred_By__c != null 
				&& existingLeadShares.containsKey(l2.Id+'-'+communityUsers.get(oldmap.get(l2.Id).EReferred_By__c))
				&&  l2.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c
			)
			{
				leadsharesDelete.add(existingLeadShares.get(l2.Id+'-'+communityUsers.get(oldmap.get(l2.Id).EReferred_By__c)));
			}
		}

		//system.debug('--* leadshares: ' + leadshares);
		//system.debug('--* leadsharesDelete: ' + leadsharesDelete);
		
		if(!leadshares.isEmpty()) insert leadshares;
		if(!leadsharesDelete.isEmpty()) delete leadsharesDelete;
	}
}