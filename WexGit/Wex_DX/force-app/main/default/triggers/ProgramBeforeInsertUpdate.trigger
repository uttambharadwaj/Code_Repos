trigger ProgramBeforeInsertUpdate on Program__c (before insert, before update) {
    if(TriggerFactory.disabledTriggers(Program__c.sObjectType)) return;
	Program__c pgm = Trigger.new[0];
    WEXProgramUtility util = new WEXProgramUtility();
    
    util.hasAllBranding(pgm);
    
    if(pgm.Publish_BOCA__c == true && !util.hasDefaultOnlineApplicationOffer(pgm.Id) && (pgm.Form_Template__c).equalsIgnoreCase('OTRBOCA')) {
        pgm.adderror('An OTR BOCA must have an associated default Online Application Offer.');
    }
    else if(pgm.Publish_BOCA__c == true && !util.hasDefaultTermsAndConditions(pgm.Id) && !(pgm.Form_Template__c).equalsIgnoreCase('OTRBOCA')){ 
    	pgm.adderror('Please define a default Campaign Program before publishing this BOCA.');
    }
}