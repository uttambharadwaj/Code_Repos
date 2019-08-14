@isTest
private class WE_ImpProjectManagerTest {
/*//https://jira.devtools.wexinc.com/browse/IADJUDICAT-816

	@testSetup
	static void dataSetup() {

		Profile euUserProfile = [SELECT Id FROM Profile WHERE Name = 'CorporatePay Sales' LIMIT 1];
		Profile auUserProfile = [SELECT Id FROM Profile WHERE Name = 'MasterCard Sales' LIMIT 1];
		Profile naUserProfile = [SELECT Id FROM Profile WHERE Name = 'International Sales' LIMIT 1];

		User u = WE_TestDataUtility.createStandardUser();
		insert u;

		User euUser = new User();
		euUser.FirstName         = 'Alex';
		euUser.LastName          = 'Sherwood';
		euUser.Email             = 'euUser@wexeurope.com';
		euUser.Username          = 'euUser@wexeurope.com';
		euUser.Alias             = 'euUser';
		euUser.TimeZoneSidKey    = 'America/Denver';
		euUser.LocaleSidKey      = 'en_US';
		euUser.EmailEncodingKey  = 'UTF-8';
		euUser.LanguageLocaleKey = 'en_US';
		euUser.ProfileId = euUserProfile.Id;
		insert euUser;

		User auUser = new User();
		auUser.FirstName         = 'Alex';
		auUser.LastName          = 'Sherwood';
		auUser.Email             = 'auUser@wexeurope.com';
		auUser.Username          = 'auUser@wexeurope.com';
		auUser.Alias             = 'auUser';
		auUser.TimeZoneSidKey    = 'America/Denver';
		auUser.LocaleSidKey      = 'en_US';
		auUser.EmailEncodingKey  = 'UTF-8';
		auUser.LanguageLocaleKey = 'en_US';
		auUser.ProfileId = auUserProfile.Id;
		insert auUser;

		User naUser = new User();
		naUser.FirstName         = 'Alex';
		naUser.LastName          = 'Sherwood';
		naUser.Email             = 'naUser@wexeurope.com';
		naUser.Username          = 'naUser@wexeurope.com';
		naUser.Alias             = 'naUser';
		naUser.TimeZoneSidKey    = 'America/Denver';
		naUser.LocaleSidKey      = 'en_US';
		naUser.EmailEncodingKey  = 'UTF-8';
		naUser.LanguageLocaleKey = 'en_US';
		naUser.ProfileId = naUserProfile.Id;
		insert naUser;

		System.runas(u) {

			VApexC__c apxCntrlSett = WE_TestDataUtility.createApexControllerCustSett(
			'Project Creation',  	// fieldRef
			false);       		 	// fcstDisabledStatus
			apxCntrlSett.Target_Manager_Disabled__c = true;
			apxCntrlSett.BudgetManagerDisabled__c = true;
			insert apxCntrlSett;

			List<VRTN__c> rtCs = new List<VRTN__c>();

			rtCs.add(WE_TestDataUtility.createRecTypeNameCustSett(
			'Virtual Credit MC',     // rtName
			'Virtual AU Opps'));    		 // csFieldRef

			rtCs.add(WE_TestDataUtility.createRecTypeNameCustSett(
			'CP Virtual Credit',     // rtName
			'EU Opps'));    		 // csFieldRef

			rtCs.add(WE_TestDataUtility.createRecTypeNameCustSett(
            'MasterCard',     		// rtName
            'NA Opps'));    		// csFieldRef

			rtCs.add(WE_TestDataUtility.createRecTypeNameCustSett(
            'Implementation',     	// rtName
            'Virtual EU Projects'));    		// csFieldRef

			rtCs.add(WE_TestDataUtility.createRecTypeNameCustSett(
            'Project',     			// rtName
            'Virtual NA Projects'));    		// csFieldRef

			insert rtCs;

			Account auNaAccount = new Account(Name='auNaA',Sales_Group__c='Travel');
			Account euAccount = new Account(Name='euA',Type='Prospect',Sales_Group__c='Corporate',Industry='Agriculture',Marketing_Approval__c='Approved');
			List<Account> acctsToInst = new List<Account>{auNaAccount,euAccount};

			insert acctsToInst;

			List<Opportunity> opps = new List<Opportunity>();
			List<Opportunity> euOpps = new List<Opportunity>();
			List<Opportunity> naOpps = new List<Opportunity>();
			List<Opportunity> auOpps = new List<Opportunity>();

			List<VProfileId__c> profCSs = new List<VProfileId__c>();

			euOpps.addAll(WE_TestDataUtility.createOpportunities(
                'EU Opps',            		// oppRef
                1,                      	// noOpps
                'CP Virtual Credit',    	// recordTypeName
                'EU Opp',                   // identifier
                '1) Suspect',               // stageName
                date.today().addMonths(1),  // closeDate
                'Extended',                 // rampProfile
                100.00));                  	// settlement

			Id euUserId = [SELECT Id FROM User WHERE Profile.Name = 'CorporatePay Sales' AND IsActive = TRUE LIMIT 1].Id;
			for(Opportunity o : euOpps) {
				o.OwnerId = euUserId;
                                o.Average_transaction_Value_POS__c = 5.00;
                o.Current_Provider__c = 'Visa';
                o.Current_Provider1__c = 'Visa';
				opps.add(o);
			}
			profCSs.add(WE_TestDataUtility.createProfileIdCustSett(euUserId,'Profile','EuSalesRm Profile',true));

			naOpps.addAll(WE_TestDataUtility.createOpportunities(
                'NA Opps',            		// oppRef
                1,                      	// noOpps
                'MasterCard',    			// recordTypeName
                'NA Opp',                   // identifier
                '1) Suspect',               // stageName
                date.today().addMonths(1),  // closeDate
                'Standard',                 // rampProfile
                100.00));                  	// settlement

			Id naUserId = [SELECT Id FROM User WHERE Profile.Name = 'MasterCard Sales' AND IsActive = TRUE LIMIT 1].Id;
			for(Opportunity o : naOpps) {
				o.OwnerId = naUserId;
                                o.Average_transaction_Value_POS__c = 5.00;
                o.Current_Provider__c = 'Visa';
                o.Current_Provider1__c = 'Visa';
				opps.add(o);
			}
			profCSs.add(WE_TestDataUtility.createProfileIdCustSett(naUserId,'Profile','NaSalesRm Profile',true));

			auOpps.addAll(WE_TestDataUtility.createOpportunities(
				'AU Opps',            		// oppRef
				1,                      	// noOpps
				'Virtual Credit MC',    	// recordTypeName
				'AU Opp',                   // identifier
				'1) Suspect',               // stageName
				date.today().addMonths(1),  // closeDate
				'Standard',                 // rampProfile
				100.00));                  	// settlement

			Id auUserId = [SELECT Id FROM User WHERE Profile.Name = 'International Sales' AND IsActive = TRUE LIMIT 1].Id;
			for(Opportunity o : auOpps) {
				o.OwnerId = auUserId;
                o.Average_transaction_Value_POS__c = 5.00;
                o.Current_Provider__c = 'Visa';
                o.Current_Provider1__c = 'Visa';
				opps.add(o);
			}
			profCSs.add(WE_TestDataUtility.createProfileIdCustSett(auUserId,'Profile','AuSalesRm Profile',true));

			insert opps;
			insert profCSs;
		}

	}

	static testMethod void testEuProjectCreation() {

        User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

        System.runas(u) {

		WE_ApexUtility.testContext = true;
		WE_ApexUtility.testContextStatus = 'TRUE';
		List<Opportunity> euOppsToUpdate = new List<Opportunity>([SELECT Id,Probability,OwnerId FROM Opportunity WHERE Name LIKE '%EU Opp%']);

        Test.startTest();

		for(Opportunity o : euOppsToUpdate) {
			o.Probability = 76;
            o.CloseDate = date.newInstance(2098,1,1);
		}
		update euOppsToUpdate;

		Test.stopTest();

		Integer projectTemplatesCount = 0;
		Integer milestoneTemplatesCount;
		for(Project_Template__mdt pt : [SELECT MasterLabel, (SELECT MasterLabel FROM Milestone_Templates__r WHERE EU_Milestone__c = TRUE AND Test_Record__c = TRUE) FROM Project_Template__mdt WHERE EU_Project__c = TRUE AND Test_Record__c = TRUE]) {
			projectTemplatesCount = projectTemplatesCount + 1;
			milestoneTemplatesCount = pt.Milestone_Templates__r.size();
		}
		System.assertEquals(1,projectTemplatesCount,'Only 1 Project Template should be retrieved otherwise several sets of Milestone Templates will be retrieved by the above query.');

		List<Id> projectIds = new List<Id>();
		Map<Id,Id> oppOwnersByOppId = new Map<Id,Id>();
		for(ProjectxOpp__c pxo : [SELECT Project__c,Opportunity__c,Opportunity__r.OwnerId FROM ProjectxOpp__c WHERE Opportunity__c IN :euOppsToUpdate]) {
			projectIds.add(pxo.Project__c);
			oppOwnersByOppId.put(pxo.Opportunity__c,pxo.Opportunity__r.OwnerId);
		}
		Map<Id,Set<MPM4_BASE__Milestone1_Milestone__c>> milestonesByProjectId = new Map<Id,Set<MPM4_BASE__Milestone1_Milestone__c>>();
		for(MPM4_BASE__Milestone1_Milestone__c m : [SELECT Id,MPM4_BASE__Project__c FROM MPM4_BASE__Milestone1_Milestone__c WHERE MPM4_BASE__Project__c IN :projectIds]) {
			Set<MPM4_BASE__Milestone1_Milestone__c> milestones = milestonesByProjectId.get(m.MPM4_BASE__Project__c);
			if (milestones == null) {
				milestones = new Set<MPM4_BASE__Milestone1_Milestone__c>();
				milestonesByProjectId.put(m.MPM4_BASE__Project__c,milestones);
			}
			milestones.add(m);
		}

		Set<MPM4_BASE__Milestone1_Milestone__c> aProjectsMilestones = new Set<MPM4_BASE__Milestone1_Milestone__c>();
        System.debug('### ProjectIds: ' + projectIds);
        System.debug('### Milestones: ' + milestonesByProjectId);
        if(milestonesByProjectId != null && milestonesByProjectId.size() > 0 && projectIds != null && projectIds.size() > 0) {
			for(MPM4_BASE__Milestone1_Milestone__c m : milestonesByProjectId.get(projectIds[0])) {
				aProjectsMilestones.add(m);
			}
        }
		System.assertEquals(milestoneTemplatesCount,aProjectsMilestones.size(),'The same number of Milestones should have been linked to each Opportunity as there are Milestone Templates');

		System.assertEquals(euOppsToUpdate.size(),milestonesByProjectId.keySet().size(),'One Project should have been created for each Opportunity.');

		Id runningUserId = UserInfo.getUserId();
		System.assertNotEquals(euOppsToUpdate[0].OwnerId,oppOwnersByOppId.get(euOppsToUpdate[0].OwnerId),'The owner of the Project should be a queue, not the Opportunity owner');
		System.assertNotEquals(euOppsToUpdate[0].OwnerId,runningUserId,'The owner of the Project should be a queue, not the running user');

        }

	}

	static testMethod void testUpdatesToMultipleRegionsProjects() {

        User u = [SELECT Id FROM User WHERE Username = 'astest@wexeurope.com'];

        System.runas(u) {

		WE_ApexUtility.testContext = true;
		List<Opportunity> auAndEuOpps = new List<Opportunity>();
		List<Opportunity> auOppsToUpdate = new List<Opportunity>([SELECT Id,Probability FROM Opportunity WHERE Name LIKE '%AU Opp%']);
		auAndEuOpps.addAll(auOppsToUpdate);
		List<Opportunity> euOppsToUpdate = new List<Opportunity>([SELECT Id,Probability FROM Opportunity WHERE Name LIKE '%EU Opp%']);
		auAndEuOpps.addAll(euOppsToUpdate);

        System.debug(LoggingLevel.ERROR,'+++ testUpdatesToMultipleRegionsProjects method entered');

		Test.startTest();

		for(Opportunity o : auAndEuOpps) {
			o.Probability = 100;
            o.CloseDate = date.newInstance(2098,1,1);
		}
		try{
			update auAndEuOpps;
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR,'Caught the error');
		}

		Test.stopTest();

        }

	}
*/
}