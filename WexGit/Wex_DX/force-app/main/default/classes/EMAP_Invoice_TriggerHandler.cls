public with sharing class EMAP_Invoice_TriggerHandler {
	
	/* used to check Is invoive Late and AOT?
    *  Parameters: List of new Invoice records
    */
    public static void isLateAndAOT(List<Invoice__c> invoiceNewList){
        
        List<Id> accIdList = new List<Id>();
        
        //get list of Account Ids
        for(Invoice__c invoiceNew: invoiceNewList){
            accIdList.add(invoiceNew.Account__c);
        }
    
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, Total_Overdue__c, Program__r.AOT_Amount__c  From Account Where Id In: accIdList]);
        
        for(Invoice__c invoice: invoiceNewList){
            Account acc = accMap.get(invoice.Account__c);
            
            if(invoice.Late_And_AOT__c == null){
            	invoice.Late_And_AOT__c = 'No';
            }
            
            //check Is invoice Late and AOT? 
            if( (invoice.Late_And_AOT__c == 'No') && 
                (invoice.Is_Late_Payer__c && acc.Total_Overdue__c > acc.Program__r.AOT_Amount__c) ) {
                    invoice.Late_And_AOT__c = 'Yes';
            }
        }
    }

}