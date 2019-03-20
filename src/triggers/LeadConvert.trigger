trigger LeadConvert on Lead (after update) {
 
  if (Trigger.new.size() == 1) 
  {
 		Set<Id> AU_Lead_RTs = new Set<Id>();
	
		for(RecordType rt : [select Id from RecordType where sObjectType = 'Lead' and DeveloperName IN ('AU_Fuel_Application_Individual','AU_Fuel_Business','AU_Fuel_Merchant','AU_Fuel_Prepaid','AU_VCC')])
			AU_Lead_RTs.add(rt.Id);
			
	if(!AU_Lead_RTs.contains(Trigger.new[0].RecordTypeId))
  	{
	
      if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) 
      {
   		// Get the new oppcontactrole record
 		if (Trigger.new[0].ConvertedOpportunityId != null && Trigger.new[0].ConvertedContactId != null)
 		{
 			for(OpportunityContactRole ocr : [select Id,IsPrimary from OpportunityContactRole where OpportunityId = :Trigger.new[0].ConvertedOpportunityId and ContactId = :Trigger.new[0].ConvertedContactId])
 			{
 				ocr.IsPrimary = true;
 				update ocr;
 			}
 			
 			
  			//OpportunityContactRole ocr = [select Id,IsPrimary from OpportunityContactRole where OpportunityId = :Trigger.new[0].ConvertedOpportunityId and ContactId = :Trigger.new[0].ConvertedContactId];
  			//ocr.IsPrimary = true;
			//update ocr;
 		}
  	  } 
  	}
  }     
}