global class EMAP_LatePayerAndDishonours_BatchJob implements Schedulable {

    global void execute(SchedulableContext SC) {
        // Calculate total number of late payments before Risk Flags
        //Database.executeBatch(new EMAP_LatePayer_Batch()); //This batch job scheduled in EMAP_RiskFlag_BatchJob

        // Calculate total number of dishonors before Risk Flags
        Database.executeBatch(new EMAP_Dishonours_Batch());       
    }

}