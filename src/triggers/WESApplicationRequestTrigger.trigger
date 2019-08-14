trigger WESApplicationRequestTrigger on WES_Application_Request__c (before insert, before update, after insert, after update) {
    List<WES_Application_Request__c> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore == true) {
        if(trigger.isInsert == true) {
            WESApplicationRequestTriggerHandler.matchVelocityProfile(records, trigger.oldMap);
        } else if(trigger.isUpdate == true) {
            WESApplicationRequestTriggerHandler.matchVelocityProfile(records, trigger.oldMap);
        } /*else if(trigger.isDelete == true) {
        }*/
    } else if(trigger.isAfter == true) {
        if(trigger.isInsert == true) {
            WESApplicationRequestWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createCreditDetails(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createFuelPacks(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createFuelCards(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.checkDNBIntegration(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.sendApplicationToIFCS(records, trigger.oldMap);
        } else if(trigger.isUpdate == true) {
            WESApplicationRequestWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createCreditDetails(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createFuelPacks(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.createFuelCards(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.checkDNBIntegration(records, trigger.oldMap);
            WESApplicationRequestTriggerHandler.sendApplicationToIFCS(records, trigger.oldMap);
        } /* else if(trigger.isDelete == true) {
        } else if(trigger.isUndelete == true) {
        }
        } */
    }
}