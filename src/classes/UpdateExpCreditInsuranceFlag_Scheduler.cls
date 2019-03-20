global class UpdateExpCreditInsuranceFlag_Scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateExpiredCreditInsuranceFlag_Batch b = new UpdateExpiredCreditInsuranceFlag_Batch(); 
      database.executebatch(b);
   }
}