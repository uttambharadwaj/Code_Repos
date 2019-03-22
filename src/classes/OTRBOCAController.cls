public class OTRBOCAController {

    public final static String APPLICATION_NAME = 'OTRBOCA';

    //TODO DELETE and get picklist dynamically on the page
    public List<SelectOption> usStateList {
        get {
            List<SelectOption> picklistValues = new List<SelectOption>();

            Set<String> usStateList = new Set<String>{
                    'AK', 'AL', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
            };

            picklistValues.add(new SelectOption('#', '--Choose One--'));
            for (String state : usStateList) {
                picklistValues.add(new SelectOption(state, state));
            }

            return picklistValues;
        }
    }

    public Beneficial_Owner_Settings__c beneficialOwnerSettings {
        get {
            return Beneficial_Owner_Settings__c.getOrgDefaults();
        }
    }

    // Credi`t application object
    public WeFormObject__c creditApp { get; set; }

    public OnlineApplication__c onlineApplication { get; set; }

    public String tmSessionId { get; set; }

    public Boolean sendToConfirmation { get; set; }

    public Boolean saveForLater { get; set; }

    public String onlineApplicationOfferParameter {
        get {
            return ApexPages.currentPage().getParameters().get('offer');
        }
    }

    public String couponCodeParameter {
        get {
            return ApexPages.currentPage().getParameters().get('cc');
        }
    }

    public Campaign_Program__c campaignProgram { get; set; }

    public Campaign campaign { get; set; }

    public Boolean forcePg { get; set; }

    // Check is this is a Personal Guaruntor application
    public Boolean isPG {
        get {

            String pg = ApexPages.currentPage().getParameters().get('pg');

            Boolean prepay = false;
            if (onlineApplication.Account_Type__c != null && onlineApplication.Account_Type__c.equalsIgnoreCase('Prepay')) {
                prepay = true;
            }

            if ((pg != null && pg == 'n') || (onlineApplicationOffer.Funding__c).equalsIgnoreCase('Parent Funded')) {
                return false;
            } else if (pg != null && pg == 'a') {
                return true;
            } else if (onlineApplication != null) {
                Date rightNow = Date.today();

                if (onlineApplication.Year_Established__c != null && ((rightNow.year()) - Integer.valueOf(onlineApplication.Year_Established__c)) <= 1) {
                    return true;

                } else if (!prepay && onlineApplication.Type_of_Business__c != null && ((onlineApplication.Type_of_Business__c).equalsIgnoreCase('Sole Proprietorship')
                        || (onlineApplication.Type_of_Business__c).equalsIgnoreCase('Proprietorship')
                        || (onlineApplication.Type_of_Business__c).equalsIgnoreCase('Partnership'))) {
                    return true;
                }
            }
            return false;
        }
    }

    // If BOCa to Prospect - get the WeForm ID
    public String partialCustomer {
        get {
            return ApexPages.currentPage().getParameters().get('customer');
        }
    }

    public String applicationKey {
        get {
            return ApexPages.currentPage().getParameters().get('key');
        }
    }

    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
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
    public String territoryCode {
        get {
            return ApexPages.currentPage().getParameters().get('territorycode');
        }
    }

    // Program for the BOCA
    public Program__c program { get; set; }

    // Language Code for the BOCA
    public String languageCode {
        get {
            if (ApexPages.currentPage().getParameters().get('lang') != null) {
                return ApexPages.currentPage().getParameters().get('lang');
            }
            return 'en_us';
        }
    }

    public String countryCode {
        get {
            if((languageCode).equalsIgnoreCase('en_ca') || (languageCode).equalsIgnoreCase('fr_ca')) {
                return 'CA';
            }
            return 'US';
        }
    }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    // Online Application Offer
    public OnlineApplicationOffer__c onlineApplicationOffer { get; set; }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    public String fleetIdentifier { get; set; }

    // Terms and conditions related to the online application offer
    public String termsAndConditionsId {
        get {
            List<Attachment> tncs = [SELECT Id, Name FROM Attachment WHERE ParentId = :onlineApplicationOffer.Id];

            if (!tncs.isEmpty()) {
                for (Attachment tnc : tncs) {
                    if ((tnc.Name).contains(onlineApplicationOffer.Terms_and_Conditions_Version__c)) {
                        return tnc.Id;
                    }
                }
            }

            return null;
        }
    }

    // Sales rep information if BOCA to Prospect
    public User salesRep {
        get {
            if (territoryCode != null) {
                List<User> u = new List<User>();

                try {
                    u = [SELECT Name, Id, Email, Phone, Sales_Code__c, Fax FROM User WHERE Territory_Code__c = :territoryCode LIMIT 1];
                } catch (SYSTEM.DmlException ex) {
                    System.debug('Exception during Sales Rep lookup: ' + ex);
                }

                return (u.size() != 0) ? u.get(0) : null;
            }
            return null;
        }
    }

    public List<SelectOption> businessDescriptionOptions {
        get {
            Set<String> availableOptions = new Set<String>{
                    'Trucking Interstate/Long Haul', 'Trucking Local', 'Local Delivery', 'Regional', 'Other'
            };

            List<SelectOption> picklistValues = new List<SelectOption>();
            picklistValues.add(new SelectOption('#', '--Choose One--'));
            Schema.DescribeFieldResult businessDescription = OnlineApplication__c.Business_Description__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = businessDescription.getPicklistValues();
            for (Schema.PicklistEntry picklistValue : picklistEntries) {
                if (availableOptions.contains(picklistValue.getLabel())) {
                    picklistValues.add(new SelectOption(picklistValue.getLabel(), picklistValue.getLabel()));
                }
            }
            return picklistValues;
        }
    }

    public List<SelectOption> paymentMethodOptions {
        get {

            List<SelectOption> picklistValues = new List<SelectOption>();
            picklistValues.add(new SelectOption('#', '--Choose One--'));

            if (onlineApplication != null && onlineApplication.Account_Type__c != 'Prepay' && onlineApplicationOffer != null && onlineApplicationOffer.Available_Payment_Methods__c != null) {

                for (String option : onlineApplicationOffer.Available_Payment_Methods__c.split(';')) {
                    picklistValues.add(new SelectOption(option, option));
                }

            }

            if (onlineApplication != null && onlineApplication.Account_Type__c == 'Prepay' && onlineApplicationOffer != null && onlineApplicationOffer.Available_Prepay_Payment_Methods__c != null) {

                for (String option : onlineApplicationOffer.Available_Prepay_Payment_Methods__c.split(';')) {
                    picklistValues.add(new SelectOption(option, option));
                }

            }

            return picklistValues;

        }
    }

    public List<String> dayOfPaymentOptions {
        get {
            List<String> picklistValues = new List<String>();
            Schema.DescribeFieldResult dayOfPayment = OnlineApplication__c.Day_of_Payment__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = dayOfPayment.getPicklistValues();
            for (Schema.PicklistEntry picklistValue : picklistEntries) {
                picklistValues.add(picklistValue.getLabel());
            }
            return picklistValues;
        }
    }

    public String selectedDaysOfPayment { get; set; }

    public OTRBOCAAdditionalAttributes additionalAttributes { get; set; }

    public OTRBOCAController() {

        // Set to true if we're skipping over the page 2 stuff
        sendToConfirmation = false;

        forcePg = false;

        saveForLater = false;

        additionalAttributes = new OTRBOCAAdditionalAttributes();

    }

    public PageReference init() {

        PageReference otrBOCAError = null;

        try {

            if (String.isEmpty(programParameter)) {

                throw new creditApplicationException('No program specified.');

            } else {

                Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

                if (programId != null) {

                    program = WexBrandingController.getProgram(programId);

                    if(program.Publish_BOCA__c ==  false) {
                        throw new creditApplicationException('Program is currently unavailable. Please check configuration.');
                    }

                    Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);

                    if (brandingUtilityId != null) {

                        brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                    }

                    brandingLogo = WexBrandingController.getLogoId(programId);

                    brandingCard = WexBrandingController.getCreditCardImageId(programId);

                    // Get the Online Application Offer
                    if (!String.isEmpty(onlineApplicationOfferParameter)) {
                        onlineApplicationOffer = WexBrandingController.getOnlineApplicationOfferById(onlineApplicationOfferParameter);
                    } else {
                        onlineApplicationOffer = WexBrandingController.getDefaultOnlineApplicationOfferByProgramId(programId);
                    }

                    // Get
                    if (couponCodeParameter != null) {
                        campaignProgram = WexBrandingController.getCampaignProgramByCouponCode(program.Id, couponCodeParameter, languageCode);
                    }

                    if (campaignProgram == null) {
                        campaignProgram = WexBrandingController.getDefaultCampaignProgramByProgram(program.Id, languageCode);
                    }

                    if (campaignProgram != null) {
                        campaign = WexBrandingController.getCampaignByCampaignProgram(campaignProgram.Id);
                    }

                    // BOCA To Prospect?
                    if (partialCustomer != null) {

                        if (((Id.valueOf(partialCustomer)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {
                            List<OnlineApplication__c> partialOnlineApplications = [
                                    SELECT Id, Opportunity__r.Beneficial_Owner_Entity__c, AO_Address__c, AO_City__c, AO_Home_Phone_Number__c,
                                            AO_Mobile_Number__c, AO_State__c, AO_Title__c, AO_Zip_Code__c, AO_Country__c, Account__c, Business_Address_Line_2__c, Business_Description__c,
                                            Business_Street_Address__c, Cell_Number__c, City__c, Country__c, Contact_First_Name__c, Contact_Last_Name__c, Credit_Line_Requested__c,
                                            DOT_Number__c, Day_of_Payment__c, Email__c, FF_Number__c, Fax_Number__c, Financial_Institution__c, Legal_Business_Name__c,
                                            MC_FF_or_DOT__c, MC_Number__c, Name_of_Parent_Company__c, Number_Of_Drivers__c, Number_of_Cards_Needed__c, Number_of_Trucks__c,
                                            Payment_Method__c, Phone_Number__c, Promotional_Code__c, State__c, Trade_Name__c, Type_of_Business__c, Year_Established__c, Zip_code__c, Account_Type__c,
                                            Mobile_Number__c, Application_Key__c, External_Application_URL__c
                                    FROM OnlineApplication__c
                                    WHERE Id = :partialCustomer and Application_Stage__c = 'Application' and Status__c in ('App-Incomplete', 'Saved-Incomplete') and Application_Key__c = :applicationKey
                            ];

                            if (partialOnlineApplications.size() > 0) {

                                onlineApplication = partialOnlineApplications[0].clone(false, false, false, false);
                                onlineApplication.Id = partialOnlineApplications[0].Id;

                                fleetIdentifier = partialOnlineApplications[0].MC_FF_or_DOT__c;
                                selectedDaysOfPayment = partialOnlineApplications[0].Day_of_Payment__c;

                            } else {

                                throw new creditApplicationException('Your application has already been submitted.');

                            }

                        } else if (((Id.valueOf(partialCustomer)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('WeFormObject__c')) {

                            // TODO - This is for backwards compatability until we transition from the WeFormObject fully
                            List<WeFormObject__c> partialOnlineApplications = [
                                    SELECT Id, Company_Name__c, Doing_Business_As__c, Business_Phone__c, Mobile_Phone__c,
                                            Business_fax__c, First_Name__c, DUNS_Number__c, Parent_Company__c,
                                            Business_Street_Address__c, Address_Line_2__c, City__c, State__c, Country__c, Zip_code__c, Fleet_Size__c,
                                            Number_Of_Drivers__c, Team_Drivers_Slip_Seat__c, Taxpayer_ID__c, Years_in_Business__c, Year_Established__c,
                                            Business_Description__c, Legal_Structure__c, Title__c, Last_Name__c, Email__c, PG_Residential_Street_Address__c,
                                            PG_Residential_City__c, PG_Residential_State__c, PG_Residential_Zip__c, PG_Residential_Phone__c
                                    FROM WeFormObject__c
                                    WHERE Id = :partialCustomer
                            ];

                            if (partialOnlineApplications.size() > 0) {

                                onlineApplication = new OnlineApplication__c();

                                onlineApplication.Legal_Business_Name__c = partialOnlineApplications[0].Company_Name__c;
                                onlineApplication.Trade_Name__c = partialOnlineApplications[0].Doing_Business_As__c;
                                onlineApplication.Phone_Number__c = partialOnlineApplications[0].Business_Phone__c;
                                onlineApplication.Contact_Name__c = partialOnlineApplications[0].First_Name__c + ' ' + partialOnlineApplications[0].Last_Name__c;
                                onlineApplication.Cell_Number__c = partialOnlineApplications[0].Mobile_Phone__c;
                                onlineApplication.Fax_Number__c = partialOnlineApplications[0].Business_fax__c;
                                onlineApplication.Contact_First_Name__c = partialOnlineApplications[0].First_Name__c;
                                onlineApplication.Contact_Last_Name__c = partialOnlineApplications[0].Last_Name__c;
                                onlineApplication.AO_Title__c = partialOnlineApplications[0].Title__c;
                                onlineApplication.Email__c = partialOnlineApplications[0].Email__c;
                                onlineApplication.DUNS__c = partialOnlineApplications[0].DUNS_Number__c;
                                onlineApplication.Name_of_Parent_Company__c = partialOnlineApplications[0].Parent_Company__c;
                                onlineApplication.Business_Street_Address__c = partialOnlineApplications[0].Business_Street_Address__c;
                                onlineApplication.Business_Address_Line_2__c = partialOnlineApplications[0].Address_Line_2__c;
                                onlineApplication.City__c = partialOnlineApplications[0].City__c;
                                onlineApplication.State__c = partialOnlineApplications[0].State__c;
                                onlineApplication.Zip_Code__c = partialOnlineApplications[0].Zip_code__c;
                                onlineApplication.Number_of_Trucks__c = partialOnlineApplications[0].Fleet_Size__c;
                                onlineApplication.Number_of_Drivers__c = partialOnlineApplications[0].Number_Of_Drivers__c;
                                onlineApplication.Team_Drivers_Slip_Seat__c = partialOnlineApplications[0].Team_Drivers_Slip_Seat__c;
                                onlineApplication.Federal_Tax_ID__c = partialOnlineApplications[0].Taxpayer_ID__c;
                                onlineApplication.Years_In_Business__c = partialOnlineApplications[0].Years_in_Business__c;
                                onlineApplication.Year_Established__c = partialOnlineApplications[0].Year_Established__c;
                                onlineApplication.Type_of_Business__c = partialOnlineApplications[0].Business_Description__c;
                                onlineApplication.Business_Description__c = partialOnlineApplications[0].Legal_Structure__c;
                                onlineApplication.AO_Title__c = partialOnlineApplications[0].Title__c;
                                onlineApplication.AO_Name__c = partialOnlineApplications[0].First_Name__c + ' ' + partialOnlineApplications[0].Last_Name__c;
                                onlineApplication.AO_Work_Email__c = partialOnlineApplications[0].Email__c;
                                onlineApplication.AO_Address__c = partialOnlineApplications[0].PG_Residential_Street_Address__c;
                                onlineApplication.AO_City__c = partialOnlineApplications[0].PG_Residential_City__c;
                                onlineApplication.AO_State__c = partialOnlineApplications[0].PG_Residential_State__c;
                                onlineApplication.AO_Zip_Code__c = partialOnlineApplications[0].PG_Residential_Zip__c;
                                onlineApplication.AO_Home_Phone_Number__c = partialOnlineApplications[0].PG_Residential_Phone__c;

                            } else {

                                throw new creditApplicationException('Your application has already been submitted.');

                            }
                        }

                    } else {

                        onlineApplication = new OnlineApplication__c();

                    }

                    // Generate ThreatMetrix SessionID
                    Datetime dt = Datetime.now();
                    Long l = dt.getTime();

                    String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                    onlineApplication.ThreatMetrix_Session_ID__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + ipAddress + salt.substring(0, 25))));

                } else {
                    throw new creditApplicationException('Unable to find specified credit application.');
                }

            }

        } catch (Exception e) {

            System.debug(e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            otrBOCAError = Page.ExternalApplicationError;
            otrBOCAError.getParameters().put('errorCode', errorNumber);
            otrBOCAError.getParameters().put('pgm', programParameter);
            otrBOCAError.setRedirect(true);
            return otrBOCAError;

        }

        return null;

    }

    // We want to calculate a value and put in a
    // rough estimate into the credit line requested box
    public void setCreditLineRequested() {
        if (onlineApplication != null && onlineApplication.Number_of_Trucks__c != null) {
            if (onlineApplication.Team_Drivers_Slip_Seat__c == true) {
                if (onlineApplicationOffer.Credit_Limit_Per_Truck_Slip_Seat__c != null) {
                    onlineApplication.Credit_Line_Requested__c = onlineApplication.Number_of_Trucks__c * onlineApplicationOffer.Credit_Limit_Per_Truck_Slip_Seat__c;
                } else {
                    onlineApplication.Credit_Line_Requested__c = onlineApplication.Number_of_Trucks__c * 3000;
                }
            } else {
                if (onlineApplicationOffer.Credit_Limit_Per_Truck__c != null) {
                    onlineApplication.Credit_Line_Requested__c = onlineApplication.Number_of_Trucks__c * onlineApplicationOffer.Credit_Limit_Per_Truck__c;
                } else {
                    onlineApplication.Credit_Line_Requested__c = onlineApplication.Number_of_Trucks__c * 2000;
                }
            }
        }
    }

    public class creditApplicationException extends Exception {}

    public PageReference saveApplication() {

        try {

            // Set this initial status so we don't trigger workflows
            onlineApplication.Program__c = program.Id;
            onlineApplication.Offer__c = onlineApplicationOffer.Id;
            onlineApplication.Product_Type__c = 'OTR';
            onlineApplication.Application_Title__c = onlineApplicationOffer.Name;

            Database.upsertResult result = Database.upsert(onlineApplication, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Online Application: ' + result.getErrors());
            }

            // Once we get the ID, we need to generate the external URL and upsert.
            if (onlineApplication.Application_Key__c == null) {

                Datetime dt = Datetime.now();
                Long l = dt.getTime();

                String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                onlineApplication.Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));
            }

            // Set the application URL, for ease of picking up in the e-mail
            if (onlineApplication.External_Application_URL__c == null) {
                onlineApplication.External_Application_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/' + program.Form_Template__c + '?pgm=' + program.Brand_Short_Name__c + '&offer=' + onlineApplicationOffer.Id + '&customer=' + onlineApplication.Id + '&key=' + onlineApplication.Application_Key__c;
            }

            // Set this status to trigger the Save For Later email
            onlineApplication.Application_Stage__c = 'Application';
            onlineApplication.Status__c = 'Saved-Incomplete';

            upsert onlineApplication;

            PageReference redirect = Page.OTRBOCAConfirmation;
            redirect.getParameters().put('pgm', program.Brand_Short_Name__c);
            redirect.getParameters().put('customer', onlineApplication.Id);
            redirect.getParameters().put('saved', 'true');

            return redirect;

        }
        catch(Exception e) {

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            PageReference externalApplicationError = Page.ExternalApplicationError;
            externalApplicationError.getParameters().put('errorCode', errorNumber);
            externalApplicationError.getParameters().put('pgm', programParameter);
            externalApplicationError.setRedirect(true);
            return externalApplicationError;

        }

    }

    // This method will write the application with any mappings. This could either be used for
    // saving the application, or submitting the application.
    public PageReference submitApplication() {

        try {

            User defaultOwner = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

            // Add Account
            Account account = new Account();

            if (Schema.SObjectType.Account.getRecordTypeInfosByName().get('Fleet Account') != null) {
                account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId();
            }

            if (onlineApplication.Account__c != null) {
                account.Id = onlineApplication.Account__c;
            }

            if (onlineApplication.Account__c == null) {
                account.OwnerId = defaultOwner.Id;
                account.Name = onlineApplication.Legal_Business_Name__c;
            }
            account.Phone = onlineApplication.Phone_Number__c;
            account.Fax = onlineApplication.Fax_Number__c;

            // Billing Information
            account.BillingStreet = onlineApplication.Business_Street_Address__c;
            account.BillingCity = onlineApplication.City__c;
            account.BillingState = onlineApplication.State__c;
            account.BillingPostalCode = onlineApplication.Zip_Code__c;

            // Shipping Information
            account.ShippingStreet = onlineApplication.Business_Street_Address__c;
            if (onlineApplication.Business_Address_Line_2__c != null) {
                account.ShippingStreet = onlineApplication.Business_Street_Address__c + ', ' + onlineApplication.Business_Address_Line_2__c;
            }
            account.ShippingCity = onlineApplication.City__c;
            account.ShippingState = onlineApplication.State__c;
            account.ShippingPostalCode = onlineApplication.Zip_code__c;

            // Misc Information
            account.Tax_ID__c = onlineApplication.Federal_Tax_ID__c;

            Database.upsertResult result = Database.upsert(account, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Account: ' + result.getErrors());
            }

            System.debug('***OTR*** Account: ' + account.Id);

            // Add Contacts

            // Create Primary Contact
            Contact primaryContact = new Contact();

            primaryContact.AccountId = account.Id;

            primaryContact.FirstName = onlineApplication.Contact_First_Name__c;
            primaryContact.LastName = onlineApplication.Contact_Last_Name__c;
            primaryContact.Phone = onlineApplication.Phone_Number__c;
            primaryContact.Fax = onlineApplication.Fax_Number__c;
            primaryContact.Email = onlineApplication.Email__c;

            primaryContact.MailingStreet = onlineApplication.Business_Street_Address__c;
            primaryContact.MailingCity = onlineApplication.City__c;
            primaryContact.MailingState = onlineApplication.State__c;
            primaryContact.MailingPostalCode = onlineApplication.Zip_code__c;
            primaryContact.MailingCountry = onlineApplication.Country__c;

            insert primaryContact;

            result = Database.upsert(primaryContact, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Primary Contact: ' + result.getErrors());
            }

            System.debug('***OTR*** Primary Contact: ' + primaryContact.Id);

            // Create PG Contact
            Contact pgContact = new Contact();

            if (additionalAttributes.ssn != null) {

                pgContact.AccountId = account.Id;

                pgContact.FirstName = onlineApplication.Contact_First_Name__c;
                pgContact.LastName = onlineApplication.Contact_Last_Name__c;

                pgContact.Email = onlineApplication.AO_Work_Email__c;
                pgContact.mobilePhone = onlineApplication.Mobile_Number__c;
                pgContact.Phone = onlineApplication.AO_Home_Phone_Number__c;

                pgContact.MailingStreet = onlineApplication.AO_Address__c;
                pgContact.MailingCity = onlineApplication.AO_City__c;
                pgContact.MailingState = onlineApplication.AO_State__c;
                pgContact.MailingPostalCode = onlineApplication.AO_Zip_Code__c;
                pgContact.MailingCountry = onlineApplication.AO_Country__c;

                if (onlineApplication.AO_Date_of_Birth__c != null) {
                    pgContact.Birthdate = onlineApplication.AO_Date_of_Birth__c;
                }
                pgContact.SSN__c = additionalAttributes.ssn;

                result = Database.upsert(pgContact, false);
                if (!result.isSuccess()) {
                    throw new creditApplicationException('Critical error inserting the PG Contact: ' + result.getErrors());
                }

                onlineApplication.Personal_Guarantor__c = pgContact.Id;
                System.debug('***OTR*** PG Contact: ' + pgContact.Id);

            }

            // Add Opportunity
            Opportunity opportunity = new Opportunity();

            if (onlineApplication.Opportunity__c != null) {
                opportunity.Id = onlineApplication.Opportunity__c;
            }

            if (Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fleet Card') != null) {
                opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
            }

            if (onlineApplication.Opportunity__c == null) {
                opportunity.OwnerId = defaultOwner.Id;
                opportunity.AccountId = account.Id;
                opportunity.Name = onlineApplication.Legal_Business_Name__c;
            }
            opportunity.CloseDate = Date.today();
            opportunity.Application_Status__c = 'Pending';
            opportunity.StageName = '5) signed';

            opportunity.Legal_Structure__c = onlineApplication.Type_of_Business__c;

            opportunity.Doing_Business_As__c = onlineApplication.Trade_Name__c;

            opportunity.Expected_Monthly_Vehicle_Expense__c = 0.00;
            opportunity.Average_Monthly_Expenses__c = 0.00;
            if (onlineApplication.Number_of_Trucks__c != null) {
                opportunity.Fleet_Size__c = onlineApplication.Number_of_Trucks__c;
            }
            opportunity.Annual_Revenue__c = 0.00;

            if (campaign == null) {
                opportunity.Promotional_Code__c = onlineApplicationOffer.Promotional_Code__c;
            } else {
                opportunity.Promotional_Code__c = campaign.Coupon_Code__c;
            }

            opportunity.Location_Code__c = locationCode;

            opportunity.SourceSystem__c = 'BOCA';

            opportunity.Billing_Street__c = onlineApplication.Business_Street_Address__c;
            opportunity.Billing_City__c = onlineApplication.City__c;
            opportunity.Billing_Country__c = onlineApplication.Country__c;
            opportunity.Billing_State__c = onlineApplication.State__c;
            opportunity.Billing_Zip_Postal_Code__c = onlineApplication.Zip_code__c;

            opportunity.Application_Signer_First_Name__c = onlineApplication.Contact_First_Name__c;
            opportunity.Application_Signer_Last_Name__c = onlineApplication.Contact_Last_Name__c;
            opportunity.Application_Signer_Email_Address__c = onlineApplication.Email__c;
            opportunity.Application_Signer_Title__c = onlineApplication.AO_Title__c;
            opportunity.Application_Signer_Phone__c = onlineApplication.Phone_Number__c;

            if (salesRep != null) {
                opportunity.OwnerId = salesRep.Id;
            }

            opportunity.IP_Address__c = ipAddress;

            opportunity.Billing_Contact__c = primaryContact.Id;
            opportunity.Primary_Contact__c = primaryContact.Id;

            opportunity.Guarantor_Name__c = pgContact.FirstName + ' ' + pgContact.LastName;
            opportunity.Guarantor_address_line_1__c = onlineApplication.AO_Address__c;
            opportunity.Guarantor_City__c = onlineApplication.AO_City__c;
            opportunity.Guarantor_State__c = onlineApplication.AO_State__c;
            opportunity.Guarantor_Zip_code__c = onlineApplication.AO_Zip_Code__c;
            opportunity.Guarantor_Country__c =	onlineApplication.AO_Country__c;

            opportunity.Guarantor_Email__c = onlineApplication.AO_Work_Email__c;
            opportunity.Guarantor_Annual_Income__c = 0.00;
            opportunity.Guarantor_home_phone__c = onlineApplication.AO_Home_Phone_Number__c;

            if (campaign != null && campaignProgram != null) {
                opportunity.CampaignId = campaign.Id;
                opportunity.Campaign_Program__c = campaignProgram.Id;
            }

            result = Database.upsert(opportunity, false);
            if (!result.isSuccess()) {
                System.debug('### Opportunity Dump: ' + opportunity);

                throw new creditApplicationException('Critical error inserting the Opportunity: ' + result.getErrors());
            }

            System.debug('***OTR*** Opportunity ID: ' + opportunity.Id);

            OpportunityContactRole opportunityPrimaryContact = new OpportunityContactRole();
            opportunityPrimaryContact.ContactId = primaryContact.Id;
            opportunityPrimaryContact.OpportunityId = opportunity.Id;
            opportunityPrimaryContact.Role = 'Primary Contact';
            opportunityPrimaryContact.IsPrimary = true;

            result = Database.upsert(opportunityPrimaryContact, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Primary Contact Opportunity Role: ' + result.getErrors());
            }

            System.debug('***OTR*** Opportunity Contact Primary: ' + opportunityPrimaryContact.Id);

            if (additionalAttributes.ssn != null) {

                OpportunityContactRole opportunityPGContact = new OpportunityContactRole();
                opportunityPGContact.ContactId = pgContact.Id;
                opportunityPGContact.OpportunityId = opportunity.Id;
                opportunityPGContact.Role = 'PG Contact';

                result = Database.upsert(opportunityPGContact, false);
                if (!result.isSuccess()) {
                    throw new creditApplicationException('Critical error inserting the PG Contact Opportunity Role: ' + result.getErrors());
                }

                System.debug('***OTR*** Opportunity Contact PG: ' + opportunityPGContact.Id);

            }

            //  Update the form with the opportunity ID
            onlineApplication.Opportunity__c = opportunity.Id;
            onlineApplication.Account__c = account.Id;

            // Calculate Beneficial Owner exemption and insert
            Boolean isBOExempt = false;

            if (beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {

                for (Beneficial_Owner_Exemption__mdt exemption : [SELECT Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c = 'US']) {

                    if (onlineApplication.Type_of_Business__c != null && (onlineApplication.Type_of_Business__c).equalsIgnoreCase(exemption.Legal_Structure__c)) {
                        isBOExempt = true;
                    }

                }

                if (onlineApplicationOffer != null && onlineApplicationOffer.Funding__c != null && (onlineApplicationOffer.Funding__c).equalsIgnoreCase('Parent Funded')) {
                    isBOExempt = true;
                }

                if (isBOExempt) {

                    Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

                    boEntity.Opportunity__c = opportunity.Id;
                    boEntity.Account__c = account.Id;
                    boEntity.Legal_Structure__c = onlineApplication.Type_of_Business__c;
                    boEntity.Verification_Status__c = 'Exempted';

                    boEntity.Certified_Date__c = Date.TODAY();
                    boEntity.Certified_By__c = onlineApplication.Contact_First_Name__c + ' ' + onlineApplication.Contact_Last_Name__c;

                    upsert boEntity;

                }

            }

            // Online Application Random Mappings
//            if (opportunity.OwnerId != null) {
//                onlineApplication.OwnerId = opportunity.OwnerId;
//            }

            onlineApplication.Day_of_Payment__c = selectedDaysOfPayment;
            onlineApplication.Program__c = program.Id;
            onlineApplication.Offer__c = onlineApplicationOffer.Id;
            onlineApplication.Product_Type__c = 'OTR';
            onlineApplication.Application_Title__c = onlineApplicationOffer.Name;

            // eApps come in using the Name field with the first and last name put together
            if (null == onlineApplication.Contact_First_Name__c && null == onlineApplication.Contact_Last_Name__c && null != onlineApplication.AO_Name__c) {
                onlineApplication.AO_First_Name__c = (onlineApplication.AO_Name__c).split(' ')[0];
                onlineApplication.AO_Last_Name__c = (onlineApplication.AO_Name__c).split(' ')[1];
            } else {
                onlineApplication.AO_First_Name__c = onlineApplication.Contact_First_Name__c;
                onlineApplication.AO_Last_Name__c = onlineApplication.Contact_Last_Name__c;
            }

            onlineApplication.IP_Address__c = ipAddress;
            onlineApplication.Application_Signer_IP__c = ipAddress;

            if(campaign != null) {
                onlineApplication.Promotional_Code__c = campaign.Coupon_Code__c;
            }
            else if(onlineApplicationOffer != null) {
                onlineApplication.Promotional_Code__c = onlineApplicationOffer.Promotional_Code__c;
            }

            if (onlineApplication.Account_Type__c != null && (onlineApplication.Account_Type__c).equalsIgnoreCase('Prepay')) {
                onlineApplication.Credit_Line_Requested__c = 0.00;
                onlineApplication.Prepaid__c = true;
            }

            if (String.isEmpty(onlineApplication.MC_Number__c) && String.isEmpty(onlineApplication.FF_Number__c) && String.isEmpty(onlineApplication.DOT_Number__c)) {
                onlineApplication.MC_FF_or_DOT__c = 'No assigned number';
            }
            else {
                onlineApplication.MC_FF_or_DOT__c = fleetIdentifier;
            }

            if (!String.isEmpty(additionalAttributes.ssn)) {
                onlineApplication.AO_Social_Security_Number__c = (additionalAttributes.ssn).replaceAll('-', '');
                onlineApplication.AO_Confirm_Social_Security_Number__c = (additionalAttributes.ssn).replaceAll('-', '');
            }

            if (!String.isEmpty(additionalAttributes.checkingAccountNumber)) {
                onlineApplication.Checking_Account_Number__c = (additionalAttributes.checkingAccountNumber).replaceAll('-', '');
                onlineApplication.Confirm_Checking_Account_Number__c = (additionalAttributes.checkingAccountNumber).replaceAll('-', '');
            }

            if (!String.isEmpty(additionalAttributes.abaRoutingNumber)) {
                onlineApplication.ABA_Routing_Number__c = (additionalAttributes.abaRoutingNumber).replaceAll('-', '');
                onlineApplication.Confirm_ABA_Routing_Number__c = (additionalAttributes.abaRoutingNumber).replaceAll('-', '');
            }

            if (!isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {
                onlineApplication.Status__c = 'BOCDD-Needed';
            } else {
                onlineApplication.Status__c = 'App-Incomplete';
            }

            result = Database.upsert(onlineApplication, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Online Application: ' + result.getErrors());
            }

            // Set an application key if it isn't there
            if (onlineApplication.Application_Key__c == null) {

                Datetime dt = Datetime.now();
                Long l = dt.getTime();

                String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                onlineApplication.Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));
            }

            // Set the application URL, for ease of picking up in the e-mail
            if (onlineApplication.External_Application_URL__c == null) {
                onlineApplication.External_Application_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/' + program.Form_Template__c + '?pgm=' + program.Brand_Short_Name__c + '&offer=' + onlineApplicationOffer.Id + '&customer=' + onlineApplication.Id + '&key=' + onlineApplication.Application_Key__c;
            }

            result = Database.upsert(onlineApplication, false);
            if (!result.isSuccess()) {
                throw new creditApplicationException('Critical error inserting the Online Application: ' + result.getErrors());
            }

            System.debug('### Online Application: ' + onlineApplication.Id);

            System.debug('### Online Application Dump: ' + onlineApplication);

            if (!isBOExempt && beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {

                PageReference redirect = Page.BOCertification;

                redirect.getParameters().put('pgm', program.Brand_Short_Name__c);
                redirect.getParameters().put('customer', onlineApplication.Id);
                if (onlineApplication.Opportunity__r.Beneficial_Owner_Entity__c != null) {
                    redirect.getParameters().put('entityId', onlineApplication.Opportunity__r.Beneficial_Owner_Entity__c);
                    redirect.getParameters().put('formKey', applicationKey);
                }

                return redirect;

            } else {

                PageReference redirect = Page.OTRSetup;

                redirect.getParameters().put('pgm', program.Brand_Short_Name__c);
                redirect.getParameters().put('customer', onlineApplication.Id);
                redirect.getParameters().put('key', applicationKey);

                return redirect;

            }

            return null;

        } catch (Exception e) {

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            PageReference externalApplicationError = Page.ExternalApplicationError;
            externalApplicationError.getParameters().put('errorCode', errorNumber);
            externalApplicationError.getParameters().put('pgm', programParameter);
            externalApplicationError.setRedirect(true);
            return externalApplicationError;

        }

    }

    public void recalculatePG() {

        if ((onlineApplication != null && onlineApplication.AO_Address__c != null && onlineApplication.AO_City__c != null && onlineApplication.AO_State__c != null &&
                onlineApplication.AO_Zip_Code__c != null && onlineApplication.AO_Home_Phone_Number__c != null && onlineApplication.AO_Social_Security_Number__c != null && onlineApplication.AO_Date_of_Birth__c != null) || isPG) {

            forcePg = true;

        } else {
            forcePg = false;
        }

    }

    public PageReference doNothing() {

        return null;

    }

    public class OTRBOCAAdditionalAttributes {

        public String ssn { get; set; }
        public String abaRoutingNumber { get; set; }
        public String checkingAccountNumber { get; set; }

        public OTRBOCAAdditionalAttributes() {

        }

    }
}