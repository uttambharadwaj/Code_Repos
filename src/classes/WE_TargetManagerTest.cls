@isTest
public class WE_TargetManagerTest {

    @testSetup
    static void dataSetup() {

        User u = WE_TestDataUtility.createStandardUser();

        // create Salesperson 1
        User s1 = new User();

        s1.FirstName 		 = 'Test';
        s1.LastName 		 = 'User';
        s1.Email 			 = 'test1@wexeurope.com';
        s1.Username 		 = 'utest1@wexeurope.com';
        s1.Alias 			 = 'utest';
        s1.ProfileId 		 = u.ProfileId;
        s1.TimeZoneSidKey    = 'America/Denver';
        s1.LocaleSidKey      = 'en_US';
        s1.EmailEncodingKey  = 'UTF-8';
        s1.LanguageLocaleKey = 'en_US';

        insert s1;

        System.runas(u) {

            VApexC__c acCS = WE_TestDataUtility.createApexControllerCustSett(
                'Target Manager',	// fieldRef
                false); 			// fcstDisabledStatus

            acCs.BudgetManagerDisabled__c = true;

            insert acCS;

            VRTN__c euRtCs = WE_TestDataUtility.createRecTypeNameCustSett(
                'CP Virtual Prepaid MC', // rtName
                'NAEU Opps');            // csField

            insert euRtCs;

            VRTN__c naRtCs = WE_TestDataUtility.createRecTypeNameCustSett(
                'MasterCard', // rtName
                'NAEU Opps'); // csField

            insert naRtCs;

            VProfileId__c profCS = WE_TestDataUtility.createProfileIdCustSett(
                u.Id,					// user Id
                'Profile',				// locationRef
                'EuNaSalesRm Profile', 	// fieldRef
                true); 				   	// settingStatus
            // delete once Budget Manager Custom Setting can be used to disable code
            profCS.Team_Name__c = 'Virtual Admin';

            insert profCS;

            List<Target__c> targetsToInsert = new List<Target__c>();

            // create Budgets
            List<Budget__c> budgets = new List<Budget__c>();

            for(integer i = 0; i < 9; i++) {
                budgets.add(new Budget__c(
                    Name = 'Test Budget ' + i,
                    Date__c = date.today().addMonths(i),
                    Team__c = 'Virtual Admin',
                    Budget__c = 1));
            }
            for(integer i = 0; i < 9; i++) {
                budgets.add(new Budget__c(
                    Name = 'Test Budget ' + i,
                    Date__c = date.today().addMonths(i),
                    Team__c = 'Virtual Admin',
                    Budget__c = 1));
            }
            insert budgets;

            //create Targets
            List<Target__c> targets1 = WE_TestDataUtility.createTargets(
                2,          						// noMonths
                u.Id,								// salespersonId
                date.today().addMonths(3).year(),   // firstYear
                date.today().addMonths(3).month(),  // firstMonth
                'Virtual Sales EU', 				// team
                'Close Date',						// dateType
                100000);      						//target

            for(Target__c t : targets1)
            {
                targetsToInsert.add(t);
            }

            List<Target__c> targets2 = WE_TestDataUtility.createTargets(
                1,         				// noMonths
                u.Id,					// salespersonId
                date.today().year(),   	// firstYear
                date.today().month(),  	// firstMonth
                'Virtual Sales EU', 	// team
                'Created Date',			// dateType
                100000);      			//target

            for(Target__c t : targets2)
            {
                targetsToInsert.add(t);
            }

            List<Target__c> targets3 = WE_TestDataUtility.createTargets(
                1,         							// noMonths
                s1.Id,								// salespersonId
                date.today().addMonths(4).year(),   // firstYear
                date.today().addMonths(4).month(),  // firstMonth
                'Virtual Sales EU', 				// team
                'Close Date',						// dateType
                100000);      						//target

            for(Target__c t : targets3)
            {
                targetsToInsert.add(t);
            }

            insert targetsToInsert;

            //create Opportunitys to insert, in bulk
            List<Opportunity> opportunities = WE_TestDataUtility.createOpportunities(
                'EU Opps',						// oppRef
                1,              				// noOpps
                'CP Virtual Prepaid MC',    	// recordTypeName
                'id0',              			// identifier
                '1) Suspect',          			// stageName
                date.today().addMonths(3),  	// closeDate
                'Standard',            			// rampProfile
                100.00);            			// settlement

            insert opportunities;
        }
    }

    static testMethod void testTargetUpdates() {

        List<Opportunity> oppsToUpdate = [SELECT Id, CloseDate, OwnerId FROM Opportunity
                                           WHERE Name LIKE '%id0%'];

        User s = [SELECT Id FROM User WHERE Username = 'utest1@wexeurope.com' LIMIT 1];

        test.startTest();

        System.runAs(s){
            for(Opportunity o : oppsToUpdate) {
                o.CloseDate = o.CloseDate.addMonths(1);
            }
            update oppsToUpdate;

            for(Opportunity o : oppsToUpdate) {
                o.OwnerId = s.id;
            }
            update oppsToUpdate;
        }

        test.stopTest();
    }

}