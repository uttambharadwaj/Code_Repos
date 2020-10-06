public with sharing class QuoteDocumentTriggerHandler {
	public static void createApplications(Map<Id, SBQQ__QuoteDocument__c> newMap) {

		Map<Id, OnlineApplication__c> docNewAppMap = new Map<Id, OnlineApplication__c>();
		Map<Id, SBQQ__QuoteDocument__c> docQuoteMap = new Map<Id, SBQQ__QuoteDocument__c>([select SBQQ__Quote__r.Online_Application_Offer__c, SBQQ__Quote__r.OwnerId from SBQQ__QuoteDocument__c where Id in :newMap.keySet()]);
		List<CPQ_Online_Application_Mappings__mdt> mdt = [select Online_Application_Field__c, Quote_Field__c from CPQ_Online_Application_Mappings__mdt];

		Map<Id, OnlineApplication__c> docExistingAppMap = new Map<Id, OnlineApplication__c>();
		Set<Id> existingAppIds = new Set<Id>();
		for (SBQQ__QuoteDocument__c doc : newMap.values()) {
			if (doc.Online_Application__c != null) {
				existingAppIds.add(doc.Online_Application__c);
			}
		}

		Map<Id, OnlineApplication__c> existingApps = new Map<Id, OnlineApplication__c>([select Id from OnlineApplication__c where Id in :existingAppIds]);

		for (SBQQ__QuoteDocument__c doc : newMap.values()) {
			if (doc.Online_Application__c != null) {
				docExistingAppMap.put(doc.Id, existingApps.get(doc.Online_Application__c));
			}
		}

		for (SBQQ__QuoteDocument__c doc : newMap.values()) {
			SBQQ__QuoteDocument__c docQuote = docQuoteMap.get(doc.Id);

			OnlineApplication__c app;

			if (doc.Online_Application__c == null) {
				app = new OnlineApplication__c();
			} else {
				app = docExistingAppMap.get(doc.Id);
			}

			if (doc.SBQQ__SignatureStatus__c == 'Signed' && docQuote.SBQQ__Quote__r.Online_Application_Offer__c != null) {
				app.Offer__c = docQuote.SBQQ__Quote__r.Online_Application_Offer__c;
				app.OwnerId = docQuote.SBQQ__Quote__r.OwnerId;
				app.Application_Stage__c = 'Application';
				app.Status__c = 'Saved-Complete';

				for (CPQ_Online_Application_Mappings__mdt fields : mdt) {
					try {
						app.put(fields.Online_Application_Field__c, doc.get(fields.Quote_Field__c));
					} catch (Exception ex) {
					}
				}

				if (doc.Online_Application__c == null) {
					docNewAppMap.put(doc.Id, app);
				}
			}
		}

		List<OnlineApplication__c> existingAppsList = docExistingAppMap.values();

		if (!existingAppsList.isEmpty()) {
			update existingAppsList;
		}

		List<OnlineApplication__c> newAppsList = docNewAppMap.values();

		if (!newAppsList.isEmpty()) {
			insert newAppsList;

			List<SBQQ__QuoteDocument__c> docList = new List<SBQQ__QuoteDocument__c>();

			for (SBQQ__QuoteDocument__c doc : [select Id, Online_Application__c from SBQQ__QuoteDocument__c where Id in :docNewAppMap.keySet()]) {
				OnlineApplication__c app = docNewAppMap.get(doc.Id);
				doc.Online_Application__c = app.Id;
				docList.add(doc);
			}

			if (!docList.isEmpty()) {
				update docList;
			}
		}
	}
}