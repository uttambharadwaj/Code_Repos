global class GenericDeleteBatchSchedulable implements Schedulable 
{	
    global void execute(SchedulableContext SC) 
    {	
        GenericDeleteBatch batchApex = new GenericDeleteBatch('default');
      	ID batchprocessid = Database.executeBatch(batchApex); 
    }
}