/**
* This class is used as a Trigger Handler for trigger on Account object having 'EMAP Fuel Accounts' record type
* It includes all methods to be executed on before and after events
*/
public with sharing class EMAP_Account_TriggerHandler{

    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
    public static Schema.RecordTypeInfo accountRecType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');
    public static Schema.RecordTypeInfo contactRecType = getRecordTypeInfo('Contact', 'EMAP Contact');
    public static Boolean AccContUpdateFlag = false;
    public static Boolean isChildAccountController = false;
    public static Boolean isUpdateParentGroupBal = false;
        
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

    /* used to update EMAP Account record currency with program currency
    *  Parameters: List of new Account records
    */    
    public static void updateCurrency(List<Account> newAccList){
        try{
            //list of account Ids
            List<Id> accIds = new List<Id>();

            //List of Program Ids
            List<Id> programIds = new List<Id>();
            
            for(Account accNewRec: newAccList){
                //only 'EMAP Fuel Accounts' records
                if(accNewRec.recordTypeId == accountRecType.getRecordTypeId() ){
                    
                    //set Account currency as Program currency
                    if(accNewRec.Program_Currency__c != null){
                        accNewRec.CurrencyIsoCode = accNewRec.Program_Currency__c;
                    }
                    
                    //list of Program Ids
                    if(accNewRec.Client_Name__c == null && accNewRec.Program__c != null){
                        programIds.add(accNewRec.Program__c);
                    }
                }
            }
            
            //below line of code is used to set client name on Account if it is blank after delta update
            if(programIds.size() > 0){
                Map<Id, Program__c> programMap = new Map<Id, Program__c>([Select id, name, Client_Name__c From Program__c Where Id In: programIds]);
                
                for(Account accNew: newAccList){
                    Program__c program = programMap.get(accNew.Program__c);
                    accNew.Client_Name__c = program.Client_Name__c;
                }
            }
        } catch(Exception ex) {
            System.debug('EMAP_Account_TriggerHandler updateCurrency failed. Reason is::-'+ex.getMessage());
        }
    }
    
    /* used to update Group balance on Parent Account based on Current balance on child accounts
    *  Parameters: List of new Account records
    */
    public static void UpdateParentGroupBal(List<Account> newAccList){
        system.debug('in isUpdateParentGroupBal  @@@@@@@@@@@@@@@@@'+isUpdateParentGroupBal);
        if(!isUpdateParentGroupBal){
            try{
                //Limit the size of list by using Sets which do not contain duplicate elements
                Set<String> parentAccIds = new Set<String>();
                system.debug('in newAccList  @@@@@@@@@@@@@@@@@'+newAccList);
                //When adding new child accounts or updating child accounts     
                for(Account newAcc: newAccList){
                    //only 'EMAP Fuel Accounts' records and Hierarchy Level 03
                    if(newAcc.recordTypeId == accountRecType.getRecordTypeId() && 
                        newAcc.parentId != null && 
                        newAcc.Hierarchy_Level__c == '03'){
                            parentAccIds.add(newAcc.parentId);
                    }
                }
                system.debug('in parentAccIds  @@@@@@@@@@@@@@@@@'+parentAccIds);
                if(parentAccIds != null && parentAccIds.size() > 0){

                    //Map will contain one acc parent Id to one sum current_balance value
                    Map<String, Decimal> accMap = new Map<String, Decimal>();
                
                    //Produce a sum of H3_Account_Current_Balance__c and add them to the map
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
                    List<Account> parentAccList = [Select Id, Group_Balance__c From Account Where Id IN :parentAccIds FOR UPDATE];
                    system.debug('in parentAccList  @@@@@@@@@@@@@@@@@'+parentAccList);
  
                    for(Account acc: parentAccList){
                        Decimal grp_bal = accMap.get(acc.Id);                        
                        if(grp_bal !=acc.Group_Balance__c){
                        	acc.Group_Balance__c = grp_bal;                        
                        	accToBeUpdated.add(acc);
                        }
                    }
                    isUpdateParentGroupBal = true;
                    update accToBeUpdated; 
                    system.debug('in accToBeUpdated  @@@@@@@@@@@@@@@@@'+accToBeUpdated);         
                }           
            } catch(Exception ex) {
                isUpdateParentGroupBal = false;
                System.debug('EMAP_Account_TriggerHandler UpdateParentGroupBal failed. Reason is::-'+ex.getMessage());
            }
        }
    }

    /* used to update EMAP primary contact on Account
    *  Parameters: Map of old Contact records and List of new Contact records
    */
    public static void updatePrimaryContactOnAccount(Map<Id, Contact> contOldMap, List<Contact> contNewList){
        try{
            if(AccContUpdateFlag == false){
                System.debug('Inside updatePrimaryContactOnAccount method');
                List<Id> accIds = new List<Id>();
                Map<Id, Contact> contMap = new Map<Id, Contact>();
                
                for(Contact contNew: contNewList){
                    //only 'EMAP Contact' records
                    if(contNew.recordTypeId == contactRecType.getRecordTypeId()){
                        //after update
                        if(contOldMap!= null && contOldMap.size() > 0){
                            Contact contOld = contOldMap.get(contNew.id);
                            if(contNew.accountId != null && contNew.Primary__c == true && contOld.Primary__c == false){
                                accIds.add(contNew.accountId);
                                contMap.put(contNew.accountId, contNew);
                            }
                        } 
                        // after insert
                        else {
                            if(contNew.accountId != null && contNew.Primary__c == true){
                                accIds.add(contNew.accountId);
                                contMap.put(contNew.accountId, contNew);
                            }
                        }
                    }
                }

                if(accIds.size() > 0){
                    List<Account> accList = [Select id, Primary_Contact__c, AU_Application_Request__c From Account Where id IN: accIds];
                    
                    List<Account> accToBeUpdated = new List<Account>();
                    for(Account acc: accList){
                        Contact cont = contMap.get(acc.id);
                        acc.Primary_Contact__c = cont.id;
                        accToBeUpdated.add(acc);
                    }
                    AccContUpdateFlag = true;
                    update accToBeUpdated;
                }
            }
        } catch(Exception ex) {
            AccContUpdateFlag = false;
            System.debug('EMAP_Account_TriggerHandler updatePrimaryContactOnAccount failed. Reason is::-'+ex.getMessage());
        }

    }
    
    /* used to update Child Account Account controller when H1 and H3 Parent account controller is updated.
    *  Parameters: Map of old and new Accounts
    */
    public static void updateChildAccountController(Map<Id, Account> oldAccMap, Map<Id, Account> newAccMap){
        if(!isChildAccountController){
            try{
                List<Account> newAccList = newAccMap.values();
                
                //Limit the size of list by using Sets which do not contain duplicate elements
                Set<String> parentAccIds = new Set<String>();
                
                //get valid set of Parent Ids
                for(Account newAcc: newAccList){
                    //get Account's old values
                    Account oldAcc = oldAccMap.get(newAcc.id);
                    
                    //check is it parent Account and hierarchy level is '01' or '03'
                    if(newAcc.recordTypeId == accountRecType.getRecordTypeId() &&                      
                        (newAcc.Hierarchy_Level__c == '01' || newAcc.Hierarchy_Level__c == '03')&&
                        (oldAcc.Hierarchy_Level__c != newAcc.Hierarchy_Level__c || oldAcc.Aggregated_Tel_USD__c != newAcc.Aggregated_Tel_USD__c) 
                   ){ if(newAcc.parentId != null){
                       parentAccIds.add(newAcc.parentid);
                   } else if(newAcc.parentId == null ){ 
                        parentAccIds.add(newAcc.id);
                   }
                          
                }
                }
                System.debug('@@@@@parentAccIds.size()@@@@@'+parentAccIds.size());
                if(parentAccIds.size() > 0){
                    //get list of child Accounts based on Parent Account Ids
                    List<Account> childAccList = [Select id, parentId, parent.Account_Controller__c,RecordTypeId, Hierarchy_Level__c, Account_Controller__c From Account Where parentId In: parentAccIds];
                                                System.debug('in child@@@@@childAccList@@@@@'+childAccList);
                    
                    List<Account> childAccListUpdated = new List<Account> ();
                    
                    for(Account childAcc: childAccList){
                        //check if it is child account and hierarchy level is '01' or '03'
                        if(childAcc.recordTypeId == accountRecType.getRecordTypeId() && 
                            ((childAcc.Hierarchy_Level__c == '01' || childAcc.Hierarchy_Level__c == '03') && (childAcc.Account_Controller__c != childAcc.parent.Account_Controller__c))){
                                System.debug('in if @@@@@childAccList@@@@@');
                                Account parentAcc = newAccMap.get(childAcc.parentId);
                                System.debug('in if @@@@@parentAcc@@@@@'+parentAcc);
                                //set parent account controller on all child Accounts
                                childAcc.Account_Controller__c = childAcc.parent.Account_Controller__c;
                                System.debug('in @@@@@childAcc.Account_Controller__c@@@@@'+childAcc.Account_Controller__c);
                                childAccListUpdated.add(childAcc);
                        }
                    }
                    isChildAccountController = true;
                    
                    update childAccListUpdated;
                }
            } catch(Exception ex){
                isChildAccountController = false;
                System.debug('EMAP_Account_TriggerHandler updateChildAccountController failed. Reason is::- '+ex.getMessage());
            }
        }
    }
    
    /* used to update parent/child Account controller when H0 and H2 account or H1/H2 parent Account is updated.
    *  Parameters: Map of old and new Accounts
    */
    public static void updateAccountController(Map<Id, Account> oldAccMap, Map<Id, Account> newAccMap){
        try{
            List<Account> newAccList = newAccMap.values();
            
            for(Account newAcc: newAccList){
                //get Account's old values
                Account oldAcc = oldAccMap.get(newAcc.id);

                //check Hierarchy level 00 or 02 or parent account with Hierarchy level 01/02/03
                if(newAcc.recordTypeId == accountRecType.getRecordTypeId() && 
                    (oldAcc.Aggregated_Tel_USD__c != newAcc.Aggregated_Tel_USD__c) && 
                    (newAcc.Hierarchy_Level__c == '00' || newAcc.Hierarchy_Level__c == '02' ||
                    (newAcc.parentId == null && (newAcc.Hierarchy_Level__c == '01' || newAcc.Hierarchy_Level__c == '02' || newAcc.Hierarchy_Level__c == '03'))) 
                ){
                    if(newAcc.Aggregated_Tel_USD__c > 50000){
                        newAcc.Account_Controller__c = 'EMTC';
                    }  else if(newAcc.Aggregated_Tel_USD__c == null || newAcc.Aggregated_Tel_USD__c <= 50000){
                        newAcc.Account_Controller__c = 'WEX';
                    }
                }
                
            }
        } catch(Exception ex){
                System.debug('EMAP_Account_TriggerHandler updateAccountController failed. Reason is::- '+ex.getMessage());
            }
    }    
}