trigger LeadConvert on Lead (after update) {
//	moved to process builder 20/Mar/2020
//	if(TriggerFactory.disabledTriggers(Lead.sObjectType)) return;
//  if (Trigger.new.size() == 1)
//  {
// 		Set<Id> AU_Lead_RTs = UtilityClass.getRecTypeByDevName('Lead', new List<String>{'AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC'});
//
//	if(!AU_Lead_RTs.contains(Trigger.new[0].RecordTypeId))
//  	{
//
//      if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true)
//      {
//   		// Get the new oppcontactrole record
// 		if (Trigger.new[0].ConvertedOpportunityId != null && Trigger.new[0].ConvertedContactId != null)
// 		{
// 			for(OpportunityContactRole ocr : [select Id,IsPrimary from OpportunityContactRole where OpportunityId = :Trigger.new[0].ConvertedOpportunityId and ContactId = :Trigger.new[0].ConvertedContactId])
// 			{
// 				ocr.IsPrimary = true;
// 				update ocr;
// 			}
//
//
//  			//OpportunityContactRole ocr = [select Id,IsPrimary from OpportunityContactRole where OpportunityId = :Trigger.new[0].ConvertedOpportunityId and ContactId = :Trigger.new[0].ConvertedContactId];
//  			//ocr.IsPrimary = true;
//			//update ocr;
// 		}
//  	  }
//  	}
//  }
}