// revision history https://gist.github.com/aplssf/0cdcd2383373efb52f5d/revisions
trigger WE_MasterTargetTrigger on Target__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete)
{

    if (Trigger.isBefore) {
        if (Trigger.isInsert) { } 
        if (Trigger.isUpdate) { }
        if (Trigger.isDelete) { }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) 
        {
            WE_TeamTargetCalculation targets = new WE_TeamTargetCalculation(true, Trigger.oldMap, Trigger.newMap);
            targets.updateTargets();
        } 
        if (Trigger.isUpdate)
        {
            WE_TeamTargetCalculation targets = new WE_TeamTargetCalculation(false, Trigger.oldMap, Trigger.newMap);
            targets.updateTargets();
        }
        if (Trigger.isDelete) { }
    }
}