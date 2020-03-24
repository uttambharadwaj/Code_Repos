trigger QuoteTrigger on zqu__Quote__c (before update, after update, before insert) {

    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Zuora_Automation__c) { return; }

    QuoteTriggerHandler handler = new QuoteTriggerHandler();
    
    system.debug('Quote Trigger Running');
    
    if (trigger.isBefore && trigger.isInsert) {
        handler.beforeInsert(trigger.new); 
    }

    if (trigger.isAfter && trigger.isUpdate){
        handler.runSend(trigger.New, Trigger.OldMap);
        QuoteTriggerHandler.isRunning = true;
    } else if (trigger.isBefore && trigger.isUpdate){
        handler.updateStatus(trigger.New, Trigger.OldMap);
    }
        
}