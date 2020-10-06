global class EMAP_RiskFlag_BatchJob implements Schedulable {

    global void execute(SchedulableContext SC) {
        // Calculate total number of Late Payments and Dishonors in last 90 days before Risk Flags
        Database.executeBatch(new EMAP_LatePayerAndDishonours_Batch()); 
        
        // Date Type Risk Flags
        Database.executeBatch(new EMAP_RiskFlag_Batch (EMAP_RiskFlag_Handler.QUERY_SECE, EMAP_RiskFlag_Handler.RISK_FLAG_SECE));
        Database.executeBatch(new EMAP_RiskFlag_Batch (EMAP_RiskFlag_Handler.QUERY_CRVW, EMAP_RiskFlag_Handler.RISK_FLAG_CRVW));
        Database.executeBatch(new EMAP_RiskFlag_Batch (EMAP_RiskFlag_Handler.QUERY_BEXP, EMAP_RiskFlag_Handler.RISK_FLAG_BEXP));
        Database.executeBatch(new EMAP_RiskFlag_Batch (EMAP_RiskFlag_Handler.QUERY_OVERRIDE, EMAP_RiskFlag_Handler.RISK_FLAG_OVERRIDE));
    }

}