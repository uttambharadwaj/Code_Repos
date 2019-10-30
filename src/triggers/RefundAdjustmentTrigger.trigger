/**
 * Created by W083158 on 10/16/2019.
 */

Trigger RefundAdjustmentTrigger on Refund_Adjustment__c (before insert, before update) {
    List<Refund_Adjustment__c> records = Trigger.isDelete ? Trigger.old : Trigger.new;

    if(Trigger.isBefore == true)
    {
        if(Trigger.isInsert == true)
        {
            RefundAdjustmentTriggerHelper.insertRefAdj(records);
        }
        else if(Trigger.isUpdate == true)
        {
            RefundAdjustmentTriggerHelper.updateRefAdj(records,Trigger.oldMap, UserInfo.getUserId());
        }
    }
}