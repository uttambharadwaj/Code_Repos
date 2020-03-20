/**
* Forseva online application code.
*/
trigger LeadAfterUpdate on Lead (after update) {
	// moved to LeadHelper 20/Mar/2020
	
//	if(TriggerFactory.disabledTriggers(Lead.sObjectType)) return;
//	Set<Id> AU_Lead_RTs = UtilityClass.getRecTypeByDevName('Lead', new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'});
//
//	List<Id> leadIds = new List<Id>();
//    for(Lead l : Trigger.new)
//    {
//    	if(!AU_Lead_RTs.contains(l.RecordTypeId))
//	    	leadIds.add(l.Id);
//    }
//
//    if(!leadIds.isEmpty()) {
//
//	    List<OnlineApplication__c> oaList = [select Id, Account__c, Opportunity__c, Lead__c from OnlineApplication__c where Lead__c in :leadIds];
//
//	    Map<Id,OnlineApplication__c> oaMapByLead = new Map<Id,OnlineApplication__c>();
//	    for(OnlineApplication__c oa : oaList) {
//	        oaMapByLead.put(oa.Lead__c, oa);
//	    }
//	    oaList.clear();
//
//	    for(Lead l : Trigger.new) {
//
//	        // we just care about newly-converted Leads
//	        if(l.IsConverted == true && Trigger.oldMap.get(l.Id).IsConverted == false) {
//	            OnlineApplication__c oa = oaMapByLead.get(l.Id);
//	            if(oa != null) {
//	                oa.Account__c = l.ConvertedAccountId;
//	                oa.Opportunity__c = l.ConvertedOpportunityId;
//	                oaList.add(oa);
//	            }
//	        }
//	    }
//
//	    update oaList;
//    }
}

// EOF