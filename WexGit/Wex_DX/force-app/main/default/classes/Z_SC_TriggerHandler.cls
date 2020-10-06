public with sharing class Z_SC_TriggerHandler {
  
  public Z_SC_TriggerHandler() {
  
  }
  
  public void onAfterInsert(Map<Id, Shipment_Charge__c> newSCsMap) {
    
    List<Shipment_Charge__c> scToUpdate; 
    Decimal minPrice; 
    
    scToUpdate = [SELECT  Id, 
        Name, 
        Min_Price_Check__c, 
        Effective_Price__c,
        Total__c,          
        ProductRatePlanCharge__r.WEXMinPrice__c 
      FROM    Shipment_Charge__c 
      WHERE   Id in: newSCsMap.keySet()]; 
    
    for (Shipment_Charge__c sc : scToUpdate) {
      try {
          minPrice = Decimal.valueOf(sc.ProductRatePlanCharge__r.WEXMinPrice__c); 
      } catch(Exception e) {
          minPrice = 0;
      }
      if (sc.Total__c < minPrice) {
        sc.Min_Price_Check__c = 0; 
      }
      else {
        sc.Min_Price_Check__c = 1; 
      }
    }
    
    update scToUpdate; 
    
  }
  
}