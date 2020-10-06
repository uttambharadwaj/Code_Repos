global class AssignAccountsBatchable implements Database.Batchable<sObject>{
    global Id integrationRecordToProcess;
    
    global AssignAccountsBatchable(Id integrationRecordId){
        this.integrationRecordToProcess = integrationRecordId;
    }
    
    global AssignAccountsBatchable(){
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Acct_Row_Id__c, Contact__c, Contact__r.Acct_Row_Id__c, Contact__r.AccountId FROM IntegrationRecord__c WHERE Account__c = null';
        if(integrationRecordToProcess != null){
            query += ' AND Id = \'' + integrationRecordToProcess + '\'';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<IntegrationRecord__c> scope){
        List<IntegrationRecord__c> integrationToUpdateList = new List<IntegrationRecord__c>();
        List<Contact> contactToUpdateList = new List<Contact>();
        Set<String> accountRowIds = new Set<String>();
        for(IntegrationRecord__c integ : scope){ 
            accountRowIds.add(integ.Acct_Row_Id__c);
        }
        
        System.debug('@@@accountRowIds: ' + accountRowIds);
        if(!accountRowIds.isEmpty()){
            List<Account> serviceOperationAccountsList = [SELECT Id, Acct_Row_Id__c FROM Account WHERE Acct_Row_Id__c IN: accountRowIds AND RecordType.Name =: Label.AccServiceOpRecordType];
            
            System.debug('@@@serviceOperationAccountsList: ' + serviceOperationAccountsList);
            System.debug('@@@serviceOperationAccountsList size: ' + serviceOperationAccountsList.size());
            if(!serviceOperationAccountsList.isEmpty()){
                Map<String, Id> accountRowIdToAccountIdMap = new Map<String, Id>();
                for(Account serviceOpAccountItem : serviceOperationAccountsList){
                    accountRowIdToAccountIdMap.put(serviceOpAccountItem.Acct_Row_Id__c, serviceOpAccountItem.Id);
                }
                
                for(IntegrationRecord__c integ : scope){
                    if(accountRowIdToAccountIdMap.get(integ.Acct_Row_Id__c) != null){
                        IntegrationRecord__c updIntegrationRecord = new IntegrationRecord__c();
                        updIntegrationRecord.Id = integ.Id;
                        updIntegrationRecord.Account__c = accountRowIdToAccountIdMap.get(integ.Acct_Row_Id__c);
                        integrationToUpdateList.add(updIntegrationRecord);
                        
                        if(integ.Contact__r.AccountId == null){
                            if(integ.Contact__r.Acct_Row_Id__c == integ.Acct_Row_Id__c){
                                Contact updContact = new Contact();
                                updContact.Id = integ.Contact__c;
                                updContact.AccountId = accountRowIdToAccountIdMap.get(integ.Acct_Row_Id__c);
                                contactToUpdateList.add(updContact);
                            }
                        }
                    }
                }
                
                Savepoint sp = Database.setSavepoint();
                try{
                    System.debug('@@@integrationToUpdateList: ' + integrationToUpdateList);
                    if(!integrationToUpdateList.isEmpty()){
                        update integrationToUpdateList;
                    }
                    
                    System.debug('@@@contactToUpdateList: ' + contactToUpdateList);
                    if(!contactToUpdateList.isEmpty()){
                        update contactToUpdateList;
                    }
                }catch(Exception ex){
                    System.debug('@@@Batch failed');
                    Database.rollback(sp);
                }
            }
        }
    }     
    
    global void finish(Database.BatchableContext info){     
    
    } 
}