global class EMAP_RiskFlag_Webservice {

    webservice String parameter { get; set; }

    public EMAP_RiskFlag_Webservice() {
        this.parameter = 'value';
    }

    
    webservice static String startHKCreditDecisionBatchJob() {
        try {
            String query = 'Select id, Name, Client_Name__c, Send_Credit_to_IFCS__c, Send_HK_Account_to_IFCS__c From Account Where RecordType.name = \'EMAP Fuel Accounts\' AND IFCS__c != null AND Client_Name__c = \'ExxonMobil Hong Kong\' ';
            
            EMAP_CreditDecision_Batch creditDecision_Batch = new EMAP_CreditDecision_Batch(query);

            Database.executeBatch(creditDecision_Batch);

        }
        catch(Exception e) {
            return e.getMessage();
        }

        return 'success';
    }
    
    webservice static String startIFCSParentAccountSyncJob() {
        try {

            EMAP_IFCSParentAccountSync_Batch IFCSParentAccountSync_Batch = new EMAP_IFCSParentAccountSync_Batch();
            
            Database.executeBatch(IFCSParentAccountSync_Batch);

        }
        catch(Exception e) {
            return e.getMessage();
        }

        return 'success';
    }
}