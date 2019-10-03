global with sharing class CustomerConversionController {

    public final static String APPLICATION_NAME = 'Customer Conversion';

    public Customer_Conversion_Data__c conversionData { get; set; }

    public String previousAccountNumber { get; set; }

    public String programName {
        get {
            return ApexPages.currentPage().getParameters().get('pgm');
        }
    }

    public String confirmationNumber {
        get {
            return ApexPages.currentPage().getParameters().get('confirmationNumber');
        }
    }

    public Boolean mailingAddressSame { get; set; }

    public String bpavEvidenceName { get; set; }

    public Blob bpavEvidenceBody { get; set; }

    public String bpavMethod { get; set; }

    public String todaysDate {
        get {
            DateTime today = DateTime.now();
            if(languageCode != null && (languageCode.equalsIgnoreCase('en_ca') || languageCode.equalsIgnoreCase('fr_ca'))) {
            	return today.format('dd/MM/yyyy');
            }
            	return today.format('MM/dd/yyyy');
        }
    }

    public String overrideCSS {
        get {
            
            try {
            	StaticResource sr = null;

            	// A lot of this will be able to be removed after we're
            	// not having to support backwards compatability.. Path
            	// of least resistance..
            	if(program != null && !String.isEmpty(program.Conversion_Form_Style_Overrides__c)) {
	                sr = [SELECT Body FROM StaticResource WHERE Name = :program.Conversion_Form_Style_Overrides__c];
	
    	            return sr.Body.toString();
        	    }
            }
            catch(Exception e) {
                System.debug('Can\'t find it!');
            }

            return null;
        }
    }
    
    public String cacheControl {
        get {
            Datetime dt = Datetime.now();
            Long l = dt.getTime();

            return String.valueOf(l);
        }
    }

    // Language Code for the BOCA
    public String languageCode {
        get {

            String languageCodeParameter = ApexPages.currentPage().getParameters().get('lang');

            Cookie languageCodeCookie = ApexPages.currentPage().getCookies().get('languageCode');

            if((languageCodeParameter == null || String.isEmpty(languageCodeParameter)) && languageCodeCookie != null && !String.isEmpty(languageCodeCookie.getValue()) && availableLanguages != null && availableLanguages.contains(languageCodeCookie.getValue())) {
                languageCodeParameter = languageCodeCookie.getValue();
            }

            if((languageCodeParameter == null || String.isEmpty(languageCodeParameter))) {
                languageCodeParameter = 'en_us';
            }

            languageCodeCookie = new Cookie('languageCode',languageCodeParameter,null,-1,false);

            ApexPages.currentPage().setCookies(new Cookie[]{languageCodeCookie});

            return languageCodeParameter;

        }
    }

    public Integer currentStep { get; set; }
    public Integer minStep  { get; set; }
    public Integer maxStep  { get; set; }

    public Id brandingLogo { get; set; }

    public Program__c program { get; set; }

    public BOCA_res__c brandingUtility { get; set; }

    public String availableLanguages { get; set; }

    public String previousAccountNumberLength {
        get {
            if(program != null) {

                if(program.Previous_Account_Number_Min_Length__c == program.Previous_Account_Number_Max_Length__c) {
                    return String.valueOf(program.Previous_Account_Number_Max_Length__c);
                }
                else {
                    return String.valueOf(program.Previous_Account_Number_Min_Length__c) + '-' + String.valueOf(program.Previous_Account_Number_Max_Length__c);
                }

            }
            return null;
        }
    }

    public CustomerConversionController() {

        // Setup for the pagination
        minStep = 1;
        maxStep = 4;
        if(ApexPages.currentPage().getParameters().get('currentPage') != null) {
            currentStep = Integer.valueOf(ApexPages.currentPage().getParameters().get('currentPage'));
        }
        else if(ApexPages.currentPage().getParameters().get('confirmationNumber') != null) {
            currentStep = 4;
        }
        else {
            currentStep = 1;
        }

        System.debug('###' + currentStep);

    }

    public PageReference init() {

        conversionData = new Customer_Conversion_Data__c();

        mailingAddressSame = true;

        bpavMethod = 'Upload';


        try {

            if(programName == null) {
                throw new customerConversionException('No Program specified: ' + programName);
            }

            Id programId = WexBrandingController.getProgramIdByBrandShortName(programName);

            System.debug(programId);

            if(programId != null) {

                program = WexBrandingController.getProgram(programId);

                availableLanguages = WexBrandingController.getAvailableLanguages(programId);

                Id brandingUtilityId = WexBrandingController.getBrandingUtilityByProgramId(programId, languageCode);

                if(brandingUtilityId != null) {

                    brandingUtility = WexBrandingController.getBrandingUtility(brandingUtilityId);

                }

                if(WexBrandingController.getBPAVLogoId(programId) != null) {
                    brandingLogo = WexBrandingController.getBPAVLogoId(programId);
                }
                else {
                	brandingLogo = WexBrandingController.getLogoId(programId);
                }

            }
            else {
                throw new customerConversionException('Cannot find Program: ' + programName);
            }

        }
        catch(Exception e) {

            System.debug('### ERROR - Line ' + e.getLineNumber() + ' - ' + e.getMessage());

            PageReference errorPage = Page.ExternalApplicationError;

            return errorPage;

        }

        return null;

    }

    // Remote action to check the previous account number before
    // allowing them to continue in the form
    @RemoteAction
    global static Boolean validatePreviousAccountNumber(String previousAccountNumber, String conversionKeyPrefix) {

        String conversionKey = conversionKeyPrefix + '-' + previousAccountNumber;

        List<Customer_Conversion_Data__c> customerConversion = [SELECT Id FROM Customer_Conversion_Data__c
        WHERE Previous_Account_Number__c = :previousAccountNumber
        and Conversion_Record_Key__c = :conversionKey
        and Status__c in ('Pending Customer Response','Abandoned By Customer') LIMIT 1];

        if(customerConversion.size() > 0) {
            return true;
        }

        return false;

    }

    public void nextStep() {
        if(currentStep == 1) {
            setupConversionObject();
        }
        currentStep = currentStep + 1;
    }

    public void setupConversionObject() {

        if(!String.isEmpty(previousAccountNumber)) {
            String conversionKey = program.Conversion_Key__c + '-' + previousAccountNumber;

            Customer_Conversion_Data__c existingConversionData = [SELECT Id, Company_Name__c, First_Name__c, Last_Name__c, Phone__c,
                    Email_Address__c, Mailing_Address_Line_1__c, Mailing_Address_Line_2__c,
                    Mailing_City__c, Mailing_State__c, Mailing_Postal_Code__c, Physical_Address_Line_1__c,
                    Physical_Address_Line_2__c, Physical_City__c, Physical_State__c, Physical_Postal_Code__c,
                    BPAV_Needed__c, TIN_Needed__c, Certified_By__c, Certified_Date__c
            FROM Customer_Conversion_Data__c WHERE Previous_Account_Number__c = :previousAccountNumber and Conversion_Record_Key__c = :conversionKey LIMIT 1];

            conversionData = existingConversionData;

            // Nulling this out otherwise VF error
            if(conversionData.TIN_Needed__c) {
            	conversionData.Taxpayer_ID_EIN__c  = '';
            }

            conversionData.Status__c = 'Abandoned By Customer';

            upsert conversionData;
        }

    }

    public PageReference mailingAddressSameToggle() {

        if(mailingAddressSame) {
            conversionData.Mailing_Address_Line_1__c = conversionData.Physical_Address_Line_1__c;
            conversionData.Mailing_Address_Line_2__c = conversionData.Physical_Address_Line_2__c;
            conversionData.Mailing_City__c = conversionData.Physical_City__c;
            conversionData.Mailing_State__c = conversionData.Physical_State__c;
            conversionData.Mailing_Postal_Code__c = conversionData.Physical_Postal_Code__c;
        }
        else {
            conversionData.Mailing_Address_Line_1__c = '';
            conversionData.Mailing_Address_Line_2__c = '';
            conversionData.Mailing_City__c = '';
            conversionData.Mailing_State__c = '';
            conversionData.Mailing_Postal_Code__c = '';
        }

        return null;

    }

    public PageReference submitConversionForm() {

        try {

            conversionData.Status__c = 'Pending Review';
            conversionData.Customer_Completed__c = Date.today();
            conversionData.Certified_Date__c = Date.today();

            if(bpavMethod != null && (bpavMethod.equalsIgnoreCase('Fax') || bpavMethod.equalsIgnoreCase('Email'))) {
                conversionData.Status__c = 'Awaiting Physical Address Verification - ' + bpavMethod;
            }

            if(mailingAddressSame) {
            	mailingAddressSameToggle();
            }
            
            conversionData.Confirmation_Email_Address__c = conversionData.Email_Address__c;
            
            Database.UpsertResult result = Database.upsert(conversionData, false);

            if(result.isSuccess()){

                if(bpavEvidenceName != null && bpavEvidenceBody != null) {

                    Attachment physicalAddressAttachment = new Attachment();

                    physicalAddressAttachment.Body = bpavEvidenceBody;
                    physicalAddressAttachment.Name = bpavEvidenceName;
                    physicalAddressAttachment.ParentId = conversionData.Id;

                    try {
                        insert physicalAddressAttachment;
                    }
                    catch (Exception e) {
                        System.debug(e);
                    }
                    finally {
                        physicalAddressAttachment.Body = null;
                    }
                }

                String conversionConfirmationNumber = [SELECT Id, Name FROM Customer_Conversion_Data__c WHERE Id = : conversionData.Id].Name;

                PageReference conversionConfirmation = Page.CustomerConversion;
                conversionConfirmation.getParameters().put('confirmationNumber', conversionConfirmationNumber);
                conversionConfirmation.getParameters().put('pgm', program.Brand_Short_Name__c);
                conversionConfirmation.getParameters().put('lang', languageCode);
                conversionConfirmation.setRedirect(true);
                return conversionConfirmation;

            }


        } catch (Exception e) {

            System.debug('Exception Encountered Submitting Application: ' + e.getStackTraceString() + ' ' + e);

            String errorNumber = WEXDEVErrorReporting.reportExternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), e);

            PageReference errorPage = Page.ExternalApplicationError;
            errorPage.getParameters().put('errorCode', errorNumber);
            return errorPage;

        }

        return null;
    }

    public class customerConversionException extends Exception {}

}