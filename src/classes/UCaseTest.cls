@isTest
private class UCaseTest {

	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}

	@isTest
	static void testShellEntitlementCase(){
		Account auxAccount = new Account();
		auxAccount.Name = 'Test';
		insert auxAccount;

		Entitlement auxEntitlementWeek = new Entitlement();
		auxEntitlementWeek.Name = 'Shell SLA';
		auxEntitlementWeek.AccountId = auxAccount.ID;
		insert auxEntitlementWeek;

		Entitlement auxEntitlementWeekEnd = new Entitlement();
		auxEntitlementWeekEnd.Name = 'Shell SLA Weekend';
		auxEntitlementWeekEnd.AccountId = auxAccount.ID;
		insert auxEntitlementWeekEnd;

		Test.startTest();
		Case auxCase = new Case();
		//auxCase.SuppliedEmail = 'test@shell.com';
		auxCase.Program_Email__c = 'Shellfleethelp@wexinc.com';
		insert auxCase;
		Test.stopTest();
	}

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

//    System.assertEquals(casesAfter.get(cases[0].Id).EntitlementId, entitlements[0].Id);
//    System.assertEquals(casesAfter.get(cases[1].Id).EntitlementId, entitlements[0].Id);
//    System.assertEquals(casesAfter.get(cases[2].Id).EntitlementId, entitlements[3].Id);
//    System.assertEquals(casesAfter.get(cases[3].Id).EntitlementId, entitlements[4].Id);
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

    /**
    * Created by mbickford on 10/11/2018.
    * 'Borrowed' by sschmidt on 6/14/2019.
     */
    @IsTest
    static void testBehavior() {

        final String caseWithSurveySummary = 'EmailMessageTriggerTest Test Case';
        final String caseWithoutSurveySummary = 'EmailMessageTriggerTest Test Case Without Survey';

        testSetup();

        insert new EmailMessageSettings__c(ActivateEmailMessageInsertTrigger__c = true);
        EmailMessage message = new EmailMessage();

        Case caseWithSurvey = [SELECT Id, RecordTypeId, AccountId , Subject, ContactId, Service_Program_Survey_Sent__c, Service_Survey_Transactional_link__c, SurveyInclusionText__c, SurveyInclusionHTML__c FROM Case WHERE Subject = :caseWithSurveySummary];

        Contact caseContact =[SELECT Id, Email FROM Contact WHERE Id = :caseWithSurvey.ContactId];

        EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();

        if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
            System.debug('ActivateEmailMessageInsertTrigger__c = false');
        } else {
            System.debug('ActivateEmailMessageInsertTrigger__c = true');
        }

        System.debug('Case ID = '+caseWithSurvey.Id);
        System.debug('CaseRecordType ID = '+caseWithSurvey.RecordTypeId);
        System.debug('Case survey link='+caseWithSurvey.Service_Survey_Transactional_link__c);
        System.debug('Case inclusion HTML='+caseWithSurvey.SurveyInclusionHTML__c);

        System.assert(caseWithSurvey.SurveyInclusionText__c != null, 'Null survey inclusion text');

        message.FromAddress = 'mark_bickford@wrightexpress.com';
        message.ParentId = caseWithSurvey.Id;
        message.Subject = 'Test message';
        message.ToAddress = 'sara.schmidt@wexinc.com';
        message.HtmlBody = 'This is a test message.<br/><br/>'+caseWithSurvey.SurveyInclusionHTML__c;
        message.TextBody = 'This is a test message.\n\n'+caseWithSurvey.SurveyInclusionText__c;
        message.Status = '3';

        insert message;

        List<Case> results = [SELECT Id, Service_Program_Survey_Sent__c FROM Case WHERE Id= :caseWithSurvey.Id];

        Case resultCase = results[0];

        System.debug('Survey was marked as sent: '+resultCase.Service_Program_Survey_Sent__c);

        System.assert(resultCase.Service_Program_Survey_Sent__c == true, 'Survey was not marked as sent');

    }

    @IsTest
    static void testNoTriggerBehavior() {

        final String caseWithSurveySummary = 'EmailMessageTriggerTest Test Case';
        final String caseWithoutSurveySummary = 'EmailMessageTriggerTest Test Case Without Survey';

        testSetup();
        insert new EmailMessageSettings__c(ActivateEmailMessageInsertTrigger__c = false);

        EmailMessage message = new EmailMessage();

        Case caseWithoutSurvey = [SELECT Id, RecordTypeId, AccountId , Subject, ContactId, Service_Program_Survey_Sent__c, Service_Survey_Transactional_link__c, SurveyInclusionText__c, SurveyInclusionHTML__c FROM Case WHERE Subject = :caseWithoutSurveySummary];

        Contact caseContact =[SELECT Id, Email FROM Contact WHERE Id = :caseWithoutSurvey.ContactId];

        EmailMessageSettings__c EMS = EmailMessageSettings__c.getOrgDefaults();

        if(EMS.ActivateEmailMessageInsertTrigger__c == false) {
            System.debug('ActivateEmailMessageInsertTrigger__c = false');
        } else {
            System.debug('ActivateEmailMessageInsertTrigger__c = true');
        }

        System.debug('Case ID = '+ caseWithoutSurvey.Id);
        System.debug('CaseRecordType ID = '+ caseWithoutSurvey.RecordTypeId);
        System.debug('Case survey link='+ caseWithoutSurvey.Service_Survey_Transactional_link__c);
        System.debug('Case inclusion HTML='+ caseWithoutSurvey.SurveyInclusionHTML__c);

        System.assert(caseWithoutSurvey.SurveyInclusionText__c != null, 'Null survey inclusion text');

        message.FromAddress = 'mark_bickford@wrightexpress.com';
        message.ParentId = caseWithoutSurvey.Id;
        message.Subject = 'Test message';
        message.ToAddress = 'sara.schmidt@wexinc.com';
        message.HtmlBody = 'This is a test message.<br/><br/>'+ caseWithoutSurvey.SurveyInclusionHTML__c;
        message.TextBody = 'This is a test message.\n\n'+ caseWithoutSurvey.SurveyInclusionText__c;
        message.Status = '3';

        insert message;

        List<Case> results = [SELECT Id, Service_Program_Survey_Sent__c FROM Case WHERE Id= :caseWithoutSurvey.Id];

        Case resultCase = results[0];

        System.debug('Survey was marked as sent: '+resultCase.Service_Program_Survey_Sent__c);

        System.assert(resultCase.Service_Program_Survey_Sent__c == false, 'Survey was marked as sent');

    }
    static void testSetup() {

        final String caseWithSurveySummary = 'EmailMessageTriggerTest Test Case';
        final String caseWithoutSurveySummary = 'EmailMessageTriggerTest Test Case Without Survey';

        RecordType caseRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Case' AND RecordType.DeveloperName = 'Service_Operations')];
        RecordType acctRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Account' AND RecordType.DeveloperName = 'Service_Operations')];
        RecordType contactRecordType = [SELECT Id FROM RecordType WHERE (SobjectType = 'Contact' AND RecordType.DeveloperName = 'Service_Operations')];

        insert new ServiceOperationsSurveySettings__c (Survey_Text__c='>>>> Your satisfaction is important to us. We would appreciate it if you could take the time to complete a short survey.',Survey_Text_Plaintext_Extension__c=' Please share your feedback by clicking the following link: ');

        Program__c wexProgram = new Program__c();
        wexProgram.Name = 'Test WEX Program';
        wexProgram.Send_CS_Satisfaction_Surveys__c = true;

        insert wexProgram;

        System.debug('wexProgram ID: '+wexProgram.Id);


        Account wexAccount = new Account();
        wexAccount.RecordType = acctRecordType;
        wexAccount.Wex_Account__c = '9100000000000';
        wexAccount.Acct_Row_Id__c = '12-AAAA-345';
        wexAccount.Name = 'Test Wex Account';
        wexAccount.Status__c = 'Active';
        wexAccount.Program__c = wexProgram.Id;


        insert wexAccount;

        System.debug('wexAccount ID: '+wexAccount.Id);

        Contact contact = new Contact();
        contact.RecordType = contactRecordType;
        contact.FirstName = 'Mark';
        contact.LastName = 'Bickford';
        contact.Email = 'mark.bickford@wexinc.com';
        contact.Account = wexAccount;
        contact.Status__c = 'Active';

        insert contact;

        System.debug('contact ID: '+contact.Id);

        Case caseWithSurvey;

        caseWithSurvey = new Case();
        caseWithSurvey.RecordTypeId = caseRecordType.Id;
        caseWithSurvey.AccountId = wexAccount.Id;
        caseWithSurvey.Subject = caseWithSurveySummary;
        caseWithSurvey.ContactId = contact.Id;
        caseWithSurvey.Service_Program_Survey_Sent__c = false;

        insert caseWithSurvey;

        System.debug('caseWithSurvey ID: '+caseWithSurvey.Id);
        System.debug('caseRecordType ID: '+caseRecordType.Id);

        Case caseWithoutSurvey;

        caseWithoutSurvey = new Case();
        caseWithoutSurvey.RecordTypeId = caseRecordType.Id;
        caseWithoutSurvey.AccountId = wexAccount.Id;
        caseWithoutSurvey.Subject = caseWithoutSurveySummary;
        caseWithoutSurvey.ContactId = contact.Id;
        caseWithoutSurvey.Service_Program_Survey_Sent__c = false;

        insert caseWithoutSurvey;

        System.debug('caseWithoutSurvey ID: '+caseWithoutSurvey.Id);
        System.debug('caseRecordType ID: '+caseRecordType.Id);

    }
}
