/* ************************************************************
 * Created By  : Phillip Southern (GearsCRM)
 * Created Date: __/__/20__ 
 * Description : Trigger LeadTrigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger LeadTrigger on Lead (before insert, before update, after insert, after delete, after update) 
{
	List<Lead> records = trigger.isDelete ? trigger.old : trigger.new;

	if(trigger.isBefore)
	{
		if(trigger.isInsert) 
		{

			ULead.setTotalVehicles(records, trigger.oldMap);
			ULead.setVehicleCount(records, trigger.oldMap);
			
			ULead.linktoContactAccount(records, trigger.oldmap);
			
			Ulead.findCampaignByCouponCode(records);

			ULead.communityUserStampData(records);
		}
		else if(trigger.isUpdate)
		{
			
			ULead.setTotalVehicles(records, trigger.oldMap);
			ULead.setVehicleCount(records, trigger.oldMap);
			
			ULead.linktoContactAccount(records, trigger.oldmap);
			
			ULead.eloquaPassParent(records, trigger.oldmap);
		}
		else if(trigger.isDelete)
		{
		}
	}     
	else if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			
			ULead.processParentLead(records, trigger.oldmap);
			
			ULead.eloquaPass(records,trigger.oldMap);
			
			ULead.createCampaignMember(records);
			ULead.decoupleChildLeadCheck(records, trigger.oldmap);

		    ULead.mergei2iParentDuplicates(records, trigger.oldmap);
		    
		    ULeadShare.communityCheckSharing(records, trigger.oldMap);
			LeadTriggerHandler.createRelatedTaskAndNote(records, trigger.oldMap);
		}
		else if(trigger.isUpdate)
		{
			
			Ulead.processParentLead(records, trigger.oldmap);		
	    	
	    	ULead.eloquaPass(records,trigger.oldMap);
	    	
	    	ULead.primaryCampaignChange(records, trigger.oldmap);
	    	ULead.decoupleChildLeadCheck(records, trigger.oldmap);
		    
			ULead.mergei2iParentDuplicates(records, trigger.oldmap);
		    
		    UCampaignMember.setOpportunity(records, trigger.oldMap);
			
			ULeadShare.communityCheckSharing(records, trigger.oldMap);
			LeadTriggerHandler.createRelatedTaskAndNote(records, trigger.oldMap);
		}
		else if(trigger.isDelete)
		{
			DeletedRecordsStageClass.processDelete(records);				   
		}
		//else if(trigger.isUndelete)
		//{	  
		//}
	}
}