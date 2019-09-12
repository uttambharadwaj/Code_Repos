public class UApplicationRequest {


	// this was moved to a process builder

	/*
	public static void communityUserStampData(List<Application_Request__c> records)
	{	//currently only for before insert trigger
		
		//String userId = UserInfo.getUserId();
        //List<User> userRecord = [Select id, UserType, AccountId, ContactId, Profile.UserLicense.Name from User where id=:userId LIMIT 1];
        
        //system.debug('current user: ' + userRecord);
        //system.debug('userlicense name: ' + userRecord[0].Profile.UserLicense.Name);
        //system.debug('boolean user check: ' + UGears.UUser.ispartnerportaluser(userRecord[0]));

        //if (userRecord.size() == 0 || userRecord == null || !UGears.UUser.ispartnerportaluser(userRecord[0])) return;
        //if (userRecord.size() == 0 || userRecord == null || !UGears.UUser.isPartnerCommunityUser(userRecord[0])) return;

		Set<Id> scopeoppIds = new Set<Id>();
		for(Application_Request__c a : records)
		{
			if(a.Opportunity__c != null) scopeoppIds.add(a.Opportunity__c);
		}

		if(scopeoppIds.isEmpty()) return;

		Map<Id, Opportunity> opps = new Map<Id, Opportunity>([Select Id, External_Referred_By_Account_Name__c, External_Referred_By__c
								from Opportunity Where Id IN :scopeoppIds]);

		if(opps.isEmpty()) return;

		for(Application_Request__c ar : records)
		{
			if(!opps.containsKey(ar.Opportunity__c)) continue;

			Opportunity o = opps.get(ar.Opportunity__c);
			ar.External_Referred_by__c = o.External_Referred_By_Account_Name__c;
			ar.External_Referring_Contact__c = o.External_Referred_By__c;

		}

	}

 */
}