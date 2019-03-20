@isTest
private class Test_MyApplications {
    
    @isTest static void testMyapplications() {
        
        
        List<Account> a = utestdata.getAccounts(1);
        insert a;
        List<Contact> c = utestdata.getcontacts(a);
        insert c;

        Id profileId = [select Id from Profile where UserType in ('PowerPartner') AND UserLicense.Name = 'Partner Community' LIMIT 1].Id;

        User u = utestdata.getuserrecord(profileId);
        u.ContactId = c[0].Id;
        insert u;

        system.debug('in AR Test: ' + u.Id + ' ' + u.ContactId);

        List<Opportunity> o = UTestData.getOpportunities(a);
        o[0].stagename = '5) Signed';
        o[0].Fleet_Size__c = 10;
        insert o;

        //system.runas(u)
        //{
            Application_Request__c ar = new Application_Request__c();
            ar.Opportunity__c = o[0].Id;
            ar.App_Submitted_Date__c = system.now().date();
            ar.Sales_Stage__c = 'test';
            ar.External_Referring_Contact__c = c[0].Id;
            insert ar;


            ar.External_Referring_Contact__c = c[0].Id;
            update ar;
        //}
        

        
        test.starttest();

        system.runas(u)
        {
            PageReference pageRef = Page.MyApplications;
            Test.setCurrentPage(pageRef);
            MyApplicationsController mac = new MyApplicationsController();
            
        }
        
        test.stoptest();

        system.assertEquals([Select count() from Application_Request__c Where External_Referring_Contact__c = :u.ContactId],1);

    }

    
}