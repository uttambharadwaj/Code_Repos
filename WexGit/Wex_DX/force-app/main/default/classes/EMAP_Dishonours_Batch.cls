global class EMAP_Dishonours_Batch implements Database.Batchable<sObject> {
    
    String query = 'Select Id From Invoice__c Where Account__c <> null AND INVOICE_ISSUE_DATE__c = LAST_90_DAYS AND Total_Dishonours_Number__c > 0 ';
    
    global EMAP_Dishonours_Batch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Invoice__c> invoices) {
        Map<Id, Invoice__c> invoiceMap = new Map<Id, Invoice__c>(invoices);
        Set<Id> invoiceIds = invoiceMap.keySet();
        System.debug('##### Invoice Ids #####:-'+invoiceIds);

        List<AggregateResult> aggregateResultsDishonoursInvoices = [
            select 
                Account__c,
                sum(Total_Dishonours_Number__c) Total_Account_Dishonours
            from 
                Invoice__c 
            where 
                Id in :invoiceIds
            group by 
                Account__c
        ];
        
        System.debug('#### Aggregate Results Invoices #####:-'+aggregateResultsDishonoursInvoices);
        
        List<Account> accountList = new List<Account>();

        for(AggregateResult invoice : aggregateResultsDishonoursInvoices) {
            ID accountId = (ID)invoice.get('Account__c');
            Decimal totalAccountDishonours = (Decimal)invoice.get('Total_Account_Dishonours');

            accountList.add(
                new Account(
                    ID = accountId, 
                    Number_of_Dishonours_in_Last_3_Months__c = totalAccountDishonours
                )
            );
        }
        
        System.debug('#### Updated Account List #####:-'+accountList);        

        update accountList;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}