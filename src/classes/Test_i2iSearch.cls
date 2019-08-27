@isTest
private class Test_i2iSearch {

	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}


	static testMethod void test_SearchPage() {
        
        
        
        
        //test.startTest();
        
        //*************load data
       
		Program__c program = new Program__c(name='test');
		
		insert program;
		
		Map<string,campaign> campaigns = new map<string,campaign>();
		List<string> couponcodes = new List<string>{'test1','test2','test3','test4','test5','test6'};
		for(string s : couponcodes)
		{
			Campaign c = new Campaign(name='test',coupon_code__c=s);
			campaigns.put(s,c);
		}
		
		insert campaigns.values();
		
		List<Campaign_Program__c> campaignprograms = new List<Campaign_Program__c>();
		for(Campaign cc : campaigns.values())
		{
			Campaign_Program__c cp = new Campaign_Program__c();
			cp.campaign__c = cc.id;
			cp.program__c = program.id;
			campaignprograms.add(cp);
		}
		insert campaignprograms;

		List<Account> accounts = utestdata.getAccounts(1);
		insert accounts;
		
		List<Contact> contacts = utestdata.getContacts(accounts,1);//2);
		integer x = 0;
		for(contact c : contacts)
		{
			c.i2i_ID__c = '1';
			/*
			if(x==0) c.email='test@test.com';
			else c.i2i_id__c = 'test';
			x++;
			*/
		}
		insert contacts;
		
		List<Opportunity> opportunities = utestdata.getOpportunities(accounts);
		//opportunities[0].Campaign__c = campaigns.get('test1').Id;
		opportunities[0].CampaignId = campaigns.get('test1').Id;
		insert opportunities;
		
		
		
		List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
		for(Contact cc : contacts)
		{
			OpportunityContactRole ocr = new OpportunityContactRole(opportunityid=opportunities[0].id,contactid=cc.id);
			ocrs.add(ocr);
		}
		insert ocrs;
		
		CampaignMember cm = new CampaignMember(contactid=contacts[0].Id, campaignid=campaigns.get('test1').Id, status='Sent');
		insert cm;

		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		insert gs;
		
		Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
		Lead_record_Type__c lrt = new Lead_record_Type__c();
		lrt.name='test';
		lrt.Lead_Record_Type_ID__c = rectId2;
		lrt.ProgramID__c = program.Id;
		insert lrt;
		
		Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
		User u = utestdata.getUserRecord((string)profileId);
		insert u;
		
		Sales_Activity_by_Profile__c sabp = new Sales_Activity_by_Profile__c();
		sabp.name='test';
		sabp.ProfileID__c = profileid;
		insert sabp;
				
		List<Lead> leads = utestdata.getLeads(1); //3);
		//Integer i = 0;
		for(lead l : leads)
		{
			//if(i==0)
			//{
				l.RecordTypeId = rectId;
				l.i2i_ID__c = '4';
				l.i2i_Coupon_Code_Pass__c = 'test4';
			/*}else if(i==1)
			{
				l.RecordTypeId = rectId;
				l.Email = 'test@test1.com';
				l.i2i_coupon_code_pass__c = 'test5';
			}else
			{
				l.RecordTypeId = rectId;
				l.i2i_ID__c = 'test6';
				l.i2i_coupon_code_pass__c = 'test6';
			}
			
			i++;
			*/
		}
		
		insert leads;
		
		Lead childlead = [Select id from Lead Where Parent_Lead__c = :leads[0].id];
		
		Task t = new task(status='Completed',type='test',whoid=childlead.Id,OwnerId=u.Id, ActivityDate=system.now().date());
		insert t;
		
		//CampaignMember cm2 = new CampaignMember(leadid=childlead.Id, campaignid=campaigns.get('test4').Id, status='Sent');
		//insert cm2;
		
		//shouldnt need a task since created recently (<90days)
		
        //*********load data end

        
        //test.stopTest();
        
        test.startTest();
        
        test.setMock(httpcalloutmock.class,new Test_i2iHttpCallOutMock());
        
        PageReference leftnav = page.i2ileftnav;
        PageReference srchPage = page.i2iSearchPage;
        
        i2iSearchController i2isc = new i2iSearchController();
        
        List<SelectOption> selects = i2isc.programValues;
        
        //test.setCurrentPage(leftnav);
        test.setCurrentPage(srchPage);
        i2isc.initLeftNavPage();
        i2isc.initPage();
        i2isc.clearForm();
        
        i2isc.findbyBusiness();
        i2isc.findbyPhone();
        i2isc.programSelected = 'Test Program';
        i2isc.promocode = 'testtesttes';
        i2isc.phoneNumber = '13111111111';
        i2isc.company = 'test';
        i2isc.zipcode = '11111';
        
              
        //test.setCurrentPage(i2isc.searchi2iLeftNav());
        //test.setcurrentpage(leftnav);
        //test.setcurrentpage(srchpage);
        
        
        
        //PageReference pg0 = i2isc.searchi2iLeftNav();
        i2isc.searchi2i();

        system.debug('... records: ' + i2isc.records);
        
        //after build data and doing a search need to go through lead wrapper and call functions
       	//go through contact wrapper and call functions
       	//go through nomatchdatawrapper and call functions
       	
       	system.debug('-- leadwrappers: ' + i2isc.leadwrappers);
       	system.debug('-- contactwrappers: ' + i2isc.contactwrappers);
       	system.debug('-- nomatchwrappers: ' + i2isc.nomatchrecordwrappers);
       	
       	
       	PageReference pg1 = i2isc.leadwrappers[0].openlead();
       	PageReference pg2 = i2isc.leadwrappers[0].convertlead();
       	PageReference pg3 = i2isc.contactwrappers[0].opencontact();
       	PageReference pg4 = i2isc.nomatchrecordwrappers[0].createleadredirect();
       	PageReference pg5 = i2isc.nomatchrecordwrappers[1].convertlead();
       	
       	boolean isprod = i2iget.inProduction();
       	double secs = i2iget.getDifferenceInMilliSeconds(system.now(), system.now().addSeconds(-20));       
        test.stopTest();
        
    }
    public static void setupdata()
    {
    	
    }
    
}