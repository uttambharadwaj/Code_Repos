@isTest
private class UOpportunityShareTest {


	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}

    static testMethod void test_UOpportunityShare() {
    	
    	List<Opportunity> lstOpportunitiesToInsert = new List<Opportunity>();
    	List<Opportunity> lstOpportunitiesToUpdate = new List<Opportunity>();
    	List<User> lstUsersToInsert = new List<User>();
    	
    	// Creating normal users
    	User objTestUser1 = new User();
    	User objTestUser2 =  new User();
    	
    	User objTestCommunityUser1 = new User();
    	User objTestCommunityUser2 = new User();
    	
    	List<Account> accounts = UTestData.getAccounts(1);	 
    	
    	insert accounts;
    	
    	List<Contact> lstContactsTest1 = UTestData.getContacts(accounts);
    	
    	insert lstContactsTest1;
    	
        
    	if(UTestData.getProfileId('Standard User') != '') {
    		
    		objTestUser1 = UTestData.getUserRecord(UTestData.getProfileId('Standard User'));
    		objTestUser2 = UTestData.getUserRecord(UTestData.getProfileId('Standard User'));
    		lstUsersToInsert.add(objTestUser1);
    		lstUsersToInsert.add(objTestUser2);
    	}
    	
    	// Creating community users
    	 if(UTestData.getCommunityUser() != null) {
    		
    		objTestCommunityUser1 = UTestData.getCommunityUser();
    		lstUsersToInsert.add(objTestCommunityUser1); 
    	 }
    	 if(UTestData.getCommunityUser() != null) {
    		
    		objTestCommunityUser2 = UTestData.getCommunityUser();
    		lstUsersToInsert.add(objTestCommunityUser2);
    	 }
    	 
    	 insert lstUsersToInsert;
    	
    	// blank External Referred by field
    	List<Opportunity> lstOpportunityBlank = UTestData.getOpportunities(accounts);
    	lstOpportunitiesToInsert.add(lstOpportunityBlank[0]);
    	
    	// Opportunity with normal user
    	List<Opportunity> lstOpportunityUser = UTestData.getOpportunities(accounts);
		lstOpportunityUser[0].External_Referred_By__c = lstContactsTest1[0].Id;
		lstOpportunitiesToInsert.add(lstOpportunityUser[0]);
		
		List<Opportunity> lstOpportunitywithCommunityUser = new List<Opportunity>();
		List<Opportunity> lstOpportunitywithCommunityUser2 = new List<Opportunity>();
		
		if(objTestCommunityUser1 != null) {
			
			// Opportunity with community user, opportunity owner and account owner are same
			lstOpportunitywithCommunityUser = UTestData.getOpportunities(accounts);
			lstOpportunitywithCommunityUser[0].External_Referred_By__c = objTestCommunityUser1.ContactId;
			lstOpportunitiesToInsert.add(lstOpportunitywithCommunityUser[0]);
			
		}
		
		if(objTestCommunityUser1 != null) {
		
			// Opportunity with community user, opportunity owner and account owner are different
			lstOpportunitywithCommunityUser2 = UTestData.getOpportunities(accounts);
			lstOpportunitywithCommunityUser[0].External_Referred_By__c = objTestCommunityUser1.ContactId;
			lstOpportunitiesToInsert.add(lstOpportunitywithCommunityUser2[0]);
		}
		
		if(!lstOpportunitiesToInsert.isEmpty())
			insert lstOpportunitiesToInsert;
		
		// Update use cases, different community users
		system.runAs(new User(Id = objTestUser1.Id)){  
			
			if(objTestCommunityUser1 != null) {
			
				lstOpportunitywithCommunityUser[0].External_Referred_By__c = objTestCommunityUser1.ContactId;
				//lstOpportunitiesToUpdate.add(lstOpportunitywithCommunityUser[0]);
			}
			lstOpportunitywithCommunityUser2[0].OwnerId = objTestUser2.Id;
			lstOpportunitiesToUpdate.add(lstOpportunitywithCommunityUser2[0]);
		}
		
		if(objTestCommunityUser2 != null) {
			
			lstOpportunitywithCommunityUser[0].External_Referred_By__c = objTestCommunityUser2.ContactId;
			lstOpportunitiesToUpdate.add(lstOpportunitywithCommunityUser[0]);
		}
		update lstOpportunitiesToUpdate;
    }
}