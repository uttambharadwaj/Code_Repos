/**
* This class is used as a Trigger Handler for trigger on Contact object having 'EMAP Contact' record type
* It includes all methods to be executed on before and after events
*/
public with sharing class EMAP_Contact_TriggerHandler{

    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe();
    public static Schema.RecordTypeInfo appReqRecType = getRecordTypeInfo('AU_Application_Request__c', 'EMAP Application Request');
    public static Schema.RecordTypeInfo accountRecType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');
    public static Schema.RecordTypeInfo contactRecType = getRecordTypeInfo('Contact', 'EMAP Contact');
    public static Boolean AUAppContUpdateflag = false;
    
    /* used to lock EMAP Contact record when Application_Status is Fulfilled for all users (except System Administrator and IFCS Connector)
    *  Parameters: Map of new contact records
    */
    public static void lockContactRecord(Map<Id, Contact> newContactMap){
    	Profile profile = null;
    	
    	if(UserInfo.getProfileId() != null && UserInfo.getProfileId() != ''){
    		profile = [Select id, name From Profile Where id=: UserInfo.getProfileId()];
    	}
        
        //check logged in user profile
        if(profile != null &&
        	profile.name != 'System Administrator' && 
           	profile.name != 'AU System Administrator' && 
           	profile.name != 'IFCS Connector'){
            
            //set of contact's Accounts Ids
            Set<Id> accIds = new Set<Id>();
            
            for(Contact cont: newContactMap.values()){
                accIds.add(cont.AccountId);
            }
            
            //Map of Accounts having non-primary contacts
            Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, AU_Application_Request__c, AU_Application_Request__r.Application_Status__c From Account Where Id In: accIds]);
            
            //list of contact Ids
            Set<Id> contactIds = newContactMap.keySet();
            
            //List of AU App Req having primary contact
            List<AU_Application_Request__c> AUAppReqList = [Select id, name, Application_Status__c, Primary_Contact__c From AU_Application_Request__c Where Primary_Contact__c IN: contactIds];
            
            //map of contact id and application request
            Map<Id, AU_Application_Request__c> AUAppReqMap = new Map<Id, AU_Application_Request__c>();
            
            for(AU_Application_Request__c AUAppReq: AUAppReqList){
                AUAppReqMap.put(AUAppReq.Primary_Contact__c, AUAppReq);
            }
            
            for(Contact newCont: newContactMap.values()){
                
                //EMAP Contact record type check
                if(newCont.recordTypeId == contactRecType.getRecordTypeId()){

                    //get AU App Req record from Map
                    AU_Application_Request__c AUAppReq = AUAppReqMap.get(newCont.id);

                    //lock primary contact record if associated AU App Req's Application Status is 'Fulfilled'
                    if(AUAppReq != null) {
                        
                        if(AUAppReq.Application_Status__c == 'Fulfilled'){
                            //add Error
                            newCont.addError('Application status is ' + AUAppReq.Application_Status__c + '. So record is locked. Please contact your System Administrator.');
                        }

                    } else {
                        Account acc = accMap.get(newCont.AccountId);
    
                        //lock non-primary contact record if associated AU App Req's Application Status is 'Fulfilled'
                        if( acc.AU_Application_Request__c != null) {
                            
                            if(acc.AU_Application_Request__r.Application_Status__c == 'Fulfilled'){
                                //add Error
                                newCont.addError('Application status is ' + acc.AU_Application_Request__r.Application_Status__c + '. So record is locked. Please contact your System Administrator.');
                            }
                        }
                        //lock contact if Account not having associated AU Application Request 
                        else {
                                //add Error
                                newCont.addError('You are not authorised to update this record. Please contact your System Administrator.');                            
                        }
                    }
                }
            }
        }
        
    }
    
    /* used to populate EMAP Contact details on associated AU App Req record
    *  Parameters: List of new Contact records
    */
    public static void populateContToAuAppReq(list<Contact> contNewList) {
        try{
            if(AUAppContUpdateflag == false){
                System.debug('Inside populateContToAuAppReq method');
                List<Id> contIds = new List<Id>();
                Map<Id, Contact> contMap = new Map<Id, Contact>();
                
                for(Contact contNew: contNewList){
                    //only 'EMAP Contact' records
                    if(contNew.recordTypeId == contactRecType.getRecordTypeId()){
                        contIds.add(contNew.id);
                    }
                }
                
                if(contIds!=null && contIds.size()>0){
                    List<AU_Application_Request__c> AUAppReqList =
                        [Select Id, Application_Status__c, Primary_Contact__c, Contact_Type__c, Contact_Email__c, Contact_Fax__c, //Primary_Contact_Salutation__c, Contact_Title__c 
                            Primary_Contact_Last_Name__c, Primary_Contact_Mobile_Number__c, Primary_Contact_Mobile_Phone2__c, Contact_Phone_Number__c //Primary_Contact_First_Name__c 
                        From AU_Application_Request__c Where Primary_Contact__c IN: contIds];

                    if(AUAppReqList != null && AUAppReqList.size() > 0){

                        List<AU_Application_Request__c> AUAppReqToBeUpdated = new List<AU_Application_Request__c>();
                        System.debug('####Inside Contact To AU App Req Sync Trigger');
                        
                        for(Contact cont: contNewList){
                            for(AU_Application_Request__c AUAppReq: AUAppReqList){
                                if((cont.Id == AUAppReq.Primary_Contact__c) && AUAppReq.Application_Status__c != 'Fulfilled'){
                                    //AUAppReq.Contact_Title__c = cont.Title;
                                    AUAppReq.Contact_Type__c = cont.Contact_Type__c;
                                    //AUAppReq.Primary_Contact_Salutation__c = cont.Salutation;
                                    AUAppReq.Contact_Email__c = cont.Email;
                                    AUAppReq.Contact_Fax__c = cont.Fax;
                                    //AUAppReq.Primary_Contact_First_Name__c = cont.FirstName;
                                    AUAppReq.Primary_Contact_Last_Name__c = cont.LastName;
                                    AUAppReq.Primary_Contact_Mobile_Number__c = cont.MobilePhone;
                                    AUAppReq.Primary_Contact_Mobile_Phone2__c = cont.OtherPhone;
                                    AUAppReq.Contact_Phone_Number__c = cont.Phone;
                                    
                                    AUAppReqToBeUpdated.add(AUAppReq);
                                }
                            }
                        }
        
                        AUAppContUpdateflag = true;
                        update AUAppReqToBeUpdated;
                    }
                }
            }
        } catch(Exception ex) {
            AUAppContUpdateflag = false;
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }
    }

    /* used to populate EMAP AU App Req's primary contact details on associated Contact record
    *  Parameters: List of new AU App Req records
    */
    public static void propagateAUAppReqToContact(List<AU_Application_Request__c> AUAppReqNewList){
        try{
            if(AUAppContUpdateflag == false){
                System.debug('Inside propagateAUAppReqToContact method');
                List<Id> accountIds = new List<Id>();
                List<Id> contIds = new List<Id>();
                Map<Id, AU_Application_Request__c> AuAppReqMap = new Map<Id, AU_Application_Request__c>();
                for(AU_Application_Request__c AUAppReqNew: AUAppReqNewList){
                    //only 'EMAP Contact' records
                    if(AUAppReqNew.recordTypeId == appReqRecType.getRecordTypeId()){
                        contIds.add(AUAppReqNew.Primary_Contact__c );
                        accountIds.add(AUAppReqNew.Account__c);
                        AuAppReqMap.put(AUAppReqNew.Primary_Contact__c, AUAppReqNew);
                    }
                }
                
                List<Contact> nonPrimaryContToBeUpdated = new List<Contact>();

                //uncheck non primary contacts on Account except primary contact
                if(accountIds != null && accountIds.size() > 0){
                    List<Contact> contList = [Select id, FirstName, LastName, AccountId, Primary__c From Contact Where accountId IN: accountIds];
                    
                    if(contList != null && contList.size() > 0){
                        for(Contact contTemp: contList){
                            AU_Application_Request__c AUAppReq = AuAppReqMap.get(contTemp.id);
                            if(AUAppReq == null ){
                                contTemp.Primary__c = false;
                            }
                            nonPrimaryContToBeUpdated.add(contTemp);
                        }
                    }
                }

                //propagate EMAP AU App Req's primary contact details on associated Contact record
                if(contIds != null && contIds.size()>0){
                    List<Contact> primaryContList = [Select id, Title, Contact_Type__c, Email, Fax, FirstName, LastName, MobilePhone, 
                                                    OtherPhone, Phone, Primary__c //,Salutation 
                                                From Contact Where id IN: contIds];
                                                
                    if(primaryContList!=null && primaryContList.size()>0){  
                        
                        List<Contact> contToBeUpdated = new List<Contact>();
                        System.debug('####Inside AU App Req To Contact Sync Trigger');
                        for(Contact cont: primaryContList){
                            AU_Application_Request__c AUAppReq = AuAppReqMap.get(cont.id);
                            cont.Primary__c = true;
                            //cont.Title = AUAppReq.Contact_Title__c;
                            cont.Contact_Type__c = AUAppReq.Contact_Type__c;
                            //cont.Salutation = AUAppReq.Primary_Contact_Salutation__c;
                            cont.Email = AUAppReq.Contact_Email__c;
                            cont.Fax = AUAppReq.Contact_Fax__c;
                            //cont.FirstName = AUAppReq.Primary_Contact_First_Name__c;
                            cont.LastName = AUAppReq.Primary_Contact_Last_Name__c;
                            cont.MobilePhone = AUAppReq.Primary_Contact_Mobile_Number__c;
                            cont.OtherPhone = AUAppReq.Primary_Contact_Mobile_Phone2__c;
                            cont.Phone = AUAppReq.Contact_Phone_Number__c;
                            
                            contToBeUpdated.add(cont);
                        }
                        AUAppContUpdateflag = true;
                        update nonPrimaryContToBeUpdated;
                        update contToBeUpdated;
                    }
                }
            }
        } catch(Exception ex) {
            AUAppContUpdateflag = false;
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }    
    }
    
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
        
}