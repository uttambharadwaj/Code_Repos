/**
* This class is used as a Credit Assessment trigger handler
* Includes all the methods to be performed on before and after events
* CA : Credit Assessment
*/
public with sharing class EMAP_Credit_Assessment_TriggerHandler{

    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe();
    public static Schema.RecordTypeInfo accountRecType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');
    
    /* used to get Record Type info on any object
    *  Parameters: Object name and Record Type name
    */
    public static Schema.RecordTypeInfo getRecordTypeInfo(String objectName, String recordTypeName){
                
        if(globalDesc.containsKey(objectName)){
                Schema.SObjectType d = globalDesc.get(ObjectName);
                Schema.DescribeSObjectResult r = d.getDescribe();
                Map<String,Schema.RecordTypeInfo> rtMapByName = r.getRecordTypeInfosByName();
                
                return rtMapByName.get(recordTypeName);                 
        }
        else {
            return null;
        }    
    }
     
    /* used to update Approval fields on Credit Assessment record
    *  Parameters: List of new CA records
    */
    public void updateApprovalFields(List<Credit_Assessment__c> creditRecNewList){
        for(Credit_Assessment__c creditRec: creditRecNewList){
            if(creditRec.Final_Judgement__c != null){
                creditRec.Approved_By__c = UserInfo.getUserId();
                creditRec.Approved_Date__c = System.today();
            }
        }
    }

    /* used to update CA currency field with Account -> Program -> Currency value 
    *  Parameters: List of new CA records
    */
    public void updateCurrency(List<Credit_Assessment__c> creditRecNewList){
    
        List<Id> creditAssIds = new List<Id>();
        Map<Id, Credit_Assessment__c> creditAssMap = new Map<Id, Credit_Assessment__c>();
        for(Credit_Assessment__c creditNewRec: creditRecNewList){
            creditAssIds.add(creditNewRec.id);
            creditAssMap.put(creditNewRec.id, creditNewRec);
        }
        
        if(creditAssIds != null && creditAssIds.size() > 0){
            //SOQL to get program currency from Account look up field on CA
            List<Credit_Assessment__c> creditAssList = 
                [Select Id, Name, Account__r.RecordTypeId, Account__r.Program_Currency__c 
                From Credit_Assessment__c 
                Where Id IN: creditAssIds AND Account__r.RecordTypeId =: accountRecType.getRecordTypeId()];
            
            if(creditAssList != null && creditAssList.size() > 0){    
                for(Credit_Assessment__c creditRec: creditAssList){
                    //only Account with record type 'EMAP Fuel Accounts' 
                    if(creditRec.Account__r.RecordTypeId == accountRecType.getRecordTypeId()){
                        String programCurrency = creditRec.Account__r.Program_Currency__c;
                    
                        Credit_Assessment__c creditRecTemp = creditAssMap.get(creditRec.Id);
                        creditRecTemp.CurrencyIsoCode = programCurrency ;
                    }
                }
            }
        }
    }

    /* used to lock CA record when Final judgement is Approved or Declined for all users (except System Administrator)
    *  Parameters: List of old CA records and Map of new CA records
    */
    public void lockCreditAssmnt(List<Credit_Assessment__c> creditRecOldList, Map<Id, Credit_Assessment__c> creditRecNewMap){
        Profile profile = [Select id, name From Profile Where id=: UserInfo.getProfileId()];
        
        if(profile.name != 'System Administrator' && profile.name != 'AU System Administrator'){
            for(Credit_Assessment__c creditAssOld: creditRecOldList){

                Credit_Assessment__c creditAssNew = creditRecNewMap.get(creditAssOld.id);

                if(creditAssOld.Final_Judgement__c == 'Approved' || creditAssOld.Final_Judgement__c == 'Declined'){
                    creditAssNew.addError('Credit Assessment final judgement is \'' + creditAssOld.Final_Judgement__c + '\'.So record is locked. Please contact your System Administrator.');
                }
            }
        }    
    }
    
    /* used to propagate few CA fields on associated Account record once CA's final judgement is Approved
    *  Parameters: List of new CA records
    */
    public void propagateCreditAssmntToAcc(List<Credit_Assessment__c> creditRecNewList){
        List<Id> accIds = new List<Id>();
        Map<Id, Credit_Assessment__c> creditRecMap = new Map<Id, Credit_Assessment__c>();
    
        for(Credit_Assessment__c creditRec: creditRecNewList){
            if(creditRec.Account__c!= null && 
                creditRec.Final_Judgement__c != null &&
                creditRec.Final_Judgement__c == 'Approved'){
                
                accIds.add(creditRec.Account__c);
                creditRecMap.put(creditRec.Account__c, creditRec);
            }
        }

        if(accIds != null && accIds.size() > 0){
        
            List<Account> accList = 
                    [Select Id, Name, Payment_Days__c, Payment_Method__c , Security_Value__c, CurrencyIsoCode, RecordTypeId, //Invoice_Frequency__c 
                         Credit_Limit_Lcy__c, Credit_Limit_USD__c, Credit_Limit__c, Total_Exposure_Limit_USD__c, Total_Exposure_Limit__c, 
                         Aggregated_Tel_USD__c, Aggregated_TEL__c, Risk_Grade__c, Nird__c  
                    From Account 
                    Where Id IN: accIds AND RecordTypeId =: accountRecType.getRecordTypeId()];
            
            if(accList != null && accList.size() > 0){        
                List<Account> accToBeUpdated = new List<Account>();
            
                for(Account acc: accList){
                    //only Account with record type 'EMAP Fuel Accounts' 
                    if(acc.RecordTypeId == accountRecType.getRecordTypeId()){
                        Credit_Assessment__c creditAssRec = creditRecMap.get(acc.id);
                        
                        acc.CurrencyIsoCode = creditAssRec.CurrencyIsoCode;
                        
/*
                        if(creditAssRec.Payment_Days__c != null && creditAssRec.Payment_Days__c != ''){
                            acc.Payment_Days__c = creditAssRec.Payment_Days__c;
                        }
                        if(creditAssRec.Payment_Method__c != null && creditAssRec.Payment_Method__c != ''){
                            acc.Payment_Method__c = creditAssRec.Payment_Method__c;
                        }
                        if(creditAssRec.Security_Value__c != null && creditAssRec.Security_Value__c > 0){
                            acc.Security_Value__c = String.valueOf(creditAssRec.Security_Value__c);
                        }
                        
                        if(creditAssRec.Invoice_Frequency__c != null && 
                            creditAssRec.Invoice_Frequency__c != '' &&
                            creditAssRec.Invoice_Frequency__c != acc.Invoice_Frequency__c){
                                acc.Invoice_Frequency__c = creditAssRec.Invoice_Frequency__c;
                        }
*/
                        
                        if(creditAssRec.Credit_Limit_Lcy__c != acc.Credit_Limit_Lcy__c){
                                acc.Credit_Limit_Lcy__c = creditAssRec.Credit_Limit_Lcy__c;
                        }
                        
                        if(creditAssRec.Approved_Credit_Limit_USD__c != acc.Credit_Limit_USD__c){
                                acc.Credit_Limit_USD__c = creditAssRec.Approved_Credit_Limit_USD__c;
                        }
                        
                        if(creditAssRec.Credit_Limit_Requested__c != acc.Credit_Limit__c){
                                acc.Credit_Limit__c = creditAssRec.Credit_Limit_Requested__c;
                        }
                        
                        if(creditAssRec.Total_Exposure_Limit_USD__c != acc.Total_Exposure_Limit_USD__c){
                                acc.Total_Exposure_Limit_USD__c = creditAssRec.Total_Exposure_Limit_USD__c;
                        }
                        
                        if(creditAssRec.Total_Exposure_Limit_LCY__c != acc.Total_Exposure_Limit__c){
                                acc.Total_Exposure_Limit__c = creditAssRec.Total_Exposure_Limit_LCY__c;
                        }
                        
                        if(creditAssRec.Aggregated_Tel_USD__c != acc.Aggregated_Tel_USD__c){
                                acc.Aggregated_Tel_USD__c = creditAssRec.Aggregated_Tel_USD__c;
                        }
                        
                        if(creditAssRec.Aggregated_TEL_LCY__c != acc.Aggregated_TEL__c){
                                acc.Aggregated_TEL__c = creditAssRec.Aggregated_TEL_LCY__c;
                        }

                        if(creditAssRec.Risk_Level__c != null && 
                            creditAssRec.Risk_Level__c != '' && 
                            creditAssRec.Risk_Level__c != acc.Risk_Grade__c){
                                acc.Risk_Grade__c = creditAssRec.Risk_Level__c ;
                        }

                        if(creditAssRec.Nird__c != null && creditAssRec.Nird__c != acc.Nird__c){
                            acc.Nird__c = creditAssRec.Nird__c;
                        }
                                        
                        accToBeUpdated.add(acc);
                    }
                    
                }
                
                update accToBeUpdated;
            }
        } 
    }
    
    /* used to maintain Assessment sub status old value in Revert to Status Field, once new sub-status is Hold
    *  Parameters: Map of old CA records and List of new CA records
    */
    public void Update_RevertToStatus(Map<Id, Credit_Assessment__c> Credit_OldMap, list<Credit_Assessment__c> Credit_New) {
        for(Credit_Assessment__c CD_New : Credit_New) {
            Credit_Assessment__c CD_Old = Credit_OldMap.get(CD_New.id);
            
            //set sub-status old value in Revert_To_Status field, when sub-status new value is Hold
            if(CD_New.Assessment_Sub_Status__c == 'Hold' && 
               (CD_New.Revert_To_Status__c == null || CD_New.Revert_To_Status__c == '')) {
                   
                   if(CD_New.Assessment_Sub_Status__c != CD_Old.Assessment_Sub_Status__c) {
                       CD_New.Revert_To_Status__c = CD_Old.Assessment_Sub_Status__c;
                   }
               } 
            //update sub-status field with Revert_To_Status, when Hold_Expiration_Date is less than today date
            else if(CD_New.Revert_To_Status__c != null && CD_New.Hold_Expiration_Date__c < system.today()) {
                CD_New.Assessment_Sub_Status__c = CD_New.Revert_To_Status__c;
                CD_New.Revert_To_Status__c = null;
                CD_New.Hold_Expiration_Date__c = null;
            } 
            //delete Revert_To_Status and Hold_Expiration_Date values once sub-status changed from Hold ti anything else
            else if(CD_Old.Assessment_Sub_Status__c == 'Hold'){
                CD_New.Revert_To_Status__c = null;
                CD_New.Hold_Expiration_Date__c = null;
            }
        }
    }
    
    /* used to update AU App req Approval status once CA approval status is updated by approval process
    *  Parameters: List of new CA records
    */
    public void updateAUAppReqApprovalStatus(List<Credit_Assessment__c> creditRecNewList){
        
        List<Id> accList = new List<Id>();
        Map<Id, Credit_Assessment__c> csMap = new Map<Id, Credit_Assessment__c>();
        for(Credit_Assessment__c creditRec : creditRecNewList){
            //only those CA whose final judgement is Approved or Declined by approval process
            if(creditRec.Final_Judgement__c == 'Approved' || creditRec.Final_Judgement__c == 'Declined'){
                accList.add(creditRec.Account__c);
                csMap.put(creditRec.Account__c, creditRec);
            }
        }
    
        if(accList.size() > 0){
            //get list of AU App Req
            List<AU_Application_Request__c> AUAppReqList = [Select Id, Account__c, Application_Status__c From AU_Application_Request__c Where Account__c IN: accList];
            
            List<AU_Application_Request__c> listToUpdate = new List<AU_Application_Request__c>();
                  
            for(AU_Application_Request__c au : AUAppReqList){
                //update only those AU App req whose Application_Status__c is not 'Fulfilled''
                if(au.Application_Status__c != 'Fulfilled'){
                    Credit_Assessment__c cs = csMap.get(au.Account__c);
                    if(cs.Final_Judgement__c == 'Approved'){
                        au.Application_Status__c = 'Approved';
                    } else if(cs.Final_Judgement__c == 'Declined'){
                        au.Application_Status__c = 'Declined';
                        au.AU_Application_Decline_Reason__c = 'Declined by approver';
                    }
                    listToUpdate.add(au);
                }
            }
    
            update listToUpdate;      
        }
    }

    
    /* used to update Approval fields on Account
    *  Parameters: List of new CA records
    */
/*    
    public static void updateCreditApprovalFieldsonAccount(List<Credit_Assessment__c> creditRecNewList){
        List<Id> accIdList = new List<Id>();

        for(Credit_Assessment__c caNew: creditRecNewList){
            //get account Ids from Credit Assessment
            if(caNew.Account__c != null){
                accIdList.add(caNew.Account__c);
            }
        }
        
        if(accIdList.size() > 0){
            //get list of Credit Assessment for each Account
            List<Credit_Assessment__c> CAList = 
                        [Select id , Account__c, Account__r.name, Approved_By__c, Approved_Date__c 
                         From  Credit_Assessment__c 
                         Where Account__c IN: accIdList AND Final_Judgement__c = 'Approved' order by Account__r.id ASC, Approved_Date__c DESC];
            
            //map of Account Id and Credit Assessment
            Map<Id, Credit_Assessment__c> credAssessMap = new Map<Id, Credit_Assessment__c>();
            
            for(Credit_Assessment__c credAssess: CAList){
                credAssessMap.put(credAssess.Account__c, credAssess);
            }

            List<Account> accList = 
                [Select id, name, RecordTypeId, Credit_Limit_Approver_Equifax__c, Credit_Limit_Effective_Date_Equifax__c  
                From Account 
                Where id IN: accIdList AND RecordTypeId =: accountRecType.getRecordTypeId()];
                
            Boolean isCreditAssessApproved = false;
            List<Account> accToUpdate = new List<Account>();
            
            for(Account acc: accList){
                //only Account with record type 'EMAP Fuel Accounts'
                if(acc.RecordTypeId == accountRecType.getRecordTypeId()){
                    Credit_Assessment__c ca = credAssessMap.get(acc.id);
                    
                    //set Approval fields as Credit Assessment 
                    if(ca!=null && ca.Approved_By__c !=null){
                        acc.Credit_Limit_Approver_Equifax__c = ca.Approved_By__c;
                        acc.Credit_Limit_Effective_Date_Equifax__c = ca.Approved_Date__c;
                        accToUpdate.add(acc);
                        isCreditAssessApproved = true;
                        break;          
                    }
        
                    if(isCreditAssessApproved == false){
                        acc.Credit_Limit_Approver_Equifax__c = null;
                        acc.Credit_Limit_Effective_Date_Equifax__c = null;
                        accToUpdate.add(acc);
                    }
                }
            }
            update accToUpdate;
        }
    }
*/
}