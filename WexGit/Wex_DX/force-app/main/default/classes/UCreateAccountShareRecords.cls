/**
    ClassName      :   UCreateAccountShareRecords
    
    Case Number    :   00022193
    
    Description    :   Insert AccountShare/OpportunityShare records, called from UOpportunityShare trigger handler
                       Class is built as Without sharing since the logged in user who executes the code does not have permission to share the record
    
    Modified Date  : 24/08/2015
*/
public without sharing class UCreateAccountShareRecords {
    
    // Insert AccountSharing records and allow access to the community user
    public static void createAccountShareForCommunityUsers(Map<Id, Id> mapAccountIdToCommunityUserId) {
        
        List<AccountShare> lstAccountShareToBeInserted = new List<AccountShare>();
        Map<Id, Id> mapAccountIdToOwnerId = new Map<Id,Id>();
        
        for(Account objAccount :  [Select Id, OwnerId from Account where ID IN : mapAccountIdToCommunityUserId.keyset()] ) {
        	
        	mapAccountIdToOwnerId.put(objAccount.Id, objAccount.OwnerId);
        }
        
        for(Id accountId : mapAccountIdToCommunityUserId.Keyset()) {
            
            Id  communityUserId = mapAccountIdToCommunityUserId.get(accountId);
            
            // Create Account sharing record only if the user is not the Account owner
	       if(mapAccountIdToOwnerId.containskey(accountId) && mapAccountIdToOwnerId.get(accountId) != communityUserId) {
	            // Create account sharing rule
	            AccountShare accountShare = new AccountShare( AccountId = accountId , 
	                                                          UserOrGroupId = communityUserId,
	                                                          AccountAccessLevel = 'Read',
	                                                          ContactAccessLevel = 'None',
	                                                          OpportunityAccessLevel = 'None'); 
	            
	            lstAccountShareToBeInserted.add(accountShare);
	        }
        }
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!! lstAccountShareToBeInserted ' + lstAccountShareToBeInserted);
        // Insert Account share records
        if(!lstAccountShareToBeInserted.isEmpty()){
            insert lstAccountShareToBeInserted; 
        } 
    }
    
    // Insert OpportunitySharing records and allow access to the community user
    public static void createOpportunityShareForCommunityUsers(Map<Id, Id> mapOpportunityIdToCommunityUserId) {
        
        List<OpportunityShare> lstOpportunitySharesToInsert = new List<OpportunityShare>();
         
        for(Id opportunityId : mapOpportunityIdToCommunityUserId.Keyset()) {
            
            Id  communityUserId = mapOpportunityIdToCommunityUserId.get(opportunityId);
            
            OpportunityShare objOppShare = new OpportunityShare( OpportunityId = opportunityId,
                                                                 OpportunityAccessLevel = 'Read' ,
                                                                 UserOrGroupId =  communityUserId);
            lstOpportunitySharesToInsert.add(objOppShare);
        }
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!! lstOpportunitySharesToInsert method ' + lstOpportunitySharesToInsert);
        // Insert Opportunity share records
        if(!lstOpportunitySharesToInsert.isEmpty()) 
            insert lstOpportunitySharesToInsert; 
    }
    
    
    // Insert OnlineApplicationShare records and allow access to the community user
    public static void createOnlineApplicationOfferShareForCommunityUsers(Map<Id, Id> mapOnlineApplicationOfferIdToCommunityUserId) {
        
        List<OnlineApplicationOffer__Share> lstOnlineApplicationSharesToInsert = new List<OnlineApplicationOffer__Share>();
        Map<Id, Id> mapOnlineAppIdToOwnerId = new Map<Id,Id>();
        
        for(OnlineApplicationOffer__c objOAOffer :  [Select Id, OwnerId from OnlineApplicationOffer__c where ID IN : mapOnlineApplicationOfferIdToCommunityUserId.keyset()] ) {
        	
        	mapOnlineAppIdToOwnerId.put(objOAOffer.Id, objOAOffer.OwnerId);
        }
        
        
        for(Id onlineAppOfferId : mapOnlineApplicationOfferIdToCommunityUserId.Keyset()) {
            
            Id  partnerCommunityUserId = mapOnlineApplicationOfferIdToCommunityUserId.get(onlineAppOfferId);
            
             if(mapOnlineAppIdToOwnerId.containskey(onlineAppOfferId) && mapOnlineAppIdToOwnerId.get(onlineAppOfferId) != partnerCommunityUserId) {
	             
	             OnlineApplicationOffer__Share objOAOfferShare = new OnlineApplicationOffer__Share( ParentId = onlineAppOfferId,
	                                                                                                AccessLevel = 'Read' ,
	                                                                                                UserOrGroupId =  partnerCommunityUserId);
	            lstOnlineApplicationSharesToInsert.add(objOAOfferShare);
             }
        }
          
        // Insert Opportunity share records 
        if(!lstOnlineApplicationSharesToInsert.isEmpty()) 
            insert lstOnlineApplicationSharesToInsert;   
    }
    
    // Insert OnlineApplicationShare records and allow access to the community user
    public static void createOnlineApplicationForCommunityUsers(Map<Id, Id> mapOnlineApplicationIdToCommunityUserId) {
        
        List<OnlineApplication__Share> lstOnlineApplicationSharesToInsert = new List<OnlineApplication__Share>();
        
        for(Id onlineAppId : mapOnlineApplicationIdToCommunityUserId.Keyset()) {
            
            Id  communityUserId = mapOnlineApplicationIdToCommunityUserId.get(onlineAppId);
            OnlineApplication__c obj = new OnlineApplication__c(Id= onlineAppId);
           Id owdId =  [select Id, OwnerId from OnlineApplication__c where Id =: onlineAppId ].ownerId;
            
            OnlineApplication__Share objOnlineAppShare = new OnlineApplication__Share( ParentId = onlineAppId,
                                                                                       AccessLevel = 'Read' ,
                                                                                       UserOrGroupId =  communityUserId );
            lstOnlineApplicationSharesToInsert.add(objOnlineAppShare);
        }
        
        // Insert Opportunity share records 
        if(!lstOnlineApplicationSharesToInsert.isEmpty()) 
            insert lstOnlineApplicationSharesToInsert; 
    } 
}