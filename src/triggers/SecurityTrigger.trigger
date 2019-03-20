trigger SecurityTrigger on Security__c (after insert, after update, before insert, before update, after delete, after undelete) {
    
    /*
    if(Trigger.isUpdate) {
        SecurityTriggerHandler.onAfterUpdate(trigger.new,trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        SecurityTriggerHandler.onAfterUpdate(trigger.new,trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        SecurityTriggerHandler.onAfterInsert(trigger.new);
    } */
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            SecurityTriggerHandler.onAfterInsert(trigger.new);
        }
        
        if(Trigger.isUpdate){
            SecurityTriggerHandler.onAfterUpdate(trigger.new,trigger.oldMap);
        }
        
        if(Trigger.isDelete){
            SecurityTriggerHandler.onAfterDelete(trigger.old);
        }
        
        if(Trigger.isUndelete){
            SecurityTriggerHandler.onAfterUndelete(trigger.new);
        }
        
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            SecurityTriggerHandler.onBeforeInsert(trigger.new);  
        }
        
        if(Trigger.isUpdate){
            SecurityTriggerHandler.onBeforeUpdate(trigger.new);
        }
    }
    
}