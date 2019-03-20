/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 02/20/2014
 * Description : TaskTrigger
 * 
 * Modified By   : Raja Y(GearsCRM)
 * Modified Date : 05/02/2016
 * Description   : TaskTypeFieldUpdate method added (Client supplied code)
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger TaskTrigger on Task (before insert, before update) 
{
    List<Task> records = trigger.isDelete ? trigger.old : trigger.new;


    
    if(trigger.isBefore)
    {
        if(trigger.isInsert) 
        {
            UTask.updateLastModifiedDate(records);
            UTask.updateActivityType(records, trigger.oldmap);
            UTask.TaskTypeFieldUpdate(records);
        }
        else if(trigger.isUpdate)
        {
            Utask.updateLastModifiedDate(records);
            UTask.updateActivityType(records, trigger.oldmap);
        }
        //else if(trigger.isDelete)
        //{
        //}
    }     
    /*else 
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {   
        }
        else if(trigger.isUpdate)
        {       
        }
        //else 
        //if(trigger.isDelete)
        //{
        //}
        //else if(trigger.isUndelete)
        //{   
        //}
    }*/
}