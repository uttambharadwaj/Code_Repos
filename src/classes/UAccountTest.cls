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

}