@isTest (seeAllData = false)
private class UOnlineApplication_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        List<Profile> lstProfilePartner = [select id from profile where name='England Logistics Partners - F1']; 
        List<Profile> lstProfileSysAdmin = [select id from profile where name='System Administrator'];
        
        if(lstProfilePartner.isEmpty())
        	return;
        
        Account objAccountPartner = new Account (Name ='TestAccount-01' );
        
        insert objAccountPartner;
        
        objAccountPartner.IsPartner = true;
        update objAccountPartner;
         
        List<Contact> lstContact = new List<Contact>{new Contact (LastName = 'TestContact-01', AccountId = objAccountPartner.Id),
                                                      new Contact (LastName = 'TestContact -02', AccountId = objAccountPartner.Id),
                                                      new Contact (LastName = 'TestContact -03', AccountId = objAccountPartner.Id)
                                                      };
                                                                
       insert lstContact;
       
       List<User> lstUser = new List<User>();
       
       User objPartneruser1 =  newUser( lstProfilePartner[0].Id, 'Partner', 'User-01', 'test.partner1@example.com' );
	   objPartneruser1.contactId = lstContact[0].Id;
        
       User objPartneruser2 =  newUser( lstProfilePartner[0].Id, 'Partner', 'User-02', 'test.partner2@example.com' );
	   objPartneruser2.contactId = lstContact[1].Id;
       
       User objInternaluser =  newUser( lstProfileSysAdmin[0].Id, 'Partner', 'User-02', 'test.partner2@example.com' );
        
        lstUser.add(objInternaluser);                                                                                      
        lstUser.add(objPartneruser1);
        lstUser.add(objPartneruser2);                                                           
        insert lstUser;
        
        List<OnlineApplicationOffer__c> lstOnlineAppOffer = new List<OnlineApplicationOffer__c>();
      	List<OnlineApplication__c> lstOnlineApp = new List<OnlineApplication__c>();
         
        lstOnlineAppOffer.add(new OnlineApplicationOffer__c (Name = 'TestOffer-01',Application_Title__c = 'TestTitle', Complete_Later_Text__c = 'Test', EchoSign_User_Email__c = 'test@test.com',
                                                                                                                                Terms_and_Conditions_Version__c = 'TestVersion-01'
                                                                                                                                ));
		insert lstOnlineAppOffer;
        OnlineApplicationOffer__Share objOAOfferShare = new OnlineApplicationOffer__Share( ParentId = lstOnlineAppOffer[0].Id,
                                                                                                AccessLevel = 'Read' ,
                                                                                                UserOrGroupId =  objPartneruser1.Id);
                                                                                                insert objOAOfferShare;
    	OnlineApplication__c obj = new OnlineApplication__c (Offer__c = lstOnlineAppOffer[0].Id);
        insert obj;
        
        Set<Id> setIds = new Set<Id>();
		system.runAs(objPartneruser1) {
                                                                                                                                   
        	lstOnlineApp.add(new OnlineApplication__c (Status__c = 'Approved', Offer__c = lstOnlineAppOffer[0].Id, CreatedById = objPartneruser1.Id, ownerId=objPartneruser1.Id)); 
            lstOnlineApp.add(new OnlineApplication__c (Offer__c = lstOnlineAppOffer[0].Id, CreatedById = objPartneruser1.Id,ownerId=objPartneruser1.Id));
         	insert lstOnlineApp;
         	setIds.add(lstOnlineApp[0].Id);
         	setIds.add(lstOnlineApp[1].Id);
        } 
         
         List<OnlineApplication__c> lstOnlineAppl = [ Select Id, External_Referred_By_Contact__c, Referred_by_External_Account__c from OnlineApplication__c
         											  where Id IN : setIds];
         
         
         System.AssertEquals(lstOnlineAppl[0].External_Referred_By_Contact__c, lstContact[0].Id);
         System.AssertEquals(lstOnlineAppl[0].Referred_by_External_Account__c, lstContact[0].AccountId);
          
         lstOnlineApp[0].ownerid =  objInternaluser.Id;
         update lstOnlineApp; 
         
         lstOnlineApp[0].External_Referred_By_Contact__c =  lstContact[0].Id;
         update lstOnlineApp; 
         
         lstOnlineApp[0].External_Referred_By_Contact__c =  lstContact[1].Id;
         update lstOnlineApp;
        
        // Cover delete event trigger code  
        Exception dmlExceptionObj;
		try {
			
			delete lstOnlineApp[0];
		}
		catch(Exception ex) {
			
			dmlExceptionObj = ex;
		} 
		system.assert(dmlExceptionObj instanceOf system.Dmlexception);
		Test.stopTest(); 
    }
    
    private static User newUser( ID profileId, String firstName, String lastName, String email ) {
        Integer rand = Math.round( Math.random() * 1000 );
        return new User(
            isActive = true,
            profileId = profileId,
            alias = firstName.substring(0,1) + lastName.substring(1,5),
            firstName = firstName,
            lastName = lastName,
            email = email,
            username = rand + email,
            emailEncodingKey = 'UTF-8',
            languageLocaleKey = 'en_US',
            localeSidKey = 'en_US',
            timeZoneSidKey = 'America/Los_Angeles',
            country = 'United States'
        );
    }
    
}