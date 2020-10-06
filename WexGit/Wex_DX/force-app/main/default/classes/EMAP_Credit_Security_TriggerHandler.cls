/**
* This class is used as a Credit Security trigger handler
* Includes all the methods to be performed on before and after events
* CS : Credit Security
*/
public with sharing class EMAP_Credit_Security_TriggerHandler{

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
    
    /* used to update CS currency field with Account -> Program -> Currency value 
    *  Parameters: List of new CS records
    */
    public static void  updateCurrency(List<Credit_Security__c > creditSecNewList){
        List<Id> creditSecIds = new List<Id>();
        Map<Id, Credit_Security__c> creditSecMap = new Map<Id, Credit_Security__c>();
        for(Credit_Security__c creditSecNewRec: creditSecNewList){
                creditSecIds.add(creditSecNewRec.id);
                creditSecMap.put(creditSecNewRec.id, creditSecNewRec);
        }
        
        if(creditSecIds != null && creditSecIds.size() > 0){
        
            List<Credit_Security__c> creditSecList = 
                [Select Id, Name, Account__r.RecordTypeId, Account__r.Program_Currency__c 
                From Credit_Security__c 
                Where Id IN: creditSecIds AND Account__r.RecordTypeId =: accountRecType.getRecordTypeId()];
            
            if(creditSecList != null && creditSecList.size() > 0){    
                for(Credit_Security__c creditSecRec: creditSecList ){
                    //only Account with record type 'EMAP Fuel Accounts'
                    if(creditSecRec.Account__r.RecordTypeId == accountRecType.getRecordTypeId()){
                        String programCurrency = creditSecRec.Account__r.Program_Currency__c;
                        
                        Credit_Security__c creditSecRecTemp = creditSecMap.get(creditSecRec.Id);
                        creditSecRecTemp.CurrencyIsoCode = programCurrency ;
                    }
                }
            }
        }
    }
    
    /* used to update CS security expiry on associated Account
    *  Parameters: List of new CS records
    */
    public static void updateCreditSecurityExpiry_OnAccount(List<Credit_Security__c > creditSecNewList){
        List<ID> accIDlist = new List<ID>();
        for(Credit_Security__c cd : creditSecNewList)
        {
            if(cd.Account__c != null){
                accIDlist.add(cd.Account__c);
            }
        }
    
        if(accIDlist.size() > 0){
            List<Credit_Security__c> creditSecList = 
                    [Select id , Account__c, Account__r.name, Status__c , Security_Expiry__c 
                     From  Credit_Security__c 
                     Where Account__c IN: accIDlist AND Status__c = 'Active' order by Account__r.id ASC, Security_Expiry__c DESC];
            
        	//map of Account Id and Credit Security
            Map<Id, Credit_Security__c> credSecMap = new Map<Id, Credit_Security__c>();
            
            for(Credit_Security__c credSec: creditSecList){
                credSecMap.put(credSec.Account__c, credSec);
            }
            
            List<Account> accList = 
                [Select id, name, RecordTypeId, Security_Expiry__c 
                From Account 
                Where id IN: accIDList AND RecordTypeId =: accountRecType.getRecordTypeId()];
            
            if(accList  != null && accList.size() > 0){
            
                List<Account> accToUpdate = new List<Account>();
                Boolean isCreditSecActive = false;
                
                for(Account acc: accList){
                    //only Account with record type 'EMAP Fuel Accounts'
                    if(acc.RecordTypeId == accountRecType.getRecordTypeId()){
                        Credit_Security__c cs = credSecMap.get(acc.id);
            
                        if(cs!=null && cs.Security_Expiry__c!=null){
                            acc.Security_Expiry__c = cs.Security_Expiry__c;
                            accToUpdate.add(acc);
                            isCreditSecActive = true;
                            break;          
                        }
            
                        if(isCreditSecActive == false){
                            acc.Security_Expiry__c = null;
                            accToUpdate.add(acc);
                        }
                    }
                }
                update accToUpdate;
            }         
        }
    }   
}