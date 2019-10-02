@isTest
private class UAccountTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @isTest
    static void test_assign_account_members() {

        Profile p = [ SELECT id FROM Profile WHERE name = 'Standard User' ];

        UserRole ur = [ SELECT id FROM UserRole WHERE developerName = 'Admin' ];

        User user1, user2;

        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_tools_runas.htm
        System.runAs( new User( id = UserInfo.getUserId() ) ) {

            user1 = newUser( p.id, ur.id, 'Alpha', 'User 1', 'user_1@example.com' );
            user2 = newUser( p.id, ur.id, 'Beta', 'User 2', 'user_2@example.com' );

            insert new List<User>{ user1, user2 };

        }

        Test.startTest();

        Account acct = new Account(
            ownerId = user1.id,
            name = 'Salesforce'
        );

        System.debug( acct );

        insert acct;

        // owner becomes member on insert
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user1.id ] );
        System.assertEquals( 0, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user2.id ] );

        acct.ownerId = user2.id;
        update acct;

        // new owner becomes member
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user1.id ] );
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user2.id ] );

        acct.ownerId = user1.id;
        update acct;

        // changing to new owner makes no difference because already a member
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user1.id ] );
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user2.id ] );

        Test.stopTest();

    }

    @isTest
    static void test_inactive_owners() {

        Profile p = [ SELECT id FROM Profile WHERE name = 'Standard User' ];

        UserRole ur = [ SELECT id FROM UserRole WHERE developerName = 'Admin' ];

        User user1, user2;

        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_tools_runas.htm
        System.runAs( new User( id = UserInfo.getUserId() ) ) {

            user1 = newUser( p.id, ur.id, 'Alpha', 'User 1', 'user_1@example.com' );
            user2 = newUser( p.id, ur.id, 'Beta', 'User 2', 'user_2@example.com' );
            user2.isActive = false;

            insert new List<User>{ user1, user2 };

        }

        Test.startTest();

        Account acct = new Account(
            ownerId = user1.id,
            name = 'Salesforce'
        );

        System.debug( acct );

        insert acct;

        // owner becomes member on insert
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user1.id ] );
        System.assertEquals( 0, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user2.id ] );

        acct.ownerId = user2.id;
        update acct;

        // don't add inactive owner as team member
        System.assertEquals( 1, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user1.id ] );
        System.assertEquals( 0, [ SELECT count() FROM AccountTeamMember WHERE accountId = :acct.id AND userId = :user2.id ] );

        Test.stopTest();

    }

    private static User newUser( ID profileId, ID userRoleId, String firstName, String lastName, String email ) {
        Integer rand = Math.round( Math.random() * 1000 );
        return new User(
            isActive = true,
            profileId = profileId,
            userRoleId = userRoleId,
            alias = firstName.substring(0,1) + lastName.substring(1,5),
            firstName = firstName,
            lastName = lastName,
            email = email,
            username = rand + email,
            emailEncodingKey = 'UTF-8',
            languageLocaleKey = 'en_US',
            localeSidKey = 'en_US',
            timeZoneSidKey = 'America/Chicago'
        );
    }

    @isTest 
    static void test_Truckers_Account()
    {
       
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Truckers - Accounts').getRecordTypeId();

        GlobalSettings__c setting = new GlobalSettings__c(Name='ForTesting', Truckers_Account_Record_Type__c=rtId);
        insert setting;
        
        Account acct = new Account
        (
            Name = 'Salesforce',
            Status__c = 'Member',
            recordtypeid=rtId
        );
        insert acct;

        delete acct;

    }
    
    static testmethod void testParentSalesAccounts() {
        Id cpsRecTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('CPS_Accounts').getRecordTypeId();

        Partner__c part1 = new Partner__c(Name = 'partner1');
        insert part1;

        Partner__c part2 = new Partner__c(Name = 'partner2');
        insert part2;

        Program__c program1 = new Program__c();
        program1.Name = 'test prog1' ;
        program1.Brand_Short_Name__c = 'test1';
        program1.Partner__c = part1.Id;

        insert program1;

        Program__c program2 = new Program__c();
        program2.Name = 'test prog2' ;
        program2.Brand_Short_Name__c = 'test2';
        program2.Partner__c = part2.Id;

        insert program2;

        Campaign campaign = new Campaign();
        campaign.Coupon_Code__c = 'TEST1';
        campaign.Name = 'TestCampaign';
        campaign.Type = 'Online Form';
        campaign.Status = 'In Progress';
        campaign.Drop_Date__c = date.today();
        campaign.EndDate = date.today();
        campaign.CurrencyIsoCode = 'USD';
        campaign.IsActive = true;

        insert campaign;        

        Campaign_Program__c campaignProgram1 = new Campaign_Program__c();
        campaignProgram1.Name = 'test campaign program1';
        campaignProgram1.Campaign__c = campaign.Id;
        campaignProgram1.Program__c = program1.Id;
        campaignProgram1.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram1.Default__c = true;

        insert campaignProgram1;

        Campaign_Program__c campaignProgram2 = new Campaign_Program__c();
        campaignProgram2.Name = 'test campaign program2';
        campaignProgram2.Campaign__c = campaign.Id;
        campaignProgram2.Program__c = program2.Id;
        campaignProgram2.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram2.Default__c = true;

        insert campaignProgram2;

        Account parentAcc1 = new Account(
            Name = 'A - Parent Account1',
            RecordTypeId = cpsRecTypeId,
            DUNS__c = '123456'
        );

        Account parentAcc2 = new Account(
            Name = 'B - Test Account',
            RecordTypeId = cpsRecTypeId,
            Phone = '111-222-4444'
        );

        Account parentAcc3 = new Account(
            Name = 'C - Test Account',
            RecordTypeId = cpsRecTypeId,
            Phone = '111-222-3333'
        );

        insert new List<Account> {parentAcc1,parentAcc2,parentAcc3};

        Account acct1 = new Account(
            Name = 'A - Duns Test',
            RecordTypeId = cpsRecTypeId,
            DUNS__c = '123456'
        );

        Account acct2 = new Account(
            Name = 'B - Test Account',
            Phone = '111-222-4444',
            RecordTypeId = cpsRecTypeId
        );

        Account acct3 = new Account(
            Name = 'C - Test Account',
            RecordTypeId = cpsRecTypeId,
            Phone = '111-222-3333'
        );

        Account acct4 = new Account(
            Name = 'D - Some Acct',
            RecordTypeId = cpsRecTypeId
        );

        insert new List<Account> {acct1,acct2,acct3,acct4};

        Opportunity oppty1 = new Opportunity(
            name = 'Test Opportunity',
            accountId = acct1.id,
            closeDate = Date.today(),
            amount = 100,
            stageName = '5) Signed',
            campaignId = campaign.id,
            Campaign_Program__c = campaignProgram1.Id
        );

        Opportunity oppty2 = new Opportunity(
            name = 'Test Opportunity',
            accountId = acct2.id,
            closeDate = Date.today(),
            amount = 100,
            stageName = '5) Signed',
            campaignId = campaign.id,
            Campaign_Program__c = campaignProgram2.Id
        );

       Opportunity oppty3 = new Opportunity(
            name = 'Test Opportunity',
            accountId = acct3.id,
            closeDate = Date.today(),
            amount = 100,
            stageName = '5) Signed',
            campaignId = campaign.id,
            Campaign_Program__c = campaignProgram1.Id
        );

       Opportunity oppty4 = new Opportunity(
            name = 'Test Opportunity',
            accountId = acct4.id,
            closeDate = Date.today(),
            amount = 100,
            stageName = '5) Signed',
            campaignId = campaign.id,
            Campaign_Program__c = campaignProgram2.Id
        );


        Test.startTest();
        insert new List<Opportunity> {oppty1,oppty2,oppty3,oppty4};
        Test.stopTest();

        List<Account> parentAcctList = [SELECT Id, Is_Program_Account__c FROM Account WHERE Program__c=null ORDER BY Name ASC];
        System.assertEquals(4, parentAcctList.size());
        System.assertEquals(false, parentAcctList[3].Is_Program_Account__c);

        List<Account> childAcctList = [SELECT Id, Partner_Name__c, ParentId FROM Account WHERE Program__c!=null ORDER BY Name ASC];
        System.assertEquals(4, childAcctList.size());
        System.assertEquals(parentAcc1.Id, childAcctList[0].ParentId);
        System.assertEquals(parentAcc2.Id, childAcctList[1].ParentId);
        System.assertEquals(parentAcc3.Id, childAcctList[2].ParentId);
        System.assertEquals(parentAcctList[3].Id, childAcctList[3].ParentId);
        System.assertEquals(part2.Id, childAcctList[3].Partner_Name__c);
    }    

    static testmethod void testParentSalesAccountsExisting() {
        Id cpsRecTypeId = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('CPS_Accounts').getRecordTypeId();

        Partner__c part1 = new Partner__c(Name = 'partner1');
        insert part1;

        Program__c program1 = new Program__c();
        program1.Name = 'test prog1' ;
        program1.Brand_Short_Name__c = 'test1';
        program1.Partner__c = part1.Id;

        insert program1;

        Account parentAcc1 = new Account(
            Name = 'A - Parent Account1',
            RecordTypeId = cpsRecTypeId,
            DUNS__c = '123456'
        );

        insert parentAcc1;

        Account acct1 = new Account(
            Name = 'A - Duns Test',
            RecordTypeId = cpsRecTypeId,
            Is_Program_Account__c = true,
            ParentId = parentAcc1.Id,
            Program__c = program1.Id,
            DUNS__c = '123456'
        );

        insert acct1;

        Account acct2 = new Account(
            Name = 'B - Test Account',
            RecordTypeId = cpsRecTypeId,
            DUNS__c = '123456'
        );

        insert acct2;

        acct2.Program__c = program1.Id;
        
        Test.startTest();
        Database.SaveResult result = Database.update(acct2, false);
        Test.stopTest();

        System.assert(result.isSuccess() == false);
        System.assert(result.getErrors().size() == 1);
    }        
}