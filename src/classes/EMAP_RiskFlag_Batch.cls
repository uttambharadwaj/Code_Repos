global class EMAP_RiskFlag_Batch implements Database.Batchable<SObject> {

    global final string query;
    global final string riskFlagValue;
        
    global EMAP_RiskFlag_Batch (String q, String rfv) {
        query = q + ' AND RecordType.name = \'EMAP Fuel Accounts\' ';
        riskFlagValue = rfv;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Risk_Flag__c> riskFlagsToInsert = EMAP_RiskFlag_Handler.buildRiskFlagsToInsert(accounts, riskFlagValue);
        insert riskFlagsToInsert;
    }
    
    global void finish(Database.BatchableContext bc) {
        //
    }
/*
    global void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Risk_Flag__c> riskFlagsToInsert = new List<Risk_Flag__c>();
        
        for(Account acct : accounts) {
            if(isAccountWithRiskFlag(acct) == false) {
                riskFlagsToInsert.add(new Risk_Flag__c(Risk_Flag_Value__c = riskFlagValue, Account__c = acct.Id, Status__c = 'open'));
            }
        }
        
        insert riskFlagsToInsert;
    }

    private static Boolean isAccountWithRiskFlag(Account acct) {
        return ((acct == null || acct.Risk_Flags__r == null) ? false : (acct.Risk_Flags__r.size() > 0));
    }
*/
}