trigger CampaignProgramAfterInsertUpdate on Campaign_Program__c (after insert, after update) {
    
    WEXProgramUtility util = new WEXProgramUtility();       
    
    if (util.isDefault(Trigger.new[0])){            
        util.resetDefaultFlagForProgram(Trigger.new[0]);  
    }
    
}