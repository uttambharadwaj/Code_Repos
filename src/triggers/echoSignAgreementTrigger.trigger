trigger echoSignAgreementTrigger on echosign_dev1__SIGN_Agreement__c (after insert, after update) 
{
    List<echosign_dev1__SIGN_Agreement__c> records = trigger.isDelete ? trigger.old : trigger.new;

    //if(trigger.isBefore)
    //{
        //i//f(trigger.isInsert)
        //{
        //}
        //else if(trigger.isUpdate)
        //{
        //}
        //else if(trigger.isDelete)
        // {
        // }
    //}     
    //else 
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
        	UEchoSignAgreement.createTasks(records, trigger.oldMap);
        }
        else if(trigger.isUpdate)
        {  
        	UEchoSignAgreement.createTasks(records, trigger.oldMap);     
        }
        /*else if(trigger.isDelete)
        {          
        }
        else if(trigger.isUndelete)
        {     
        }*/
    }
}