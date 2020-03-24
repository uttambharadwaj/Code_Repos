/* ************************************************************
 * Created By  : Sean Fielding (GearsCRM)
 * Created Date: 
 * Description : Trigger AccountTrigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger AccountTrigger on Account (after delete, before delete,after insert, after update, before insert, before update) 
{
    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Account_Automation__c) { return; }

    List<Account> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            UAccount.truckersGenerateMemIdAndPassword(records, trigger.oldmap);
			UAccount.executeBREeze(records, trigger.oldMap);                        
        }
        else if(trigger.isUpdate)
        {
            UAccount.truckersGenerateMemIdAndPassword(records, trigger.oldmap);
            UAccount.parentSalesAccounts(records, trigger.oldmap);            
			UAccount.executeBREeze(records, trigger.oldMap);                        
        }
        else if(trigger.isDelete)
        {
            // collect all the data about to be deleted
            DeletedRecordsStageClass.preDeleteAccount(records);
        }
    }     
    else if(trigger.isAfter)
    {
        if(trigger.isInsert == true)
        {
            UAccount.AssignAccountTeamMembers(records, trigger.oldmap);
            UAccount.checkCompaniesHouseIntegration(records, trigger.oldMap);
            UAccount.checkVATRegNumber(records, trigger.oldMap);
        }
        else if(trigger.isUpdate == true)
        {
            UAccount.AssignAccountTeamMembers(records, trigger.oldmap);
            UAccount.checkCompaniesHouseIntegration(records, trigger.oldMap);
            UAccount.checkVATRegNumber(records, trigger.oldMap);
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