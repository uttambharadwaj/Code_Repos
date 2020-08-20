public class WexBOCAController {

    public Beneficial_Owner_Settings__c beneficialOwnerSettings {
        get {
            return Beneficial_Owner_Settings__c.getOrgDefaults();
        }
    }

    // Credit application object
    public WeFormObject__c creditApp { get; set; }

    // Partial lead record object
    public Lead partialLeadRecord { get; set; }

    public String tmSessionId { get; set; }

    // Get Template
    public String currentPageName {
        get {
            String strurl = ApexPages.currentPage().getUrl();
            strurl = strurl.replaceFirst('/apex/','');
            strurl = EncodingUtil.urlEncode(strurl, 'UTF-8');
            string[] strurlExtra = strurl.split('%3F',0);
            strurl = strurlExtra[0];

            return strurl;
        }
    }

    // If this is a preview from the Program object
    public Boolean isPreview {
        get {
            if(ApexPages.CurrentPage().getParameters().get('preview') == 'true') {
                return true;
            }
            return false;
        }
    }

    // Check is this is a Personal Guaruntor application
    public Boolean isPG {
        get {
            String pg = ApexPages.currentPage().getParameters().get('pg');

            if(program.Always_Require_PG__c != null && program.Always_Require_PG__c == true) {
                return true;
            }

            if(pg != null) {
                if(pg == 'n' || languageCode.equalsIgnoreCase('fr_ca') || languageCode.equalsIgnoreCase('en_ca')) {
                    return false;
                }
                else if (pg == 'a') {
                    return true;
                }
                else if (pg == 'b' && creditApp.Years_in_Business__c != null) {
                    Boolean inBusinessOverYear = (creditApp.Years_in_Business__c).isNumeric();
                    if (!inBusinessOverYear) {
                        return true;
                    } else if (Integer.valueOf(creditApp.Years_in_Business__c) <= 3 && creditApp.Fleet_Size__c <= 5) {
                        return true;
                    }
                }
                else if ((program.BOCA_Type__c).equalsIgnoreCase('Revolver Card') || (creditApp != null && creditApp.Years_in_Business__c != null && (creditApp.Years_in_Business__c).isNumeric() == false)) {
                    return true;
                }
            }
            else if (languageCode.equalsIgnoreCase('fr_ca') || languageCode.equalsIgnoreCase('en_ca')) {
                return false;
            }
            else if ((program.BOCA_Type__c).equalsIgnoreCase('Revolver Card') || (creditApp != null && creditApp.Years_in_Business__c != null && (creditApp.Years_in_Business__c).isNumeric() == false)) {
                return true;
            }

            return false;

        }
    }

    // Check is this is a BOCA to Prospect
    public Boolean isPartial {
        get {
            Boolean partialApp = ApexPages.CurrentPage().getParameters().get('priority') != null ? true : false;
            return partialApp;
        }
    }

    // If BOCa to Prospect - get the WeForm ID
    public String partialCustomer {
        get {
            return ApexPages.CurrentPage().getParameters().get('customer');
        }
    }

    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

    // Get the coupon code, if supplied
    public String couponCodeParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('cc');
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
            return ApexPages.CurrentPage().getParameters().get('salescode');
        }
    }

    // Get the PG to log for the lead
    public String pgParameter  {
        get {
            return ApexPages.CurrentPage().getParameters().get('pg');
        }
    }

    // Get the PG to log for the lead
    public String groupCode  {
        get {
            return ApexPages.CurrentPage().getParameters().get('groupcode');
        }
    }

    // Get the Merchant Facility Number
    public String merchantFacilityNumber {
        get {
            return ApexPages.currentPage().getParameters().get('merchantFacilityNumber');
        }
    }

    public Id optyId {
        get {
            if (ApexPages.currentPage().getParameters().get('optyId') != null) {
                return ApexPages.currentPage().getParameters().get('optyId');
            }
            return null;
        }
    }

    // Get the PG to log for the lead
    public String leadIdParameter  {
        get {
            return ApexPages.CurrentPage().getParameters().get('leadId');
        }
    }

    public Lead passedInLead { get; set; }

    public List<Campaign_Pricing__c> revolverPricingList { get; set; }

    public Map<String, String> revolverPricing { get; set; }

    // Get the full URL for the page
    private String applicationURL {
        get {
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            string[] urlValExtra = urlVal.split('%3F',0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    public Boolean billingAddressSame { get; set; }

    // Program for the BOCA
    public Program__c program { get; set; }

    public Boolean financialCapture { get; set; }

    public Boolean requireFinancials {
        get {
            if (creditApp != null) {
                if (creditApp.Payment_Method__c != null && creditApp.Payment_Method__c.contains('ACH')) {
                    return true;
                }
            }
            return false;
        }
    }

    public Boolean isUpmarket {
        get {
            if (program != null) {
                return program.Use_Upmarket__c;
            }
            return false;
        }
    }

    public Boolean requireUpmarketFinancials {
        get {
            if (program != null) {
                return program.Require_Financial_Documents__c;
            }
            return false;
        }
    }

    // Language Code for the BOCA
    public String languageCode { get; set; }

    public String countryCode {
        get {
            if((languageCode).equalsIgnoreCase('en_ca') || (languageCode).equalsIgnoreCase('fr_ca')) {
                return 'CA';
            }
            return 'US';
        }
    }

    public List<SelectOption> paymentMethodOptions {
        get {
            return UtilityClass.multiSelectToBOCAPickList(program.Available_Payment_Methods__c);
        }
    }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    public Id defaultBrandingUtility {
        get {
            List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_Res__c WHERE Program__c = :program.Id and BOCA_Default__c = true];

            if(brandingUtilities.isEmpty()) {
                // If we don't get a default branding utility back, just return the first one in the list
                // This is for backwards compatability until we get the new field in place..
                List<BOCA_res__c> defaultBrandingUtility = [SELECT Id FROM BOCA_Res__c WHERE Program__c = :program.Id];
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

    public String statementAndReportDelivery { get; set; }

    public List<SelectOption> statementAndReportDeliveryOptions {
        get {
            List<SelectOption> options = new List<SelectOption>();

            options.add(new SelectOption('#', '-- Choose One --'));
            options.add(new SelectOption('Yes', 'Paperless Billing'));
            options.add(new SelectOption('No', 'Paper Billing By Mail'));

            return options;
        }
    }

    // Disclaimer related to the program
    public String disclaimer {
        get {
            StaticResource sr = null;

            // A lot of this will be able to be removed after we're
            // not having to support backwards compatability.. Path
            // of least resistance..
            if(isPG && !String.isEmpty(brandingUtility.PG_Disclosure__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name = :brandingUtility.PG_Disclosure__c];
            }
            else if(isPG) {
                sr = [SELECT Body FROM StaticResource WHERE Name = 'BOCA_PG_Disclaimer'];
            }
            else if(!String.isEmpty(brandingUtility.Default_Disclosure__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name = :brandingUtility.Default_Disclosure__c];
            }
            else if(!String.isEmpty(program.BOCA_Disclaimer__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name = :program.BOCA_Disclaimer__c];
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

            if(!String.isEmpty(brandingUtility.Terms_And_Conditions__c)) {
                sr = [select Body from StaticResource where Name =: brandingUtility.Terms_And_Conditions__c ];
            }
            else {
                sr = [select Body from StaticResource where Name =: program.T_C__c ];
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

    public DNBResolvedInformation dnbResolvedInformation { get; set; }

    public class DNBResolvedInformation {

        public String physicalAddress { get; set; }
        public String physicalAddressLine2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String dunsNumber { get; set; }

    }

    public WexBOCAController() {
        // Setup for the pagination
        minStep = 1;
        maxStep = 2;
        if(ApexPages.CurrentPage().getParameters().get('currentPage') != null) {
            currentStep = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('currentPage'));
        }
        else {
            currentStep = 1;
        }

        // This will always be the case, unless a Canadian
        // application is being filled out.
        billingAddressSame = true;

        dnbResolvedInformation = new DNBResolvedInformation();
    }

    public PageReference init() {

        PageReference wexBOCAError = null;

        if(String.isEmpty(programParameter)) {
            wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '1');
            wexBOCAError.setRedirect(true);
            return wexBOCAError;
        }
        else {

            // Setup the program
            List<Program__c> programs = [SELECT Id, Live_Person_Code__c, Publish_BOCA__c, Custom_Email_Header_URL__c,
                    Analytics_Body_Block__c, Analytics_Head_Block__c, Peoplesoft_rel_code__c,
                    Upload_Pricing_Data_Flag__c, T_C__c, Brand_Long_Name__c, BOCA_Disclaimer__c,
                    Inside_Sales_Phone_Number__c, Brand_Color_1__c, Brand_Color_2__c, Confirmation_Info__c, BOCA_Type__c, Always_Require_PG__c,
                    Financial_Institution_Capture__c, Use_Upmarket__c, Require_Financial_Documents__c, Available_Payment_Methods__c
            FROM Program__c WHERE Brand_Short_Name__c = :programParameter AND Form_Template__c = :currentPageName];

            // If we have a program, then set it, otherwise, redirect to error page
            if(!programs.isEmpty()) {

                if(programs[0].Publish_BOCA__c != true && isPreview != true) {
                    wexBOCAError = Page.WexBOCAError;
                    wexBOCAError.getParameters().put('errorCode', '1');
                    wexBOCAError.setRedirect(true);
                    return wexBOCAError;
                }
                else {
                    program = programs[0];
                    if (program.Financial_Institution_Capture__c == true) financialCapture = true;
                }
            }
            else {
                wexBOCAError = Page.WexBOCAError;
                wexBOCAError.getParameters().put('errorCode', '1');
                wexBOCAError.setRedirect(true);
                return wexBOCAError;
            }

            // Setup branding logo
            transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-logo.png'];
            brandingLogo = logo.Id;

            // Setup branding card image
            transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : program.Id AND Name=:'ui-credit-card.png'];
            brandingCard = card.Id;

            // Setup the branding utility if a language code was passed in
            if(ApexPages.CurrentPage().getParameters().get('lang') != null) {
                languageCode = (ApexPages.CurrentPage().getParameters().get('lang')).toLowerCase();

                List<BOCA_res__c> brandingUtilities = [SELECT Id FROM BOCA_res__c WHERE Program__c = :program.Id AND ISO_code__c = :languageCode];

                if(!brandingUtilities.isEmpty()) {
                    brandingUtility = [SELECT Id, Program_Name__c, Brand_Heading__c, Brand_Tagline__c,
                            PG_Disclosure__c, Terms_And_Conditions__c, Default_Disclosure__c,
                            Email_Template_ID__c, SideBar__c, Side_Panel_Title__c, ISO_code__c, Country_Code__c
                    FROM BOCA_res__c WHERE Id = :brandingUtilities[0].Id];
                }
            }

            // Default to the default branding utility if the language code was not found, or none was passed in
            if(brandingUtility == null) {
                brandingUtility = [SELECT Id, Program_Name__c, Brand_Heading__c, Brand_Tagline__c,
                        PG_Disclosure__c, Terms_And_Conditions__c, Default_Disclosure__c,
                        Email_Template_ID__c, SideBar__c, Side_Panel_Title__c, ISO_code__c, Country_Code__c
                FROM BOCA_res__c WHERE Id = :defaultBrandingUtility];

                languageCode = brandingUtility.ISO_code__c;
            }

            // Setup the campaign stuff via the coupon code if one is passed in
            if(!String.isEmpty(couponCodeParameter)) {
                List<Campaign> campaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Coupon_Code__c = :couponCodeParameter];

                // If we have a campaign - check to ensure
                // we have a campaign program also
                if(!campaigns.isEmpty()) {
                    List<Campaign_Program__c> campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions_Footer__c, Terms_and_Conditions_Header__c, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE program__c = :program.Id AND campaign__c = :campaigns[0].Id AND Language_Code__c = :languageCode];

                    if(campaignPrograms.isEmpty()) {
                        campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions_Footer__c, Terms_and_Conditions_Header__c, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE program__c = :program.Id AND campaign__c = :campaigns[0].Id];
                    }

                    // If we have a campaign program
                    // then set the campaign and campaignProgram
                    // to be the results..
                    if (!campaignPrograms.isEmpty()){
                        campaign = campaigns[0];
                        campaignProgram = campaignPrograms[0];

                        if(!String.isEmpty(campaignProgram.Terms_and_Conditions__c) || (!String.isEmpty(campaignProgram.Terms_and_Conditions_Header__c) && (!String.isEmpty(campaignProgram.Terms_and_Conditions_Footer__c)))) {
                            pricingTermsAndConditions = campaignProgram.Terms_and_Conditions__c;
                            pricingTermsAndConditionsHeader = campaignProgram.Terms_and_Conditions_Header__c;
                            pricingTermsAndConditionsFooter = campaignProgram.Terms_and_Conditions_Footer__c;
                        }
                        else {
                            pricingTermsAndConditions = [SELECT Id, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true and Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions__c;
                            pricingTermsAndConditionsHeader = [SELECT Id, Terms_and_Conditions_Header__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true and Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions_Header__c;
                            pricingTermsAndConditionsFooter = [SELECT Id, Terms_and_Conditions_Footer__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true and Language_Code__c = :languageCode LIMIT 1].Terms_and_Conditions_Footer__c;
                        }
                    }
                }

            }

            // Setup the default campaiwexbocagn and campaign program if they
            // weren't found via the coupon code
            if(campaign == null && campaignProgram == null) {
                List<Campaign_Program__c> defaultCampaignPrograms = [SELECT Id, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c, Campaign__c, Default__c, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Language_Code__c = :languageCode and Default__c = true];

                if(defaultCampaignPrograms.isEmpty()) {
                    defaultCampaignPrograms = [SELECT Id, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c, Campaign__c, Default__c, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true];
                }

                campaignProgram = defaultCampaignPrograms[0];
                pricingTermsAndConditions = campaignProgram.Terms_and_Conditions__c;
                pricingTermsAndConditionsHeader = campaignProgram.Terms_and_Conditions_Header__c;
                pricingTermsAndConditionsFooter = campaignProgram.Terms_and_Conditions_Footer__c;

                // Setup default campaign
                List<Campaign> defaultCampaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Id = :campaignProgram.Campaign__c];
                if(!defaultCampaigns.isEmpty()) {
                    campaign = defaultCampaigns[0];
                }
            }

            // Fetch the dynamic pricing for Revolver
            if((program.BOCA_Type__c).equalsIgnoreCase('Revolver Card') && program.Upload_Pricing_Data_Flag__c == true) {

                revolverPricingList = getCampaignPricing(program.Peoplesoft_rel_code__c, campaign.Coupon_Code__c);

                if(revolverPricingList.size() == 2){
                    Campaign_Pricing__c p1 = revolverPricingList.get(0);
                    Campaign_Pricing__c p2 = revolverPricingList.get(1);
                    SYSTEM.debug('pric 1: ' + p1.risk_code__c + 'pric 2: ' + p2.risk_code__c);
                    if(p1.risk_Code__c == '7'){
                        revolverPricing = formatPricing(revolverPricingList.get(0));
                    }
                    if(p2.risk_code__c == '7'){
                        revolverPricing = formatPricing(revolverPricingList.get(1));
                    }
                }
                else{
                    revolverPricing = formatPricing(revolverPricingList.get(0));
                }

            }

            // Check to see if it's a BOCA to Prospect - otherwise setup a new app
            if(isPartial && partialCustomer != null) {
                try{
                    creditApp = [SELECT togglePG__c, ABA_Routing_Number__c, Address_Line_2__c, Annual_Gross_Revenue__c,
                            Authorization__c, Authorization_agreement_Signature__c,
                            Authorize__c, Authorized_officer__c, Avg_Monthly_Fuel_Service_Expenses__c, Billing_Address_Line_2__c,
                            Billing_City__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Email__c, Billing_Fax__c,
                            Billing_Mobile_Phone__c, Billing_Phone__c, Billing_State__c, Billing_Street_Address__c, Billing_Zip_Code__c, Business_Phone__c,
                            Business_Street_Address__c, Business_fax__c, Campaign_Program_ID__c,  City__c, Company_Name__c,
                            DUNS_Number__c, Date_of_Birth__c, Day_of_Payment__c, Doing_Business_As__c,
                            Email__c, Employee_Id__c, Estimated_Monthly_Vehicle_Expenses__c, External_Sales_Id__c, Financial_Institution__c,
                            First_Name__c, Fiscal_Year_Starts__c, Fleet_Size__c, Guarantor_Annual_Income__c,
                            How_did_you_hear_about_this_offer__c, Id, IsDeleted, Is_business_exempt_from_Motor_Fuels_Tax__c,
                            Last_Name__c, Legal_Structure__c, Location_Code__c, Mobile_Phone__c, Name, Non_Std_Neg_Fee__c, Online_Application_Status__c, Opportunity__c,
                            Opportunity__r.Average_Monthly_Fueling__c, OwnerId, PG_Residential_City__c, PG_Residential_Phone__c, PG_Residential_State__c, PG_Residential_Street_Address__c,
                            PG_Residential_Zip__c, Paperless_Flag__c, Payment_Method__c, Program_Id__c, Program__c, Promotional_Code__c,
                            RecordTypeId, Sales_Id__c, Sales_Rep_Email__c, Sales_Rep_Phone__c, Same_as_Business_Address__c,
                            Signer_s_Email__c, Signer_s_First_Name__c, Signer_s_Last_Name__c, Signer_s_Phone__c, State__c,
                            Years_in_Business__c, Zip_code__c, isPG__c, message__c,
                            signer_title__c, status__c FROM WeFormObject__c WHERE Id =: partialCustomer LIMIT 1 ];

                    System.debug('Got the credit app: ' + creditApp.Id);

                    if(creditApp != null && ((creditApp.status__c).equalsIgnoreCase('partial') || (creditApp.status__c).equalsIgnoreCase('partner-partial'))) {
                        // Mappings to fix BOCA to Prospect
                        creditApp.Email__c = creditApp.Signer_s_Email__c;
                        creditApp.First_Name__c = creditApp.Signer_s_First_Name__c;
                        creditApp.Last_Name__c = creditApp.Signer_s_Last_Name__c;
                        creditApp.Business_Phone__c = creditApp.Signer_s_Phone__c;
                        creditApp.Address_Line_2__c = '';

                        if(creditApp.Avg_Monthly_Fuel_Service_Expenses__c == null && creditApp.Opportunity__c != null) {
                            creditApp.Avg_Monthly_Fuel_Service_Expenses__c = creditApp.Opportunity__r.Average_Monthly_Fueling__c;
                        }

                        if(creditApp.Years_in_Business__c == '0.5' || creditApp.Years_in_Business__c == '0') {
                            creditApp.Years_in_Business__c = 'Less than 12 months';
                        }
                    }
                    else if(creditApp != null && (creditApp.status__c).equalsIgnoreCase('bo-needed')) {
                        PageReference beneficialOwner = Page.BOCertification;
                        beneficialOwner.getParameters().put('weFormId', creditApp.Id);
                        beneficialOwner.getParameters().put('lang', languageCode);
                        beneficialOwner.setRedirect(true);
                        return beneficialOwner;
                    }
                    else {
                        // This clears up the dreaded "314 error" when someone tries to access the BOCA to Prospect
                        // twice after it's been submitted. This will instead send them to the confirmation page.
                        PageReference wexBOCAConfirmation = Page.WexBOCAConfirmation;
                        wexBOCAConfirmation.getParameters().put('pgm', programParameter);
                        wexBOCAConfirmation.getParameters().put('id', creditApp.Id);
                        wexBOCAConfirmation.setRedirect(true);
                        return wexBOCAConfirmation;
                    }
                }
                catch(Exception e) {
                    SYSTEM.debug('Problem accessing existing WeFormObject ' + e.getLineNumber() + ' ' + e);

                    String errorNumber = logError(e);

                    wexBOCAError = Page.WexBOCAError;
                    wexBOCAError.getParameters().put('errorCode', '3');
                    wexBOCAError.getParameters().put('errorReferenceNumber', errorNumber);
                    wexBOCAError.getParameters().put('pgm', programParameter);
                    wexBOCAError.setRedirect(true);
                    return wexBOCAError;
                }
            }
            else {
                creditApp = new WeFormObject__c();

                if((brandingUtility.ISO_code__c).equalsIgnoreCase('fr_ca')) {
                    creditApp.Communications_Preference__c = 'French';
                }
            }

            try {
                if(!String.isEmpty(leadIdParameter)) {
                    Lead lead = [SELECT Id, OwnerId, Owner.Type, Status, Lead_Converted_To_Opportunity__c, ConvertedOpportunityId FROM Lead WHERE Id = :leadIdParameter LIMIT 1];

                    if(lead != null) { passedInLead = lead; }
                }
            }
            catch(Exception e) { System.debug('Can\'t find lead.. Failing gracefully..');}


            if(salesCode != null) {
                List<User> u = new List<User>();

                try{
                    u = [SELECT Name, Id, email, phone, Sales_Code__c, fax FROM USER WHERE sales_code__c =: salesCode LIMIT 1];
                }
                catch(SYSTEM.DmlException ex){
                    SYSTEM.debug('Exception during Sales Rep lookup: ' + ex);
                }

                salesRep = (u.size() != 0) ? u.get(0) : null;
            }

            // Generate ThreatMetrix SessionID
            Datetime dt = Datetime.now();
            Long l = dt.getTime();

            String salt = EncodingUtil.convertToHex(crypto.generateAesKey(128));

            tmSessionId = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + ipAddress + salt.substring(0, 25))));

        }

        return null;

    }

    // For Revolver Card Dynamic pricing
    public List<Campaign_Pricing__c> getCampaignPricing(String peoplesoftRelationshipCode, String couponCode) {

        List<Campaign_Pricing__c> pricingList = [SELECT nbr_billing_cyles__c,contract_rate_pct__c,
                contract_margin__c, Contract_Rate_Type__c,
                coup_code__c, Coupon_Status__c, days_to_pay__c, fixed_late_fee__c,
                is_Active__c, late_fee_type__c, minimum_payment_percentage__c,over_limit_fee__c,
                paper_delivery_fee__c,pct_late_fee__c, pen_rate_pct__c, penalty_margin__c,
                penalty_rate_ceiling__c, Penalty_Rate_Type__c, prime_rate__c,prime_rate_effective_date__c,
                promo_add_prime__c, promo_periods__c, promotional_rate__c, Peoplesoft_rel_code__c,
                return_payment_fee__c, risk_code__c
        FROM Campaign_Pricing__c
        WHERE Peoplesoft_rel_code__c = :peoplesoftRelationshipCode
        and coup_code__c = :couponCode];
        if(pricingList.size() > 0) {
            return pricingList;
        }
        else {
            return null;
        }

    }

    public Map<String, String> formatPricing(Campaign_Pricing__c campaignPricing){
        Map<String, String> pricing = new Map<String, String>();
        String rate = ' ';
        String penRate = ' ';
        String primeDate = ' ';
        String lateFee = ' ';
        String retFee = ' ';
        String paperFee = ' ';
        String ovrLimFee = ' ';

        //test condition for rate
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.contract_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Variable'))){
            rate = 'Prime + ' + campaignPricing.contract_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.contract_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            rate = campaignPricing.contract_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.contract_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Variable'))){
            rate = 'Up to Prime + ' + campaignPricing.contract_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.contract_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            rate = 'Up to ' + campaignPricing.contract_rate_pct__c + '%';
        }

        //test condition for penalty
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Variable'))){
            penRate = 'Prime + ' + campaignPricing.pen_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            penRate = campaignPricing.pen_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Variable'))){
            penRate = 'Up to Prime + ' + campaignPricing.pen_rate_pct__c + '%';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            penRate = 'Up to ' + campaignPricing.pen_rate_pct__c + '%';
        }

        //Test condition for Prime Rate Effective Date
        if((campaignPricing.contract_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Variable')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('Y')) &&
                campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Variable')){
            primeDate = 'Variable rates are based on the Prime Rate as of ' + campaignPricing.prime_rate_effective_date__c.format();
        }
        if((campaignPricing.contract_margin__c.equalsIgnoreCase('Y')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Variable')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('N')) &&
                campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed')){
            primeDate = 'Variable rates are based on the Prime Rate as of ' + campaignPricing.prime_rate_effective_date__c.format();
        }
        if((campaignPricing.contract_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Fixed')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('Y')) &&
                campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Variable')){
            primeDate = 'Variable rates are based on the Prime Rate as of  ' + campaignPricing.prime_rate_effective_date__c.format();
        }
        if((campaignPricing.contract_margin__c.equalsIgnoreCase('N')) && (campaignPricing.Contract_Rate_Type__c.equalsIgnoreCase('Fixed')) && (campaignPricing.penalty_margin__c.equalsIgnoreCase('N')) &&
                campaignPricing.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed')){
            primeDate = 'N/A';
        }

        //Test Condition For Fixed Late Fee
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.late_fee_type__c.equalsIgnoreCase('P'))){
            lateFee = campaignPricing.pct_late_fee__c + '% of the account balance';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('No')) && (campaignPricing.late_fee_type__c.equalsIgnoreCase('F'))){
            lateFee = '$' + campaignPricing.fixed_late_fee__c;
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.late_fee_type__c.equalsIgnoreCase('P'))){
            lateFee = 'Up to '+ campaignPricing.pct_late_fee__c + '% of the account balance';
        }
        if((campaignPricing.risk_code__c.equalsIgnoreCase('7')) && (campaignPricing.late_fee_type__c.equalsIgnoreCase('F'))){
            lateFee = 'Up to $'+ campaignPricing.fixed_late_fee__c;
        }

        //Test for retFee, paperFee, and ovrLimFee
        if(campaignPricing.risk_code__c.equalsIgnoreCase('No')){
            retFee = '$' + campaignPricing.return_payment_fee__c + ' per occurrence';
            paperFee = '$' + campaignPricing.paper_delivery_fee__c + ' per month for paper statement and reporting';
            ovrLimFee = '$' + campaignPricing.over_limit_fee__c + ' per occurrence';
        }
        if(campaignPricing.risk_code__c.equalsIgnoreCase('7')){
            retFee = 'Up to $' + campaignPricing.return_payment_fee__c + ' per occurrence';
            paperFee = 'Up to $' + campaignPricing.paper_delivery_fee__c + ' per month for paper statement and reporting';
            ovrLimFee = 'Up to $' + campaignPricing.over_limit_fee__c + ' per occurrence';
        }
        //Add Key/Value pairs
        pricing.put('Annual Percentage Rate (APR) for Purchases: ', rate);
        if(campaignPricing.promo_periods__c != 0){
            pricing.put('Introductory APR for Purchases: ', campaignPricing.promotional_rate__c + '% introductory APR for ' + campaignPricing.nbr_billing_cyles__c + '  cycles after account opening.');
        }
        pricing.put('Penalty APR: ', penRate);
        //check for N/A on Prime
        if(primeDate != 'N/A'){
            pricing.put('Prime Rate: ', primeDate);
        }
        pricing.put('Paper Delivery Fee: ', paperFee);
        pricing.put('Late Payment Fee: ', lateFee);
        pricing.put('Overlimit Fee: ', ovrLimFee);
        pricing.put('Returned Payment Fee: ', retFee);

        return pricing;
    }

    // Refactored as part of BOCDD
    // - Added Lead to WeFormObject
    // - Reversed logic to create lead first, then attach to WeFormObject
    public PageReference createLead() {

        PageReference wexBOCAError = null;

        // We don't want to create a lead if it is
        // from BOCA to Prospect
        if(!isPartial && passedInLead == null) {

            try {

                String backgroundNotes = '';

                partialLeadRecord = new Lead();

                partialLeadRecord.FirstName = creditApp.First_Name__c;
                partialLeadRecord.LastName = creditApp.Last_Name__c;
                partialLeadRecord.Phone = creditApp.Business_Phone__c;
                partialLeadRecord.Email = creditApp.Email__c;
                partialLeadRecord.Status = 'Untouched';
                partialLeadRecord.LeadSource = 'Web Partial';
                partialLeadRecord.Campaign_Program__c = campaignProgram.Id;
                partialLeadRecord.Primary_Campaign__c = campaign.Id;
                partialLeadRecord.Company = creditApp.Company_Name__c;
                partialLeadRecord.Fleet_Size__c = creditApp.Fleet_Size__c;
                partialLeadRecord.Campaign_Response_Methods__c = 'Online App';
                if(creditApp.Doing_Business_As__c != null && creditApp.Doing_Business_As__c != '') {
                    backgroundNotes = 'Doing Business As: ' + creditApp.Doing_Business_As__c;
                }
                partialLeadRecord.qRouting__c = 'WebPartialApp1';
                partialLeadRecord.Site_Location__c = locationCode;
                if(creditApp.Years_in_Business__c == 'Less than 12 months') {
                    partialLeadRecord.Years_in_Business__c = Decimal.valueOf('0.5');
                }
                else {
                    partialLeadRecord.Years_in_Business__c = Decimal.valueOf(creditApp.Years_in_Business__c);
                }

                String pgState = '';

                if(pgParameter == 'n') {
                    pgState = 'PG not presented on app for all applicants';
                }
                else if(pgParameter == 'a') {
                    pgState = 'PG Requested on app for all applicants';
                }
                else if(creditApp.Years_in_Business__c == 'Less than 12 months' || pgParameter == 'c') {
                    pgState = 'PG Requested on app for less than 12 months in business';
                }

                if(!String.isEmpty(pgState)) {
                    if(!String.isEmpty(backgroundNotes)) {
                        backgroundNotes += ', ';
                    }
                    backgroundNotes += 'PG Information: ' + pgState;
                }

                partialLeadRecord.Description = backgroundNotes;

                Database.upsertResult leadResult = Database.upsert(partialLeadRecord, false);
                if(leadResult.isSuccess()){
                    System.debug('Created Lead: ' + partialLeadRecord.Id);

                    creditapp.Lead__c = partialLeadRecord.Id;
                    creditApp.status__c = 'lead';
                    creditApp.Communications_Preference__c = brandingUtility.ISO_code__c.equalsIgnoreCase('fr_ca') ? 'French' : 'English';

                    creditApp.TM_Session_ID__c = tmSessionId;

                    Database.upsertResult creditAppResult = Database.upsert(creditapp, false);
                    if(creditAppResult.isSuccess()){
                        System.debug('Credit Application Saved');
                    }
                }

            }
            catch (Exception e) {
                System.debug('Exception Encountered Creating Lead: ' + e.getStackTraceString() + ' ' + e);

                String errorNumber = logError(e);

                wexBOCAError = Page.WexBOCAError;
                wexBOCAError.getParameters().put('errorCode', '2');
                wexBOCAError.getParameters().put('errorReferenceNumber', errorNumber);
                wexBOCAError.getParameters().put('pgm', programParameter);
                wexBOCAError.setRedirect(true);
                return wexBOCAError;
            }

        }

        currentStep = currentStep + 1;

        return null;

    }

    public class creditappException extends Exception {}

    public PageReference submitApplication() {

        try {

            // Determining if the legal structure is exempted from BOCDD
            Boolean isBOExempt = false;

            for(Beneficial_Owner_Exemption__mdt exemption : [SELECT Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c =: countryCode]) {

                if((creditApp.Legal_Structure__c).equalsIgnoreCase(exemption.Legal_Structure__c)) {
                    isBOExempt = true;
                }

            }

            // If they're not exempt, then we're going to
            // add additional notes to the Lead from the BOCA incase
            // they abandon at the BO certification form
            if(isBOExempt == false && partialLeadRecord != null) {
                String backgroundNotes = partialLeadRecord.Description;

                partialLeadRecord.Legal_Structure__c = creditApp.Legal_Structure__c;
                if(!String.isEmpty(backgroundNotes)) {
                    backgroundNotes += ', ';
                }
                backgroundNotes += 'Stopped At Beneficial Owner Form';

                partialLeadRecord.Description = backgroundNotes;
                partialLeadRecord.qRouting__c = 'WebPartialApp2';

                upsert partialLeadRecord;
            }

            // Need to review why this is.. Maybe just need to set defaults on the picklists?
            if(brandingUtility.Country_Code__c != null) {
                creditApp.Country__c = brandingUtility.Country_Code__c;
                creditApp.Billing_Country__c = brandingUtility.Country_Code__c;
            }
            else {
                creditApp.Country__c = 'US';
                creditApp.Billing_Country__c = 'US';
            }

            // Additional mappings to satisfy the trigger - Need to fix
            if(billingAddressSame) {

                creditApp.Billing_Contact_First_Name__c = creditApp.First_Name__c;
                creditApp.Billing_Contact_Last_Name__c = creditApp.Last_Name__c;
                creditApp.Billing_Email__c = creditApp.Email__c;
                creditApp.Billing_Phone__c = creditApp.Business_Phone__c;

                creditApp.Billing_Street_Address__c = creditApp.Business_Street_Address__c;

                if(!String.isEmpty(creditApp.Address_Line_2__c)) {
                    creditApp.Billing_Address_Line_2__c = creditApp.Address_Line_2__c;
                }

                creditApp.Billing_City__c = creditApp.City__c;
                creditApp.Billing_State__c = creditApp.State__c;
                creditApp.Billing_Zip_Code__c = creditApp.Zip_code__c;

            }

            // Lead functionality for MVF to attach the Sales Rep
            // on either the lead or converted lead to the application
            // for attribution
            try {
                // Add the Sales Rep to the WeFormObject
                if(passedInLead != null) {
                    if(passedInLead.ConvertedOpportunityId != null) {
                        creditApp.Opportunity__c = passedInLead.ConvertedOpportunityId;
                        creditApp.SalesRep__c = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :passedInLead.ConvertedOpportunityId LIMIT 1].OwnerId;
                    }
                    else {
                        if(passedInLead.OwnerId != null) {
                            if(passedInLead.OwnerId.getSObjectType() == User.SObjectType) {
                                creditApp.SalesRep__c = passedInLead.OwnerId;
                            }
                        }
                    }
                }
            }
            catch(Exception e) { System.debug('Can\'t attach.. Failing gracefully..'); }

            try {
                if (!String.isEmpty(optyId)) {
                    creditApp.Opportunity__c = optyId;
                }
            } catch (Exception e) {
                System.debug('Unable to attach passed in opportunity: ' + e);
            }

            if(languageCode.equalsIgnoreCase('fr_ca') || languageCode.equalsIgnoreCase('en_ca')) { creditApp.Paperless_Flag__c = 'Yes'; }

            creditApp.Signer_s_First_Name__c = creditApp.First_Name__c;
            creditApp.Signer_s_Last_Name__c = creditApp.Last_Name__c;
            creditApp.Signer_s_Email__c = creditApp.Email__c;
            creditApp.Signer_s_Phone__c = creditApp.Business_Phone__c;

            if((program.Boca_Type__c).equalsIgnoreCase('Revolver Card')) {
                if(statementAndReportDelivery != null && statementAndReportDelivery.equalsIgnoreCase('Paperless Billing')) {
                    creditApp.Paperless_Flag__c = 'Yes';
                }
                else {
                    creditApp.Paperless_Flag__c = 'No';
                }
            }

            // Additional information
            creditApp.Confirmation_Email_Sent__c = false;
            creditApp.Confirmation_Email_Template__c = brandingUtility.Email_Template_ID__c;
            creditApp.Branding_Utility__c = brandingUtility.id;
            creditApp.IPAddress__c = ipAddress;
            creditApp.TM_Session_ID__c = tmSessionId;
            creditApp.Location_Code__c = locationCode;
            creditApp.Program__c = program.Id;
            creditApp.Program_Id__c = program.Id;
            creditApp.Campaign_Program_ID__c = campaignProgram.Id;
            if(salesRep != null) { creditApp.salesRep__c = salesRep.Id; }

            creditApp.Group_Code__c = groupCode;
            if (merchantFacilityNumber != null && merchantFacilityNumber.length() < 15) creditApp.Merchant_Facility_Number__c = merchantFacilityNumber;

            // Set the PG flag if it is true
            if(isPG) {
                creditApp.isPG__c = true;
            }

            // I shouldn't even have to..
            //creditApp.RecordTypeId = null;

            // Set the status to TEST if it is a test, otherwise complete.
            // We don't want to test downstream triggers as part of this.
            // Testing downstream functionality is done via other test classes,
            // and this just throws a SOQL limit error otherwise.
            if(TestUtils.isRunningTest()) {
                creditApp.status__c = 'test';
            }
            else if(!isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {
                creditApp.status__c = 'bo-needed';
            }
            else {
                creditApp.status__c = 'complete';
            }

            System.debug('The credit application: ' + creditApp);

            // Upsert the credit application, then send the e-mail, and redirect to the confirmation page
            Database.upsertResult result = Database.upsert(creditApp);
            if(result.isSuccess()){
                Id creditAppId = result.getId();

                System.debug('Credit App Id: ' + creditAppId);

                // Convert the passed in lead and relate it back to the weform account, contact, and opportunity.
                if (passedInLead != null && passedInLead.ConvertedOpportunityId == null) {

                    WeFormObject__c weForm = [
                            SELECT Id, Opportunity__r.AccountId, Opportunity__r.Primary_Contact__c, Opportunity__c
                            FROM WeFormObject__c
                            WHERE Id = :creditAppId
                    ];

                    if (weForm.Opportunity__c != null) {
                        UtilityClass.convertPassedInLead(passedInLead.Id, weForm.Opportunity__r.AccountId, weForm.Opportunity__r.Primary_Contact__c, weForm.Opportunity__c, null);
                    }
                }

                if((creditApp.Status__c).equalsIgnoreCase('bo-needed')) {
                    PageReference beneficialOwner = Page.BOCertification;
                    beneficialOwner.getParameters().put('weFormId', creditAppId);
                    beneficialOwner.getParameters().put('pgm', programParameter);
                    beneficialOwner.getParameters().put('lang', languageCode);
                    beneficialOwner.setRedirect(true);
                    return beneficialOwner;

                } else if (isUpmarket && requireUpmarketFinancials) {
                    PageReference wexBOCAFinancials = Page.WexBOCAFinancials;
                    wexBOCAFinancials.getParameters().put('id', creditAppId);
                    wexBOCAFinancials.getParameters().put('pgm', programParameter);
                    wexBOCAFinancials.getParameters().put('lang', languageCode);
                    wexBOCAFinancials.setRedirect(true);
                    return wexBOCAFinancials;

                } else {
                    PageReference wexBOCAConfirmation = Page.WexBOCAConfirmation;
                    wexBOCAConfirmation.getParameters().put('pgm', programParameter);
                    wexBOCAConfirmation.getParameters().put('id', creditAppId);
                    wexBOCAConfirmation.getParameters().put('lang', languageCode);
                    wexBOCAConfirmation.setRedirect(true);
                    return wexBOCAConfirmation;
                }

            }
            else {
                throw new creditappException(String.valueOf(result.getErrors()));
            }

        } catch (Exception e) {

            System.debug('Exception Encountered Submitting Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = logError(e);

            PageReference wexBOCAError = Page.WexBOCAError;
            wexBOCAError.getParameters().put('errorCode', '2');
            wexBOCAError.getParameters().put('errorReferenceNumber', errorNumber);
            wexBOCAError.getParameters().put('pgm', programParameter);
            wexBOCAError.setRedirect(true);
            return wexBOCAError;

        }

        return null;
    }

    private String logError(Exception e) {
        try {
            External_Application_Error__c error = new External_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCA';
            error.Application_URL__c = applicationURL;

            insert error;

            List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }
        }
        catch(Exception f) {
            System.debug('Error logging exception.. Skipping..');

            return '';
        }
    }

}