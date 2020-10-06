/* ************************************************************
 * Created By  : USER_NAME (GearsCRM)
 * Created Date: __/__/20__ 
 * Description : MergeRecordsStagingTrigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger MergeRecordsStagingTrigger on Merge_Records_Staging__c (after insert) 
{
	List<Merge_Records_Staging__c> records = trigger.isDelete ? trigger.old : trigger.new;

/*
	if(trigger.isBefore)
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
			UMergeRecords.processMerge(records);	
		}
		//else if(trigger.isUpdate)
		//{		
		//}
		//else 
		//if(trigger.isDelete)
		//{
		//}
		//else if(trigger.isUndelete)
		//{	  
		//}
	}
}