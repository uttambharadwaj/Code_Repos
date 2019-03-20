/**
* Forseva online application code.
*/
trigger OnlineApplicationDelete on OnlineApplication__c ( before insert, before update, after insert, after update, before delete) {
    
    if(Trigger.isBefore && Trigger.isDelete) {
        
        for(OnlineApplication__c oa : Trigger.old) {
            if(oa.Status__c == OnlineApplication.APPROVED || 
               oa.Status__c == OnlineApplication.DECLINED || 
               oa.Status__c == OnlineApplication.SETUP_COMPLETE || 
               oa.Status__c == OnlineApplication.MANUAL_REVIEW) {
                
               oa.addError(Label.ApplicationCannotBeDeleted);
               return;
            }
        }
    }
    // Case : trigger to stamp the object upon creation or owner change with the partner user contact and account information and  create a manual share to the record for Read Access only so that if the owner does change the partner still has visibility.
    UOnlineApplication objhandler = new UOnlineApplication();
    
    if(Trigger.isInsert && Trigger.isBefore)  
         objHandler.stampPartnerUserDetails(null, Trigger.new); 
         
    if(Trigger.isUpdate && Trigger.isBefore)  
         objHandler.stampPartnerUserDetails(Trigger.oldMap, Trigger.new);  
         
   if(Trigger.isInsert && Trigger.isAfter)  
         objHandler.afterInsertAndUpdateOfOA(null, Trigger.newmap); 
    
    if(Trigger.isUpdate && Trigger.isAfter )  {
         objHandler.afterInsertAndUpdateOfOA(Trigger.oldMap, Trigger.newmap);
    }
}
 
// EOF