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
		String query = 'SELECT ' + fields.toString().replaceAll('[{}]', '') + ',Processed_Email_Configs__c FROM Case WHERE Id IN :caseIds';
		Map<Id, sObject> cases = new Map<Id, sObject>(Database.query(query));

		if (!cases.isEmpty()) {

			Map<Id, Collections_Email_Configuration__mdt> emailConfigs = new Map<Id, Collections_Email_Configuration__mdt>([
					SELECT Id, Email_Template_Id__c,Save_As_Activity__c,Contact_Types__c,Sales_Rep_Roles__c,Org_Wide_Email_Id__c
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
						emailedCase.Processed_Email_Configs__c = UtilityClass.updateMultiPicklist(emailedCase.Processed_Email_Configs__c, emailConfig.Id, false);
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


		// could technically pass this information in via the soql in sendEmailTemplate
		// but doing it this way will allow calling this method in anon apex for debugging purposes
		for (Collection_Email_Rules__mdt emailRule : [
				SELECT Id,Field__c,Collections_Email_Configuration__r.Email_Template_Id__c,Operator__c,Value__c
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
			String processedEmailConfigs = (String) sObj.get('Processed_Email_Configs__c');
			for (Id configId : configToEmailRules.keySet()) {

				List<Collection_Email_Rules__mdt> rules = configToEmailRules.get(configId);
				Boolean ruleEval = processedEmailConfigs != null && processedEmailConfigs.contains(configId) ? false : true;

				if (ruleEval) { // false when a config id has already been sent for specific Case.

					// Individual rules for a config
					for (Collection_Email_Rules__mdt rule : rules) {

						try {
							Object value = UtilityClass.getSObjectField(sObj, rule.Field__c);

							if (value == null) {
								ruleEval = false;
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
}