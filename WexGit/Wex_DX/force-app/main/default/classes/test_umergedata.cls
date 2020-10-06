/*
*	Created by: Phillip Southern (GearsCRM)
*	Created Date: 020514
*	Description: Test class for UMergeRecords
*/

@isTest
public class test_umergedata {

	@testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testLeads()
	{
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
		
		Lead l = new Lead(lastname='test',company='test',email='test@test.com',i2i_id__c='1',recordtypeid=gs.Parent_Lead_Record_Type_Id__c,phone='1111111111');
		insert l;
		
		Lead l2 = new Lead(lastname='test',company='test',email='test@test2.com',i2i_id__c='2',recordtypeid=gs.Parent_Lead_Record_Type_Id__c);
		insert l2;
		
		test.stopTest();
		
		Merge_Records_Staging__c mr = new Merge_Records_Staging__c();
		mr.Original_i2i_ID__c = '1';
		mr.Most_Recent_i2i_ID__c = '2';
		insert mr;
		
		system.assertEquals([select id from lead where recordtypeid=:gs.Parent_Lead_Record_Type_Id__c].size(),1);
	
	}
	
	static testMethod void testContacts()
	{
		test.startTest();
		
		Merge_Record_Mapping__c mrm2 = new Merge_Record_Mapping__c();
		mrm2.Name='test1';
		mrm2.API_Field_Name__c='Phone';
		mrm2.Object_Name__c='Contact';
		insert mrm2;
		
		Account a = utestdata.getaccounts(1)[0];
		insert a;
		
		Contact c = new Contact(lastname='test',accountid=a.Id,i2i_id__c='1',email='test@test.com',phone='1111111111');
		insert c;
		
		Contact c2 = new Contact(lastname='test',accountid=a.Id,i2i_id__c='2',email='test@test2.com');
		insert c2;
		
		test.stopTest();
		
		Merge_Records_Staging__c mr = new Merge_Records_Staging__c();
		mr.Original_i2i_ID__c = '1';
		mr.Most_Recent_i2i_ID__c = '2';
		insert mr;
		
		system.assertequals([select id from contact].size(),1);
	}

	static testMethod void testContactsWithExcludes()
	{
		test.startTest();
		
		Merge_Record_Mapping__c mrm2 = new Merge_Record_Mapping__c();
		mrm2.Name='test1';
		mrm2.API_Field_Name__c='Phone';
		mrm2.Object_Name__c='Contact';
		insert mrm2;
		
		Account a = utestdata.getaccounts(1)[0];
		insert a;

		Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Truckers_Contacts' LIMIT 1].Id;
		
		Contact c = new Contact(lastname='test',accountid=a.Id,i2i_id__c='1',email='test@test.com',phone='1111111111',recordtypeid=rectypeid);
		insert c;
		
		Contact c2 = new Contact(lastname='test',accountid=a.Id,i2i_id__c='2',email='test@test2.com',recordtypeid=rectypeid);
		insert c2;
		
		test.stopTest();
		
		Merge_Records_Staging__c mr = new Merge_Records_Staging__c();
		mr.Original_i2i_ID__c = '1';
		mr.Most_Recent_i2i_ID__c = '2';
		insert mr;
		
		system.assertequals([select id from contact].size(),2);
	}
}