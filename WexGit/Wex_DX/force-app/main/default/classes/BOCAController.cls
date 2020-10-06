public class BOCAController{
    //
    //    private String BASE_URL{get;set;}
    //
    //    //Document related variables
    //    public Id logoURL {get;set;}
    //    public Id cardURL {get;set;}
    //
    //    //flag for pg fields in template
    //    public String isPG{get;set;}
    //
    //    //revolver only flag
    //    public String revFlag{get;set;}
    //
    //    //Bank data
    //    public String bankData{get;set;}
    //    //page language
    //    public String lang{get;set;}
    //
    //    //terms and conditions code
    //    public String termandcond {get;set;}
    //
    //    //terms and conditions code on the Campaign Program
    //    public String cp_terms {get;set;}
    //    //Static T&C for bottom div of BOCA from picklist on Program
    //    public String staticTNC{get;set;}
    //    //A param for google to track the page
    //    public String errors{get{if(errors == null)errors = '';return errors;}set;}
    //
    //    //Branding Colors
    //    public String brand1{get;set;}
    //    public String brand2{get;set;}
    //
    //    //program name
    //    public String name{get;set;}
    //
    //    //user variable for sales rep
    //    public user salesRep{get;set;}
    //    //pricing string
    //    public Campaign_Pricing__c  pricingObj{get;set;}
    //
    //    //google analytics code
    //    public String googleAnalyticsHeadBlock{get;set;}
    //    public String googleAnalyticsBodyBlock{get;set;}
    //
    //    //live person code
    //    public String livePerson{get;set;}
    //
    //    //inside sales
    //    public String inSales{get;set;}
    //
    //    //confirmation page content
    //    public String confirmation{get; set;}
    //    //confirmation page oppNum
    //    public String oppNum{get; set;}
    //    //application status info
    //    public String statusInfo{get; set;}
    //    //application status
    //    public String appStatus{get; set;}
    //    //error page
    //    public String errorMsg {get;set;}
    //
    //    //Brand Determining related variables
    //    private Program__c pgm {get;set;}
    //    private Campaign_Program__c cp {get;set;}
    //    public String LocationCode{get;set;}
    //    public  List<Campaign_Pricing__c> pricing {get;set;}
    //    private  String couponCode {get;set;}
    //
    //    //Email header URL
    //    public  String emailURL{get;set;}
    //
    //    //Map the fields of the pricing object so we can iterate through them dynamically
    //    public Map<String, String> fieldList{get; set;}
    //
    //
    //    //For the email component
    //    public Program__c prog{get; set;}
    //
    //    public  String BrandLongName{get;set;}
    //
    //    //branded title and tagline
    //    public  String PanelTitle{get;set;}
    //    public String BrandTitle {get;set;}
    //    public String BrandTagline{get;set;}
    //
    //    public BOCALangExtension langExt
    //    {get{
    //        if(langExt == null)
    //            langExt = new BOCALangExtension(this);
    //        return langExt;
    //    }
    //     set;
    //    }
    //
    //    public WeFormObject__c creditApp
    //    {get{
    //        if(creditApp == null)
    //            creditApp = new WeFormObject__c();
    //
    //        return creditApp;
    //    }
    //     set;
    //    }
    //
    //This initBrandCheck() method is used to redirect the form to the error page if there
    //is insufficient information to put together a branded BOCA (pgm/campaign_program)

    public PageReference initBrandCheck(){
        
        PageReference redirect = new PageReference('/apex/WexBOCA');
        redirect.getParameters().put('pgm', ApexPages.CurrentPage().getParameters().get('pgm'));
        redirect.getParameters().put('customer', ApexPages.CurrentPage().getParameters().get('customer'));
        redirect.getParameters().put('cc', ApexPages.CurrentPage().getParameters().get('cc'));
        redirect.getParameters().put('salescode', ApexPages.CurrentPage().getParameters().get('salescode'));
        redirect.getParameters().put('lc', ApexPages.CurrentPage().getParameters().get('lc'));
        redirect.getParameters().put('priority', ApexPages.CurrentPage().getParameters().get('priority'));
        redirect.setRedirect(true);
        return redirect;
        
    }
    
    //
    //    public PageReference CreditApplicationError(){
    //        String errorCode = ApexPages.CurrentPage().getParameters().get('errorCode');
    //
    //        if (errorCode != null){
    //            errorMsg = WEXErrorUtility.getErrorMessage(errorCode);
    //        }
    //        if(pgm != null){
    //            //for the branded error pages
    //            setupBranding();
    //
    //        }
    //
    //
    //        return null;
    //    }
    //
    //    public void setupBranding(){
    //
    //        //first get the page language
    //        String langID = ApexPages.CurrentPage().getParameters().get('lang');
    //        WEXBrandUtility util = new WEXBrandUtility();
    //
    //        //**************************************************************
    //        //Initial Setup of program and campaign program  ***************
    //
    //        //Variables used to determine brand
    //
    //        String couponCodeUrlParam = ApexPages.CurrentPage().getParameters().get('cc');
    //        String tempCC = ApexPages.CurrentPage().getParameters().get('Promotional_Code__c');
    //        if(couponCodeUrlParam == null && tempCC != null)couponCodeUrlParam = tempCC;
    //        String brandUrlParam = ApexPages.CurrentPage().getParameters().get('pgm');
    //        //the WE_ID is for the app status page when returning via the email link
    //        String weId = ApexPages.currentPage().getParameters().get('weId');
    //
    //        if (LocationCode == null) {
    //          LocationCode = ApexPages.currentPage().getParameters().get('lc');
    //          String tempLoc = ApexPages.CurrentPage().getParameters().get('Location_Code__c');
    //          if(LocationCode == null && tempLoc != null)LocationCode = tempLoc;
    //        }
    //
    //        String url = ApexPages.CurrentPage().getUrl();
    //
    //        //get toggle for pg if exists
    //        String togglePG = ApexPages.CurrentPage().getParameters().get('pgOff');
    //
    //        //Get the Sales Id from the URL
    //        creditApp.Sales_Id__c = ApexPages.CurrentPage().getParameters().get('salescode');
    //        SYSTEM.debug('User: ' + creditApp.Sales_Id__c);
    //
    //        //check the language from the url, or default
    //        if(langID != null){
    //            lang = langID;
    //        }
    //        else lang = 'en_us';
    //
    //
    //        if(weId != null){
    //            //get the opp off of the weform
    //            WeFormObject__c stat = [SELECT  Opportunity__c, Id FROM WeFormObject__c WHERE Id =: weId];
    //            //query the opp for the app request
    //            Opportunity weOpp = [SELECT ID, Application_Request__c, Application_Status__c FROM Opportunity WHERE ID =: stat.Opportunity__c];
    //            //query the app request for the status
    //            Application_Request__c wef = [SELECT Application_Status__c, ID, Opportunity__c FROM Application_Request__c WHERE Opportunity__c =: weOpp.Id];
    //            //give that status back to the page
    //            appStatus = wef.Application_Status__c;
    //
    //            SYSTEM.debug('status '+appStatus);
    //        }
    //        //Need to get the program
    //        pgm = util.setProgramFromURL(brandUrlParam, url);
    //        //Then need to get the campaign program for the t&c's
    //        if (pgm != null){
    //            //Now get the campaign based on the coupon code
    //            List<Campaign> campaigns = [select id from campaign where coupon_code__c = :couponCodeUrlParam];
    //            if (campaigns.size() == 0){
    //                //Need to get the default campaign program for the program
    //                cp = util.getDefaultCampaignProgram(pgm);
    //                //terms and conditions text from the campain program
    //                cp_terms = cp.Terms_and_Conditions__c;
    //            }else{
    //                cp = util.getCampaignProgram(pgm, campaigns[0]);
    //                //terms and conditions text from the campain program
    //                cp_terms = cp.Terms_and_Conditions__c;
    //                //now if the campaign program selected does not have any t&c, get the default
    //                if(cp.Terms_and_Conditions__c == null){
    //                    //terms and conditions text from the campain program
    //                    cp_terms = util.getDefaultCampaignProgram(pgm).Terms_and_Conditions__c;
    //
    //                }
    //            }
    //
    //        }
    //        if (pgm != null && cp != null){
    //
    //            //**************************************************************
    //            //**************************************************************
    //
    //            BrandLongName = pgm.Brand_Long_Name__c;
    //            googleAnalyticsBodyBlock = pgm.Analytics_Body_Block__c;
    //            googleAnalyticsHeadBlock = pgm.Analytics_Head_Block__c;
    //
    //            StaticResource sr = [select Body from StaticResource where Name =: pgm.T_C__c ];
    //            staticTNC = sr.Body.toString();
    //
    //
    //            //confirmation page
    //            confirmation = pgm.Confirmation_Info__c;
    //
    //            //livePerson code
    //            livePerson = pgm.Live_Person_Code__c;
    //
    //            //inside sales
    //            inSales = ' '+ pgm.Inside_Sales_Phone_Number__c;
    //
    //            //Email header
    //            emailURL = pgm.Custom_Email_Header_URL__c;
    //
    //            // creditApp.TM_Session_ID__c = UserInfo.getSessionId();
    //            SYSTEM.debug('session id: ' + creditApp.TM_Session_ID__c);
    //
    //            //branded colors
    //            brand1 = pgm.Brand_Color_1__c;
    //            brand2 = pgm.Brand_Color_2__c;
    //
    //            //look up the sales id if it exists
    //            if(creditApp.Sales_Id__c != null && creditApp.Sales_Id__c != ''){
    //                List<User> u = new List<User>();
    //                try{
    //                    u = [SELECT Name, Id, email, phone, Sales_Code__c, fax FROM USER WHERE sales_code__c =: creditApp.Sales_Id__c LIMIT 1];
    //
    //                }
    //                catch(SYSTEM.DmlException ex){
    //                    SYSTEM.debug('error on accessing user ' + ex);
    //
    //                }
    //                salesRep = (u.size() != 0) ? u.get(0) :  null;
    //
    //            }
    //            //retrieve attachment images
    //            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : pgm.Id AND Name=:'ui-credit-card.png'];
    //            cardURL = card.id;
    //
    //            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = : pgm.Id AND Name=:'ui-logo.png'];
    //            logoURL = logo.id;
    //
    //            //this sets the coupon code (for the pricing) to the appropriate one set on the program
    //
    //            //turn off the PG on conditional templates if the param is set in the URL
    //            creditApp.togglePG__c = togglePG != null ? true : false;
    //
    //            //coupon code
    //            couponCode = util.getCouponCode(cp);
    //            creditApp.Promotional_Code__c = couponCode;
    //
    //            //set the campaign program
    //            creditApp.Campaign_Program_ID__c = cp.Id;
    //
    //            //get the pricing information if the program's setup says it should be so...
    //            if (pgm.Upload_Pricing_Data_Flag__c == true){
    //                //need to default if there is no pricing
    //                pricing = util.getPricing(pgm.Peoplesoft_rel_code__c,couponCode);
    //                if(pricing == null){
    //                    creditApp.Promotional_Code__c = util.getDefault(pgm.id);
    //                    pricing = util.getPricing(pgm.Peoplesoft_rel_code__c, creditApp.Promotional_Code__c);
    //
    //                }
    //                WEXPricingHelper wexP = new WEXPricingHelper();
    //                //check to see if the pricing contains two rows of data
    //                //send the campaign pricing to the helper class and get the format map
    //                if(pricing.size() == 2){
    //                    SYSTEM.debug('pricing: '+pricing);
    //                    //if there are two rows only return the format map for the risk based pricing
    //                    Campaign_Pricing__c p1 = pricing.get(0);
    //                    Campaign_Pricing__c p2 = pricing.get(1);
    //                    SYSTEM.debug('pric 1: ' + p1.risk_code__c + 'pric 2: ' + p2.risk_code__c);
    //                    if(p1.risk_Code__c == '7'){
    //
    //                        fieldList = wexP.getPricing(pricing.get(0));
    //                        SYSTEM.debug('list: ' + fieldList );
    //                    }
    //                    if(p2.risk_code__c == '7'){
    //                        fieldList = wexP.getPricing(pricing.get(1));
    //                        SYSTEM.debug('list: ' + fieldList );
    //                    }
    //                }
    //                else{
    //                    fieldList = wexP.getPricing(pricing.get(0));
    //                }
    //
    //
    //
    //            }
    //
    //        }
    //
    //    }
    //    public BOCAController(){
    //        SYSTEM.debug('inside the controller');
    //        //check to see if the application is coming in with an existing record id/partial app from URLgen email
    //        Boolean partialApp = false;
    //        partialApp = ApexPages.CurrentPage().getParameters().get('priority') != null ? true : false;
    //        SYSTEM.debug('is partial ' + partialApp);
    //        if(partialApp){
    //            Id cust = ApexPages.CurrentPage().getParameters().get('customer');
    //
    //            if(cust != null){
    //                try{
    //                    creditApp = [SELECT togglePG__c, ABA_Routing_Number__c, Address_Line_2__c, Annual_Gross_Revenue__c,
    //                                 Authorization__c, Authorization_agreement_Signature__c,
    //                                 Authorize__c, Authorized_officer__c, Avg_Monthly_Fuel_Service_Expenses__c, Billing_Address_Line_2__c,
    //                                 Billing_City__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Email__c, Billing_Fax__c,
    //                                 Billing_Mobile_Phone__c, Billing_Phone__c, Billing_State__c, Billing_Street_Address__c, Billing_Zip_Code__c, Business_Phone__c,
    //                                 Business_Street_Address__c, Business_fax__c, Campaign_Program_ID__c,  City__c, Company_Name__c,
    //                                 DUNS_Number__c, Date_of_Birth__c, Day_of_Payment__c, Doing_Business_As__c,
    //                                 Email__c, Employee_Id__c, Estimated_Monthly_Vehicle_Expenses__c, External_Sales_Id__c, Financial_Institution__c,
    //                                 First_Name__c, Fiscal_Year_Starts__c, Fleet_Size__c, Guarantor_Annual_Income__c,
    //                                 How_did_you_hear_about_this_offer__c, Id, IsDeleted, Is_business_exempt_from_Motor_Fuels_Tax__c,
    //                                 LastModifiedById, LastModifiedDate, LastViewedDate, Last_Name__c, Legal_Structure__c,
    //                                 Location_Code__c, Mobile_Phone__c, Name, Non_Std_Neg_Fee__c, Online_Application_Status__c, Opportunity__c,
    //                                 OwnerId, PG_Residential_City__c, PG_Residential_Phone__c, PG_Residential_State__c, PG_Residential_Street_Address__c,
    //                                 PG_Residential_Zip__c, Paperless_Flag__c, Payment_Method__c, Program_Id__c, Program__c, Promotional_Code__c,
    //                                 RecordTypeId, Sales_Id__c, Sales_Rep_Email__c, Sales_Rep_Phone__c, Same_as_Business_Address__c,
    //                                 Signer_s_Email__c, Signer_s_First_Name__c, Signer_s_Last_Name__c, Signer_s_Phone__c, State__c,
    //                                 Years_in_Business__c, Zip_code__c, isPG__c, message__c,
    //                                 signer_title__c, status__c FROM WeFormObject__c WHERE Id =: cust AND status__c =: 'partial' LIMIT 1 ];
    //                    creditApp.status__c = 'complete';
    //                }
    //                catch(DmlException ex){
    //                    SYSTEM.debug('problem accessing record ' + ex.getMessage());
    //                }
    //            }
    //        }
    //
    //        //Initial Setup of program and campaign program  ***************
    //        setupBranding();
    //
    //
    //    }
    //
    //    public void SendEmail(weFormObject__c we){
    //        SYSTEM.debug('inside emailer ' +  we.First_Name__c);
    //
    //        Map<String, BOCA_IDs__c> bi = new Map<String, BOCA_IDs__c>();
    //        bi = BOCA_IDs__c.getAll();
    //        BOCA_IDs__c singleBI = new BOCA_IDs__c();
    //        String emailAdd = '';
    //        if(bi.size() != 0){
    //            singleBI = bi.get('BOCA IDS');
    //            SYSTEM.debug('custom setting ' + bi.get('BOCA IDS') + 'single bi ' + singleBI.get('Email_Address_Noreply__c'));
    //            emailAdd = String.valueOf(singleBI.get('Email_Address_Noreply__c'));
    //        }
    //        List<RecordType> ctRecordTypes = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('F1_Contact')];
    //        Messaging.reserveSingleEmailCapacity(1);
    //        Messaging.SingleEmailMessage confirm = new Messaging.SingleEmailMessage();
    //        Contact c = new Contact();
    //        c.FirstName = we.First_Name__c;
    //        c.LastName = we.Last_Name__c;
    //
    //        c.Email = we.Email__c;
    //        c.RecordTypeId = ctRecordTypes[0].Id;
    //        insert c;
    //        confirm.setTemplateId(langExt.emailTemplate);
    //        confirm.setWhatId(we.Id);
    //        confirm.setTargetObjectId(c.id);
    //        confirm.setSaveAsActivity(false);
    //        confirm.setReplyTo(emailAdd);
    //        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress])
    //        {
    //            if(owa.Address.contains(emailAdd))
    //
    //                confirm.setOrgWideEmailAddressId(owa.id);
    //        }
    //
    //        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {confirm});
    //
    //        delete c;
    //
    //    }
    //
    //    public Program__c getProg(String pId){
    //        //query the form for the emailer
    //
    //        prog = [select id,  Custom_Email_Header_URL__c FROM Program__c WHERE id =:pId];
    //        return prog;
    //
    //    }
    //
    //    public PageReference SubmitCreditApplication(){
    //        boolean rev = false;
    //        PageReference page = null;
    //        //get the record type
    //        String recType = '';
    //        //system.debug('isPG : ' );
    //        if(isPG != 'true' && bankData != 'true'){
    //            recType = 'WEX';
    //        }
    //        if(isPG == 'true' && bankData == 'true'){
    //            recType = 'WEX';
    //        }
    //        if(revFlag != null){
    //            recType = 'Revolver';
    //            creditApp.isPG__c = true;
    //            rev = true;
    //        }
    //        else{
    //            recType = 'WEX';
    //            creditApp.isPG__c = true;
    //        }
    //        system.debug('bankdata ' + bankData);
    //        boolean bankD = (bankData == null) ? false : true;
    //        creditApp.isPG__c = (isPG == null || isPG != 'true') ? false: true;
    //        if(!BOCAValidator.validateFields(creditApp, lang, creditApp.isPG__c, bankD, rev)){
    //            Map<String, Schema.RecordTypeInfo> RT = weFormObject__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    //            //List of record types to look for, not the label is used not the api name
    //            String recordTname = recType;
    //
    //            Id type;
    //
    //            if(RT.containsKey(recordTname)){
    //                SYSTEM.debug(RT.get(recordTname).getRecordTypeId());
    //                //add the record type ids to the list for your trigger logic
    //                type = RT.get(recordTname).getRecordTypeId();
    //                SYSTEM.debug('type ' + type);
    //                creditApp.RecordTypeId = type;
    //            }
    //
    //            //check for the location code
    //            if(LocationCode != null){creditApp.Location_Code__c = LocationCode;}
    //            creditApp.IPAddress__c =  ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
    //            creditApp.Program_Id__c = pgm.Id;
    //            if(salesRep != null)creditApp.salesRep__c = salesRep.id;
    //            //this one is a lookup for the email
    //            creditApp.Program__c = pgm.Id;
    //            SYSTEM.debug('credit app before insert: ' + creditApp + 'ID: ' + creditApp.id);
    //            // if(creditApp.status__c == '' )
    //            Database.upsertResult result = Database.upsert(creditApp, false);
    //            if(result.isSuccess()){
    //                Id weId = result.getId();
    //                SYSTEM.debug('weForm'+ weId);
    //                WeFormObject__c we = [SELECT ID, First_Name__c, Last_Name__c, Email__c, Application_Number__c FROM WeFormObject__c WHERE ID =: weId];
    //
    //                oppNum = we.Application_Number__c;
    //                SYSTEM.debug('opp'+ we);
    //                sendEmail(we);
    //
    //                page = new PageReference('/apex/BOCAConfirmation?pgm='+pgm.Brand_Short_Name__c);
    //                page.getParameters().put('oppNum',oppNum);
    //                page.setRedirect(true);
    //
    //                //return page;
    //            }
    //            else{
    //                SYSTEM.debug('insert errors' + result.getErrors());
    //                page = ApexPages.currentPage();
    //                page.setRedirect(true);
    //                //return page;
    //            }
    //
    //        }
    //        else{
    //            page = null;
    //
    //            // page.setRedirect(true);
    //        }
    //        errors = 'Your application has errors. Please fix the highlighted fields and resubmit.';
    //        return page;
    //
    //
    //
    //
    //
    //    }
}