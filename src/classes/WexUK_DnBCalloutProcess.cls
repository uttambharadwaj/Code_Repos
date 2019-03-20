global class WexUK_DnBCalloutProcess{



    public class DnBTransaction{
        public String name;
        public String Street_Address;
        public String City_Name;
        public String State_Name;
        public String zipCode;
        public String country;
    }
    
    //@Future (callout=true)
     public void preformDnB_WF(List<Account> accList, map<id,id> accutidAssmtidMap){
    
      String DnBHit = 'HIT';
     String DnBNoHit = 'NO-HIT';
     String DnBException = 'EXCEPTION';
     String bestMatchCompanyId = null;
     Boolean isDnBHit = false;
     String DnBScenarioForTest = null;
     Credit_Assessment__c creditAss = null;
     forseva1__DnBDecisionSupport__c DnB_Report = null;
     Map<id,Credit_Assessment__c> acctidAssmentMap= new  Map<id,Credit_Assessment__c>();
     Account_Status_History__c history = new Account_Status_History__c();
      list<Account_Status_History__c> historyList = new list<Account_Status_History__c>();
    
        
        String DnBCalloutResult = 'NO-HIT';
        DnBTransaction dnbTrans = new DnBTransaction();
        List<Account> accListToBeUpdated = new List<Account>();
        List<Credit_Assessment__c> creditAssListToBeUpdated = new List<Credit_Assessment__c>();
        
        system.debug('accutidAssmtidMap.values() '+ accutidAssmtidMap.values() );
        
         List<Credit_Assessment__c> credLatest = [Select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Validation__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
           from Credit_Assessment__c where id = :accutidAssmtidMap.values()];
         
         // [Select  max(lastmodifieddate) lstdate, account__c acct from Credit_Assessment__c where account__c = :accList group by account__c ];
         
         
         
          List<Credit_Assessment__c> credassmtLst = new List<Credit_Assessment__c> ();
          Map<id, Credit_Assessment__c> credAssmtMap = new  Map<id, Credit_Assessment__c> ();
          
         for(Credit_Assessment__c res : credLatest){
          // credassmtLst = [select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Validation__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
           //from Credit_Assessment__c where account__c = :(id)res.get('acct')  and lastmodifieddate = :(datetime) res.get('lstdate') limit 1 ];
           
            system.debug('acct ' + res.Account__c + ' assmt ' + res );
            
            acctidAssmentMap.put(res.Account__c, res);
         
         }
         
         
        
         //List<Credit_Assessment__c> credassmtLst = [select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Validation__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
          // from Credit_Assessment__c where account__c = :accList  and lastmodifieddate = :(datetime) credLatest[0].get('lstdate') ];
        
       //  for(Credit_Assessment__c assmt : credassmtLst){
     //     system.debug('acct ' + assmt.Account__c + ' assmt ' + assmt );
       //acctidAssmentMap.put(assmt.Account__c, assmt);             
      // }
        
           
           // List<Account> accList = [select id, name, BillingStreet, BillingCity,BillingState,BillingPostalCode from account where id =:Acctid];
        for(Account acc: accList){
            //creating credit assessment for account based on HLA/Pre-HLA/NIRD
            creditAss = acctidAssmentMap.get(acc.id);
            //insert creditAss;
            
            //############################### Start Pull and Save Report ################################################
            
          //  Account acc = [select id, name, BillingStreet, BillingCity,BillingState,BillingPostalCode from account where id =:Acctid limit 1  ];
        
            dnbTrans.name = acc.name;
            dnbTrans.Street_Address = acc.BillingStreet; 
            dnbTrans.City_Name = acc.BillingCity;
            dnbTrans.State_Name = acc.BillingState;
            dnbTrans.zipCode = acc.BillingPostalCode;
            dnbTrans.country = acc.billingCountry;
            
            forseva1.CompanyLookupResultGlobal bestMatch;
            if(!Test.isRunningTest()){
             bestMatch = getTheBestMatch(dnbTrans);//get best match for the Account
            }
            system.debug('bestMatch ' + bestMatch);
             if(bestMatch !=  null){
            DnBCalloutResult =  DnBHit;
        }
        else{
           DnBCalloutResult =  DnBNoHit;
        }
            system.debug('@@@@DnBCalloutResult'+DnBCalloutResult);
            if(DnBCalloutResult == DnBHit){
                if(!Test.isRunningTest()){
                    bestMatchCompanyId = bestMatch.getCompanyId();
                }
                else{
                    bestMatchCompanyId = '123456';
                }
                
                system.debug('@@@@bestMatchCompanyId'+bestMatchCompanyId);
                
                //if(acc.forseva1__Experian_File_Number__c == bestMatchCompanyId){
                    if(!Test.isRunningTest()){
                         system.debug('pulling DNb report ' + acc +  bestMatchCompanyId);
                        DnB_Report = getDnBReport(acc, bestMatchCompanyId);// Pull report
                    }
                    else{
                        forseva1__DnBDecisionSupport__c DnBObj = new forseva1__DnBDecisionSupport__c();
                        DnBObj.forseva1__Account__c = acc.id;
                        DnBObj.forseva1__FAIL_SCR__c = 0;
                        insert DnBObj;
                        
                        DnB_Report = DnBObj;
                    }
                    system.debug('@@@@DnB_Report'+DnB_Report);
                    
                    
               // } else {
                    
                //}
            } else if(DnBCalloutResult == DnBNoHit ){// BestMatch = null, DnB No hit scenario
                system.debug('@@@@@in to the Experian no hit @@@@@');
                isDnBHit = false;
                
                forseva1__DnBDecisionSupport__c DnBObj = new forseva1__DnBDecisionSupport__c();
                DnBObj.forseva1__Account__c = acc.id;
                DnBObj.forseva1__FAIL_SCR__c = 0;
                insert DnBObj;
                
                DnB_Report = DnBObj;
                System.debug('-------After Pull and Save Report---------');                
            }
            //############################### End Pull and Save Report ################################################
            
            System.debug('-------Before calling calculatePaymentHistoryDetails---------');
           // WexUK_Reassessment_Handler.calculatePaymentHistoryDetails(acc, creditAss);
           // System.debug('-------After calling calculatePaymentHistoryDetails---------');
           Account account = [Select id, name,  Payment_History_Status__c, Risk_Grade_Criteria__c
           from Account where id = :acc.id];
           
           acc.Payment_History_Status__c = account.Payment_History_Status__c;
           acc.Risk_Grade_Criteria__c = account.Risk_Grade_Criteria__c;
           
            WexUK_Reassessment_Handler.calculateCreditUtilization(acc, creditAss);
           
             history = new Account_Status_History__c();
           
            if(creditAss.Assessment_Status__c == 'Batch Assesment Passed'){
            WexUK_Reassessment_Handler.calculateResult(acc, creditAss, history);
            }
            
            acc.Assigned_to__c = null;
           // acc.Credit_Limit_Status__c = 'Pending';
            
            creditAssListToBeUpdated.add(creditAss);
           accListToBeUpdated.add(acc);
           historyList.add(history);
           
        }
        
        update creditAssListToBeUpdated;
        
        update accListToBeUpdated;
        
        insert historyList;
    }

     public forseva1.CompanyLookupResultGlobal getTheBestMatch(DnBTransaction dnbTransaction){ 
            
              forseva1.CommercialReportService crs = new forseva1.CommercialReportService('Dun & Bradstreet');
    
        forseva1.CompanyLookupResultGlobal bestMatch;
        try{         
            system.debug('dnbTransaction ' + dnbTransaction);
            
            forseva1__CreditPolicy__c cp = [select id, forseva1__First_Lookup_Confidence_Threshold__c from forseva1__CreditPolicy__c where name = 'Dun And Bradstreet'];
            system.debug('@@@@ START DnB LIST OF SIMILAR:::-'+datetime.now());
                       
            List<forseva1.CompanyLookupResultGlobal> dnbGlobalData =  crs.getListofSimilars(dnbTransaction.name, dnbTransaction.Street_Address, 
                dnbTransaction.City_Name, dnbTransaction.State_Name,dnbTransaction.zipCode, dnbTransaction.country, 'DnB Decision Support', cp.forseva1__First_Lookup_Confidence_Threshold__c, 'First Verification', cp.Id);
           bestMatch = getBestMatch(dnbGlobalData);
                
        } catch(Exception exp) {
            system.debug(exp.getMessage());
      }
  
        
        return bestMatch;
    }
    
     public forseva1.CompanyLookupResultGlobal getBestMatch(List<forseva1.CompanyLookupResultGlobal> los) {
        
       
        
       Wex_UK_Configurable__c configVals =  WexUK_Reassessment_Handler.getConfigurableValues();
       
        Integer threshold = (Integer)configVals.Confidence_Threshold_DNB__c;
        /*
        CenturyLink_Preference_Settings__c ps = CenturyLink_Preference_Settings__c.getOrgDefaults();
        if (ps == null) {
            throw new CenturyLinkErrorException('Century Link Preference Settings not found.  Unable to determine confidence threshold for selecting file from Experian LOS.');
        }
        else {
            threshold = (Integer) ps.Experian_Confidence_Threshold__c;
            system.debug('got the threshold as  ' + threshold);
        }
        */
        forseva1.CompanyLookupResultGlobal best = null;
        for (forseva1.CompanyLookupResultGlobal clrg : los) {
            System.debug('clrg' + clrg);
            System.debug('clrg.conf = ' + clrg.getConfidence() + ' clrg.threshold attained: ' + clrg.getThresholdAttained());
            if (clrg.getConfidence() > threshold) {
                if (best == null) {
                    best = clrg;
                }
                else if (clrg.getConfidence() > best.getConfidence()) {
                    best = clrg;
                }
            }
        }
        
        return best;
    }

    public forseva1__DnBDecisionSupport__c getDnBReport(Account acct, String bestmatchDnBNumber){
        
        system.debug('inside getDnBReport ');
        
 
            forseva1.CommercialReportService crs = new forseva1.CommercialReportService('Dun & Bradstreet');
    
            system.debug('inside getDnBReport ' +acct.id + bestmatchDnBNumber);
            
            forseva1__DnBDecisionSupport__c DnBReport = 
             (forseva1__DnBDecisionSupport__c)crs.getAndSaveReport('DnB Process', 'DnB Decision Support', acct.id, bestmatchDnBNumber);
             
            
            system.debug('@@@@GOT The Report '+ datetime.now());
             
        
            return DnBReport;
            
    }
    
        public void updateTrackList(DateTime nowtime , String activity){
            /*
            CDTTransLifeCycle__c lfc = new CDTTransLifeCycle__c();
            lfc.ActivityTime__c = nowtime;
            lfc.OrderOpptyTransId__c = transId;
            lfc.TransId__c = orderOpptyId;
            lfc.Activity__c = activity;
            trackList.add(lfc);
            */
        }

        
}