@isTest
private class WE_WinLossSurveyTest {
/*//https://jira.devtools.wexinc.com/browse/IADJUDICAT-816

	@testSetup
    static void dataSetup() {

		User u = WE_TestDataUtility.createStandardUser();

		 System.runas(u) {

			VApexC__c acCS = WE_TestDataUtility.createApexControllerCustSett(
                'Target Manager',  	// fieldRef
                false);       		// fcstDisabledStatus
            acCs.BudgetManagerDisabled__c = true;
            insert acCS;

			VRTN__c euRtCs = WE_TestDataUtility.createRecTypeNameCustSett(
                'CP Virtual Prepaid MC', // rtName
                'EU Opps');            // csField
            insert euRtCs;

			// delete once Budget Manager Custom Setting can be used to disable code
			VProfileId__c profCS = WE_TestDataUtility.createProfileIdCustSett(
                u.Id,					// user Id
                'Profile',        		// locationRef
                'EuNaSalesRm Profile',  // fieldRef
                true);              	// settingStatus
            profCS.Team_Name__c = 'Virtual Admin';
            insert profCS;

			List<Budget__c> budgets = WE_TestDataUtility.createBudgets(
				12,
				date.today().addMonths(4).year(),
				date.today().addMonths(4).month(),
				'Virtual Admin',
				100
				);
			insert budgets;

			List<Target__c> targets = WE_TestDataUtility.createTargets(
                1,                      			// noMonths
                u.Id,                				// salespersonId
                date.today().addMonths(1).year(),   // firstYear
                date.today().addMonths(1).month(),  // firstMonth
                'Virtual Sales EU',         		// team
                'Close Date',            			// dateType
                100000);                  			//target
			insert targets;

			//create Opportunitys to insert, in bulk
			List<Opportunity> oppsWithCRs = new List<Opportunity>();
			List<Opportunity> oppsWithOutCRs = new List<Opportunity>();
			List<Opportunity> oppsToInsert = new List<Opportunity>();

            oppsWithCRs.addAll(WE_TestDataUtility.createOpportunities(
                'EU Opps',            		// oppRef
				// will hit "Too many Email Invocations error" if number of Opportunities is greater than 10
                10,                      	// noOpps
                'CP Virtual Prepaid MC',    // recordTypeName
                'withContactRoles',         // identifier
                '1) Suspect',               // stageName
                date.today().addMonths(1),  // closeDate
                'Standard',                 // rampProfile
                100.00));                  	// settlement

			oppsWithOutCRs.addAll(WE_TestDataUtility.createOpportunities(
                'EU Opps',            		// oppRef
                10,                      	// noOpps
                'CP Virtual Prepaid MC',    // recordTypeName
                'withoutContactRoles',      // identifier
                '1) Suspect',               // stageName
                date.today().addMonths(1),  // closeDate
                'Standard',                 // rampProfile
                100.00));                  	// settlement

			oppsToInsert.addAll(oppsWithCRs);
			oppsToInsert.addAll(oppsWithOutCRs);
			insert oppsToInsert;

			Contact c = new Contact(
				FirstName 	= 'Test',
				LastName 	= 'Contact',
				Email		= 'test@gmail.com');
			insert c;

			List<OpportunityContactRole> ocrsToInsert = new List<OpportunityContactRole>();
			for(Opportunity o : oppsWithCRs) {
				OpportunityContactRole ocr = new OpportunityContactRole(
					OpportunityId 	= o.Id,
					ContactId 		= c.Id,
					Role 			= 'Decision Maker',
					IsPrimary		= false);
				ocrsToInsert.add(ocr);
			}
			insert ocrsToInsert;
		}

	}

	static testMethod void testOppsWithContactRoles() {

		User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];
		List<Opportunity> opportunities = [SELECT Id,Reason_Code__c FROM Opportunity
											WHERE Name LIKE '%withContactRoles%'];

		Test.startTest();
		system.runAs(u){
			for(Opportunity o : opportunities) {
				o.Send_Lost_Deal_Survey__c 	= true;
				o.Reason_Code__c 			= 'Unit Test - Do Not Delete';
			}
			update opportunities;
		}

	}

	static testMethod void testOppsWithoutContactRoles() {

		User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];
		List<Opportunity> opportunities = [SELECT Id,Reason_Code__c FROM Opportunity
											WHERE Name LIKE '%withoutContactRoles%'];

		Boolean updateCausedError;

		Integer emailBefore = Limits.getEmailInvocations();
		Test.startTest();
		system.runAs(u){
			for(Opportunity o : opportunities) {
				o.Send_Lost_Deal_Survey__c 	= true;
				o.Reason_Code__c 			= 'Unit Test - Do Not Delete';
			}
			try{
				update opportunities;
			} catch(Exception e) {
				updateCausedError = true;
			}
		}
		Test.stopTest();

		//System.assertEquals(true,updateCausedError,'error should have been thrown when no Decision Maker Contact Roles were found');
	}
*/
}