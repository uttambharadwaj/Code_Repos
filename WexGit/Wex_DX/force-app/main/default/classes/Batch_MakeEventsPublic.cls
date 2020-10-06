global class Batch_MakeEventsPublic implements Database.Batchable<sObject> {
	
	String query;
	Date ninetydays = system.now().date().adddays(-90);
	
	global Batch_MakeEventsPublic() 
	{

		query = 'Select Id, IsVisibleInSelfService, CreatedDate from Event Where CreatedDate >= :ninetydays AND IsVisibleInSelfService = false';
		if(Test.isRunningTest())
		{
			query+=' LIMIT 200';
		}
		//else
		//{
			//query = ' LIMIT 1000';
		//}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		system.debug('events query: ' + query);

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Event> updateevents = new List<Event>();
		Date ndays = system.now().date().adddays(-90);

   		for(sobject s : scope)
   		{
   			Event ev = (Event)s;

   			if(ev.CreatedDate >= ndays)
   			{
   				ev.IsVisibleInSelfService = true;
   				updateevents.add(ev);
   			}
   			
   		}

   		//if(!updateevents.isEmpty()) update updateevents;

   		if(!updateevents.isEmpty())
   		{
   			Database.SaveResult[] results = Database.update(updateevents,false);
   		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}