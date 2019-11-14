/**
* Forseva online application code.
*/
/* ************************************************************
 * Created By  : GearsCRM
 * Created Date: 4/1/2013 
 * Description :  Class  OnlineApplication
 *
 * Modified By   : Raja Yeccherla(GearsCRM)  
 * Modified Date : 12/2/2015 
 * Description   : StageName changed from 'BSA Received' to '5) Signed'  
 *
 * Modified By   :  
 * Modified Date :   
 * Description   :
 * ************************************************************
 */
public without sharing class OnlineApplication {

    //-----------------
    // public constants
    //-----------------
    
    // NOTE: These must remain in synch with picklist values where relevant
    
    // url parameters
    public final static String APPLICATION_KEY = 'ak';
    public final static String LOCAL = 'Local';
    public final static String OTR = 'OTR';
    public final static String MASTERCARD = 'MasterCard';
    public final static String OFFER = 'offer';
    public final static String NO_FRAME = 'noFrame';
    public final static string TRADECREDIT = 'TradeCredit';  
    
    // type of business value
    public final static String OTHER = 'Other';
     
    // (some) application status values
    public final static String PREFILL_IN_PROGRESS = 'Prefill in Progress';
    public final static String INCOMPLETE = 'App-Incomplete';//Modified on 15th july for case:00022569
    public final static String INCOMPLETE_SAVED = 'Saved-Incomplete';//Modified on 15th july for case:00022569
    public final static String ABANDONED = 'Abandoned';  // no longer used
    public final static String SAVED = 'Saved-Complete';//Modified on 15th july for case:00022569
    public final static String APPROVED = 'Approved';
    public final static String DECLINED = 'Declined';  // no longer used
    public final static String SETUP_COMPLETE = 'Setup Complete';
    public final static String MANUAL_REVIEW = 'Manual Review';
    
    // invoice/statement delivery method values
    public final static String EMAIL = 'Email';
    public final static String FAX = 'Fax';
    public final static String INTERNET = 'Internet';
    public final static String MAIL = 'Mail';
    
    // billing cycle values
    public final static String WEEKLY_7 = 'Weekly - 7-Day Terms';    
    public final static String WEEKLY_14 = 'Weekly - 14-Day Terms';
    public final static String BIWEEKLY_7 = 'Bi-Weekly - 7-Day Terms';
    public final static String MONTHLY = 'Monthly - 14-Day Terms';
    public final static String DAILY = 'Daily - 7-Day Terms';
    public final static String PREPAY = 'Prepay';
    
    // (some/partial) payment method values
    public final static String AUTO_PAY = 'Auto Pay (ACH)';
    public final static String INTERNET_PAY = 'Internet Pay';
    public final static String ELECTRONICHEK = 'ElectroniChek';
    public final static String MAILED_CHECK = 'Mailed Check';
    public final static String WIRE = 'Wire';
    
    // data entry stage values
    public final static String COMPANY_INFORMATION_COMPLETE = 'Company Information Complete';
    public final static String ACCOUNT_SETUP_COMPLETE = 'Account Setup Complete';
    public final static String CARD_SETUP_COMPLETE = 'Card Setup Complete';
    public final static String REVIEW_COMPLETE = 'Review Complete';
    
    // eSignature status values
    public final static String NOT_EXECUTED = 'Not Executed';
    public final static String EXECUTED = 'Executed';
    public final static String EXECUTED_AND_RECEIVED = 'Executed and Received';
    public final static String EXECUTED_AND_INVALID_SIGNER = 'Executed and Invalid Signer';
    
    // (some) lead source subtype values
    public final static String MAGAZINE_AD = 'Magazine Ad';
    public final static String TRADESHOW = 'Tradeshow';
    public final static String REFERRAL = 'Referral';
    
    // OTR and Local fuel choices -- needed because we don't want the hated 'None' in the DDLB if we use inputField tag
    public final static String DIESEL = 'Diesel';
    public final static String DIESEL_AND_GASOLINE = 'Diesel and Gasoline';
    public final static String UNLEADED = 'Unleaded'; 
    public final static String UNLEADED_MID = 'Unleaded - Mid';
    public final static String UNLEADED_PREM = 'Unleaded - Prem';
    public final static String ALL = 'All';    
    
    // OTR offer Other Services that should only be visible for >50 number of trucks
    public final static String OTH_SVC_1 = 'Bulk Fuel Management'; 
    public final static String OTH_SVC_2 = 'Retail Fuel Management';
    public final static String OTH_SVC_3 = 'Bridgestone Tire Program';
    
    //----------------------
    // public static methods
    //----------------------

    // takes leads, converts to account/contact/oppo, and then creates eApps and sends out eApp emails!
    @future
    public static void processLeads(List<Id> leadIdList, List<Id> cardProgramIdList) {
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! processLeads called ');
        // stage reference data

        Map<Id,Id> leadProgramMap = new Map<Id,Id>();
        Map<Id,OnlineApplicationOffer__c> programOfferMap = new Map<Id,OnlineApplicationOffer__c>(); 

        for(Integer i = 0; i < leadIdList.size(); i++) {
            leadProgramMap.put(leadIdList[i],cardProgramIdList[i]);
        }                
        for(OnlineApplicationOffer__c oao : [select Id, Auto_Creation_Email_Template__c, Card_Program__c
                                             from   OnlineApplicationOffer__c
                                             where  Card_Program__c != null 
                                             and    Card_Program__c in :cardProgramIdList]) {
            programOfferMap.put(oao.Card_Program__c, oao);                                     
        }

        // perform selective lead conversion
                                                           
        LeadStatus lStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true order by SortOrder DESC LIMIT 1];        
        List<Database.LeadConvert> lcList = new List<Database.LeadConvert>();
        
        for(Id leadId : leadIdList) {           
            if(programOfferMap.containsKey(leadProgramMap.get(leadId))) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadId);
                lc.setConvertedStatus(lStatus.MasterLabel);
                lcList.add(lc);
            }
        }

        List<Database.LeadConvertResult> lcrList = Database.convertLead(lcList,false);
        
        // create eApps and send emails
        
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! lcrList ' + lcrList);
        
        for(Database.LeadConvertResult lcr : lcrList) {
            if(lcr.isSuccess() && lcr.getAccountId() != null && lcr.getContactId() != null && lcr.getOpportunityId() != null) {
                OnlineApplication oa = convertAccountContactOpportunityToApplication(lcr.getAccountId(), 
                                                                                     lcr.getContactId(), 
                                                                                     lcr.getOpportunityId(), 
                                                                                     programOfferMap.get(leadProgramMap.get(lcr.getLeadId())).Id);
                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! oa bf : ' +  oa);
                oa.sendWeb2LeadEmail(lcr.getContactId());                                                                                     
            }
            else {
                System.debug('ERROR CONVERTING LEAD:' + lcr.getErrors());
            }
        }    
    }

    public static OnlineApplication convertAccountContactOpportunityToApplication(Id accountId, Id contactId, Id oppoId, Id offerId) {
    
        OnlineApplication__c oa = new OnlineApplication__c();
        
        Account a = (Account)SOUtility.getCompleteSObject(Account.SObjectType, accountId);
        Contact c = (Contact)SOUtility.getCompleteSObject(Contact.SObjectType, contactId);        
        Opportunity o = (Opportunity)SOUtility.getCompleteSObject(Opportunity.SObjectType, oppoId);
        OnlineApplicationOffer__c off = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, offerId);

        //oa.ABA_Routing_Number__c
        oa.Account__c = a.Id;
        oa.AO_Address__c = c.MailingStreet;
        oa.AO_City__c = c.MailingCity;
        oa.AO_Confirm_Social_Security_Number__c = c.Social_Security_Number__c;
        oa.AO_Date_of_Birth__c = c.Birthdate;
        oa.AO_Home_Phone_Number__c = c.HomePhone;
        oa.AO_Name__c = c.FirstName + ' ' + c.LastName;
        oa.AO_Social_Security_Number__c = c.Social_Security_Number__c;
        oa.AO_State__c = c.MailingState;
        oa.AO_Title__c = c.Title;
        oa.AO_Work_Email__c = c.Email;
        oa.AO_Zip_Code__c = c.MailingPostalCode;
        oa.Application_Key__c = String.valueOf(Math.abs(Crypto.getRandomLong()));
        oa.Application_Title__c = off.Application_Title__c;
        oa.Billing_Cycle__c = off.Billing_Cycle__c;
        //oa.Branch_Address__c
        //oa.Branch_City__c
        //oa.Branch_Phone_Number__c
        //oa.Branch_State__c
        //oa.Branch_Zip_Code__c
        //oa.Business_Description__c
        //oa.Business_Street_Address__c
        //oa.Card_Setup_Bypassed__c
        //oa.Cell_Number__c
        //oa.Change_to_Authorizing_Officer_Address__c
        //oa.Checking_Account_Number__c 
        //oa.City__c
        //oa.Confirm_ABA_Routing_Number__c
        //oa.Confirm_Checking_Account_Number__c
        
        
        // Added by Trekbin : 21 July
        String strFirst_LastName = c.FirstName + ' ' + c.LastName;
        
        String rep_name = strFirst_LastName.substring(0, Math.min(79, strFirst_LastName.length()));
        List<String> elems = rep_name.split(' ');
        rep_name = '';
        for (String x : elems) {
            
            x = x.trim();
            x = x.replaceAll('(\\s+)', ' ');
        
            if(x.length() == 1) {
                
                rep_name += x.toUpperCase()+ ' ';
            }
            else if(x.length() > 1){
                
                rep_name += x.substring(0,1).toUpperCase()+x.substring(1,x.length()) + ' ';
            }    
        }
        
        
        oa.Contact_Name__c = rep_name; // Need to modify here
        //oa.Credit_Line_Requested__c
        oa.CurrencyIsoCode = a.CurrencyIsoCode;
        //oa.Data_Entry_Stage__c = MUST SET
        oa.Day_of_Payment__c = OnlineApplication.DAILY == off.Billing_Cycle__c ? 'Tuesday' : null;
        //oa.DUNS__c
        oa.Email__c = c.Email;
        oa.Email_Template_Id__c = off.Auto_Creation_Email_Template__c; 
        //oa.Embossing_Line_1_Company_Name__c
        oa.eSignature_Status__c = OnlineApplication.NOT_EXECUTED;
        //oa.Fax_Number__c
        //oa.Federal_Tax_ID__c
        //oa.Financial_Institution__c
        oa.Fleet_One_Initiated_Application__c = false;
        oa.Hide_Card_Setup_Page__c = off.Hide_Card_Setup_Page__c;
        oa.How_Did_You_Hear_About_Us__c = off.Lead_Source__c;
        //oa.I_Have_Read_and_Agree__c
        //oa.Invoice_Delivery_Method__c
        //oa.Invoice_Delivery_Method_Email__c
        //oa.Invoice_Delivery_Method_Fax__c
        //oa.Lead__c
        //oa.Lead_Source_Subtype__c
        oa.Legal_Business_Name__c = a.Name.substring(0, Math.min(30, a.Name.length()));
        //oa.MC_FF_or_DOT__c
        //oa.Name_of_Parent_Company__c
        //oa.Number_of_Cards_Needed__c
        oa.Number_of_Drivers__c = a.Number_of_Tractors__c;
        //oa.Number_of_Employees__c
        //oa.Number_of_Trailers__c
        oa.Number_of_Trucks__c = a.Number_of_Tractors__c;
        oa.Number_of_Vehicles__c = a.Number_of_Other_Fuel_Vehicles__c;
        oa.Odometer__c = OnlineApplication.OTR == off.Product_Type__c ? true : false;
        oa.Offer__c = off.Id;
        oa.Opportunity__c = o.Id;
        //oa.Other_Services__c
        oa.Payment_Method__c = off.Payment_Method__c;
        oa.Phone_Number__c = a.Phone;
        oa.Product_Type__c = off.Product_Type__c;
        oa.Promotional_Code__c = off.Promotional_Code__c;
        //oa.Ship_Cards_To__c
        oa.Show_Card_Setup_Page__c = true;
        //oa.State__c
        oa.Status__c = OnlineApplication.INCOMPLETE;
        //oa.Terms_and_Conditions_Version__c
        //oa.Trade_Name__c
        //oa.Trip__c
        //oa.Type_of_Business__c
        //oa.Type_of_Business_Other__c
        //oa.Unit__c
        //oa.Validation_Rule_Test__c
        //oa.Year_Established__c
        //oa.Zip_Code__c
        oa.OwnerId = o.OwnerId;

        insert oa;
        oa.External_Application_URL__c = OnlineApplicationParameters.getApplicationBaseUrl() + 
                                         'ApplicationCompanyInformation?id=' + oa.Id + '&' +
                                         APPLICATION_KEY + '=' + oa.Application_Key__c + '&' +
                                         NO_FRAME + '=true';
        
        OnlineApplication eApp = new OnlineApplication(oa);
        eApp.saveApplication();
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! eApp : ' + eApp);
        return eApp;
    }

    //----------------------
    // public methods
    //----------------------

    public OnlineApplication(OnlineApplication__c oa) {
        
        m_oa = oa;
        
        if(oa.Id != null) {
            m_authorizedContacts = [select    Id, Name, Email__c, Online_Application__c, Online_Password__c, Security_Code__c
                                    from      OnlineApplicationAuthorizedContact__c
                                    where     Online_Application__c = :oa.Id
                                    order by  CreatedDate];
                                    
            m_vehicleSetups = [select    Id, Name, Additives__c, Fuel__c, Maintenance__c, Miscellaneous__c, Online_Application__c,
                                         Fuel_Grade__c, Vehicle_Id__c, Vehicle_Description__c, Vehicle_Type__c
                               from      OnlineApplicationVehicleSetup__c
                               where     Online_Application__c = :oa.Id
                               order by  CreatedDate];
                               
            m_driverSetups = [select    Id, Driver_ID__c, Driver_Name__c, Name, Online_Application__c,
                                        ATM_Access__c, Cash_Limit__c, Fuel_Limit__c, Fuel_Grade__c, Misc_Limit__c 
                              from      OnlineApplicationDriverSetup__c
                              where     Online_Application__c = :oa.Id
                              order by  CreatedDate];

            m_unitNumbers = [select    Id, Name, Online_Application__c 
                             from      OnlineApplicationUnitNumber__c
                             where     Online_Application__c = :oa.Id
                             order by  CreatedDate];

            m_cardSetups = [select    Id, Name, Online_Application__c, All_Merchants__c, Cardholder_Name__c, Card_Restrictions__c,
                                          Card_Type__c, Cash__c, Credit_Limit__c, Fuel__c, Maint__c, Security_Code_Driver_ID__c 
                            from      OnlineApplicationCardSetup__c
                            where     Online_Application__c = :oa.Id
                            order by  CreatedDate];
        }
    }

    //--------------------
    // getters and setters
    //--------------------

    public OnlineApplication__c getSO() {
        return m_oa;
    }

    public Boolean isSaved() {
        return !this.IsUnsaved();
    }

    public Boolean isUnsaved() {
        return m_oa.Id == null;
    }

    public String getProductType() {
        return m_oa.Product_Type__c;
    }

    public String getDisclosure() {

        OnlineApplicationOffer__c o = [select Id, Disclosure__c
                                       from   OnlineApplicationOffer__c
                                       where  Id = :m_oa.Offer__c];
                                                                          
        return o.Disclosure__c.replace('\n','<br/>');    
    }

    public String getShipToAddress() {
        
        if(m_oa.Change_to_Authorizing_Officer_Address__c) {             
            return
            m_oa.Legal_Business_Name__c + '<br/>' + 
            Label.Attn + m_oa.AO_Name__c + '<br/>' + 
            m_oa.AO_Address__c + '<br/>' + 
            m_oa.AO_City__c + ', ' + m_oa.AO_State__c + ', ' + m_oa.AO_Zip_Code__c;
        } 
        else {
            // Need to modify here
            return
            m_oa.Legal_Business_Name__c + '<br/>' + 
            Label.Attn + m_oa.AO_Name__c + '<br/>' + 
            m_oa.Business_Street_Address__c + '<br/>' + 
            m_oa.City__c + ', ' + m_oa.State__c + ', ' + m_oa.Zip_Code__c;            
        }
    }

    public static Map<String,String> getNameLabelFieldMap(Schema.SOBjectType sot) {
        
        Map<String,String> m = new Map<String,String>();
        List<Schema.SObjectField> sofs;
        
        if(sot == OnlineApplication__c.SObjectType) {
            sofs = m_oaFieldMap.values();
        }
        else if(sot == OnlineApplicationAuthorizedContact__c.SObjectType) {
            sofs = m_acFieldMap.values();
        }
        else if(sot == OnlineApplicationVehicleSetup__c.SObjectType) {
            sofs = m_vsFieldMap.values();
        }
        else if(sot == OnlineApplicationDriverSetup__c.SObjectType) {
            sofs = m_dsFieldMap.values();
        }
        else if(sot == OnlineApplicationCardSetup__c.SObjectType) {
            sofs = m_csFieldMap.values();
        }
        else {
            sofs = m_unFieldMap.values();
        }
        
        for(Schema.SObjectField sof : sofs) {
            Schema.DescribeFieldResult f = sof.getDescribe();
            m.put(f.getName(),f.getLabel());
        }
        
        return m;
    }

    public static String getFormattedValue(Schema.SOBjectType sot, String fieldName, Object value) {

        Schema.SObjectField sof = null;
        String stringValue = String.valueOf(value);
        
        if(value == null) {
            return '';
        }
        
        // masking scenarios
        
        if(sot == OnlineApplicationAuthorizedContact__c.SObjectType && fieldName == 'Security_Code__c') {
            return getStars(String.valueOf(value).length());
        }
        else if(sot == OnlineApplicationAuthorizedContact__c.SObjectType && fieldName == 'Online_Password__c') {
            return getStars(String.valueOf(value).length());
        }
        else if(sot == OnlineApplication__c.SObjectType && fieldName == 'AO_Date_of_Birth__c') {
            try {
                Date d = (Date)value;
                String pieceOfDate = d.format();
                pieceOfDate = pieceOfDate.substring(0,pieceOfDate.length()-4);
                return pieceOfDate + getStars(4);
            }
            catch(Exception e) {}
        }
        
        // non-masking scenarios
        
        if(sot == OnlineApplication__c.SObjectType) {
            sof = m_oaFieldMap.get(fieldName);
        }
        else if(sot == OnlineApplicationAuthorizedContact__c.SObjectType) {
            sof = m_acFieldMap.get(fieldName);
        }
        else if(sot == OnlineApplicationVehicleSetup__c.SObjectType) {
            sof = m_vsFieldMap.get(fieldName);
        }
        else if(sot == OnlineApplicationDriverSetup__c.SObjectType) {
            sof = m_dsFieldMap.get(fieldName);
        }
        else if(sot == OnlineApplicationCardSetup__c.SObjectType) {
            sof = m_csFieldMap.get(fieldName);
        }        
        else {
            sof = m_unFieldMap.get(fieldName);
        }
        
        Schema.DescribeFieldResult f = sof.getDescribe();
        Schema.DisplayType dt = f.getType();
        
        if(dt == Schema.DisplayType.EncryptedString) {
            Integer sLength = stringValue.length();
            if(sLength > 4) {
                String firstPart = stringValue.substring(0, sLength-4); 
                firstPart = firstPart.replaceAll('.*','*');
                String lastFour = stringValue.substring(sLength-4);
                return firstPart+lastFour;
            }
            else {
                return stringValue;
            }
        }
        else if(dt == Schema.DisplayType.Currency) {
            return '$' + stringValue;
        }
        else if(dt == Schema.DisplayType.Date) {
            return ((Date)value).format();
        }
        else if(dt == Schema.DisplayType.Boolean) {
            return stringValue.toLowerCase() == 'true' ? 'Yes' : 'No';
        }        
        else {
            return stringValue;
        }

    }

    public static OnlineApplication__c getSObjectWithAllFields(ID oaId) {
        return (OnlineApplication__c)SOUtility.getCompleteSObject(OnlineApplication__c.SObjectType, oaId);        
    }

    //------------------------------------------------------

    public List<OnlineApplicationAuthorizedContact__c> getAuthorizedContacts() {
        return m_authorizedContacts;
    }
    public void addAuthorizedContact(OnlineApplicationAuthorizedContact__c contact) {
        m_authorizedContacts.add(contact);
    }

    public List<OnlineApplicationVehicleSetup__c> getVehicleSetups() {
        return m_vehicleSetups;
    }
    public void addVehicleSetup(OnlineApplicationVehicleSetup__c setup) {
        m_vehicleSetups.add(setup);
    }

    public List<OnlineApplicationDriverSetup__c> getDriverSetups() {
        return m_driverSetups;
    }
    public void addDriverSetup(OnlineApplicationDriverSetup__c setup) {
        m_driverSetups.add(setup);
    }

    public List<OnlineApplicationUnitNumber__c> getUnitNumbers() {
        return m_unitNumbers;
    }
    public void addUnitNumber(OnlineApplicationUnitNumber__c nbr) {
        m_unitNumbers.add(nbr);
    }

    public List<OnlineApplicationCardSetup__c> getCardSetups() {
        return m_cardSetups;
    }
    public void addCardSetup(OnlineApplicationCardSetup__c setup) {
        m_cardSetups.add(setup);
    }

    //------------------------------------------------------

    public Boolean isLargeFleet() {
        
        Integer i = OnlineApplicationParameters.getSmallFleetMaximum();
        if(i == null) {
            return false;
        }
    
        if(OnlineApplication.LOCAL == getProductType()) {     
            return (m_oa.Number_of_Vehicles__c != null && m_oa.Number_of_Vehicles__c > i);
        }
        else if(OnlineApplication.MASTERCARD == getProductType()) {     
            return (m_oa.Number_of_Cards_Needed__c != null && m_oa.Number_of_Cards_Needed__c > i);
        }
        else {
            return (m_oa.Number_of_Trucks__c != null && m_oa.Number_of_Trucks__c > i);
        }
    }

    public List<SelectOption> getLocalFuelChoices() {
        return new List<SelectOption>{new SelectOption(UNLEADED,UNLEADED), 
                                      new SelectOption(UNLEADED_MID,UNLEADED_MID),
                                      new SelectOption(UNLEADED_PREM,UNLEADED_PREM),
                                      new SelectOption(DIESEL,DIESEL),
                                      new SelectOption(ALL,ALL)};
    }

    public List<SelectOption> getOTRFuelChoices() {
        return new List<SelectOption>{new SelectOption(DIESEL,DIESEL), new SelectOption(DIESEL_AND_GASOLINE,DIESEL_AND_GASOLINE)};
    }

    // this is tricky as it has a slightly different meaning 
    // depending on who created the application
    public Boolean getShowCardSetupPage() {

        if(m_oa.Fleet_One_Initiated_Application__c) {
            return m_oa.Show_Card_Setup_Page__c;
        }
        else {
            return !isLargeFleet() && !m_oa.Hide_Card_Setup_Page__c;
        }
    }

    //------------------
    // 'action' methods
    //------------------    

    public void saveApplication() {
        
        List<ID> recordsToKeep;
        
        system.debug('**m_oa***'+m_oa);
        upsert m_oa;
        // contacts
        
        recordsToKeep = new List<ID>();
        for(OnlineApplicationAuthorizedContact__c c : m_authorizedContacts) {
            if(c.Online_Application__c == null) {
                c.Online_Application__c = m_oa.Id;
            }
            if(c.Id != null) {
                recordsToKeep.add(c.Id);
            }
        }
        List<OnlineApplicationAuthorizedContact__c> obsoleteContacts = 
            [select Id  from  OnlineApplicationAuthorizedContact__c 
                        where Online_Application__c = :m_oa.Id
                        and   Id not in :recordsToKeep];
        delete obsoleteContacts;
        upsert m_authorizedContacts;

        // vehicles
        
        recordsToKeep = new List<ID>();        
        for(OnlineApplicationVehicleSetup__c vs : m_vehicleSetups) {
            if(vs.Online_Application__c == null) {
                vs.Online_Application__c = m_oa.Id;
            }
            if(vs.Id != null) {
                recordsToKeep.add(vs.Id);
            }
        }
        List<OnlineApplicationVehicleSetup__c> obsoleteVehicles = 
            [select Id  from  OnlineApplicationVehicleSetup__c 
                        where Online_Application__c = :m_oa.Id
                        and   Id not in :recordsToKeep];
        delete obsoleteVehicles;
        upsert m_vehicleSetups;        

        // drivers

        recordsToKeep = new List<ID>();
        for(OnlineApplicationDriverSetup__c ds : m_driverSetups) {
            if(ds.Online_Application__c == null) {
                ds.Online_Application__c = m_oa.Id;
            }
            if(ds.Id != null) {
                
                //Added by Trekbin on 22 July, 2015
                ds.Driver_Name__c = formatNames(ds.Driver_Name__c, 39);
                
                recordsToKeep.add(ds.Id);
            }
        }
        List<OnlineApplicationDriverSetup__c> obsoleteDrivers = 
            [select Id  from  OnlineApplicationDriverSetup__c 
                        where Online_Application__c = :m_oa.Id
                        and   Id not in :recordsToKeep];
        delete obsoleteDrivers;
        upsert m_driverSetups;        

        // unit numbers

        recordsToKeep = new List<ID>();
        for(OnlineApplicationUnitNumber__c un : m_unitNumbers) {
            if(un.Online_Application__c == null) {
                un.Online_Application__c = m_oa.Id;
            }
            if(un.Id != null) {
                recordsToKeep.add(un.Id);
            }
        }
        List<OnlineApplicationUnitNumber__c> obsoleteUnits = 
            [select Id  from  OnlineApplicationUnitNumber__c 
                        where Online_Application__c = :m_oa.Id
                        and   Id not in :recordsToKeep];
        delete obsoleteUnits;
        upsert m_unitNumbers;        

        // cards

        recordsToKeep = new List<ID>();
        for(OnlineApplicationCardSetup__c cs : m_cardSetups) {
            if(cs.Online_Application__c == null) {
                cs.Online_Application__c = m_oa.Id;
            }
            if(cs.Id != null) {
                recordsToKeep.add(cs.Id);
            }
        }
        List<OnlineApplicationCardSetup__c> obsoleteCards = 
            [select Id  from  OnlineApplicationCardSetup__c 
                        where Online_Application__c = :m_oa.Id
                        and   Id not in :recordsToKeep];
        delete obsoleteCards;
        upsert m_cardSetups;        
    }

    // If an Id is passed this is an update operation for the account, contact, and opportunity.
    // Otherwise, it's an insert operation.
    public Id convertApplicationToAccountContactOpportunity(Id accountId) {

        Boolean isNewAccount = (accountId == null);
        
        //-------------------------
        // create or update account
        //-------------------------
        
        Account a;
        if(isNewAccount) {
            a = new Account();
            a.OwnerId = m_oa.OwnerId;
        }
        else {
            a = new Account(Id = accountId);
        }
        
        a.Name = m_oa.Legal_Business_Name__c;
        a.BillingStreet = m_oa.Business_Street_Address__c;
        a.BillingCity = m_oa.City__c;
        a.BillingState = m_oa.State__c;
        a.BillingPostalCode = m_oa.Zip_Code__c;
        a.Phone = m_oa.Phone_Number__c;
        a.Fax = m_oa.Fax_Number__c;        
        a.forseva1__DUNS_Number__c = m_oa.DUNS__c;
        
        // BEGIN FLEET ONE-SPECIFIC FIELDS
        
        a.SSNTIN__c = m_oa.Federal_Tax_ID__c;
        a.D_B__c = m_oa.DUNS__c;
        a.Number_of_Tractors__c = m_oa.Number_of_Trucks__c;
        a.Number_of_Trailers__c = m_oa.Number_of_Trailers__c;
        if(m_oa.Product_Type__c == OTR) {
            a.Number_of_Other_Fuel_Vehicles__c = m_oa.Number_of_Vehicles__c;            
        }
        else {
            a.Number_of_Vehicles__c = m_oa.Number_of_Vehicles__c;
        }
        a.Number_of_Employed_Drivers__c = m_oa.Number_of_Drivers__c;
        a.Card_Product_del__c = m_oa.Product_Type__c;
        a.Trade_Name_of_Business__c = m_oa.Trade_Name__c;
        a.Financial_Institution__c = m_oa.Financial_Institution__c;
        a.Branch_Address__c = m_oa.Branch_Address__c;
        a.Branch_City__c = m_oa.Branch_City__c;
        a.Branch_State__c = m_oa.Branch_State__c;
        a.Branch_Zip_Code__c = m_oa.Branch_Zip_Code__c;
        a.ABA_Routing_Number__c = m_oa.ABA_Routing_Number__c;
        a.Checking_Account_Number__c = m_oa.Checking_Account_Number__c;
        a.RecordTypeId  = UtilityClass.getRecordTypeByName(Account.getSObjectType(), 'Fleet Account');

        upsert a;
        m_oa.Account__c = a.Id;
        update m_oa;
        
        //-------------------------
        // create or update contact
        //-------------------------
        
        Contact c;
        if(isNewAccount) {
            c = new Contact();
            Id rId = OnlineApplicationParameters.getDefaultContactRecordType();
            if(rId != null) {
                c.RecordTypeId = rId;
            }            
            c.AccountId = a.Id;
            c.OwnerId = m_oa.OwnerId;
        }
        else {
            try {
                c = [select Id, AccountId from Contact where AccountId = :a.Id and (Name = :m_oa.AO_Name__c or Email = :m_oa.AO_Work_Email__c)];
            }
            catch(Exception e) {
                c = new Contact();
                Id rId = OnlineApplicationParameters.getDefaultContactRecordType();
                if(rId != null) {
                    c.RecordTypeId = rId;
                }                
                c.AccountId = a.Id;
            }
        }
        
        String fullName = m_oa.AO_Name__c;
        if(fullName.contains(' ')) {
            c.FirstName = fullName.substring(0, fullName.indexOf(' '));
            c.LastName = fullName.substring(fullName.indexOf(' ')+1);
        }
        else {
            c.LastName = fullName;
        }
        c.Title = m_oa.AO_Title__c;
        c.Email = m_oa.AO_Work_Email__c;
        c.HomePhone = m_oa.AO_Home_Phone_Number__c;
        c.MobilePhone = m_oa.Cell_Number__c;
        c.Phone = m_oa.Phone_Number__c;
        c.MailingStreet = m_oa.AO_Address__c;
        c.MailingCity = m_oa.AO_City__c;
        c.MailingState = m_oa.AO_State__c;
        c.MailingPostalCode = m_oa.AO_Zip_Code__c;
        c.Birthdate = m_oa.AO_Date_of_Birth__c;
        
        // BEGIN FLEET ONE-SPECIFIC FIELDS
        
        c.LeadSource = m_oa.How_Did_You_Hear_About_Us__c;
        c.Lead_Source_Sub_Type2__c = m_oa.Lead_Source_Subtype__c;
        c.Social_Security_Number__c = m_oa.AO_Social_Security_Number__c;
        if(getSO().eSignature_Status__c == EXECUTED_AND_RECEIVED) {
            c.Last_Valid_Authorized_Signer__c = true;
        }
             
        upsert c;
        
        //-----------------------------
        // create or update opportunity
        //-----------------------------
        
        Opportunity o;
        if(isNewAccount) {
            o = new Opportunity();
            o.AccountId = a.Id;
            o.OwnerId = m_oa.OwnerId;
        }
        else {
            try {
                o = [select Id, AccountId from Opportunity where Id = :m_oa.Opportunity__c];
            }
            catch(Exception e) {
                o = new Opportunity();
                o.AccountId = a.Id;
            }
        }
            
        o.Name = m_oa.Application_Title__c;
            System.debug('_______@@@@@oname______' + o.name);
       // o.StageName = 'BSA Received';
       // o.StageName = '4) Negotiating';
        o.StageName = '5) Signed';
        o.CloseDate = Date.today() + 7;
              System.debug('_______@@@@Closedate______' + o.closeDate);
      
        
        // BEGIN FLEET ONE-SPECIFIC FIELDS
        
        o.Credit_Line_Requested__c = m_oa.Credit_Line_Requested__c;
        o.Day_of_Payment__c = m_oa.Day_of_Payment__c;

        o.RecordTypeId = UtilityClass.getRecordTypeByName(Opportunity.getSObjectType(),'Fleet Card');

        OnlineApplicationOffer__c off = [select Id, Card_Program__c from OnlineApplicationOffer__c where Id = :m_oa.Offer__c];
        o.Card_Program__c = off.Card_Program__c;
        
        upsert o;
        m_oa.Opportunity__c = o.id;
        update m_oa;
        
        return a.Id;        
    }

    public Id convertApplicationToLead() {
    
        Lead l = new Lead();
        
        String fullName = m_oa.Contact_Name__c;
        if(fullName != null && fullName.contains(' ')) {
            l.FirstName = fullName.substring(0, fullName.indexOf(' '));
            l.LastName = fullName.substring(fullName.indexOf(' ')+1);
        }
        else {
            l.LastName = fullName;
        }
        l.Company = m_oa.Legal_Business_Name__c;
        l.Status = 'Open';
        l.Rating = 'Hot';
        l.LeadSource = m_oa.How_Did_You_Hear_About_Us__c;
        l.Initial_Contact_Method__c = 'Online Application';
        l.Phone = m_oa.AO_Home_Phone_Number__c != null ? m_oa.AO_Home_Phone_Number__c : m_oa.Phone_Number__c;
        l.Street = m_oa.AO_Address__c != null ? m_oa.AO_Address__c : m_oa.Business_Street_Address__c;
        l.City = m_oa.AO_City__c != null ? m_oa.AO_City__c : m_oa.City__c;
        l.State = m_oa.AO_State__c != null ? m_oa.AO_State__c : m_oa.State__c;
        l.PostalCode = m_oa.AO_Zip_Code__c != null ? m_oa.AO_Zip_Code__c : m_oa.Zip_Code__c;
        l.Fax = m_oa.Fax_Number__c;
        l.Email = m_oa.AO_Work_Email__c != null ? m_oa.AO_Work_Email__c : m_oa.Email__c;
                
        // BEGIN FLEET ONE-SPECIFIC FIELDS
        
        l.Trade_Name_of_Business__c = m_oa.Trade_Name__c;
        l.F1_Lead_Type__c = 'Fleet';
        l.F1_Lead_Sub_Type__c = 'Fleet';
        l.Card_Product__c = m_oa.Product_Type__c;
        
        if(m_oa.Product_Type__c == OTR) {
            
            l.Number_of_Vehicles__c = m_oa.Number_of_Trucks__c;
            l.Number_of_Tractors__c = m_oa.Number_of_Trucks__c;
            l.Number_of_Other_Fuel_Vehicles__c = m_oa.Number_of_Vehicles__c;            
            
            if(m_oa.Number_of_Trucks__c == 0) {
                l.Number_of_Vehicles_Range__c = 'Not Applicable';
            }
            else if(m_oa.Number_of_Trucks__c <= 2) {
                l.Number_of_Vehicles_Range__c = '1-2';
            }            
            else if(m_oa.Number_of_Trucks__c <= 4) {
                l.Number_of_Vehicles_Range__c = '3-4';
            }            
            else if(m_oa.Number_of_Trucks__c <= 9) {
                l.Number_of_Vehicles_Range__c = '5-9';
            }            
            else if(m_oa.Number_of_Trucks__c <= 25) {
                l.Number_of_Vehicles_Range__c = '10-25';
            }            
            else if(m_oa.Number_of_Trucks__c <= 50) {
                l.Number_of_Vehicles_Range__c = '26-50';
            }            
            else if(m_oa.Number_of_Trucks__c <= 75) {
                l.Number_of_Vehicles_Range__c = '51-75';
            }            
            else if(m_oa.Number_of_Trucks__c <= 500) {
                l.Number_of_Vehicles_Range__c = '76-500';
            }            
            else if(m_oa.Number_of_Trucks__c > 500) {
                l.Number_of_Vehicles_Range__c = '501+';
            }            
        }
        else if(m_oa.Product_Type__c == LOCAL) {
            
            l.Number_of_Vehicles__c = m_oa.Number_of_Vehicles__c;
            l.Number_of_Other_Fuel_Vehicles__c = m_oa.Number_of_Vehicles__c;
            
            if(m_oa.Number_of_Vehicles__c == 0) {
                l.Number_of_Vehicles_Range__c = 'Not Applicable';
            }
            else if(m_oa.Number_of_Vehicles__c <= 2) {
                l.Number_of_Vehicles_Range__c = '1-2';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 4) {
                l.Number_of_Vehicles_Range__c = '3-4';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 9) {
                l.Number_of_Vehicles_Range__c = '5-9';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 25) {
                l.Number_of_Vehicles_Range__c = '10-25';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 50) {
                l.Number_of_Vehicles_Range__c = '26-50';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 75) {
                l.Number_of_Vehicles_Range__c = '51-75';
            }            
            else if(m_oa.Number_of_Vehicles__c <= 500) {
                l.Number_of_Vehicles_Range__c = '76-500';
            }            
            else if(m_oa.Number_of_Vehicles__c > 500) {
                l.Number_of_Vehicles_Range__c = '501+';
            }            
        }

        OnlineApplicationOffer__c off = [select Id, Card_Program__c from OnlineApplicationOffer__c where Id = :m_oa.Offer__c];
        l.Card_Program__c = off.Card_Program__c;
                
        // Lead Assignment
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        l.setOptions(dmo);
        
        insert l;
        
        l = [select Id, OwnerId from Lead where Id = :l.Id];
        
        m_oa.OwnerId = l.OwnerId;
        m_oa.Lead__c = l.Id;
        
        update m_oa;
        
        return l.Id;
    }

    public void sendWeb2LeadEmail(Id contactId) {        

        OnlineApplication__c oa = getSO();
        
        User u = [select Name from User where Id = :oa.OwnerId];
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! sendWeb2LeadEmail ' + oa + u.Name + contactId);            
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setTemplateId(oa.Email_Template_Id__c);
        m.setTargetObjectId(contactId);
        m.setWhatId(oa.Id);
        m.setReplyTo('noreply@fleetone.com');
        m.setSenderDisplayName(u.Name);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    m
            });
        } catch (Exception e) {
            System.debug(e);
        }
    }

    //---------------
    // private
    //---------------
    
    private OnlineApplication__c m_oa;
    private List<OnlineApplicationAuthorizedContact__c> m_authorizedContacts = new List<OnlineApplicationAuthorizedContact__c>();
    private List<OnlineApplicationVehicleSetup__c> m_vehicleSetups = new List<OnlineApplicationVehicleSetup__c>();
    private List<OnlineApplicationDriverSetup__c> m_driverSetups = new List<OnlineApplicationDriverSetup__c>();
    private List<OnlineApplicationUnitNumber__c> m_unitNumbers = new List<OnlineApplicationUnitNumber__c>();
    private List<OnlineApplicationCardSetup__c> m_cardSetups = new List<OnlineApplicationCardSetup__c>();
    
    private final static Map<String, Schema.SObjectField> m_oaFieldMap = Schema.SObjectType.OnlineApplication__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> m_acFieldMap = Schema.SObjectType.OnlineApplicationAuthorizedContact__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> m_vsFieldMap = Schema.SObjectType.OnlineApplicationVehicleSetup__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> m_dsFieldMap = Schema.SObjectType.OnlineApplicationDriverSetup__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> m_unFieldMap = Schema.SObjectType.OnlineApplicationUnitNumber__c.fields.getMap();
    private final static Map<String, Schema.SObjectField> m_csFieldMap = Schema.SObjectType.OnlineApplicationCardSetup__c.fields.getMap();
    
    private static String getStars(Integer length) {
        String starBaby = '';
        for(Integer i = 1; i <= length; i++) {
            starBaby += '*';
        }
        return starBaby;
    }
    
    //Added by Trekbin on 22 July, 2015
    private String formatNames(String strLegalBusinessName, integer intSize) {
        
        String strLegalName = strLegalBusinessName.substring(0,Math.min(intSize,strLegalBusinessName.length()));
        List<String> elems = strLegalName.split(' ');
        strLegalName = '';
        
        for (String x : elems) {
           
            x = x.trim();
            x = x.replaceAll('(\\s+)', ' ');
            
            if(x.length() == 1) {
               
                strLegalName += x.toUpperCase()+ ' ';
            }
            else if(x.length() > 1){
               
                strLegalName += x.substring(0,1).toUpperCase()+x.substring(1,x.length()) + ' ';
            } 
        }
        
        return strLegalName;
    }
    
}

// EOF