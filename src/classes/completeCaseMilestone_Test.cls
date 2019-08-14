@isTest
private class completeCaseMilestone_Test {

//    static testMethod void testCaseMilestone(){
//
//        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator - Wex Europe'];
//
//        // create User
//        User u = new User();
//
//        u.FirstName = 'Alex';
//        u.LastName = 'Sherwood';
//        u.Email = 'test@wexeurope.com';
//        u.Username = 'astest@wexeurope.com';
//        u.Alias = 'astest';
//        u.ProfileId = p1.Id;
//        u.TimeZoneSidKey 	= 'America/Denver';
//        u.LocaleSidKey    	= 'en_US';
//        u.EmailEncodingKey  = 'UTF-8';
//        u.LanguageLocaleKey = 'en_US';
//
//        insert u;
//        system.debug('u contains ' + u);
//
//        System.runas(u){
//
//        // fetch Record Type Id for Custom Setting
//        RecordType rt = [SELECT Id, Name FROM RecordType
//                         WHERE SObjectType = 'Case' AND Name = 'WE Application'
//                         Limit 1];
//
//        system.debug('rt contains ' + rt);
//
//        // create Custom Setting
//        WEID__c[] csList = new WEID__c[]{};
//            WEID__c cs = New WEID__c();
//
//        cs.Name = 'WE Application';
//        cs.WECaseId__c = rt.Id;
//        csList.add(cs);
//
//        insert csList;
//        system.debug('csList contains ' + csList);
//
//        // create Group for Queue
//        Group g = new Group ();
//        g.Name = 'Wex Europe Applications';
//        g.Type = 'Queue';
//
//        insert g;
//        system.debug('g contains ' + g);
//
//        // create Queue
//        QueueSObject q = new QueueSObject ();
//        q.QueueId = g.Id;
//        q.SobjectType = 'Case';
//
//        insert q;
//        system.debug('q contains ' + q);
//
//        // create Milestones
//        List <MilestoneType> msList = new List <MilestoneType>();
//
//        MilestoneType m1 = new MilestoneType();
//        m1.Name = 'Case Accepted1';
//        msList.add(m1);
//
//        MilestoneType m2 = new MilestoneType();
//        m2.Name = 'Create & CSDM Approve Account1';
//        msList.add(m2);
//
//        insert msList;
//        system.debug('msList contains ' + msList);
//
//        // create Account
//        Account a = new Account();
//        a.Name = 'Test Account';
//        // satisfy validation rules
//        a.Sales_Group__c = 'Leisure Travel';
//        a.Sales_Type__c = 'OTA';
//
//        insert a;
//        system.debug('a contains ' + a);
//
//        // create Entitlement
//        Entitlement ent = New Entitlement();
//
//        ent.Name = 'Applications';
//        ent.AccountId = a.id;
//        ent.StartDate = system.today();
//        ent.EndDate = system.today().addYears(50);
//
//        insert ent;
//        system.debug('ent contains ' + ent);
//
//        // create Opportunity
//        Opportunity o = new Opportunity();
//        o.Name = 'Test Opportunity';
//
//        o.RecordTypeId = '012700000005qie';
//        o.StageName = '1) Qualified';
//        o.CloseDate = system.today().addMonths(4);
//
//        // satisfy validation rules
//        o.Type = 'New Customer';
//        o.Sales_Group__c = 'Business Travel';
//        o.LeadSource = 'Cold Call';
//        o.Billing_Street__c = '66 Hammersmith Road';
//        o.Billing_City__c = 'London';
//        o.Billing_State__c = 'London';
//        o.Billing_Zip_Postal_Code__c = 'W14 8UD';
//        o.Billing_Country__c = 'United Kingdom';
//
//        o.Annual_Settlement_Value__c = 1000000;
//        o.Average_transaction_Value_POS__c = 50;
//        o.Interchange_Rate_Revenue_as_a_percentag__c = 0.0175;
//
//        insert o;
//        system.debug('o contains ' + o);
//
//        // test Case changes
//
//            // create a Case with WE Application Record Type
//            Case c = new Case();
//
//            c.OwnerId = q.QueueId;
//            c.Status = 'Application Submitted';
//
//            c.RecordTypeId = rt.Id;
//            c.Subject = 'New Application';
//            c.EntitlementId = ent.Id;
//            c.Opportunity__c = o.Id;
//            c.AccountId = a.Id;
//
//            insert c;
//            system.debug('c contains ' + c);
//
//            // update Case to complete Milestones
//
//            // change Case owner
//            c.OwnerId = u.id;
//
//            update c;
//            system.debug('c contains ' + c + 'after update 1');
///*
//            // close Case
//            c.Status = 'Approval Completed';
//
//            update c;
//            system.debug('c contains ' + c + 'after update 2');
//*/
//            // make a change which shouldn't complete a Milestone
//            c.Subject = 'New Subject';
//
//            update c;
//
//            // create a Case with a Record Type Id that's not included in the Custom Setting, then update it
//
//            Case c1 = new Case();
//
//            c1.OwnerId = q.QueueId;
//            c1.Status = 'Application Submitted';
//            c1.Subject = 'Test Submit Application 2';
//
//            // Record Type - CorporatePay Salesforce Support Request
//            c1.RecordTypeId = '012700000005r40';
//            c1.Subject = 'New Application';
//            c1.EntitlementId = ent.Id;
//            c1.Opportunity__c = o.Id;
//            c1.AccountId = a.Id;
//
//            insert c1;
//
//            c1.Subject = 'New Subject';
//
//            try{
//            update c1;
//            } catch(Exception e){
//                				 System.debug('No Cases met the Milestone completion criteria');
//            }
//
//        }
//    }
}