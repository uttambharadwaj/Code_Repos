global class WexUK_EquifaxCalloutProcess {
    
    public class EquifaxTransaction{
        public String name;
        public String Street_Address;
        public String City_Name;
        public String State_Name;
        public String zipCode;
        public String country;
    }
    
      public void preformEfx_WF(List<Account> accList, map<id,id> accutidAssmtidMap){
        
      String EfxHit = 'HIT';
     String EfxNoHit = 'NO-HIT';
     String DnBException = 'EXCEPTION';
     String bestMatchCompanyId = null;
     Boolean isEfxHit = false;
     String DnBScenarioForTest = null;
     Credit_Assessment__c creditAss = null;
     forseva1__EquifaxInternationalCommercialReport__c EFX_Report = null;
     Map<id,Credit_Assessment__c> acctidAssmentMap= new  Map<id,Credit_Assessment__c>();
     Account_Status_History__c history = new Account_Status_History__c();
      list<Account_Status_History__c> historyList = new list<Account_Status_History__c>();
    
        
        String EfxCalloutResult = 'NO-HIT';
        EquifaxTransaction EfxTrans = new EquifaxTransaction();
        List<Account> accListToBeUpdated = new List<Account>();
        List<Credit_Assessment__c> creditAssListToBeUpdated = new List<Credit_Assessment__c>();
        
        system.debug('accutidAssmtidMap.values() '+ accutidAssmtidMap.values() );
        
         List<Credit_Assessment__c> credLatest = [Select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Validation__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
           from Credit_Assessment__c where id = :accutidAssmtidMap.values()];
         
         // [Select  max(lastmodifieddate) lstdate, account__c acct from Credit_Assessment__c where account__c = :accList group by account__c ];
         
         
         
          List<Credit_Assessment__c> credassmtLst = new List<Credit_Assessment__c> ();
          Map<id, Credit_Assessment__c> credAssmtMap = new  Map<id, Credit_Assessment__c> ();
          
         for(Credit_Assessment__c res : credLatest){
          // credassmtLst = [select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Status__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
           //from Credit_Assessment__c where account__c = :(id)res.get('acct')  and lastmodifieddate = :(datetime) res.get('lstdate') limit 1 ];
           
            system.debug('acct ' + res.Account__c + ' assmt ' + res );
            
            acctidAssmentMap.put(res.Account__c, res);
         
         }
         
         
        
         //List<Credit_Assessment__c> credassmtLst = [select id, name, Review_Type__c, Assessment_Status__c, account__c, account__r.id, Payment_History_Status__c, Risk_Grade_Criteria__c, Auto_Evaluation_Message__c
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
        
            EfxTrans.name = acc.name;
            EfxTrans.Street_Address = acc.BillingStreet; 
            EfxTrans.City_Name = acc.BillingCity;
            EfxTrans.State_Name = acc.BillingState;
            EfxTrans.zipCode = acc.BillingPostalCode;
            EfxTrans.country = acc.billingCountry;
            
            forseva1.CompanyLookupResultGlobal bestMatch;
             if(!Test.isRunningTest()){
             bestMatch = getTheBestMatch(EfxTrans);//get best match for the Account
             }
            system.debug('bestMatch ' + bestMatch);
             if(bestMatch !=  null){
            EfxCalloutResult =  EfxHit;
        }
        else{
           EfxCalloutResult =  EfxNoHit;
        }
            system.debug('@@@@EfxCalloutResult'+EfxCalloutResult);
            if(EfxCalloutResult == EfxHit){
                if(!Test.isRunningTest()){
                    bestMatchCompanyId = bestMatch.getCompanyId();
                }
                else{
                    bestMatchCompanyId = '123456';
                }
                
                system.debug('@@@@bestMatchCompanyId'+bestMatchCompanyId);
                
                //if(acc.forseva1__Experian_File_Number__c == bestMatchCompanyId){
                    if(!Test.isRunningTest()){
                         system.debug('pulling  report ' + acc +  bestMatchCompanyId);
                        EFX_Report = getEfxReport(acc, bestMatchCompanyId);// Pull report
                    }
                    else{
                        forseva1__EquifaxInternationalCommercialReport__c Efxobj = new forseva1__EquifaxInternationalCommercialReport__c();
                        Efxobj.forseva1__Account__c = acc.id;
                        Efxobj.forseva1__Financial_Score__c = 0;
                        insert Efxobj;
                        
                        EFX_Report = Efxobj;
                    }
                    system.debug('@@@@EFX_Report'+EFX_Report);
                    
                    
               // } else {
                    
                //}
            } else if(EfxCalloutResult == EfxNoHit ){// BestMatch = null, DnB No hit scenario
                system.debug('@@@@@in to the Experian no hit @@@@@');
                isEfxHit = false;
                
                forseva1__EquifaxInternationalCommercialReport__c Efxobj = new forseva1__EquifaxInternationalCommercialReport__c();
                Efxobj.forseva1__Account__c = acc.id;
                Efxobj.forseva1__Financial_Score__c = 0;
                insert Efxobj;
                
                EFX_Report = Efxobj;
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

     public forseva1.CompanyLookupResultGlobal getTheBestMatch(EquifaxTransaction EfxTransaction){ 
            
     forseva1.CommercialReportService crs = new forseva1.CommercialReportService('Equifax International');
    
        forseva1.CompanyLookupResultGlobal bestMatch;
        try{         
            system.debug('EfxTransaction ' + EfxTransaction);
            
            forseva1__CreditPolicy__c cp = [select id, forseva1__First_Lookup_Confidence_Threshold__c from forseva1__CreditPolicy__c where name = 'Equifax'];
            system.debug('@@@@ START efx LIST OF SIMILAR:::-'+datetime.now());
                       
            List<forseva1.CompanyLookupResultGlobal> EfxGlobalData =  crs.getListofSimilars(EfxTransaction.name, EfxTransaction.Street_Address, 
                EfxTransaction.City_Name, EfxTransaction.State_Name,EfxTransaction.zipCode, EfxTransaction.country, 'Equifax International Commercial', cp.forseva1__First_Lookup_Confidence_Threshold__c, 'First Verification', cp.Id);
           system.debug('EfxGlobalData '  + EfxGlobalData);
           bestMatch = getBestMatch(EfxGlobalData);
                
        } catch(Exception exp) {
            system.debug(exp.getMessage());
      }
  
        
        return bestMatch;
    }
    
     public forseva1.CompanyLookupResultGlobal getBestMatch(List<forseva1.CompanyLookupResultGlobal> los) {
        
         Wex_UK_Configurable__c configVals =  WexUK_Reassessment_Handler.getConfigurableValues();
       
        Integer threshold = (Integer)configVals.Confidence_Threshold_EFX__c;
        
        System.debug('threshold '+ threshold );
        
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

    public forseva1__EquifaxInternationalCommercialReport__c getEfxReport(Account acct, String bestmatchDnBNumber){
        
        system.debug('inside getEfxReport ');
        
 
            forseva1.CommercialReportService crs = new forseva1.CommercialReportService('Equifax International');
    
            system.debug('inside getEfxReport ' +acct.id + bestmatchDnBNumber);
            
            forseva1__EquifaxInternationalCommercialReport__c EfxReport = 
             (forseva1__EquifaxInternationalCommercialReport__c)crs.getAndSaveReport('Credit Review', 'Equifax International Commercial', acct.id, bestmatchDnBNumber);
             
            
            system.debug('@@@@GOT The Report '+ datetime.now());
             
        
            return EfxReport;
            
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