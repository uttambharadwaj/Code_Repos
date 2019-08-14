@isTest
private class Test_CommunityUserStampData {

    @isTest static void test_StampLeadData() {



        test.starttest();

        Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
        GlobalSettings__c gs = new GlobalSettings__c(name='test');
        gs.Parent_Lead_Record_Type_Id__c = rectId;
        User upp = [Select Id, ProfileId, isactive from User Where Profile.Name='System Administrator' AND IsActive = true LIMIT 1];
        gs.Parent_Lead_Queue__c = upp.Id;
        insert gs;

        List<Account> a = utestdata.getaccounts(1);
        insert a;
        List<Contact> c = utestdata.getcontacts(a);
        insert c;

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND Name = 'Alon Partners' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        //u.AccountId = a[0].Id;
        insert u;

        test.stoptest();

        //User ucheck = [Select Id, Name, ContactId, AccountId from User where Id = :u.Id];
        //system.debug(ucheck);
        //system.assert(profileId != null && u != null);

        system.runAs(u)
        {
            List<Lead> lds = UTestData.getLeads(1);
            insert lds;
        }

        system.assertNotEquals([Select Id from Lead
                                Where External_Referred_By__c!=null AND
                                Referred_by_External_Account__c != null
                                AND EReferred_By__c != null
                                AND Referred_by_External__c != null].size(),0);



    }



    @isTest static void test_stampApplicationRequestData() {

        test.starttest();


        List<Account> a = utestdata.getaccounts(1);
        insert a;
        List<Contact> c = utestdata.getcontacts(a);
        insert c;

        /*
        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND Name = 'Alon Partners' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;
        */

        List<Opportunity> o = UTestData.getOpportunities(a);
        o[0].Program_Row_Id_Update__c = '1-3HWT-36';
        o[0].StageName = '5) Signed';
        o[0].Fleet_Size__c = 10;
        o[0].External_Referred_By_Account_Name__c = a[0].Id;
        o[0].External_Referred_By__c = c[0].Id;

        insert o;

        Application_Request__c ar = new Application_Request__c();
        ar.Opportunity__c = o[0].Id;

        insert ar;

        test.stoptest();


        /*
        system.runAs(u)
        {
            List<Opportunity> o = UTestData.getOpportunities(a);
            o[0].Program_Row_Id_Update__c = '1-3HWT-36';
            o[0].StageName = '5) Signed';
            o[0].External_Referred_By_Account_Name__c = a[0].Id;
            o[0].External_Referred_By__c = c[0].Id;

            insert o;

            Application_Request__c ar = new Application_Request__c();
            ar.Opportunity__c = o[0].Id;

            insert ar;
        }
        */

        system.assertNotEquals([Select Id from Application_Request__c
                                Where External_Referred_by__c!=null AND
                                External_Referring_Contact__c != null].size(),0);


    }

    @isTest
    static void test_stampOpportunity() {

        // At some point the "Advanced Approvals" package was installed
        // and its built-in triggers run when any user affects opportunities.
        // Although unrelated to this code, we are affected by it so
        // our test user must meet the package license access requirements.

        Profile p = [ SELECT id FROM Profile WHERE userType = 'PowerPartner' LIMIT 1 ]; // partner community

        PackageLicense pl = [ SELECT id FROM PackageLicense WHERE namespacePrefix = 'SBAA' LIMIT 1 ];

        List<Account> accounts = UTestData.getAccounts( 1 );
        insert accounts[0];

        List<Contact> contacts = UTestData.getContacts( accounts );
        insert contacts[0];

        User user = UTestData.getUserRecord( p.id );
        user.contactId = contacts[0].id;

        insert user;

        System.runAs( new User( id = UserInfo.getUserId() ) ) {

            UserPackageLicense upl = new UserPackageLicense(
                userId = user.id,
                packageLicenseId = pl.id
            );

            insert upl;

            PermissionSet ps = [ SELECT id FROM PermissionSet WHERE name = 'AdvancedApprovalsUser' LIMIT 1 ];

            PermissionSetAssignment psa = new PermissionSetAssignment(
                assigneeId = user.id,
                permissionSetId = ps.id
            );

            insert psa;

        }

        Test.startTest();

        // for whatever reason, the opportunity trigger calls code that calls UGears.UUser.isPartnerCommunityUser(..)
        // and that method expects `Profile.UserLicense.Name` field populated...
        user = [ SELECT id, userType, profile.userLicense.name, accountId, contactId FROM User WHERE id = :user.id LIMIT 1 ];

        System.runAs( user ) {

            List<Opportunity> opportunities = UTestData.getOpportunities( new Account[] { new Account( id = user.accountId ) } );

            Opportunity oppty = opportunities[0];

            oppty.program_row_id_update__c = '1-3HWT-36';
            oppty.stageName = '5) Signed';

            insert oppty;

        }

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM Opportunity WHERE external_referred_by_account_name__c = :user.accountId AND external_referred_by__c = :user.contactId ] );

    }

}