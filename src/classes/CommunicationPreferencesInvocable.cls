/**
 * Created by jharrell on 6/12/20.
 */

public class CommunicationPreferencesInvocable {

	@InvocableMethod(
			label = 'Communication Preferences Updated Handler'
			description = 'Syncs communication preferences between records with matching contact information'
	)
	public static void preferencesUpdatedHandler(List<CommunicationPreferencesInput> inputs) {

		List<Id> partnerIds = new List<Id>();
		List<String> emails = new List<String>();
		List<String> phoneNumbers = new List<String>();
		Map<String, CommunicationPreferencesInput> preferences = new Map<String, CommunicationPreferencesInput>();
		List<Contact> contactsToUpdate = new List<Contact>();

		for (CommunicationPreferencesInput input : inputs) {

			// ALL - used for selective query
			partnerIds.add(input.partnerId);
			emails.add(input.email);
			phoneNumbers.add(input.phone);

			// TODO create one of these for mobile number, snail mail, phone, street
			if (input.updatedPreferences.containsIgnoreCase('email')) {
				String key = getKey(input.partnerId,input.email);
				if (preferences.get(key) == null) preferences.put(key, input);
			}

		}

		// Contacts
		for (Contact contact :  [
				SELECT Id, Email,Phone,PartnerID__c,HasOptedOutOfEmail,Email_Opt_In_Contact__c
				FROM Contact
				WHERE PartnerID__c IN :partnerIds
				AND (Email IN :emails
					OR Phone IN :phoneNumbers)
		]) {
			Boolean updateContact = false;
			String emailKey = getKey(contact.PartnerID__c, contact.email);
			String phoneKey = getKey(contact.PartnerID__c, contact.phone);

			if (emailKey != null && preferences.get(emailKey) != null) {

				CommunicationPreferencesInput pref = preferences.get(emailKey);

				contact.Email_Opt_In_Contact__c = pref.emailOptIn;
				contact.HasOptedOutOfEmail = pref.emailOptOut;
				updateContact = true;
			}
			if (phoneKey != null && preferences.get(phoneKey) != null) {

				updateContact = true;
			}


			// If updated add to list
			if (updateContact) {
				contact.opt_status_updated__c = null;
				contactsToUpdate.add(contact);
			}
		}
		if (!contactsToUpdate.isEmpty()) Database.update(contactsToUpdate, false);
	}

	public class CommunicationPreferencesInput {

		@InvocableVariable(label = 'email')
		public String email;

		@InvocableVariable(label = 'phone')
		public String phone;

		@InvocableVariable(label = 'partnerId')
		public Id partnerId;

		@InvocableVariable(label = 'updatedPreferences')
		public String updatedPreferences;

		@InvocableVariable(label = 'Email Opt In')
		public Boolean emailOptIn;

		@InvocableVariable(label = 'Email Opt Out')
		public Boolean emailOptOut;
		// TODO make sure these are required and such

	}

	private static String getKey(String partnerId, String param) {
		return partnerId != null && param != null ? partnerId + '$' + param.replaceAll('[- ()]', '') : null;
	}
}