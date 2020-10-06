/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger CreditSecurity_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/
trigger EMAP_Credit_Security_Trigger on Credit_Security__c (before insert, before update, after insert, after update) 
{
    if(trigger.isBefore){

        if(trigger.isUpdate){
            //used to update currency with Account's program currency
            EMAP_Credit_Security_TriggerHandler.updateCurrency(trigger.new);
        }
    }
    
    if(trigger.isAfter){
        //used to update Credit Security Expiry date on associated Account
        EMAP_Credit_Security_TriggerHandler.updateCreditSecurityExpiry_OnAccount(trigger.new);
    }
}