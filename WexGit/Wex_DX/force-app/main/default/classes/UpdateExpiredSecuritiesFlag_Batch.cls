global class UpdateExpiredSecuritiesFlag_Batch implements Database.Batchable<sObject>{
	String query = 'SELECT Id, isExpired__c, Security_Expiry_Date__c FROM Security__c WHERE isExpired__c = false AND Security_Expiry_Date__c < TODAY';

  global Database.QueryLocator start(Database.BatchableContext BC) 
      {
        system.debug('--Securities query: ' + query);
        return Database.getQueryLocator(query);
      }

    
  global void execute(Database.BatchableContext BC, List<sObject> scope) 
  	{
        List<Security__c> updateSecurity  = new List<Security__c>();
        for(sObject s : scope){
            Security__c sec = (Security__c)s;
            if(sec.isExpired__c == FALSE && sec.Security_Expiry_Date__c < system.now().date()){
                sec.isExpired__c = TRUE;
                updateSecurity.add(sec);
            }
        }
        
        if(!updateSecurity.isEmpty())
           {
             Database.SaveResult[] results = Database.update(updateSecurity,false);
           }
        
    }  
    
  global void finish(Database.BatchableContext BC) 
  {
    
  }  
}