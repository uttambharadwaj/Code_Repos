public with sharing class Z_Agreement_TriggerHandler {

  public Z_Agreement_TriggerHandler() {
  
  }
  
  // Called after the agreement is updated
  // Used to update the quote customer approval flag when 
  // the agreement is signed. 
  public void onAfterUpdate(List<echosign_dev1__SIGN_Agreement__c> newAs, 
    map<Id, echosign_dev1__SIGN_Agreement__c> oldAsMap) {
    Set<Id> qIds; 
    Map<Id, zqu__Quote__c> qMap; 
    
    // Get quotes related to the agreements
    qIds = new Set<Id>(); 
    for (echosign_dev1__SIGN_Agreement__c a : newAs) {
      qIds.add(a.Quote__c); 
    }
    
    qMap = new Map<Id, zqu__Quote__c>([
      SELECT  Id, 
        CustomerApproval__c, 
        zqu__Status__c  
      FROM   zqu__Quote__c 
      WHERE  Id in: qIds]); 
    
    // Loop through the agreements 
    // and update flags on related quotes
    for (echosign_dev1__SIGN_Agreement__c a : newAs) {
        // We don't want the status/record type changed if the quote has already been sent to the vendor/Zuora
        if(a.Quote__c != null) {
        	if((qMap.get(a.Quote__c).zqu__Status__c).equalsIgnoreCase('Issued Order')) {
            	continue;
        	}
        }
        
      // If the new status doesn't equal the old status, and it's signed, then set Customer Approval
      if (a.echosign_dev1__Status__c != oldAsMap.get(a.Id).echosign_dev1__Status__c && a.echosign_dev1__Status__c == 'Signed') {
        if (a.Quote__c != null) { 
          qMap.get(a.Quote__c).CustomerApproval__c = true; 
        }    
      } 
        
      // If the new status doesn't equal the old status, and it's signed, then set Out For Signature  
      if (a.echosign_dev1__Status__c != oldAsMap.get(a.Id).echosign_dev1__Status__c && a.echosign_dev1__Status__c == 'Out for Signature') {
        if (a.Quote__c != null) { 
          qMap.get(a.Quote__c).zqu__Status__c = 'Out for Signature'; 
        }
      }
        
      // Check to see if the agreement was rejected and set it back to 'New' so the quote can be edited and resent
      if (a.echosign_dev1__Status__c != oldAsMap.get(a.Id).echosign_dev1__Status__c && a.echosign_dev1__Status__c == 'Cancelled / Declined') {
        if (a.Quote__c != null) { 
          qMap.get(a.Quote__c).zqu__Status__c = 'New';
          qMap.get(a.Quote__c).Approved__c = false;
          qMap.get(a.Quote__c).RecordTypeId = UtilityClass.getRecordTypeByName(zqu__Quote__c.getSObjectType(), 'Default');
        }    
      } 
    }
    
    update qMap.values(); 
    
  } 

}