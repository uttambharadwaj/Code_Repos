@istest
class Test_UpdateExpiredSecuritiesFlag{

   static testmethod void testScheduler() {
   Test.startTest();

   String CRON_EXP = '0 0 0 18 9 ? 2030';

      //Account a = new Account();
      //a.Name = 'test_Account_For_Securities';
      Account a = TestDatatUtility.getAccount(); 
       System.debug('Account-->'+a);
      insert a; 
       
      //'0012200000FHt3W' 
      Security__c s = new Security__c(Account__c = a.id, Security_Expiry_Date__c = system.now().date().adddays(-90), isExpired__c = FALSE, Security_Limit__c = 1000);
      insert s;
       s.Security_Limit__c = 500;
       update s;
       

	  system.debug('Security record: ' + s);	
      //String jobId = System.schedule('testUpdateExpiredSecuritiesFlag_Scheduler', CRON_EXP, 
        // new UpdateExpiredSecuritiesFlag_Scheduler());
       UpdateExpiredSecuritiesFlag_Scheduler sch = new UpdateExpiredSecuritiesFlag_Scheduler();
       String jobId = System.schedule('testUpdateExpiredSecuritiesFlag_Scheduler', CRON_EXP, sch);
		sch.execute(null);


      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      System.assertEquals(CRON_EXP, ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
     System.assertEquals('2030-09-18 00:00:00', String.valueOf(ct.NextFireTime));
      System.assertNotEquals(FALSE, [SELECT id, isExpired__c FROM Security__c WHERE id = :s.id].isExpired__c);

   Test.stopTest();

   System.assertEquals(TRUE, [SELECT id, isExpired__c FROM Security__c WHERE id = :s.id].isExpired__c);

   }
    static testmethod void testUpdateSecBatch(){
        
      Test.startTest();
       Account a = TestDatatUtility.getAccount(); 
       
       System.debug('Account-->'+a);
      insert a; 
       
      //'0012200000FHt3W' 
     List<Security__c> secList = new List<Security__c>();
      Security__c s = new Security__c(Account__c = a.id, Security_Expiry_Date__c = system.now().date().addMonths(-90), isExpired__c = FALSE, Security_Limit__c = 1000);
        secList.add(s);
        System.debug('SecList' + secList);
      insert secList;
        
        UpdateExpiredSecuritiesFlag_Batch updateSecBatch = new UpdateExpiredSecuritiesFlag_Batch();
        Database.executeBatch(updateSecBatch);
        Test.stopTest();
       

        
    }
}