/* ************************************************************
 * Created By  : Ashish Takke
 * Created Date: 25/02/2015
 * Description : Trigger EMAP_Contact_Trigger
 * 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger EMAP_Contact_Trigger on Contact (after insert, after update) 
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            //Used to update primary contact on Account
            EMAP_Account_TriggerHandler.updatePrimaryContactOnAccount(trigger.oldMap, trigger.new);
            
            //Sync data from contact to AU Application Request's primary contact
            //EMAP_Contact_TriggerHandler.populateContToAuAppReq(trigger.new);
        }
        else if(trigger.isUpdate)
        {
            //used to lock Contact record for all users (except System Admin and IFCS Connector)
            EMAP_Contact_TriggerHandler.lockContactRecord(trigger.newMap);

            //Used to update primary contact on Account
            EMAP_Account_TriggerHandler.updatePrimaryContactOnAccount(trigger.oldMap, trigger.new);
            
            //Sync data from contact to AU Application Request's primary contact
            EMAP_Contact_TriggerHandler.populateContToAuAppReq(trigger.new);
        }
    }
}