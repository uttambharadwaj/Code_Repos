public class WexConsumerController {

    public final static String APPLICATION_NAME = 'Consumer BOCA';

    // Credit application object
    public WeFormObject__c creditApp { get; set; }
    
    public String tmSessionId { get; set; }

    // If this is a preview from the Program object
    public Boolean isPreview { 
        get {
            if(ApexPages.currentPage().getParameters().get('preview') == 'true') {
                return true;
            } 
            return false;
        }
    }
    
    // Check is this is a BOCA to Prospect
    public Boolean isPartial {
        get {
            Boolean partialApp = ApexPages.currentPage().getParameters().get('priority') != null ? true : false;
            return partialApp;
        }
    }
    
    // If BOCa to Prospect - get the WeForm ID
    public String partialCustomer { 
        get {
            return ApexPages.currentPage().getParameters().get('customer');
        }
    }
    
    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
        }
    }
    
    // Get the coupon code, if supplied
    public String couponCodeParameter {
        get {
            return ApexPages.currentPage().getParameters().get('cc');
        } 
    }
    
    // Get the location code, if supplied
    public String locationCode {
        get {
            return ApexPages.currentPage().getParameters().get('lc');
        }
    }
    
    // Get the IP of the applicant for ThreatMetrix
    public String ipAddress {
        get {
            return ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
    }
    
    // Get the Sales Code if BOCA to Prospect
    public String salesCode {
        get {
            return ApexPages.currentPage().getParameters().get('salescode');
        }
    }

    // Get the Sales Code if BOCA to Prospect
    public String groupCode {
        get {
            return ApexPages.currentPage().getParameters().get('groupcode');
        }
    }

    // Get the Merchant Facility Number
    public String merchantFacilityNumber {
        get {
            return ApexPages.currentPage().getParameters().get('merchantFacilityNumber'); // __c only because they've already added it this way to all of the URLs
        }
    }

    // Program for the BOCA
    public Program__c program { get; set; }
    
    // Language Code for the BOCA
    public String languageCode { get; set; }
    
    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }
    
    public Id defaultBrandingUtility {
        get {
            List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND BOCA_Default__c = TRUE];
            
            if(brandingUtilities.isEmpty()) {
                // If we don't get a default branding utility back, just return the first one in the list
                // This is for backwards compatability until we get the new field in place.. 
                List<BOCA_res__c> defaultBrandingUtility = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id];
                return defaultBrandingUtility[0].Id;    
            }
            else {
                // We should always have a default
                return brandingUtilities[0].Id;
            }
        }
    }
    
    // Branding logo related to the program
    public Id brandingLogo { get; set; }
    
    // Branding card related to the program
    public Id brandingCard { get; set; }
    
    // Disclaimer related to the program
    public String disclaimer { 
        get {
            StaticResource sr = null;

            if(brandingUtility != null && brandingUtility.Consumer_Authorized_Signer__c != null) {
                sr = [SELECT Body FROM StaticResource WHERE Name =: brandingUtility.Consumer_Authorized_Signer__c];
            }
            else {
                sr = [SELECT Body FROM StaticResource WHERE Name = 'BOCA_Default_Disclaimer'];
            }
            
            return sr.Body.toString();
        }
    }
    
    // Terms and conditions related to the program, 
    // or the branding utility override
    public String termsAndConditions { 
        get {
            StaticResource sr = null;
            
            if(!String.isEmpty(brandingUtility.Consumer_Terms_and_Conditions__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name =: brandingUtility.Consumer_Terms_and_Conditions__c];
            }
            else {
                sr = [SELECT Body FROM StaticResource WHERE Name =: program.T_C__c ];
            }
            
            return sr.Body.toString();
        }
    }

    public String pricingTermsAndConditions { get; set; }

    public String pricingTermsAndConditionsHeader { get; set; }

    public String pricingTermsAndConditionsFooter { get; set; }
    
    // Campaign for the BOCA if a coupon code is used
    public Campaign campaign { get; set; } 
    
    // Campaign program for the BOCA if a coupon code is used
    public Campaign_Program__c campaignProgram { get; set; } 
    
    // Sales rep information if BOCA to Prospect
    public User salesRep { get; set; }
    
    // Pagination variables for tracking the steps
    public Integer currentStep { get; set; }
    public Integer minStep  { get; set; }
    public Integer maxStep  { get; set; }
    
    public WexConsumerController() {
        // Setup for the pagination
        minStep = 1;
        maxStep = 2;
        if(ApexPages.currentPage().getParameters().get('currentPage') != null) {
            currentStep = Integer.valueOf(ApexPages.currentPage().getParameters().get('currentPage'));
        }
        else {
            currentStep = 1;
        }
        
        //currentStep = 2;

    }
    
    public PageReference init() {

        PageReference wexBOCAError = null;

        if (String.isEmpty(programParameter)) {
            wexBOCAError = Page.ExternalApplicationError;
            wexBOCAError.getParameters().put('pgm', programParameter);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        } else {

            // Setup the program
            List<Program__c> programs = [
                    SELECT Id, Live_Person_Code__c, Publish_BOCA__c, Custom_Email_Header_URL__c,
                            Analytics_Body_Block__c, Analytics_Head_Block__c, Peoplesoft_rel_code__c,
                            Upload_Pricing_Data_Flag__c, T_C__c, Brand_Long_Name__c, BOCA_Disclaimer__c,
                            Inside_Sales_Phone_Number__c, Brand_Color_1__c, Brand_Color_2__c, Confirmation_Info__c, BOCA_Type__c
                    FROM Program__c
                    WHERE Brand_Short_Name__c = :programParameter AND Consumer_Application_Enabled__c = TRUE
            ];

            // If we have a program, then set it, otherwise, redirect to error page
            if (!programs.isEmpty()) {

                if (programs[0].Publish_BOCA__c != true && isPreview != true) {
                    wexBOCAError = Page.ExternalApplicationError;
                    wexBOCAError.getParameters().put('pgm', programParameter);
                    wexBOCAError.setRedirect(true);
                    return wexBOCAError;
                } else {
                    program = programs[0];
                }
            } else {
                wexBOCAError = Page.ExternalApplicationError;
                wexBOCAError.getParameters().put('pgm', programParameter);
                wexBOCAError.setRedirect(true);
                return wexBOCAError;
            }

            // Setup branding logo
            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :program.Id AND Name = :'ui-logo.png'];
            brandingLogo = logo.Id;

            // Setup branding card image
            transient Attachment card = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :program.Id AND Name = :'ui-credit-card.png'];
            brandingCard = card.Id;

            // Setup the branding utility if a language code was passed in
            if (ApexPages.currentPage().getParameters().get('lang') != null) {
                languageCode = (ApexPages.currentPage().getParameters().get('lang')).toLowerCase();

                List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];

                if (!brandingUtilities.isEmpty()) {
                    brandingUtility = [
                            SELECT Id, Program_Name__c, Brand_Heading__c, Brand_Tagline__c,
                                    Consumer_Terms_and_Conditions__c, Consumer_Authorized_Signer__c, Default_Disclosure__c,
                                    Email_Template_ID__c, SideBar__c, Side_Panel_Title__c, ISO_code__c
                            FROM BOCA_res__c
                            WHERE Id = :brandingUtilities[0].Id
                    ];
                }
            }

            // Default to the default branding utility if the language code was not found, or none was passed in
            if (brandingUtility == null) {
                brandingUtility = [
                        SELECT Id, Program_Name__c, Brand_Heading__c, Brand_Tagline__c,
                                Consumer_Authorized_Signer__c, Consumer_Terms_and_Conditions__c, Default_Disclosure__c,
                                Email_Template_ID__c, SideBar__c, Side_Panel_Title__c, ISO_code__c
                        FROM BOCA_res__c
                        WHERE Id = :defaultBrandingUtility
                ];

                languageCode = brandingUtility.ISO_code__c;
            }

            // Setup the campaign stuff via the coupon code if one is passed in
            if (!String.isEmpty(couponCodeParameter)) {
                List<Campaign> campaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Coupon_Code__c = :couponCodeParameter];

                // If we have a campaign - check to ensure
                // we have a campaign program also
                if (!campaigns.isEmpty()) {
                    List<Campaign_Program__c> campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions_Footer__c, Terms_and_Conditions_Header__c, Terms_and_Conditions__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Campaign__c = :campaigns[0].Id AND Language_Code__c = :languageCode];

                    if (campaignPrograms.isEmpty()) {
                        campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions_Footer__c, Terms_and_Conditions_Header__c, Terms_and_Conditions__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Campaign__c = :campaigns[0].Id];
                    }

                    // If we have a campaign program
                    // then set the campaign and campaignProgram
                    // to be the results..
                    if (!campaignPrograms.isEmpty()) {
                        campaign = campaigns[0];
                        campaignProgram = campaignPrograms[0];

                        if (!String.isEmpty(campaignProgram.Terms_and_Conditions__c) || (!String.isEmpty(campaignProgram.Terms_and_Conditions_Header__c) && (!String.isEmpty(campaignProgram.Terms_and_Conditions_Footer__c)))) {
                            pricingTermsAndConditions = campaignProgram.Terms_and_Conditions__c;
                            pricingTermsAndConditionsHeader = campaignProgram.Terms_and_Conditions_Header__c;
                            pricingTermsAndConditionsFooter = campaignProgram.Terms_and_Conditions_Footer__c;
                        } else {
                            pricingTermsAndConditions = [SELECT Id, Terms_and_Conditions__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Default__c = TRUE AND Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions__c;
                            pricingTermsAndConditionsHeader = [SELECT Id, Terms_and_Conditions_Header__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Default__c = TRUE AND Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions_Header__c;
                            pricingTermsAndConditionsFooter = [SELECT Id, Terms_and_Conditions_Footer__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Default__c = TRUE AND Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions_Footer__c;
                        }
                    }
                }

            }

            // Setup the default campaiwexbocagn and campaign program if they
            // weren't found via the coupon code
            if (campaign == null && campaignProgram == null) {
                List<Campaign_Program__c> defaultCampaignPrograms = [SELECT Id, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c, Campaign__c, Default__c, Terms_and_Conditions__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Language_Code__c = :languageCode AND Default__c = TRUE LIMIT 1];

                if (defaultCampaignPrograms.isEmpty()) {
                    defaultCampaignPrograms = [SELECT Id, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c, Campaign__c, Default__c, Terms_and_Conditions__c FROM Campaign_Program__c WHERE Program__c = :program.Id AND Default__c = TRUE AND Language_Code__c = :languageCode LIMIT 1];
                }

                campaignProgram = defaultCampaignPrograms[0];
                pricingTermsAndConditions = campaignProgram.Terms_and_Conditions__c;
                pricingTermsAndConditionsHeader = campaignProgram.Terms_and_Conditions_Header__c;
                pricingTermsAndConditionsFooter = campaignProgram.Terms_and_Conditions_Footer__c;

                // Setup default campaign
                List<Campaign> defaultCampaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Id = :campaignProgram.Campaign__c];
                if (!defaultCampaigns.isEmpty()) {
                    campaign = defaultCampaigns[0];
                }
            }

            // Check to see if it's a BOCA to Prospect - otherwise setup a new app
            if (isPartial && partialCustomer != null) {
                try {
                    creditApp = [
                            SELECT togglePG__c, ABA_Routing_Number__c, Address_Line_2__c, Annual_Gross_Revenue__c,
                                    Authorization__c, Authorization_agreement_Signature__c,
                                    Authorize__c, Authorized_officer__c, Avg_Monthly_Fuel_Service_Expenses__c, Billing_Address_Line_2__c,
                                    Billing_City__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Email__c, Billing_Fax__c,
                                    Billing_Mobile_Phone__c, Billing_Phone__c, Billing_State__c, Billing_Street_Address__c, Billing_Zip_Code__c, Business_Phone__c,
                                    Business_Street_Address__c, Business_fax__c, Campaign_Program_ID__c, City__c, Company_Name__c,
                                    DUNS_Number__c, Date_of_Birth__c, Day_of_Payment__c, Doing_Business_As__c,
                                    Email__c, Employee_Id__c, Estimated_Monthly_Vehicle_Expenses__c, External_Sales_Id__c, Financial_Institution__c,
                                    First_Name__c, Fiscal_Year_Starts__c, Fleet_Size__c, Guarantor_Annual_Income__c,
                                    How_did_you_hear_about_this_offer__c, Id, IsDeleted, Is_business_exempt_from_Motor_Fuels_Tax__c,
                                    Last_Name__c, Legal_Structure__c, Location_Code__c, Mobile_Phone__c, Name, Non_Std_Neg_Fee__c, Online_Application_Status__c, Opportunity__c,
                                    OwnerId, PG_Residential_City__c, PG_Residential_Phone__c, PG_Residential_State__c, PG_Residential_Street_Address__c,
                                    PG_Residential_Zip__c, Paperless_Flag__c, Payment_Method__c, Program_Id__c, Program__c, Promotional_Code__c,
                                    RecordTypeId, Sales_Id__c, Sales_Rep_Email__c, Sales_Rep_Phone__c, Same_as_Business_Address__c,
                                    Signer_s_Email__c, Signer_s_First_Name__c, Signer_s_Last_Name__c, Signer_s_Phone__c, State__c,
                                    Years_in_Business__c, Zip_code__c, isPG__c, message__c,
                                    signer_title__c, status__c
                            FROM WeFormObject__c
                            WHERE Id = :partialCustomer
                            LIMIT 1
                    ];

                    System.debug('Got the credit app: ' + creditApp.Id);

                    if (creditApp != null && ((creditApp.status__c).equalsIgnoreCase('partial'))) {
                        // Mappings to fix BOCA to Prospect
                        creditApp.Email__c = creditApp.Signer_s_Email__c;
                        creditApp.First_Name__c = creditApp.Signer_s_First_Name__c;
                        creditApp.Last_Name__c = creditApp.Signer_s_Last_Name__c;
                        creditApp.Business_Phone__c = creditApp.Signer_s_Phone__c;
                        creditApp.Address_Line_2__c = '';

                        if (creditApp.Avg_Monthly_Fuel_Service_Expenses__c == null) {
                            creditApp.Avg_Monthly_Fuel_Service_Expenses__c = creditApp.Avg_Monthly_Fuel_Service_Expenses__c;
                        }

                        if (creditApp.Years_in_Business__c == '0.5' || creditApp.Years_in_Business__c == '0') {
                            creditApp.Years_in_Business__c = 'Less than 12 months';
                        }
                    } else {
                        // This clears up the dreaded "314 error" when someone tries to access the BOCA to Prospect
                        // twice after it's been submitted. This will instead send them to the confirmation page. 
                        PageReference wexBOCAConfirmation = Page.WexBOCAConfirmation;
                        wexBOCAConfirmation.getParameters().put('pgm', programParameter);
                        wexBOCAConfirmation.getParameters().put('id', creditApp.Id);
                        wexBOCAConfirmation.setRedirect(true);
                        return wexBOCAConfirmation;
                    }
                } catch (Exception e) {
                    System.debug('Problem accessing existing WeFormObject ' + e.getLineNumber() + ' ' + e);

                    String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

                    wexBOCAError = Page.ExternalApplicationError;
                    wexBOCAError.getParameters().put('errorCode', errorNumber);
                    wexBOCAError.getParameters().put('pgm', programParameter);
                    wexBOCAError.setRedirect(true);
                    return wexBOCAError;
                }
            } else {
                creditApp = new WeFormObject__c();

                if ((brandingUtility.ISO_code__c).equalsIgnoreCase('fr_ca')) {
                    creditApp.Communications_Preference__c = 'French';
                }
            }

            if (salesCode != null) {
                List<User> u = new List<User>();

                try {
                    u = [SELECT Name, Id, Email, Phone, Sales_Code__c, Fax FROM User WHERE Sales_Code__c = :salesCode LIMIT 1];
                } catch (SYSTEM.DmlException ex) {
                    System.debug('Exception during Sales Rep lookup: ' + ex);
                }

                salesRep = (u.size() != 0) ? u.get(0) : null;
            }

            // Generate ThreatMetrix SessionID
            try {
                Datetime dt = Datetime.now();
                Long l = dt.getTime();

                String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                tmSessionId = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + ipAddress + salt.substring(0, 25))));
            } catch (Exception e) {
                System.debug('Problem generating TM Session ID ' + e.getLineNumber() + ' ' + e);

                String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

                wexBOCAError = Page.ExternalApplicationError;
                wexBOCAError.getParameters().put('errorCode', errorNumber);
                wexBOCAError.getParameters().put('pgm', programParameter);
                wexBOCAError.setRedirect(true);
                return wexBOCAError;
            }

        }

        return null;

    }
    
    public class creditappException extends Exception {}
    
    public PageReference submitApplication() {
        
        try {

            // Additional information
            creditApp.IPAddress__c = ipAddress; 
            creditApp.Location_Code__c = locationCode;
            creditApp.Program__c = program.Id;
            creditApp.Program_Id__c = program.Id;
            creditApp.Campaign_Program_ID__c = campaignProgram.Id;
            creditApp.Company_Name__c = creditApp.First_Name__c + ' ' + creditApp.Last_Name__c;
            if(salesRep != null) { creditApp.SalesRep__c = salesRep.Id; }

            creditApp.Fleet_Size__c = 1;

            creditApp.Billing_Contact_First_Name__c = creditApp.First_Name__c;
            creditApp.Billing_Contact_Last_Name__c = creditApp.Last_Name__c;
            creditApp.Billing_Email__c = creditApp.Email__c;
            creditApp.Billing_Phone__c = creditApp.Business_Phone__c;
            creditApp.Billing_Mobile_Phone__c = creditApp.PG_Mobile_Phone__c;
            creditApp.Billing_Street_Address__c = creditApp.Business_Street_Address__c;
            creditApp.Billing_Address_Line_2__c = creditApp.Address_Line_2__c;
            creditApp.Billing_City__c = creditApp.City__c;
            creditApp.Billing_State__c = creditApp.State__c;
            creditApp.Billing_Zip_Code__c = creditApp.Zip_code__c;
            creditApp.Billing_Country__c = 'CA';

            creditApp.Signer_s_First_Name__c = creditApp.First_Name__c;
            creditApp.Signer_s_Last_Name__c = creditApp.Last_Name__c;
            creditApp.Signer_s_Email__c = creditApp.Email__c;
            creditApp.Signer_s_Phone__c = creditApp.Business_Phone__c;
            creditApp.signer_title__c = 'Self';

            creditApp.PG_Residential_Street_Address__c = creditApp.Business_Street_Address__c;
            creditApp.PG_Residential_City__c = creditApp.City__c;
            creditApp.PG_Residential_State__c = creditApp.State__c;
            creditApp.PG_Residential_Zip__c = creditApp.Zip_code__c;
            creditApp.Mobile_Phone__c = creditApp.PG_Mobile_Phone__c;
            creditApp.PG_Residential_Phone__c = creditApp.Business_Phone__c;

            creditApp.Legal_Structure__c = 'Natural Person';

            creditApp.isPG__c = true;

            creditApp.Group_Code__c = groupCode;
            if (merchantFacilityNumber != null && merchantFacilityNumber.length() < 15) creditApp.Merchant_Facility_Number__c = merchantFacilityNumber;
            
            // Set the status to TEST if it is a test, otherwise complete.
            // We don't want to test downstream triggers as part of this.
            // Testing downstream functionality is done via other test classes,
            // and this just throws a SOQL limit error otherwise. 
            if(TestUtils.isRunningTest()) {
                creditApp.status__c = 'test';
            }
            else {
                creditApp.status__c = 'complete';
            }
            
            System.debug('The credit application: ' + creditApp);
            
            // Upsert the credit application, then send the e-mail, and redirect to the confirmation page
            Database.UpsertResult result = Database.upsert(creditApp, false);
            if(result.isSuccess()){
                Id creditAppId = result.getId();
                
                System.debug('Credit App Id: ' + creditAppId);
                
                List<WeFormObject__c> confirmationContact = [SELECT Id, Confirmation_Contact_ID__c FROM WeFormObject__c WHERE Id =: creditAppId LIMIT 1];
                
                if(confirmationContact.size() > 0) {
                	sendConfirmationEmail(creditAppId, confirmationContact[0].Confirmation_Contact_ID__c, brandingUtility.Email_Template_ID__c);
				}

                PageReference wexBOCAConfirmation = Page.WexBOCAConfirmation;
                wexBOCAConfirmation.getParameters().put('pgm', programParameter);
                wexBOCAConfirmation.getParameters().put('id', creditAppId);
                wexBOCAConfirmation.getParameters().put('lang', languageCode);
                wexBOCAConfirmation.setRedirect(true);
                return wexBOCAConfirmation;

            }
            else {
                throw new creditappException(String.valueOf(result.getErrors()));
            }
        } catch (Exception e) {
            System.debug('Exception Encountered Submitting Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);
            
            PageReference wexBOCAError = Page.ExternalApplicationError;
            wexBOCAError.getParameters().put('errorCode', errorNumber);
            wexBOCAError.getParameters().put('pgm', programParameter);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;  
        }
        
    }
    
    @future
    public static void sendConfirmationEmail(Id creditAppId, Id contactId, Id templateId) {

        System.debug('### ' + creditAppId);
        System.debug('### ' + contactId);
        System.debug('### ' + templateId);
        
        Map<String, BOCA_IDs__c> bocaIdMap = new Map<String, BOCA_IDs__c>();
        
        bocaIdMap = BOCA_IDs__c.getAll();
        
        BOCA_IDs__c singleBocaId = new BOCA_IDs__c();
        
        String replyTo = '';
        
        if(!bocaIdMap.isEmpty()){
            singleBocaId = bocaIdMap.get('BOCA IDS');
            replyTo = String.valueOf(singleBocaId.get('Email_Address_Noreply__c'));
        }
        
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();
        
        confirmation.setTemplateId(templateId);
        confirmation.setWhatId(creditAppId); 
        confirmation.setTargetObjectId(contactId);
        confirmation.setSaveAsActivity(false);
        confirmation.setReplyTo(replyTo);
        
        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
        {
            if(owa.Address.contains(replyTo)) {
                confirmation.setOrgWideEmailAddressId(owa.id);                 
            }
        }
        
        if(!Test.isRunningTest()){
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                        confirmation
                });
            } catch (Exception e) {
                System.debug(e);
            }
        }
        
    }

}