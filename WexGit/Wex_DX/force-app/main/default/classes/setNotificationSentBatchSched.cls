global class setNotificationSentBatchSched implements Schedulable 
{
    global void execute(SchedulableContext SC) 
    {
       	ID batchprocessid = Database.executeBatch(new setNotificationSentBatch());
    }
}