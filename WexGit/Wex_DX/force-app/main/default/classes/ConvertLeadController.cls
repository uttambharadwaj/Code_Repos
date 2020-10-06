/*
  Created By: Unknown
  Created On: Unknown
  Description: Controller to support the ConvertLead page. 
  NOTE: The usage of creating the opp via the ConvertLead class by SF was removed since it was not setting all of the values as expected.
  Resolved the issue by creating and managing the opp manually. This does mean that the ConvertedOpportunityId does not get set as well. 
 
  Last Modified By: Jason McCormack (GearsCRM)
  Last Modified On: 2012-02-14
  Notes Regarding Modification: Make changes to accommodate forcing a lead to convert into an existing account/contact
  When the lead has a values for Related_Account__c and/or Related_Contact__c.
  Also did some cleanup and refactoring to make the code more maintainable.
 
 
  Last Modified By: Raja Yeccherla (GearsCRM)
  Last Modified On: 2015-04-08
  Notes Regarding Modification: The Search/Lookup icon next to Contact Name is looking in Fleet Card Programs.  
  This lookup changed to Contacts.                             
 
 
 
*/
public class ConvertLeadController
{
	private ApexPages.StandardController controller;
	private Map<String, OpportunityStage> stageNameToOppStageMap;

	public ConvertLeadSettings__c Settings { get; private set; }

	//public Boolean disableAccountFields { get; private set;}
	//public Boolean disableContactFields { get; private set;}
	public Lead LeadRecord { get; private set; }
	public Opportunity OpportunityRecord { get; private set; }
	public Account AccountRecord { get; private set; }
	public Contact ContactRecord { get; private set; }
	public Task TaskRecord { get; private set; }
	public Task TempTaskRecord { get; private set; } //Used as a data store object
	//public OpportunityContactRole ocr {get; set;}
	public List<SelectOption> Stages { get; private set; }
	public List<SelectOption> foundAccounts;
	public List<SelectOption> foundContacts;
	public List<SelectOption> ReminderTimes { get; private set; }
	public String ReminderTime { get; set; }
	public String existingAccountId { get; set; }
	public String existingContactId { get; set; }
	public List<SelectOption> taskPriorities { get; set; }
	//public String taskPriority {get; set;}
	public String ConvertedStatus { get; set; }
	public List<SelectOption> ConvertedStatuses { get; set; }
	//public Boolean CreateOpportunity {get; set;}
	public Boolean DoNotCreateOpportunity { get; set; }
	public Boolean CreateTask { get; set; }
	public Boolean SelectAccount { get; set; }
	public Boolean SelectContact { get; set; }
	public String temp_acclkid_lkold { get; set; }
	public String temp_acclkid_lktp { get; set; }
	public String temp_acclkid_lspf { get; set; }
	public String temp_acclkid_mod { get; set; }
	public String temp_acclkid_onpk { get; set; }
	public String temp_conlkid_lkold { get; set; }
	public String temp_conlkid_lktp { get; set; }
	public String temp_conlkid_lspf { get; set; }
	public String temp_conlkid_mod { get; set; }
	public String temp_conlkid_onpk { get; set; }
	public String TempOppName;
	public String Contact_Email { get; set; }
	public boolean isContactEmailMatch { get; set; }
	public String debugx;
	public string ContactNo;
	public Boolean SendEmailToOwner { get; set; }
	public Boolean AddReminder { get; set; }
	//public Integer Probability {get; set;}
	//public String Stage {get; set;}
	public Boolean ShowStageError { get; set; }
	public Boolean referralAcctConvert { get; set; }

	public String GetContactNo()
	{
		if (foundContacts.size() > 1)
		{
			return '1';
		}
		else
		{
			return '2';
		}
	}

	public void setContactNo(String val)
	{
		ContactNo = val;
	}

	public static void createSettings()
	{
		ConvertLeadSettings__c cls = new ConvertLeadSettings__c();

		cls.Task_Priority__c = 'Normal';

		String convertedStatusValue = null;

		List<LeadStatus> convertedLeadStatusValues = [select Id, MasterLabel from LeadStatus where IsConverted = True order by SortOrder asc limit 1];

		if (convertedLeadStatusValues.size() == 1)
		{
			convertedStatusValue = convertedLeadStatusValues[0].MasterLabel;
		}

		cls.Lead_Converted_Status__c = convertedStatusValue;

		try
		{
			insert cls;
		}
		catch(DmlException e)
		{
			System.debug('EXCEPTION: ' + e);
		}
	}

	public ConvertLeadController(ApexPages.StandardController controller)
	{
		this.settings = ConvertLeadSettings__c.getInstance();
		this.ReminderTimes = UGears.UDateTime.getTimeOptions(null, null, Settings.Reminder_Minutes_Interval__c.intValue(), false);
		//this.ReminderTime = getCurrentTimeSlot(30);   
		this.controller = controller;
		this.LeadRecord = (Lead) controller.getRecord();
		this.ShowStageError = false;
		this.SendEmailToOwner = Settings.Send_Email_To_Owner_Default__c;

		loadStageNameToOppStageMap();
		loadLead();
		disableAccountContactFields();
		loadLeadStatusValues();
		loadAccount();
		loadContact();
		loadOpportunity();
		loadTask();
		setLookupValues();

		debugx = 'nothing yet';
	}

	/*
	  private String getCurrentTimeSlot(Integer intervalInMinutes)
	  {
	  DateTime currentDateTime = DateTime.now();
	  Integer hour = currentDateTime.hour();
	  Integer minute = currentDateTime.minute();
	  Integer timeSlotHour = hour.addHours(1);
	  Integer timeSlotMinutes = intervalInMinutes; //hour.addMinutes(1);
	  Integer timeSlots = (60 / intervalsInMinutes);
	 
	  for(Integer i = 0; i < timeSlots; i++)
	  {
	  Integer currentSlotMinutes = 
	  Integer halfWayPoint = intervalInMinutes / 2;
	 
	  if(minute < timeSlotMinutes)
	  {
	 
	  }
	  else
	  {
	 
	  }
	  }
	  }
	 */

	private void loadStageNameToOppStageMap()
	{
		this.stageNameToOppStageMap = new Map<String, OpportunityStage> ();
		this.Stages = new List<SelectOption> ();

		//Add empty stage value
		Stages.add(UGears.UUI.getEmptySelectOption());

		for (OpportunityStage stage :[Select
		     SortOrder,
		     MasterLabel,
		     IsWon,
		     IsClosed,
		     IsActive,
		     Id,
		     ForecastCategoryName,
		     ForecastCategory,
		     Description,
		     DefaultProbability
		     From
		     OpportunityStage
		     where
		     IsActive = true
		     order by
		     SortOrder])
		{
			String key = stage.MasterLabel.toUpperCase();

			if (stageNameToOppStageMap.containsKey(key) == false)
			{
				stageNameToOppStageMap.put(key, stage);
			}

			Stages.add(new SelectOption(stage.MasterLabel, stage.MasterLabel));
		}
	}

	private void loadLead()
	{
		/*
		  Modified by Trekbin
		  Date: 15 July 2015
		 */
		this.LeadRecord = [select Id, Company, Parent_Lead__c, Parent_Lead__r.Related_Account__c, Parent_Lead__r.i2i_Id__c,
		                   Parent_Lead__r.Related_Account__r.Name, Parent_Lead__r.Related_Contact__c,
		                   Parent_Lead__r.Related_Contact__r.AccountId, Parent_Lead__r.Related_Contact__r.Account.Name,
		                   FirstName, LastName, Email, Status, IsConverted, ConvertedContactId, PostalCode, City, State,
		                   Phone, Ext__c, MobilePhone, Fax, Referring_Account_ID__c, RecordTypeId
		                   from Lead where Id = :this.LeadRecord.Id];

		if (this.LeadRecord == null || this.LeadRecord.IsConverted)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lead does not exist or already converted'));

			return;
		}
	}

	private void loadLeadStatusValues()
	{
		List<String> statusValuesList = new List<String> ();
		if (test.isRunningTest())
		{
			statusValuesList.add('Qualified');
		} else
		{
			statusValuesList = picklistDescriber.describe('Lead', this.LeadRecord.RecordTypeId, 'Status');
		}


		Set<String> statusValues = new Set<String> ();
		List<string> statusValuesReturned = new List<String> ();
		this.convertedStatuses = new List<SelectOption> ();

		//for(LeadStatus ls : [select Id,MasterLabel from LeadStatus where IsConverted = True order by SortOrder asc limit 50])
		for (LeadStatus ls :[select Id, MasterLabel from LeadStatus where IsConverted = True AND MasterLabel IN :statusValuesList order by SortOrder asc limit 50])
		{
			convertedStatuses.add(new SelectOption(ls.MasterLabel, ls.MasterLabel));
			statusValues.add(ls.MasterLabel.trim().toUpperCase());
			statusValuesReturned.add(ls.MasterLabel);
		}

		if (UGears.UString.isNullOrEmpty(Settings.Lead_Converted_Status__c) == false)
		{
			if (statusValues.contains(Settings.Lead_Converted_Status__c.trim().toUpperCase()) == false)
			{
				convertedStatuses.add(new SelectOption(Settings.Lead_Converted_Status__c, Settings.Lead_Converted_Status__c));
			}

			this.ConvertedStatus = Settings.Lead_Converted_Status__c;
		} else
		{
			if (statusValues.isEmpty())
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Lead RecordType does not contain a Converted Status.'));
				return;
			}
			else
			{
				this.ConvertedStatus = statusValuesReturned[0];
			}

		}
	}

	public PageReference processChange()
	{
		//This method just serves as point of refresh.
		//where buttons have immediate=true, its cutting of view state.
		//So this is just to server as refresh point if any field changes
		return null;
	}

	private void loadAccount()
	{
		if (LeadRecord.Referring_Account_ID__c == null) {
			this.AccountRecord = new Account();
			this.existingAccountId = 'New';
		} else {
			existingAccountId = LeadRecord.Referring_Account_ID__c;
			TempOppName = LeadRecord.Company;
			referralAcctConvert = true;
			loadFoundAccounts(existingAccountId);
		}
	}

	private void loadContact()
	{
		this.ContactRecord = new Contact();

		ContactRecord.FirstName = LeadRecord.FirstName;
		ContactRecord.LastName = LeadRecord.LastName;

		this.existingContactId = 'New';

		loadFoundContacts();
	}

	private void loadOpportunity()
	{
		this.OpportunityRecord = new Opportunity();

		OpportunityRecord.OwnerId = UserInfo.getUserId();
		OpportunityRecord.Name = TempOppName;
		OpportunityRecord.CloseDate = getOppCloseDate();

		//this.CreateOpportunity = Settings.Do_Not_Create_New_Opp_Default__c;
		this.DoNotCreateOpportunity = Settings.Do_Not_Create_New_Opp_Default__c;
	}

	private void loadTask()
	{
		this.taskPriorities = new List<SelectOption> ();

		for (String x : new String[] { 'High', 'Normal', 'Low' })
		{
			taskPriorities.add(new SelectOption(x, x));
		}

		this.TaskRecord = new Task();

		if (UGears.UString.isNullOrEmpty(Settings.Task_Subject__c) == false)
		{
			TaskRecord.Subject = Settings.Task_Subject__c;
		}

		if (UGears.UString.isNullOrEmpty(Settings.Task_Status__c) == false)
		{
			TaskRecord.Status = Settings.Task_Status__c;
		}

		if (Settings.Task_Due_Date_Offset__c != null)
		{
			TaskRecord.ActivityDate = Date.today().addDays(Integer.valueOf(Settings.Task_Due_Date_Offset__c));
		}

		if (UGears.UString.isNullOrEmpty(Settings.Task_Priority__c) == false)
		{
			TaskRecord.Priority = Settings.Task_Priority__c;
		}

		//Used to facilitate reminder functionality 
		this.TempTaskRecord = new Task();

		this.CreateTask = Settings.Create_New_Task_Default__c;
	}

	private void setLookupValues()
	{
		this.temp_acclkid_lktp = '001';
		this.temp_acclkid_lspf = '0';
		this.temp_acclkid_mod = '0';
		this.temp_acclkid_onpk = 'initiateUpdateFromAccount();';

		this.temp_conlkid_lktp = '003';
		this.temp_conlkid_lspf = '0';
		this.temp_conlkid_mod = '0';
		this.temp_conlkid_onpk = 'initiateUpdateFromContact();';

		//Commented out to get the contacts on the lookup.
		/*this.temp_conlkid_lktp = 'a06';
		  this.temp_conlkid_lspf = '0';
		  this.temp_conlkid_mod = '0';
		  this.temp_conlkid_onpk = 'initiateUpdateFromMembership();'; */
	}

	private void disableAccountContactFields()
	{
		//this.disableAccountFields = true;
		//this.disableContactFields = true;
	}

	/*public PageReference showHideOpportunity()
	  {
	  this.CreateOpportunity = !CreateOpportunity;
	 
	  return null;
	  }*/

	public PageReference showHideTask()
	{
		this.CreateTask = !CreateTask;

		return null;
	}

	/*public PageReference changeProbability()
	  {               
	  String stageName = ApexPages.currentPage().getParameters().get('stageName');
	 
	  if(stageName != null && stageName.trim().length() > 0)
	  {
	  OpportunityStage os = stageNameToOppStageMap.get(stageName.toUpperCase());
	 
	  if(os != null)
	  {
	  OpportunityRecord.Probability = os.DefaultProbability;
	  OpportunityRecord.StageName = stageName;
	  }
	  else
	  {
	  OpportunityRecord.Probability = 0;
	  OpportunityRecord.StageName = null;
	  }
	  }
	  else
	  {
	  OpportunityRecord.Probability = 0;
	  OpportunityRecord.StageName = null;
	  }
	 
	  return null;
	  }   
	 */

	private void loadFoundAccounts(Id foundAccountId)
	{
		this.foundAccounts = new List<SelectOption> ();

		String companySearchField = 'Name'; //Use the name field by default               
		String companySearchValue = null;

		//if(LeadRecord.Related_Account__c != null || LeadRecord.Parent_Lead__r.Related_Account__c != null)
		//if(LeadRecord.Parent_Lead__r.Related_Account__c != null)
		if (foundAccountId != null)
		{
			companySearchField = 'Id';
			//companySearchValue = (LeadRecord.Parent_Lead__r.Related_Account__c != null) ? LeadRecord.Parent_Lead__r.Related_Account__c : LeadRecord.Related_Account__c;
			//this.TempOppName = (LeadRecord.Parent_Lead__r.Related_Account__c != null) ? LeadRecord.Parent_Lead__r.Related_Account__r.Name : LeadRecord.Related_Account__r.Name;           

			//companySearchValue = LeadRecord.Parent_Lead__r.Related_Account__c;
			companySearchValue = foundAccountId;
			//this.TempOppName = LeadRecord.Parent_Lead__r.Related_Account__r.Name;

			//this.SelectAccount = true;

			//**If client wants to not let user select the account if its found, change the
			//**above this.selectaccount = false.

			//this.selectaccount=false;
			this.selectaccount = settings.Select_Account_if_Found__c;
		}
		else
		{
			companySearchValue = '' + LeadRecord.Company + '%';
			this.TempOppName = LeadRecord.Company;
			foundAccounts.add(new SelectOption('new', 'Create New Account: ' + LeadRecord.Company));
			this.SelectAccount = true;
		}

		if (companySearchValue.length() > 3)
		{
			String soqlQuery = 'select Id, Name, BillingState from Account where ' + companySearchField + ' ';

			if (companySearchField.equalsIgnoreCase('Id') == true)
			{
				soqlQuery += '= :companySearchValue ';
			//commented "Attach to Existing Account" functionality	
			// }
			// else
			// {
			// 	soqlQuery += 'like :companySearchValue ';
			// }

				soqlQuery += 'order by Name asc limit 50';

				for (Account a : Database.query(soqlQuery))
				{
					String displayValue = '';

					displayValue += a.Name;
					if (a.BillingState != null) displayValue += ' - ' + a.BillingState;

					this.existingAccountId = a.Id;
					foundAccounts.add(new SelectOption(a.Id, 'Attach to Existing: ' + displayValue));
				}
			}
		}
		
		if (foundAccountId == null) {
			loadMatchingAccounts();
		}
	}

	private void loadMatchingAccounts() {
		String leadRecTypeName = Schema.SObjectType.Lead.getRecordTypeInfosById().get(LeadRecord.RecordTypeId).getDeveloperName();
		for (Lead_Convert_Mappings__mdt cmdt : [SELECT Account_RecordType__c, Account_Key1__c, Account_Key2__c, Lead_Key1__c, Lead_Key2__c FROM Lead_Convert_Mappings__mdt WHERE Lead_RecordType__c = :leadRecTypeName LIMIT 1]) {
			String acctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(cmdt.Account_RecordType__c).getRecordTypeId();
			String acctField1 = cmdt.Account_Key1__c;
			String acctField2 = cmdt.Account_Key2__c;
			String leadField1 = cmdt.Lead_Key1__c;
			String leadField2 = cmdt.Lead_Key2__c;
			String leadQuery = 'SELECT ';
			if (String.isNotEmpty(leadField1)) {
				leadQuery += leadField1 + ', ';
			}
			if (String.isNotEmpty(leadField2)) {
				leadQuery += leadField2 + ', ';
			}
			if (String.isNotEmpty(leadField1) || String.isNotEmpty(leadField2)) {
				Id leadId = LeadRecord.Id;
				String company = '%' + LeadRecord.Company + '%';
				leadQuery += ' Id FROM Lead WHERE Id =:leadId';
				List<Lead> leadsList = Database.query(leadQuery);
				if (!leadsList.isEmpty()) {
					String acctsQuery = 'SELECT Id, Name, BillingState FROM Account WHERE RecordTypeId =:acctRecTypeId AND Name LIKE :company AND (';
					acctsQuery += helpBuildAcctsQuery(acctField1, leadField1, leadsList[0]);
					acctsQuery += helpBuildAcctsQuery(acctField2, leadField2, leadsList[0]);
					if (acctsQuery.endsWith('OR ')) {
						acctsQuery = acctsQuery.removeEnd('OR ');
						acctsQuery += ') ORDER BY Name ASC LIMIT 50';
						for (Account a : Database.query(acctsQuery))
						{
							String displayValue = a.Name;
							if (a.BillingState != null) displayValue += ' - ' + a.BillingState;
							foundAccounts.add(new SelectOption(a.Id, 'Attach to Existing: ' + displayValue));
						}							
					}
				}
			}
		}
	}

	private String helpBuildAcctsQuery(String acctField, String leadField, Lead lead) {
		String acctsQuery = '';
		if (String.isNotEmpty(acctField) && String.isNotEmpty(leadField)) {
			Object obj;
			if (leadField.contains('.')) {
				String[] leadFieldArr = leadField.split('\\.');
				if (lead.getSobject(leadFieldArr[0])!=null) {
					obj = lead.getSobject(leadFieldArr[0]).get(leadFieldArr[1]);
				}
			}
			else {
				obj = lead.get(leadField);
			}
			if (obj!= null) {
				acctsQuery += acctField + '= \'' + (String) obj + '\' OR ';
			}
		}
		return acctsQuery;
	}

	private void loadFoundContacts()
	{
		this.foundContacts = new List<SelectOption> ();

		String contactSearchField = 'Name'; //Use the name field by default               
		String contactSearchValue = null;

		Id existingContactAccountId = null;

		//if((LeadRecord.Related_Contact__c != null && LeadRecord.Related_Contact__r.AccountId!=null) || (LeadRecord.Parent_Lead__r.Related_Contact__c != null && LeadRecord.Parent_Lead__r.Related_Contact__r.AccountId!=null))
		/*if (LeadRecord.Parent_Lead__r.Related_contact__c != null && LeadRecord.Parent_Lead__r.Related_Contact__r.AccountId != null)
		{
			contactSearchField = 'Id';
			contactSearchValue = LeadRecord.Parent_Lead__r.Related_Contact__c;
			this.selectcontact = settings.Select_Contact_if_Found__c;

			//edit 7/16/14 -Phillip
			//if contact found, use account.            
			//companySearchField = 'Id'; 
			//companySearchValue = LeadRecord.Parent_Lead__r.Related_Contact__c.AccountId;
			//this.TempOppName = LeadRecord.Parent_Lead__r.Related_Contact__r.Account.Name;
			//this.selectaccount = settings.Select_Account_if_Found__c;
			 
			//
			if (LeadRecord.Parent_Lead__r.Related_Contact__r.AccountId != null)
			{
				existingContactAccountId = LeadRecord.Parent_Lead__r.Related_Contact__r.AccountId;
				this.TempOppName = LeadRecord.Parent_Lead__r.Related_Contact__r.Account.Name;
			}



		}
		else
		{*/
			contactSearchField = 'Name';
			//contactSearchValue = '' + UGears.UString.isNullOrEmpty(LeadRecord.FirstName) + '%' + UGears.UString.isNullOrEmpty(LeadRecord.LastName) + '';  
			contactSearchValue = '' + UGears.UString.isNullOrEmptyToValue(LeadRecord.FirstName, '') + '%' + UGears.UString.isNullOrEmptyToValue(LeadRecord.LastName, '') + '';

			//foundContacts.add( new SelectOption('new', 'Create New Contact: ' + UGears.UString.isNullOrEmpty(LeadRecord.FirstName) + ' ' + UGears.UString.isNullOrEmpty(LeadRecord.LastName)));  
			foundContacts.add(new SelectOption('new', 'Create New Contact: ' + UGears.UString.isNullOrEmptyToValue(LeadRecord.FirstName, '') + ' ' + UGears.UString.isNullOrEmptyToValue(LeadRecord.LastName, '')));
			this.SelectContact = true;
		//}

		if (contactSearchValue.length() > 4)
		{
			String soqlQuery = 'select Id,Name,Account.Name, Email from Contact where AccountId != null AND ( ' + contactSearchField + ' ';


			if (contactSearchField.equalsIgnoreCase('Id') == true)
			{
				//soqlQuery += '= :contactSearchValue or Email = \'' + LeadRecord.Email + '\' ) order by Name asc limit 50';
				soqlQuery += '= :contactSearchValue) order by Name asc limit 50';
			}
			else
			{
				//soqlQuery += 'like :contactSearchValue or Email = \'' + LeadRecord.Email + '\' ) order by Name asc limit 50';
				soqlQuery += 'like :contactSearchValue'; // or Email = \'' + LeadRecord.Email + '\' ) order by Name asc limit 50';
				if (LeadRecord.Email != null && LeadRecord.Email != 'none@none.com')
				{
					soqlQuery += ' or Email = \'' + LeadRecord.Email + '\'';
				}
				soqlQuery += ' ) ';
				//if(LeadRecord.State!=null && LeadRecord.State!='')
				//{
				//soqlQuery += ' and MailingState = \'' + LeadRecord.State + '\'';
				//}

				soqlQuery += ' order by Name asc limit 50';
			}

			for (Contact c : Database.query(soqlQuery))
			{
				this.existingContactId = c.Id;
				foundContacts.add(new SelectOption(c.Id, 'Attach to Existing: ' + c.Name + ' (' + c.Account.Name + ')'));

				if (LeadRecord.Email == c.email)
				{
					this.isContactEmailMatch = true;
				}
			}
		}

		if (referralAcctConvert != true) {
			//loadFoundAccounts(existingContactAccountId);
			// Do not pass in the existing Account ID, this should allow Users to select any they want
			loadFoundAccounts(null);
		}

	}



	public String getDebugx()
	{
		String returnData = '';
		returnData += ' *** ExistingAccountId=' + existingAccountId;
		returnData += ' *** ExistingContactId=' + existingContactId;

		for (String key : ApexPages.currentPage().getParameters().keySet())
		{
			returnData += ' *** ' + key + '=' + ApexPages.currentPage().getParameters().get(key);
		}

		return debugx + returnData;
	}

	public SelectOption[] getFoundAccounts()
	{
		processAccountChange();

		return foundAccounts;
	}

	public PageReference processAccountChange()
	{
		for (String paramKey : ApexPages.currentPage().getParameters().keySet())
		{
			if (paramKey.endsWith('acclkid_lkid'))
			{
				existingAccountId = ApexPages.currentPage().getParameters().get(paramKey);
			}
		}

		system.debug('-- existingaccountid: ' + existingaccountid);

		if (existingAccountId == null || existingAccountId == 'new')
		{
			//default contact to new
			this.existingContactId = 'new';
			//ApexPages.currentPage().getParameters().put('conlkid_lkid','new');
			//this.loadFoundContacts();
			//system.debug('existing contact in ac change: ' + existingcontactid);
			//system.debug('page vars: ' + apexpages.currentpage().getparameters().get('conlkid_lkid'));
			//this.processContactChange();
			//system.debug('here process ac change.');

			for (String paramKey : ApexPages.currentPage().getParameters().keySet())
			{
				if (paramKey.endsWith('conlkid_lkid'))
				{
					ApexPages.currentPage().getParameters().put(paramKey, 'new');
				}
			}

			return null;
		}

		Account a1;

		for (Account a :[select Id, Name from Account where Id = :existingAccountId])
		{
			a1 = a;
		}

		if (a1 == null)
		{
			return null;
		}

		Boolean found = false;

		for (Selectoption so : foundAccounts)
		{
			if (so.getValue() == (String) existingAccountId)
			{
				found = true;
			}
		}

		if (!found)
		{
			foundAccounts.add(new SelectOption(existingAccountId, 'Attach to Existing: ' + a1.Name));
		}

		return null;
	}

	public SelectOption[] getFoundContacts()
	{
		processContactChange();

		return foundContacts;
	}

	public PageReference processContactChange()
	{
		debugx += '***  asdfasdf';

		system.debug('process contact change: ' + existingcontactid);
		System.debug(LoggingLevel.INFO, '#debug: temp_conlkid_lkold: ' + temp_conlkid_lkold);
		System.debug(LoggingLevel.INFO, '#debug: ApexPages.currentPage().getParameters().keySet() : ' + ApexPages.currentPage().getParameters().keySet());
		System.debug(LoggingLevel.INFO, '#debug: ApexPages.currentPage().getParameters().values() : ' + ApexPages.currentPage().getParameters().values());
		for (String paramKey : ApexPages.currentPage().getParameters().keySet())
		{
			System.debug(LoggingLevel.INFO, '#debug: paramKey: ' + paramKey);
			System.debug(LoggingLevel.INFO, '#debug: value: ' + ApexPages.currentPage().getParameters().get(paramKey));
			if (paramKey.endsWith('conlkid_lkid'))
			{
				existingContactId = ApexPages.currentPage().getParameters().get(paramKey);
			}
		}
		System.debug(LoggingLevel.INFO, '#debug: existingContactId: ' + existingContactId);

		if (existingContactId == null || existingContactId == 'new')
		{
			return null;
		}

		Contact c1;

		for (Contact c :[select Id, Name, AccountId, Account.Id, Account.Name from Contact where Id = :existingContactId AND AccountId != null limit 1])
		{
			c1 = c;
		}
		System.debug(LoggingLevel.INFO, '#debug: c1: ' + c1);
		if (c1 == null)
		{
			return null;
		}

		Boolean found = false;
		System.debug(LoggingLevel.INFO, '#debug: foundContacts: ' + foundContacts);
		for (Selectoption so : foundContacts)
		{
			if (so.getValue() == (String) existingContactId)
			{
				found = true;
			}
		}
		System.debug(LoggingLevel.INFO, '#debug: found: ' + found);
		if (!found)
		{
			foundContacts.add(new SelectOption(existingContactId, 'Attach to Existing: ' + c1.Name));
		}

		existingAccountId = c1.AccountId;
		found = false;

		for (Selectoption so : foundAccounts)
		{
			if (so.getValue() == existingAccountId)
			{
				found = true;
			}
		}

		if (!found)
		{
			foundAccounts.add(new SelectOption(existingAccountId, 'Attach to Existing: ' + c1.Account.Name));
		}

		debugx += ' *** XXXupdated';

		return null;
	}

	public PageReference convertAndJumpToOpp()
	{
		return convert(ConvertDestination.OPPORTUNITY);
	}

	public PageReference convertAndJumpToAccount()
	{
		return convert(ConvertDestination.ACCOUNT);
	}

	public PageReference convertAndJumpToContact()
	{
		return convert(ConvertDestination.CONTACT);
	}

	public PageReference convert(ConvertDestination destination)
	{
		if (!isValid())
		{
			return null;
		}

		if (ApexPages.hasMessages())
		{
			return null;
		}

		/*Boolean successOppInsert = createOpportunityRecord();
		 
		  if(!successOppInsert)
		  {
		  return null;
		  }   
		 */
		Boolean successTaskInsert = createTaskRecord();

		if (!successTaskInsert)
		{
			return null;
		}

		String conlkid_lkid = ApexPages.currentPage().getParameters().get('conlkid_lkid');

		if (conlkid_lkid != null)
		{
			existingContactId = conlkid_lkid;
		}

		if (existingContactId != 'new' && existingAccountId == 'new')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not create a new account while specifying an existing contact.'));
		}

		Contact c1;
		Account a1;

		System.debug('----existingAccountId-----' + existingAccountId);
		System.debug('----existingContactId-----' + existingContactId);

		if (existingAccountId != null && existingAccountId != 'new')
		{
			a1 = [select Id, Name from Account where Id = :existingAccountId];
		}

		if (existingContactId != null && existingContactId != 'new')
		{
			/*
			  Modified by Trekbin
			  Date: 15 July 2015
			 */
			c1 = [select Id, Name, AccountId, Account.Id, Account.Name, Phone, Ext__c, Email, MobilePhone, Fax from Contact where Id = :existingContactId];
		}

		Database.LeadConvertResult lcr = null;

		if (a1 != null && c1 != null)
		{
			if (a1.Id != c1.Account.Id)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'If selecting an existing contact, the existing account selected must be the parent account of the selected contact.'));
			}
		}

		LeadRecord.Status = ConvertedStatus;

		Database.Leadconvert lc = new Database.Leadconvert();

		// if linked to a new account, put the id in here:
		if (existingAccountId != 'new')
		{
			lc.setAccountId(existingAccountId);
		}

		if (existingContactId != 'new')
		{
			lc.setContactId(existingContactId);
		}

		try
		{

		}
		catch(DmlException e)
		{
			ApexPages.addMessages(e);

			return null;
		}

		// set the old lead status
		lc.setConvertedStatus(ConvertedStatus);
		lc.setLeadId(LeadRecord.Id);
		//lc.setDoNotCreateOpportunity(CreateOpportunity);
		lc.setDoNotCreateOpportunity(DoNotCreateOpportunity);
		if (!this.DoNotCreateOpportunity)
		{
			lc.setOpportunityName(opportunityrecord.name);
		}
		/*    
		  if(createOpportunity)
		  {
		  lc.setDoNotCreateOpportunity(false);
		  lc.setOpportunityName(OpportunityRecord.Name);
		  }
		 */

		lc.setOwnerId(OpportunityRecord.OwnerId);

		if (Settings.Show_Send_Email_To_Owner__c && sendEmailToOwner)
		{
			lc.setSendNotificationEmail(true);
		}

		system.debug('-- lc: ' + lc);

		try
		{
			lcr = Database.convertLead(lc, true);

			System.debug('### ACCOUNTID = ' + lcr.getAccountId());
			System.debug('------lcr--------' + lcr);

			//sendEmailToOwner(lcr);

			/*
			  Added by Trekbin.
			  Date: 15 July 2015
			 */
			if (c1 != null) {

				if (LeadRecord.Phone != null)
				c1.Phone = LeadRecord.Phone;

				if (LeadRecord.Ext__c != null)
				c1.Ext__c = LeadRecord.Ext__c;

				if (LeadRecord.Email != null)
				c1.Email = LeadRecord.Email;

				if (LeadRecord.MobilePhone != null)
				c1.MobilePhone = LeadRecord.MobilePhone;

				if (LeadRecord.Fax != null)
				c1.Fax = LeadRecord.Fax;

				update c1;
			}
			/**/

			return postLeadConvert(lcr, destination);
		}
		catch(Exception e)
		{
			ApexPages.addMessages(e);

			return null;
		}
	}

	private PageReference postLeadConvert(Database.LeadConvertResult lcr, ConvertDestination destination)
	{
		if (lcr.isSuccess())
		{
			updateOpportunityRecord(lcr);
			updateContactRecord(lcr);
			updateTaskRecord(lcr);

			if (lcr.getOpportunityId() != null && destination == ConvertDestination.OPPORTUNITY)
			{
				return new PageReference('/' + lcr.getOpportunityId());
			}
			else if (lcr.getAccountId() != null && destination == ConvertDestination.ACCOUNT)
			{
				return new PageReference('/' + lcr.getAccountId());
			}
			else if (lcr.getContactId() != null && destination == ConvertDestination.CONTACT)
			{
				return new PageReference('/' + lcr.getContactId());
			}
			else
			{
				//Error
				throw new CustomException('Invalid convert destination');
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Conversion Error: ' + lcr.getErrors()));

			return null;
		}
	}

	/*private Boolean createOpportunityRecord()
	  {
	  //if(!CreateOpportunity)
	  if(DoNotCreateOpportunity)
	  {
	  return true;
	  }
	 
	  try
	  {    
	  UGears.UDebug.printDebug('OPP RECORD BEFORE INSERT: ' + OpportunityRecord);
	 
	  insert OpportunityRecord;
	 
	  return true;
	  }
	  catch(DmlException e)
	  {
	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));
	 
	  System.debug('EXCEPTION: ' + e);
	 
	  return false;
	  }
	  }*/
	private Boolean updateContactRecord(Database.LeadConvertResult lcr)
	{
		boolean success = true;

		Contact c = new Contact(id = lcr.getContactId());
		c.i2i_ID__c = LeadRecord.Parent_Lead__r.i2i_id__c;

		try
		{
			UGears.UDebug.printDebug('Contact Record Before Update: ' + c);

			update c;
		} catch(DmlException e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));

			System.debug('EXCEPTION: ' + e);

			return false;
		}

		return success;
	}
	private Boolean updateOpportunityRecord(Database.LeadConvertResult lcr)
	{
		//if(!CreateOpportunity)
		if (DoNotCreateOpportunity)
		{
			return true;
		}

		Boolean success = true;

		//OpportunityRecord.AccountId = lcr.getAccountId();  
		Opportunity o = new Opportunity(id = lcr.getOpportunityId());
		o.CloseDate = opportunityrecord.CloseDate;

		try
		{
			//UGears.UDebug.printDebug('OPP RECORD BEFORE UPDATE: ' + OpportunityRecord);

			//update OpportunityRecord; 
			update o;
		}
		catch(DmlException e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));

			System.debug('EXCEPTION: ' + e);

			return false;
		}

		/*if(success)
		  {
		  success = createOpportunityContactRole(lcr);
		  }*/

		return success;
	}

	/*private Boolean createOpportunityContactRole(Database.LeadConvertResult lcr)
	  {
	  //if(!CreateOpportunity)
	  if(DoNotCreateOpportunity)
	  {
	  return true;
	  }
	 
	  OpportunityContactRole ocr = new OpportunityContactRole();      
	 
	  ocr.OpportunityId = OpportunityRecord.Id;       
	  ocr.ContactId = lcr.getContactId();
	  //ocr.Role = ''
	  //ocr.IsPrimary = true;
	 
	  try
	  {                           
	  insert ocr; 
	 
	  return true;        
	  }
	  catch(DmlException e)
	  {
	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));
	 
	  System.debug('EXCEPTION: ' + e);
	 
	  return false;
	  }
	  }
	 */
	private Boolean createTaskRecord()
	{
		if (!CreateTask || TaskRecord.Subject == null || TaskRecord.Subject == '')
		{
			system.debug('create task record exit.');
			return true;
		}

		// create task                  
		TaskRecord.OwnerId = OpportunityRecord.OwnerId;

		if (AddReminder == true)
		{
			TaskRecord.IsReminderSet = true;
			TaskRecord.ReminderDateTime = DateTime.parse(TempTaskRecord.ActivityDate.month() + '/' + TempTaskRecord.ActivityDate.day() + '/' + TempTaskRecord.ActivityDate.year() + ' ' + ReminderTime);
		}

		try
		{
			insert TaskRecord;

			return true;
		}
		catch(DmlException e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));

			System.debug('EXCEPTION: ' + e);

			return false;
		}
	}

	private Boolean updateTaskRecord(Database.LeadConvertResult lcr)
	{
		if (!CreateTask || TaskRecord.Subject == null || TaskRecord.Subject == '')
		{
			system.debug('update task exit.');
			return true;
		}

		TaskRecord.WhoId = lcr.getContactId();
		TaskRecord.WhatId = lcr.getOpportunityId(); //OpportunityRecord.Id; 
		//Did us the lcr opp id since I had to remove that due to issues in the ConvertLead class provided by SF
		//Using lcr opp for this client.  -Phillip 11/12/13
		try
		{
			update TaskRecord;

			return true;
		}
		catch(DmlException e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));

			System.debug('EXCEPTION: ' + e);

			return false;
		}
	}

	private Boolean isValid()
	{
		//**Using standard opp create from lead convert so only
		//**need to valid task
		//Boolean validOpp = isValidOpp();
		//Boolean validTask = isValidTask();

		/*if(validOpp == false || validTask == false)
		  {
		  return false;
		  }
		  else
		  {
		  return true;
		  }*/

		return isvalidtask();

	}

	private Boolean isValidOpp()
	{
		Boolean validOpp = true;

		//if(!CreateOpportunity)
		if (DoNotCreateOpportunity)
		{
			return validOpp;
		}

		if (OpportunityRecord.Name == null || OpportunityRecord.Name.trim().length() == 0)
		{
			OpportunityRecord.Name.addError(UGears.UUI.getSFDefaultErrorMessage());

			validOpp = false;
		}

		if (OpportunityRecord.StageName == null || OpportunityRecord.StageName.trim().length() == 0)
		{
			OpportunityRecord.StageName.addError(UGears.UUI.getSFDefaultErrorMessage());

			this.ShowStageError = true;

			validOpp = false;
		}
		else
		{
			this.ShowStageError = false;
		}

		if (OpportunityRecord.Amount == null)
		{
			OpportunityRecord.Amount.addError(UGears.UUI.getSFDefaultErrorMessage());

			validOpp = false;
		}

		if (OpportunityRecord.Probability == null)
		{
			OpportunityRecord.Probability.addError(UGears.UUI.getSFDefaultErrorMessage());

			validOpp = false;
		}

		return validOpp;
	}

	private Boolean isValidTask()
	{
		Boolean validTask = true;

		if (CreateTask == false || TaskRecord.Subject == null || TaskRecord.Subject == '')
		{
			system.debug('valid task exit.');
			return validTask;
		}

		if (TaskRecord.Subject == null || TaskRecord.Subject.trim().length() == 0)
		{
			TaskRecord.Subject.addError(UGears.UUI.getSFDefaultErrorMessage());

			validTask = false;
		}

		if (TaskRecord.Status == null || TaskRecord.Status.trim().length() == 0)
		{
			TaskRecord.Status.addError(UGears.UUI.getSFDefaultErrorMessage());

			validTask = false;
		}

		if (TaskRecord.Priority == null || TaskRecord.Priority.trim().length() == 0)
		{
			TaskRecord.Priority.addError(UGears.UUI.getSFDefaultErrorMessage());

			validTask = false;
		}

		return validTask;
	}

	/*
	  private String getOppName()
	  {
	  List<String> values = new List<String>();
	 
	  values.add(AccountRecord.Name);
	  values.add(ContactRecord.FirstName);
	  values.add(ContactRecord.LastName);
	 
	  return String.format(Settings.Opportunity_Name_String__c, values);
	  }    
	 */

	private Date getOppCloseDate()
	{
		Date d = Date.today().addDays(Integer.valueOf(Settings.Opportunity_Close_Date_Offset__c));

		if (Settings.Opportunity_Close_Date_To_Month_End__c == true)
		{
			Integer daysInMonth = Date.daysInMonth(d.year(), d.month());

			d = UGears.UDate.getMonthEndDate(Date.newInstance(d.year(), d.month(), daysInMonth));
		}

		return d;
	}

	private void sendEmailToOwner(Database.LeadConvertResult lcr)
	{
		if (Settings.Show_Send_Email_To_Owner__c == true)
		{
			if (sendEmailToOwner == true)
			{
				system.debug('-- sending email');

				GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();

				User currentUser = [select Id, Email from User where Id = :UserInfo.getUserId() limit 1];
				User u = [select Id, Email from User where Id = :OpportunityRecord.OwnerId limit 1];

				Messaging.Singleemailmessage msg = new Messaging.Singleemailmessage();
				msg.setSubject('Lead Converted');
				string bodytext = 'Your lead has been converted: \r\n';
				bodytext += '\r\n Account: ' + gs.productionInstance__c + '/' + lcr.getAccountId() + '\r\n';
				bodytext += '\r\n Contact: ' + gs.productionInstance__c + '/' + lcr.getContactId() + '\r\n';
				bodytext += '\r\n Opportunity: ' + gs.productionInstance__c + '/' + lcr.getOpportunityId() + '\r\n';
				msg.setPlainTextBody(bodytext);
				msg.setTargetObjectId(u.Id);
				msg.setSaveAsActivity(false);
				Messaging.sendEmail(new List<Messaging.Singleemailmessage> { msg });

				/*
				  Email msg = new Email();
				 
				  msg.SenderEmail = currentUser.Email;                    
				  msg.Subject = 'Lead Converted';
				  string bodytext = 'Your lead has been converted: \r\n';
				  bodytext += '\r\n Account: ' + gs.productionInstance__c + '/' + lcr.getAccountId() + '\r\n';
				  bodytext += '\r\n Contact: ' + gs.productionInstance__c + '/' + lcr.getContactId() + '\r\n';
				  bodytext += '\r\n Opportunity: ' + gs.productionInstance__c + '/' + lcr.getOpportunityId() + '\r\n';
				  msg.PlainTextBody = bodytext;
				  msg.addToAddress(u.Email);
				 
				  msg.send();
				 */

			}
		}
	}

	public enum ConvertDestination
	{
		ACCOUNT,
		OPPORTUNITY,
		CONTACT
	}

	class CustomException extends exception { }
}