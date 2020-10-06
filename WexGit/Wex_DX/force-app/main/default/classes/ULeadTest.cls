@isTest
private without sharing class ULeadTest {
	private static String COUNTRY_CODE = '+1 en-us';
	private static String MOBILE_NUMBER = '6159099034';
	private static String INVALID_MOBILE_NUMBER = '21316159099034';

	// Test data
	private static Campaign primaryCampaign;
	private static Lead parentLead;
	private static Lead childLead;
	private static Campaign_Program__c campaignProgram;

	// Test data initialization
	private static void init() {
		UtilityTestLoader.setAutomation(false);
		primaryCampaign = UTestData.createCampaign(false);
		primaryCampaign.Campaign_Program_Marketable_to__c = 'All';
		insert primaryCampaign;

		Program__c program = new Program__c(Country_Code__c = COUNTRY_CODE);
		insert program;
		campaignProgram = new Campaign_Program__c(Campaign__c = primaryCampaign.Id, Program__c = program.Id);
		insert campaignProgram;

		parentLead = UTestData.createParentLead(true);
		childLead = UTestData.createChildLead(false);
		childLead.Primary_Campaign__c = primaryCampaign.Id;
		childLead.Campaign_Program__c = campaignProgram.Id;
		insert childLead;
        
        Id leadRecordTypeId = [SELECT RecordTypeId FROM Lead WHERE Id = :childLead.Id].RecordTypeId;
        insert new GlobalSettings__c(Name = 'Settings', Country_Code_Enabled_RecordTypes__c = leadRecordTypeId + ';');


	}

	// setMarketable with no parent lead change 
	@isTest
	private static void testSetMarketable_noParentChange() {
		init();
		childLead.Email = 'newemail@email.com';

		// Test
		System.Test.startTest();
		update childLead;
		System.Test.stopTest();

		// Post-test
		String marketable = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;

		// Assert there is no update to marketable
		System.assertEquals(null, marketable);
	}

	// setMarketable with no Primary Campaign set
	@isTest
	private static void testSetMarketable_noPrimaryCampaign() {
		init();
		childLead.Primary_Campaign__c = null;
		childLead.Parent_Lead__c = parentLead.Id;

		// Test
		System.Test.startTest();
		update childLead;
		System.Test.stopTest();

		// Post-test
		String marketable = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;

		// Assert there is no update to marketable
		System.assertEquals(null, marketable);
	}

	// setMarketable with parent Lead Marketable value already set
	@isTest
	private static void testSetMarketable_marketableNotNull() {
		init();
		childLead.Parent_Lead__c = parentLead.Id;
		parentLead.Marketable__c = 'Partners';
		update parentLead;

		// Test
		System.Test.startTest();
		update childLead;
		System.Test.stopTest();

		// Post-test
		String marketable = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;

		// Assert there is no update to marketable
		System.assertEquals(parentLead.Marketable__c, marketable);
	}

	// setMarketable to All
	@isTest
	private static void testSetMarketable_All() {
		init();
        childLead.Parent_Lead__c = parentLead.Id;

		// Test
		System.Test.startTest();
		update childLead;
		System.Test.stopTest();

		// Post-test
		String marketable = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;

		// Assert marketable changed to All
		System.assertEquals('All', marketable);
	}

	// setMarketable to Partners
	@isTest
	private static void testSetMarketable_Partners() {
		init();
		childLead.Parent_Lead__c = parentLead.Id;
		primaryCampaign.Campaign_Program_Marketable_to__c = 'Partners';
		update primaryCampaign;

		// Test
		System.Test.startTest();
		update childLead;
		System.Test.stopTest();

		// Post-test
		String marketable = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;

		// Assert marketable changed to Partners
		System.assertEquals('Partners', marketable);
	}

	// setMarketable on group
	@isTest
	private static void testSetMarketable_multiple() {
		init();
		childLead.Parent_Lead__c = parentLead.Id;

		Campaign partnerCampaign = UTestData.createCampaign(false);
		partnerCampaign.Campaign_Program_Marketable_to__c = 'Partners';
		insert partnerCampaign;

		Lead partnerParentLead = UTestData.createParentLead(true);
		Lead partnerChildLead = UTestData.createChildLead(true);
		partnerChildLead.Parent_Lead__c = partnerParentLead.Id;
		partnerChildLead.Primary_Campaign__c = partnerCampaign.Id;

		List<Lead> childLeadList = new List<Lead>{ childLead, partnerChildLead };

		// Test
		System.Test.startTest();
		update childLeadList;
		System.Test.stopTest();

		// Post-test
		String marketableAll = [SELECT Marketable__c FROM Lead WHERE Id = :parentLead.Id].Marketable__c;
		String marketablePartner = [SELECT Marketable__c FROM Lead WHERE Id = :partnerParentLead.Id].Marketable__c;

		// Assert that both parent Leads were set correctly
		System.assertEquals('All', marketableAll);
		System.assertEquals('Partners', marketablePartner);
	}

	@isTest
	private static void testUpdateCountryCode() {
		init();

		Test.startTest();
		childLead.MobilePhone = MOBILE_NUMBER;
		update childLead;
		Test.stopTest();

		childLead = [ SELECT Id, MobilePhone FROM Lead WHERE Id = :childLead.Id];
		System.assertEquals(COUNTRY_CODE.split(' ')[0] + MOBILE_NUMBER, childLead.MobilePhone); // assert that country code was added
	}

	@isTest
	private static void testUpdateExistingCountryCode() {
		init();
		String countryCode = COUNTRY_CODE.split(' ')[0];

		Test.startTest();
		childLead.MobilePhone = countryCode + MOBILE_NUMBER;
		update childLead;
		Test.stopTest();

		childLead = [ SELECT Id, MobilePhone FROM Lead WHERE Id = :childLead.Id];
		System.assertEquals(countryCode + MOBILE_NUMBER, childLead.MobilePhone); //assert that an additional country code was not added
	}
}