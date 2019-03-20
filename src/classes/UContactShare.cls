public class UContactShare {
	
	public static void communityCheckSharing (List<Contact> records, Map<Id, Contact> oldmap)
	{
		Set<Id> contactIds = new Set<Id>();
		Set<Id> referredContactIds = new Set<Id>();

		List<ContactShare> contactShares = new List<ContactShare>();
		List<ContactShare> contactSharesDelete = new List<ContactShare>();

		Boolean isinsert = (oldmap==null);

		

		for(Contact c : records)
		{
			if(isinsert && c.Referred_by_External__c != null
			||
			(!isinsert && 
				(c.Referred_by_External__c != oldmap.get(c.Id).Referred_by_External__c || c.OwnerId != oldmap.get(c.Id).OwnerId))
			)
			{
				
				if(c.Referred_by_External__c != null) referredContactIds.add(c.Referred_by_External__c);
				else if(oldmap.get(c.Id).Referred_by_External__c != null) referredContactIds.add(oldmap.get(c.id).Referred_by_External__c);

				contactIds.add(c.Id);
			}
		}

		//system.debug('-- run insert: ' + isinsert + ' : ' + contactIds);

		if(referredContactIds.isEmpty()) return;

		Map<Id, Id> communityUsers = new Map<Id,Id>();
		Set<Id> userIds = new Set<Id>();

		for(User u : [Select Id, ContactId from User where ContactId IN :referredContactIds])
		{
			communityUsers.put(u.ContactId,u.Id);
			userIds.add(u.Id);
		}

		if(communityUsers.isEmpty()) return;

		Map<String, ContactShare> existingContactShares = new Map<String, ContactShare>();

		for(ContactShare cs : [Select ContactId, UserOrGroupId
								from ContactShare
								Where ContactId IN :contactIds AND UserOrGroupId IN :userIds]) //:contactIds])
		{
			existingContactShares.put(cs.contactid+'-'+cs.userorgroupid,cs);
		}

		//system.debug('-- existingleadshares insert: ' + isinsert + ' ' + existingContactShares);

		for(Contact c2 : records)
		{

			if(!communityUsers.containsKey(c2.Referred_by_External__c)
				&& (c2.Referred_by_External__c==null && !communityUsers.containsKey(oldmap.get(c2.Id).Referred_by_External__c))) continue;

			if(c2.Referred_by_External__c != null
			&&
			(isinsert || 
				(c2.Referred_by_External__c != oldmap.get(c2.Id).Referred_by_External__c 
					|| c2.OwnerId != oldmap.get(c2.Id).OwnerId)
				)
			&& !existingContactShares.containsKey(c2.Id+'-'+communityUsers.get(c2.Referred_by_External__c))
			)
			{
				ContactShare cs = new ContactShare();
				cs.ContactId = c2.Id;
				cs.ContactAccessLevel = 'Read';
				cs.UserOrGroupId = communityUsers.get(c2.Referred_by_External__c);
				contactShares.add(cs);
			}

			if(!isinsert && c2.Referred_by_External__c != oldmap.get(c2.Id).Referred_by_External__c
				&& oldmap.get(c2.id).Referred_by_External__c != null 
				&& existingContactShares.containsKey(c2.Id+'-'+communityUsers.get(oldmap.get(c2.Id).Referred_by_External__c))
			)
			{
				contactSharesDelete.add(existingContactShares.get(c2.Id+'-'+communityUsers.get(oldmap.get(c2.Id).Referred_by_External__c)));
			}
		}

		//system.debug('-- contactShares: ' + contactShares);
		//system.debug('-- contactSharesDelete: ' + contactSharesDelete);

		if(!contactShares.isEmpty()) insert contactShares;
		if(!contactSharesDelete.isEmpty()) delete contactSharesDelete;

	}
}