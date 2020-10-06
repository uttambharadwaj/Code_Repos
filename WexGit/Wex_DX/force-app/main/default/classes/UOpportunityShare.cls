/**
    ClassName      :   UOpportunityShare trigger handler
    
    Case Number    :   00022193
    
    Description    :   Whenever Opportunity is Inserted or Updated(based on crieteria), share the Opportunity record with the Community User who is associated with the opportunity
                       via "Extenal Referred By(lookup to Contact)"
    
    Modified Date  : 24/08/2015
*/

public with sharing class UOpportunityShare {
    
    
    /**
        MethodName  : communityCheckSharing
        Parameters  : Old and new Opportunity map
        Description : Called on after insert and on after update trigger events
                      - On insert share the Opportunity record with the community user 
                      - On update of ownerId or External referred By field create opportunity share record
                      - On update Delete the Opportunity Sharing record created for old contact, applicable only if the updated Opportunity has no contact associated
    */
    
    /* Modified According to the case - 22193 */
    
    public static void communityCheckSharing (List<Opportunity> lstNewOpportunities, Map<Id, Opportunity> oldmap) {
        
        /*Set<Id> setOldContactsToRevokeSharings = new Set<Id>();
        Set<Id> referredContactIds = new Set<Id>();
        Set<Id> setAccountIds = new Set<Id>();
        
        List<OpportunityShare> lstOpportunitySharesToInsert = new List<OpportunityShare>();
        List<OpportunityShare> lstOpportunitySharesDelete = new List<OpportunityShare>();
        
        Map<Id, Id> communityUsers = new Map<Id,Id>();
        Map<Id, Id> mapAccountIdToOwner = new Map<Id, Id>();
        Map<Id, Id> mapAccountIdToCommunityUserId = new Map<Id, Id>();
        Map<Id, Id> mapOpportunityIdToCommunityUserId = new Map<Id, Id>();
        Map<String, OpportunityShare> mapOppIdToShareForOldContacts = new Map<String, OpportunityShare>();
        
        // Determine insert or upadte event
        Boolean isinsert = (oldmap == null);*/
        
        List<OpportunityShare> lstSharingRecordsToDelete = new List<OpportunityShare>();
        List<AccountShare> lstAccountSharingRecordsToDelete = new List<AccountShare>();
        
        Set<Id> setPartnerAccountIds = new Set<Id>();
        Set<Id> setOfExternalContactId = new Set<Id>();
        Set<Id> setChnagedOwnerId = new Set<Id>();
        Set<Id> setOldOwnerIds = new Set<Id>();
        
        Map<Id,Id> mapContactIdToUserId = new Map<Id,Id>();
        Map<Id, User> mapUserIdToUser = new Map<Id,User>(); 
        Map<Id,Id> mapUserIdToAccountId = new Map<Id,Id>();
        Map<Id,Id> mapOfOppIdToCreatedById = new Map<Id,Id>();
        Map<Id, Id> mapOfAccountToCommunityUser = new Map<Id, Id>();
        Map<Id, Id> mapOfOpportunityIdToCommunityUserId = new Map<Id, Id>();
        
        Map<Id,Id> mapOpportunityIdToOldContact = new Map<Id,Id>();
        Map<Id,Id> mapAccountIdToOldContact = new Map<Id,Id>();
        
        // Determine insert or upadte event
        //Boolean isinsert = (oldmap == null);
        
         //iterate over map to get the ownerId's of Opportunities
        for(Opportunity objOpportunity : lstNewOpportunities) {
            
              if(Trigger.isInsert) {
                
                if(objOpportunity.CreatedById != objOpportunity.OwnerId)  // only if the created user and owner are different
                    mapOfOppIdToCreatedById.put(objOpportunity.Id, objOpportunity.CreatedById );
              }
              
              if(Trigger.isUpdate) {
                
                if(oldmap.get(objOpportunity.Id).External_Referred_By__c != objOpportunity.External_Referred_By__c) {
                    
                    if(oldmap.get(objOpportunity.Id).External_Referred_By__c != NULL) {
                        
                        setOfExternalContactId.add(oldmap.get(objOpportunity.Id).External_Referred_By__c);
                    } 
                    if(objOpportunity.External_Referred_By__c != NULL) {
                        
                        setOfExternalContactId.add(objOpportunity.External_Referred_By__c);
                    }
                }
                
                 //add ownerIds to set
                if(objOpportunity.OwnerId != oldmap.get(objOpportunity.Id).OwnerId) {
                    
                    setOldOwnerIds.add(oldmap.get(objOpportunity.Id).OwnerId);
                    setChnagedOwnerId.add(objOpportunity.OwnerId);
                }
                
              }
        }
        
        // iterating over user to get the account id
        if(setOfExternalContactId.size()>0) {
            for (User objuser : [
                    SELECT Id,AccountId,ContactId
                    FROM User
                    WHERE ContactId IN :setOfExternalContactId
            ]) {

                mapContactIdToUserId.put(objuser.ContactId, objuser.Id);
            }
        }
        
        
         // Get all users who created Opportunities
         if(mapOfOppIdToCreatedById.size()>0 || setChnagedOwnerId.size()>0 || setOldOwnerIds.size()>0 || mapContactIdToUserId.size()>0) {
             for (User objuser : [
                     SELECT Id, AccountId, ContactId
                     FROM User
                     WHERE isActive = true AND (Id IN :mapOfOppIdToCreatedById.values() OR Id IN :setChnagedOwnerId OR Id IN :setOldOwnerIds OR Id IN :mapContactIdToUserId.values())
             ]) { // update owner
                 // if Partner users will Account
                 if (objuser.AccountId != null) {

                     mapUserIdToAccountId.put(objuser.Id, objuser.AccountId);
                     mapUserIdToUser.put(objuser.Id, objuser);
                 }
             }
         }

        // Cross verify whether the user is Partner user or not
        if(mapUserIdToAccountId.size()>0) {
            for (Account objAccount : [
                    SELECT Id, IsPartner
                    FROM Account
                    WHERE Id IN :mapUserIdToAccountId.values()
            ]) {

                if (objAccount.IsPartner) {

                    setPartnerAccountIds.add(objAccount.Id);
                }
            }
        }
        
        for(Opportunity objOpportunity : lstNewOpportunities) {
            
            Id userId = objOpportunity.CreatedById;
            
            if(trigger.isupdate) {
                
                 userId = oldmap.get(objOpportunity.Id).OwnerId;
            }
            
             if(trigger.isInsert) {
                    
                if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                // Share Read access to Account record
                if(objOpportunity.AccountId != null ) 
                
                 mapOfAccountToCommunityUser.put(objOpportunity.AccountId,  userId);
                 
                 mapOfOpportunityIdToCommunityUserId.put(objOpportunity.Id, userId);
              }
            }
            
            // If owner is changed, create share record
            if(trigger.isUpdate && objOpportunity.OwnerId != oldmap.get(objOpportunity.Id).OwnerId) { 
                    
                 if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                     
                     // create sharing record 
                     if(objOpportunity.AccountId != null) // Share Read access to Account record
                        mapOfAccountToCommunityUser.put(objOpportunity.AccountId,  userId);
                    // creat Opportunity share record
                    mapOfOpportunityIdToCommunityUserId.put(objOpportunity.Id, userId);
                }
                
                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mapOfOpportunityIdToCommunityUserId upd' + mapOfOpportunityIdToCommunityUserId );
            } 
            
            if(Trigger.isUpdate) {
                
                Id oldExternalContact, newExternalContact;
                
                oldExternalContact = oldmap.get(objOpportunity.Id).External_Referred_By__c;
                newExternalContact = objOpportunity.External_Referred_By__c;
                
                 //comparing  external Contact
                if(oldExternalContact != newExternalContact) {
                    
                    if(newExternalContact != null && mapContactIdToUserId.containskey(newExternalContact)  
                     && mapContactIdToUserId.get(newExternalContact) != objOpportunity.OwnerId
                     && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(newExternalContact))
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(newExternalContact)))) { 
                        
                         // create sharing record 
                        if(objOpportunity.AccountId != null) 
                            mapOfAccountToCommunityUser.put(objOpportunity.AccountId,  mapContactIdToUserId.get(newExternalContact));
                    
                        mapOfOpportunityIdToCommunityUserId.put(objOpportunity.Id, mapContactIdToUserId.get(newExternalContact));
                    }
                    
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mapOfOpportunityIdToCommunityUserId' + mapOfOpportunityIdToCommunityUserId);
                    
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mapOfAccountToCommunityUser' + mapOfAccountToCommunityUser);
                    
                    // delete if the contact user is not current owner or old owner then delete
                    
                     if( oldExternalContact != NULL && mapContactIdToUserId.containskey(oldExternalContact)
                        && mapContactIdToUserId.get(oldExternalContact) != objOpportunity.OwnerId
                        && mapContactIdToUserId.get(oldExternalContact) != oldmap.get(objOpportunity.Id).OwnerId
                        && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(oldExternalContact))
                        && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(oldExternalContact)))) {
                        
                        // add OpportunityId and old conatct  
                        mapOpportunityIdToOldContact.put(objOpportunity.Id, mapContactIdToUserId.get(oldExternalContact));
                        mapAccountIdToOldContact.put(objOpportunity.AccountId, mapContactIdToUserId.get(oldExternalContact));
                    }
                }
            }
        }   
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mapOpportunityIdToOldContact ' + mapOpportunityIdToOldContact.keyset());
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! mapOpportunityIdToOldContact ' + mapOpportunityIdToOldContact.values());
        
        // Execute if External contact is changed   
        for(OpportunityShare objsharing : [ SELECT  OpportunityID, UserOrGroupId
                                                    FROM OpportunityShare
                                                    WHERE OpportunityID IN : mapOpportunityIdToOldContact.keyset()
                                                    AND UserOrGroupId IN : mapOpportunityIdToOldContact.values()  ]) {
            
            lstSharingRecordsToDelete.add(objsharing);
            
        }
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!! lstSharingRecordsToDelete ' + lstSharingRecordsToDelete);
        
        // Execute if External contact is changed 
        for(AccountShare objAccountsharing : [ SELECT Id,AccountId,UserOrGroupId 
                                                              FROM AccountShare
                                                              WHERE AccountId IN : mapAccountIdToOldContact.keyset()
                                                              AND UserOrGroupId IN : mapAccountIdToOldContact.values()  ]) {
                                                            
              lstAccountSharingRecordsToDelete.add(objAccountsharing);
        }
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!! lstAccountREcordsToDelete ' + lstAccountSharingRecordsToDelete );
        
        
        if(!lstSharingRecordsToDelete.isEmpty())
            delete lstSharingRecordsToDelete;
            
        if(!lstAccountSharingRecordsToDelete.isEmpty())
            delete lstAccountSharingRecordsToDelete;
            
            
        if(!mapOfAccountToCommunityUser.isEmpty())
            UCreateAccountShareRecords.createAccountShareForCommunityUsers(mapOfAccountToCommunityUser);
        
        if(!mapOfOpportunityIdToCommunityUserId.isEmpty())
            UCreateAccountShareRecords.createOpportunityShareForCommunityUsers(mapOfOpportunityIdToCommunityUserId);
            
        ////////////////////////////////////////////////////////////////////
        // Collect contacts related to each Opporrtunity that is being proceesed
        /*for(Opportunity objNewOpportunity : lstNewOpportunities) {
            
            Opportunity objOldOpportunity ;
            
            if(!isinsert)
                objOldOpportunity = oldmap.get(objNewOpportunity.Id);
                 
            // On insert check if the "External Referred by" is populated or in case of update check if "External Referred by" ischanged and also if ownerId is changed
            if( isinsert && objNewOpportunity.External_Referred_By__c != null ||
              ( !isinsert && (objNewOpportunity.External_Referred_By__c != objOldOpportunity.External_Referred_By__c || objNewOpportunity.OwnerId != objOldOpportunity.OwnerId))) {
                
                if(objNewOpportunity.External_Referred_By__c != null) 
                    referredContactIds.add(objNewOpportunity.External_Referred_By__c);
                
                else if(oldmap != null && objOldOpportunity.External_Referred_By__c != null && objOldOpportunity.External_Referred_By__c != objOldOpportunity.OwnerId) { // Collect old contact only if the updated contact is null
                    
                    referredContactIds.add(objOldOpportunity.External_Referred_By__c);
                    setOldContactsToRevokeSharings.add(objOldOpportunity.Id);
                }
                setAccountIds.add(objNewOpportunity.AccountId);
            }
        }
        
        // Do not porceed id no contacts populated on Oppotunities
        if(referredContactIds.isEmpty()) return;

        // Collect community user associated with the contacts, can not share with inactive users
        for(User objCommunityUser : [ Select Id, ContactId from User where isActive = true and ContactId IN : referredContactIds]) {
            
            communityUsers.put(objCommunityUser.ContactId, objCommunityUser.Id);
        }
        
        // Do not porceed if no community user contacts are present on opportunity
        if(communityUsers.isEmpty()) return;
        
        // Collect Opportuniy Shares that have been created for old Contact via apex code
        for(OpportunityShare objOppShare : [ SELECT OpportunityID, UserOrGroupId
                                             FROM OpportunityShare
                                             WHERE OpportunityID IN : setOldContactsToRevokeSharings AND UserOrGroupId IN : communityUsers.values()]) {
                                        
            mapOppIdToShareForOldContacts.put(objOppShare.opportunityid + ' : ' +objOppShare.userorgroupid, objOppShare);
        }
        
        for( Account objAccount : [Select Id, Name, OwnerId From Account where Id IN  : setAccountIds ]) {
            
            mapAccountIdToOwner.put(objAccount.Id, objAccount.OwnerId);
        }
        
        // Iterate for each Opportunity and creat AccountSharing record and then the Opportunity share record
        // AccountSharing is required because if the community user does not have access to the Opportunity's.Account "Insuffient priviledges or cross object refernce Id" error is thrown
        for(Opportunity objOpportunity : lstNewOpportunities) {
            
            Opportunity objOldOpportunity ;
            
            if(!isinsert)
                objOldOpportunity = oldmap.get(objOpportunity.Id);
            
            // If the new conatct and/or the old contacts were not community contacts skip the iteration
            if(!communityUsers.containsKey(objOpportunity.External_Referred_By__c)
                && (!isInsert && objOpportunity.External_Referred_By__c == null && !communityUsers.containsKey(objOldOpportunity.External_Referred_By__c))) continue;
            
            if( !isInsert && objOldOpportunity.External_Referred_By__c != null && communityUsers.containskey(objOldOpportunity.External_Referred_By__c) 
                && mapOppIdToShareForOldContacts.containskey(objOpportunity.Id + ' : ' + communityUsers.get(objOldOpportunity.External_Referred_By__c))) {
                            
                    // If the OpportunityShare was created via trigger logic  then the OpportunityShare.userorgroupid is same as old community user
                    // Collect old Opportunity share and delete those
                    OpportunityShare objOldOppShare =  new OpportunityShare();
                    objOldOppShare = mapOppIdToShareForOldContacts.get(objOpportunity.Id + ' : ' +  communityUsers.get(objOldOpportunity.External_Referred_By__c));
                    
                    lstOpportunitySharesDelete.add(objOldOppShare);
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!! lstOpportunitySharesDelete' + lstOpportunitySharesDelete);
            }
            
            if(objOpportunity.External_Referred_By__c != null && communityUsers.containskey(objOpportunity.External_Referred_By__c)) { 
                
                if( IsInsert || (!isInsert && objOpportunity.External_Referred_By__c != objOldOpportunity.External_Referred_By__c )) {
                    
                    // create Account and Opportunity share records as logged in user
                    if( UserInfo.getUserId() != objOpportunity.OwnerId) {
                        
                        mapAccountIdToCommunityUserId.put(objOpportunity.AccountId, communityUsers.get(objOpportunity.External_Referred_By__c));
                        mapOpportunityIdToCommunityUserId.put(objOpportunity.Id, communityUsers.get(objOpportunity.External_Referred_By__c));
                    }
                    else { // Owner itself updating the record
                        
                        // Check if Account owner is not same as opportunity owner then create Account sharing
                        if(mapAccountIdToOwner.containskey(objOpportunity.AccountId) && mapAccountIdToOwner.get(objOpportunity.AccountId) != objOpportunity.OwnerId) {
                            
                            mapAccountIdToCommunityUserId.put(objOpportunity.AccountId, communityUsers.get(objOpportunity.External_Referred_By__c));
                        }
                        OpportunityShare objOppShare = new OpportunityShare( OpportunityId = objOpportunity.Id ,
                                                                             OpportunityAccessLevel = 'Read' ,
                                                                             UserOrGroupId =  communityUsers.get(objOpportunity.External_Referred_By__c));
                        lstOpportunitySharesToInsert.add(objOppShare);
                    }
                    
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! lstOpportunitySharesToInsert ' + lstOpportunitySharesToInsert);
                }
                // owner id changed in bulk
                if(!isInsert && objOpportunity.OwnerId != objOldOpportunity.OwnerId) { // owner is change
                    
                    if( UserInfo.getUserId() != objOpportunity.OwnerId) 
                        mapOpportunityIdToCommunityUserId.put(objOpportunity.Id, communityUsers.get(objOpportunity.External_Referred_By__c));
                }
            }
        }
        
        // Call a method to insert AccountShare records in without sharing context
        if(!mapAccountIdToCommunityUserId.isEmpty())
            UCreateAccountShareRecords.createAccountShareForCommunityUsers(mapAccountIdToCommunityUserId);
        
        // Call a method to insert OpportunityShare records in without sharing context
        if(!mapOpportunityIdToCommunityUserId.isEmpty())
            UCreateAccountShareRecords.createOpportunityShareForCommunityUsers(mapOpportunityIdToCommunityUserId);
        
        // Insert Opportunity share records
        if(!lstOpportunitySharesToInsert.isEmpty()) 
            insert lstOpportunitySharesToInsert; 
        
            
        // Delete the old Opportunity share records
        if(!lstOpportunitySharesDelete.isEmpty()) 
            delete lstOpportunitySharesDelete;*/
    }
}