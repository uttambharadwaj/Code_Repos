/*

    Name: UTestData
    Created By: Jason McCormack (GearsCRM)
    Created Date: 2012-10-08
    Description: Factory class for creating test data. The methods in this class ideally should not be doing an DML. The goal is
                 to return a list or records to your unit test and then within the unit test, you can perform any DML operations.
                 This helps be avoiding issues specific to each instance when performing the DML in the UTestData. It also allows for 
                 better unit test by allowing the unit test to perform the DML which allows asserts to be done in much more flexible way.
    
    Modified By: 
    Modified Date: 
    Description: 

*/

@IsTest
public with sharing class UTestData
{   
	//#####################################################################
	//Custom Object Test Methods
	//#####################################################################

	//#####################################################################
	//Standard Object Test Methods
	//#####################################################################


	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}

 	public class CustomException extends Exception {}

	//Used to give consistent assert messages used to track down the assert issues
	public static String getAssertMessage(Integer testNumber, Integer checkNumber)
	{
		return 'TEST #' + testNumber + '/CHECK #' + checkNumber;
	}
	
	public static String getTimestamp(Datetime dt)
	{
		if(dt == null)
		{
			dt = Datetime.now();
		}
		
		String timestamp = '';
		
		timestamp += dt.year();
		timestamp += dt.month();
		timestamp += dt.day();
		timestamp += dt.hour();
		timestamp += dt.minute();
		timestamp += dt.second();
		timestamp += dt.millisecond();
		
		return timestamp;
	}

	/*
	public static List<CaseArticle> getCaseArticles(List<Case> records, String knowledgeArticleId)
	{
		List<CaseArticle> caseArticles = new List<CaseArticle>();
		
		for(Case record : records)
		{
			CaseArticle ca = new CaseArticle();
			
			ca.KnowledgeArticleId = (Id) knowledgeArticleId;
			ca.CaseId = record.Id;
				
			caseArticles.add(ca);				
		}
				
		return caseArticles;
	}
	*/
	
	/*
	public static List<Attachment> getEmailMessageAttachments(List<EmailMessage> records)
	{	
		return getAttachments(records);
	}
		
	public static List<EmailMessage> getCaseEmailMessages(List<Case> records, User u)
	{
		List<EmailMessage> emailMessages = getEmailMessages(records, u);
		
		if(records.size() == emailMessages.size())
		{
			for(Integer i = 0; i < records.size(); i++)
			{
				EmailMessage em = emailMessages[i];
				Case c = records[i];
				
				//em.HtmlBody = em.HtmlBody + ' ' + c.Email_To_Case_Reference_Number__c;
				//em.TextBody = em.TextBody + ' ' + c.Email_To_Case_Reference_Number__c;
			}
		}
		else
		{
			throw new CustomException('UTestData.getCaseEmailMessages record counts don\'t match');
		}
		
		return emailMessages;
	}
	
	public static List<EmailMessage> getEmailMessages(List<SObject> records, User u)
	{		
		Integer counter = 0;
		Date messageDate = Date.today();
		List<EmailMessage> emailMessages = new List<EmailMessage>();
		String emailBody = 'This is a test email message';
		 
		for(SObject record : records)
		{
			EmailMessage em = new EmailMessage();
			/*
			ToAddress 
			Incoming 
			HtmlBody 
			Headers 
			HasAttachment 
			CcAddress 
			BccAddress 
			ActivityId
			*/
			/*
			em.ParentId = record.Id;
			em.MessageDate = messageDate;
			
			if(u != null)
			{
				em.FromName = u.Name;
				em.FromAddress = u.Email;
			}
			else
			{			
				em.FromName = UserInfo.getName();
				em.FromAddress = UserInfo.getUserName();
			}
			
			em.Subject = 'Test Email ' + (counter + 1);						
			em.Status = '0'; //Status is 0 - 4 when you look at the field using the schema browser			
			em.TextBody = emailBody;
			em.HtmlBody = emailBody;
			
			emailMessages.add(em);
			
			counter++;
		}
				
		return emailMessages;
	}	
	*/
	
	public static List<CaseComment> getCaseComments(List<Case> records)
	{
		List<CaseComment> caseComments = new List<CaseComment>();
		
		for(Case record : records)
		{		
			caseComments.add(getCaseComment(record));
		}
				
		return caseComments;
	}
	
	public static CaseComment getCaseComment(Case record)
	{		
		String commentBody = 'This is a test case comment';
		 
		CaseComment cc = new CaseComment();
			
		cc.ParentId = record.Id;
		cc.IsPublished = true; 
		cc.CommentBody = commentBody;
					
		return cc;
	}
	
	public static List<Task> getOpenTasksForWho(String subject, Set<String> whoIds)
	{
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		for(String whoId : whoIds)
		{
			tasks.add(getOpenTask(getTaskSubject(subject) + (counter + 1), whoId, null));
			
			counter++;
		}
		
		return tasks;
	}
	
	public static List<Task> getOpenTasksForWhat(String subject, Set<String> whatIds)
	{
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		for(String whatId : whatIds)
		{
			tasks.add(getOpenTask(getTaskSubject(subject) + (counter + 1), null, whatId));
			
			counter++;
		}
		
		return tasks;	
	}
	
	public static List<Task> getOpenTasksForWhoWhat(String subject, Set<String> whoIds, Set<String> whatIds)
	{
		if(whoIds == null)
		{
			throw new CustomException('UTestData.getOpenTasksForWhoWhat - No whoIds were passed in.');	
		}
		
		if(whatIds == null)
		{
			throw new CustomException('UTestData.getOpenTasksForWhoWhat - No whatIds were passed in.');	
		}
		
		if(whoIds.size() != whatIds.size())
		{
			throw new CustomException('UTestData.getOpenTasksForWhoWhat - WhoId and WhatId sizes must be equal');	
		}
		
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		List<String> whoIdsList = new List<String>(whoIds); //added this so that we can grab the value by index
		
		for(String whatId : whatIds)
		{
			String whoId = whoIdsList[counter];
			
			tasks.add(getOpenTask(getTaskSubject(subject) + (counter + 1), whoId, whatId));
			
			counter++;
		}
		
		return tasks;
	}
	
	public static Task getOpenTask(String subject, String whoId, String whatId)
	{		
		Task t = new Task();
		
		if(subject != null && subject.trim().length() > 0)
		{
			t.Subject = subject;
		}
		else
		{
			t.Subject = getTaskSubject(subject).trim();
		}
		
		if(whoId != null && whoId.trim().length() > 0)
		{
			t.WhoId = whoId;
		}
		
		if(whatId != null && whatId.trim().length() > 0)
		{
			t.WhatId = whatId;
		}
		
		t.ActivityDate = Date.today();
		t.Description = t.Subject + ' - Test Description on ' + t.ActivityDate;
		t.Type='test';
					
		return t;
	}	
	
	public static List<Task> getCompletedTasksForWho(String subject, Set<String> whoIds)
	{
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		for(String whoId : whoIds)
		{
			tasks.add(getCompletedTask(getTaskSubject(subject) + (counter + 1), whoId, null));
			
			counter++;
		}
		
		return tasks;
	}
	
	public static List<Task> getCompletedTasksForWhat(String subject, Set<String> whatIds)
	{
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		for(String whatId : whatIds)
		{
			tasks.add(getCompletedTask(getTaskSubject(subject) + (counter + 1), null, whatId));
			
			counter++;
		}
		
		return tasks;	
	}
	
	public static List<Task> getCompletedTasksForWhoWhat(String subject, Set<String> whoIds, Set<String> whatIds)
	{
		if(whoIds == null)
		{
			throw new CustomException('UTestData.getCompletedTasksForWhoWhat - No whoIds were passed in.');	
		}
		
		if(whatIds == null)
		{
			throw new CustomException('UTestData.getCompletedTasksForWhoWhat - No whatIds were passed in.');	
		}
		
		if(whoIds.size() != whatIds.size())
		{
			throw new CustomException('UTestData.getCompletedTasksForWhoWhat - WhoId and WhatId sizes must be equal');	
		}
		
		List<Task> tasks = new List<Task>();
		Integer counter = 0;
		
		List<String> whoIdsList = new List<String>(whoIds); //added this so that we can grab the value by index
		
		for(String whatId : whatIds)
		{
			String whoId = whoIdsList[counter];
			
			tasks.add(getCompletedTask(getTaskSubject(subject) + (counter + 1), whoId, whatId));
			
			counter++;					
		}
		
		return tasks;
	}	
	
	public static Task getCompletedTask(String subject, String whoId, String whatId)
	{	
		Task t = getOpenTask(subject, whoId, whatId);
		
		t.Status = 'Completed';
		
		return t;
	}	
	
	private static String getTaskSubject(String subject)
	{
		if(subject == null || subject.trim().length() == 0)
		{
			return 'Test Open Task ';
		}
		else
		{
			return subject;
		}
	}
	
	public static List<Event> getOpenEventsForWho(String subject, Set<String> whoIds)
	{
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		for(String whoId : whoIds)
		{
			events.add(getOpenEvent(getEventSubject(subject) + (counter + 1), whoId, null));
			
			counter++;
		}
		
		return events;
	}
	
	public static List<Event> getOpenEventsForWhat(String subject, Set<String> whatIds)
	{
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		for(String whatId : whatIds)
		{
			events.add(getOpenEvent(getEventSubject(subject) + (counter + 1), null, whatId));
			
			counter++;
		}
		
		return events;	
	}
	
	public static List<Event> getOpenEventsForWhoWhat(String subject, Set<String> whoIds, Set<String> whatIds)
	{
		if(whoIds == null)
		{
			throw new CustomException('UTestData.getOpenEventsForWhoWhat - No whoIds were passed in.');	
		}
		
		if(whatIds == null)
		{
			throw new CustomException('UTestData.getOpenEventsForWhoWhat - No whatIds were passed in.');	
		}
		
		if(whoIds.size() != whatIds.size())
		{
			throw new CustomException('UTestData.getOpenEventsForWhoWhat - WhoId and WhatId sizes must be equal');	
		}
		
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		List<String> whoIdsList = new List<String>(whoIds); //added this so that we can grab the value by index
		
		for(String whatId : whatIds)
		{
			String whoId = whoIdsList[counter];
			
			events.add(getOpenEvent(getEventSubject(subject) + (counter + 1), whoId, whatId));
			
			counter++;
		}
		
		return events;
	}
	
	public static Event getOpenEvent(String subject, String whoId, String whatId)
	{		
		Event e = new Event();
		
		if(subject != null && subject.trim().length() > 0)
		{
			e.Subject = subject;
		}
		else
		{
			e.Subject = getEventSubject(subject).trim();
		}
		
		if(whoId != null && whoId.trim().length() > 0)
		{
			e.WhoId = whoId;
		}
		
		if(whatId != null && whatId.trim().length() > 0)
		{
			e.WhatId = whatId;
		}
		
		e.ActivityDateTime = Datetime.now().addDays(-10);
		e.Description = e.Subject + ' - Test Description on ' + e.ActivityDate;
		e.DurationInMinutes = 60;
					
		return e;
	}	
	
	public static List<Event> getCompletedEventsForWho(String subject, Set<String> whoIds)
	{
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		for(String whoId : whoIds)
		{
			events.add(getCompletedEvent(getEventSubject(subject) + (counter + 1), whoId, null));
			
			counter++;
		}
		
		return events;
	}
	
	public static List<Event> getCompletedEventsForWhat(String subject, Set<String> whatIds)
	{
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		for(String whatId : whatIds)
		{
			events.add(getCompletedEvent(getEventSubject(subject) + (counter + 1), null, whatId));
			
			counter++;
		}
		
		return events;	
	}
	
	public static List<Event> getCompletedEventsForWhoWhat(String subject, Set<String> whoIds, Set<String> whatIds)
	{
		if(whoIds == null)
		{
			throw new CustomException('UTestData.getCompletedEventsForWhoWhat - No whoIds were passed in.');	
		}
		
		if(whatIds == null)
		{
			throw new CustomException('UTestData.getCompletedEventsForWhoWhat - No whatIds were passed in.');	
		}
		
		if(whoIds.size() != whatIds.size())
		{
			throw new CustomException('UTestData.getCompletedEventsForWhoWhat - WhoId and WhatId sizes must be equal');	
		}
		
		List<Event> events = new List<Event>();
		Integer counter = 0;
		
		List<String> whoIdsList = new List<String>(whoIds); //added this so that we can grab the value by index
		
		for(String whatId : whatIds)
		{
			String whoId = whoIdsList[counter];
			
			events.add(getCompletedEvent(getEventSubject(subject) + (counter + 1), whoId, whatId));
			
			counter++;					
		}
		
		return events;
	}	
	
	public static Event getCompletedEvent(String subject, String whoId, String whatId)
	{	
		Event e = getOpenEvent(subject, whoId, whatId);
		
		e.ActivityDateTime = Datetime.now().addDays(-10);
		e.DurationInMinutes = 60;
		
		return e;
	}	
	
	private static String getEventSubject(String subject)
	{
		if(subject == null || subject.trim().length() == 0)
		{
			return 'Test Open Event ';
		}
		else
		{
			return subject;
		}
	}	
	
	public static List<Note> getNotes(List<SObject> records)
	{
		List<Note> notes = new List<Note>();
		
		for(SObject record : records)
		{		
			Note n = new Note();
			
			n.ParentId = record.Id;
			n.Title = 'Test Note';
			n.IsPrivate = false;
			n.Body = 'Test note body';								
			
			notes.add(n);
		}
				
		return notes;
	}		
	
	public static List<Attachment> getAttachments(List<SObject> records)
	{
		List<Attachment> attachments = new List<Attachment>();

		for(SObject record : records)
		{		
			attachments.add(getAttachment(record));
		}
				
		return attachments;
	}
	
	public static Attachment getAttachment(SObject record)
	{		
		String attachmentBody = 'This is a test attachment';
		 
		Attachment a = new Attachment();
			
		a.ParentId = record.Id;
		a.Name = 'Test Attachment';
		a.Description = 'Test attachment description';
		a.ContentType = 'Text';			
		a.Body = Blob.valueOf(attachmentBody);
					
		return a;
	}	
		
	public static List<Lead> getLeads(Integer numberOfRecords)
	{
		List<Lead> leads = new List<Lead>();
		 
		for(Integer i = 0; i < numberOfRecords; i++)
		{
			Lead l = new Lead();
			
			l.Company = 'Test Company ' + (i + 1);
			l.FirstName = 'Test';
			l.LastName = 'Lead ' + (i + 1);
			l.Status = 'New';
			l.Country = 'US';			
			
			leads.add(l);
		}
				
		return leads;
	}
	
	public static List<Account> getAccounts(Integer numberOfRecords)
	{
		List<Account> accounts = new List<Account>();		
		String timestamp = getTimestamp(null);
		
		for(Integer i = 0; i < numberOfRecords; i++)
		{
			
			Account a = new Account();
			
			a.Name = 'Test Account ' + timestamp + ' #' + (i + 1);			
						
			accounts.add(a);
		}
		
		return accounts;
	}	
	
	public static List<Contact> getContacts(List<Account> accounts)
	{
		return getContacts(accounts, 1);
	}
	
	public static List<Contact> getContacts(List<Account> accounts, Integer numberOfContactsPerAccount)
	{
		List<Contact> contacts = new List<Contact>();
		Integer counter = 1;	
		String timestamp = getTimestamp(null);	
		
		for(Account a : accounts)
		{
			for(Integer i = 0; i < numberOfContactsPerAccount; i++)
			{
				
				Contact c = new Contact();
				
				c.AccountId = a.Id;
				c.FirstName = 'Test';			
				c.LastName = 'Contact ' + timestamp + ' #' + counter;
				
				contacts.add(c);
				
				counter++;
			}
		}
		
		return contacts;
	}
		
	public static List<Case> getCases(List<Account> accounts)
	{
		List<Case> cases = new List<Case>();
		Integer counter = 1;

		for(Account a : accounts)
		{
			Case c = new Case();
				
			c.AccountId = a.Id;		
			c.Type = 'Problem';
			c.Origin = 'Web';
			c.Subject = 'Test Case ' + counter;
			c.Description = 'Test Case Description ' + counter;		
				
			cases.add(c);
				
			counter++;			
		}
		
		return cases;
	}	
		
	public static List<Opportunity> getOpportunities(List<Account> accounts)
	{
		List<Opportunity> opportunities = new List<Opportunity>();
		Integer counter = 1;		
		
		for(Account a : accounts)
		{
			Opportunity opp = new Opportunity();
				
			opp.AccountId = a.Id;
			opp.Name = 'Test Opportunity #' + counter;
			opp.CloseDate = Date.today();
			opp.StageName = '1) Qualified';
			opp.Fueling_Methos__c = 'test';
			
			opportunities.add(opp);
			
			counter++;			
		}
		
		return opportunities;
	}

	public static List<Product2> getProducts(Integer numberOfRecords)
	{
		List<Product2> products = new List<Product2>();		
		
		for(Integer i = 0; i < numberOfRecords; i++)
		{			
			Product2 p = new Product2();
			
			p.Name = 'Test Product ' + (i + 1);	
			p.IsActive = true;
			p.Description = 'Test Product ' + (i + 1) + ' Description';	
			p.ProductCode = String.valueOf(i + 1);
			
			products.add(p);
		}
		
		return products;
	}
	
	/*public static Pricebook2 getPricebook(String pricebookName)
	{
		Pricebook2 pb = new Pricebook2();
			
		pb.Name = pricebookName;	
		pb.IsActive = true;		
		
		return pb;
	}
	
	public static List<PricebookEntry> getStandardPricebookEntries(List<Product2> products)
	{
		Pricebook2 standardPricebook = [select Id from Pricebook2 where Name = 'Standard Price Book' limit 1];
		
		return getPricebookEntries(standardPricebook, products);
	}	
	
	public static List<PricebookEntry> getPricebookEntries(Pricebook2 pricebook, List<Product2> products)
	{
		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();		
		Integer counter = 1;
		
		for(Product2 product : products)
		{			
			PricebookEntry pe = new PricebookEntry();
			
			pe.Pricebook2Id = pricebook.Id;
			pe.Product2Id = product.Id;			
			pe.IsActive = true;			
			pe.UnitPrice = 1.00 * counter;
			//pe.UseStandardPrice = true;	
			
			pricebookEntries.add(pe);
			
			counter++;
		}
		
		return pricebookEntries;
	}
	*/
	public static void addEmailToRecords(List<SObject> records, String emailFieldName)
	{
		addEmailToRecords(records, emailFieldName, null);
	}	
	
	public static void addEmailToRecords(List<SObject> records, String emailFieldName, String emailBeforeAtSign)
	{		
		Integer counter = 1;
		
		for(SObject record : records)
		{		
			addEmailToRecord(record, emailFieldName, emailBeforeAtSign + counter);
			
			counter++;
		}
	}	
	
	public static void addEmailToRecord(SObject record, String emailFieldName)
	{
		addEmailToRecord(record, emailFieldName, null);
	}
	
	public static void addEmailToRecord(SObject record, String emailFieldName, String emailBeforeAtSign)
	{
		String email = null;
		
		if(emailBeforeAtSign != null && emailBeforeAtSign.length() > 0)
		{
			email = emailBeforeAtSign + '@' + getTimestamp(null) + '.test';
		}
		else
		{
			email = 'test' + '@' + getTimestamp(null) + '.test';
		}
		
		addValueToSObject(record, emailFieldName, email);		
	}	
	
	public static void addValueToSObjects(List<SObject> records, Map<String, Object> keyValueMap)	
	{
		for(SObject record : records)
		{
			for(String key : keyValueMap.keySet())
			{
				addValueToSObject(record, key, keyValueMap.get(key));
			}
		}
	}	
	
	public static void addValueToSObject(SObject record, String fieldName, Object value)	
	{
		record.put(fieldName, value);
	}	
	
	public static User getUserRecord(String profileId)
	{

		String username = 'testuser' + getTimestamp(null) + '@test.test';

		return getUserRecord(username, profileId);
	}

	//One of the very few places where a DML statement actually occur in UTestData
	/*
	public static void enableCustomerPortalUserRecord(User u)
	{
		u.IsPortalEnabled = true;
		
		try
		{
			update u;
		}
		catch(DmlException e)
		{
			System.debug('EXCEPTION: ' + e);
		}
	}
	*/	
	
	public static User getUserRecord(String username, String profileId)
	{
		User u = new User();
		
		String alias = username.substring(0, username.indexOf('@'));
		
		if(alias.trim().length() > 8)
		{
			alias = alias.substring(0, 8);
		}
		
        System.debug('Alias = ' + alias);
         
        u.Alias = alias;
        u.Email = username;
        u.EmailEncodingKey = 'UTF-8';
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = profileId;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.Username = username;
                 
		return u;
	}
	
	public static String getStandardProfileId(String profileName)
	{		
		return [SELECT Id FROM Profile WHERE UserType = 'Standard' AND Name = :profileName].Id;
	}

	// Added by trekbin to get profile is
	public static String getProfileId(String ProfileName) {
		
		String strProfileId = '';
		List<Profile> lstProfile = [SELECT Id FROM Profile WHERE Name = :ProfileName];

		if (!lstProfile.isEmpty()) {
			strProfileId = lstProfile[0].Id;
		}
		return strProfileId;
	}
	
	// added by trekbin to prepare a coomunity user
	public static User getCommunityUser(){
		
		User communityUser ;
		
		if(getProfileId('Partner Community User') != ''){
			
			communityUser = getUserRecord(getProfileId('Partner Community User'));
			
			List<Account> accounts = getAccounts(1);		
			insert accounts;
			
			List<Contact> lstContacts = getContacts(accounts);
			insert lstContacts;
			
			communityUser.ContactId = lstContacts[0].Id;
			
		}
		return communityUser;
	}
	
	/*
	public static List<LiveChatTranscript> getCaseLiveChatTranscripts(List<Case> cases, List<LiveChatVisitor> visitors)
    { 
    	return getCaseLiveChatTranscripts(cases, visitors, null, null);
    }
    
    public static List<LiveChatTranscript> getCaseLiveChatTranscripts(List<Case> cases, List<LiveChatVisitor> visitors, Id deploymentId, Id chatButtonId)
    {       	
    	if(cases.size() != visitors.size())
    	{
    		throw new CustomException('UTestData.getCaseLiveChatTranscripts - case and visitor counts must be equal');	
    	}
    	
    	List<LiveChatTranscript> chats = getLiveChatTranscripts(visitors, deploymentId, chatButtonId);
    	
    	Integer counter = 0;
    	
    	for(Case c : cases)
    	{
    		LiveChatTranscript chat = chats[counter];
    		
    		chat.CaseId = c.Id;
    		
    		counter++;
    	}
    	
    	return chats;
    }
	
    public static List<LiveChatVisitor> getLiveChatVisitors(Integer numberOfVisitors)
    {    
        List<LiveChatVisitor> visitors = new List<LiveChatVisitor>();
        
        for(Integer i = 0; i < numberOfVisitors; i++)
        {
        	LiveChatVisitor visitor = getLiveChatVisitor();
        	
        	visitors.add(visitor);
        }
        
        return visitors;    
    }
    
    public static LiveChatVisitor getLiveChatVisitor()
    {    
        LiveChatVisitor visitor = new LiveChatVisitor();
        
        return visitor;    
    }    
        
    public static List<LiveChatTranscript> getLiveChatTranscripts(List<LiveChatVisitor> liveChatVisitors)
    {    
    	return getLiveChatTranscripts(liveChatVisitors, null, null);
    }
    
    public static List<LiveChatTranscript> getLiveChatTranscripts(List<LiveChatVisitor> liveChatVisitors, Id deploymentId, Id chatButtonId)
    {
    	List<LiveChatTranscript> chats = new List<LiveChatTranscript>();
    	Integer counter = 0;
    	
    	for(LiveChatVisitor visitor : liveChatVisitors)
    	{
	        LiveChatTranscript chat = getLiveChatTranscript(visitor, deploymentId, chatButtonId);
	      
	        chats.add(chat);
	        
	        counter++;
    	} 
    	
    	return chats;
    }
    
    public static LiveChatTranscript getLiveChatTranscript(LiveChatVisitor visitor, Id deploymentId, Id chatButtonId)
    {
    	LiveChatTranscript chat = new LiveChatTranscript();
	                
	    chat.Platform = 'Test Platform';
	    chat.Browser = 'IE';
	    chat.StartTime = System.today() - 2;
	    chat.EndTime = System.today () - 1;
	    chat.OperatorMessageCount = 2;
	    chat.VisitorMessageCount = 2;	    	    
	    chat.LiveChatDeploymentId = deploymentId;
	    chat.LiveChatButtonId = chatButtonId;
	    chat.LiveChatVisitorId = visitor.Id;
	    
    	return chat;   
    }
	*/
        
	/*        
	public static List<sf4twitter__Twitter_Conversation__c> getTwitterConversations(List<Contact> contacts, Integer numberOfTwitterConversations)
	{
		List<sf4twitter__Twitter_Conversation__c> twitterConversations = new List<sf4twitter__Twitter_Conversation__c>();
		Integer counter = 1;	
		String timestamp = getTimestamp(null);	
		
		for(Contact c : Contacts)
		{
			for(Integer i = 0; i < numberOfTwitterConversations; i++)
			{
				
				sf4twitter__Twitter_Conversation__c twit = new sf4twitter__Twitter_Conversation__c();
				
				twit.sf4twitter__contact__c = c.Id;			
				twit.sf4twitter__TwitterID__c = 'TwitterId ' + timestamp + ' #' + counter;
				
				twitterConversations.add(twit);
				
				counter++;
			}
		}
		
		return twitterConversations;
	}   
	*/
		
	/*	
	public static List<SF4Twitter__Twitter_Conversation__c> getConversations(Integer numberofConversations)
	{
		List<SF4Twitter__Twitter_Conversation__c> conversations = new List<SF4Twitter__Twitter_Conversation__c>();
		Integer counter = 0;
		
		for(Integer i = 0; i < numberOfConversations; i++)
		{
			String timestamp = getTimestamp(DateTime.now());
			SF4Twitter__Twitter_Conversation__c c = new SF4Twitter__Twitter_Conversation__c();			
			
			c.sf4twitter__Author_Real_Name__c = 'Test Twitter User ' + timestamp;
			c.sf4twitter__TwitterID__c = timestamp + '-' + counter;
			c.sf4twitter__Published_Date__c = System.now(); 
			c.sf4twitter__Status__c = 'New';
			
			conversations.add(c);
			
			counter++;						
		}
		
		return conversations;
	}*/
	
	private static testMethod void test1()
	{
		Integer numberOfAccounts = 1;
		Integer numberOfLeads = 1;
		Integer numberOfContactsPerAccount = 1;
		
		//Add accounts
		List<Account> accounts = getAccounts(numberOfAccounts);				
		
		insert accounts;					
		
		accounts = [SELECT Id FROM Account WHERE Id IN :accounts];
		
		System.assertEquals(numberOfAccounts, accounts.size(), getAssertMessage(1, 1));
		
		//Add Open Account Tasks
		List<Task> openAccountTasks = getOpenTasksForWhat('Open Account Task Test', UGears.USObject.getSetFromSObjectList(accounts, 'Id'));
		
		insert openAccountTasks;
		
		openAccountTasks = [SELECT Id FROM Task WHERE Id IN :openAccountTasks];
		
		System.assertEquals(numberOfAccounts, openAccountTasks.size(), getAssertMessage(1, 2));
		
		//Add Open Account Events
		List<Event> openAccountEvents = getOpenEventsForWhat('Open Account Event Test', UGears.USObject.getSetFromSObjectList(accounts, 'Id'));
		
		insert openAccountEvents;
		
		openAccountEvents = [SELECT Id FROM Event WHERE Id IN :openAccountEvents];
		
		System.assertEquals(numberOfAccounts, openAccountEvents.size(), getAssertMessage(1, 3));
		
		//Add Completed Account Tasks
		List<Task> completedAccountTasks = getCompletedTasksForWhat('Completed Account Task Test', UGears.USObject.getSetFromSObjectList(accounts, 'Id'));
		
		insert completedAccountTasks;
		
		completedAccountTasks = [SELECT Id FROM Task WHERE Id IN :completedAccountTasks];
		
		System.assertEquals(numberOfAccounts, completedAccountTasks.size(), getAssertMessage(1, 4));
		
		//Add Completed Account Events
		List<Event> completedAccountEvents = getCompletedEventsForWhat('Completed Account Event Test', UGears.USObject.getSetFromSObjectList(accounts, 'Id'));
		
		insert completedAccountEvents;
		
		completedAccountEvents = [SELECT Id FROM Event WHERE Id IN :completedAccountEvents];
		
		System.assertEquals(numberOfAccounts, completedAccountEvents.size(), getAssertMessage(1, 5));		
		
		//Add contacts
		List<Contact> contacts = getContacts(accounts, numberOfContactsPerAccount);
		
		addEmailToRecords(contacts, 'Email');
		
		insert contacts;
		
		contacts = [SELECT Id, AccountId FROM Contact WHERE Id IN :contacts];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, contacts.size(), getAssertMessage(1, 6));
		
		//Add Contact Notes
		List<Note> contactNotes = getNotes(contacts);
		
		insert contactNotes;
		
		contactNotes = [SELECT Id FROM Note WHERE ParentId IN :contacts];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, contactNotes.size(), getAssertMessage(1, 7));
		
		//Add Contact Attachments
		List<Attachment> contactAttachments = getAttachments(contacts);
		
		insert contactAttachments;
		
		contactAttachments = [SELECT Id FROM Attachment WHERE ParentId IN :contacts];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, contactAttachments.size(), getAssertMessage(1, 8));
		
		//Add Open Contact Tasks
		List<Task> openContactTasks = getOpenTasksForWho('Open Contact Task Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'));
		
		insert openContactTasks;
		
		openContactTasks = [SELECT Id FROM Task WHERE Id IN :openContactTasks];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openContactTasks.size(), getAssertMessage(1, 9));
		
		//Add Open Contact Events
		List<Event> openContactEvents = getOpenEventsForWho('Open Contact Event Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'));
		
		insert openContactEvents;
		
		openContactEvents = [SELECT Id FROM Event WHERE Id IN :openContactEvents];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openContactEvents.size(), getAssertMessage(1, 10));
		
		//Add Completed Contact Tasks
		List<Task> completedContactTasks = getCompletedTasksForWho('Completed Contact Task Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'));
		
		insert completedContactTasks;
		
		completedContactTasks = [SELECT Id FROM Task WHERE Id IN :completedContactTasks];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, completedContactTasks.size(), getAssertMessage(1, 11));
		
		//Add Completed Contact Events
		List<Event> completedContactEvents = getCompletedEventsForWho('Open Contact Event Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'));
		
		insert completedContactEvents;
		
		completedContactEvents = [SELECT Id FROM Event WHERE Id IN :completedContactEvents];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, completedContactEvents.size(), getAssertMessage(1, 12));
		
		//Add Open Account/Contact Tasks
		List<Task> openAccountContactTasks = getOpenTasksForWhoWhat('Open Account/Contact Task Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'), UGears.USObject.getSetFromSObjectList(contacts, 'AccountId'));
		
		insert openAccountContactTasks;
		
		openAccountContactTasks = [SELECT Id FROM Task WHERE Id IN :openAccountContactTasks];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openAccountContactTasks.size(), getAssertMessage(1, 13));
		
		//Add Completed Account/Contact Tasks
		List<Task> completedAccountContactTasks = getCompletedTasksForWhoWhat('Completed Account/Contact Task Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'), UGears.USObject.getSetFromSObjectList(contacts, 'AccountId'));
		
		insert completedAccountContactTasks;
		
		completedAccountContactTasks = [SELECT Id FROM Task WHERE Id IN :completedAccountContactTasks];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openAccountContactTasks.size(), getAssertMessage(1, 14));
		
		//Add Open Account/Contact Events
		List<Event> openAccountContactEvents = getOpenEventsForWhoWhat('Open Account/Contact Event Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'), UGears.USObject.getSetFromSObjectList(contacts, 'AccountId'));
		
		insert openAccountContactEvents;
		
		openAccountContactEvents = [SELECT Id FROM Event WHERE Id IN :openAccountContactEvents];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openAccountContactEvents.size(), getAssertMessage(1, 13));
		
		//Add Completed Account/Contact Events
		List<Event> completedAccountContactEvents = getCompletedEventsForWhoWhat('Completed Account/Contact Event Test', UGears.USObject.getSetFromSObjectList(contacts, 'Id'), UGears.USObject.getSetFromSObjectList(contacts, 'AccountId'));
		
		insert completedAccountContactEvents;
		
		completedAccountContactEvents = [SELECT Id FROM Event WHERE Id IN :completedAccountContactEvents];
		
		System.assertEquals(numberOfAccounts * numberOfContactsPerAccount, openAccountContactEvents.size(), getAssertMessage(1, 14));		
		
		//Add cases
		List<Case> cases = getCases(accounts);
				
		insert cases;
		
		cases = [SELECT Id FROM Case WHERE Id IN :cases];
		
		System.assertEquals(numberOfAccounts, cases.size(), 'Case counts don\'t match');
		
		//Add case comments
		List<CaseComment> caseComments = getCaseComments(cases);
				
		insert caseComments;
		
		caseComments = [SELECT Id FROM CaseComment WHERE Id IN :caseComments];
		
		System.assertEquals(cases.size(), caseComments.size(), 'Case comment counts don\'t match');
				
		//Add products		
		
		//List<Product2> products = new List<Product2>();		
		List<Product2> products = getProducts(4);
				
		insert products;				
						
		products = [SELECT Id FROM Product2 WHERE Id IN :products];
		
		System.assertEquals(4, products.size(), 'Product counts don\'t match');			
		
		/*//Add pricebook
		Pricebook2 pricebook = getPricebook('Test Pricebook ' + getTimestamp(DateTime.now()));
		
		insert pricebook;
		
		List<Pricebook2> pricebooks = [select Id from Pricebook2 where Id = :pricebook.Id and Name like 'Test Pricebook%'];
		
		System.assertEquals(1, pricebooks.size(), 'Test pricebook counts don\'t match');
		
		//Add products to standard pricebook
		List<PricebookEntry> standardPricebookEntries = getStandardPricebookEntries(products);
		
		insert standardPricebookEntries;
		
		standardPricebookEntries = [select Id from PricebookEntry where Id in :standardPricebookEntries];
		
		System.assertEquals(4, standardPricebookEntries.size(), 'Standard pricebook entry counts don\'t match');
		
		//Add products to test pricebook
		List<PricebookEntry> pricebookEntries = getPricebookEntries(pricebook, products);
		
		insert pricebookEntries;
		
		pricebookEntries = [select Id from PricebookEntry where Id in :pricebookEntries];
		
		System.assertEquals(4, pricebookEntries.size(), 'Pricebook entry counts don\'t match');					
	*/
		//Add opportunities
		List<Opportunity> opps = getOpportunities(accounts);
		
		insert opps;
		
		opps = [SELECT Id FROM Opportunity WHERE Id IN :opps];
		
		System.assertEquals(accounts.size(), opps.size(), 'Opportunity counts don\'t match');
		
		//Add opportunity line items
/*		List<OpportunityLineItem> oppLineItems = getOpportunityLineItems(opps, pricebookEntries[0]);
		
		insert oppLineItems;
		
		oppLineItems = [select Id from OpportunityLineItem where Id in :oppLineItems];
		
		System.assertEquals(opps.size(), oppLineItems.size(), 'OpportunityLineItem counts don\'t match');
	*/	
		//Add leads
		List<Lead> leads = getLeads(numberOfLeads);
		
		for(Lead l : leads)
		{
			addEmailToRecord(l, 'Email');			
		}
		
		insert leads;					
		
		leads = [SELECT Id FROM Lead WHERE Id IN :leads];
		
		System.assertEquals(numberOfLeads, leads.size(), 'Lead counts don\'t match');

		//Add a user			
		User u = getUserRecord([SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id);
				
		System.assert(u != null, 'User record is null');
		
		//String profileId = getStandardProfileId('System Administrator');
		
		Map<String, Object> keyValueMap = new Map<String, Object>();
		
		keyValueMap.put('Phone', '1234567890');
		
		addValueToSObjects(leads, keyValueMap);		
	}	   
}