public with sharing class EMAP_Accounts_Receivable_TriggerHandler {
    

    /* used to check Is invoive Late and AOT?
    *  Parameters: List of new Accounts_Receivable records
    */
    @future
    public static void isInvoiceLateAndAOT(List<ID> accIdList){
        
		/* <<<<<<<<<<< Commented....IDs passed from trigger >>>>>>>>>>>>>
        List<Id> accIdList = new List<Id>();
        
        //get list of Account Ids
        for(Accounts_Receivable__c ARNew: ARNewList){
            accIdList.add(ARnew.Account__c);
        }
		<<<<<<<<<< Commented....IDs passed from trigger >>>>>>>>>>>>>   */ 
        
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, Total_Overdue__c, Program__r.AOT_Amount__c  From Account Where Id In: accIdList]);
        
        //get list of Invoices under each Accounts to check Late and AOT
        List<Invoice__c> invoiceList = 
            [Select id, Account__c, Invoice_Paid_in_Full_On__c, Is_Late_Payer__c, Late_And_AOT__c 
            From Invoice__c Where Account__c IN: accIdList];

        List<Invoice__c> invoiceToBeUpdated = new List<Invoice__c>();               
        for(Invoice__c invoice: invoiceList){
            Account acc = accMap.get(invoice.Account__c);
            
            if(invoice.Late_And_AOT__c == null){
                invoice.Late_And_AOT__c = 'No';
            }
            
            //check invoive Late & AOT
            if( (invoice.Late_And_AOT__c == 'No') && 
                (invoice.Is_Late_Payer__c && acc.Total_Overdue__c > acc.Program__r.AOT_Amount__c) ) {
                    invoice.Late_And_AOT__c = 'Yes';
                    
                     invoiceToBeUpdated.add(invoice);
            }
            
        }
        
        update invoiceToBeUpdated;
    }

    /* used to update Group balance on Parent Account based on Current balance on child accounts
    *  Parameters: List of new Accounts Receivable records
    */
    public static void UpdateParentGroupBal(List<Accounts_Receivable__c> ARNewList){
        system.debug('in UpdateParentGroupBal@@@@@@@@@@@@@@@@@');
        
        //List of account Ids
        List<Id> accIds = new List<id>();
        
        for(Accounts_Receivable__c ARNew: ARNewList){
            accIds.add(ARNew.Account__c);
        }

        //prepare list of Accounts on Accounts Receivable 
        List<Account> accList = [Select Id, Name, recordTypeId, parentId, Hierarchy_Level__c From Account Where Id In: accIds];
        system.debug('in accList @@@@@@@@@@@@@@@@@'+accList );
        //Limit the size of list by using Sets which do not contain duplicate elements
        Set<String> parentAccIds = new Set<String>();

        //When adding new child accounts or updating child accounts     
        for(Account acc: accList){
            //only 'EMAP Fuel Accounts' records and Hierarchy Level 03
            if(acc.recordTypeId == EMAP_Account_TriggerHandler.accountRecType.getRecordTypeId() && 
                acc.parentId != null && 
                acc.Hierarchy_Level__c == '03'){
                    parentAccIds.add(acc.parentId);
            }
        }
        system.debug('in parentAccIds @@@@@@@@@@@@@@@@@'+parentAccIds );
        if(parentAccIds != null && parentAccIds.size() > 0){

            //Map will contain one acc parent Id to one sum current_balance value
            Map<String, Decimal> accMap = new Map<String, Decimal>();
        
            //Produce a sum of AR_Current_Balance__c and add them to the map
            //use group by to have a single parent Id with a single sum value
            for(AggregateResult aggRes : 
                [Select parentId, sum(AR_Current_Balance__c) 
                 From Account 
                 Where parentId IN :parentAccIds 
                        AND Hierarchy_Level__c = '03'  
                        group by parentId]){
                accMap.put((Id) aggRes.get('parentId'), (Decimal) aggRes.get('expr0'));
            }
        
            List<Account> accToBeUpdated = new List<Account>();
            
            //Run the for loop on Account using the non-duplicate set of Parent Account Ids
            //Get the sum value from the map and create a list of Accounts to update       
            for(Account acc: [Select Id, Group_Balance__c From Account Where Id IN :parentAccIds]){
                Decimal grp_bal = accMap.get(acc.Id);
                if(grp_bal !=acc.Group_Balance__c){
                acc.Group_Balance__c = grp_bal;
                accToBeUpdated.add(acc);
                }
            }
           
            EMAP_Account_TriggerHandler.isUpdateParentGroupBal= true;
            update accToBeUpdated; 
            system.debug('in accToBeUpdatedEMAP_Account_TriggerHandler.isUpdateParentGroupBal@@@@@@@@@@@@@@@@'+EMAP_Account_TriggerHandler.isUpdateParentGroupBal);
         
        }
    }

    /* Used to set current Accounts Receivable on related Account 
    *  Parameters: List of new Accounts Receivable records
    */
/*    public static void setCurrentARonAccount(List<Accounts_Receivable__c> ARNewList){
        //list of Accounts Ids
        List<Id> accIds = new List<Id>();
        
        //map of Account Id and Accounts Receivable
        Map<Id, Accounts_Receivable__c> ARMap = new Map<Id, Accounts_Receivable__c>();
        
        for(Accounts_Receivable__c ARNew: ARNewList){
            accIds.add(ARNew.Account__c);
        }
        
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Accounts_Receivable__c From Account Where Id IN: accIds AND RecordType.Name = 'EMAP Fuel Accounts' FOR UPDATE]);
        
        //list of Accounts to be updated with new AR
        List<Account> accListToBeUpdated = new List<Account>();
        
        for(Accounts_Receivable__c ARNew: ARNewList){
            Account acc = accMap.get(ARNew.Account__c);
            
            acc.Accounts_Receivable__c = ARNew.id;
            
            accListToBeUpdated.add(acc);
        }
        
        update accListToBeUpdated;
    }
*/
}