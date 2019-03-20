global class ContactCountBackfill implements  Database.Batchable<sObject> {

	global final String query; 

	public ContactCountBackfill(boolean isTest)
	{		
		string tmpQuery; 
    	tmpQuery =  ' select id from account where Contact_Count__c = null '; 
		
	    if(isTest == true)
	    {
	    	tmpQuery +=	' LIMIT 1';	
	    }  
	      
		query = tmpQuery;	
	}
	
    global Database.QueryLocator start(Database.BatchableContext BC)
    {   
          return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {        
    	set <id> accountIds = new set <id>();
    	
    	for(sObject so : scope)
   		{
   			Account a = (Account)so;
   			accountIds.add(a.id);
   		}     
    	
   		UContact.countContacts (accountIds);
    }
    
  
	global void finish(Database.BatchableContext BC)
	{
		 
	}
	
	public static testMethod void testCode() 
   	{              
    	ID batchprocessid = Database.executeBatch( new ContactCountBackfill(true));
    }
	
	
}