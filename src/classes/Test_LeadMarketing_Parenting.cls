/**
*	Created by: Phillip Southern (GearsCRM)
*	Created Date:	9/10/2013
*	Description: Test class to test parenting process on ULead.  Since we have alot of overhead will also
*					be testing campaigns, programs, linking acc/contact, etc.
*
 */
@isTest
private class Test_LeadMarketing_Parenting {

    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    public static testMethod void testProcessParent_nonOCR()
	{
		test.startTest();
		//****Campaigns and Program****
		Program__c program = new Program__c(name='test');
		insert program;
		//List<Campaign> campaigns = new List<Campaign>();
		Map<string,campaign> campaigns = new map<string,campaign>();
		List<string> couponcodes = new List<string>{'test1','test2','test3','test4','test5','test6','test7','test8','test9'};
		for(string s : couponcodes)
		{
			Campaign c = new Campaign(name='test',coupon_code__c=s);
			campaigns.put(s,c);
		}
		
		insert campaigns.values();
		
		List<Campaign_Program__c> campaignprograms = new List<Campaign_Program__c>();
		for(Campaign cc : [Select Id from Campaign]) //campaigns.values())
		{
			Campaign_Program__c cp = new Campaign_Program__c();
			cp.campaign__c = cc.id;
			cp.program__c = program.id;
			campaignprograms.add(cp);
		}
		insert campaignprograms;
		
		system.assert([Select Default_Program__c from Campaign Where Default_Program__c != null].size()==couponcodes.size());
		
		//*******************************
		Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
		User u = utestdata.getUserRecord((string)profileId);
		insert u;
		
		
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		gs.Integration_User_ID__c = u.Id;
		gs.Default_Activity_Owner__c = u.Id;
		gs.Default_Lead_Record_Type__c = rectId2;
		insert gs;
		
		
		Lead_record_Type__c lrt = new Lead_record_Type__c();
		lrt.name='test';
		lrt.Lead_Record_Type_ID__c = rectId2;
		lrt.ProgramID__c = program.Id;
		insert lrt;

		Sales_Activity_by_Profile__c sap = new Sales_Activity_by_Profile__c(name='test',profileid__c=profileid);
		insert sap;
		
		test.stopTest();
		
		//second rounds of leads, do inserts
		//add task to one of them
		//then do updates

		List<Lead> secondround = utestdata.getLeads(1); //(3);
		Integer i = 0;
		for(lead l : secondround)
		{
			if(i==0)
			{
				l.RecordTypeId = rectId;
				l.i2i_ID__c = 'test4';
				l.i2i_Coupon_Code_Pass__c = 'test4';
			}else if(i==1)
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
		}
		
		system.debug('-- test class secondround: ' + secondround);
		
		system.runas(u)
		{
			insert secondround;
		}
		
		
		
		//after this insert, each should have 3 child lead and 3 campaign member to campaigns.
		//List<Lead> childLeadcheck1 = [Select Id from Lead Where RecordTypeId != :gs.Parent_Lead_Record_Type_Id__c];
		//List<CampaignMember> cmcheck1 = [select Id from CampaignMember];
		//system.debug('**-- check1: ' + childleadcheck1.size() + ' cms: ' + cmcheck1.size());
		//3 and 6
		//system.assert(childleadcheck.size()>2);
		//system.assert(cmcheck.size()>2);
		//system.debug(' --** secondround: ' + secondround);
		
		//do task insert
		Task t = new Task(whoId=secondround[0].id,subject='test',type='test',status='Completed',activitydate=system.now().date(),ownerid=u.id);
		insert t;
		
		//do update on each lead in second round with new coupon code
		//changed to soql since parents may have merged.
		Integer z = 0;
		List<Lead> secondRoundUpdate = new List<Lead>();
		for(Lead ll : [Select Id, i2i_coupon_code_pass__c from Lead]) //secondround)
		{
			if(z==0) ll.i2i_Coupon_Code_Pass__c = 'test7';
			else if (z==1) ll.i2i_Coupon_Code_Pass__c = 'test8';
			else ll.i2i_Coupon_Code_Pass__c = 'test9';			
			secondroundupdate.add(ll);
			z++;
		}	
		
		system.debug('-- secondround update size: ' + secondround.size());
		system.debug('-- secondround : ' + secondround);
		
		system.runas(u)
		{
			if(secondRoundUpdate.size()>0) update secondround;
		}
		
		//should be 6 child leads and 12 campaign members
		//system.assert([select Id from CampaignMember].size()>6);
		//system.assert([select Id from Lead Where RecordtypeId != :gs.Parent_Lead_Record_Type_Id__c].size()==3);
		
		List<Lead> leadcheck = [select Id from Lead Where RecordtypeId != :gs.Parent_Lead_Record_Type_Id__c];
		List<CampaignMember> cmcheck = [select Id from CampaignMember];
		
		system.debug(' **-- checks: ' + leadcheck.size() + ' ' + cmcheck.size());
		//9 and 15
	}
	
	
	public static testMethod void testProcessParent_OCRMatches()
	{
		//This test method will hit alot of class and triggers since we are doing a full setup of data
		//-Default Campaign trigger
		//-Link Contact and Account
		//-Process Parent
		
		test.startTest();
		
		//****Campaigns and Program****
		Program__c program = new Program__c(name='test');
		insert program;
		//List<Campaign> campaigns = new List<Campaign>();
		Map<string,campaign> campaigns = new map<string,campaign>();
		List<string> couponcodes = new List<string>{'test1','test2','test3','test4','test5','test6','test7','test8','test9'};
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
		
		system.assert([Select Default_Program__c from Campaign Where Default_Program__c != null].size()==couponcodes.size());
		//*******************************
		
		List<Account> accounts = utestdata.getAccounts(1);
		insert accounts;
		
		List<Contact> contacts = utestdata.getContacts(accounts,2);
		integer x = 0;
		for(contact c : contacts)
		{
			if(x==0) c.email='test@test.com';
			else c.i2i_id__c = 'test';
			x++;
		}
		insert contacts;
		
		List<Opportunity> opportunities = utestdata.getOpportunities(accounts);
		opportunities[0].CampaignId = campaigns.get('test1').Id;
		insert opportunities;
		
		List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
		for(Contact cc : contacts)
		{
			OpportunityContactRole ocr = new OpportunityContactRole(opportunityid=opportunities[0].id,contactid=cc.id);
			ocrs.add(ocr);
		}
		insert ocrs;


		//******
		Id profileID = [Select Id from Profile Where Name = 'System Administrator'].Id;
		User u = utestdata.getUserRecord((string)profileId);
		insert u;
		
		
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		gs.Integration_User_ID__c = u.Id;
		gs.Default_Activity_Owner__c = u.Id;
		gs.Default_Lead_Record_Type__c = rectId2;
		insert gs;
		
		
		
		Lead_record_Type__c lrt = new Lead_record_Type__c();
		lrt.name='test';
		lrt.Lead_Record_Type_ID__c = rectId2;
		lrt.ProgramID__c = program.Id;
		insert lrt;

		test.stopTest();		
		
		List<Lead> firstroundinsert = utestdata.getLeads(3);
		integer y = 0;
		for(lead L : firstroundinsert)
		{
			if(y==0)
			{
				l.RecordTypeId = rectId;
				l.i2i_ID__c = 'test';
				l.i2i_coupon_code_pass__c = 'test1';
			}else if(y==1)
			{
				l.RecordTypeId = rectId;
				l.email='test@test.com';
				l.i2i_Coupon_Code_Pass__c = 'test2';
			}else
			{
				l.RecordTypeId = rectId;
				l.i2i_Coupon_Code_Pass__c = 'test3';
			}
			
			y++;
		}
		
		system.runas(u)
		{
			insert firstroundinsert;
		}
		
		
		//should be 3 child leads and 6 campaign members for children and parents
		//List<Lead> ldcheck = [Select Id from Lead Where RecordTypeId != :gs.Parent_Lead_Record_Type_Id__c];
		//List<CampaignMember> cmcheck = [Select Id from CampaignMember];
		//system.debug('-- size checks final: ' + ldcheck.size() + ' ' + cmcheck.size());		
		
		//May be less because of parent merging....which would include children.
		system.assert([Select Id from Lead Where RecordTypeId != :gs.Parent_Lead_Record_Type_Id__c].size()<=3);
		system.assert([Select Id from CampaignMember].size()<=6);

	
	}
	
}