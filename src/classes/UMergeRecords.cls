public class UMergeRecords {

	public static void processMerge (List <Merge_Records_Staging__c> records)
	{
		set <string> i2iIds = new set <string>();
		Map <string, string> changeMap = new Map <string, string>();
		
		List <Merge_Records_Staging__c> mergesToUpdate = new List <Merge_Records_Staging__c>();
		
		for(Merge_Records_Staging__c m : records)
		{
			if(m.Most_Recent_i2i_ID__c != null)
			{
				i2iIds.add(m.Most_Recent_i2i_ID__c);
			}	
			if(m.Original_i2i_ID__c != null)
			{
				i2iIds.add(m.Original_i2i_ID__c);
			}	
			if(m.Most_Recent_i2i_ID__c != null && m.Original_i2i_ID__c != null)
			{
				changeMap.put(m.Original_i2i_ID__c, m.Most_Recent_i2i_ID__c);
				
				Merge_Records_Staging__c newM = new Merge_Records_Staging__c(id = m.id);
				newM.Date_Processed__c = system.now();
				mergesToUpdate.add(newM);
			}
		}
		
		if(changeMap.size() == 0)
		{
			return;
		}
		
		set <string> leadFields = new set <string>();
		set <string> contactFields = new set <string>();
		string leadFieldString = 'id, i2i_id__c';
		string contactFieldString = 'id, i2i_id__c';
		
		//custom setting that defines the fields to merge when source is not null and destination is null
		for(Merge_Record_Mapping__c m : Merge_Record_Mapping__c.getAll().values())
		{
			if(m.Object_Name__c.toLowerCase() == 'contact')
			{
				contactFields.add(m.API_Field_Name__c);
				contactFieldString += ', ' + m.API_Field_Name__c;
			}
			if(m.Object_Name__c.toLowerCase() == 'lead')
			{
				leadFields.add(m.API_Field_Name__c);
				leadFieldString += ', ' + m.API_Field_Name__c;
			}
		}
		
		///////////
		// LEADS
		//////////
		
		Map <string, Lead> parentLeadMap = new Map <string, Lead>();
		
		string leadQuery = 'select ' + leadFieldString + ', (Select Id, i2i_id__c From Child_Leads__r where isConverted = false) ';
		leadQuery += 'from lead where i2i_id__c in :i2iIds and isConverted = false and parent_lead__c = null';

		Set<Id> excludedLeadRecordTypeIds = UMergeRecords.getExcludedRecordTypes('Lead');
		if (!excludedLeadRecordTypeIds.isEmpty()) {
			leadQuery += ' AND RecordTypeId NOT IN :excludedLeadRecordTypeIds';
		}

		system.debug('-----lead Query ' + leadQuery);
		
		// find all the parent leads (parent_lead__c is null) for the i2i ids
		for(Lead l : database.query(leadQuery))
		{
			parentLeadMap.put(l.i2i_id__c, l);
		}
		
		List <Lead> leadsToUpdate = new List <Lead>();
		List <Lead> leadsToDelete = new List <Lead>();
		
		for(Merge_Records_Staging__c m : records)
		{
			system.debug('-----Merge ' + m.Original_i2i_ID__c + ' to ' + m.Most_Recent_i2i_ID__c);
			
			// nmove the child
			// reset the i2i id
			// delete the parent
			if(parentLeadMap.containsKey(m.Most_Recent_i2i_ID__c) && parentLeadMap.containsKey(m.Original_i2i_ID__c))	
			{
				Lead parentLead = parentLeadMap.get(m.Original_i2i_ID__c);
				// move the original child leads to the new parent
				id newParentId = parentLeadMap.get(m.Most_Recent_i2i_ID__c).id;
				for(Lead childLead : parentLead.Child_Leads__r)
				{
					childLead.Parent_Lead__c = newParentId;
					childLead.i2i_ID__c = m.Most_Recent_i2i_ID__c;
					leadsToUpdate.add(childLead);	
				}	
				
				Lead originalLead = parentLeadMap.get(m.Original_i2i_ID__c);
				Lead mostRecentLead = parentLeadMap.get(m.Most_Recent_i2i_ID__c);
				boolean hasUpdates = false;
				
				//copy fields
				for(string fieldName : leadFields)
				{
					if(mostRecentLead.get(fieldName) == null && originalLead.get(fieldName) != null)
					{
						mostRecentLead.put(fieldName, originalLead.get(fieldName));	
						hasUpdates = true;
					}
				}	
				
				if(hasUpdates == true)
				{
					leadsToUpdate.add(mostRecentLead);
				}
				
				leadsToDelete.add(parentLeadMap.get(m.Original_i2i_ID__c));
				DeletedRecordsStageClass.deletedRecordsReasons.put(parentLeadMap.get(m.Original_i2i_ID__c).Id,'Merge Records Staging');

			}
		}
		
		if(leadsToUpdate.size() > 0)
		{
			update leadsToUpdate;
		}
		
		if(leadsToDelete.size() > 0)
		{
			delete leadsToDelete;
		}
		
		List <Lead> changeIdLeads = new List <Lead>();
		// perform the logic to change ids
		// if anything is left
		for(Lead l : [select id, i2i_id__c from lead where i2i_id__c in :i2iIds and isConverted = false])
		{
			if(changeMap.containsKey(l.i2i_id__c))
			{
				l.i2i_id__c = changeMap.get(l.i2i_id__c);
				changeIdLeads.add(l);
			}
		}
		
		if(changeIdLeads.size() > 0)
		{
			update changeIdLeads;
		}
		
		///////////
		// CONTACTS
		//////////
		
		Map <string, Contact> contactMap = new Map <string, Contact>();
		
		string contactQuery = 'select ' + contactFieldString ;
		contactQuery += ' from contact where i2i_id__c in :i2iIds';

		Set<Id> excludedContactRecordTypeIds = UMergeRecords.getExcludedRecordTypes('Contact');
		if (!excludedContactRecordTypeIds.isEmpty()) {
			contactQuery += ' AND RecordTypeId NOT IN :excludedContactRecordTypeIds';
		}
		
		system.debug('-----contact Query ' + contactQuery);
		
		// find all the contacts
		for(contact c : database.query(contactQuery))
		{
			contactMap.put(c.i2i_id__c, c);
		}
		
		List <Contact> contactsToUpdate = new List <Contact>();
		List <Contact> contactsToDelete = new List <Contact>();
		Map<Id,Set<Id>> contactCompilation = new Map<Id,Set<Id>>();
		
		for(Merge_Records_Staging__c m : records)
		{
			system.debug('-----Merge ' + m.Original_i2i_ID__c + ' to ' + m.Most_Recent_i2i_ID__c);
			
			// nmove the child
			// reset the i2i id
			// delete the parent
			if(contactMap.containsKey(m.Most_Recent_i2i_ID__c) && contactMap.containsKey(m.Original_i2i_ID__c))	
			{
				
				contact originalcontact = contactMap.get(m.Original_i2i_ID__c);
				contact mostRecentContact = contactMap.get(m.Most_Recent_i2i_ID__c);
				boolean hasUpdates = false;
				
				system.debug('-----A = ' + originalContact);
				system.debug('-----B = ' + mostRecentContact);
				
				//copy fields
				for(string fieldName : contactFields)
				{
					if(mostRecentContact.get(fieldName) == null && originalContact.get(fieldName) != null)
					{
						mostRecentContact.put(fieldName, originalContact.get(fieldName));	
						hasUpdates = true;
					}
				}	
				
				if(hasUpdates == true)
				{
					contactsToUpdate.add(mostRecentContact);
				}
				
				contactcompilation.put(mostrecentcontact.Id,new set<Id>{originalcontact.Id});
				
				system.debug('-----Adding to contactsToDelete');
				
				contactsToDelete.add(contactMap.get(m.Original_i2i_ID__c));
				DeletedRecordsStageClass.deletedRecordsReasons.put(contactMap.get(m.Original_i2i_ID__c).Id,'Merge Records Staging');

				system.debug('-----' + contactMap.get(m.Original_i2i_ID__c));
				system.debug('-----' + contactsToDelete.size());
			}
		}
		
		if(contactsToUpdate.size() > 0)
		{
			update contactsToUpdate;
		}
		
		if(contactcompilation.size() > 0)
		{
			usobject.mergeContactRelatedItems(contactcompilation);
		}
		if(contactsToDelete.size() > 0)
		{
			delete contactsToDelete;
		}
		
		
		/// change Ids
		
		List <Contact> changeIdContacts = new List <Contact>();
		// perform the logic to change ids
		// if anything is left
		for(Contact c : [select id, i2i_id__c from Contact where i2i_id__c in :i2iIds])
		{
			if(changeMap.containsKey(c.i2i_id__c))
			{
				c.i2i_id__c = changeMap.get(c.i2i_id__c);
				changeIdContacts.add(c);
			}
		}
		
		if(changeIdContacts.size() > 0)
		{
			update changeIdContacts;
		}
		
		//////////
		
		if(mergesToUpdate.size() > 0)
		{
			update mergesToUpdate;
		}
		
	}

	public static Set<Id> getExcludedRecordTypes(String objName) {
		Set<Id> excludedRecordTypeIds = new Set<Id>();
		Map<String, Set<String>> excludedRecordTypeNames = new Map<String, Set<String>>();
		for (Merge_Ignore__mdt cmdt : [SELECT MasterLabel, Record_Type_Name__c FROM Merge_Ignore__mdt]) {
			if (cmdt.Record_Type_Name__c!=null) {
				excludedRecordTypeNames.put(cmdt.MasterLabel.toLowerCase(), new Set<String>(cmdt.Record_Type_Name__c.split(',')));
			}
		}

		if (String.isNotEmpty(objName)) {
			objName = objName.toLowerCase();
			if (excludedRecordTypeNames.get(objName)!=null) {
				for (RecordType rectype : [SELECT Id FROM RecordType WHERE SobjectType = :objName AND DeveloperName IN : excludedRecordTypeNames.get(objName)]) {
					excludedRecordTypeIds.add(rectype.Id);
				}
			}
		}

		return excludedRecordTypeIds;
	}
}