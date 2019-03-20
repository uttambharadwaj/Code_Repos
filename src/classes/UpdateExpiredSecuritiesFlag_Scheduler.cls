global class UpdateExpiredSecuritiesFlag_Scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateExpiredSecuritiesFlag_Batch b = new UpdateExpiredSecuritiesFlag_Batch(); 
      database.executebatch(b);
   }
}