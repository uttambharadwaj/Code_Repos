/**
* Forseva online application code.
*/
trigger ForsevaLeadUpsert on Lead (after insert) {	  

    List<Id> leadList = new List<Id>();
    List<Id> cardProgramList = new List<Id>();    

    for(Lead ld : Trigger.new) {

    	if((ld.Card_Program__c != null || ld.Card_Program_ID__c != null) && ld.Lead_Source_Website__c != null && ld.Email != null) {
            leadList.add(ld.Id);
            cardProgramList.add(ld.Card_Program_ID__c != null ? ld.Card_Program_ID__c : ld.Card_Program__c);        
    	}

    	if(leadList.size() == 20) {
    	    OnlineApplication.processLeads(leadList,cardProgramList);  // only do 20 at a time as governors can crush us downstream...
    	    leadList.clear();
    	    cardProgramList.clear();
    	}
    }

    if(leadList.size() > 0) {
        OnlineApplication.processLeads(leadList,cardProgramList);
    }
    
}

// EOF