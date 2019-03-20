/* ************************************************************
 * Created By  : Raja Yeccherla (GearsCRM)
 * Created Date: 8/15/2017 
 * Description : Trigger ObjectChangeLogTrigger
 * 
 * Modified By   :
 * Modified Date :  
 * Description   :
 * 
 * ************************************************************/
trigger ObjectChangeLogTrigger on pi__ObjectChangeLog__c (after insert) 
{
    List<pi__ObjectChangeLog__c> records = trigger.isDelete ? trigger.old : trigger.new;

    /*if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
        }
        else if(trigger.isUpdate)
        {
        }
        else if(trigger.isDelete)
        { 
        } 
    }     
    else if(trigger.isAfter)*/
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            UObjectChangeLog.updateOwner(records);
        }
        /*else if(trigger.isUpdate)
        {       
        }
        else if(trigger.isDelete)
        {          
        }
        else if(trigger.isUndelete)
        {   
        }*/
    }  
}