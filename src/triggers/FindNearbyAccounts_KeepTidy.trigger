trigger FindNearbyAccounts_KeepTidy on Account (before update) {
	
	Set<Id> AU_Acc_RTs = new Set<Id>();
	
	for(RecordType rt : [select Id from RecordType where sObjectType = 'Account' and DeveloperName IN ('AU_Fuel_Customer')])
		AU_Acc_RTs.add(rt.Id);
		
     for(Integer k=0; k<Trigger.new.size(); k++)
     {
     	if(!AU_Acc_RTs.contains(Trigger.new[k].RecordTypeId))
     	{
	        Boolean reset = false; 
	        //If they change which Address to map 
	        if(Trigger.new[k].Which_Address__c != Trigger.old[k].Which_Address__c)
	        {
	            reset = true; 
	        }
	        
	        if(Trigger.new[k].Which_Address__c == 'Billing')
	        {
	            if(Trigger.new[k].BillingStreet != Trigger.old[k].BillingStreet || Trigger.new[k].Billingcity != Trigger.old[k].BillingCity ||
	               Trigger.new[k].BillingPostalCode != Trigger.old[k].BillingPostalCode || Trigger.new[k].BillingState != Trigger.old[k].BillingState || Trigger.new[k].BillingState != Trigger.old[k].BillingState
	               || Trigger.new[k].BillingCountry != Trigger.old[k].BillingCountry )
	            {   
	               reset = true;  
	               
	            }
	        }
	        else if(Trigger.new[k].Which_Address__c == 'Shipping')
	        {
	     
	            if(Trigger.new[k].ShippingStreet != Trigger.old[k].ShippingStreet || Trigger.new[k].Shippingcity != Trigger.old[k].ShippingCity
	             ||Trigger.new[k].ShippingPostalCode != Trigger.old[k].ShippingPostalCode || Trigger.new[k].ShippingState != Trigger.old[k].ShippingState  ||
	             Trigger.new[k].ShippingCountry != Trigger.old[k].ShippingCountry)
	            {
	                  reset = true;  
	            }
	        }
	        
	        if(reset){
	            Trigger.new[k].FNA_Status__c = 'Not Located Yet';
	            Trigger.new[k].Lat__c = null;
	            Trigger.new[k].Lon__c = null;
	        }
     	}
        
     }//end FOR
}