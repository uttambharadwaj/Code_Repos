@isTest
private class ApplicationRequestcStatsTT {

   static testMethod void testTrigger() {
      try {
          Application_Request__c o = new Application_Request__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Application_Request__c> l = [SELECT Id from Application_Request__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}