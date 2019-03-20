global class EMAP_LatePayer_Batch implements Database.Batchable<sObject> {
    
    String query = 'Select Id From Invoice__c Where Account__c <> null AND INVOICE_ISSUE_DATE__c = LAST_90_DAYS AND Late_And_AOT__c = \'Yes\' ';
    
    global EMAP_LatePayer_Batch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Invoice__c> invoices) {
        Map<Id, Invoice__c> invoiceMap = new Map<Id, Invoice__c>(invoices);
        Set<Id> invoiceIds = invoiceMap.keySet();
        System.debug('##### Invoice Ids #####:-'+invoiceIds);

        List<AggregateResult> aggregateResultsLateInvoices = [
            select 
                Account__c,
                sum(Is_Late_And_AOT__c) Total_Late_Payer 
            from 
                Invoice__c 
            where 
                Id in :invoiceIds
            group by 
                Account__c
        ];
        
        System.debug('#### Aggregate Results Late Invoices #####:-'+aggregateResultsLateInvoices);
        
        List<Account> accountList = new List<Account>();

        for(AggregateResult invoice : aggregateResultsLateInvoices) {
            ID accountId = (ID)invoice.get('Account__c');
            Decimal totalLatePaidInvoice = (Decimal)invoice.get('Total_Late_Payer');

            accountList.add(
                new Account(
                    ID = accountId, 
                    Number_of_Late_Payments_Last_3_Months__c = totalLatePaidInvoice,
                    Send_Late_Payer_and_Dishonour_to_IFCS__c = true
                )
            );
        }
        
        System.debug('#### Updated Account List #####:-'+accountList);        

        update accountList;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}