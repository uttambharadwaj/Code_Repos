/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger EMAP_Trade_Reference_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
trigger EMAP_Trade_Reference_Trigger on Trade_Reference__c (after insert, after update) 
{
    if(Trigger.isInsert)
    {
        //used to propagate Trade Ref details to associated AU App Req record
        EMAP_Bank_Trade_ReferenceTriggerHandler handler = new EMAP_Bank_Trade_ReferenceTriggerHandler();
       // handler.createTradeReference_OnAU(Trigger.new);
    }
    
    if(trigger.isUpdate)
    {
        //used to propagate Trade Ref details to associated AU App Req record
        EMAP_Bank_Trade_ReferenceTriggerHandler handler = new EMAP_Bank_Trade_ReferenceTriggerHandler();
        handler.createTradeReference_OnAU(Trigger.new);
    }
}