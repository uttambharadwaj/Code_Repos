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

trigger TaskTrigger on Task (before insert, before update, before delete)
{
    List<Task> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore)
    {
        if(trigger.isInsert) 
        {
            UTask.updateLastModifiedDate(records);
            UTask.updateActivityType(records, trigger.oldMap);
            UTask.TaskTypeFieldUpdate(records);
        }
        else if(trigger.isUpdate)
        {
            UTask.updateLastModifiedDate(records);
            UTask.updateActivityType(records, trigger.oldMap);
        }
        else if(trigger.isDelete)
        {
            UTask.DontDeleteCollectionsTasks(records);
        }
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