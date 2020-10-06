/*
Description:        Test class for Opportunity Trigger
Revision History: 
*/
@isTest
public class OpportunityTriggerTest {

    public static void testFleetEnrollmentOpptyInfoOnInsert() {

        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test' LIMIT 1];
        System.debug('Account Id is: ' + acc.id);
        Campaign_Program__c campaignProgram = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram.Program__c);
        Contact billingContact = [SELECT Id, LastName FROM Contact WHERE LastName = 'McTesterson' LIMIT 1];

        Opportunity oppty = new Opportunity();
        oppty.Name = 'Test FE Creation Oppty';
        oppty.AccountId = acc.Id;
        system.debug('Related Account is: ' + oppty.AccountId);
        oppty.CloseDate = Date.today().addDays(30);
        oppty.StageName = '1) Qualified';
        oppty.Type = 'New Customer';
        oppty.CampaignId = campaignProgram.Campaign__c;
        system.debug('Related Campaign is : ' + oppty.CampaignId);
        oppty.Campaign_Program__c = campaignProgram.Id;
        system.debug('Related Campaign Program is : ' + oppty.Campaign_Program__c);
        oppty.Fueling_Methos__c = 'Bank Debit Card';
        oppty.Fleet_Size__c = 10;
        Oppty.Legal_Structure__c = 'Sole Proprietorship';
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
        oppty.Siebel_Opportunity__c = '1-5Y02BEZ';
        oppty.Billing_Street__c = '123 anywhere st';
        oppty.Billing_City__c = 'Nashville';
        oppty.Billing_State__c = 'TN';
        oppty.Billing_Zip_Postal_Code__c = '37214';
        oppty.Billing_Contact__c = billingContact.Id;

        Test.startTest();
        insert oppty;
        Test.stopTest();

        //Asserts for After Insert logic
        Opportunity oppty2 = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c, Billing_Contact__c FROM Opportunity WHERE Name = 'Test FE Creation Oppty' LIMIT 1];
        FleetEnrollment__c myFE = [SELECT Id, Opportunity__c, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c, RecordType.Name FROM FleetEnrollment__c WHERE Opportunity__c = :oppty2.Id];
        system.assertEquals(oppty2.Id, myFE.Opportunity__c);
        system.assertEquals(oppty2.Campaign_Program__r.Program__c, myFE.Program__c);
        system.assertEquals(oppty2.Campaign_Program__r.Program__c, myFE.Program_Template_Account__r.Program__c);
        system.assertEquals('Internal', myFE.RecordType.Name);

    }

    public static void testFleetEnrollmentOpptyInfoOnUpdate() {

        Opportunity oppty = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Name ='Test Oppty 10' LIMIT 1];
        FleetEnrollment__c fe = [SELECT Id, Name, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c FROM FleetEnrollment__c WHERE Opportunity__c =: oppty.Id];
        Campaign_Program__c campaignProgram = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram.Program__c);
        Campaign_Program__c campaignProgram2 = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test 3' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram2.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram2.Program__c);

        //Update Oppty, check that FleetEnrollment Record updates
        oppty.Campaign_Program__c = campaignProgram2.Id;

        Test.startTest();
        update oppty;
        Test.stopTest();

        //Asserts for Before Update logic
        Opportunity oppty2 = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Name ='Test Oppty 10' LIMIT 1];
        FleetEnrollment__c FE2 = [SELECT Id, Opportunity__c, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c, RecordType.Name FROM FleetEnrollment__c WHERE Opportunity__c =:oppty2.Id];
        system.assertNotEquals(FE.Program__c, FE2.Program__c);
        system.assertEquals(FE2.Program__c, Oppty2.Campaign_Program__r.Program__c);

    }

    public static void testOpportunityInsert(){
        /*
        BI needs:
            getStageId
                record with stagename
                    assert stageid matches stagename.id
            findCampaignByCouponCode
                Default_Campaigns__c records
                Campaign with matching coupon code
                    assert campaign and campaign program
                    will need three: one with user id, one with user profile, one with neither
            communityUserStampData
                non community user w/ contact and account parents
                    assert external referred by fields
        AI needs:
            createCommission
                OppRecordTypeForComm__c custom setting
                    assert commission is created
            communityCheckSharing
                oppty change External_Referred_By__c
                    assert things created
            createTasks
                oppty with coupon code
            updateProgramAccount
         */
        Id cid = [SELECT Id FROM Campaign WHERE Name = 'Test 5' LIMIT 1].Id;
        Opportunity o1 = [SELECT Id, StageName, Name, CloseDate, CampaignId, AccountId, Campaign_Program__c,Campaign_Program__r.Program__c,Campaign_Program__r.Name FROM Opportunity WHERE Name = 'Test Oppty' LIMIT 1];
        Opportunity o2 = o1.clone(false,false,false,false); //getstageid, bi
        Opportunity o3 = o1.clone(false,false,false,false); //findCampaignByCouponCode, bi; will need campaignid already populated; assert no change
        Opportunity o4 = o1.clone(false,false,false,false); //findCampaignByCouponCode, bi; will need default campaign cs with user profile; assert changes
        Opportunity o5 = o1.clone(false,false,false,false); //createTasks, ai; need oppty w/ Coupon_code2__c matching metadata; assert task created & outbound message sent
        Opportunity o6 = o1.clone(false,false,false,false); //updateProgramAccount, ai; account doesn't have program
        Opportunity o7 = o1.clone(false,false,false,false); //updateProgramAccount, ai; account doesn't match program; cps account, is program account, has parent
        /*
        //these will need their own test methods as they will run as different users
        Opportunity o1 = o1.clone(false,false,false,false); //communityUserStampData, bi; will need to run as user with contactid and accountid; assert field updates
        Opportunity o2 = o1.clone(false,false,false,false); //communityUserStampData, bi; will need to run as partnercommunityuser; assert no field updates
        Opportunity o3 = o1.clone(false,false,false,false); //communityUserStampData, bi; will need to run as user without contactid; assert no field updates
        Opportunity o4 = o1.clone(false,false,false,false); //communityUserStampData, bi; will need to run as user without accountid; assert no field updates
        Opportunity o5 = o1.clone(false,false,false,false); //createCommission, ai; will need to run as user with guest type and need specific record type; assert no commission created
        Opportunity o6 = o1.clone(false,false,false,false); //findCampaignByCouponCode, bi; will need default campaign cs with user id; assert changes...maybe?
        Opportunity o7 = o1.clone(false,false,false,false); //createCommission, ai; will need specific record type and owner not guest type; assert commission created
        Opportunity o8 = o1.clone(false,false,false,false); //communityCheckSharing, ai; will need createdby and ownerid different; createdby partner user, prob. some stuff with account; assert account & oppty share records created
        */

        //o2 will test getStageId in before insert
        String stageName = '2) Engaged';
        o2.StageName = stageName;

        //o3 will test findCampaignByCouponCode in before insert...no change to campaignid
        Id o3InitCampaignId = o3.CampaignId;
        
        //o4 will test findCampaignByCouponCode in before insert. null campaignid
        o4.CampaignId = null;

        List<Campaign_Program__c> campPrograms = [SELECT Id, Name FROM Campaign_Program__c];
        System.Debug('*** Number of Campaign Programs ***: ' + campPrograms.size());
        string s = '';
        for (Campaign_Program__c cp : campPrograms) s += '\n' + cp;
        System.Debug(s);
        
        //o5 will test createTasks in after insert
        Id cpid = [SELECT Id FROM Campaign_Program__c WHERE Name = 'Test 6' LIMIT 1].Id;
        o5.CampaignId = cid;
        o5.Campaign_Program__c = cpid;
        o5.Error_Log__c = 'Success';

        //o6 will test updateProgramAccount in after insert
        Id aid = [SELECT Id FROM Account WHERE Name = 'Test 3' LIMIT 1].Id;
        o6.AccountId = aid;
        
        //o7 will test updateProgramAccount in after insert; account program won't match oppty program
        Id o7InitAccount = [SELECT Id FROM Account WHERE Name = 'Test 3' LIMIT 1].Id;
        o7.AccountId = o7InitAccount;
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.Class, new Test_i2iHttpCallOutMock());
        insert new List<Opportunity>{o2,o3,o4,o5,o6,o7};
        Test.stopTest();

        //getStageId in before insert should update the sales stage id
        stageName = stageName.toLowerCase();
        Id stageId = [SELECT Id, Masterlabel FROM OpportunityStage WHERE Masterlabel = :stageName LIMIT 1].Id;
        o2 = [SELECT Sales_Stage_Id__c FROM Opportunity WHERE Id = :o2.Id LIMIT 1];
        system.assertEquals(stageId, o2.Sales_Stage_Id__c, 'Oh no! The sales stage id does not match the stage id!');

        //findCampaignByCouponCode in before insert should not change as campaign was already set
        Id o3FinalCampId = [SELECT CampaignId FROM Opportunity WHERE Id = :o3.Id LIMIT 1].CampaignId;
        system.assertEquals(o3InitCampaignId, o3FinalCampId, 'Oh no! The campaign id changed unexpectedly!');

        //findCampaignByCouponCode in before insert should find campaign based on coupon code
        Campaign c4 = [SELECT Id, Default_Campaign_Program__c FROM Campaign WHERE Coupon_Code__c = 'UB40' LIMIT 1];
        o4 = [SELECT CampaignId, Campaign_Program__c FROM Opportunity WHERE Id = :o4.Id LIMIT 1];
        system.assertEquals(c4.Id, o4.CampaignId, 'Oh no! The campaign did not set as expected.');
        system.assertEquals(c4.Default_Campaign_Program__c, o4.Campaign_Program__c, 'Hey! The campaign program is not right!');

        //createTasks in after insert will create a task for the oppty
        List<Task> o5T = [SELECT Id, Subject FROM Task WHERE WhatId = :o5.Id];
        system.assertEquals(1, o5T.size(), 'Oh man it did not create the correct number of tasks!');
        system.assertEquals('Set Up Account', o5T[0].Subject, 'Hey! The subject does not match!');

        //updateProgramAccount in after insert will match account program to oppty program
        o6 = [SELECT Id, Campaign_Program__r.Program__c, Account.Program__c FROM Opportunity WHERE Id = :o6.Id LIMIT 1];
        system.assertEquals(o6.Campaign_Program__r.Program__c, o6.Account.Program__c, 'Whoops! The account program does not match the oppty one.');

        //updateProgramAccount in after insert will do a bunch of stuff. all we care about is that the accountid changes.
        //TODO: assert things correctly after trigger is made legible
        o7 = [SELECT Id, AccountId FROM Opportunity WHERE Id = :o7.Id LIMIT 1];
        system.assertNotEquals(o7InitAccount, o7.AccountId, 'The account stayed the same. Lame!');

    }

    public static void testOpportunityUpdate(){
        /*
        BU needs:
            getStageId
            echoBefore
            setContactRoles
            checkProgramAccount
            executeBreeze
        AU needs:
            echoAfter
            createCommission
            communityCheckSharing
            createTasks
         */
    }

    public static void testOpportunityDelete(){
        Opportunity o = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        delete o;
        Test.stopTest();

        Deleted_Records_Stage__c drs = [SELECT Id, Record_Type__c, Delete_Initiated_By__c, Delete_Source__c FROM Deleted_Records_Stage__c WHERE Record_ID__c = :o.Id LIMIT 1];
        system.assertEquals('Opportunity', drs.Record_Type__c, 'Hey! That is the wrong object type!');
        system.assertEquals('i2i', drs.Delete_Initiated_By__c, 'Whoa that should be i2i!');
        system.assertEquals('Manual', drs.Delete_Source__c, 'That should be manual. Why is it not?');
    }
}