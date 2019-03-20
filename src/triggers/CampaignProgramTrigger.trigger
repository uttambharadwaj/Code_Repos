/*

	Created By: Phillip Southern (GearsCRM)
	Created Date: 11/21/2013
	Description: Trigger for the Campaign Program object
    
	Modified By:
	Modified Date:
	Description:	

*/

trigger CampaignProgramTrigger on Campaign_Program__c (after insert, after update) {

	List<Campaign_Program__c> records = Trigger.isDelete ? Trigger.old : Trigger.new;

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
    else*/ if(Trigger.isAfter == true)
    {
        if(Trigger.isInsert == true)
        {
			Ucampaignprogram.setDefaultProgram(records, trigger.oldmap);		              
        }
        else if(trigger.isUpdate == true)
        {
        	ucampaignprogram.setDefaultProgram(records, trigger.oldmap);
			      
        }        
		/*else if(trigger.isDelete == true)
        {
               
        }
        else if(trigger.isUndelete == true)
        {
                  
        } */      
    }
}