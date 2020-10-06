global class WexUK_CalloutProcessorBatch implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts {
  
   String query ='select id, Account__c, Account__r.id, Object_Id__c, Status__c, CredAssmtId__c from Webservice_Seession__c where Status__c=\'Staged\' ';
   global Database.QueryLocator start(Database.BatchableContext BC){
                
        return Database.getQueryLocator(Query);
    }
    
    
      global void execute(Database.BatchableContext BC, List<Webservice_Seession__c> sessionlist) {
        
        WexUK_DnBCalloutProcess dnbCalloutProc = new WexUK_DnBCalloutProcess();
        
        WexUK_EquifaxCalloutProcess EfxCalloutProc = new WexUK_EquifaxCalloutProcess();
        
        List<Account> accidList = new List<Account>();
        map<id,id> accutidAssmtidMap = new Map<id,id>();
        
        for(Webservice_Seession__c session : sessionlist){
          
          accidList.add(session.Account__r);
          accutidAssmtidMap.put(session.Account__r.id,session.CredAssmtId__c);
        }
        
        List<Account> accList = [select id, name, BillingStreet, BillingCity,BillingState,BillingPostalCode, billingcountry, Credit_Limit_Approved_Equifax__c, Payment_History_Status__c, Credit_authorised_limit__c,  Risk_Grade_Criteria__c, accountnumber , account_id__c  from account where id =:accidList];
        
        
        
        List<Account> EfxAcctlist = new List<Account>();
        List<Account> DnbAcctList = new List<Account>();
        
         for(Account acct : accList){
           if(acct.billingcountry == 'GB'){
           system.debug('acct; for EFX' + acct);  
           EfxAcctlist.add(acct);
           }else {
           DnbAcctList.add(acct);  
           }
           
         }
         
         if(DnbAcctList != null && !DnbAcctList.isEmpty()){
         dnbCalloutProc.preformDnB_WF(DnbAcctList, accutidAssmtidMap);
         
         }
         
         if(EfxAcctlist != null && !EfxAcctlist.isEmpty()){
           EfxCalloutProc.preformEfx_WF(EfxAcctlist,accutidAssmtidMap);
         }
         
         
         updateStagedAccounts(sessionlist);  
         
         sendItToIFCS(accList);     
        
      }
    
      global void finish(Database.BatchableContext BC) {
        
      }
      
      
      private void updateStagedAccounts(List<Webservice_Seession__c> sessionlist){
        
        List<Webservice_Seession__c> sessionupdlist = new List<Webservice_Seession__c> ();
        
        for(Webservice_Seession__c session : sessionlist){
          
          session.Status__c = 'Completed';
          sessionupdlist.add(session);
          
        }
        
        database.update(sessionlist);
        
        
        
      }
      
      private void sendItToIFCS(List<Account> accList ){
        list<Account> accountList = new list<Account> ();
        
        for(Account account : accList){
          
          account.Send_WES_to_IFCS__c  = true;
          accountList.add(account);
          
          
        }
        
        database.update(accountList);
      }
}