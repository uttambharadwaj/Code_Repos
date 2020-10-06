global class AssignAccountsSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
      Database.executeBatch(new AssignAccountsBatchable());
    }
}