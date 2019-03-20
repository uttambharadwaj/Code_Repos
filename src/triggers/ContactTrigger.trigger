/* ************************************************************
 * Created By  : Sean Fielding (GearsCRM)
 * Created Date: 8/9/2013 
 * Description : Trigger ContactTrigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger ContactTrigger on Contact (after insert, after update, after delete) 
{
	List<Contact> records = trigger.isDelete ? trigger.old : trigger.new;

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
			UContact.processCountContacts(records, trigger.oldMap);
			UContactShare.communityCheckSharing(records,trigger.oldmap);
			
		}
		else if(trigger.isUpdate)
		{
			UContact.processCountContacts(records, trigger.oldMap);	
			
			
			UContact.mergei2iDuplicates(records, trigger.oldmap);	
			UContactShare.communityCheckSharing(records,trigger.oldmap);
		}
		else if(trigger.isDelete)
		{	
			UContact.processDeleteCountContacts(records, trigger.oldMap);
			DeletedRecordsStageClass.processDelete(records);		   
		}
		//else if(trigger.isUndelete)
		//{	  
		//https://cs1.salesforce.com/img/seasonLogos/2013_summer_aloha.png}
	}
}