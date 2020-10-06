/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger EMAP_Bank_Reference_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
trigger EMAP_Bank_Reference_Trigger on Bank_Reference__c (after insert, after update) 
{
    if(trigger.isUpdate)
    {
        //used to propagate Bank Ref details to associated AU App Req record
        EMAP_Bank_Trade_ReferenceTriggerHandler handler = new EMAP_Bank_Trade_ReferenceTriggerHandler();
        handler.createBankReference_OnAU(Trigger.new);
    }
}