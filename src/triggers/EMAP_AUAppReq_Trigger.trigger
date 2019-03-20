/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : EMAP_AUAppReq_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
trigger EMAP_AUAppReq_Trigger on AU_Application_Request__c (before update, after insert, after update) 
{   
    if(trigger.isBefore){
        if(trigger.isUpdate) {
            //used to restrict parent account from diff program
            EMAP_AUAppReq_TriggerHandler.ParentAccLookupFilter(Trigger.new);

            //used to update currency
            EMAP_AUAppReq_TriggerHandler.updateCurrency(Trigger.new);
            
            //used to update primary contact details on AU App Req
            EMAP_AUAppReq_TriggerHandler.updateAUPrimaryContact(Trigger.oldMap, Trigger.new);
            
            //used to maintain and revert status
            EMAP_AUAppReq_TriggerHandler.Update_RevertToStatus(Trigger.oldMap, Trigger.new);
            
            EMAP_AUAppReq_TriggerHandler.updateTotalTimeToAssess(Trigger.old, Trigger.newMap);
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {       
            //used to lock record for all users (except System Admin)
            EMAP_AUAppReq_TriggerHandler.lockAUAppReqRecord(Trigger.old, Trigger.newMap);
        } 
        
        //used to propagate AU App Req's Account details on associated Account
        EMAP_AUAppReq_TriggerHandler.propagateAUAppReqToAccount(Trigger.new);
        
        //used to propagate AU App Req's Contact details on associated primary contact
        EMAP_Contact_TriggerHandler.propagateAUAppReqToContact(Trigger.new);
        
        //used to update Bank and Trade ref details from AU App Req to Bank ref and Trade ref 
        EMAP_Bank_Trade_ReferenceTriggerHandler handler = new EMAP_Bank_Trade_ReferenceTriggerHandler();
        handler.CreateBankTradeReference_FromAU(Trigger.new);
    }
    
}