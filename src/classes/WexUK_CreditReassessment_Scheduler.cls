global class WexUK_CreditReassessment_Scheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
      WexUK_CreditReassessment_BatchClass b = new WexUK_CreditReassessment_BatchClass();
      database.executebatch(b,1);
   }
}