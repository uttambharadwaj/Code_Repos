/**
 * 	Created by: Phillip Southern (GearsCRM) 12/10/2013
 *	Description: Test class for additional methods in Ulead class (lead marketing for wex)
 *
 *
 */

 
@isTest
private class Test_LeadMarketing {

	@testSetup
	static void setup(){
		UtilityTestLoader.setAutomation(false);
	}

	static testMethod void testLinking(){
		
		test.startTest();
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		insert gs;
		
		Account a = new account(name='test');
		insert a;
		Contact c = new Contact(lastname='test',firstname='test',i2i_id__c='test',email='test@yahoo.com',accountid=a.id);
		insert c;
		test.stopTest();
		
		Lead l = new lead(company='test',lastname='test',i2i_id__c='test',recordtypeid=gs.Parent_Lead_Record_Type_Id__c);
		insert l;
		lead l2 = new lead(company='test',lastname='test',email='test@yahoo.com',recordtypeid=gs.Parent_Lead_Record_Type_Id__c);
		insert l2;
		
		for(lead ld : [select id, related_contact__c, related_account__c from lead])
		{
			//system.assert(ld.related_contact__c != null && ld.Related_Account__c != null);
			system.assert(ld.related_contact__c != null);
		}
	}
	
	static testMethod void test_decoupleLead()
	{
		test.startTest();
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		
		User u = [Select Id, ProfileId, isactive from User Where Profile.Name='System Administrator' AND IsActive = true LIMIT 1];
        gs.Parent_Lead_Queue__c = u.Id;
		insert gs;
		
		Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
		
		List<Lead> leads = Utestdata.getLeads(2);
		
		//Integer x = 0;
		for(lead l : leads)
		{
			l.RecordTypeId = gs.Parent_Lead_Record_Type_Id__c;
			//l.email = 'test'+x+'@test.com';
			//x++;
		}
		insert leads;
		
		leads[0].email='test0@test.com';
		leads[1].email='test1@test.com';
		
		update leads;
		
		
		List<Lead> childLeads = utestdata.getLeads(2);
		Integer y = 0;
		for(lead ld : childleads)
		{
			ld.recordtypeid = rectid2;
			//ld.email='test'+y+'@test.com';
			ld.Parent_Lead__c=leads[y].id;
			ld.Email = leads[y].email;
			
			y++;
		}
		
		insert childleads;
		
		test.stopTest();
		
		system.debug('--- updating emails in test class');
		
		childleads[0].Email = 'test1@test.com';
		childleads[1].Email = 'test3@test.com';
		
		update childleads;
		
		//system assert three parent leads and first one parent lead updated to second in parent
		//lead array
		
		system.assertequals([select id from lead 
				where recordtypeid = :gs.Parent_Lead_Record_Type_Id__c].size(),4);

		//system.assertequals([select parent_lead__c from lead 
		//		where id = :childleads[0].Id].Parent_Lead__c, leads[1].Id);
				
		//assert recursion did not occur
		system.assertequals([select id from lead 
			where recordtypeid != :gs.Parent_Lead_Record_Type_Id__c].size(),2);

		system.assertEquals([select id from lead where recordtypeid != :gs.Parent_Lead_Record_Type_Id__c
			AND Parent_Lead__c = null].size(),0);

		
		
	}
	static testMethod void findCampaigns() {
        test.startTest();
        User u = [Select Id, ProfileId, isactive from User Where Profile.Name='System Administrator' AND IsActive = true LIMIT 1];
        Default_Campaigns__c dc = new Default_Campaigns__c(name='test',coupon_code__c='TEST',profileid__c=(string)u.profileid);
        insert dc;
        
        Campaign c = new Campaign(name='test',coupon_code__c='TEST');
        insert c;
        
        Campaign c2 = new Campaign(name='test2',coupon_code__c='TEST2');
        insert c2;
        
        Id rectIdchild = [Select Id from RecordType Where sobjectType='Lead' AND Name != 'Parent Lead' AND IsActive=true LIMIT 1].Id;
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		//User u = [Select Id, ProfileId, isactive from User Where Profile.Name='System Administrator' AND IsActive = true LIMIT 1];
        gs.Parent_Lead_Queue__c = u.Id;
		insert gs;
        test.stopTest();
        
        Lead l;
        system.runas(u)
        {
        	//Lead 
        	l = new lead(lastname='test',firstname='test',company='test');
        	insert l;
        	
        	Opportunity o = new opportunity(name='test',stagename='test',closedate=system.now().date());
        	insert o;
        }
        
        
        system.assertnotequals([select primary_campaign__c from Lead limit 1].primary_campaign__c,null);
        
        l.Primary_Campaign__c = c2.id;
        update l;
        
        system.assertequals([select id from campaignmember].size(),2);
        
        //take out to test
        //system.assertnotequals([select campaignid from Opportunity limit 1].campaignid,null);
        
    }
    
    
    static testMethod void mergeParents()
    {
    	//testing the merge function for Ulead and UContact.
    	
    	test.startTest();
		Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		insert gs;
		
		Merge_Record_Mapping__c mrm = new Merge_Record_Mapping__c();
		mrm.Name='test';
		mrm.API_Field_Name__c='Phone';
		mrm.Object_Name__c='Lead';
		insert mrm;
		
		Merge_Record_Mapping__c mrm2 = new Merge_Record_Mapping__c();
		mrm2.Name='test1';
		mrm2.API_Field_Name__c='Phone';
		mrm2.Object_Name__c='Contact';
		insert mrm2;
		
			
		test.stopTest();
		
		//Lead l = new Lead(lastname='test',company='test', email='test@test.com', i2i_Contact_Id__c='111', recordtypeid=gs.Parent_Lead_Record_Type_Id__c);
		//insert l;
		//Lead l2 = l.clone();
		//l2.phone='1111111111';
		//insert l2;
		
		Lead l3 = new Lead(lastname='test',company='test',i2i_id__c='1', recordtypeid=gs.Parent_Lead_Record_Type_Id__c);
		insert l3;
		Lead l4 = l3.clone();
		l4.phone='1111111111';
		insert l4;
		
		
		List<Lead> leadQuery = [Select Phone from Lead where recordtypeid = :gs.Parent_Lead_Record_Type_Id__c];
		
		//system.assertequals(leadQuery.size(),2);
		system.assertEquals(leadQuery.size(),1);
    	
    }
    
   /*
    static testMethod void mergeContacts()  //Ucontact class
    {
    	//testing the merge function for Ulead and UContact.
    	
    	test.startTest();
		
		Merge_Record_Mapping__c mrm2 = new Merge_Record_Mapping__c();
		mrm2.Name='test1';
		mrm2.API_Field_Name__c='Phone';
		mrm2.Object_Name__c='Contact';
		insert mrm2;
		
		Account a = utestdata.getAccounts(1)[0];
		insert a;
			
		test.stopTest();
		
		Contact c = new contact(lastname='test',accountid=a.Id,email='test@test.com');
		insert c;
		Contact c2 = c.clone();
		c2.email='test@test2.com';
		insert c2;
		c2.phone='1111111111';
		c2.email = 'test@test.com';
		update c2;
		
		Contact c3 = new contact(lastname='test',accountid=a.Id,i2i_id__c='1');
		insert c3;
		Contact c4 = c3.clone();
		c4.i2i_id__c='2';
		insert c4;
		c4.phone='1111111111';
		c4.i2i_id__c = '1';
		update c4;


		
		List<Contact> contactQuery = [Select Phone from Contact];
		
		system.assertequals(contactQuery.size(),2);
    	
    }
    */
    
}