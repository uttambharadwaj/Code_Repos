public class DeletedRecordsStageClass {

	public static Map<Id,String> deletedRecordsReasons = new Map<Id,String>();

    public static void preDeleteAccount (List <Account> records)
	{
		GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
		
		List <Deleted_Records_Stage__c> recordsToInsert = new List <Deleted_Records_Stage__c>();
		
		for(Account a: [select id,
							   (select id from Contacts),
							   (select id from Opportunities)
						from account 
						where id in :records])
		{
			
			for(Contact c : a.contacts)
			{
				Deleted_Records_Stage__c d = new Deleted_Records_Stage__c();
				d.Record_ID__c = c.id;
				d.Date_Deleted__c = system.now();
				d.Record_Type__c = 'Contact';
				d.Delete_Initiated_By__c = 'User';
				d.Delete_Source__c = (deletedRecordsReasons.containskey(a.Id)) ? deletedRecordsReasons.get(a.Id) : 'Manual';
			
				if(userInfo.getUserId() == gs.Integration_User_ID__c)
				{
					d.Delete_Initiated_By__c = 'i2i';	
				}
			
				recordsToInsert.add(d);
			}
			
			for(Opportunity o : a.opportunities)
			{
				Deleted_Records_Stage__c d = new Deleted_Records_Stage__c();
				d.Record_ID__c = o.id;
				d.Date_Deleted__c = system.now();
				d.Record_Type__c = 'Opportunity';
				d.Delete_Initiated_By__c = 'User';
				d.Delete_Source__c = (deletedRecordsReasons.containskey(a.Id)) ? deletedRecordsReasons.get(a.Id) : 'Manual';
			
				if(userInfo.getUserId() == gs.Integration_User_ID__c)
				{
					d.Delete_Initiated_By__c = 'i2i';	
				}
			
				recordsToInsert.add(d);
			}
			
		}
		
		if(recordsToInsert.size() > 0)
		{
			insert recordsToInsert;
		}
	
	}


	public static void processDelete (List <sObject> records)
	{
		GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
		
		List <Deleted_Records_Stage__c> recordsToInsert = new List <Deleted_Records_Stage__c>();
		
		for(sObject s : records)
		{
			Deleted_Records_Stage__c d = new Deleted_Records_Stage__c();
			d.Record_ID__c = s.id;
			d.Date_Deleted__c = system.now();
			d.Record_Type__c = string.valueOf(s.getSObjectType());
			d.Delete_Initiated_By__c = 'User';
			d.Delete_Source__c = (deletedRecordsReasons.containskey(s.Id)) ? deletedRecordsReasons.get(s.Id) : 'Manual';
			
			if(userInfo.getUserId() == gs.Integration_User_ID__c)
			{
				d.Delete_Initiated_By__c = 'i2i';	
			}
			
			recordsToInsert.add(d);
			
		}
		
		if(recordsToInsert.size() > 0)
		{
			insert recordsToInsert;
		}
		
	}

}