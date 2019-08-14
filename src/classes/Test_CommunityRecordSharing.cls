@isTest
private class Test_CommunityRecordSharing {
    
    @isTest static void testLeadSharingAdd() {
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

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND UserLicense.Name = 'Partner Community' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;

        test.stoptest();


        Lead l = UTestData.getLeads(1)[0];
        l.EReferred_By__c = c[0].Id;
        insert l;

        system.assertNotEquals([Select Id from LeadShare Where LeadId = :l.Id AND UserOrGroupId = :u.Id].size(),0);


    }
    
    @isTest static void testLeadSharingRemove() {
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

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND UserLicense.Name = 'Partner Community' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;

        Lead l = UTestData.getLeads(1)[0];
        l.EReferred_By__c = c[0].Id;
        insert l;

        test.stoptest();

        //List<LeadShare> lss = [Select Leadid, UserOrGroupId from LeadShare Where UserOrGroupId = :u.Id];
        //system.debug('-- TC: lead shares: ' + lss);

        l.EReferred_By__c = null;
        update l;

        system.assertEquals([Select Id from LeadShare Where LeadId = :l.Id AND UserOrGroupId = :u.Id].size(),0);
    }


    @isTest static void testContactSharing() {
        test.starttest();
        
        List<Account> a = utestdata.getaccounts(1);
        insert a;
        List<Contact> c = utestdata.getcontacts(a);
        insert c;

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND UserLicense.Name = 'Partner Community' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;

        test.stoptest();


        Contact c2 = UTestData.getContacts(a)[0];
        c2.Referred_by_External__c = c[0].Id;
        insert c2;

        system.assertNotEquals([Select Id from ContactShare Where ContactId = :c2.Id AND UserOrGroupId = :u.Id].size(),0);

        c2.Referred_by_External__c = null;
        update c2;

        system.assertEquals([Select ID from ContactShare Where ContactId = :c2.Id AND UserOrGroupId = :u.Id].size(),0);


    }

    @isTest static void testOpportunitySharing() {
        test.starttest();
        
        List<Account> a = utestdata.getaccounts(1);
        insert a;
        List<Contact> c = utestdata.getcontacts(a);
        insert c;

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND UserLicense.Name = 'Partner Community' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;

        test.stoptest();

        Opportunity o = UTestData.getOpportunities(a)[0];
        o.External_Referred_By__c = c[0].Id;
        insert o;

       // system.assertNotEquals([Select Id from OpportunityShare Where OpportunityId = :o.Id AND UserOrGroupId = :u.Id].size(),0);

        o.External_Referred_By__c = null;
        update o;

        system.assertEquals([Select ID from OpportunityShare Where OpportunityId = :o.Id AND UserOrGroupId = :u.Id].size(),0);


    }
    
}