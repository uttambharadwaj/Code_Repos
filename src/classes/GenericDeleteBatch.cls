global class GenericDeleteBatch implements Database.Batchable<sObject> 
{
	global final String query;
	 
	public GenericDeleteBatch(string passedQueryName)
	{
		Map <string, GenericDeleteBatchQueries__c> queryMap = new Map <string, GenericDeleteBatchQueries__c>();
		
		for(GenericDeleteBatchQueries__c g : GenericDeleteBatchQueries__c.getAll().values())
		{
		 	queryMap.put(g.name.toLowerCase(), g);	
		}
		 
		query = queryMap.get(passedQueryName.toLowerCase()).queryString__c;
		system.debug('-----' + query);
	}
	
    global Database.QueryLocator start(Database.BatchableContext BC)
    {   
         
    	return Database.getQueryLocator(query);
    }
     
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{  
		delete scope;
    } 
	
	global void finish(Database.BatchableContext BC)
	{
	}
	
}