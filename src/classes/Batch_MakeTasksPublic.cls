global class Batch_MakeTasksPublic implements Database.Batchable<sObject> {
	
	String query;
	Date ninetydays = system.now().date().adddays(-90);
	
	
	global Batch_MakeTasksPublic() 
	{
		system.debug('ninetydays: ' + ninetydays);

		query = 'Select Id, IsVisibleInSelfService, CreatedDate from Task Where CreatedDate >= :ninetydays AND IsVisibleInSelfService = false';
		if(Test.isRunningTest())
		{
			query+=' LIMIT 200';
		}
		//else
		//{
			//query+=' LIMIT 500';
		//}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		system.debug('--task query: ' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		List<Task> updateTasks = new List<Task>();
   		Date ndays = system.now().date().adddays(-90);

   		for(sobject s : scope)
   		{
   			Task t = (Task)s;
   			if(t.CreatedDate >= ndays)
   			{
   				t.IsVisibleInSelfService = true;
   				updateTasks.add(t);
   			}
   			
   		}

   		//if(!updateTasks.isEmpty()) update updateTasks;

   		if(!updateTasks.isEmpty())
   		{
   			Database.SaveResult[] results = Database.update(updateTasks,false);
   		}
	
	}
	
	global void finish(Database.BatchableContext BC) 
	{
		
	}
	
}