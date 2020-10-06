global class EMAP_CreditDecision_Batch implements Database.Batchable<sObject>{
    
    String queryStr = '';
    
    global EMAP_CreditDecision_Batch(String query){
        queryStr = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryStr);
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts) {
    
        List<Account> acctsToBeSentToIFCS = new List<Account>();
        
        for(Account acct : accounts) {
            if(acct.Client_Name__c == 'ExxonMobil Hong Kong'){
                // setting this to true to trigger the outbound message via workflow rule (EMAP Send HK Account to IFCS - Day 0)
                acct.Send_HK_Account_to_IFCS__c = true;
                
                acctsToBeSentToIFCS.add(acct);
            } else {
                // setting this to true to trigger the outbound message via workflow rule (INTEGRATION - Send Credit to IFCS)
                acct.Send_Credit_to_IFCS__c = true; 

                acctsToBeSentToIFCS.add(acct);
            }
        }

        update acctsToBeSentToIFCS;
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }

}