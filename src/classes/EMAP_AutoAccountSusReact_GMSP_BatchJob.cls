global class EMAP_AutoAccountSusReact_GMSP_BatchJob implements Schedulable {

    global void execute(SchedulableContext SC) {

        //Queries are streamlined as per business requirement

        Database.executeBatch(new EMAP_AccountAutoSusReact_Batch (EMAP_AccountAutoSusReact_Handler.QUERY_GMSP_OVERDUE_SUSPENSION, EMAP_AccountAutoSusReact_Batch.TYPE_SUSPEND));
        
        Database.executeBatch(new EMAP_AccountAutoSusReact_Batch (EMAP_AccountAutoSusReact_Handler.QUERY_GMSP_REACTIVATION, EMAP_AccountAutoSusReact_Batch.TYPE_REACTIVATE));
    }

}