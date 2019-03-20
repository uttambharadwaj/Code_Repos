/**
* This class is used as a Trigger Handler for trigger on AU App Req object having 'EMAP Application Request' record type
* It includes all methods to be executed on before and after events
*/
public with sharing class EMAP_AUAppReq_TriggerHandler{

    public static final Map<String, Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
    public static Boolean AUAppAccUpdateflag = false;
    public static Schema.RecordTypeInfo appReqRecType = getRecordTypeInfo('AU_Application_Request__c', 'EMAP Application Request');
    public static Schema.RecordTypeInfo accountRecType = getRecordTypeInfo('Account', 'EMAP Fuel Accounts');

    /* used to lock EMAP AU App Req record when Application_Status is Fulfilled for all users (except System Administrator)
    *  Parameters: Map of old AU App Req records and List of new AU App Req records
    */
    public static void lockAUAppReqRecord(List<AU_Application_Request__c> AUAppReqOldList, Map<Id, AU_Application_Request__c> AUAppReqNewMap){
        Profile profile = [Select id, name From Profile Where id=: UserInfo.getProfileId()];
        
        if(profile.name != 'System Administrator' && profile.name != 'AU System Administrator'){
            for(AU_Application_Request__c AUAppReqOld: AUAppReqOldList){
                AU_Application_Request__c AUAppReqNew = AUAppReqNewMap.get(AUAppReqOld.id);
                if(AUAppReqOld.recordTypeId == appReqRecType.getRecordTypeId() && AUAppReqOld.Application_Status__c == 'Fulfilled'){
                      AUAppReqNew.addError('Application status is ' + AUAppReqOld.Application_Status__c + '.So record is locked. Please contact your System Administrator.');
                }
            }
        }        
    }
    
    /* used to calculate Total business days taken to credit assessment
    *  Parameters: List of new AU App Req records
    */
    public static void updateTotalTimeToAssess(List<AU_Application_Request__c> AUAppReqOldList, Map<Id, AU_Application_Request__c> AUAppReqNewMap){
        for(AU_Application_Request__c AUAppReqOld: AUAppReqOldList){
            
            AU_Application_Request__c AUAppReqNew = AUAppReqNewMap.get(AUAppReqOld.id);
            if(AUAppReqOld.Application_Status__c == 'Credit Assessment' && AUAppReqNew.Application_Status__c != 'Credit Assessment' ){

                if(AUAppReqNew.Assess_Start_Time__c != null && AUAppReqNew.Assess_End_Time__c != null && 
                    AUAppReqNew.Assess_End_Time__c >= AUAppReqNew.Assess_Start_Time__c){
                        //Default Total time to Assess to 0, if it is null 
                        if(AUAppReqNew.Total_time_to_Assess__c == null){
                            AUAppReqNew.Total_time_to_Assess__c = 0;
                        }
                        //calculate difference in business days
                        Integer dateDiff = EMAP_DateTime_Handler.getDiffBusinessDays((AUAppReqNew.Assess_Start_Time__c).Date(), (AUAppReqNew.Assess_End_Time__c).Date());
                        
                        AUAppReqNew.Total_time_to_Assess__c += dateDiff;
                        //(AUAppReqNew.Assess_Start_Time__c).Date().daysBetween((AUAppReqNew.Assess_End_Time__c).Date());
                }
            }
        }
    }
        
    /* used to restrict parent account from diff program
    *  Parameters: List of new AU App Req records
    */
    public static void ParentAccLookupFilter(List<AU_Application_Request__c> AUAppReqNewList){
        for(AU_Application_Request__c appReq: AUAppReqNewList){

            if(appReq.Account_Parent_Account__c!= null && appReq.Program__c != appReq.Parent_Account_Program__c){
                appReq.addError('Parent Account: Please select Parent Account belonging to same program.');
            }
        }    
    }

    /* used to update EMAP AU App Req record currency with program currency
    *  Parameters: List of new AU App Req records
    */    
    public static void updateCurrency(List<AU_Application_Request__c> AUAppReqNewList){
    
        List<Id> AUAppReqIds = new List<Id>();
        Map<Id, AU_Application_Request__c> AUAppReqMap = new Map<Id, AU_Application_Request__c>();
        for(AU_Application_Request__c AUAppReqNewRec: AUAppReqNewList){
            //only 'EMAP Application Request' records
            if(AUAppReqNewRec.recordTypeId == appReqRecType.getRecordTypeId()){
                AUAppReqIds.add(AUAppReqNewRec.id);
                AUAppReqMap.put(AUAppReqNewRec.id, AUAppReqNewRec);
            }
        }
        
        if(AUAppReqIds.size() > 0){
            List<AU_Application_Request__c> AUAppReqList = 
                [Select Id, Name, Account__r.Program_Currency__c From AU_Application_Request__c Where Id IN: AUAppReqIds ];
                
            for(AU_Application_Request__c AUAppReqRec: AUAppReqList ){
                String programCurrency = AUAppReqRec.Account__r.Program_Currency__c;
                
                AU_Application_Request__c AUAppReqRecTemp = AUAppReqMap.get(AUAppReqRec.Id);
                AUAppReqRecTemp.CurrencyIsoCode = programCurrency;
            }       
        }

    }

    /* used to update primary contact details on EMAP AU App Req (only on change of Primary contact)
    *  Parameters: Map of old AU App Req records and List of new AU App Req records
    */
    public static void updateAUPrimaryContact(Map<Id, AU_Application_Request__c> AUAppReqOldMap, List<AU_Application_Request__c> AUAppReqNewList){
        List<Id> primaryContIds = new List<Id>();
        for(AU_Application_Request__c AUAppReqNewRec: AUAppReqNewList){
            //get AU App Req old record
            AU_Application_Request__c AUAppReqOldRec = AUAppReqOldMap.get(AUAppReqNewRec.id);
            
            //only 'EMAP Application Request' records
            if(AUAppReqNewRec.recordTypeId == appReqRecType.getRecordTypeId() && 
                AUAppReqOldRec.Primary_Contact__c != AUAppReqNewRec.Primary_Contact__c){
                
                primaryContIds.add(AUAppReqNewRec.Primary_Contact__c);
            }
        }
        
        if(primaryContIds != null && primaryContIds.size() > 0){
            List<Contact> contList = [Select id, Title, Contact_Type__c, Salutation, Email, Fax, FirstName, LastName, MobilePhone, OtherPhone, Phone
                                      From Contact Where id IN: primaryContIds];
            
            if(contList != null && contList.size() > 0){
                Map<Id, Contact> contMap = new Map<Id, Contact>();
                for(Contact cont: contList){
                    contMap.put(cont.id, cont);
                }
                for(AU_Application_Request__c AUAppReq: AUAppReqNewList){
                    Contact contTemp = contMap.get(AUAppReq.Primary_Contact__c);
                    AUAppReq.Contact_Title__c = contTemp.Title;
                    AUAppReq.Primary_Contact_Salutation__c = contTemp.Salutation;
                    AUAppReq.Contact_Type__c = contTemp.Contact_Type__c;
                    AUAppReq.Contact_Email__c = contTemp.Email;
                    AUAppReq.Contact_Fax__c = contTemp.Fax;
                    AUAppReq.Primary_Contact_First_Name__c = contTemp.FirstName;
                    AUAppReq.Primary_Contact_Last_Name__c = contTemp.LastName;
                    AUAppReq.Primary_Contact_Mobile_Number__c = contTemp.MobilePhone;
                    AUAppReq.Primary_Contact_Mobile_Phone2__c = contTemp.OtherPhone;
                    AUAppReq.Contact_Phone_Number__c = contTemp.Phone;              
                }
            }
        }
    }

    /* used to maintain EMAP AU App Req's Application status old value in Revert to Status Field, once new application status is Hold
    *  Parameters: Map of old AU App Req records and List of new AU App Req records
    */
    public static void Update_RevertToStatus(Map<Id, AU_Application_Request__c> AUAppReqOldMap, List<AU_Application_Request__c> AUAppReqNewList){
        for(AU_Application_Request__c AUAppReqNew: AUAppReqNewList){
            //only 'EMAP Application Request' records
            if(AUAppReqNew.recordTypeId == appReqRecType.getRecordTypeId()){
            
                //get AU App Req old record
                AU_Application_Request__c AUAppReqOld = AUAppReqOldMap.get(AUAppReqNew.id);
                    
                if(AUAppReqNew.Application_Status__c == 'Hold' && 
                    (AUAppReqNew.Revert_To_Status__c == null || AUAppReqNew.Revert_To_Status__c == '')){
                    
                    if(AUAppReqOld.Application_Status__c != AUAppReqNew.Application_Status__c){
                        AUAppReqNew.Revert_To_Status__c = AUAppReqOld.Application_Status__c;
                    }
                } else if((AUAppReqNew.Revert_To_Status__c != null) && (AUAppReqNew.Hold_Expiration_Date__c < System.today())){
                    AUAppReqNew.Application_Status__c = AUAppReqNew.Revert_To_Status__c;
                    AUAppReqNew.Revert_To_Status__c = null;
                    AUAppReqNew.Hold_Expiration_Date__c = null;
                } else if(AUAppReqOld.Application_Status__c == 'Hold'){
                    AUAppReqNew.Revert_To_Status__c = null;
                    AUAppReqNew.Hold_Expiration_Date__c = null;
                }
            }
        }
    }
   
    /* used to propagate EMAP AU App Req details to associated Account record
    *  Parameters: List of new AU App Req records
    */
   public static void propagateAUAppReqToAccount(List<AU_Application_Request__c> AUAppReqNewList){
        try{
            if(AUAppAccUpdateflag == false){
                System.debug('Inside propagateAUAppReqToAccount method');
                List<Id> accIds = new List<Id>();
                Map<Id, AU_Application_Request__c> AuAppReqMap = new Map<Id, AU_Application_Request__c>();
                
                for(AU_Application_Request__c AUAppReqNew: AUAppReqNewList){
                    //only 'EMAP Application Request' records
                    if(AUAppReqNew.recordTypeId == appReqRecType.getRecordTypeId() && AUAppReqNew.Account__c != null){
                        accIds.add(AUAppReqNew.Account__c);
                        AuAppReqMap.put(AUAppReqNew.Account__c, AUAppReqNew);
                    }
                }

                if(accIds != null && accIds.size() > 0){

                    List<Account> accList = [Select id, Name, ParentId, Company__c, Type, Behavioural_Score__c, Card_Pin__c, Direct_Debit__c, 
                            BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Billing_Frequency__c, Billing_Plan__c,
                            ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Electronic_Marketing_Flag__c, 
                            Business_Registration_Number__c, Security_Indicator__c, Class_of_Buyer__c, Credit_Plan__c, Speed_Pass__c, 
                            Customer_Type__c, AU_Date_Business_Commenced__c , Mail_Indicator__c, Embassy_Code__c, Industry, Client_Name__c, 
                            NumberOfEmployees, Preferred_Language__c, Phone, E_Business_OLS__c, AU_Business_Structure__c, Account_Cycle__c, 
                            Payment_Days__c, Payment_Method__c, Credit_Limit__c, Fax, AU_Marketing_Offers__c,  Business_Financial_Year_Month_End__c, 
                            Sales_Area_Administration__c, Sales_Area_Marketing__c, AU_Number_of_Cards__c, Primary_Contact__c, Risk_Grade__c 
                            From Account Where id IN: accIds];

                    if(accList != null && accList.size() > 0){
                        System.debug('####Inside AU App Req To Account Sync Trigger');
                        List<Account> accToBeUpdated = new List<Account>();
                        for(Account acc: accList){
                            AU_Application_Request__c AUAppReq = AuAppReqMap.get(acc.id);
                            acc.AU_Application_Request__c = AUAppReq.id;
                            acc.name = AUAppReq.Account_Company_Name__c;
                            acc.AU_Business_Structure__c = AUAppReq.Acc_Business_Structure__c;
                            acc.AU_Number_of_Cards__c = AUAppReq.Total_Card_Requested__c;
                            acc.ParentId = AUAppReq.Account_Parent_Account__c;
                            acc.Primary_Contact__c = AUAppReq.Primary_Contact__c;
                            acc.Phone = AUAppReq.Account_Phone__c;
                            acc.Card_Pin__c = AUAppReq.Card_Pin__c;
                            //Direct Debit Field added which will be used for applications and account to determine If the account is direct debit Yes or No.
                            acc.Direct_Debit__c = AUAppReq.Direct_Debit__c;
                            //acc.Company__c = AUAppReq.Account_Company_Name__c;
                            //acc.Company_Email_Address__c = AUAppReq.Account_Company_Email_Address__c;
                            acc.Electronic_Marketing_Flag__c = AUAppReq.Electronic_Marketing_Flag__c;
                            acc.AU_Marketing_Offers__c = AUAppReq.AU_Marketing_Offers__c;
                            acc.Preferred_Language__c = AUAppReq.Account_Preferred_Language__c;
                            acc.Type = AUAppReq.Application_Type__c;
                            //acc.Secondary_Mobile_Phone__c = AUAppReq.Account_Secondary_Mobile_Phone__c;
                            acc.E_Business_OLS__c = AUAppReq.E_Business_OLS__c;
                            acc.Payment_Days__c = AUAppReq.Account_Payment_Days__c;
                            acc.Payment_Method__c = AUAppReq.Account_Payment_Method__c;
                            acc.Credit_Limit__c = AUAppReq.Credit_Limit_Requested__c;
                            //acc.Tel_USD__c = AUAppReq.Account_Tel_USD__c;
                            acc.Account_Cycle__c = AUAppReq.Account_Cycle__c;
                            acc.Business_Financial_Year_Month_End__c = AUAppReq.Accnt_Business_Financial_Year_Month_End__c;
                            acc.Client_Name__c = AUAppReq.Client_Name__c;
                            acc.Sales_Area_Administration__c = AUAppReq.Account_Sales_Area_Administration__c;
                            acc.Sales_Area_Marketing__c = AUAppReq.Account_Sales_Area_Marketing__c;
                            acc.Speed_Pass__c = AUAppReq.Account_Speedpass_Key_Tag__c;
                            //acc.Behavioural_Score__c = AUAppReq.Account_Behavioural_Score__c;
                            acc.BillingStreet = AUAppReq.Account_Billing_Street__c;
                            acc.BillingCity = AUAppReq.Account_Billing_City__c;
                            acc.BillingState = AUAppReq.Account_Billing_State__c;
                            acc.BillingCountry = AUAppReq.Account_Billing_Country__c;
                            acc.BillingPostalCode = AUAppReq.Account_Billing_Zip_Code__c;
                            acc.ShippingStreet = AUAppReq.Account_Shipping_Street__c;
                            acc.ShippingCity = AUAppReq.Account_Shipping_City__c;
                            acc.ShippingState = AUAppReq.Account_Shipping_State__c;
                            acc.ShippingCountry = AUAppReq.Account_Shipping_Country__c;
                            acc.ShippingPostalCode = AUAppReq.Account_Shipping_Zip_Code__c;
                            acc.Billing_Frequency__c = AUAppReq.Account_Billing_Frequency__c;
                            acc.Billing_Plan__c = AUAppReq.Account_Billing_Plan__c;
                            acc.Business_Registration_Number__c = AUAppReq.Account_Business_Registration_Number__c;
                            acc.Security_Indicator__c = AUAppReq.Account_Security_Indicator__c;
                            acc.Class_of_Buyer__c = AUAppReq.Account_Class_of_Buyer__c;
                            acc.Credit_Plan__c = AUAppReq.Account_Credit_Plan__c;
                            acc.Customer_Type__c = AUAppReq.Account_Customer_Type__c;
                            acc.AU_Date_Business_Commenced__c= AUAppReq.Account_Date_Business_Started__c;
                            acc.Embassy_Code__c = AUAppReq.Account_Embassy_Code__c;
                            acc.Fax = AUAppReq.Account_Fax__c;
                            acc.Industry = AUAppReq.Account_Industry__c;
                            acc.Mail_Indicator__c = AUAppReq.Account_Mail_Indicator__c;
                            acc.Risk_Grade__c = AUAppReq.Application_Risk_Grade__c;
                            //acc.Mobile_Phone_Number__c = AUAppReq.Account_Mobile_Phone__c;
                            if(AUAppReq.Account_Number_of_Employees__c != null && AUAppReq.Account_Number_of_Employees__c != ''){
                                acc.NumberOfEmployees = Integer.valueOf(AUAppReq.Account_Number_of_Employees__c);
                            }

                            accToBeUpdated.add(acc);
                        }
                        
                        AUAppAccUpdateflag = true;
                        update accToBeUpdated;
                    }
                }
            }    
        } catch(Exception ex) {
            AUAppAccUpdateflag = false;
            System.debug('Trigger failed. Reason is::-'+ex.getMessage());
        }
    }

    /* used to propagate Account details to associated EMAP AU App Req record
    *  Parameters: List of new Account records
    */
    public static void populateAccToAuAppReq(list<Account> accNewList) {
        try{
            if(AUAppAccUpdateflag == false){
                System.debug('Inside populateAccToAuAppReq method');
                List<Id> AUAppReqIds = new List<Id>();
                Map<Id, Account> accMap = new Map<Id, Account>();
                
                for(Account accNew: accNewList){
                    //only 'EMAP Fuel Accounts' records
                    if(accNew.recordTypeId == accountRecType.getRecordTypeId() &&
                        accNew.AU_Application_Request__c != null){

                        AUAppReqIds.add(accNew.AU_Application_Request__c);
                        accMap.put(accNew.AU_Application_Request__c, accNew );
                    }
                }
                
                if(AUAppReqIds != null && AUAppReqIds.size() > 0){
                    List<AU_Application_Request__c> AUAppReqList = 
                        [Select id, Account_Parent_Account__c, Account_Company_Name__c, Total_Security_Value__c, Card_Pin__c, Direct_Debit__c, 
                            Application_Type__c, Account_Behavioural_Score__c, Account_Billing_Street__c, Account_Billing_City__c, Account_Billing_State__c, 
                            Account_Billing_Country__c, Account_Billing_Zip_Code__c, Account_Billing_Frequency__c, Total_Card_Requested__c, Primary_Contact__c, 
                            Account_Shipping_Street__c, Account_Shipping_City__c, Account_Shipping_State__c, Account_Shipping_Country__c, Account_Shipping_Zip_Code__c, 
                            Account_Billing_Plan__c, Account_Business_Registration_Number__c, Account_Security_Indicator__c, Application_Status__c, 
                            Account_Class_of_Buyer__c, Account_Credit_Plan__c, Account_Customer_Type__c, Account_Date_Business_Started__c, Electronic_Marketing_Flag__c, 
                            Account_Direct_Debit_Account_Number__c, Account_Direct_Debit_Bank_Name__c, Account_Speedpass_Key_Tag__c, Account_Direct_Debit_Bank_Account_Name__c, 
                            Account_Direct_Debit_Bank_Number__c, Account_Direct_Debit_Branch_Number__c, Account_Embassy_Code__c, Account_Fax__c, AU_Marketing_Offers__c, 
                            Account_Industry__c, Account_Mail_Indicator__c, Account_Number_of_Employees__c, Account_Preferred_Language__c, Application_Risk_Grade__c, 
                            Account_Phone__c, E_Business_OLS__c, Account_Payment_Days__c, Account_Payment_Method__c, Credit_Limit_Requested__c, Accnt_Business_Financial_Year_Month_End__c, 
                            Account_Cycle__c, Client_Name__c, Account_Sales_Area_Administration__c, Account_Sales_Area_Marketing__c, Card_Embossing_Form__c, Financial_Statement__c, 
                            Vehicle_Registration_Certificate__c, Direct_Debit_Authority__c, Proof_Of_Address__c, Staff_Id__c, Security_Document__c, Duty_Exemption_Letter__c, Credit_Bureau_Results__c, Letter_from_Government__c
                        From AU_Application_Request__c Where Id IN: AUAppReqIds];
        
                    if(AUAppReqList != null && AUAppReqList.size() > 0){

                        List<AU_Application_Request__c> AUAppReqToBeUpdated = new List<AU_Application_Request__c>();
                        System.debug('####Inside Account To AU App Req Sync Trigger');
                        for(AU_Application_Request__c AUAppReq: AUAppReqList){
                            //only when AU App Req Application_Status is not fulfilled
                            if(AUAppReq.Application_Status__c != 'Fulfilled'){
                                Account acc = accMap.get(AUAppReq.id);
                                
                                if(acc.IFCS__c != null && acc.IFCS__c != '' && AUAppReq.Application_Status__c == 'Sent To IFCS'){
                                    AUAppReq.Application_Status__c = 'Created in IFCS';
                                }
                                
                                AUAppReq.Account_Company_Name__c = acc.name;
                                AUAppReq.Primary_Contact__c = acc.Primary_Contact__c;
                                AUAppReq.Total_Card_Requested__c = acc.AU_Number_of_Cards__c;
                                AUAppReq.Account_Parent_Account__c = acc.ParentId;
                                //Direct Debit Field added which will be used for applications and account to determine If the account is direct debit Yes or No.
                                AUAppReq.Direct_Debit__c = acc.Direct_Debit__c;
                                //AUAppReq.Card_Pin__c = acc.Card_Pin__c;
                                //AUAppReq.Account_Company_Email_Address__c = acc.Company_Email_Address__c;
                                AUAppReq.Electronic_Marketing_Flag__c = acc.Electronic_Marketing_Flag__c;
                                AUAppReq.AU_Marketing_Offers__c = acc.AU_Marketing_Offers__c;
                                AUAppReq.Account_Preferred_Language__c = acc.Preferred_Language__c;
                                AUAppReq.Application_Type__c = acc.Type;
                                AUAppReq.Account_Phone__c =    acc.Phone;
                                //AUAppReq.Account_Secondary_Mobile_Phone__c = acc.Secondary_Mobile_Phone__c;
                                AUAppReq.E_Business_OLS__c = acc.E_Business_OLS__c;
                                AUAppReq.Account_Payment_Days__c = acc.Payment_Days__c;
                                //AUAppReq.Account_Tel_USD__c = acc.Tel_USD__c;
                                AUAppReq.Account_Cycle__c = acc.Account_Cycle__c;
                                AUAppReq.Accnt_Business_Financial_Year_Month_End__c = acc.Business_Financial_Year_Month_End__c;
                                AUAppReq.Client_Name__c = acc.Client_Name__c;
                                AUAppReq.Account_Sales_Area_Administration__c = acc.Sales_Area_Administration__c;
                                AUAppReq.Account_Sales_Area_Marketing__c = acc.Sales_Area_Marketing__c;
                                AUAppReq.Account_Speedpass_Key_Tag__c = acc.Speed_Pass__c;
                                AUAppReq.Total_Security_Value__c = acc.Total_Security_Value__c;
                                //AUAppReq.Account_Behavioural_Score__c = acc.Behavioural_Score__c;
                                AUAppReq.Account_Billing_Street__c = acc.BillingStreet;
                                AUAppReq.Account_Billing_City__c = acc.BillingCity;
                                AUAppReq.Account_Billing_State__c = acc.BillingState;
                                AUAppReq.Account_Billing_Country__c = acc.BillingCountry;
                                AUAppReq.Account_Billing_Zip_Code__c = acc.BillingPostalCode;
                                AUAppReq.Account_Billing_Frequency__c = acc.Billing_Frequency__c;
                                AUAppReq.Account_Shipping_Street__c = acc.ShippingStreet;
                                AUAppReq.Account_Shipping_City__c = acc.ShippingCity;
                                AUAppReq.Account_Shipping_State__c = acc.ShippingState;
                                AUAppReq.Account_Shipping_Country__c = acc.ShippingCountry;
                                AUAppReq.Account_Shipping_Zip_Code__c = acc.ShippingPostalCode;
                                AUAppReq.Account_Billing_Plan__c = acc.Billing_Plan__c;
                                AUAppReq.Account_Business_Registration_Number__c = acc.Business_Registration_Number__c;
                                AUAppReq.Account_Payment_Method__c = acc.Payment_Method__c;
                                AUAppReq.Credit_Limit_Requested__c = acc.Credit_Limit__c;
                                AUAppReq.Account_Security_Indicator__c = acc.Security_Indicator__c;
                                AUAppReq.Account_Class_of_Buyer__c = acc.Class_of_Buyer__c;
                                AUAppReq.Account_Credit_Plan__c = acc.Credit_Plan__c;
                                AUAppReq.Account_Customer_Type__c = acc.Customer_Type__c;
                                AUAppReq.Account_Date_Business_Started__c = acc.AU_Date_Business_Commenced__c;
                                AUAppReq.Account_Embassy_Code__c = acc.Embassy_Code__c;
                                AUAppReq.Account_Fax__c = acc.Fax;
                                AUAppReq.Account_Industry__c = acc.Industry;
                                AUAppReq.Account_Mail_Indicator__c = acc.Mail_Indicator__c;
                                //AUAppReq.Account_Mobile_Phone__c = acc.Mobile_Phone_Number__c;
                                AUAppReq.Application_Risk_Grade__c = acc.Risk_Grade__c;
                                if(acc.NumberOfEmployees != null && acc.NumberOfEmployees > 0){
                                    AUAppReq.Account_Number_of_Employees__c = String.valueOf(acc.NumberOfEmployees);
                                }
/*                                
                                AUAppReq.Card_Embossing_Form__c = acc.Card_Embossing_Form__c;
                                AUAppReq.Financial_Statement__c = acc.Financial_Statement__c;
                                AUAppReq.Vehicle_Registration_Certificate__c = acc.Vehicle_Registration_Certificate__c;
                                AUAppReq.Direct_Debit_Authority__c = acc.Direct_Debit_Authority__c;
                                AUAppReq.Proof_Of_Address__c = acc.Proof_Of_Address__c;
                                AUAppReq.Staff_Id__c = acc.Staff_Id__c;
                                AUAppReq.Security_Document__c = acc.Security_Document__c;
                                AUAppReq.Duty_Exemption_Letter__c = acc.Duty_Exemption_Letter__c;
                                AUAppReq.Credit_Bureau_Results__c =acc.Credit_Bureau_Results__c;
                                AUAppReq.Letter_from_Government__c = acc.Letter_from_Government__c;                
*/                                
                                AUAppReqToBeUpdated.add(AUAppReq);
                            }
                        }
                    
                        AUAppAccUpdateflag = true;
                        update AUAppReqToBeUpdated;
                    }
                }
            }
        } catch(Exception ex) {
            AUAppAccUpdateflag = false;
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