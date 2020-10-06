trigger Z_Agreement_Trigger on echosign_dev1__SIGN_Agreement__c (before update, after update) {
  Z_Agreement_TriggerHandler handler = new Z_Agreement_TriggerHandler(); 
  
  if (Trigger.isUpdate) {
    if (Trigger.isAfter) {
      handler.onAfterUpdate(Trigger.new, Trigger.oldMap); 
    }
  }
}