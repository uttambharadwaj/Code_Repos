global class EMAP_AccountAutoSusReact_Batch implements Database.Batchable<sObject> {
    global final static String TYPE_SUSPEND = 'suspend';
    global final static String TYPE_REACTIVATE = 'reactivate';
    global final string query;
    global final string type;
    
    global EMAP_AccountAutoSusReact_Batch (String q, String t) {
        query = q;
        type = t;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts) {

        if(type == TYPE_SUSPEND) {
            for(Account acct : accounts) {
                acct.Status__c = '3 - Stopped (blocked)';
                acct.Account_Sub_Status__c = 'R - Delinquent (man.)';
                acct.Send_Credit_to_IFCS__c = true; // setting this to true triggers the outbound message via workflow rule (INTEGRATION - Send Credit to IFCS)
            }
        }

        if(type == TYPE_REACTIVATE) {
            for(Account acct : accounts) {
                acct.Status__c = '1 - Active';
                acct.Account_Sub_Status__c = 'Active';
                acct.Send_Credit_to_IFCS__c = true; // setting this to true triggers the outbound message via workflow rule (INTEGRATION - Send Credit to IFCS)
            }
        }
        
        update accounts;

    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}