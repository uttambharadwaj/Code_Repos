trigger Z_SC_Trigger on Shipment_Charge__c (after insert) {
  
  Z_SC_TriggerHandler handler = new Z_SC_TriggerHandler(); 
  
  if (Trigger.isAfter) {
    if (Trigger.isInsert) {
      handler.onAfterInsert(Trigger.newMap); 
    }
  }
  
}