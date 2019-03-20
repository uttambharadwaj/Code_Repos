trigger EMAP_Invoice_Trigger on Invoice__c (before insert, before update) {
	
    if(trigger.isBefore){
        	//used to check Is invoive Late and AOT? 
			EMAP_Invoice_TriggerHandler.isLateAndAOT(trigger.new);
    }
}