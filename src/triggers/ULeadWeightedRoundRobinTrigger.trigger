trigger ULeadWeightedRoundRobinTrigger on Lead (after insert, after update) 
{
	List<Lead> records = trigger.isDelete ? trigger.old : trigger.new;

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
	else 
	*/
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			ULeadWeightedRoundRobin.leadWeightedRoundRobin(records, trigger.oldMap);
		}
		else if(trigger.isUpdate)
		{
			ULeadWeightedRoundRobin.leadWeightedRoundRobin(records, trigger.oldMap);		
		}
		//else if(trigger.isDelete)
		//{		   
		//}
		//else if(trigger.isUndelete)
		//{	  
		//}
	}
}