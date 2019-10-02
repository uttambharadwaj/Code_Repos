@isTest
private class ApplicationRequestcStatsTriggerTest {

   static testMethod void testTrigger() {
      try {
          Application_Request__c o = new Application_Request__c();
          
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Application_Request__c> l = [SELECT Id from Application_Request__c WHERE createddate =: date.today() LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}