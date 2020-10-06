public with sharing class QuickLinksController {
	public class QuickLinkWrapper {
		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String url { get; set; }
		@AuraEnabled
		public String target { get; set; }
	}

	@AuraEnabled
	public static List<QuickLinkWrapper> getQuickLinksServ(String recordId) {
		List<QuickLinkWrapper> wrList = new List<QuickLinkWrapper> ();
		Map<String, String> mergeFieldReplaceMap = new Map<String, String> ();
		Map<String, String> mergeFieldValueMap = new Map<String, String> ();
		List<String> fldList = new List<String> ();
		String platform = 'ALL';

		List<Case> cases = [SELECT AccountId, Account.Platform__c FROM Case WHERE Id = :recordId];
		if (!cases.isEmpty()) {
			Case c = cases[0];
			if (c.AccountId != null) {
				platform = c.Account.Platform__c;
			}
			else {
				return wrList;
			}
		}

		List<Quick_Links__mdt> linksList = [SELECT
		                                    MasterLabel,
		                                    Link_URL__c,
		                                    Query_Parameter__c,
		                                    Sort_Order__c,
		                                    Target__c
		                                    FROM
		                                    Quick_Links__mdt
		                                    WHERE
		                                    Platform__c = :platform
		                                    OR
		                                    Platform__c = 'ALL'
		                                    ORDER BY
		                                    Sort_Order__c ASC];

		for (Quick_Links__mdt link : linksList) {
			String queryStr = link.Query_Parameter__c;
			if (String.isNotEmpty(queryStr)) {
				String regex = '\\{![\\._a-zA-Z0-9]+\\}';
				Pattern p = Pattern.compile(regex);
				Matcher m = p.matcher(queryStr);
				while (m.find())
				{
					String replaceString = queryStr.substring(m.start(), m.end());
					String mergeField = queryStr.substring(m.start() + 2, m.end() - 1);
					String field = mergeField.substring(mergeField.indexOf('.') + 1);
					mergeFieldReplaceMap.put(field, replaceString);
					fldList.add(field);
				}
			}
		}

		if (!fldList.isEmpty() && String.isNotEmpty(recordId)) {
			String query = 'SELECT Id';
			for (String field : fldList) {
				if (field != 'Id') {
					query += ', ' + field;
				}
			}
			String objName = Id.valueOf(recordId).getSobjectType().getDescribe().getName();
			query += ' FROM ' + objName + ' WHERE Id =:recordId LIMIT 1';
			List<SObject> records = Database.query(query);
			if (!records.isEmpty()) {
				Sobject rec = records[0];
				for (String field : fldList) {
					String fieldValue = '';
					Object sobjValue;
					if (field.contains('.')) {
						String relSobj = field.substring(0, field.indexOf('.'));
						String relField = field.substring(field.indexOf('.') + 1);
						SObject parentObj = rec.getSObject(relSobj);
						if (parentObj != null) {
							sobjValue = parentObj.get(relField);
						}
					} else {
						sobjValue = rec.get(field);
					}
					if (sobjValue != null) {
						fieldValue = (String) sobjValue;
					}
					mergeFieldValueMap.put(field, fieldValue);
				}
			}
		}

		for (Quick_Links__mdt link : linksList) {
			QuickLinkWrapper linkWrapper = new QuickLinkWrapper();
			linkWrapper.label = link.MasterLabel;
			linkWrapper.url = link.Link_URL__c;
			linkWrapper.target = link.Target__c;
			String queryStr = link.Query_Parameter__c;
			if (String.isNotEmpty(queryStr)) {
				for (String field : fldList) {
					String replaceString = mergeFieldReplaceMap.get(field);
					String fieldValue = mergeFieldValueMap.get(field);
					queryStr = queryStr.replace(replaceString, fieldValue);
				}
				queryStr = (linkWrapper.url.contains('?')) ? '&' + queryStr : '?' + queryStr;
				linkWrapper.url += queryStr;
			}
			wrList.add(linkWrapper);
		}
		return wrList;
	}
}