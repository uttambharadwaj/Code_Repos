/**
* This class is used as a controller in DupeCheckPage and CreditApplicationPage
*/
public with sharing class EMAP_CreditApp_Controller{

    public AU_Application_Request__c AUAppReq {get; set;}
    public Program__c program {get; set;}
    public Account acc {get; set;}
    public Contact contact {get; set;}
    public Bank_Reference__c bankRef {get; set;}
    public Trade_Reference__c tradeRef1 {get; set;}
    public Trade_Reference__c tradeRef2 {get; set;}
    public Credit_Assessment__c creditAssessment {get; set;}
    public List<Document_Checklist_Matrix__c> docChkList {get; set;}
    public List<Account> accList {get; set;}
    public Boolean displayPopup {get; set;} 
    public Boolean isDocumentChecklistPresent{get; set;}
    public Boolean isSamePhysicalAddress {get; set;}
    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 

    public EMAP_CreditApp_Controller(){
        AUAppReq = new AU_Application_Request__c();
        program = new Program__c ();
        acc = new Account();
        contact = new Contact();
        bankRef = new Bank_Reference__c ();
        tradeRef1 = new Trade_Reference__c ();
        tradeRef2 = new Trade_Reference__c ();
        accList = new List<Account>();
        docChkList = new List<Document_Checklist_Matrix__c>();
        displayPopup = false;
        isSamePhysicalAddress = false;
        
        //set default 'EMAP Fuel Accounts' record type on Account
        Schema.RecordTypeInfo accRecordType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');
        acc.RecordTypeId = accRecordType.getRecordTypeId();
        
        //set default 'AU Contact' record type on Contact
        Schema.RecordTypeInfo contRecordType = getRecordTypeInfo('Contact', 'EMAP Contact');
        contact.RecordTypeId = contRecordType.getRecordTypeId();
        
        //set default 'EMAP Application Request' record type on AU App Req
        Schema.RecordTypeInfo appReqRecType = getRecordTypeInfo('AU_Application_Request__c', 'EMAP Application Request');
        AUAppReq.recordTypeId = appReqRecType.getRecordTypeId();
        
    }
    
    /** This method is used to perform Duplicate check on Account
    * Duplicate check is performed based on Program Name, Account Name, Business Trading name and Business Registration Number.
    */
    public pageReference DupeCheck(){
        
        String query = 'Select id, Name, Trade_Name_of_Business__c, Business_Registration_Number__c, Program__r.Program_Name__c From Account Where RecordType.name = \'EMAP Fuel Accounts\' ';
        query += ' and (';
        //Adding Account Name check in Dupe check query
        if(AUAppReq.Account_Company_Name__c != null && AUAppReq.Account_Company_Name__c != '') {
            String accName = (AUAppReq.Account_Company_Name__c).trim();
            if(accName.length() > 30){
                accName = accName.subString(0, 30); 
                
                query += 'Name LIKE \'' + String.escapeSingleQuotes(accName) + '%\' ';
                
            } else {
                query += 'Name = \'' + String.escapeSingleQuotes(accName) + '\'';
            }
        }
        
        //Adding Trade Name of Business check in Dupe check query
        if(acc.Trade_Name_of_Business__c != null && acc.Trade_Name_of_Business__c != '') {
            String tradeName = (acc.Trade_Name_of_Business__c).trim();
            if(tradeName.length() > 30){
                tradeName = tradeName.subString(0, 30);
                
                query += ' OR Trade_Name_of_Business__c LIKE \'' + String.escapeSingleQuotes(tradeName) + '%\' ';
                
            } else {
                query += ' OR Trade_Name_of_Business__c = \'' + String.escapeSingleQuotes(tradeName) + '\'';
            }
        } 

        //Adding Business Registration Number check in Dupe check query
        if(AUAppReq.Account_Business_Registration_Number__c != null) {
            String regNumber = (AUAppReq.Account_Business_Registration_Number__c).trim();
            if(regNumber.length() > 30){
                regNumber = regNumber.subString(0, 30);
                
                query += ' OR Business_Registration_Number__c LIKE \'' + String.escapeSingleQuotes(regNumber) + '%\' ';
                
            } else {
                query += ' OR Business_Registration_Number__c = \'' + String.escapeSingleQuotes(regNumber) + '\'';
            }            
        }
        query += ')';
        System.debug('@@ query@@ ' + query);
        
        //get List of Duplicate Accounts
        accList = Database.query(query);
        
        //check duplicates found or not
        if(accList.size() <= 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Duplicates found'));
            displayPopup = false;
        }else{
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Duplicates found'));
            displayPopup = true;
        }
        
        return null;
    }

    //This method is used to close pop up 
    public pageReference closePopup() { 
        displayPopup = false;
        return null;    
    }
    
    //This method is used to proceed to next Credit Application VF page
    public pageReference nextPage() {
        isDocumentChecklistPresent = false;
        
        //Logic is used to identify required document check list defined in Document checklist matrix object
        //if(prog_name  != null && prog_name  != ''){        
            docChkList = [SELECT Id, Name, Card_Embossing_Form__c, Credit_Bureau_Results__c, Direct_Debit_Authority__c, Duty_Exemption_Letter__c, Financial_Statement__c, 
                            Letter_from_Government__c, Program_Name__c, Proof_of_Address__c, Security_Document__c, Staff_ID__c, Vehicle_Registration_Certificate__c, Application_TYpe__c 
                            FROM Document_Checklist_Matrix__c 
                            Where Program_Name__c =: program.Program_Name__c AND Application_TYpe__c =: AUAppReq.Application_Type__c]; 
                            
            if(docChkList != null && !docChkList.isEmpty()) {
                isDocumentChecklistPresent = true;
            }
        //}

        //Redirect to Credit Application VF page
        PageReference pageRef = new PageReference('/apex/EMAP_CreditApplication_Page');
        return pageRef;
    }

    /**This method is used to save data filled in Credit Application form
    *If any insertion fails while processing form, we are doing roll back of entire transaction in catch block
    */
    public pageReference SaveRecords() {
        
        Savepoint sp = Database.setSavepoint();
        Bank_Reference__c bankRefDummy = new Bank_Reference__c ();
        Trade_Reference__c tradeRefDummy1 = new Trade_Reference__c ();
        Trade_Reference__c tradeRefDummy2 = new Trade_Reference__c ();
        try{
            Account parentAcc = null;
            
            if(AUAppReq.Account_Parent_Account__c != null){
                parentAcc = [Select Id, Name, Program__r.Name From Account Where id =: AUAppReq.Account_Parent_Account__c Limit 1];
            }

            if(parentAcc != null && program.Program_Name__c != parentAcc.Program__r.Name){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Parent Account: Please select Parent Account belonging to same program.'));
                return null;
            } else {
            
                String progName = program.Program_Name__c;
                Program__c prog = [Select id, name, Program_Name__c, CurrencyIsoCode From Program__c Where Program_Name__c =: progName Limit 1];
                
                //Account Record created here
                acc.name = AUAppReq.Account_Company_Name__c;
                if(AUAppReq.Account_Parent_Account__c != null){
                    acc.ParentId = AUAppReq.Account_Parent_Account__c;
                }
                acc.Program__c = prog.id;
                acc.CurrencyIsoCode = prog.CurrencyIsoCode;
                acc.Card_Pin__c = AUAppReq.Card_Pin__c;
                insert acc;
                           
                //Contact record created here
                contact.accountId = acc.Id;
                contact.Primary__c = true;
                insert contact;
                
                if(isSamePhysicalAddress){
                    AUAppReq.Account_Billing_Street__c = AUAppReq.Account_Shipping_Street__c;
                    AUAppReq.Account_Billing_City__c = AUAppReq.Account_Shipping_City__c;
                    AUAppReq.Account_Billing_Country__c = AUAppReq.Account_Shipping_Country__c;
                    AUAppReq.Account_Billing_State__c = AUAppReq.Account_Shipping_State__c;
                    AUAppReq.Account_Billing_Zip_Code__c = AUAppReq.Account_Shipping_Zip_Code__c;
                }
                
                AUAppReq.Account__c = acc.id;
                AUAppReq.Account_Cycle__c = AUAppReq.Account_Billing_Frequency__c;
                AUAppReq.CurrencyIsoCode = prog.CurrencyIsoCode;
                AUAppReq.Primary_Contact__c = contact.id;
                //AUAppReq.Contact_Title__c = contact.Title;
                AUAppReq.Contact_Type__c = contact.Contact_Type__c;
                AUAppReq.Primary_Contact_Salutation__c = contact.Salutation;
                //AUAppReq.Primary_Contact_First_Name__c = contact.FirstName;
                AUAppReq.Primary_Contact_Last_Name__c = contact.LastName;
                AUAppReq.Contact_Phone_Number__c = contact.Phone;
                AUAppReq.Primary_Contact_Mobile_Number__c = contact.MobilePhone;
                AUAppReq.Primary_Contact_Mobile_Phone2__c = contact.OtherPhone;
                AUAppReq.Contact_Email__c = contact.Email;
                AUAppReq.Contact_Fax__c = contact.Fax;
                AUAppReq.Application_Status__c = 'RPS Pending';
                AUAppReq.Program__c = prog.id;
                
                Boolean isDummyBankRef = false;
                //If any of the bank details entered then we create actual bank reference record
                if((bankRef.Name != null && bankRef.Name != '') || 
                    (bankRef.Bank_Account_Type__c != null && bankRef.Bank_Account_Type__c != '') || 
                    (bankRef.Bank_Account_Number__c != null && bankRef.Bank_Account_Number__c != '') || 
                    (bankRef.Bank_Date_Open__c != null) || 
                    (bankRef.Mailing_Address__c != null && bankRef.Mailing_Address__c != '') || 
                    (bankRef.Bank_Phone__c != null && bankRef.Bank_Phone__c != '') || 
                    (bankRef.Bank_Fax__c != null && bankRef.Bank_Fax__c != '') ||
                    (bankRef.Bank_Payment_History__c != null && bankRef.Bank_Payment_History__c != ''))
                {
                    //Actual Bank Reference created here
                    bankRef.Account__c = acc.id;
                    isDummyBankRef = false;
                    insert bankRef;
                    
                    //Setting Bank Ref details on AU App Req bank ref fields
                    AUAppReq.Bank_Reference__c = bankRef.id;
                    AUAppReq.Bank_Name__c = bankRef.Name;
                    AUAppReq.Bank_Account_Type__c = bankRef.Bank_Account_Type__c;
                    AUAppReq.Bank_Account_Number__c = bankRef.Bank_Account_Number__c;
                    AUAppReq.Date_Open__c = bankRef.Bank_Date_Open__c;
                    AUAppReq.Mailing_Address__c = bankRef.Mailing_Address__c;
                    AUAppReq.Bank_Contact_Phone__c = bankRef.Bank_Phone__c;
                    AUAppReq.Bank_Contact_Fax__c = bankRef.Bank_Fax__c;
                    AUAppReq.Bank_Payment_History__c = bankRef.Bank_Payment_History__c;
                } 
                //If none of the bank details entered then we create dummy bank reference record
                else {
                    //Dummy Bank Ref created here
                    bankRefDummy.Name = 'No Bank Reference';
                    bankRefDummy.Account__c = acc.id;
                    isDummyBankRef = true;
                    insert bankRefDummy;
                    
                    AUAppReq.Bank_Reference__c = bankRefDummy.id;
                }
                
                Boolean isDummyTradeRef1 = false;
                //If any of the Trade reference 1 details entered then we create actual trade reference 1 record
                if((tradeRef1.Name != null && tradeRef1.Name != '') || 
                    (tradeRef1.Trade_Account_Number__c != null && tradeRef1.Trade_Account_Number__c != '') || 
                    (tradeRef1.Trade_Supplier_Type__c != null && tradeRef1.Trade_Supplier_Type__c != '') || 
                    (tradeRef1.Trade_Date_Open__c != null) || 
                    (tradeRef1.Street_Address__c != null && tradeRef1.Street_Address__c != '') || 
                    (tradeRef1.Trade_Phone__c != null && tradeRef1.Trade_Phone__c != '') || 
                    (tradeRef1.Trade_Fax__c != null && tradeRef1.Trade_Fax__c != '') || 
                    (tradeRef1.Trade_Payment_History__c != null && tradeRef1.Trade_Payment_History__c != ''))
                {
                    //Actual Trade ref1 created here
                    //tradeRef1.Name = tradeRef1.Trade_Contact_Name__c;
                    tradeRef1.Account__c = acc.id;
                    isDummyTradeRef1 = false;
                    insert tradeRef1;
                    
                    //setting Trade Ref1 details on AU App Req's trade ref1 fields
                    AUAppReq.Trade_Reference__c = tradeRef1.id;
                    AUAppReq.Trade_Contact_Name__c = tradeRef1.Name;
                    AUAppReq.Trade_Account_Number__c = tradeRef1.Trade_Account_Number__c;
                    AUAppReq.Trade_Supplier_Type__c = tradeRef1.Trade_Supplier_Type__c;
                    AUAppReq.Trade_Date_Open__c = tradeRef1.Trade_Date_Open__c;
                    AUAppReq.Street_Address__c = tradeRef1.Street_Address__c;
                    AUAppReq.Trade_Contact_Phone__c = tradeRef1.Trade_Phone__c;
                    AUAppReq.Trade_Contact_Fax__c = tradeRef1.Trade_Fax__c;
                    AUAppReq.Trade_Payment_History__c = tradeRef1.Trade_Payment_History__c;
                } 
                //If none of the Trade reference 1 details entered then we create dummy trade reference 1 record
                else {
                    //Dummy Trade ref1 created here
                    tradeRefDummy1.Name = 'No Trade Reference';
                    tradeRefDummy1.Account__c = acc.id;
                    isDummyTradeRef1 = true;
                    insert tradeRefDummy1;
                    
                    AUAppReq.Trade_Reference__c = tradeRefDummy1.id;
                }
                
                Boolean isDummyTradeRef2 = false;
                //If any of the Trade reference 2 details entered then we create actual trade reference 2 record
                if((tradeRef2.Name != null && tradeRef2.Name != '') || 
                    (tradeRef2.Trade_Account_Number__c != null && tradeRef2.Trade_Account_Number__c != '') || 
                    (tradeRef2.Trade_Supplier_Type__c != null && tradeRef2.Trade_Supplier_Type__c != '') || 
                    (tradeRef2.Trade_Date_Open__c != null) || 
                    (tradeRef2.Street_Address__c != null && tradeRef2.Street_Address__c != '') || 
                    (tradeRef2.Trade_Phone__c != null && tradeRef2.Trade_Phone__c != '') || 
                    (tradeRef2.Trade_Fax__c != null && tradeRef2.Trade_Fax__c != '') || 
                    (tradeRef2.Trade_Payment_History__c != null && tradeRef2.Trade_Payment_History__c != ''))
                {
                    //Actual Trade ref2 created here
                    //tradeRef2.Name = tradeRef2.Trade_Contact_Name__c;
                    tradeRef2.Account__c = acc.id;
                    isDummyTradeRef2 = false;
                    insert tradeRef2;
                    
                    //setting Trade Ref2 details on AU App Req's trade ref2 fields
                    AUAppReq.Trade_Reference1__c = tradeRef2.id;
                    AUAppReq.Trade_Contact_Name1__c = tradeRef2.Name;
                    AUAppReq.Trade_Account_Number1__c = tradeRef2.Trade_Account_Number__c;
                    AUAppReq.Trade_Supplier_Type1__c = tradeRef2.Trade_Supplier_Type__c;
                    AUAppReq.Trade_Date_Open1__c = tradeRef2.Trade_Date_Open__c;
                    AUAppReq.Street_Address1__c = tradeRef2.Street_Address__c;
                    AUAppReq.Trade_Contact_Phone1__c = tradeRef2.Trade_Phone__c;
                    AUAppReq.Trade_Contact_Fax1__c = tradeRef2.Trade_Fax__c;
                    AUAppReq.Trade_Payment_History1__c = tradeRef2.Trade_Payment_History__c;
                } 
                //If none of the Trade reference 2 details entered then we create dummy trade reference 2 record
                else {
                    //Dummy Trade ref1 created here
                    tradeRefDummy2.Name = 'No Trade Reference';
                    tradeRefDummy2.Account__c = acc.id;
                    isDummyTradeRef2 = true;
                    insert tradeRefDummy2;
                    
                    AUAppReq.Trade_Reference1__c = tradeRefDummy2.id;
                }
    
                insert AUAppReq;
                
                //Updating AU App Req id on Bank Ref
                if(isDummyBankRef){
                    bankRefDummy.AU_Application_Request__c = AUAppReq.id;
                    update bankRefDummy;
                } else {
                    bankRef.AU_Application_Request__c = AUAppReq.id;
                    update bankRef;
                }
                
                //Updating AU App Req id on Trade Ref1
                if(isDummyTradeRef1){
                     tradeRefDummy1.AU_Application_Request__c = AUAppReq.id;
                     update tradeRefDummy1;
                } else {
                    tradeRef1.AU_Application_Request__c = AUAppReq.id;
                    update tradeRef1;
                }
                
                //Updating AU App Req id on Trade Ref2
                if(isDummyTradeRef2){
                     tradeRefDummy2.AU_Application_Request__c = AUAppReq.id;
                     update tradeRefDummy2;
                } else {
                    tradeRef2.AU_Application_Request__c = AUAppReq.id;
                    update tradeRef2;
                }
                
                //Updating Primary Contact id and AU App Req id on Account
                //acc.Primary_Contact__c = contact.id;   
                //acc.AU_Application_Request__c = AUAppReq.id;
                //update acc;
                
                /*
                //if total security value on AU App Req > 0, then only we are creating dummy Credit Security record
                if(AUAppReq.Total_Security_Value__c != null || AUAppReq.Total_Security_Value__c > 0){
                    Credit_Security__c credSecurity = new Credit_Security__c();
                    credSecurity.name = 'AU Application Request Credit Security';
                    credSecurity.Account__c = acc.id;
                    credSecurity.Status__c = 'Active';
                    credSecurity.Security_Value__c = AUAppReq.Total_Security_Value__c;
                    credSecurity.CurrencyIsoCode = prog.CurrencyIsoCode;
                    insert credSecurity ;
                }
                */
                            
                PageReference pageRef = new PageReference('/'+AUAppReq.id);
                return pageRef;
            }     
        } catch(exception ex){
            System.debug('Record insertion failed::-'+ex.getMessage());
            ApexPages.addMessages(ex);
            
            //If any insertion fails while processing form, we are doing roll back of entire transaction
            //Errors like Required field check, validation rule defined on object
            Database.rollback(sp);
            acc = acc.clone(false);
            contact = contact.clone(false);
            AUAppReq = AUAppReq.clone(false);
            bankRef = bankRef.clone(false);
            bankRefDummy = bankRefDummy.clone(false);
            tradeRef1 = tradeRef1.clone(false);
            tradeRefDummy1 = tradeRefDummy1.clone(false);
            tradeRef2 = tradeRef2.clone(false);
            tradeRefDummy2 = tradeRefDummy2.clone(false);

            return null;
        }
    }
    
    //This method is used on DupeCheck VF page, used to clear duplicate check result and input fields
    public pageReference clearPage(){
        displayPopUp = false;
        
        return null;
    }
    
    /** This method used to get Record TYpe info defined in different objects
    * it takes 2 parameters: Object Name and Record Type Name
    */
    public Static Schema.RecordTypeInfo getRecordTypeInfo(String objectName, String recordTypeName){
                
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