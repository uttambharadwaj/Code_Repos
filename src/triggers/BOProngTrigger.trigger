trigger BOProngTrigger on Beneficial_Owner_Prong__c (before insert, after insert, after update) {
    
    // Adding this for anything coming from a public site. 
    // These calculations are already happening on that side, so
    // trying to reduce number of SOQL calls since we're close to
    // limits. Will re-visit after Project Lean n' Mean
    if(UserInfo.getSessionId() == null) {
        return;
    }
    
	if(Trigger.isBefore && Trigger.isInsert) {
        
        for(Beneficial_Owner_Prong__c boProng : Trigger.new) {
        
        	BOProngTriggerHandler.validateNumberOfRecords(boProng);
            
        }
        
    }

}