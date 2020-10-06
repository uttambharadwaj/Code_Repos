public with sharing class UOnlineApplication {
    public UOnlineApplication() {
        
    }
    
    /*  
        Method      : stampPartnerUserDetails
        Parameters  : old and new Online Applications
        Description 
                    * On insert if the CreatedById user is Partner community user then stamp user Contact and Account values on Online Application EXtrenal Account and Contact
                    * On update of owner field  if the Owner is Partner community user then stamp user Contact and Account values on Online Application EXtrenal Account and Contact
    
    */
    
    public void stampPartnerUserDetails(Map<Id,OnlineApplication__c> mapOldOnlineApplication, List<OnlineApplication__c> listOnlineApplication) {
        
        Set<Id> setOApplicationCreatedUserIds = new Set<Id>();   
        Map<Id,Id> mapOApplicationIdToOwner = new Map<Id,Id>();
        Map<Id, User> mapPartnerUserIdToObj = new Map<Id, User>();
        
        // iterate over map to get the ownerId's of OnlineApplication
        for(OnlineApplication__c objApplication : listOnlineApplication) 
        {
            if(Trigger.isInsert) 
                setOApplicationCreatedUserIds.add(objApplication.CreatedById);
            else if(Trigger.isUpdate)
            {
                if(mapOldOnlineApplication.get(objApplication.Id).OwnerId != objApplication.OwnerId) 
                    mapOApplicationIdToOwner.put(objApplication.Id, objApplication.OwnerId);
            }
        }
       
        
        // SWF 12/11/15 - 
        // in a simple test, this query executes 16 times fo rno reason
        if(setOApplicationCreatedUserIds.size() == 0 && mapOApplicationIdToOwner.size() == 0)
        {
            return;
        }
        
        
        // Query the Users  related to OnlineApplication
        for(User objuser : [SELECT Id, AccountId, ContactId
                            FROM User 
                            WHERE (Id IN : setOApplicationCreatedUserIds OR Id IN : mapOApplicationIdToOwner.values())
                            AND IsActive = true
                            AND AccountId != null 
                            AND ContactId != null ]) 
        {
            // check for partner users                  
            mapPartnerUserIdToObj.put(objuser.Id, objuser); 
        }   
   
        
        //iterate over  map to update the fields on OnlineApplication with Running users Partner Account and Running users Partner Contact
        //SWF 12/11/15 
        // if the mapPartnerUserIdToObj is empty, this is is a wate of time, add a check
        if(mapPartnerUserIdToObj.size() == 0)
        {
            return;
        }
        
        for(OnlineApplication__c objApplication : listOnlineApplication) 
        {
            if(trigger.isInsert) 
            { 
                if(mapPartnerUserIdToObj.containskey(objApplication.CreatedById)) 
                {    
                    objApplication.Referred_by_External_Account__c = mapPartnerUserIdToObj.get(objApplication.CreatedById).AccountId;
                    objApplication.External_Referred_By_Contact__c = mapPartnerUserIdToObj.get(objApplication.CreatedById).ContactId;
                }
            }
            else if(trigger.isUpdate)
            {
                 if(mapPartnerUserIdToObj.containskey(objApplication.OwnerId)) 
                 {   
                    objApplication.Referred_by_External_Account__c = mapPartnerUserIdToObj.get(objApplication.OwnerId).AccountId;
                    objApplication.External_Referred_By_Contact__c = mapPartnerUserIdToObj.get(objApplication.OwnerId).ContactId;
                }
            }
            system.debug('!!!!!!!!!!!!!!!!!!! acc : ' + objApplication.Referred_by_External_Account__c);
            system.debug('!!!!!!!!!!!!!!!!!!! con : ' + objApplication.External_Referred_By_Contact__c);
        }
    }
    
     /*
        Method      : afterInsertAndUpdateOfOA
        Parameters  : old and new Online Applications
        Description 
                    * On insert if the created by user and owner is different then create sharing record and share with that created by user
                    * On update of owner field check if the old owner is partner then share the record with him
                    * On update of External contact share the record with new contact and delete the sharing record of old external contact
    
    */
      public void afterInsertAndUpdateOfOA( Map<Id,OnlineApplication__c> mapOldOnlineApplication,  Map<Id,OnlineApplication__c> mapNewOnlineApplication) {
        
        List<OnlineApplication__Share> lstSharingRecordsToDelete = new List<OnlineApplication__Share>();
        List<OnlineApplicationOffer__Share> lstOfferSharingRecordsToDelete = new List<OnlineApplicationOffer__Share>();
        
        Set<Id> setPartnerAccountIds = new Set<Id>();
        Set<Id> setOfExternalContactId = new Set<Id>();
        Set<Id> setChnagedOwnerId = new Set<Id>();
        Set<Id> setOldOwnerIds = new Set<Id>();
        
        Map<Id,Id> mapContactIdToUserId = new Map<Id,Id>();
        Map<Id, User> mapUserIdToUser = new Map<Id,User>(); 
        Map<Id,Id> mapUserIdToAccountId = new Map<Id,Id>();
        Map<Id,Id> mapOfOAIdToCreatedById = new Map<Id,Id>();
        Map<Id, Id> mapOnlineAppIdToPartnerId = new Map<Id,Id>();
        Map<Id, Id> mapOApplicationOfferToPartnerUser = new Map<Id, Id>();
        //Map<Id, Id> mapOfAppIdToExternalContactToUpdate = new Map<Id, Id>();
        
        Map<Id,Id> mapOApplicationIdToOldContact = new Map<Id,Id>();
        Map<Id,Id> mapOApplicationOfferIdToOldContact = new Map<Id,Id>();
        
        //iterate over map to get the ownerId's of OnlineApplication
        for(OnlineApplication__c objApplication : mapNewOnlineApplication.values()) {
            
            if(Trigger.isInsert) {  
                  
                if(objApplication.CreatedById != objApplication.OwnerId)  // only if the created user and owner are different
                    mapOfOAIdToCreatedById.put(objApplication.Id, objApplication.CreatedById );
            }
            
             if(trigger.isupdate) {
                
                if(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c != objApplication.External_Referred_By_Contact__c) {
                    
                    if(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c != NULL) {
                        
                        setOfExternalContactId.add(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c);
                    } 
                    if(objApplication.External_Referred_By_Contact__c != NULL) {
                        
                        setOfExternalContactId.add(objApplication.External_Referred_By_Contact__c);
                    }
                }
                //add ownerIds to list
                if(objApplication.OwnerId != mapOldOnlineApplication.get(objApplication.Id).OwnerId) {
                    
                    setOldOwnerIds.add(mapOldOnlineApplication.get(objApplication.Id).OwnerId);
                    setChnagedOwnerId.add(objApplication.OwnerId);
                }
            }
        }
       /* if(Test.isRunningTest()) { 
            
             List<User> lstUsers = [ Select Id, ContactId,AccountId from User where ContactId != null and isActive = true limit 1];
            
            //User objUser = createTestUser();
            
            // check for partner users                  
            mapContactIdToUserId.put(lstUsers[0].ContactId, lstUsers[0].Id);
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!! SIZE 2 : ' + lstUsers.size());
            
         } else {*/
            
         // SWF 12/11/15
         if(setOfExternalContactId.size() > 0)
         {
            // iterating over user to get the account id
            for(User  objuser :[    SELECT Id,AccountId,ContactId
                                    FROM User
                                    WHERE ContactId IN : setOfExternalContactId]) {
                                        
                mapContactIdToUserId.put(objuser.ContactId, objuser.Id);
            }
         }  
            
     //   }
        
       /*  if(Test.isRunningTest()) {  
            
             List<User> lstUsers = [ Select Id,ContactId, AccountId from User where ContactId != null and AccountId != null and isActive = true limit 1];
             // User objUser = createTestUser();
              mapUserIdToAccountId.put(lstUsers[0].Id, lstUsers[0].AccountId);
              mapUserIdToUser.put(lstUsers[0].Id, lstUsers[0]);
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!! SIZE 3 : ' + lstUsers.size());
         }else {*/
             
        //SWF 12/1/15 
        if(mapOfOAIdToCreatedById.size() > 0 || setChnagedOwnerId.size() > 0 || setOldOwnerIds.size() > 0 || mapContactIdToUserId.size() > 0)    
        {         
            // Get all users who created Online Applications
            for(User objuser : [  SELECT Id, AccountId, ContactId
                                  FROM User 
                                  WHERE isActive = true AND (Id IN : mapOfOAIdToCreatedById.values() OR Id IN : setChnagedOwnerId OR Id IN : setOldOwnerIds OR Id IN : mapContactIdToUserId.values())]) { // update owner
                // if Partner users will Account
                // SWF 12/11/15 Why is this not a part of the query if it must be populated?
                if(objuser.AccountId != null) 
                {                         
                    mapUserIdToAccountId.put(objuser.Id, objuser.AccountId);
                    mapUserIdToUser.put(objuser.Id, objuser);
                }
            }
        }
    //    }
        
       if(mapUserIdToAccountId.size() > 0)
       {
        // Cross verify whether the user is Partner user or not                      
        for(Account objAccount : [  SELECT Id, IsPartner 
                                    FROM Account
                                    WHERE Id IN : mapUserIdToAccountId.values()]) 
        {
            //SWF 12/11/15 why is this not a part of the query
            if(objAccount.IsPartner) 
            {
                setPartnerAccountIds.add(objAccount.Id);
            }
        }
       }
        
        //iterate over  map to update the fields on OnlineApplication with Running users Partner Account and Running users Partner Contact
        for(OnlineApplication__c objApplication : mapNewOnlineApplication.values()) {
            
            Id userId = objApplication.CreatedById;
            
            if(trigger.isUpdate) 
                userId = mapOldOnlineApplication.get(objApplication.Id).OwnerId;
                
                if(trigger.isInsert) {
                    
                    if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                        
                         if(objApplication.Offer__c != null ) // Share Read access to online Application Offer record
                            mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  userId);
                        // create online application share record
                        mapOnlineAppIdToPartnerId.put(objApplication.Id, userId);
                     }
            }
                
            if(trigger.isUpdate && objApplication.OwnerId != mapOldOnlineApplication.get(objApplication.Id).OwnerId) { // owner change, create share record
                    
                 if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                     
                     // create sharing record 
                     if(objApplication.Offer__c != null) // Share Read access to online Application Offer record
                        mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  userId);
                    // creat online application share record
                    mapOnlineAppIdToPartnerId.put(objApplication.Id, userId);
                }
            } 
            if(Trigger.isUpdate) {
                
                Id oldExternalContact, newExternalContact;
                
                oldExternalContact = mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c;
                newExternalContact = objApplication.External_Referred_By_Contact__c;
                // external Contact
                if(oldExternalContact != newExternalContact) {
                    
                    if(newExternalContact != null && mapContactIdToUserId.containskey(newExternalContact)  
                     && mapContactIdToUserId.get(newExternalContact) != objApplication.OwnerId
                     && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(newExternalContact))
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(newExternalContact)))) { //&& mapContactIdToUserId.get(newExternalContact) != objApplication.OwnerId 
                        
                         // create sharing record 
                        if(objApplication.Offer__c != null) // Share Read access to online Application Offer record
                            mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  mapContactIdToUserId.get(newExternalContact));
                    
                        mapOnlineAppIdToPartnerId.put(objApplication.Id, mapContactIdToUserId.get(newExternalContact));
                        // map to update Online applications
                    }
                    // delete if the contact user is not current owner or old owner then delete
                   if( oldExternalContact != NULL && mapContactIdToUserId.containskey(oldExternalContact)
                        && mapContactIdToUserId.get(oldExternalContact) != objApplication.OwnerId
                        && mapContactIdToUserId.get(oldExternalContact) != mapOldOnlineApplication.get(objApplication.Id).OwnerId
                        && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(oldExternalContact))
                        && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(oldExternalContact)))) {
                        
                        // add online app id and old conatct  
                        mapOApplicationIdToOldContact.put(objApplication.Id, mapContactIdToUserId.get(oldExternalContact));
                        mapOApplicationOfferIdToOldContact.put(objApplication.Offer__c, mapContactIdToUserId.get(oldExternalContact));
                    }
                }
            }
        }
        
        //SWF 12/11/15 
        if(mapOApplicationIdToOldContact.size() > 0 &&  mapOApplicationIdToOldContact.size() > 0)
        {
            // Execute only if External contact is changes 
            for(OnlineApplication__Share objsharing : [ SELECT Id,ParentId,UserOrGroupId 
                                                        FROM OnlineApplication__Share
                                                        WHERE ParentId IN : mapOApplicationIdToOldContact.keyset()
                                                        AND UserOrGroupId IN : mapOApplicationIdToOldContact.values()  ]) {
                                                                
                    lstSharingRecordsToDelete.add(objsharing);
                    
            }
        }
        
        
        if(mapOApplicationOfferIdToOldContact.size() > 0 && mapOApplicationOfferIdToOldContact.size() > 0)
        {
             // Execute only if External contact is changes 
            for(OnlineApplicationOffer__Share objOffersharing : [ SELECT Id,ParentId,UserOrGroupId 
                                                                  FROM OnlineApplicationOffer__Share
                                                                  WHERE ParentId IN : mapOApplicationOfferIdToOldContact.keyset()
                                                                  AND UserOrGroupId IN : mapOApplicationOfferIdToOldContact.values()  ]) {
                                                                
                  lstOfferSharingRecordsToDelete.add(objOffersharing);
            }
        }
        
        if(!lstOfferSharingRecordsToDelete.isEmpty())
            delete lstOfferSharingRecordsToDelete;
            
        if(!lstSharingRecordsToDelete.isEmpty())
            delete lstSharingRecordsToDelete;
            
        if(!mapOApplicationOfferToPartnerUser.isEmpty())
            UCreateAccountShareRecords.createOnlineApplicationOfferShareForCommunityUsers(mapOApplicationOfferToPartnerUser);
        
        if(!mapOnlineAppIdToPartnerId.isEmpty())
            UCreateAccountShareRecords.createOnlineApplicationForCommunityUsers(mapOnlineAppIdToPartnerId);
       
    }
     

}