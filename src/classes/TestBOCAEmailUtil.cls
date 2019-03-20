@isTest
public class TestBOCAEmailUtil{


    @testSetup public static void setupData(){
        
        BOCA_IDS__C bi = BOCAtestDataUtility.getBOCAids();
        insert bi;
        
        
        Campaign camp = BOCAtestDataUtility.getCampaign();
        Program__c testP = BOCAtestDataUtility.getProgram();
        Campaign_Program__c cp = BOCAtestDataUtility.getCP();
        Campaign_Pricing__c pric = BOCAtestDataUtility.getPricing();
        
        Contact ct = new Contact();
        
        ct.FirstName = 'Tester';
        ct.LastName = 'Tester Last';
        ct.Email = 'Tester@UnitTest.com';
        insert ct;
       
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');
        
        insert u;

        WeFormObject__c we = new WeFormObject__c();
        we.First_Name__c = 'Tester';
        we.Last_Name__c = 'TesterLast';
        we.status__c = 'test';
        we.Email__c = 'TesterWe@UnitTest.com';
        we.Program__c = testP.Id;

      //  insert we;

        Opportunity opp = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2015,11,11),stagename='1) Qualified', fleet_size__c = 10, ownerId = u.id, sourcesystem__c = 'test');
        opp.Fueling_Methos__c = 'BP';

        
        insert opp;
        SYSTEM.debug('opp ' + opp.OwnerId);
        
        OpportunityContactRole oppCon = new OpportunityContactRole(contactId = ct.id, isPrimary = true, OpportunityId = opp.id);
        
        insert oppCon;
                  
        Task mTask = new Task(subject= 'testTask');
        mTask.WhatId = opp.id;

        
        insert mTask;
        //we.Opportunity__c = opp.id;
        
        upsert we;
        
        testP.BOCA_Sell_Sheet__c = 'http://www.google.com';
        
        upsert testP;
    }
    
    @isTest public static void testInternalUserPage(){
        
        test.startTest();
        TestUtils.enable_isRunningTest = true;
        // This code runs as the system user
        Contact c = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = 'Tester@UnitTest.com'];
        WeFormObject__c we = [SELECT First_Name__c, Email__c, status__c, ID FROM WeFormObject__c WHERE First_Name__c = 'Tester'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@wexinc.com');
        
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
        }

               
        Opportunity opp = [SELECT Id, ownerId, sourcesystem__c, Program_Name__c, Name FROM Opportunity WHERE Name = 'TestOpp'];
        Apexpages.StandardController stdCont = new ApexPages.StandardController(opp);
        BOCAemailUtility bCont = new BOCAemailUtility(stdCont);
        
        PageReference testPage = new PageReference('apex/URLgen');
        //test Strings
        List<String> sellS = new List<String>{'test','test2','test3'};
        List<String> urls = new List<String>{'test','test2','test3'};
        List<String> name = new List<String>{'test','test2','test3'};

        test.setCurrentPage(testPage);
        
        URLgenAttachmentLookupController ugalc = new URLgenAttachmentLookupController();
        System.assert(ugalc.folders != null);
        ugalc.displayDocuments();
        
        //Test method with 5 params
        String message = BOCAemailUtility.sendEmail(c.Id, u.Name, true, we.Id, opp.Id, '', null);
        SYSTEM.assertEquals('Messaging.SendEmailResult[getErrors=();isSuccess=true;]', message, 'assert');
        //test overloaded method with 7 params 
        String message2 = BOCAemailUtility.sendEmailMulti(c.Id, u.Name, sellS, urls, name, true, we.Id, opp.Id);
        SYSTEM.assertEquals('Messaging.SendEmailResult[getErrors=();isSuccess=true;]', message2, 'assert');
        test.stopTest();
    
    }
    
    @isTest public static void testButtonSubmissionWithOpp(){
        
        test.startTest();
        TestUtils.enable_isRunningTest = true;
        // This code runs as the system user
        Contact c = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = 'Tester@UnitTest.com'];
        WeFormObject__c we = [SELECT First_Name__c, Email__c, status__c, ID FROM WeFormObject__c WHERE First_Name__c = 'Tester'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@wexinc.com');
        
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
        }
        
        Opportunity opp = [SELECT Id, ownerId, sourcesystem__c, Program_Name__c, Name FROM Opportunity WHERE Name = 'TestOpp'];

        Apexpages.StandardController stdCont = new ApexPages.StandardController(opp);
        BOCAemailUtility bCont = new BOCAemailUtility(stdCont);
        PageReference testPage = new PageReference('apex/URLgen');

        List<String> sellS = new List<String>{'test','test2','test3'};
        List<String> urls = new List<String>{'test','test2','test3'};
        List<String> name = new List<String>{'test','test2','test3'};
        
        
        test.setCurrentPage(testPage);
        
        String message = BOCAemailUtility.sendEmail(c.Id, u.Name, true, we.Id, '', '', null);
        SYSTEM.assertEquals('Messaging.SendEmailResult[getErrors=();isSuccess=true;]', message, 'assert');
        
        String message2 = BOCAemailUtility.sendEmailMulti(c.Id, u.Name, sellS, urls, name, true, we.Id, opp.id);
        SYSTEM.assertEquals('Messaging.SendEmailResult[getErrors=();isSuccess=true;]', message2, 'assert');
        
        test.stopTest();
 
    }
    
    @isTest public static void testBOCAReminder() {
        
        test.startTest();
        TestUtils.enable_isRunningTest = true;
        // This code runs as the system user
        Contact c = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'Tester@UnitTest.com'];
        WeFormObject__c we = [SELECT Program__c, First_Name__c, Email__c, status__c, ID FROM WeFormObject__c WHERE First_Name__c = 'Tester'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@wexinc.com');
        
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
        }

        Opportunity opp = [SELECT Id, ownerId, sourcesystem__c, Program_Name__c, Name FROM Opportunity WHERE Name = 'TestOpp'];
        
        BOCA_To_Prospect__c bocaToProspect = new BOCA_To_Prospect__c();
		bocaToProspect.Opportunity__c = opp.Id;
        bocaToProspect.WeFormObject__c = we.Id;
        bocaToProspect.Contact__c = c.Id;
        bocaToProspect.Sent__c = Date.today();
                
       	insert bocaToProspect;
        
        PageReference bocaReminder = Page.BOCAReminder;
        bocaReminder.getParameters().put('id', bocaToProspect.Id);
        
        Apexpages.StandardController stdCont = new ApexPages.StandardController(bocaToProspect);
        BOCAemailUtility beu = new BOCAemailUtility(stdCont);
        
        Test.setCurrentPage(bocaReminder);
        
        System.assert(beu.weFormObject != null);
        
        beu.reminderMessage = 'Just reminding you!';
        
        beu.sendReminder();
        
        System.assert(beu.messageSent == true);
        
        ProgramEmailAssetController peac = new ProgramEmailAssetController();
        peac.programId = we.Program__c;
        
        System.assert(peac.brandingLogo != null);
        System.assert(peac.brandingCard != null);
        
        PageReference bocaTracking = Page.BOCAtoProspectTracking;
        bocaTracking.getParameters().put('customer', we.Id);
        bocaTracking.getParameters().put('action', 'learnmore');
        
        BOCAtoProspectTrackingController bptc = new BOCAtoProspectTrackingController();
        
        Test.setCurrentPage(bocaTracking);
        
        System.assert(bptc.weFormId != null);
        System.assert(bptc.action != null);
        
        PageReference redirect = bptc.logVisit();
        
        System.assert(redirect != null);
        
        test.stopTest();
        
    }
    
}