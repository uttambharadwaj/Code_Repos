/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: 02/11/2014 
 * Description : Class UTask
 * 
 * Modified By   : Raja Yeccherla(GearsCRM)
 * Modified Date : 05/02/2016
 * Description   : TaskTypeFieldUpdate (Code supplied by client)
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
public with sharing class UTask 
{

    public static void updateLastModifiedDate(List<Task> records)
    {
        //List<Task> tasktoupdate = new List<Task>();
        
        for(Task t : records)
        {
            t.Last_Modified_Index__c = system.now(); //t.LastModifiedDate;
            //tasktoupdate.add(t);
        }
        
        //if(tasktoupdate.size()>0) update tasktoupdate;
    }

    public static void updateActivityType(List<Task> records, Map<Id,Task> oldmap)
    {
        Id collRecordTypeId = UtilityClass.getRecTypeByDevName('Task', 'Collections');
        Id armRecordTypeId = UtilityClass.getRecTypeByDevName('Task', 'AR_Maintenance');
        boolean isinsert = (oldmap==null);

        for(Task t : records)
        {
            //add a check for collections or ar maintenance type. skip if true
            if(t.RecordTypeId != null && (t.RecordTypeId != collRecordTypeId && t.RecordTypeId != armRecordTypeId)) {
                if (
                        (isinsert && t.Type != null)
                                ||
                                (!isinsert && t.Type != oldmap.get(t.Id).Type)
                        ) {
                    t.Activity_Type__c = t.Type;
                }
            }
        }
    }
    
    public static void TaskTypeFieldUpdate(List<Task> records)
    {
        for(Task t : records)
        {
            if(t.Subject == 'Solicited Application')
            {
                t.Type = 'Solicited'; 
            }
        }
    }

    public static void DontDeleteCollectionsTasks(List<Task> records){
        Id collRecordTypeId = UtilityClass.getRecTypeByDevName('Task', 'Collections');
        Id armRecordTypeId = UtilityClass.getRecTypeByDevName('Task', 'AR_Maintenance');

        for(Task t : records){

            if(t.RecordTypeId != null && (t.RecordTypeId == collRecordTypeId || t.RecordTypeId == armRecordTypeId
                    || t.whatId.getSobjectType() == Collections__c.getSObjectType())) {
                t.addError('Unable to delete Collections tasks.');
            }
        }
    }
}