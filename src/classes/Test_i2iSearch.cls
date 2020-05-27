@isTest
private class Test_i2iSearch {
	/** TEST DATA */
	static Program__c program;
	static Campaign campaign1;
	static Campaign campaign2;
	static Campaign_Program__c campaignProgram1;
	static Campaign_Program__c campaignProgram2;

	static Account acct;
	static Contact cont1;
	static Contact cont2;
	static Opportunity opp1;
	static Opportunity opp2;
	static Lead parentLead;
	static Lead childLead;
	static Task childLeadTask;

	static User sysAdminUser;
	static Lead_Record_Type__c leadRecordType;
	static QueuesObject qObject;

	static i2iSearchController i2isc;

	/** TEST DATA INITIALIZATION */
	private static void init() {
		// Config
		sysAdminUser = TestDataFactory.createUserSysAdmin(true); 
		GlobalSettings__c gs = TestDataFactory.createGlobalSettings('Lead', 'Parent Lead', sysAdminUser.Id);
		UtilityTestLoader.setAutomation(false);

		// Test Data
		program = TestDataFactory.createProgram(true, 'Test');
		campaign1 = TestDataFactory.createCampaign(true, 'Campaign1', 'test1');
		campaignProgram1 = TestDataFactory.createCampaignProgram(true, campaign1.Id, program.Id);

		acct = TestDataFactory.createAccount(true);
		leadRecordType = TestDataFactory.createLeadRecordType(true, 'Test', program.Id); 
		parentLead = TestDataFactory.createLead(true, null, '1');
    
        
		childLead = [SELECT Id, Parent_Lead__r.rr_lead_number__c FROM Lead WHERE Parent_Lead__c = :parentLead.Id][0];

		cont1 = TestDataFactory.createContact(true, acct.Id, 'test1', childLead.Parent_Lead__r.rr_lead_number__c); 
		opp1 = TestDataFactory.createOpportunity(true, acct.Id, campaign1.Id);

		OpportunityContactRole ocr1 = TestDataFactory.createOpportunityContactRole(true, opp1.Id, cont1.Id);
		CampaignMember campMember1 = TestDataFactory.createCampaignMember(true, campaign1.Id, cont1.Id); 
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = campaign1.Id;
        cm.LeadId = parentLead.Id;
        cm.Status = 'Sent';
        insert cm;
		
		childLeadTask = TestDataFactory.createTask(true, childLead.Id, sysAdminUser.Id);
		Sales_Activity_by_Profile__c sabp = TestDataFactory.createSalesActivityByProfile(true); 
	}

	private static void initPage() {
		i2isc = new i2iSearchController();
        List<SelectOption> selects = i2isc.programValues;

		System.Test.setCurrentPage(Page.i2iSearchPage);
		ApexPages.currentPage().getParameters().put('leftnav', 'true');
        i2isc.initLeftNavPage();
        i2isc.initPage();
        i2isc.phoneNumber = '1111111111';
        i2isc.findbyBusiness();
        i2isc.findbyPhone();
		i2isc.searchi2iLeftNav();
		i2isc.clearForm();

        i2isc.company = 'THE TEST COMPANY';

		// If searching with Quick Pivot
		Boolean isQuickPivot = [SELECT Active__c FROM Search_Tool_Source__mdt WHERE Data_Source__c = 'Quick Pivot' LIMIT 1].Active__c;
		if (isQuickPivot) {
            
			i2isc.programSelected = 'Test';
			i2isc.phoneNumber = '13111111111';
			i2isc.company = 'THE TEST COMPANY';
			i2isc.zipcode = '11111';
			i2isc.promocode = 'test1';

			// Callout mock
			System.Test.setMock(HttpCalloutMock.class, new Test_i2iHttpCallOutMock());
		}
		// If searching with Marketing Cloud
		else {            
			i2isc.phoneNumber = '3333333333';
			i2isc.promocode = 'test1-' + childLead.Parent_Lead__r.rr_lead_number__c;
            
			// Callout mock
			Map<String, String> servicesHeaders = new Map<String, String>();
			servicesHeaders.put('SOAPAction', 'Retrieve');
			servicesHeaders.put('Content-type', 'text/xml');
			servicesHeaders.put('Accept', 'text/xml');

			i2iGetMC_CalloutTest.TestMock services = new i2iGetMC_CalloutTest.TestMock(200, '', servicesHeaders);
			Map<String, HttpCalloutMock> endpointMock = new Map<String, HttpCalloutMock>();
			endpointMock.put('callout:Marketing_Cloud_Service', services);

			HttpCalloutMock multiCalloutMock = new i2iGetMC_CalloutTest.MultiRequestMock(endpointMock);
			System.Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		}
	}

	/** TEST METHODS */
	@isTest
	static void testInit() {        
		init();
		initPage();
	}

	@isTest
	static void testSearch_lead() {
		init();
		initPage();

		// Test
		System.Test.startTest();
		i2isc.searchi2i();
		System.Test.stopTest(); 

		// Assert that a lead was found, wrapped, and added to the controller
		System.assertEquals(1, i2isc.leadwrappers.size()); 
	}

	@isTest
	static void testOpen_lead() {
		init();
		initPage();

		// Test
		System.Test.startTest();
		i2isc.searchi2i();
		PageReference pageRef = i2isc.leadwrappers[0].openlead();
		System.Test.stopTest();

		// Assert that the page reference was returned for the lead
		System.assertEquals('/' + childLead.Id, pageRef.getUrl());
	}

	@isTest
	static void testConvertLead_lead() {
        
		init();
		initPage();

		System.Test.startTest();
		i2isc.searchi2i();
		PageReference pageRef = i2isc.leadwrappers[0].convertlead();
		System.Test.stopTest();

		Id newOppId = [SELECT ConvertedOpportunityId FROM Lead WHERE Id = :childLead.Id][0].ConvertedOpportunityId;
		String url = '/' + newOppId + '/e?retURL=%2F' + newOppId;
        
        
        System.debug('newOppId: '+newOppId);

		// Assert that the lead was converted and the page reference was returned for the new Opportunity
		System.assertEquals(url, pageRef.getUrl());
	}

	@isTest
	static void testSearch_contact() {
		init();
		initPage();
		cont1.i2i_ID__c = '1';
		update cont1;

		// Test
		System.Test.startTest();
		i2isc.searchi2i();
		System.Test.stopTest();  

		// Assert that the contact was found, wrapped, and added to the controller
		System.assertEquals(1, i2isc.contactwrappers.size()); 
	}

	@isTest
	static void testOpen_contact() {
        
		init();
		initPage();
		cont1.i2i_ID__c = '1';
		update cont1;

		// Test
		System.Test.startTest();
		i2isc.searchi2i();
		PageReference pageRef = i2isc.contactwrappers[0].opencontact();
		System.Test.stopTest();  

		// Assert that the page reference was returned for the contact
		System.assertEquals('/' + cont1.Id, pageRef.getUrl());
	}

	@isTest
	static void testCreateLead_noMatch() {
		init();
		delete parentLead;
		delete childLead;
		delete cont1;
		initPage();

		// Test
		System.Test.startTest();
		i2isc.searchi2i();

		PageReference pageRef = i2isc.nomatchrecordwrappers[0].createleadredirect();
		System.Test.stopTest();  

		Id newChildLeadId = [SELECT Id FROM Lead WHERE Parent_Lead__c != null][0].Id;
		String url = '/' + newChildLeadId + '/e?retURL=%2F' + newChildLeadId;

		// Assert that a lead was created and the page reference returned for the new lead
		System.assertEquals(url, pageRef.getUrl());
	}

	@isTest
	static void testConvertLead_noMatch() {        
		init();
		delete parentLead;
		delete childLead;
		delete cont1;
		initPage();

		// Test
		System.Test.startTest();
		i2isc.searchi2i();
		i2isc.nomatchrecordwrappers[0].convertLead();
		System.Test.stopTest();  

		Lead newParentLead = [SELECT Id, i2i_ID__c FROM Lead WHERE i2i_ID__c = '1' LIMIT 1];
		Integer newChildLeadCount = [SELECT COUNT() FROM Lead WHERE Parent_Lead__c = :newParentLead.Id];

		// Assert that a new parent Lead and child Lead were created
		// NOTE: Despite function name, process only creates lead and does not convert it
		System.assertNotEquals(null, newParentLead);
		System.assertEquals(1, newChildLeadCount);
	}

	@isTest
	static void testConvertChildLead_noMatch() {        
		init();
		childLead = [
			SELECT Id, i2i_id__c, Parent_Lead__r.rr_lead_number__c, Parent_Lead__r.i2i_id__c, IsConverted, 
			RecordTypeId, Parent_Lead__r.Related_Account__c, Parent_Lead__r.Related_Contact__c 
		FROM Lead 
		WHERE Id = :childLead.Id];
		
		initPage();
		i2isc.programNamesByCouponCode = new Map<String, String>();
		i2iGet.ReturnData rd = new i2iGet.ReturnData();
		rd.couponcode = 'testing';

		i2iSearchController.NoMatchi2i noMatch = new i2iSearchController.NoMatchi2i(rd, i2isc);
		noMatch.childLead = new List<Lead>{ childLead };

		// Test
		System.Test.startTest();
		PageReference pageRef = noMatch.convertChildLead();
		System.Test.stopTest();
		
		Id newOpportunityId = [SELECT Id, ConvertedOpportunityId FROM Lead WHERE Id = :childLead.Id][0].ConvertedOpportunityId;
		String url = '/' + newOpportunityId + '/e?retURL=%2F' + newOpportunityId;

		// Assert that a lead was created and the page reference returned for the new lead
		System.assertEquals(url, pageRef.getUrl());
	}
}