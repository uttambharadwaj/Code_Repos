trigger OnlineApplicationTrigger on OnlineApplication__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	List<OnlineApplication__c> records = trigger.isDelete ? trigger.old :trigger.new;
    
    if(trigger.isafter)
    {
        if(trigger.isInsert)
        {
            OnlineApplicationWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
			// coment out code below so code coverage is maintained as this call out is no longer need. 
			// per GearsCRM Case 30757 enm 04/18/2017
       // 	UOnlineApplication.callExperianBizScore(records, Trigger.oldMap);	

        }
        else if(trigger.isUpdate)
        {
            OnlineApplicationWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
        }
        /*
        //else if(trigger.isDelete)
        //{
        // }
        //else if(trigger.isUndelete)
        //{
        //}*/  
    } 
}