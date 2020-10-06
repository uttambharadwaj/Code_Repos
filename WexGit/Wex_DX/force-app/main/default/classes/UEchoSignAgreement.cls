/* ************************************************************
 * Created By  :  GearsCRM
 * Created Date: 11/16/2013 
 * Description :  Helper class for Echosign
 *
 * Modified By   :  Raja Yeccherla(GearsCRM)
 * Modified Date :  7/1/2015
 * Description :  On Create Task where Subject = "Call for Echosign Signature".
 *                    Set Activity_Type__c to "Call".
 *                    Set Type = "Call"
 * ************************************************************/

public class UEchoSignAgreement {

    public static void createTasks (List <echosign_dev1__SIGN_Agreement__c> records, Map <id, echosign_dev1__SIGN_Agreement__c> oldMap)
    {
        boolean isInsert = (oldMap == null);
        
        set <id> outForSigs = new set <id>();
        set <id> signed = new set <id>();
        set <id> oppIds = new set <id>();
        
        for(echosign_dev1__SIGN_Agreement__c e : records)
        {
            if(e.echosign_dev1__Status__c == 'Out for Signature'
                && e.echosign_dev1__Opportunity__c != null
                && ((isInsert == true)
                   || (isInsert == false && e.echosign_dev1__Status__c != oldMap.get(e.id).echosign_dev1__Status__c)))
            {
                outForSigs.add(e.id);
            }
            else if(e.echosign_dev1__Status__c == 'Signed'
                && e.echosign_dev1__Opportunity__c != null
                && ((isInsert == true)
                   || (isInsert == false && e.echosign_dev1__Status__c != oldMap.get(e.id).echosign_dev1__Status__c)))
            {
                signed.add(e.id);
                oppIds.add(e.echosign_dev1__Opportunity__c);
            } 
        }
        
        if(signed.size() == 0 && outForSigs.size() == 0)
        {
            return;
        }
        
        if(outForSigs.size() > 0)
        {
        
            id recordTypeId = UtilityClass.getRecordTypeByName(Task.getSObjectType(),'General');
        
            List <Task> tasksToCreate = new List <Task>();
        
            for(echosign_dev1__SIGN_Agreement__c e : [select echosign_dev1__Opportunity__r.OwnerId, 
                                                  echosign_dev1__Status__c,
                                                  echosign_dev1__Opportunity__c
                                                  from echosign_dev1__SIGN_Agreement__c
                                                  where id in :outForSigs])
            {
                if(e.echosign_dev1__Status__c == 'Out for Signature')
                {
                    tasksToCreate.add(createTask(recordTypeId, e.echosign_dev1__Opportunity__c, 
                       'Sent app for Echosign', 'Email', 'Sent app for Echosign', 'Completed', e.echosign_dev1__Opportunity__r.OwnerId, system.today()));   
                     
                    tasksToCreate.add(createTask(recordTypeId, e.echosign_dev1__Opportunity__c, 
                       'Call for Echosign Signature', 'Call', 'Call for Echosign Signature', 'Not Started', e.echosign_dev1__Opportunity__r.OwnerId, system.today().addDays(2)));
                }   
            }
        
            if(tasksToCreate.size() > 0)
            {
                insert tasksToCreate;
            }
        }
        
        if(signed.size() > 0)
        {
            List <Task> tasksToUpdate = new List <Task>();
            
            for(Task t : [select id, whatId, status, activityDate 
                          from Task 
                          where whatId in :oppIds 
                          and status = 'Not Started' 
                          and subject = 'Call for Echosign Signature'])
            {
                t.status = 'Completed';
                t.activityDate = system.today();
                t.Call_Outbound_Result__c = 'Did Not Make Contact';
                tasksToUpdate.add(t);   
            }
            
            if(tasksToUpdate.size() > 0)
            {
                update tasksToUpdate;
            }
        }
    }
    
    public static Task createTask (id recordTypeId, id opportunityId, string subject, string atype, string description, string status, id ownerId, date aDate)
    {
        Task t = new Task();
        t.recordTypeId = recordTypeId;
        t.whatId = opportunityId;
        t.subject = subject;
        t.type = atype;
        t.Activity_Type__c = atype;
        t.description = description;        
        t.status = status;
        t.activityDate = aDate;
        t.ownerId = ownerId;
        return t;
    }
    

}