/**
 * Created by jharrell on 6/23/20.
 */
// TODO add saveAsActivity to metadata
public class CollectionsEmailHandler {

	@InvocableMethod(label='Collections Email Handler' description='Associate template ids with case')
	public static void sendEmailTemplate(List<InvocableSendEmailTemplate.EmailWrapper> emailWrappers) {

		List<Id> caseIds = new List<Id>();
		Set<String> fields = new Set<String>();
		List<InvocableSendEmailTemplate.EmailWrapper> updatedEmailWrappers = new List<InvocableSendEmailTemplate.EmailWrapper>();

		for (InvocableSendEmailTemplate.EmailWrapper emailWrapper : emailWrappers) {

			// Get all case ids
			caseIds.add(emailWrapper.whatId); // TODO maybe a map instead with emailwrapper as value
		}


		for (Collection_Email_Rules__mdt emailRules : [
				SELECT Id,Field__c
				FROM Collection_Email_Rules__mdt
		]) {
			fields.add(emailRules.Field__c);
		}
		String query = 'SELECT ' + fields.toString().replaceAll('[{}]', '') + ' FROM Case WHERE Id IN :caseIds';
		List<sObject> cases = Database.query(query);

		if (!cases.isEmpty()) {

			Map<Id, Collections_Email_Configuration__mdt> emailConfigs = new Map<Id, Collections_Email_Configuration__mdt>([
					SELECT Id, Email_Template_Id__c,Save_As_Activity__c,Contact_Types__c,Sales_Rep_Roles__c
					FROM Collections_Email_Configuration__mdt
			]);

			Map<Id, List<Id>> objToEmailConfigIds = runRuleEval(cases);

			for (Integer i = 0; i < emailWrappers.size(); i++) {
				InvocableSendEmailTemplate.EmailWrapper emailWrapper = emailWrappers.get(i);

				if (objToEmailConfigIds.get(emailWrapper.whatId) != null) {
					List<Id> matchedEmailConfigIds = objToEmailConfigIds.get(emailWrapper.whatId);

					for (Id matchedEmailConfigId : matchedEmailConfigIds) {

						InvocableSendEmailTemplate.EmailWrapper emailWrapperClone = emailWrapper.clone(); // in the even that there's more than 1 email to be send for a record
						Collections_Email_Configuration__mdt emailConfig = emailConfigs.get(matchedEmailConfigId);

						// TODO do a check for if email has previously been sent
						emailWrapperClone.templateId = emailConfig.Email_Template_Id__c;
						emailWrapperClone.saveAsActivity = emailConfig.Save_As_Activity__c;
						emailWrapperClone.contactTypes = emailConfig.Contact_Types__c;
						emailWrapperClone.salesRepRoles = emailConfig.Sales_Rep_Roles__c;

						updatedEmailWrappers.add(emailWrapperClone);

					}
				}
			}
			System.debug(updatedEmailWrappers);
			if (!updatedEmailWrappers.isEmpty()) {
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
			for (Id configId : configToEmailRules.keySet()) {

				List<Collection_Email_Rules__mdt> rules = configToEmailRules.get(configId);
				Boolean ruleEval = true;

				// Individual rules for a config
				for (Collection_Email_Rules__mdt rule : rules) {

					// TODO prolly should try catch this section
					Object value = UtilityClass.getSObjectField(sObj, rule.Field__c);
					try {
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
						}

					} catch (Exception e) {
						ruleEval = false;
						System.debug(e);
					}
				}

				// ========= Email Config Rules Ran =========
				if (ruleEval) { // true if all rules were true
					Id sObjId = (Id) sObj.get('id');
					if (objToEmailConfigIds.get(sObjId) == null) {
						objToEmailConfigIds.put(sObjId, new List<Id>());
					}
					objToEmailConfigIds.get(sObjId).add(configId);
				}
			}
		}
		return objToEmailConfigIds;
	}
}