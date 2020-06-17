/**
 * Created by jharrell on 6/16/20.
 */
@IsTest
public class CommunicationPreferencesTest {

	public static void test_CommunicationPreferencesSync() {

		Lead lead = [ SELECT Id, PartnerID__c,HasOptedOutOfEmail FROM Lead WHERE PartnerID__c != null AND email != null LIMIT 1];
		lead.HasOptedOutOfEmail = true;
		update lead;

		lead = [ SELECT Id, PartnerID__c,opt_status_updated__c,Email_Opt_In__c,HasOptedOutOfEmail,email FROM Lead WHERE id = :lead.Id];
		String optStatuses = lead.opt_status_updated__c;

		// Trigger should add status to field when opt preference updates
		System.assertEquals(true, optStatuses.contains(CommunicationPreferencesInvocable.PREF_GENERIC_EMAIL));

		CommunicationPreferencesInvocable.CommunicationPreferencesInput prefInput = new CommunicationPreferencesInvocable.CommunicationPreferencesInput();
		prefInput.genericEmail = lead.email;
		prefInput.genericEmailOptOut = lead.HasOptedOutOfEmail;
		prefInput.genericEmailOptIn = lead.Email_Opt_In__c;
		prefinput.partnerId = lead.PartnerID__c;
		prefInput.updatedPreferences = lead.opt_status_updated__c;

		CommunicationPreferencesInvocable.preferencesUpdatedHandler(new List<CommunicationPreferencesInvocable.CommunicationPreferencesInput>{prefInput});

		for (Lead updatedLead : [
				SELECT Id, PartnerID__c, opt_status_updated__c,HasOptedOutOfEmail
				FROM Lead
				WHERE Email = :lead.Email AND PartnerID__c = :lead.PartnerID__c
		]) {
			System.debug(updatedLead);
			System.assertEquals(true, updatedLead.opt_status_updated__c == null || updatedLead.opt_status_updated__c == '');
			System.assertEquals(true, updatedLead.HasOptedOutOfEmail);
		}
	}
}