trigger CreditUtilizationHistory on Credit_Utilization_History__c (after insert, after update) {
    
    /*
    List<Credit_Utilization_History__c> credUtilList = [select Account__r.id, account__c from Credit_Utilization_History__c where id in :Trigger.new];
    system.debug('credUtilList ' + credUtilList);
    
    
        
    list<Account> AccountTBU = new List<Account>();
    
    
    for(Credit_Utilization_History__c util : credUtilList){
    
    system.debug('util.Account__r.id ' + util.Account__r.id);
    system.debug('util.Account__r.id ' + util.account__c);
    if(util.Account__r.id != null){
    Account acct  = [Select a.id, a.name , a.Credit_Utilization__c from account a where a.id=:util.Account__r.id];
    
    List<AggregateResult> credLatest = [select  max(lastmodifieddate) lstdate from Credit_Utilization_History__c where account__c =:util.Account__c group by account__c ];
     system.debug('credLatest ' + credLatest);
     system.debug('util.Account__c '+ util.Account__c + ' (datetime) credLatest[0].get(\'lstdate\')  '  + (datetime) credLatest[0].get('lstdate') );

   Credit_Utilization_History__c hist = [select Credit_Utilization__c from Credit_Utilization_History__c where account__c =:util.Account__c and lastmodifieddate = :(datetime) credLatest[0].get('lstdate')  ];

    system.debug('hist ' + hist);
    acct.Credit_Utilization__c = hist.Credit_Utilization__c ;
    AccountTBU.add(acct);   
    
    }
    
    }
    
    //Database.update(AccountTBU, false);
    
    update AccountTBU; */

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CreditUtilizationHistory_trigger_handler.updateCreditUtilizationOnUltParentAccount(Trigger.new);
        }
    }

    
    
}