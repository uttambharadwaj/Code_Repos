/***************************************************************************************************
* Created By : PRM | Cloud Solutions
* Purpose : Trigger to associate card detail with Opportunity and Account after Lead conversion
* Date of Creation : 24-July-2013
****************************************************************************************************/

trigger CardDetailAssociation on Lead (after update) 
{
	//moved to LeadHelper 20/Mar/20202

//	// trigger should fire only for Leads with Australian record types
//
//	Set<Id> AU_Lead_RTs = new Set<Id>();
//
//	// Query the recordypes
//	// 26-May-2014 Manu Erwin (Salesforce.com) Now query for all AU Lead record types
//	for(RecordType rt : [SELECT Id, Name, DeveloperName FROM RecordType WHERE sObjectType = 'Lead' AND DeveloperName LIKE 'AU_%'])
//		AU_Lead_RTs.add(rt.Id);
//
//	Set<Id> leadIds = new Set<Id>();
//
//	for(Lead l : Trigger.new)
//	{
//		if(AU_Lead_RTs.contains(l.RecordTypeId))
//		{
//			// check if lead is converted
//			if(l.isConverted && !Trigger.oldMap.get(l.Id).isConverted)
//				leadIds.add(l.Id);
//		}
//	}
//
//	if(!leadIds.isEmpty())
//	{
//		List<AU_Card_Details__c> cardDetailList = new List<AU_Card_Details__c>();
//
//		// Query all card detail records against the Lead
//		cardDetailList = [SELECT Id, Lead__c FROM AU_Card_Details__c WHERE Lead__c IN :leadIds];
//		for(AU_Card_Details__c CardDetail : cardDetailList)
//		{
//			// assign the Converted Opportunity and Account to Card detail
//			Lead l = Trigger.newMap.get(CardDetail.Lead__c);
//			CardDetail.Opportunity__c = l.ConvertedOpportunityId;
//			CardDetail.Account__c = l.ConvertedAccountId;
//		}
//
//		update cardDetailList;
//
//		List<AU_Vehicle__c> vehicleDetailList = new List<AU_Vehicle__c>();
//
//		vehicleDetailList = [SELECT Id, Lead__c FROM AU_Vehicle__c WHERE Lead__c in :leadIds];
//		for(AU_Vehicle__c vehicleDetail : vehicleDetailList) {
//			Lead l = Trigger.newMap.get(vehicleDetail.Lead__c);
//			vehicleDetail.Opportunity__c = l.ConvertedOpportunityId;
//		}
//
//		update vehicleDetailList;
//
//		List<Contact> contactList = new List<Contact>();
//
//		contactList = [SELECT Id, Lead__c FROM Contact WHERE Lead__c in :leadIds];
//		for(Contact contact : contactList) {
//			Lead l = Trigger.newMap.get(contact.Lead__c);
//			contact.AccountId = l.ConvertedAccountId;
//		}
//
//		update contactList;
//	}
}