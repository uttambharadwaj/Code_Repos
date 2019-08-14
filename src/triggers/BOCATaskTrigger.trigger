trigger BOCATaskTrigger on Application_Request__c (before update) {
    /*
    BOCA_Settings__c bocaSettings = BOCA_Settings__c.getOrgDefaults();
    
    if(bocaSettings.Enable_BOCA_Task_Trigger__c == false) {
        return; 
    }
    
    BOCATaskTriggerHandler handler = new BOCATaskTriggerHandler();
    
    if(Trigger.isBefore && Trigger.isUpdate) {

        try {
			handler.sendSolicitedTask(trigger.New);
        }
        catch(Exception e) {
            System.debug('An error occured..' + String.valueOf(e));
        }
        
        
        
    }
    */
}