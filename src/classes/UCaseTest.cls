@isTest
private class UCaseTest {

	@isTest static void caseAccountDomainMatch() {

		VRTN__c vrtn = new VRTN__c();

		vrtn.EUAccts__c = 'CorporatePay Accounts';
		vrtn.EUServiceCases__c = '  Virtual Credit CS';
		vrtn.Name = 'test data';
		insert vrtn;


		/*VApexC__c acCS = WE_TestDataUtility.createApexControllerCustSett(
		  'Domain Match',  // fieldRef
		  false);          // fcstDisabledStatus
		  insert acCS;
		 */

		Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
		Map<String, Schema.RecordTypeInfo> accountRtMapByName = accountSobject.getRecordTypeInfosByName();
		for (String st : accountRtMapByName.keySet()) {
			system.debug('the name---' + st);
			system.debug('the rt----' + accountRtMapByName.get(st));
		}
		Id acId = accountRtMapByName.get('CorporatePay Accounts').getRecordTypeId();

		List<Account> acts = UTestData.getAccounts(1);
		for (Account act : acts) {
			act.Website = 'www.test.com';
			act.RecordTypeId = acId;
		}

		insert acts;

		Schema.DescribeSObjectResult caseSobject = Case.SObjectType.getDescribe();
		Map<String, Schema.RecordTypeInfo> caseRtMapByName = caseSobject.getRecordTypeInfosByName();
		Id caId = caseRtMapByName.get('Virtual Credit CS').getRecordTypeId();

		List<Case> actCases = UTestData.getCases(acts);

		for (Case c : actCases) {
			c.AccountId = null;
			c.Origin = 'Email';
			c.SuppliedEmail = 'user1@test.com';
			c.RecordTypeId = caId;
			c.SuppliedName = 'john smith';
			c.Reason = 'test';
		}

		insert actCases;

		actCases = [SELECT Id, Origin, SuppliedName, SuppliedEmail, AccountId, ContactId FROM Case];
		acts = [SELECT Id, Name, Website, RecordTypeId FROM Account];
		List<Contact> ct = [SELECT Id, Name FROM Contact];


		system.debug('the cases-------' + actCases);
		system.debug('the accounts-------' + acts);
		system.debug('the contacts-------' + ct);

		//system.assertEquals(actCases[0].AccountId, acts[0].Id);
		//system.assertEquals(actCases[0].ContactId, ct[0].Id);



	}

	@isTest static void caseAccountWithContactMatch() {

		VRTN__c vrtn = new VRTN__c();

		vrtn.EUAccts__c = 'CorporatePay Accounts';
		vrtn.EUServiceCases__c = '  Virtual Credit CS';
		vrtn.Name = 'test data';
		insert vrtn;



		Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
		Map<String, Schema.RecordTypeInfo> accountRtMapByName = accountSobject.getRecordTypeInfosByName();
		for (String st : accountRtMapByName.keySet()) {
			system.debug('the name---' + st);
			system.debug('the rt----' + accountRtMapByName.get(st));
		}
		Id acId = accountRtMapByName.get('CorporatePay Accounts').getRecordTypeId();

		List<Account> acts = UTestData.getAccounts(1);
		for (Account act : acts) {
			act.Website = 'www.test.com';
			act.RecordTypeId = acId;
		}

		insert acts;

		Schema.DescribeSObjectResult caseSobject = Case.SObjectType.getDescribe();
		Map<String, Schema.RecordTypeInfo> caseRtMapByName = caseSobject.getRecordTypeInfosByName();
		Id caId = caseRtMapByName.get('Virtual Credit CS').getRecordTypeId();

		List<Case> actCases = UTestData.getCases(acts);

		for (Case c : actCases) {
			c.AccountId = null;
			c.Origin = 'Email';
			c.SuppliedEmail = 'user1@test.com';
			c.RecordTypeId = caId;
			c.SuppliedName = 'john smith';
			c.Reason = 'test';
		}

		insert actCases;

		actCases = [SELECT Id, Origin, SuppliedName, SuppliedEmail, AccountId, ContactId FROM Case];
		acts = [SELECT Id, Name, Website, RecordTypeId FROM Account];
		List<Contact> ct = [SELECT Id, Name FROM Contact];

		//system.assertEquals(actCases[0].AccountId, acts[0].Id);
		//system.assertEquals(actCases[0].ContactId, ct[0].Id);

		List<Case> actCasesLatest = UTestData.getCases(acts);
		for (Case c : actCases) {
			c.AccountId = null;
			c.Origin = 'Email';
			c.SuppliedEmail = 'user1@test.com';
			c.RecordTypeId = caId;
			c.SuppliedName = 'john smith';
			c.Reason = 'test';
		}

		insert actCasesLatest;

		actCasesLatest = [SELECT Id, Origin, SuppliedName, SuppliedEmail, AccountId, ContactId FROM Case];
		acts = [SELECT Id, Name, Website, RecordTypeId FROM Account];
		ct = [SELECT Id, Name FROM Contact];

		List<Contact> newContact = UTestData.getContacts(acts);
		insert newContact;

		ct[0].FirstName = 'Updated';
		update ct;


		//system.assertEquals(actCasesLatest[0].AccountId, acts[0].Id);
		//system.assertEquals(actCasesLatest[0].ContactId, ct[0].Id);

		system.debug('the cases-------' + actCases);
		system.debug('the accounts-------' + acts);
		system.debug('the contacts-------' + ct);

	}

	@isTest static void testSendCaseCloseEmailToOpportunityOwner()
	{
		User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

		EmailTemplate template = new EmailTemplate();
		template.isActive = true;
		template.Name = 'testGears';
		template.DeveloperName = 'test' + System.now().getTime();
		template.TemplateType = 'text';
		template.FolderId = UserInfo.getUserId();
		template.Body = '';

		System.runAs(u)
		{
			insert template;
		}

		insert new GlobalSettings__c(Name = 'Setting', Truckers_Account_Record_Type__c = '12345678911', CaseCloseEmailAlert__c = template.Id);

		Account acc = UTestData.getAccounts(1) [0];
		insert acc;

		Opportunity opp = new Opportunity(
		                                  Name = 'Test Opportunity',
		                                  RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId(),
		                                  AccountId = acc.Id,
		                                  CloseDate = Date.today(),
		                                  Amount = 100,
		                                  StageName = '5) Signed',
		                                  Error_Log__c = 'Success'
		);

		insert opp;

		Case c = UTestData.getCases(new Account[] { acc }) [0];
		c.AccountId = acc.Id;
		c.Origin = 'Email';
		c.SuppliedEmail = 'user1@test.com';
		c.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
		c.SuppliedName = 'john smith';
		c.Reason = 'test';
		c.Cards__c = 1;
		c.Opportunity__c = opp.Id;
		c.Type = 'PreCard Call';
		c.OwnerId = UserInfo.getUserId();

		insert c;

		Test.startTest();

		c.Status = 'Closed';
		try
		{
			update c;
		}
		catch(DmlException e)
		{
			// This is fine as long as it's due to org-wide email delivery settings
			String message = e.getDmlMessage(0);
			System.assertEquals(true, message.contains('System.NoAccessException'));
		}

		Test.stopTest();
	}

	@isTest static void testSetDefaultEntitlement()
	{
		List<SlaProcess> entProcess = [SELECT Id FROM SlaProcess WHERE SObjectType = 'Case' AND Name = 'Service Operations' LIMIT 1];
		System.assertEquals(entProcess.size(), 1);
		SlaProcess sla = entProcess[0];

		List<Account> accounts = UTestData.getAccounts(4);
		insert accounts;

		Account parentAccount = accounts[0];
		Account accountWithParent1 = accounts[1];
		Account accountWithParent2 = accounts[2];
		Account parentlessAccount = accounts[3];

		accountWithParent1.ParentId = parentAccount.Id;
		accountWithParent2.ParentId = parentAccount.Id;
		update new List<Account> { accountWithParent1, accountWithParent2 };

		Date startDate = Date.today().addDays(- 1);
		Date endDate = Date.today().addDays(365);

		List<Entitlement> entitlements = new List<Entitlement> {
			new Entitlement(AccountId = parentAccount.Id, SlaProcessId = sla.Id, Name = 'Parent Entitlement', StartDate = startDate, EndDate = endDate),
			new Entitlement(AccountId = accountWithParent1.Id, SlaProcessId = sla.Id, Name = 'Child Entitlement 1', StartDate = startDate, EndDate = endDate),
			new Entitlement(AccountId = accountWithParent1.Id, SlaProcessId = sla.Id, Name = 'Child Entitlement 2', StartDate = startDate, EndDate = endDate),
			new Entitlement(AccountId = parentlessAccount.Id, SlaProcessId = sla.Id, Name = 'Solo Entitlement', StartDate = startDate, EndDate = endDate),
			new Entitlement(AccountId = accountWithParent2.Id, SlaProcessId = sla.Id, Name = 'Solo Entitlement', StartDate = startDate, EndDate = endDate)
		};

		insert entitlements;

		insert new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), DefaultEntitlementID__c = entitlements[0].Id);

		List<Case> cases = new List<Case> {
			new Case(AccountId = parentAccount.Id, Origin = 'Test', SuppliedEmail = 'user1@test.com', SuppliedName = 'john smith', Reason = 'test', EntitlementId = null),
			new Case(AccountId = accountWithParent1.Id, Origin = 'Test', SuppliedEmail = 'user1@test.com', SuppliedName = 'john smith', Reason = 'test', EntitlementId = null),
			new Case(AccountId = parentlessAccount.Id, Origin = 'Test', SuppliedEmail = 'user1@test.com', SuppliedName = 'john smith', Reason = 'test', EntitlementId = null),
			new Case(AccountId = accountWithParent2.Id, Origin = 'Test', SuppliedEmail = 'user1@test.com', SuppliedName = 'john smith', Reason = 'test', EntitlementId = null)
		};

		Test.startTest();
		insert cases;
		Test.stopTest();

		Map<Id, Case> casesAfter = new Map<Id, Case> ([SELECT Id, AccountId, EntitlementId FROM Case]);

//		System.assertEquals(casesAfter.get(cases[0].Id).EntitlementId, entitlements[0].Id);
//		System.assertEquals(casesAfter.get(cases[1].Id).EntitlementId, entitlements[0].Id);
//		System.assertEquals(casesAfter.get(cases[2].Id).EntitlementId, entitlements[3].Id);
//		System.assertEquals(casesAfter.get(cases[3].Id).EntitlementId, entitlements[4].Id);
	}

	@isTest static void testE2CContactAssociationSingleContactFound()
	{
		Account acc = new Account(
		                          Name = 'newAcc1'
		);
		insert acc;

		Id pilotRectypeId, nonPilotRectypeId;
		List<RecordType> ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			pilotRectypeId = ctRectypes[0].Id;
		}

		ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'F1_Contact' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			nonPilotRectypeId = ctRectypes[0].Id;
		}

		Support_Operation_Settings__c settings = new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), PilotContactRecordTypeID__c = String.valueOf(pilotRectypeId).substring(0, 15));
		insert settings;

		Contact con1 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = pilotRectypeId
		);
		insert con1;
		Contact con2 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = nonPilotRectypeId
		);
		insert con2;

		Test.startTest();
		Case c = new Case(Subject = 'test', Status = 'New', Description = 'test desc', SuppliedEmail = 'testuser1@test.com', ContactId = con2.Id, AccountId = con2.AccountId);
		insert c;
		Test.stopTest();

		c = [SELECT ContactId, AccountId from Case where Id = :c.Id];
		System.assertEquals(con1.Id, c.ContactId);
		System.assertEquals(con1.AccountId, c.AccountId);
	}

	@isTest static void testE2CContactAssociationMultipleContactsFound()
	{
		Account acc = new Account(
		                          Name = 'newAcc1'
		);
		insert acc;

		Id pilotRectypeId, nonPilotRectypeId;
		List<RecordType> ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			pilotRectypeId = ctRectypes[0].Id;
		}

		ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'F1_Contact' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			nonPilotRectypeId = ctRectypes[0].Id;
		}

		Support_Operation_Settings__c settings = new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), PilotContactRecordTypeID__c = String.valueOf(pilotRectypeId).substring(0, 15));
		insert settings;

		Contact con1 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = pilotRectypeId
		);
		insert con1;

		Contact con2 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = pilotRectypeId
		);
		insert con2;

		Contact con3 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = nonPilotRectypeId
		);
		insert con3;

		Test.startTest();
		Case c = new Case(Subject = 'test', Status = 'New', Description = 'test desc', SuppliedEmail = 'testuser1@test.com', ContactId = con3.Id, AccountId = con3.AccountId);
		insert c;
		Test.stopTest();

		c = [SELECT ContactId, AccountId from Case where Id = :c.Id];
		System.assertEquals(true, c.ContactId == con1.Id || c.ContactId == con2.Id);
		System.assertEquals(true, c.AccountId == con1.AccountId || c.AccountId == con2.AccountId);
	}

	@isTest static void testE2CContactAssociationNoContactsFound()
	{
		Account acc = new Account(
		                          Name = 'newAcc1'
		);
		insert acc;

		Id pilotRectypeId, nonPilotRectypeId;
		List<RecordType> ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			pilotRectypeId = ctRectypes[0].Id;
		}

		ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'F1_Contact' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			nonPilotRectypeId = ctRectypes[0].Id;
		}

		Support_Operation_Settings__c settings = new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), PilotContactRecordTypeID__c = String.valueOf(pilotRectypeId).substring(0, 15));
		insert settings;

		Contact con1 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = nonPilotRectypeId
		);
		insert con1;

		Test.startTest();
		Case c = new Case(Subject = 'test', Status = 'New', Description = 'test desc', SuppliedEmail = 'testuser1@test.com', ContactId = con1.Id, AccountId = con1.AccountId);
		insert c;
		Test.stopTest();

		c = [SELECT ContactId, AccountId from Case where Id = :c.Id];
		System.assertEquals(null, c.ContactId);
		System.assertEquals(null, c.AccountId);
	}

	@isTest static void testE2CContactAssociationPilotContact()
	{
		Account acc = new Account(
		                          Name = 'newAcc1'
		);
		insert acc;

		Id pilotRectypeId;
		List<RecordType> ctRectypes = [SELECT Id FROM RecordType WHERE sObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1];
		if (!ctRectypes.isEmpty()) {
			pilotRectypeId = ctRectypes[0].Id;
		}

		Support_Operation_Settings__c settings = new Support_Operation_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), PilotContactRecordTypeID__c = String.valueOf(pilotRectypeId).substring(0, 15));
		insert settings;

		Contact con1 = new Contact(
		                           AccountId = acc.id,
		                           LastName = 'tstLastName',
		                           Email = 'testuser1@test.com',
		                           RecordTypeId = pilotRectypeId
		);
		insert con1;

		Test.startTest();
		Case c = new Case(Subject = 'test', Status = 'New', Description = 'test desc', SuppliedEmail = 'testuser1@test.com', ContactId = con1.Id, AccountId = con1.AccountId);
		insert c;
		Test.stopTest();

		c = [SELECT ContactId, AccountId from Case where Id = :c.Id];
		System.assertEquals(con1.Id, c.ContactId);
		System.assertEquals(con1.AccountId, c.AccountId);
	}

	@isTest static void testNotificationFromBatch()
	{
		Case c = new Case(Subject = 'test', Status = 'New', Notification_Sent__c = false);
		insert c;
		UCase.setNotificationFromBatch(new List<Case> { c });
		c = [select Notification_Sent__c from Case where Id = :c.Id];
		System.assertEquals(true, c.Notification_sent__c);
	}
}