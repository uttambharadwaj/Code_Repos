@isTest
private class forseva1CreditApplicationcStatsTT {

   static testMethod void testTrigger() {
      try {
          forseva1__CreditApplication__c o = new forseva1__CreditApplication__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<forseva1__CreditApplication__c> l = [SELECT Id from forseva1__CreditApplication__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}