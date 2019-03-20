global class EMAP_AutoAccountSusReact_SG_BatchJob implements Schedulable {

    global void execute(SchedulableContext SC) {

        //Queries are streamlined as per business requirement

        Database.executeBatch(new EMAP_AccountAutoSusReact_Batch (EMAP_AccountAutoSusReact_Handler.QUERY_SG_OVERDUE_SUSPENSION, EMAP_AccountAutoSusReact_Batch.TYPE_SUSPEND));
        
        Database.executeBatch(new EMAP_AccountAutoSusReact_Batch (EMAP_AccountAutoSusReact_Handler.QUERY_SG_REACTIVATION, EMAP_AccountAutoSusReact_Batch.TYPE_REACTIVATE));
    }

}