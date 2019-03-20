/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger Credit_Assessment_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
trigger EMAP_Credit_Assessment_Trigger on Credit_Assessment__c (before insert, before update, after insert, after update) {
  
    //all methods defined in below CreditAssessmntTriggerHandler class
    EMAP_Credit_Assessment_TriggerHandler creditAssmnt = new EMAP_Credit_Assessment_TriggerHandler();
    
    if(trigger.isBefore){
    
        if(trigger.isUpdate)
        {
            //lock credit Assessment when final judgement is Approved
            creditAssmnt.lockCreditAssmnt(trigger.old, trigger.newMap);

	        //used to update Approval fields on Credit Assessment record. 
	        creditAssmnt.updateApprovalFields(trigger.new);
        
            //update currency with Account.Program.Currency
            creditAssmnt.updateCurrency(trigger.new);

            //maintain old sub-status in Revert_To_Status field, when new sub-status is Hold
            creditAssmnt.Update_RevertToStatus(trigger.oldMap, trigger.new);
        }
    }
    else if(trigger.isAfter){
        //propagate credit assessment record values on associated Account, when final judgement is Approved
        creditAssmnt.propagateCreditAssmntToAcc(trigger.new);
        
        if(trigger.isUpdate){
	        //update AU App req Approval status once CA approval status is updated by approval process
	        creditAssmnt.updateAUAppReqApprovalStatus(trigger.new);
        }
    }
}