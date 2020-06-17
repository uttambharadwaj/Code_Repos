/**
 * Created by jharrell on 6/12/20.
 */

public class CommunicationPreferencesInvocable {

	// Communication Preference fields
	public static final List<String> PREF_FIELDS_GENERIC_EMAIL = new List<String>{'Email_Opt_In_Contact__c','Email_Opt_In__c','HasOptedOutOfEmail'};
	public static final List<String> PREF_FIELDS_GENERIC_PHONE = new List<String>{'DoNotCall','Outbound_Call_Opt_In__c'};
	public static final List<String> PREF_FIELDS_MOBILE_PHONE = new List<String>{'et4ae5__HasOptedOutOfMobile__c','HasOptedInOfMobile__c'};
	public static final List<String> PREF_FIELDS_SNAIL_MAIL = new List<String>{'Mail_Opt_Out__c','Direct_Mail_Opt_In__c'};

	// Picklist values for when preference is updated
	public static final String PREF_GENERIC_EMAIL = 'Generic-Email';
	public static final String PREF_GENERIC_PHONE = 'Generic-Phone';
	public static final String PREF_MOBILE_PHONE = 'Mobile-Phone';
	public static final String PREF_SNAIL_MAIL = 'Snail-Mail';

	@InvocableMethod(
			label = 'Communication Preferences Updated Handler'
			description = 'Syncs communication preferences between records with matching contact information'
	)
	public static void preferencesUpdatedHandler(List<CommunicationPreferencesInput> inputs) {

		// Enable Bulk Data Load

		Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
		bulkDataLoadSettings.Disable_Lead_Automation__c = true;
		bulkDataLoadSettings.Disable_Contact_Automation__c = true;
		upsert bulkDataLoadSettings;

		List<Id> partnerIds = new List<Id>();
		List<String> emails = new List<String>();
		List<String> phoneNumbers = new List<String>();
		List<String> mobilePhoneNumbers = new List<String>();
		List<String> mailingStreets = new List<String>();

		Map<String, CommunicationPreferencesInput> preferences = new Map<String, CommunicationPreferencesInput>();
		List<Contact> contactsToUpdate = new List<Contact>();
		List<Lead> leadsToUpdate = new List<Lead>();

		for (CommunicationPreferencesInput input : inputs) {

			// ALL - used for selective query
			if (input.partnerId != null) partnerIds.add(input.partnerId);
			if (input.genericEmail != null) emails.add(input.genericEmail);
			if (input.genericPhone != null) phoneNumbers.add(input.genericPhone);
			if (input.mobilePhone != null) mobilePhoneNumbers.add(input.mobilePhone);
			if (input.mailingStreet != null) mailingStreets.add(input.mailingStreet);

			// Determine which opt status changed. If mobile phone opt changes it is not desire to have email statuses update as well.
			if (input.updatedPreferences.containsIgnoreCase(PREF_GENERIC_EMAIL)) {
				String key = getKey(input.partnerId,input.genericEmail);
				if (key != null && preferences.get(key) == null) preferences.put(key, input);
			}
			if (input.updatedPreferences.containsIgnoreCase(PREF_GENERIC_PHONE)) {
				String key = getKey(input.partnerId,input.genericPhone);
				if (key != null && preferences.get(key) == null) preferences.put(key, input);
			}
			if (input.updatedPreferences.containsIgnoreCase(PREF_MOBILE_PHONE)) {
				String key = getKey(input.partnerId,input.mobilePhone);
				if (key != null && preferences.get(key) == null) preferences.put(key, input);
			}
			if (input.updatedPreferences.containsIgnoreCase(PREF_SNAIL_MAIL)) {
				String key = getKey(input.partnerId,input.mailingStreet + input.mailingPostal);
				if (key != null && preferences.get(key) == null) preferences.put(key, input);
			}

		}

		if (preferences.isEmpty()) return;	// missing all contact info

		// ####################### Update Contacts
		for (Contact contact :  [
				SELECT id,opt_status_updated__c,phone,email,PartnerID__c,Email_Opt_In_Contact__c,HasOptedOutOfEmail,MailingPostalCode,MailingStreet,MobilePhone,DoNotCall,Outbound_Call_Opt_In__c,HasOptedInOfMobile__c,et4ae5__HasOptedOutOfMobile__c,Mail_Opt_Out__c,Direct_Mail_Opt_In__c
				FROM Contact
				WHERE PartnerID__c IN :partnerIds
				AND (Email IN :emails
					OR Phone IN :phoneNumbers
					OR MobilePhone IN :mobilePhoneNumbers
				 	OR MailingStreet IN :mailingStreets)
		]) {
			Boolean updateContact = false;
			String emailKey = getKey(contact.PartnerID__c, contact.email);
			String genericPhoneKey = getKey(contact.PartnerID__c, contact.phone);
			String mobilePhoneKey = getKey(contact.PartnerID__c, contact.MobilePhone);
			String snailMailKey = getKey(contact.PartnerID__c, contact.MailingStreet + contact.MailingPostalCode);

			// ##### Generic Email
			if (emailKey != null && preferences.get(emailKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(emailKey);
				contact.Email_Opt_In_Contact__c = pref.genericEmailOptIn;
				contact.HasOptedOutOfEmail = pref.genericEmailOptOut;
				contact.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(contact.Opt_Status_Updated__c,PREF_GENERIC_EMAIL, true);
				updateContact = true;
			}

			// #### Generic Phone
			if (genericPhoneKey != null && preferences.get(genericPhoneKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(genericPhoneKey);
				contact.DoNotCall = pref.genericEmailOptOut;
				contact.Outbound_Call_Opt_In__c = pref.genericEmailOptIn;
				contact.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(contact.Opt_Status_Updated__c,PREF_GENERIC_PHONE, true);
				updateContact = true;
			}

			// #### Mobile Phone
			if (mobilePhoneKey != null && preferences.get(mobilePhoneKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(mobilePhoneKey);
				contact.HasOptedInOfMobile__c = pref.mobilePhoneOptIn;
				contact.et4ae5__HasOptedOutOfMobile__c = pref.mobilePhoneOptOut;
				contact.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(contact.Opt_Status_Updated__c,PREF_MOBILE_PHONE, true);
				updateContact = true;
			}

			// #### Snail Mail
			if (snailMailKey != null && preferences.get(snailMailKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(snailMailKey);
				contact.Direct_Mail_Opt_In__c = pref.snailMailOptIn;
				contact.Mail_Opt_Out__c = pref.snailMailOptOut;
				contact.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(contact.Opt_Status_Updated__c,PREF_SNAIL_MAIL, true);
				updateContact = true;
			}

			// If updated add to list
			if (updateContact) {
				contactsToUpdate.add(contact);
			}
		}
		if (!contactsToUpdate.isEmpty()) Database.update(contactsToUpdate, false);


		// TODO Combine these two using sobject...
		// ####################### Update Leads
		for (Lead lead :  [
				SELECT id,opt_status_updated__c,phone,email,PartnerID__c,Email_Opt_In__c,HasOptedOutOfEmail,Shipping_Zip_Code__c,Shipping_Street__c,MobilePhone,DoNotCall,Outbound_Call_Opt_In__c,HasOptedInOfMobile__c,et4ae5__HasOptedOutOfMobile__c,Mail_Opt_Out__c,Direct_Mail_Opt_In__c
				FROM Lead
				WHERE PartnerID__c IN :partnerIds
				AND (Email IN :emails
				OR Phone IN :phoneNumbers
				OR MobilePhone IN :mobilePhoneNumbers
				OR Shipping_Street__c IN :mailingStreets)
		]) {
			Boolean updateLead = false;
			String emailKey = getKey(lead.PartnerID__c, lead.email);
			String genericPhoneKey = getKey(lead.PartnerID__c, lead.phone);
			String mobilePhoneKey = getKey(lead.PartnerID__c, lead.MobilePhone);
			String snailMailKey = getKey(lead.PartnerID__c, lead.Shipping_Street__c + lead.Shipping_Zip_Code__c);

			// ##### Generic Email
			if (emailKey != null && preferences.get(emailKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(emailKey);
				lead.Email_Opt_In__c = pref.genericEmailOptIn;
				lead.HasOptedOutOfEmail = pref.genericEmailOptOut;
				lead.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(lead.Opt_Status_Updated__c,PREF_GENERIC_EMAIL, true);
				updateLead = true;
			}

			// #### Generic Phone
			if (genericPhoneKey != null && preferences.get(genericPhoneKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(genericPhoneKey);
				lead.DoNotCall = pref.genericEmailOptOut;
				lead.Outbound_Call_Opt_In__c = pref.genericEmailOptIn;
				lead.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(lead.Opt_Status_Updated__c,PREF_GENERIC_PHONE, true);
				updateLead = true;
			}

			// #### Mobile Phone
			if (mobilePhoneKey != null && preferences.get(mobilePhoneKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(mobilePhoneKey);
				lead.HasOptedInOfMobile__c = pref.mobilePhoneOptIn;
				lead.et4ae5__HasOptedOutOfMobile__c = pref.mobilePhoneOptOut;
				lead.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(lead.Opt_Status_Updated__c,PREF_MOBILE_PHONE, true);
				updateLead = true;
			}

			// #### Snail Mail
			if (snailMailKey != null && preferences.get(snailMailKey) != null) {
				CommunicationPreferencesInput pref = preferences.get(snailMailKey);
				lead.Direct_Mail_Opt_In__c = pref.snailMailOptIn;
				lead.Mail_Opt_Out__c = pref.snailMailOptOut;
				lead.Opt_Status_Updated__c = UtilityClass.updateMultiPicklist(lead.Opt_Status_Updated__c,PREF_SNAIL_MAIL, true);
				updateLead = true;
			}


			// If updated add to list
			if (updateLead) {
				leadsToUpdate.add(lead);
			}
		}
		if (!leadsToUpdate.isEmpty()) Database.update(leadsToUpdate, false);

		// Disable bulk data load
		bulkDataLoadSettings.Disable_Lead_Automation__c = false;
		bulkDataLoadSettings.Disable_Contact_Automation__c = false;
		update bulkDataLoadSettings;
	}

	public class CommunicationPreferencesInput {

		// why are there so many opt fields.......

		@InvocableVariable(label = 'Generic Email')
		public String genericEmail;

		@InvocableVariable(label = 'Generic Phone')
		public String genericPhone;

		@InvocableVariable(label = 'Mobile Phone')
		public String mobilePhone;

		@InvocableVariable(label = 'Mailing Street')
		public String mailingStreet;

		@InvocableVariable(label = 'Mailing Postal')
		public String mailingPostal;

		@InvocableVariable(label = 'partnerId')
		public Id partnerId;

		@InvocableVariable(label = 'updatedPreferences')
		public String updatedPreferences;

		// ====================================================

		@InvocableVariable(label = 'Generic Email Opt In')
		public Boolean genericEmailOptIn;
		@InvocableVariable(label = 'Generic Email Opt Out')
		public Boolean genericEmailOptOut;


		@InvocableVariable(label = 'Generic Phone Opt In')
		public Boolean genericPhoneOptIn;
		@InvocableVariable(label = 'Generic Phone Opt Out')
		public Boolean genericPhoneOptOut;


		@InvocableVariable(label = 'Mobile Phone Opt In')
		public Boolean mobilePhoneOptIn;
		@InvocableVariable(label = 'Mobile Phone Opt out')
		public Boolean mobilePhoneOptOut;

		@InvocableVariable(label = 'Snail Mail Opt In')
		public Boolean snailMailOptIn;
		@InvocableVariable(label = 'Snail Mail Opt Out')
		public Boolean snailMailOptOut;


	}


	// Called before insert on Lead/Contact
	public static void communicationRecordUpdated(List<SObject> communicationRecords, Map<Id, SObject> oldMap) {

		for (SObject communicationRecord : communicationRecords) {

			String optStatuses = (String) communicationRecord.get('Opt_Status_Updated__c');
			SObject oldRecord = oldMap.get((Id) communicationRecord.get('id'));

			if (UtilityClass.isChanged(communicationRecord, oldRecord,PREF_FIELDS_GENERIC_EMAIL)) {
				optStatuses = UtilityClass.updateMultiPicklist(optStatuses, PREF_GENERIC_EMAIL, false);
			}

			if (UtilityClass.isChanged(communicationRecord, oldRecord,PREF_FIELDS_MOBILE_PHONE)) {
				optStatuses = UtilityClass.updateMultiPicklist(optStatuses, PREF_MOBILE_PHONE, false);
			}

			if(UtilityClass.isChanged(communicationRecord, oldRecord,PREF_FIELDS_GENERIC_PHONE)) {
				optStatuses = UtilityClass.updateMultiPicklist(optStatuses, PREF_GENERIC_PHONE, false);
			}

			if(UtilityClass.isChanged(communicationRecord, oldRecord,PREF_FIELDS_SNAIL_MAIL)) {
				optStatuses = UtilityClass.updateMultiPicklist(optStatuses, PREF_SNAIL_MAIL, false);
			}

			if (optStatuses != null) {
				System.debug(optStatuses);
				communicationRecord.put('Opt_Status_Updated__c', optStatuses);
			}
		}
	}

	private static String getKey(String partnerId, String param) {
		return partnerId != null && param != null ? partnerId + '$' + param.replaceAll('[- ()$]', '') : null;
	}
}