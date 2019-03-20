trigger CampaignProgramBeforeInsertUpdate on Campaign_Program__c (before insert, before update) {
 	if (Trigger.isUpdate){
        WEXProgramUtility util = new WEXProgramUtility();
         
        if (util.isPublished(Trigger.new[0].program__c) && !util.isDefault(Trigger.new[0]) && !util.hasAnotherDefaultTermsAndConditionsSet(Trigger.new[0])){
            Trigger.new[0].adderror('The default Campaign Program (Terms and Conditions) cannot be unchecked for a published BOCA.');                  	
        } 
    }
    if (Trigger.isInsert){
        WEXProgramUtility util = new WEXProgramUtility();
         
        if (util.isPublished(Trigger.new[0].program__c) && !util.isDefault(Trigger.new[0]) && !util.hasAnotherDefaultTermsAndConditionsSet(Trigger.new[0])){
            Trigger.new[0].adderror('There must be a default Campaign Program (Terms and Conditions) cannot be unchecked for a published BOCA.');                  	
        } 
    }
}