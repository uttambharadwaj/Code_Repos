global class WexUK_CreditReassessment_BatchClass implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts{

      global  List<Account> validAccountList = new List<Account>();
  
    global Wex_UK_Configurable__c configVals =  null;
    
     
    global WexUK_CreditReassessment_BatchClass(){
     
     
        configVals = WexUK_Reassessment_Handler.getConfigurableValues();
      
        
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
         Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();
         
        String query = 'Select Id, name, Credit_Utilization__c, nird__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, billingcountry  from Account Where recordtypeid = :rtId AND (Nird__c <= NEXT_N_DAYS:' ///sriram
    + (Integer)configVals.Nird_Review__c+' OR Credit_Utilization__c >= '+ (Integer)configVals.Credit_Util_threshold__c+') and Auth_Node_Indicator__c = \'Y\' and Credit_Limit_Status__c in (\'Approved\', \'Auto approved\', \'Continue without change\', \'Declined\', null)  ';
  return Database.getQueryLocator(Query);
  
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
        
          List<Webservice_Seession__c> sessionList = new List<Webservice_Seession__c>();
    
        List<Account> validAccountList = new List<Account>();
        //created the credit assessment object for each of the account
        List<Credit_Assessment__c> credassmtLst =  WexUK_Reassessment_Handler.createCreditAsmt(accList);
        Map<id,Credit_Assessment__c> acctidAssmentMap= new  Map<id,Credit_Assessment__c>();
       
       for(Credit_Assessment__c assmt : credassmtLst){
        system.debug('acct ' + assmt.Account__c + ' assmt ' + assmt );
       acctidAssmentMap.put(assmt.Account__c, assmt);               
       }
       //Initail validation
       validAccountList = WexUK_Reassessment_Handler.ValidateAccounts(accList, acctidAssmentMap);
       
      
        //validAccountList = validateAccounts(accList);7
      // WexUK_DnBCalloutProcess dnbCalloutProc = new WexUK_DnBCalloutProcess();
       
       
       //Auto limit validation and DNB report pull
      //dnbCalloutProc.preformDnB_WF(validAccountList);
        //dnbCalloutProc.preformDnB_WF(accList);
        
       Webservice_Seession__c session;
       // List<Webservice_Seession__c> sessionList = new List<Webservice_Seession__c>();
       
       list<Account> acctToBeUpdated = new list<Account>();
        
        for(Account acc : validAccountList){            
            WexUK_Reassessment_Handler.calculateAutolimitIncrease(acc);
            
            session = new Webservice_Seession__c();
            session.Account__c = acc.id;
            session.Object_Id__c = acc.id;
            session.Status__c = 'Staged'; 
            session.CredAssmtId__c = (String) acctidAssmentMap.get(acc.id).id;
            sessionList.add(session);
            
            acctToBeUpdated.add(acc);
            
        }
        
        insert sessionList;
        update acctToBeUpdated;
        
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
        //system.debug('inside finish ' +sessionList );

     // insert sessionList; 
     
     WexUK_CalloutProcessorBatch batch = new WexUK_CalloutProcessorBatch();
     Database.executeBatch(batch,1);
        
    }
}