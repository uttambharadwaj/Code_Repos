/* ************************************************************
 * Created By  : (GearsCRM)
 * Created Date: 05/03/2013
 * Description : Trigger UOpportunity
 * 
 * ************************************************************/
trigger UOpportunity on Opportunity (after insert, after update, before insert, before update, after delete) {


    List<Opportunity> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            UOpportunity.getStageId(records, trigger.oldMap);
            Uopportunity.findCampaignByCouponCode(records);
            Uopportunity.communityUserStampData(records);
        }
        else if(trigger.isUpdate)
        {
            UOpportunity.getStageId(records, trigger.oldMap);
            UOpportunity.echoBefore(records, trigger.oldMap);
            UOpportunity.setContactRoles(records);
        }
        //else if(trigger.isDelete)
        //{
        //} 
    }     
    else if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            UOpportunity.createCommission(trigger.new, trigger.oldMap);
            UOpportunityShare.communityCheckSharing (records, trigger.oldmap);
            UOpportunity.createTasks(records, trigger.oldmap);
        }
        else if(trigger.isUpdate)
        {
            UOpportunity.echoAfter(records, trigger.oldMap);
            UOpportunity.createCommission(trigger.new, trigger.oldMap);
            UOpportunityShare.communityCheckSharing (records, trigger.oldmap);
            UOpportunity.createTasks(records, trigger.oldmap);
            
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