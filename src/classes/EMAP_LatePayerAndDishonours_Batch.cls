global class EMAP_LatePayerAndDishonours_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    
    String query = 'Select Id From Invoice__c Where Account__c <> null AND INVOICE_ISSUE_DATE__c = LAST_90_DAYS ';
    
    global Decimal totalLatePaidInvoice;
    global Decimal totalDishHonours;
    global Set<id> accountSet;
    global Map<id,Decimal> accountLastPayment;
    global Map<id,Decimal> accountDishonours;
 
    
    global EMAP_LatePayerAndDishonours_Batch() {
       totalLatePaidInvoice=0;
       totalDishHonours=0;
       accountSet= new Set<id>();
       accountLastPayment=new Map<id,Decimal>();
       accountDishonours=new Map<id,Decimal>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Invoice__c> invoices) {
        Map<Id, Invoice__c> invoiceMap = new Map<Id, Invoice__c>(invoices);
        Set<Id> invoiceIds = invoiceMap.keySet();
        System.debug(LoggingLevel.DEBUG,'##### Invoice Ids #####:-'+invoiceIds);
        
        List<AggregateResult> aggregateResultsInvoices = [
            select 
                Account__c
                ,sum(Total_Dishonours_Number__c) Total_Account_Dishonours
                ,sum(Is_Late_And_AOT__c) Total_Late_Payer 
            from 
                Invoice__c 
            where 
                Id in :invoiceIds
            group by 
                Account__c
        ];
        
        System.debug(LoggingLevel.DEBUG,'#### Aggregate Results Invoices #####:-'+aggregateResultsInvoices);
        
        List<Account> accountList = new List<Account>();

        for(AggregateResult invoice : aggregateResultsInvoices) {
            ID accountId = (ID)invoice.get('Account__c');
            System.debug(LoggingLevel.DEBUG,'#### accountId  #####:-'+accountId ); 
            System.debug(LoggingLevel.DEBUG,'#### accountSet.contains(accountId)  #####:-'+accountSet.contains(accountId) ); 
            if(accountSet.contains(accountId)){
                System.debug(LoggingLevel.DEBUG,'### in if #####:-'); 
                System.debug(LoggingLevel.DEBUG,'#### in if accountLastPayment.get(accountId)#####:-'+accountLastPayment.get(accountId));
                Decimal totalLatePaidInvoice1= accountLastPayment.get(accountId)+(Decimal)invoice.get('Total_Late_Payer');
                Decimal totalDishHonours1= accountDishonours.get(accountId)+(Decimal)invoice.get('Total_Account_Dishonours');
                
                System.debug(LoggingLevel.DEBUG,'#### in if totalLatePaidInvoice1 #####:-'+totalLatePaidInvoice1); 
                accountLastPayment.put(accountId,totalLatePaidInvoice1);
                accountDishonours.put(accountId,totalDishHonours1);
                
                System.debug(LoggingLevel.DEBUG,'#### in if accountLastPayment#####:-'+accountLastPayment); 
                
            } else {
                
                totalLatePaidInvoice = (Decimal)invoice.get('Total_Late_Payer');
                totalDishHonours= (Decimal)invoice.get('Total_Account_Dishonours');
                System.debug(LoggingLevel.DEBUG,'#### in else totalLatePaidInvoice #####:-'+totalLatePaidInvoice );
                accountLastPayment.put(accountId,totalLatePaidInvoice);
                accountDishonours.put(accountId,totalDishHonours);
                System.debug(LoggingLevel.DEBUG,'#### in else accountLastPayment#####:-'+accountLastPayment);
                accountSet.add(accountId);
                System.debug(LoggingLevel.DEBUG,'#### in else accountSet after add#####:-'+accountSet);

                }
            
            accountList.add(
                new Account(
                    ID = accountId,                    
                    Number_of_Late_Payments_Last_3_Months__c = accountLastPayment.get(accountId),
                    Number_of_Dishonours_in_Last_3_Months__c = accountDishonours.get(accountId)));
        }
        
        System.debug(LoggingLevel.DEBUG,'#### Updated Account List #####:-'+accountList);        

        update accountList;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}