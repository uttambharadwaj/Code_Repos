trigger ProgramTrigger on Program__c (before insert, before update) {
    List<Program__c> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore == true) {
        if(trigger.isInsert == true) {
			UProgram.executeBREeze(records, trigger.oldMap);                        
        } else if(trigger.isUpdate == true) {
			UProgram.executeBREeze(records, trigger.oldMap);                        
        } /*else if(trigger.isDelete == true) {
        }
    } else if(trigger.isAfter == true) {
        if(trigger.isInsert == true) {
        } else if(trigger.isUpdate == true) {
        } else if(trigger.isDelete == true) {
        } else if(trigger.isUndelete == true) {
        }
        } */
    }
}