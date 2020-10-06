@isTest
 class Test_UpdateExpCreditInsuranceFlag {
 @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testmethod void testScheduler() {
   Test.startTest();

   String CRON_EXP = '0 0 0 15 9 ? 2030';

      //Account a = new Account();
      //a.Name = 'test_Account_For_Securities';
      Account a = TestDatatUtility.getAccount(); 
      insert a; 
       
      //'0012200000FHt3W' 
      Credit_Insurance__c c = new Credit_Insurance__c(Account__c = a.id, Expiration_Date__c = system.now().date().adddays(-90), isExpired__c = FALSE);
      insert c;

	  system.debug('Credit Insurance  record: ' + c);	
      String jobId = System.schedule('testUpdateExpCreditInsuranceFlag', CRON_EXP, 
         new UpdateExpCreditInsuranceFlag_Scheduler());

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      System.assertEquals(CRON_EXP, ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2030-09-15 00:00:00', String.valueOf(ct.NextFireTime));
      System.assertNotEquals(FALSE, [SELECT id, isExpired__c FROM Credit_Insurance__c WHERE id = :c.id].isExpired__c);

   Test.stopTest();

   System.assertEquals(TRUE, [SELECT id, isExpired__c FROM Credit_Insurance__c WHERE id = :c.id].isExpired__c);

   }
}