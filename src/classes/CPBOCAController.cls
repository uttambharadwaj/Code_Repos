/*
*
*   Revision History:   26/AUG/2019     MFarrell    LRC-97      Added donothing method and isUpMarket boolean.
*
*/

public class CPBOCAController {

    // Credit application object
    public CP_Application_Request__c creditApp { get; set; }

    // Partial lead record object
    public Lead partialLeadRecord { get; set; }

    public String tmSessionId { get; set; }

    public String selectedCurrency { get; set; }

    public List<SelectOption> currencyOptions {
        get {
            Set<String> allowedCurrency = new Set<String>{'AUD','CAD','EUR','GBP'};
            List<SelectOption> myOptions = new List<SelectOption>();
            Schema.DescribeFieldResult currencies = Opportunity.CurrencyIsoCode.getDescribe();
            myOptions.add(new SelectOption('USD','USD'));
            for(Schema.PicklistEntry currencyOption : currencies.getPicklistValues()){
                if(allowedCurrency.contains(currencyOption.getValue()))
                    myOptions.add(new SelectOption(currencyOption.getValue(), currencyOption.getValue()));
            }
            return myOptions;
        }
    }

    public List<SelectOption> countryOptions {
        get {
            List<SelectOption> myOptions = new List<SelectOption>();
            Schema.DescribeFieldResult countries = Account.Legal_Entity_Country__c.getDescribe();
            myOptions.add(new SelectOption('','-- Choose One --'));
            for(Schema.PicklistEntry countryOption : countries.getPicklistValues()){
                myOptions.add(new SelectOption(countryOption.getValue(), countryOption.getValue()));
            }
            return myOptions;
        }
    }

    //have to get states from a different field on a different object bc our legal state needs to be free text for sales reps bc why do things right when we can do them fast
    public List<SelectOption> stateOptions {
        get {
            List<SelectOption> myOptions = new List<SelectOption>();
            Set<String> provinces = new Set<String>{'AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'};
            Schema.DescribeFieldResult states = OnlineApplication__c.State__c.getDescribe();
            myOptions.add(new SelectOption('','-- Choose One --'));
            for(Schema.PicklistEntry stateOption : states.getPicklistValues()){
                if(selectedCountry == 'CA' && provinces.contains(stateOption.getValue()))
                    myOptions.add(new SelectOption(stateOption.getValue(), stateOption.getValue()));
                else if(selectedCountry == 'US' && !provinces.contains(stateOption.getValue()))
                    myOptions.add(new SelectOption(stateOption.getValue(), stateOption.getValue()));
            }
            return myOptions;
        }
    }

    public String selectedCountry {get;set;}

    public String selectedState {get;set;}

    public String userSessionId {
        get {
            return UserInfo.getSessionId();
        }
    }

    public List<SelectOption> countryOptions {
        get {
            List<SelectOption> myOptions = new List<SelectOption>();
            Schema.DescribeFieldResult countries = Account.Legal_Entity_Country__c.getDescribe();
            myOptions.add(new SelectOption('','-- Choose One --'));
            for(Schema.PicklistEntry countryOption : countries.getPicklistValues()){
                myOptions.add(new SelectOption(countryOption.getValue(), countryOption.getValue()));
            }
            return myOptions;
        }
    }

    //have to get states from a different field on a different object bc our legal state needs to be free text for sales reps bc why do things right when we can do them fast
    public List<SelectOption> stateOptions {
        get {
            List<SelectOption> myOptions = new List<SelectOption>();
            Set<String> provinces = new Set<String>{'AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'};
            Schema.DescribeFieldResult states = OnlineApplication__c.State__c.getDescribe();
            myOptions.add(new SelectOption('','-- Choose One --'));
            for(Schema.PicklistEntry stateOption : states.getPicklistValues()){
                if(selectedCountry == 'CA' && provinces.contains(stateOption.getValue()))
                    myOptions.add(new SelectOption(stateOption.getValue(), stateOption.getValue()));
                else if(selectedCountry == 'US' && !provinces.contains(stateOption.getValue()))
                    myOptions.add(new SelectOption(stateOption.getValue(), stateOption.getValue()));
            }
            return myOptions;
        }
    }

    public String selectedCountry {get;set;}

    public String selectedState {get;set;}

    public Boolean showTNC{
        get{
            if(UserInfo.getSessionId() == null && (!ApexPages.CurrentPage().getParameters().containsKey('tnc') || ApexPages.CurrentPage().getParameters().get('tnc') != '000')) return true;
            return false;
        }
    }

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

    // Get the PG to log for the lead
    public String leadIdParameter  {
        get {
            return ApexPages.CurrentPage().getParameters().get('leadId');
        }
    }

    public Lead passedInLead { get; set; }

    public List<Campaign_Pricing__c> revolverPricingList { get; set; }

    public Map<String, String> revolverPricing { get; set; }

    public Beneficial_Owner_Settings__c beneficialOwnerSettings {
        get {
            return Beneficial_Owner_Settings__c.getOrgDefaults();
        }
    }

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

    private String applicationViewState {
        get {
            return Apexpages.currentPage().getUrl();
        }
    }

    public Boolean billingAddressSame { get; set; }

    public Boolean isBankInfoNeeded {
        get {
            if (creditApp != null) {
                if (null != creditApp.Payment_Type__c && creditApp.Payment_Type__c.equalsIgnoreCase('ET')) {
                    return true;
                }
            }
            return false;
        }
    }

    public Boolean isUpMarket {
        get {
            if (creditApp != null) {
                if (creditApp.Projected_Monthly_Spend__c >= 150000) {
                    return true;
                }
            }
            return false;
        }
    }

    public void doNothing() {

    }

    // Program for the BOCA
    public Program__c program { get; set; }

    // Language Code for the BOCA
    public String languageCode { get; set; }



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

    // Check is Personal Guarantor information required
    public Boolean isPGRequired {
        get {

            if(creditApp != null) {
                Date rightNow = Date.today();

                if (creditApp.Years_in_Business__c != null && creditApp.Years_in_Business__c.equalsIgnoreCase('Less than 12 Months')) {

                    return true;
                }
            }
            return false;
        }
    }

    // Set the defaults for payment fields with dependent picklist values
    public void setPaymentDefaults() {

        if (creditApp != null) {
            if (creditApp.Billing_Cycle__c != null && (creditApp.Billing_Cycle__c).equalsIgnoreCase('Weekly')) {
                creditApp.Payment_Due_Date__c = 'Monday';
            }
            else if (creditApp.Billing_Cycle__c != null && (creditApp.Billing_Cycle__c).equalsIgnoreCase('Monthly')) {
                creditApp.Payment_Due_Date__c = '1st';
            }
            creditApp.Payment_Type__c = 'ET';
        }
    }

    // Disclaimer related to the program
    public String disclaimer {
        get {
            StaticResource sr = null;

            // A lot of this will be able to be removed after we're
            // not having to support backwards compatability.. Path
            // of least resistance..
            if(brandingUtility != null && !String.isEmpty(brandingUtility.Default_Disclosure__c)) {
                sr = [SELECT Body FROM StaticResource WHERE Name = :brandingUtility.Default_Disclosure__c];
            }
            else if(program != null && !String.isEmpty(program.BOCA_Disclaimer__c)) {
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

            if(brandingUtility != null && !String.isEmpty(brandingUtility.Terms_And_Conditions__c)) {
                sr = [select Body from StaticResource where Name =: brandingUtility.Terms_And_Conditions__c ];
            }
            else if(program != null) {
                sr = [select Body from StaticResource where Name =: program.T_C__c ];
            }

            if(sr != null) {
                return sr.Body.toString();
            }

            return null;
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

    public CPBOCAController() {
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
            selectedCountry = 'US';
            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

            if(programId != null) {

                program = WexBrandingController.getProgram(programId);

                Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);

                if(brandingUtilityId != null) {

                    brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                }

                brandingLogo = WexBrandingController.getLogoId(programId);

                brandingCard = WexBrandingController.getCreditCardImageId(programId);

                // Setup the campaign stuff via the coupon code if one is passed in
                if(program != null && !String.isEmpty(couponCodeParameter)) {
                    List<Campaign> campaigns = [SELECT Id, Coupon_Code__c FROM Campaign WHERE Coupon_Code__c = :couponCodeParameter];

                    // If we have a campaign - check to ensure
                    // we have a campaign program also
                    if(!campaigns.isEmpty()) {
                        List<Campaign_Program__c> campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions__c, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c  FROM Campaign_Program__c WHERE program__c = :program.Id AND campaign__c = :campaigns[0].Id AND Language_Code__c = :languageCode];

                        if(campaignPrograms.isEmpty()) {
                            campaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions__c, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c FROM Campaign_Program__c WHERE program__c = :program.Id AND campaign__c = :campaigns[0].Id];
                        }

                        // If we have a campaign program
                        // then set the campaign and campaignProgram
                        // to be the results..
                        if (!campaignPrograms.isEmpty()){
                            campaign = campaigns[0];
                            campaignProgram = campaignPrograms[0];

                            if(!String.isEmpty(campaignProgram.Terms_and_Conditions__c)) {
                                pricingTermsAndConditions = campaignProgram.Terms_and_Conditions__c;
                                pricingTermsAndConditionsHeader = campaignProgram.Terms_and_Conditions_Header__c;
                                pricingTermsAndConditionsFooter = campaignProgram.Terms_and_Conditions_Footer__c;
                            }
                            else {
                                pricingTermsAndConditions = [SELECT Id, Terms_and_Conditions__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true].Terms_and_Conditions__c;
                                pricingTermsAndConditionsHeader = [SELECT Id, Terms_and_Conditions_Header__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true].Terms_and_Conditions_Header__c;
                                pricingTermsAndConditionsFooter = [SELECT Id, Terms_and_Conditions_Footer__c  FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true].Terms_and_Conditions_Footer__c;
                            }
                        }
                    }

                }

                // Setup the default campaign and campaign program if they
                // weren't found via the coupon code
                if(program != null && campaign == null && campaignProgram == null) {
                    List<Campaign_Program__c> defaultCampaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions__c, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c FROM Campaign_Program__c WHERE Program__c = :program.Id and Language_Code__c = :languageCode and Default__c = true];

                    if(defaultCampaignPrograms.isEmpty()) {
                        defaultCampaignPrograms = [SELECT Id, Campaign__c, Default__c, Terms_and_Conditions__c, Terms_and_Conditions_Header__c, Terms_and_Conditions_Footer__c FROM Campaign_Program__c WHERE Program__c = :program.Id and Default__c = true];
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

            }

            // Check to see if it's a BOCA to Prospect - otherwise setup a new app
            if(partialCustomer != null) {
                try{
                    creditApp = [SELECT Id, Account__c, Opportunity__c, Company_Legal_Name__c, Doing_Business_As__c, Years_In_Business__c, Credit_Line_Requested__c,
                            Physical_Address_Line_1__c, Physical_Address_Line_2__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, Physical_Country__c,
                            Taxpayer_ID__c, DUNS_Number__c, Email__c, Guarantor_First_Name__c, Guarantor_Last_Name__c, Guarantor_Residential_Address__c, Business_Phone__c,
                            Guarantor_Residential_City__c, Guarantor_Residential_State__c, Guarantor_Residential_Postal_Code__c, Guarantor_Country__c,
                            Guarantor_Social_Security_Number__c, Guarantor_Date_of_Birth__c, Guarantor_Residential_Phone__c, Guarantor_Mobile_Phone__c,
                            Beneficial_Owner_Entity__c, Beneficial_Owner_Status__c, Application_Stage__c, Status__c, Credit_Decision__c, Credit_Line_Approved__c,
                            ThreatMetrix_Session_ID__c, ThreatMetrix_Result__c, DNB_SBRI_Score__c, DNB_Lookup_Hits__c, Number_Of_Existing_Applications__c,
                            Number_of_Existing_Accounts__c, Lexis_Nexis_Check__c, DNB_SBRI_Check__c, Existing_Exposure_Check__c, ThreatMetrix_Check__c, Legal_Structure__c,
                            Credit_Line_Recommendation__c, Credit_Decision_Recommendation__c, First_Name__c, Last_Name__c, Bank_Contact_Phone__c, Bank_Contact__c,
                            Projected_Monthly_Spend__c, Billing_Cycle__c
                    FROM CP_Application_Request__c WHERE Id =: partialCustomer and Application_Stage__c = 'Application' and Status__c = 'Sent to Prospect' LIMIT 1 ];

                    System.debug('Got the credit app: ' + creditApp.Id);

                }
                catch(Exception e) {
                    System.debug('Problem accessing existing WeFormObject ' + e.getLineNumber() + ' ' + e);

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
                creditApp = new CP_Application_Request__c();
            }

            if (creditApp != null && brandingUtility != null) {
                creditApp.Physical_Country__c = brandingUtility.Country_Code__c;
            }

            if(salesCode != null) {
                List<User> u = new List<User>();

                try{
                    u = [SELECT Name, Id, email, phone, Sales_Code__c, fax FROM USER WHERE sales_code__c =: salesCode LIMIT 1];
                }
                catch(SYSTEM.DmlException ex){
                    System.debug('Exception during Sales Rep lookup: ' + ex);
                }

                salesRep = (u.size() != 0) ? u.get(0) : null;
            }

            // Generate ThreatMetrix SessionID
            Datetime dt = Datetime.now();
            Long l = dt.getTime();

            String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

            tmSessionId = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + ipAddress + salt.substring(0, 25))));

            creditApp.ThreatMetrix_Session_ID__c = tmSessionId;

            creditApp.Mailing_Country__c = 'US';
            creditApp.Guarantor_Country__c = 'US';

            selectedCurrency = 'USD';
        }

        return null;

    }

    public PageReference createLead() {

        PageReference wexBOCAError = null;

        // We don't want to create a lead if it is
        // from BOCA to Prospect
        if(!isPartial) {

            creditApp.Application_Stage__c = 'Application';
            creditApp.Status__c = 'Application Incomplete';

            try {

                upsert creditApp;

                System.debug('Created CP_Application_Request__c: ' + creditApp.Id);

                if(!String.isEmpty(creditApp.Id) && passedInLead == null) {

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
                    partialLeadRecord.Company = creditApp.Company_Legal_Name__c;
                    partialLeadRecord.Campaign_Response_Methods__c = 'Online App';
                    if(creditApp.Doing_Business_As__c != null && creditApp.Doing_Business_As__c != '') {
                        backgroundNotes = 'Doing Business As: ' + creditApp.Doing_Business_As__c;
                    }
                    partialLeadRecord.qRouting__c = 'WebPartialApp';
                    partialLeadRecord.Site_Location__c = locationCode;
                    if(creditApp.Years_in_Business__c.equalsIgnoreCase('Less than 12 Months')) {
                        partialLeadRecord.Years_in_Business__c = Decimal.valueOf('0.5');
                    }
                    else {
                        partialLeadRecord.Years_in_Business__c = Integer.valueOf(creditApp.Years_in_Business__c);
                    }
                    partialLeadRecord.Total_Cards_Requested__c = creditApp.Number_of_Cards__c;

                    partialLeadRecord.Description = backgroundNotes;

                    Database.upsertResult result = Database.upsert(partialLeadRecord, false);
                    if(result.isSuccess()){
                        System.debug('Created Lead: ' + partialLeadRecord.Id);
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

    public class creditApplicationException extends Exception {}

    public PageReference submitApplication() {

        System.debug('in SubmitApplication method');

        try {

            if(billingAddressSame) {
                creditApp.Mailing_Address_Line_1__c = creditApp.Physical_Address_Line_1__c;
                creditApp.Mailing_Address_Line_2__c = creditApp.Physical_Address_Line_2__c;
                creditApp.Mailing_Country__c = creditApp.Physical_Country__c;
                creditApp.Mailing_City__c = creditApp.Physical_City__c;
                creditApp.Mailing_State_Province__c = creditApp.Physical_State_Province__c;
                creditApp.Mailing_Postal_Code__c = creditApp.Physical_Postal_Code__c;
            }

            // Determining if the legal structure is exempted from BOCDD
            Boolean isBOExempt = false;

            for(Beneficial_Owner_Exemption__mdt exemption : [SELECT Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c = 'US']) {

                if((creditApp.Legal_Structure__c).equalsIgnoreCase(exemption.Legal_Structure__c)) {
                    isBOExempt = true;
                }

            }

            String recordOwner = UserInfo.getUserId();

            List<User> integrationUsers = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

            if(integrationUsers.size() == 1) {
                recordOwner = integrationUsers[0].Id;
            }

            // Create/update the account
            Account account = new Account();

            account.Legal_Entity_Country__c = selectedCountry;
            account.Legal_Entity_State__c = selectedState;

            if(creditApp.Account__c != null) {
                account.Id = creditApp.Account__c;
            }
            else {
                if(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate Payments') != null) {
                    account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate Payments').getRecordTypeId();
                }
                account.OwnerId = recordOwner;
                account.Name = creditApp.Company_Legal_Name__c;
            }

            account.BillingStreet = creditApp.Mailing_Address_Line_1__c;
            if(creditApp.Mailing_Address_Line_2__c != null) account.BillingStreet = creditApp.Mailing_Address_Line_1__c + ', ' + creditApp.Mailing_Address_Line_2__c;
            account.BillingCity = creditApp.Mailing_City__c;
            account.BillingState = creditApp.Mailing_State_Province__c;
            account.BillingPostalCode = creditApp.Mailing_Postal_Code__c;
            account.BillingCountry = creditApp.Mailing_Country__c;

            account.ShippingStreet = creditApp.Physical_Address_Line_1__c;
            if(creditApp.Physical_Address_Line_2__c != null) account.BillingStreet = creditApp.Physical_Address_Line_1__c + ', ' + creditApp.Physical_Address_Line_2__c;
            account.ShippingCity = creditApp.Physical_City__c;
            account.ShippingState = creditApp.Physical_State_Province__c;
            account.ShippingPostalCode = creditApp.Physical_Postal_Code__c;
            account.ShippingCountry = creditApp.Physical_Country__c;

            account.Tax_ID__c = creditApp.Taxpayer_ID__c;
            account.Phone = creditApp.Business_Phone__c;

            Database.upsertResult result = Database.upsert(account, false);
            if(!result.isSuccess()){
                throw new creditApplicationException('Critical error inserting the Account: ' + result.getErrors());
            }

            // Create the application signer contact
            Contact primaryContact = new Contact();

            primaryContact.AccountId = account.Id;
            primaryContact.FirstName = creditApp.First_Name__c;
            primaryContact.LastName = creditApp.Last_Name__c;
            primaryContact.Email = creditApp.Email__c;
            primaryContact.Phone = creditApp.Business_Phone__c;

            result = Database.upsert(primaryContact, false);
            if(!result.isSuccess()){
                throw new creditApplicationException('Critical error inserting the App Signer Contact: ' + result.getErrors());
            }

            // Create/update the opportunity
            Opportunity opportunity = new Opportunity();

            opportunity.CurrencyIsoCode = selectedCurrency;

            if(creditApp.Opportunity__c != null) {
                opportunity.Id = creditApp.Opportunity__c;
            }
            else {
                if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NA Corporate Payments') != null) {
                    opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NA Corporate Payments').getRecordTypeId();
                }
                opportunity.OwnerId = recordOwner;
                opportunity.AccountId = account.Id;
                opportunity.Name = creditApp.Company_Legal_Name__c;
                opportunity.SourceSystem__c = 'BOCA';
            }

            opportunity.StageName = '5) Signed';
            opportunity.CloseDate = Date.today();

            opportunity.Legal_Structure__c = creditApp.Legal_Structure__c;
            if (creditApp.Years_in_Business__c.equalsIgnoreCase('Less than 12 Months')) {
                opportunity.Years_In_Business__c = 0.5;
            } else {
                opportunity.Years_in_Business__c = Integer.valueOf(creditApp.Years_in_Business__c);
            }

            opportunity.DUNS_Number__c = creditApp.DUNS_Number__c;

//            opportunity.Billing_Street__c = creditApp.Billing_Address_Line_1__c;
//            opportunity.Billing_Street_Line_2__c = creditApp.Billing_Address_Line_2__c;
//            opportunity.Billing_City__c = creditApp.Billing_City__c;
//            opportunity.Billing_State__c = creditApp.Billing_State__c;
//            opportunity.Billing_Zip_Postal_Code__c = creditApp.Billing_Postal_Code__c;

            opportunity.Physical_Street__c = creditApp.Physical_Address_Line_1__c;
            opportunity.Physical_Street_Line_2__c = creditApp.Physical_Address_Line_2__c;
            opportunity.Physical_City__c = creditApp.Physical_City__c;
            opportunity.Physical_State__c = creditApp.Physical_State_Province__c;
            opportunity.Physical_Zip_Postal_Code__c = creditApp.Physical_Postal_Code__c;
            opportunity.Physical_Country__c = creditApp.Physical_Country__c;

            result = Database.upsert(opportunity, false);
            if(!result.isSuccess()){
                throw new creditApplicationException('Critical error inserting the Opportunity: ' + result.getErrors());
            }

            // Associate the application signer to the opportunity
            OpportunityContactRole appSignerContactRole = new OpportunityContactRole();

            appSignerContactRole.ContactId = primaryContact.Id;
            appSignerContactRole.OpportunityId = opportunity.Id;
            appSignerContactRole.Role = 'Primary';

            result = Database.upsert(appSignerContactRole, false);
            if(!result.isSuccess()){
                throw new creditApplicationException('Critical error inserting the Opportunity Contact Role (App Signer): ' + result.getErrors());
            }

            // Create/update the credit application
            if(creditApp.Id == null) {
                if(Schema.SObjectType.CP_Application_Request__c.getRecordTypeInfosByName().get('NA Corporate Payments') != null) {
                    opportunity.RecordTypeId = Schema.SObjectType.CP_Application_Request__c.getRecordTypeInfosByName().get('NA Corporate Payments').getRecordTypeId();
                }
                creditApp.OwnerId = recordOwner;
            }

            creditApp.Account__c = account.Id;
            creditApp.Opportunity__c = opportunity.Id;
            creditApp.Program__c = program.Id;

            creditapp.Application_Signer_IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');

            // currently, the bank has no algorithm for setting the credit line requested. Credit Line requested is their projected monthly spend.
            creditApp.Credit_Line_Requested__c = creditApp.Projected_Monthly_Spend__c;

            if(TestUtils.isRunningTest()) {
                creditApp.Application_Stage__c = 'Application';
                creditApp.Status__c = 'Application Incomplete';
            }
            else {
                creditApp.Application_Stage__c = 'Application';
                creditApp.Status__c = 'Pending BOCDD';
            }

            System.debug('The credit application: ' + creditApp);

            // Upsert the credit application, then send the e-mail, and redirect to the confirmation page
            result = Database.upsert(creditApp, false);
            System.debug('attempted to insert, result was successful: ' + result.isSuccess());
            if(result.isSuccess()){
                Id creditAppId = result.getId();

                System.debug('Credit App Id: ' + creditAppId);

                // Send the confirmation email
                //sendEmail(creditApp);

                if(isBOExempt) {

                    Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
                    boEntity.Opportunity__c = opportunity.Id;
                    boEntity.Account__c = account.Id;
                    boEntity.CorporatePayments_Application_Request__c = creditAppId;
                    boEntity.Legal_Structure__c = creditApp.Legal_Structure__c;
                    boEntity.Verification_Status__c = 'Exempted';

                    if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('CorporatePayments') != null) {
                        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('CorporatePayments').getRecordTypeId();
                    }

                    upsert boEntity;

                    result = Database.upsert(boEntity, false);
                    if(!result.isSuccess()){
                        throw new creditApplicationException('Critical error inserting the Beneficial Owner Information: ' + result.getErrors());
                    }

                    creditApp.Application_Stage__c = 'Adjudication';
                    creditApp.Status__c = 'Pending Decision';
                    creditApp.Beneficial_Owner_Entity__c = result.getId();

                    result = Database.upsert(creditApp, false);
                    if(!result.isSuccess()){
                        throw new creditApplicationException('Critical error finalizing Credit Application after Beneficial Owner Exemption: ' + result.getErrors());
                    }

                }

                if(!isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {

                    PageReference boCertification = Page.BOCertification;
                    boCertification.getParameters().put('pgm', program.Brand_Short_Name__c);
                    boCertification.getParameters().put('cpAppId', creditAppId);
                    return boCertification;

                }
                else {

                    PageReference cpBOCAConfirmation = Page.CPBOCAConfirmation;
                    CPBOCAConfirmation.getParameters().put('pgm', programParameter);
                    CPBOCAConfirmation.getParameters().put('id', creditAppId);
                    CPBOCAConfirmation.getParameters().put('lang', languageCode);
                    CPBOCAConfirmation.setRedirect(true);
                    return cpBOCAConfirmation;

                }

            }
            else {
                throw new creditApplicationException('Critical error inserting the Credit Application: ' + String.valueOf(result.getErrors()));
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

    public void sendEmail(CP_Application_Request__c creditApp){

        Map<String, BOCA_IDs__c> bocaIdMap = new Map<String, BOCA_IDs__c>();

        bocaIdMap = BOCA_IDs__c.getAll();

        BOCA_IDs__c singleBocaId = new BOCA_IDs__c();

        String replyTo = '';

        if(!bocaIdMap.isEmpty()){
            singleBocaId = bocaIdMap.get('BOCA IDS');
            replyTo = String.valueOf(singleBocaId.get('Email_Address_Noreply__c'));
        }

        List<RecordType> contactRecordTypes = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('F1_Contact')];

        Contact temporaryContact = new Contact();

        temporaryContact.FirstName = creditApp.First_Name__c;
        temporaryContact.LastName = creditApp.Last_Name__c;
        temporaryContact.Email = creditApp.Email__c;
        temporaryContact.RecordTypeId = contactRecordTypes[0].Id;

        insert temporaryContact;

        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();

        confirmation.setTemplateId(brandingUtility.Email_Template_ID__c);
        confirmation.setWhatId(creditApp.Id);
        confirmation.setTargetObjectId(temporaryContact.id);
        confirmation.setSaveAsActivity(false);
        confirmation.setReplyTo(replyTo);

        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress])
        {
            if(owa.Address.contains(replyTo)) {
                confirmation.setOrgWideEmailAddressId(owa.id);
            }
        }

        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {confirmation});
        }

        delete temporaryContact;

    }

    private String logError(Exception e) {
        try {
            External_Application_Error__c error = new External_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCA';
            error.Application_URL__c = applicationURL;
            error.Application_View_State__c = maskViewState(applicationViewState);

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

    // This function will mask PII to ensure it's not stored in this table
    private String maskViewState(String viewState) {

        // Remove TaxPayer ID
        viewState = viewState.replaceAll('taxpayerId=(\\d{9})', 'taxpayerId=#REDACTED#');

        // Remove SSN
        viewState = viewState.replaceAll('pgSSN=(\\d{3}-\\d{2}-\\d{4})', 'pgSSN=#REDACTED#');

        // Remove DOB
        viewState = viewState.replaceAll('pgDateOfBirth=(\\d{2}%2F\\d{2}%2F\\d{4})', 'pgDOB=#REDACTED#');

        return viewState;

    }
}