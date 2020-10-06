/*
	CreatedBy: Phillip Southern (GearsCRM)
	Date: 01/07/2014
	Description: test class for i2imerge method on ulead and ucontact class

*/

@isTest
private class Test_MergingLeadsContacts {

    
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void mergeLeads() {
        test.startTest();
        Id rectId = [Select Id from RecordType Where sobjectType='Lead' AND Name = 'Parent Lead' LIMIT 1].Id;
		GlobalSettings__c gs = new GlobalSettings__c(name='test');
		gs.Parent_Lead_Record_Type_Id__c = rectId;
		//gs.Integration_User_ID__c = u.Id;
		insert gs;
		
		system.debug('-- in testmethod gs: ' + gs);
		
		Id rectId2 = [Select Id from RecordType Where sobjecttype='Lead' And Id != :rectId And isActive=true LIMIT 1].id;
		
		Merge_Record_Mapping__c mrm = new Merge_Record_Mapping__c();
		mrm.Name = 'Phone';
		mrm.API_Field_Name__c = 'Phone';
		mrm.Object_Name__c = 'Lead';
		insert mrm;
        
        Lead l = new Lead(lastname='test',company='test',i2i_id__c='test', recordtypeid=rectId);
        insert l;
        
        Lead l2 = new Lead(lastname='test',company='test',i2i_id__c='test1',recordtypeid=rectId,Phone='1111111111');
        insert l2;
        
        List<Lead> childleads = utestdata.getLeads(4);
        Integer x = 0;
        for(lead chl : childleads)
        {
        	chl.Parent_Lead__c = (x<2) ? l.id:l2.id;
        	chl.RecordTypeId = rectid2;
        	x++;
        }
        
        insert childleads;
        test.stopTest();

        l2.i2i_id__c = 'test';
        update l2;
        
        system.assert([Select Id from Lead where recordtypeid = :gs.Parent_Lead_Record_Type_Id__c].size()==1);
        
        
        
    }
    
    
    /*
    static testMethod void mergeContacts() {
        test.startTest();
        
		Merge_Record_Mapping__c mrm = new Merge_Record_Mapping__c();
		mrm.Name = 'Phone';
		mrm.API_Field_Name__c = 'Phone';
		mrm.Object_Name__c = 'Contact';
		insert mrm;
        account a = new account(name='test');
        insert a;
        
        contact c = new Contact(lastname='test',accountid=a.Id,i2i_id__c='test');
        insert c;
        
        Contact c2 = new Contact(lastname='test',accountid=a.Id,i2i_id__c='test1',Phone='1111111111');
        insert c2;
        

        test.stopTest();

        c2.i2i_id__c = 'test';
        update c2;
        
        system.assert([Select Id from Contact].size()==1);
        
        
        
    }*/
}