/*
	Created By: Phillip Southern (GearsCRM)
	Created Date: 06/17/2013
	Description: Trigger for the Account_Asset__c object
    
	Modified By:
	Modified Date:
	Description:	
*/

trigger AccountAssetTrigger on Account_Asset__c (after insert, after update) {
	
	List<Account_Asset__c> records = Trigger.isDelete ? Trigger.old : Trigger.new;

    /*if(Trigger.isBefore == true)
    {
    	if(Trigger.isInsert == true)
        {
        		                  
        }
        else if(trigger.isUpdate == true)
        {
        	     
        }
        else if(trigger.isDelete == true)
        {
                  
        }
    }     
    else */
    if(Trigger.isAfter == true)
    {
        if(Trigger.isInsert == true)
        {
			UAccountAsset.opportunityPopulation(records, trigger.oldMap); 			              
        }
        else if(trigger.isUpdate == true)
        {
			UAccountAsset.opportunityPopulation(records, trigger.oldMap);            
        }        
		/*else if(trigger.isDelete == true)
        {
               
        }
        else if(trigger.isUndelete == true)
        {
                  
        }    */   
    }

}