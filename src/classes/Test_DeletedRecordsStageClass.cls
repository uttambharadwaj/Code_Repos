@isTest
private class Test_DeletedRecordsStageClass {

    static testMethod void test1() 
    {
        Account a = new Account();
		a.name = 'test';
		insert a;

		delete a;
		
		Deleted_Records_Stage__c d = [select id, record_id__c from Deleted_Records_Stage__c where record_id__c = :a.id];
		
		system.assertEquals(a.id, d.record_id__c);
		
    }
    
    static testMethod void test2()
    {
    	Lead l = new Lead();
    	l.company='test';
    	l.lastname='test';
    	insert l;
    	delete l;
    	
    	Deleted_Records_Stage__c d = [select id, record_id__c from Deleted_Records_Stage__c where record_id__c = :l.id];
		
		system.assertEquals(l.id, d.record_id__c);
    	
    }
}