/**
 * Created by jharrell on 6/23/20.
 */

public class CollectionsEmailHandler {

	@InvocableMethod(label='Collections Email Handler' description='Associate template ids with case')
	public static void sendEmailTemplate(List<InvocableSendEmailTemplate.EmailWrapper> emailWrappers) {

		List<Id> caseIds = new List<Id>();
		Set<String> fields = new Set<String>();
		List<InvocableSendEmailTemplate.EmailWrapper> updatedEmailWrappers = new List<InvocableSendEmailTemplate.EmailWrapper>();
		Map<Id, Case> updatedCases = new Map<Id, Case>();


		for (InvocableSendEmailTemplate.EmailWrapper emailWrapper : emailWrappers) {

			// Get all case ids
			caseIds.add(emailWrapper.whatId);
		}


		for (Collection_Email_Rules__mdt emailRules : [
				SELECT Id,Field__c
				FROM Collection_Email_Rules__mdt
		]) {
			fields.add(emailRules.Field__c);
		}
		fields.add('Processed_Email_Configs__c');
		fields.add('CreatedDate');

		String query = 'SELECT ' + fields.toString().replaceAll('[{}]', '') + ' FROM Case WHERE Id IN :caseIds';
		Map<Id, sObject> cases = new Map<Id, sObject>(Database.query(query));

		if (!cases.isEmpty()) {

			Map<Id, Collections_Email_Configuration__mdt> emailConfigs = new Map<Id, Collections_Email_Configuration__mdt>([
					SELECT Id, Email_Template_Id__c,Save_As_Activity__c,Contact_Types__c,Sales_Rep_Roles__c,Org_Wide_Email_Id__c,Appended_Value_Field__c
					FROM Collections_Email_Configuration__mdt
			]);

			Map<Id, List<Id>> objToEmailConfigIds = runRuleEval(cases.values());

			for (Integer i = 0; i < emailWrappers.size(); i++) {
				InvocableSendEmailTemplate.EmailWrapper emailWrapper = emailWrappers.get(i);

				if (objToEmailConfigIds.get(emailWrapper.whatId) != null) {
					List<Id> matchedEmailConfigIds = objToEmailConfigIds.get(emailWrapper.whatId);

					for (Id matchedEmailConfigId : matchedEmailConfigIds) {

						InvocableSendEmailTemplate.EmailWrapper emailWrapperClone = emailWrapper.clone(); // in the even that there's more than 1 email to be send for a record
						Collections_Email_Configuration__mdt emailConfig = emailConfigs.get(matchedEmailConfigId);

						emailWrapperClone.templateId = emailConfig.Email_Template_Id__c;
						emailWrapperClone.saveAsActivity = emailConfig.Save_As_Activity__c;
						emailWrapperClone.contactTypes = emailConfig.Contact_Types__c;
						emailWrapperClone.salesRepRoles = emailConfig.Sales_Rep_Roles__c;
						emailWrapperClone.orgWideEmailId = emailConfig.Org_Wide_Email_Id__c;

						updatedEmailWrappers.add(emailWrapperClone);

						Id caseId = emailWrapperClone.whatId;
						Case emailedCase = updatedCases.get(caseId) != null ? updatedCases.get(caseId) : (Case) cases.get(caseId); // in the event that more than one email is sent, get the already updated case

						// value to be added to the Processed_Email_Configs__c field

						// check the email config record for an additional field value that we want to add to the value going into Processed_Email_Configs__c
						String appendValues = emailConfig.Appended_Value_Field__c != null ? String.valueOf(UtilityClass.getSObjectField(emailedCase, emailConfig.Appended_Value_Field__c)) : null;

						List<String> processedEmailKeys = getEmailKeys(emailConfig.Id, appendValues);
						emailedCase.Processed_Email_Configs__c = UtilityClass.updateMultiPicklist(emailedCase.Processed_Email_Configs__c, processedEmailKeys, false);
						updatedCases.put(emailedCase.Id, emailedCase);

					}
				}
			}
			System.debug(updatedEmailWrappers);
			if (!updatedEmailWrappers.isEmpty()) {
				update updatedCases.values();
				InvocableSendEmailTemplate.sendEmailTemplate(updatedEmailWrappers);
			}
		}
	}

	// TODO consider and/or and how that'd work
	public static Map<Id, List<Id>> runRuleEval(List<sObject> sObjs) {

		Map<Id, List<Id>> objToEmailConfigIds = new Map<Id, List<Id>>();

		Map<Id, List<Collection_Email_Rules__mdt>> configToEmailRules = new Map<Id, List<Collection_Email_Rules__mdt>>();

		for (Collection_Email_Rules__mdt emailRule : [
				SELECT  Id,
						Field__c,
						Collections_Email_Configuration__r.Email_Template_Id__c,
						Collections_Email_Configuration__r.Start_Date_Time__c,
						Collections_Email_Configuration__r.Appended_Value_Field__c,
						Operator__c,Value__c
				FROM Collection_Email_Rules__mdt
		]) {

			if (configToEmailRules.get(emailRule.Collections_Email_Configuration__c) == null) {
				configToEmailRules.put(emailRule.Collections_Email_Configuration__c, new List<Collection_Email_Rules__mdt>());
			}
			configToEmailRules.get(emailRule.Collections_Email_Configuration__c).add(emailRule);
		}

		// For each sObject
		for (sObject sObj : sObjs) {
			// All rules for a config
			List<String> previouslyProcessedEmails = sObj.get('Processed_Email_Configs__c') != null ? String.valueOf(sObj.get('Processed_Email_Configs__c')).split('\\,') : null;
			for (Id configId : configToEmailRules.keySet()) {

				List<Collection_Email_Rules__mdt> rules = configToEmailRules.get(configId);
				Boolean ruleEval = true;

				if (ruleEval) { // false when a config id has already been sent for specific Case.

					// Individual rules for a config
					for (Collection_Email_Rules__mdt rule : rules) {

						try {
							Object value = UtilityClass.getSObjectField(sObj, rule.Field__c);

							if (value == null) {
								ruleEval = false;
							} else if (rule.Collections_Email_Configuration__r.Start_Date_Time__c != null &&
									rule.Collections_Email_Configuration__r.Start_Date_Time__c > Datetime.valueOf(sObj.get('CreatedDate'))) {
								ruleEval = false;
							} else if (rule.Collections_Email_Configuration__r.Appended_Value_Field__c != null) {

								String appendValues = String.valueOf(UtilityClass.getSObjectField(sObj, rule.Collections_Email_Configuration__r.Appended_Value_Field__c));
								List<String> keys = getEmailKeys(configId, appendValues);
								ruleEval = emailsNotYetSent(keys, previouslyProcessedEmails); // if email has already been sent don't send it again

								// ============= Operator Rules =============
							} else if (rule.Operator__c == '>=') {
								if (Integer.valueOf(value) < Integer.valueOf(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == '<=') {
								if (Integer.valueOf(value) > Integer.valueOf(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == '>') {
								if (Integer.valueOf(value) <= Integer.valueOf(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == '<') {
								if (Integer.valueOf(value) >= Integer.valueOf(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == '==') {
								if (!String.valueOf(value).equalsIgnoreCase(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == '!=') {
								if (String.valueOf(value).equalsIgnoreCase(rule.Value__c)) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == 'IN') {
								List<String> valueList = rule.Value__c.split(',');
								if (!valueList.contains(String.valueOf(value))) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == 'NOT IN') {
								List<String> valueList = rule.Value__c.split(',');
								if (valueList.contains(String.valueOf(value))) {
									ruleEval = false;
								}
							} else if (rule.Operator__c == 'Contains') {

								if (!rule.Value__c.contains(',')) rule.Value__c += ',';

								Boolean contained = false;
								for (String val : rule.Value__c.split(',')) {
									if (String.valueOf(value).containsIgnoreCase(val)) {
										contained = true;
									}
								}
								ruleEval = contained;

							} else if (rule.Operator__c == 'NOT Contains') {
								if (!rule.Value__c.contains(',')) rule.Value__c += ',';

								Boolean contained = false;
								for (String val : rule.Value__c.split(',')) {
									if (String.valueOf(value).containsIgnoreCase(val)) {
										contained = true;
									}
								}
								ruleEval = !contained;
							}
							// ==============================================================================
						} catch (Exception e) {
							ruleEval = false;
							System.debug(e);
						}

						if (ruleEval == false) break; // currently all rules need to be true so no need to go through the rest....
					}
				}

				// ========= Email Config Rules Ran =========

				Id sObjId = (Id) sObj.get('id');
				if (objToEmailConfigIds.get(sObjId) == null) objToEmailConfigIds.put(sObjId, new List<Id>());

				// true if all rules were true
				if (ruleEval) objToEmailConfigIds.get(sObjId).add(configId);

			}
		}
		return objToEmailConfigIds;
	}


	/**
		* Purpose: Create a key to be used in logic to determine what email configs have been sent previously. In the event that
		* 			an email needs to be sent more than once configs allow for having a value appended to the key.
		* Input: (String, String) Main Key, Comma seperated values. -- Main key is likely to be the record ID of the email config, values
		* 			are specified in the config metadata. For example, comma separated list of Contract IDs where each contract should have
		* 			the email config sent.
		* Output: (List<String>) List of generated keys. If 0-1 values were passed in this list size will be 1. Otherwise increased per value.
	*/
	public static List<String> getEmailKeys(String key, String values) {

		List<String> keys = new List<String>();

		if (values != null && values != '') {
			List<String> valueList = values.remove(' ').split('\\,');

			for (String value : valueList) {
				String createdKey = value != '' ? key + '$' + value : key;
				keys.add(createdKey);
			}

		} else {
			keys.add(key);
		}
		return keys;
	}


	/**
		* Purpose: Determine if there's any emails that have not yet been sent. This factors in both the email config id,
	 	* 			and any values identified in the config to append(allowing for a config to be sent more than once).
		* Input: (List<String>, List<String>) New keys, Old (processed) keys
		* Output: (Boolean) false when all emails have already been sent
	*/
	private static Boolean emailsNotYetSent(List<String> keys, List<String> processedEmails) {
		Boolean emailsNotYetSent = false;

		if (processedEmails == null) {
			emailsNotYetSent = true;
		} else {
			for (String key : keys) {
				if (!processedEmails.contains(key)) emailsNotYetSent = true;
			}
		}

		return emailsNotYetSent;
	}
}