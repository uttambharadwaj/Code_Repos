/* ************************************************************
 * Created By  : Sean Fielding (GearsCRM)
 * Created Date: 3/15/2013
 * Description : Trigger CampaignMemberTrigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger CampaignMemberTrigger on CampaignMember (before insert, after insert, after delete, after undelete) 
{
	List<CampaignMember> records = trigger.isDelete ? trigger.old : trigger.new;

	if(trigger.isBefore)
	{
		if(trigger.isInsert)
		{
			//turning off due to locking row error 022614
			//UCampaignMember.setParentLead(records);
		}
		//else if(trigger.isUpdate)
		//{ 
		//}
		//else if(trigger.isDelete)
		//{
		//}
	}     
	else if(trigger.isAfter) 
	{
		if(trigger.isInsert)
		{
			//turning off due to locking row error 022614
			//UCampaignMember.linkParentLead(records);
			
			//turning off due to locking_row error 020914
			//UCampaignMember.updateCounts(records);
		}
		//else if(trigger.isUpdate)
		//{
		//}
		else if(trigger.isDelete)
		{
			//UCampaignMember.updateCounts(records);
			
			//turning off due to locking_row error 022614
			//UCampaignMember.checkAssociations(records);		   
		}
		else if(trigger.isUndelete)
		{
			//UCampaignMember.updateCounts(records);	  
		}
	}
}