@isTest
private class ConvertLeadControllerTests
{
	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}

	//Tests lead convert with no opp or task
	static testMethod void test1()
	{
		Integer testNumber = 1;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		insert leads;

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

		Lead l = leads[0];

		ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

		controller.ConvertedStatus = settings.Lead_Converted_Status__c;

		// Start code touches
		String s1 = controller.getDebugx();
		String s2 = controller.getContactNo();
		controller.setContactNo('2');
		String s3 = controller.getContactNo();
		List<SelectOption> options1 = controller.getFoundAccounts();
		List<SelectOption> options2 = controller.getFoundContacts();
		PageReference pr1 = controller.processAccountChange();
		PageReference pr2 = controller.processContactChange();
		//PageReference pr3 = controller.changeProbability();
		//End code touches
		controller.processChange();

		controller.convertAndJumpToContact();

		if(ApexPages.hasMessages())
		{
			System.debug('### ' + ApexPages.getMessages());
		}

		leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

		List<Account> accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 3));

		List<Contact> contacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, contacts.size(), UTestData.getAssertMessage(testNumber, 4));
	}

	//Tests lead convert with opp and no task
	static testMethod void test2()
	{
		Integer testNumber = 2;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		insert leads;

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

		Lead l = leads[0];

		ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

		controller.ConvertedStatus = settings.Lead_Converted_Status__c;
		//controller.showHideOpportunity();

		//Call showHideOpportunity a second time if it is false due to custom settings
		/*if(controller.CreateOpportunity == false)
        {
          controller.showHideOpportunity();
        }*/

		//controller.convertAndJumpToContact();

		controller.OpportunityRecord.Name = 'Test Opportunity ' + UTestData.getTimestamp(null);
		controller.OpportunityRecord.StageName = 'New';
		controller.OpportunityRecord.Probability = 15;
		controller.OpportunityRecord.Amount = 1.00;

		controller.convertAndJumpToContact();

		if(ApexPages.hasMessages())
		{
			System.debug('### ' + ApexPages.getMessages());
		}

		leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

		List<Account> accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 3));

		List<Contact> contacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, contacts.size(), UTestData.getAssertMessage(testNumber, 4));

		List<Opportunity> opps = [select Id from Opportunity where AccountId = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, opps.size(), UTestData.getAssertMessage(testNumber, 5));

		/*List<OpportunityContactRole> oppContactRoles = [select Id from OpportunityContactRole where OpportunityId = :opps[0].Id];

        System.assertEquals(numberOfLeads, oppContactRoles.size(), UTestData.getAssertMessage(testNumber, 6));*/
	}

	//Tests lead convert with opp and task
	/*static testMethod void test3()
     {
       Integer testNumber = 3;

         ConvertLeadController.createSettings();

         ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

         Integer numberOfLeads = 1;

         List<Lead> leads = UTestData.getLeads(numberOfLeads);

         insert leads;

     leads = [select Id from Lead where id in :leads];

     System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

     Lead l = leads[0];

     ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

     controller.ConvertedStatus = settings.Lead_Converted_Status__c;
     //controller.showHideOpportunity();

     controller.OpportunityRecord.Name = 'Test Opportunity ' + UTestData.getTimestamp(null);
     controller.OpportunityRecord.StageName = 'New';
     controller.OpportunityRecord.Probability = 15;
     controller.OpportunityRecord.Amount = 1.00;

     Date activityDate = Date.today().addDays(3);

     controller.showHideTask();

     controller.TaskRecord.Subject = 'TEST';
     controller.TaskRecord.Status = 'Not Started';
     controller.TaskRecord.ActivityDate = activityDate;
     controller.TaskRecord.Description = 'Test Task';
     controller.AddReminder = true;
     controller.ReminderTime = '11:00 AM';
     controller.TempTaskRecord.ActivityDate = activityDate;

     controller.convertAndJumpToContact();

     if(ApexPages.hasMessages())
     {
       System.debug('### ' + ApexPages.getMessages());
     }

     leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true];

     System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

     List<Account> accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

     System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 3));

     List<Contact> contacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

     System.assertEquals(numberOfLeads, contacts.size(), UTestData.getAssertMessage(testNumber, 4));

     List<Opportunity> opps = [select Id from Opportunity where AccountId = :leads[0].ConvertedAccountId];

     System.assertEquals(numberOfLeads, opps.size(), UTestData.getAssertMessage(testNumber, 5));

     /*List<OpportunityContactRole> oppContactRoles = [select Id from OpportunityContactRole where OpportunityId = :opps[0].Id];

     System.assertEquals(numberOfLeads, oppContactRoles.size(), UTestData.getAssertMessage(testNumber, 6));*/

	//List<Task> tasks = [select Id from Task where WhatId = :opps[0].Id and WhoId = :contacts[0].Id];

	//System.assertEquals(numberOfLeads, tasks.size(), UTestData.getAssertMessage(testNumber, 7));
	//}
	/*
  //Tests lead convert with task and no opp
    static testMethod void test4()
    {
      Integer testNumber = 4;

        ConvertLeadController.createSettings();

        ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

        Integer numberOfLeads = 1;

        List<Lead> leads = UTestData.getLeads(numberOfLeads);

        insert leads;

    leads = [select Id from Lead where id in :leads];

    System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

    Lead l = leads[0];

    ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

    controller.ConvertedStatus = settings.Lead_Converted_Status__c;

    Date activityDate = Date.today().addDays(3);

    controller.showHideTask();

    //Call showHideTask a second time if it is false due to custom settings
    if(controller.CreateTask == false)
    {
      controller.showHideTask();
    }

    //controller.convertAndJumpToContact();

    controller.TaskRecord.Subject = 'TEST';
    controller.TaskRecord.Status = 'Not Started';
    controller.TaskRecord.ActivityDate = activityDate;
    controller.TaskRecord.Description = 'Test Task';
    controller.AddReminder = true;
    controller.ReminderTime = '11:00 AM';
    controller.TempTaskRecord.ActivityDate = activityDate;

    controller.convertAndJumpToContact();

    if(ApexPages.hasMessages())
    {
      System.debug('### ' + ApexPages.getMessages());
    }

    leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true];

    System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

    List<Account> accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

    System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 3));

    List<Contact> contacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

    System.assertEquals(numberOfLeads, contacts.size(), UTestData.getAssertMessage(testNumber, 4));

    List<Task> tasks = [select Id from Task where WhoId = :contacts[0].Id];

    System.assertEquals(numberOfLeads, tasks.size(), UTestData.getAssertMessage(testNumber, 7));
    }
    */
	//Tests lead convert with no opp or task but matching account
	/*static testMethod void test5()
	{
		Integer testNumber = 5;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Account> accounts = UTestData.getAccounts(numberOfLeads);
		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		if(accounts.size() == leads.size())
		{
			for(Integer i = 0; i < leads.size(); i++)
			{
				accounts[i].Name = leads[i].Company;
			}
		}

		insert accounts;
		insert leads;

		accounts = [select Id from Account where id in :accounts];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 1));

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

		Lead l = leads[0];

		ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

		controller.ConvertedStatus = settings.Lead_Converted_Status__c;

		controller.convertAndJumpToContact();

		if(ApexPages.hasMessages())
		{
			System.debug('### ' + ApexPages.getMessages());
		}

		leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true and ConvertedAccountId = :accounts[0].Id];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 3));

		accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 4));

		List<Contact> contacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, contacts.size(), UTestData.getAssertMessage(testNumber, 5));
	}*/

	//Test cancel
	static testMethod void test6()
	{
		Integer testNumber = 6;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		insert leads;

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

		Lead l = leads[0];

		ApexPages.StandardController standardController = new ApexPages.StandardController(l);

		ConvertLeadController controller = new ConvertLeadController(standardController);

		standardController.cancel();
	}

	//Tests lead convert with no opp or task but matching account and contact
	//** new -phillip
	/*static testMethod void test7()
	{
		Integer testNumber = 7;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Account> accounts = UTestData.getAccounts(numberOfLeads);

		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		if(accounts.size() == leads.size())
		{
			for(Integer i = 0; i < leads.size(); i++)
			{
				accounts[i].Name = leads[i].Company;
			}
		}


		insert accounts;
		//insert leads;

		accounts = [select Id from Account where id in :accounts];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 1));

		//**
		List<Contact> contacts = UTestData.getContacts(accounts, numberofleads);
		/*if(contacts.size() == leads.size())
            {
              for(Integer i = 0; i < leads.size(); i++)
              {
                contacts[i].FirstName = leads[i].FirstName;
                contacts[i].LastName = leads[i].LastName;
              }
            }*/
		/*insert contacts;

		leads[0].Related_Account__c = accounts[0].Id;
		//insert leads;

		contacts = [select Id from Contact where id in :contacts];
		system.assertequals(numberofleads,contacts.size(),utestdata.getassertmessage(testnumber,1));

		leads[0].Related_Contact__c = contacts[0].Id;
		insert leads;
		//**

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 2));

		Lead l = leads[0];

		ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

		controller.ConvertedStatus = settings.Lead_Converted_Status__c;

		controller.SendEmailToOwner = true;
		PageReference pr1 = controller.processAccountChange();
		PageReference pr2 = controller.processContactChange();
		//controller.convertAndJumpToContact();
		controller.convertAndJumpToOpp();

		if(ApexPages.hasMessages())
		{
			System.debug('### ' + ApexPages.getMessages());
		}

		leads = [select Id, ConvertedAccountId, ConvertedContactId from Lead where id = :l.Id and IsConverted = true and ConvertedAccountId = :accounts[0].Id];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 3));

		accounts = [select Id from Account where Id = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, accounts.size(), UTestData.getAssertMessage(testNumber, 4));

		List<Contact> convertedcontacts = [select Id from Contact where Id = :leads[0].ConvertedContactId and AccountId = :leads[0].ConvertedAccountId];

		System.assertEquals(numberOfLeads, convertedcontacts.size(), UTestData.getAssertMessage(testNumber, 5));
	}*/


	/*static testmethod void test8() {

		Integer testNumber = 1;

		ConvertLeadController.createSettings();

		ConvertLeadSettings__c settings = ConvertLeadSettings__c.getInstance();

		Integer numberOfLeads = 1;

		List<Lead> leads = UTestData.getLeads(numberOfLeads);

		insert leads;

		leads = [select Id from Lead where id in :leads];

		System.assertEquals(numberOfLeads, leads.size(), UTestData.getAssertMessage(testNumber, 1));

		Lead l = leads[0];

		ConvertLeadController controller = new ConvertLeadController(new ApexPages.StandardController(l));

		controller.ConvertedStatus = settings.Lead_Converted_Status__c;

		// Start code touches
		String s1 = controller.getDebugx();
		String s2 = controller.getContactNo();
		controller.setContactNo('2');
		String s3 = controller.getContactNo();
		List<SelectOption> options1 = controller.getFoundAccounts();
		List<SelectOption> options2 = controller.getFoundContacts();

		User user= TestDatatUtility.createUser();

		Account acc = TestDatatUtility.getAccount();
		acc.Temporary_Credit_Expire_Date__c = system.today();
		acc.Temporary_Credit_Limit__c = 123;
		acc.Temporary_Credit_Reason__c = 'ABC';
		insert acc;

		Contact con = TestDatatUtility.getContact();
		con.ownerId = user.id;
		con.AccountId = acc.Id;
		insert con;

		controller.existingAccountId = acc.Id;
		PageReference pr2 = controller.processAccountChange();
		controller.existingContactId = con.Id;
		PageReference pr1 = controller.processContactChange();


		ConvertLeadController.ConvertDestination cdn1 = ConvertLeadController.ConvertDestination.ACCOUNT;
		ConvertLeadController.ConvertDestination cdn2 = ConvertLeadController.ConvertDestination.OPPORTUNITY;
		ConvertLeadController.ConvertDestination cdn3 = ConvertLeadController.ConvertDestination.CONTACT;

	}*/
}