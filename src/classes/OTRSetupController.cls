public without sharing class OTRSetupController {

    public final static String APPLICATION_NAME = 'OTRSetup';

    public String customerParameter {
        get {
            if (!String.isEmpty(ApexPages.currentPage().getParameters().get('customer'))) {
                return ApexPages.currentPage().getParameters().get('customer');
            }
            return null;
        }
    }

    public String applicationKey {
        get {
            return ApexPages.currentPage().getParameters().get('key');
        }
    }

    public Campaign campaign { get; set; }

    public OnlineApplication__c onlineApplication { get; set; }

    public OnlineApplicationOffer__c onlineApplicationOffer { get; set; }

    public OnlineApplicationAuthorizedContact__c onlineApplicationAuthorizedContact { get; set; }

    public String cardType { get; set; }

    public Integer numberOfCards { get; set; }

    public List<OnlineApplicationUnitNumber__c> onlineApplicationUnits { get; set; }

    public Integer unitCollectionSize {
        get {
            if(onlineApplicationUnits != null) {
            return onlineApplicationUnits.size();
            }
            return null;
        }
    }

    public String selectedUnitIndex { get; set; }

    public List<OnlineApplicationDriverSetup__c> onlineApplicationDrivers { get; set; }

    public Integer driverCollectionSize {
        get {
            if(onlineApplicationDrivers != null) {
            return onlineApplicationDrivers.size();
            }
            return -1;
        }
    }

    public String selectedDriverIndex { get; set; }

    public String selectedAddressOption { get; set; }

    public List<String> otherServices { get; set; }

    public String selectedOtherServices { get; set; }

    public Integer otherServicesSize {
        get {
            if(otherServices != null) {
                return otherServices.size();
            }
            return 0;
        }
    }

    public Program__c program { get; set; }

    // Get the program parameter - required at the very least
    public String programParameter {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
        }
    }

    // Language Code for the BOCA
    public String languageCode {
        get {
            if (ApexPages.currentPage().getParameters().get('lang') != null) {
                return ApexPages.currentPage().getParameters().get('lang');
            }
            return 'en_us';
        }
    }

    // Branding utility related to the program
    public BOCA_res__c brandingUtility { get; set; }

    // Branding logo related to the program
    public Id brandingLogo { get; set; }

    // Branding card related to the program
    public Id brandingCard { get; set; }

    public String salesCode {
        get {
            return ApexPages.currentPage().getParameters().get('salescode');
        }
    }

    // Sales rep information if BOCA to Prospect
    public User salesRep {
        get {
            if (salesCode != null) {
                List<User> u = new List<User>();

                try {
                    u = [SELECT Name, Id, Email, Phone, Sales_Code__c, Fax FROM User WHERE Sales_Code__c = :salesCode LIMIT 1];
                } catch (SYSTEM.DmlException ex) {
                    System.debug('Exception during Sales Rep lookup: ' + ex);
                }

                return (u.size() != 0) ? u.get(0) : null;
            }
            return null;
        }
    }

    public class creditApplicationException extends Exception { }

    public OTRSetupController() {

        numberOfCards = 1;

        selectedAddressOption = 'yes';

        // Setting this for now to remove the "driver/unit" flip
        cardType = 'driver';

    }

    public PageReference init() {

        PageReference redirect = null;

        try {

            System.debug(customerParameter);
            ///eee

            if (!String.isEmpty(customerParameter)) {

                List<OnlineApplication__c> onlineApplications = [
                        SELECT Id, Name, Program__c, Offer__c, Other_Services__c, Invoice_Delivery_Method_Email__c, Credit_Line_Requested__c, Billing_Cycle__c, Invoice_Delivery_Method__c,
                                Business_Street_Address__c, City__c, State__c, Country__c, Zip_Code__c, Number_of_Cards_Needed__c, Embossing_Line_1_Company_Name__c, Number_of_Drivers__c,
                                Driver__c, Odometer__c, Trip__c, Unit__c, ATM__c, PlusCheks__c, Daily_Fuel_Gallons__c, Daily_Cash_Limit__c, Daily_DEF_Limit__c, Business_Address_Line_2__c,
                                Card_Shipping_Address_Line_1__c, Card_Shipping_Address_Line_2__c, Card_Shipping_City__c, Card_Shipping_State__c, Card_Shipping_Postal_Code__c, Card_Shipping_Country__c, Card_Shipping_Attention__c,
                                Opportunity__r.CampaignId, Contact_Last_Name__c, Email__c, Contact_First_Name__c, Phone_Number__c, Cell_Number__c, Opportunity__r.Campaign_Program__c,
                                Card_Shipping_First_Name__c, Card_Shipping_Last_Name__c
                        FROM OnlineApplication__c
                        WHERE Id = :customerParameter AND Status__c = 'App-Incomplete'
                        LIMIT 1
                ];

                if (!onlineApplications.isEmpty()) {

                    onlineApplication = onlineApplications[0];

                    if (onlineApplication.Program__c != null) {

                        program = WexBrandingController.getProgram(onlineApplication.Program__c);

                        Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(program.Id, languageCode);

                        if (brandingUtilityId != null) {

                            brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                        }

                        brandingLogo = WexBrandingController.getLogoId(program.Id);

                        brandingCard = WexBrandingController.getCreditCardImageId(program.Id);

                        // Get the Online Application Offer
                        onlineApplicationOffer = WexBrandingController.getOnlineApplicationOfferById(onlineApplication.Offer__c);

                        campaign = WexBrandingController.getCampaignByCampaignProgram(onlineApplication.Opportunity__r.Campaign_Program__c);

                    }

                    onlineApplicationDrivers = new List<OnlineApplicationDriverSetup__c>();

                    if(applicationKey != null) {

                        List<OnlineApplicationDriverSetup__c> onlineApplicationDriverSetups = [SELECT Id, Driver_First_Name__c, Driver_Last_Name__c, Driver_ID__c, Driver_Name__c FROM OnlineApplicationDriverSetup__c WHERE Online_Application__c =: customerParameter AND Online_Application__r.Application_Key__c =: applicationKey AND Online_Application__r.Application_Stage__c = 'Application' AND Online_Application__r.Status__c = 'App-Incomplete'];

                        if(onlineApplicationDriverSetups.size() > 0) {
                            onlineApplicationDrivers = onlineApplicationDriverSetups;
                        }

                    }

                    for (Integer i = 0; i < 7; i++) {
                        addDriver();
                    }

                    onlineApplicationUnits = new List<OnlineApplicationUnitNumber__c>();

                    if(applicationKey != null) {

                        List<OnlineApplicationUnitNumber__c> onlineApplicationUnitNumbers = [SELECT Id, Name FROM OnlineApplicationUnitNumber__c WHERE Online_Application__c =: customerParameter AND Online_Application__r.Application_Key__c =: applicationKey AND Online_Application__r.Application_Stage__c = 'Application' AND Online_Application__r.Status__c = 'App-Incomplete'];

                        if(onlineApplicationUnitNumbers.size() > 0) {
                            onlineApplicationUnits = onlineApplicationUnitNumbers;
                        }

                    }

                    for (Integer i = 0; i < 7; i++) {
                        addUnit();
                    }

                    if(applicationKey != null) {
                        List<OnlineApplicationAuthorizedContact__c> onlineApplicationAuthorizedContacts = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone_Number__c, Mobile_Number__c FROM OnlineApplicationAuthorizedContact__c WHERE Online_Application__c =: customerParameter AND Online_Application__r.Application_Key__c =: applicationKey AND Online_Application__r.Application_Stage__c = 'Application' AND Online_Application__r.Status__c = 'App-Incomplete'];

                        if(onlineApplicationAuthorizedContacts.size() > 0) {
                            onlineApplicationAuthorizedContact = onlineApplicationAuthorizedContacts[0];
                        }
                    }
                    else {
                        onlineApplicationAuthorizedContact = new OnlineApplicationAuthorizedContact__c();
                        onlineApplicationAuthorizedContact.First_Name__c = onlineApplication.Contact_First_Name__c;
                        onlineApplicationAuthorizedContact.Last_Name__c = onlineApplication.Contact_Last_Name__c;
                        onlineApplicationAuthorizedContact.Email__c = onlineApplication.Email__c;
                        onlineApplicationAuthorizedContact.Phone_Number__c = onlineApplication.Phone_Number__c;
                        onlineApplicationAuthorizedContact.Mobile_Number__c = onlineApplication.Cell_Number__c;
                    }

                    if(applicationKey == null) {
                        populateAddress();
                    }

                    numberOfCards = (onlineApplication.Number_of_Drivers__c).intValue();

                }

            }
            else {
                throw new creditApplicationException('Customer parameter missing. Cannot find specified application.');
            }
        }
        catch (Exception e) {

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            PageReference otrBOCAError = Page.ExternalApplicationError;
            otrBOCAError.getParameters().put('errorCode', errorNumber);
            otrBOCAError.getParameters().put('pgm', programParameter);
            otrBOCAError.setRedirect(true);
            return otrBOCAError;

        }

        return redirect;

    }

    public void populateAddress() {
        if (selectedAddressOption.equalsIgnoreCase('yes')) {
            if (onlineApplication != null) {
                onlineApplication.Card_Shipping_Address_Line_1__c = onlineApplication.Business_Street_Address__c;
                onlineApplication.Card_Shipping_Address_Line_2__c = onlineApplication.Business_Address_Line_2__c;
                onlineApplication.Card_Shipping_City__c = onlineApplication.City__c;
                onlineApplication.Card_Shipping_Country__c = onlineApplication.Country__c;
                onlineApplication.Card_Shipping_State__c = onlineApplication.State__c;
                onlineApplication.Card_Shipping_Postal_Code__c = onlineApplication.Zip_Code__c;
            }
        } else {
            if (onlineApplication != null) {
                onlineApplication.Card_Shipping_Address_Line_1__c = '';
                onlineApplication.Card_Shipping_Address_Line_2__c = '';
                onlineApplication.Card_Shipping_City__c = '';
                onlineApplication.Card_Shipping_State__c = '';
                onlineApplication.Card_Shipping_Postal_Code__c = '';
                onlineApplication.Card_Shipping_Country__c = '';
            }
        }
    }

    public void addDriver() {
        if(onlineApplication != null && onlineApplicationDrivers != null) {
        	OnlineApplicationDriverSetup__c driver = new OnlineApplicationDriverSetup__c(Online_Application__c = onlineApplication.Id);
        	onlineApplicationDrivers.add(driver);
        }
    }

    public void removeDriver() {
        System.debug(selectedDriverIndex);

        List<OnlineApplicationDriverSetup__c> newList = new List<OnlineApplicationDriverSetup__c>();

        if(onlineApplicationDrivers != null) {
        for (Integer i = 0; i < onlineApplicationDrivers.size(); i++) {
            if (i == Integer.valueOf(selectedDriverIndex)) {
                System.debug('Removing ' + i);
                continue;
            }

            newList.add(onlineApplicationDrivers.get(i));
        }

        onlineApplicationDrivers = newList;

        }

    }

    public void addUnit() {
        if(onlineApplication != null) {
        OnlineApplicationUnitNumber__c unit = new OnlineApplicationUnitNumber__c(Online_Application__c = onlineApplication.Id);
        onlineApplicationUnits.add(unit);
        }
    }

    public void removeVehicle() {
        List<OnlineApplicationUnitNumber__c> newList = new List<OnlineApplicationUnitNumber__c>();

        if(onlineApplicationUnits != null) {
        for (Integer i = 0; i < onlineApplicationUnits.size(); i++) {
            if (i == Integer.valueOf(selectedUnitIndex)) {
                continue;
            }

            newList.add(onlineApplicationUnits.get(i));
        }

        onlineApplicationUnits = newList;
        }
    }

    // Re-factor with upserts of set, with all or nothing
    public PageReference submitForm() {

        try {

            if (program.WEX_Platform__c != null && (program.WEX_Platform__c).equalsIgnoreCase('CoreCard')) {
                onlineApplication.Daily_DEF_Limit__c = 0;
            }

            if (TestUtils.isRunningTest() || program.Disable_Instant_Decisioning__c == true) {
                onlineApplication.Application_Stage__c = 'Application';
                onlineApplication.Status__c = 'Saved-Complete';
            } else {
                onlineApplication.Application_Stage__c = 'Adjudication';
                onlineApplication.Status__c = 'Pending Decision';
                onlineApplication.Submitted_to_Credit__c = Datetime.now();
            }

            onlineApplication.Number_of_Cards_Needed__c = numberOfCards;

            if (selectedOtherServices != null) {
                onlineApplication.Other_Services__c = selectedOtherServices;
            }

            upsert onlineApplication;

            onlineApplicationAuthorizedContact.Online_Application__c = onlineApplication.Id;

            try {
                insert onlineApplicationAuthorizedContact;
            } catch (Exception e) {
                WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);
            }

            for (Integer i = 0; i < onlineApplicationDrivers.size(); i++) {

                OnlineApplicationDriverSetup__c driver = onlineApplicationDrivers.get(i);

                if (!String.isEmpty(driver.Driver_Name__c)) {

                    if ((driver.Driver_Name__c).indexOf(' ') > 0) {
                        driver.Driver_First_Name__c = (driver.Driver_Name__c).substring(0, (driver.Driver_Name__c).indexOf(' '));
                        driver.Driver_Last_Name__c = (driver.Driver_Name__c).substring((driver.Driver_Name__c).indexOf(' ') + 1);
                    } else {
                        driver.Driver_First_Name__c = (driver.Driver_Name__c);
                        driver.Driver_Last_Name__c = '';
                    }

                    try {
                        insert driver;
                    } catch (Exception e) {
                        WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);
                    }

                }

            }

            for (Integer i = 0; i < onlineApplicationUnits.size(); i++) {

                OnlineApplicationUnitNumber__c unit = onlineApplicationUnits.get(i);

                if (!String.isEmpty(unit.Name)) {

                    try {
                        insert unit;
                    } catch (Exception e) {
                        WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);
                    }

                }

            }

            Datetime dt = Datetime.now();
            Long l = dt.getTime();

            String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(256));

            onlineApplication.PDF_Token__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + onlineApplication.Application_Signer_IP__c + salt)));

            upsert onlineApplication;

        } catch (Exception e) {
            System.debug('Exception Encountered Submitting Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);

            PageReference otrBOCAError = Page.ExternalApplicationError;
            otrBOCAError.getParameters().put('errorCode', errorNumber);
            otrBOCAError.getParameters().put('pgm', programParameter);
            otrBOCAError.setRedirect(true);
            return otrBOCAError;
        }

        return null;

    }

    public PageReference generatePDFandConfirm() {

        PageReference redirect = null;

        try {

            Attachment pdfAttachment = new Attachment();

            if (!TestUtils.isRunningTest()) {

                pdfAttachment.ParentId = onlineApplication.Id;

                pdfAttachment.Name = onlineApplication.Name + '.pdf';

                PageReference bocaToPDF = Page.BOCAToPDF;
                bocaToPDF.getParameters().put('applicationId', onlineApplication.Id);
                bocaToPDF.getParameters().put('token', onlineApplication.PDF_Token__c);

                pdfAttachment.Body = bocaToPDF.getContentAsPDF();

                pdfAttachment.ContentType = 'application/pdf';

                insert pdfAttachment;

            }

            try {

                Map<String, BOCA_IDs__c> bocaIdMap = new Map<String, BOCA_IDs__c>();

                bocaIdMap = BOCA_IDs__c.getAll();

                BOCA_IDs__c singleBocaId = new BOCA_IDs__c();

                String replyTo = '';

                if (!bocaIdMap.isEmpty()) {
                    singleBocaId = bocaIdMap.get('BOCA IDS');
                    replyTo = String.valueOf(singleBocaId.get('Email_Address_Noreply__c'));
                }

                List<RecordType> contactRecordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName IN ('F1_Contact')];

                Contact temporaryContact = new Contact();

                temporaryContact.FirstName = onlineApplication.Contact_First_Name__c;
                temporaryContact.LastName = onlineApplication.Contact_Last_Name__c;
                temporaryContact.Email = onlineApplication.Email__c;
                temporaryContact.RecordTypeId = contactRecordTypes[0].Id;

                insert temporaryContact;

                Messaging.reserveSingleEmailCapacity(1);
                Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();

                String[] ccAddresses = new String[] {onlineApplicationOffer.Partner_Group_Email_Address__c};

                confirmation.setTemplateId(brandingUtility.Email_Template_ID__c);
                confirmation.setWhatId(onlineApplication.Id);
                confirmation.setTargetObjectId(temporaryContact.Id);
                if (onlineApplicationOffer.CC_Partner_On_Confirmation_Email__c == true) {
                    confirmation.setCcAddresses(ccAddresses);
                }
                confirmation.setSaveAsActivity(false);
                confirmation.setReplyTo(replyTo);

                if (pdfAttachment != null) {

                    Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                    emailAttachment.setBody(pdfAttachment.Body);
                    emailAttachment.setContentType('application/pdf');
                    emailAttachment.setFileName(onlineApplication.Name + '.pdf');

                    confirmation.setFileAttachments(new List<Messaging.EmailFileAttachment>{
                            emailAttachment
                    });

                }

                for (OrgWideEmailAddress owa : [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress]) {
                    if (owa.Address.contains(replyTo)) {
                        confirmation.setOrgWideEmailAddressId(owa.Id);
                    }
                }

                if (!Test.isRunningTest()) {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ confirmation });
                }

            } catch (Exception e) {
                System.debug('### Unable to send email... ' + e.getMessage());
            }

            onlineApplication.PDF_Token__c = '';

            upsert onlineApplication;

        } catch (Exception e) {
            System.debug('Can\'t generate PDF: ' + e.getStackTraceString() + ' ' + e);

            WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage(), e, true);
        }

        redirect = Page.OTRBOCAConfirmation;
        if(onlineApplication != null) {
        redirect.getParameters().put('customer', onlineApplication.Id);
        }
        return redirect;

    }

}