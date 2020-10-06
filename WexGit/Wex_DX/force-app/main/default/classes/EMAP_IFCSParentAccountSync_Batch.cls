global class EMAP_IFCSParentAccountSync_Batch implements Database.Batchable<SObject> {

    String query = 'Select id, Parent_Account_IFCS_Id_integration__c ' +
                    'From account ' +
                    'Where RecordType.Name = \'EMAP Fuel Accounts\' ' +
                    'AND Parent_Account_IFCS_Id_integration__c  != null ' +
                    'AND Program__c != null ' +
                    'AND Parent_Account_IFCS_Id__c = null ' +
                    'AND Client_Name__c = \'ExxonMobil Hong Kong\' ';
        
    global EMAP_IFCSParentAccountSync_Batch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> accountList) {
        
        Map<String, String> AcctMap = new Map<String, String>();
        
        List<Account> accList = [select ifcs__c, id 
                                 From account 
                                 Where Program__c != null 
                                 and RecordType.Name = 'EMAP Fuel Accounts' 
                                 and ifcs__c != null 
                                 and Client_Name__c = 'ExxonMobil Hong Kong' ];
        
        for(Account acct1 : accList){
             AcctMap.put(acct1.ifcs__c, acct1.id);
        }

        List<Account> AcctsResults = new List<Account>();
        
        for (Account acct: accountList){

            acct.ParentId = Acctmap.get(acct.Parent_Account_IFCS_Id_integration__c);

            AcctsResults.add(acct);
            
        }
        
        update AcctsResults;
    }
    
    global void finish(Database.BatchableContext bc) {
    }
}