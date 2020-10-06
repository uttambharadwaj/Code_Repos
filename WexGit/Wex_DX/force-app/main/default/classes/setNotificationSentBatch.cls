global class setNotificationSentBatch implements  Database.Batchable<sObject> {

	//ID batchprocessid = Database.executeBatch(new setNotificationSentBatch());

	global final String query; 
	global final id recTypeId;
	global final id owner;
	
	public setNotificationSentBatch()
	{   
		GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
		recTypeId = gs.Virtual_Card_RecType_ID__c;
		owner = gs.Virtual_Card_Queue_ID__c;
		
		
		
		string tmpQuery;
    	tmpQuery = ' select id, notification_sent__c  ';
    	tmpQuery += ' from case ';
    	tmpQuery += ' where no_account_manager__c = true ';
    	tmpQuery += ' and notification_sent__c = false ';
    	tmpQuery += ' and RecordTypeID = :recTypeId ';
    	tmpQuery += ' and ownerId = :owner ';
    	                                
    	
	    if(test.isRunningTest() == true)
	    {
	    	tmpQuery +=	' LIMIT 1';	
	    }  
	      
		query = tmpQuery;	 
		
		system.debug('-----query = ' + query);
		
	}
	
    global Database.QueryLocator start(Database.BatchableContext BC)
    {   
          return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {  
    	UCase.setNotificationFromBatch (scope);      
    }
  
	global void finish(Database.BatchableContext BC)
	{
	}
	
}