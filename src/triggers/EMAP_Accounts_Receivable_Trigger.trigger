trigger EMAP_Accounts_Receivable_Trigger on Accounts_Receivable__c (after insert, after update) {

    if(trigger.isAfter){

        if(trigger.isInsert){
            //used to set current Accounts Receivable on related Account
            //EMAP_Accounts_Receivable_TriggerHandler.setCurrentARonAccount(trigger.new);         
        }
        
        //used to check Is invoive Late and AOT? 
		//Getting list of Account IDs
		
		List<Id> accIdList = new List<Id>();
		for(Accounts_Receivable__c ARNew: trigger.new){
			accIdList.add(ARnew.Account__c);
		}
		
		//Passing the list of account IDs so that we can invoke the method asynchronously.
		
        EMAP_Accounts_Receivable_TriggerHandler.isInvoiceLateAndAOT(accIdList);
        
        //used to update Group balance on Parent Account based on Current balance on child account's AR
        EMAP_Accounts_Receivable_TriggerHandler.UpdateParentGroupBal(trigger.new);
    }
    
}