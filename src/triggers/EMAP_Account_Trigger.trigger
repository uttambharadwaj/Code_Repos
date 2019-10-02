/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger EMAP_Account_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger EMAP_Account_Trigger on Account (before insert, before update, after update) 
{
    if(trigger.isBefore){
        //used to update EMAP Account record currency with program currency
        EMAP_Account_TriggerHandler.updateCurrency(trigger.new);
        
        if(trigger.isUpdate){
            //Update parent Account controller
            EMAP_Account_TriggerHandler.updateAccountController(Trigger.oldMap, Trigger.newMap);
        }
    }
    
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            // Create any new risk flags
            EMAP_RiskFlag_Handler.addRiskFlags(Trigger.newMap);
    
            //Sync data from Account to AU Application Request
            EMAP_AUAppReq_TriggerHandler.populateAccToAuAppReq(trigger.new);
            
            //update group balance on parent account
            EMAP_Account_TriggerHandler.UpdateParentGroupBal(trigger.new);
            
            //update Child Account controller on update of Parent Account controller
            EMAP_Account_TriggerHandler.updateChildAccountController(Trigger.oldMap, Trigger.newMap);        
        }
    }
}