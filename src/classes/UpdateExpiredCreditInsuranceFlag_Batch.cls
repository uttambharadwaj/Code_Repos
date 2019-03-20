global class UpdateExpiredCreditInsuranceFlag_Batch implements Database.Batchable<sObject>{
	String query = 'SELECT Id, isExpired__c, Expiration_Date__c  FROM Credit_Insurance__c WHERE isExpired__c = false AND Expiration_Date__c  < TODAY';

  global Database.QueryLocator start(Database.BatchableContext BC) 
      {
        system.debug('--Credit Insurance query: ' + query);
        return Database.getQueryLocator(query);
      }

    
  global void execute(Database.BatchableContext BC, List<sObject> scope) 
  	{
        List<Credit_Insurance__c> updateCreditInsurance  = new List<Credit_Insurance__c	>();
        for(sObject s : scope){
            Credit_Insurance__c	 ci = (Credit_Insurance__c)s;
            if(ci.isExpired__c == FALSE && ci.Expiration_Date__c  < system.now().date()){
                ci.isExpired__c = TRUE;
                updateCreditInsurance.add(ci);
            }
        }
        
        if(!updateCreditInsurance.isEmpty())
           {
             Database.SaveResult[] results = Database.update(updateCreditInsurance,false);
           }
        
    }  
    
  global void finish(Database.BatchableContext BC) 
  {
    
  }  
}