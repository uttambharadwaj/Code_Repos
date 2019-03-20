public class UContact {

	public static void processDeleteCountContacts (List <Contact> records, Map <id, Contact> oldMap)	
	{
		boolean isInsert = (oldMap == null);
		set <id> accountIds = new set <id>();
		
		for(Contact c : records)
		{
			if(oldMap.get(c.id).accountId != null)
			{
				accountIds.add(c.accountId);
			}
		}	
		
		if(accountIds.size() > 0)
		{
			countContacts(accountIds);
		}
	
	}

	public static void processCountContacts (List <Contact> records, Map <id, Contact> oldMap)	
	{
		
		boolean isInsert = (oldMap == null);
		set <id> accountIds = new set <id>();
		
		for(Contact c : records)
		{
			if(isInsert == true && c.accountId != null)
			{
				accountIds.add(c.accountId);	
			}
			if(isInsert == false && c.accountId != oldMap.get(c.id).accountId)
			{
				if(c.accountId != null)
				{
					accountIds.add(c.accountId);	
				}
				if(oldMap.get(c.id).accountId != null)
				{
					accountIds.add(c.accountId);
				}
			}
		}
		
		if(accountIds.size() > 0)
		{
			countContacts(accountIds);
		}
	}

	public static void countContacts (set <id> accountIds)
	{
		
		List <Account> accountsToUpdate = new List <Account>();
		
		for(Account a : [select id, contact_count__c, 
								(select id from Contacts)
						 from account 
						 where id in :accountIds])
		{
			
			//accessing children size() inside a for loop can cause error on 
			//large children data set.  Converting to looping through counter -Phillip -072214
			
			/*
			if(a.contact_count__c != a.contacts.size())
			{
				a.contact_count__c = a.contacts.size();
				accountsToUpdate.add(a);
			}
			*/	
			Integer count = 0;
			for(Contact c : a.contacts)
			{
				count++;
			}

			if(a.Contact_Count__c != count)
			{
				a.Contact_Count__c = count;
				accountsToUpdate.add(a);
			}
		}
		
		if(accountsToUpdate.size() > 0)
		{
			update accountsToUpdate;
		}
	}
	
	public static void mergei2iDuplicates(List<Contact> records, map<id, Contact> oldmap)
	{
		GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
		//boolean isinsert = (oldmap==null);
		
		Set<string> i2iIds = new Set<string>();
		//Set<string> emails = new Set<string>();

		for(Contact scope : records)
		{
			if(
			(scope.i2i_ID__c !=null && scope.i2i_ID__c != oldmap.get(scope.id).i2i_id__c)
			//||
			//(scope.email!=null && scope.email!='none@none.com' && scope.email != oldmap.get(scope.id).email)		
			)
			{
				if(scope.i2i_ID__c!=null) i2iIds.add(scope.i2i_id__c);
				//if(scope.email !=null && scope.email != 'none@none.com') emails.add(scope.email);
			}
		}
		
		if(i2iIds.isempty()) return; // && emails.isempty()) return;
		
		system.debug('-- i2iIds: ' + i2iIds);
		//system.debug('-- emails: ' + emails);
		
		
		Map<String,Map<Id,Contact>> contactsByi2iIds = new Map<String,Map<Id,Contact>>();
		Set<String> i2iIdsWithDups = new Set<String>();
		Map<String,Contact> i2iIdWinningContact = new Map<String,Contact>();
		
		/*
		Map<String,Map<Id,Contact>> contactsbyEmail = new Map<String,Map<Id,Contact>>();
		Set<String> emailsWithDups = new Set<String>();
		Map<String,Contact> emailWinningContact = new Map<String,Contact>();
		*/
		
		
		set <string> contactFields = new set <string>();
		string contactFieldString = 'id, i2i_id__c, email, createddate ';
		
		//custom setting that defines the fields to merge when source is not null and destination is null
		for(Merge_Record_Mapping__c m : Merge_Record_Mapping__c.getAll().values())
		{
			if(m.Object_Name__c.toLowerCase() == 'contact')
			{
				contactFields.add(m.API_Field_Name__c);
				contactFieldString += ', ' + m.API_Field_Name__c;
			}
		}

		string contactQuery = 'select ' + contactFieldString;
		contactQuery += ' from contact where i2i_id__c in :i2iIds'; // OR email in :emails';

		Set<Id> excludedContactRecordTypeIds = UMergeRecords.getExcludedRecordTypes('Contact');
		if (!excludedContactRecordTypeIds.isEmpty()) {
			contactQuery += ' AND RecordTypeId NOT IN :excludedContactRecordTypeIds';
		}
		
		for(contact ct : database.query(contactquery))
		{
			if(contactsbyi2iIds.containskey(ct.i2i_id__c))
			{
				Map<Id,Contact> contacts = contactsbyi2iids.get(ct.i2i_id__c);
				contacts.put(ct.id,ct);
				contactsbyi2iids.put(ct.i2i_id__c,contacts);
				
				i2iIdsWithDups.add(ct.i2i_id__c);

			}else if(ct.i2i_id__c !=null)
			{
				Map<Id, contact> contacts = new Map<Id,contact>();
				contacts.put(ct.id, ct);
				contactsbyi2iids.put(ct.i2i_id__c,contacts);
			}
			
			if(ct.i2i_id__c !=null && (!(i2iIdWinningContact.containskey(ct.i2i_id__c)) || (i2iIdWinningContact.get(ct.i2i_id__c).createddate < ct.createddate)))
			{
				i2iIdWinningContact.put(ct.i2i_id__c,ct);
			}
			
			
			/*
			if(contactsbyemail.containskey(ct.email))
			{
				Map<Id,Contact> contacts = contactsbyemail.get(ct.email);
				contacts.put(ct.id,ct);
				contactsbyemail.put(ct.email,contacts);
				
				emailswithdups.add(ct.email);

			}else if(ct.email !=null)
			{
				Map<Id, contact> contacts = new Map<Id,contact>();
				contacts.put(ct.id, ct);
				contactsbyemail.put(ct.email,contacts);
			}
			
			if(ct.email !=null && (!(emailWinningContact.containskey(ct.email)) || (emailWinningContact.get(ct.email).createddate < ct.createddate)))
			{
				emailWinningContact.put(ct.email,ct);
			}
			*/
		}
		
		if((contactsbyi2iids.isempty() || i2iIdswithdups.isempty())) return; // && (contactsbyemail.isempty() || emailswithdups.isempty())) return;

		Map<Id,contact> contactstoupdate = new Map<Id,Contact>();
		Map<Id,contact> contactstodelete = new Map<Id,Contact>();
		
		Map<Id,Set<Id>> contactCompilation = new Map<Id,Set<Id>>();
		
		for(String i2i : i2iIdswithdups)
		{
			if(contactsByi2iIds.containskey(i2i) && i2iIdWinningContact.containskey(i2i))
			{
				Contact winningContact = i2iIdWinningContact.get(i2i);
				Boolean hasupdate = false;
				
				set<Id> losingContacts = new Set<Id>();
				
				for(Contact c : contactsbyi2iIds.get(i2i).values())
				{
					if(c.id!=winningcontact.id)
					{

						for(String fieldname : contactfields)
						{
							if(winningcontact.get(fieldname) == null && c.get(fieldname)!= null)
							{
								winningcontact.put(fieldname,c.get(fieldname));
								hasupdate = true;
							}
						}

						contactstodelete.put(c.id,c);
						DeletedRecordsStageClass.deletedRecordsReasons.put(c.Id,'Contact Duplicate i2i Id');
						
						losingcontacts.add(c.Id);
					}
				}
				
				if(hasupdate) contactstoupdate.put(winningcontact.id,winningcontact);

				if(losingcontacts.size()>0) contactCompilation.put(winningContact.Id,losingContacts);
			}
		}
		/*
		for(string em : emailswithdups)
		{
			if(contactsbyemail.containskey(em) && emailwinningcontact.containskey(em))
			{
				Contact winningContact = (contactstoupdate.containskey(emailwinningcontact.get(em).Id)) ? contactstoupdate.get(emailwinningcontact.get(em).Id) : emailwinningcontact.get(em);
				if(contactstodelete.containskey(winningcontact.id)) continue;
				boolean hasupdate = false;
				
				set<Id> losingcontacts = new set<Id>();
				
				for(contact c : contactsbyemail.get(em).values())
				{
					if(c.Id!=winningcontact.id && !(contactstodelete.containskey(c.id)))
					{
						for(string fieldname : contactfields)
						{
							if(winningcontact.get(fieldname) == null && c.get(fieldname)!=null)
							{
								winningcontact.put(fieldname,c.get(fieldname));
								hasupdate=true;
							}
						}
						
						contactstodelete.put(c.id,c);
						
						losingcontacts.add(c.Id);
					}
				}
				
				if(hasupdate)contactstoupdate.put(winningcontact.id,winningcontact);
				
				if(losingcontacts.size()>0)
				{
					set<Id> idstoput = new Set<id>();
					if(contactCompilation.containskey(winningContact.Id)) idstoput = contactCompilation.get(winningContact.Id);
					idstoput.addall(losingcontacts);
					contactcompilation.put(winningcontact.id,idstoput);
				}
			}
		}
		*/
		
		if(contactstoupdate.size()>0) update contactstoupdate.values();
		
		Usobject.mergeContactRelatedItems(contactCompilation);
		
		if(contactstodelete.size()>0) delete contactstodelete.values();
	}
}