public with sharing class CreditWS_LexisNexisRDP {

    // Settings for Lexis / Nexis Business IID
    public static Credit_Decision_Engine_Endpoints__mdt lexisNexisBIIDSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt lexisNexisBIIDSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c, Operating_Mode__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexisRDP_BIID'];

                return lexisNexisBIIDSettings;

            } catch (Exception e) {

                System.debug('### ERROR: Error getting LexisNexis BIID connection settings.');

            }

            return null;

        }
    }

    // Settings for Lexis / Nexis Consumer IID
    public static Credit_Decision_Engine_Endpoints__mdt lexisNexisIIDSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt lexisNexisIIDSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c, Operating_Mode__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexisRDP_IID'];

                return lexisNexisIIDSettings;

            } catch (Exception e) {

                System.debug('### ERROR: Error getting LexisNexis Consumer IID connection settings.');

            }

            return null;

        }
    }

    // Settings for Lexis / Nexis Consumer IID
    public static Credit_Decision_Engine_Endpoints__mdt lexisNexisSmallBusinessAnalyticsSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt lexisNexisSmallBusinessAnalyticsSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c, Operating_Mode__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexisRDP_SBA'];

                return lexisNexisSmallBusinessAnalyticsSettings;

            } catch (Exception e) {

                System.debug('### ERROR: Error getting LexisNexis Small Business Analytics connection settings.');

            }

            return null;

        }
    }

    public static LexisNexisBIIDResponse lexisNexisBusinessInstantID(LexisNexisBIIDRequest lexisNexisBIIDRequest) {

        LexisNexisBIIDResponse lexisNexisBIIDResponse = new LexisNexisBIIDResponse();

        try {

            CreditWSUtil_LexisNexisBIID request = new CreditWSUtil_LexisNexisBIID();

            request.Type_x = 'Initiate';

            request.Settings = new CreditWSUtil_LexisNexisBIID.cls_Settings();
            request.Settings.Mode = lexisNexisBIIDSettings.Operating_Mode__c;
            request.Settings.Reference = lexisNexisBIIDRequest.applicationId;
            request.Settings.Locale = 'en_US';
            request.Settings.Venue = 'online';

            CreditWSUtil_LexisNexisBIID.cls_Businesses businesses = new CreditWSUtil_LexisNexisBIID.cls_Businesses();

            businesses.CompanyName = lexisNexisBIIDRequest.businessName;
            if (!String.isBlank(lexisNexisBIIDRequest.federalTaxId)) {
                businesses.Fein = lexisNexisBIIDRequest.federalTaxId.replaceAll('[^0-9]', '');
            }

            CreditWSUtil_LexisNexisBIID.cls_Addresses addresses = new CreditWSUtil_LexisNexisBIID.cls_Addresses();

            addresses.StreetAddress1 = lexisNexisBIIDRequest.streetAddress;
            addresses.City = lexisNexisBIIDRequest.city;
            addresses.State = lexisNexisBIIDRequest.state;
            addresses.Zip5 = lexisNexisBIIDRequest.postalCode;
            if ((addresses.Zip5).length() > 5) {
                addresses.Zip5 = (addresses.Zip5).substring(0, 5);
            }
            addresses.Country = 'US';
            addresses.Context = 'primary';

            businesses.Addresses = new CreditWSUtil_LexisNexisBIID.cls_Addresses[]{
                    addresses
            };

            if (!String.isBlank(lexisNexisBIIDRequest.phoneNumber)) {

                CreditWSUtil_LexisNexisBIID.cls_Phones phones = new CreditWSUtil_LexisNexisBIID.cls_Phones();

                phones.Number_x = lexisNexisBIIDRequest.phoneNumber.replaceAll('[^0-9]', '');
                phones.Context = 'business';

                businesses.Phones = new CreditWSUtil_LexisNexisBIID.cls_Phones[]{
                        phones
                };

            }

            request.Businesses = new CreditWSUtil_LexisNexisBIID.cls_Businesses[]{
                    businesses
            };

            if(lexisNexisBIIDRequest.lexisNexisAuthorizedRepresenatives != null) {

                request.Persons = new CreditWSUtil_LexisNexisBIID.cls_Persons[]{};

                for(LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative : lexisNexisBIIDRequest.lexisNexisAuthorizedRepresenatives) {

                    CreditWSUtil_LexisNexisBIID.cls_Persons person = new CreditWSUtil_LexisNexisBIID.cls_Persons();

                    person.Name = new CreditWSUtil_LexisNexisBIID.cls_Name();

                    person.Name.FirstName = lexisNexisAuthorizedRepresenative.firstName;
                    person.Name.LastName = lexisNexisAuthorizedRepresenative.lastName;

                    CreditWSUtil_LexisNexisBIID.cls_Addresses personsAddress = new CreditWSUtil_LexisNexisBIID.cls_Addresses();

                    personsAddress.StreetAddress1 = lexisNexisAuthorizedRepresenative.streetAddress;
                    personsAddress.City = lexisNexisAuthorizedRepresenative.city;
                    personsAddress.State = lexisNexisAuthorizedRepresenative.state;
                    personsAddress.Zip5 = lexisNexisAuthorizedRepresenative.postalCode;
                    if ((personsAddress.Zip5).length() > 5) {
                        personsAddress.Zip5 = (personsAddress.Zip5).substring(0, 5);
                    }
                    personsAddress.Country = 'US';
                    personsAddress.Context = 'primary';

                    person.Addresses = new CreditWSUtil_LexisNexisBIID.cls_Addresses[]{
                            personsAddress
                    };

                    person.SSN = new CreditWSUtil_LexisNexisBIID.cls_SSN();

                    if (!String.isBlank(lexisNexisAuthorizedRepresenative.socialSecurityNumber)) {
                        person.SSN.Number_x = lexisNexisAuthorizedRepresenative.socialSecurityNumber.replaceAll('[^0-9]', '');
                    }
                    person.SSN.Type_x = 'ssn9';

                    if (lexisNexisAuthorizedRepresenative.dateOfBirth != null) {

                        person.DateOfBirth = new CreditWSUtil_LexisNexisBIID.cls_DateOfBirth();

                        person.DateOfBirth.Year = String.valueOf(lexisNexisAuthorizedRepresenative.dateOfBirth.year());
                        person.DateOfBirth.Day = String.valueOf(lexisNexisAuthorizedRepresenative.dateOfBirth.day());
                        person.DateOfBirth.Month = String.valueOf(lexisNexisAuthorizedRepresenative.dateOfBirth.month());

                    }

                    if (!String.isBlank(lexisNexisAuthorizedRepresenative.phoneNumber)) {

                        CreditWSUtil_LexisNexisBIID.cls_Phones phones = new CreditWSUtil_LexisNexisBIID.cls_Phones();

                        phones.Number_x = lexisNexisAuthorizedRepresenative.phoneNumber.replaceAll('[^0-9]', '');
                        phones.Context = 'primary';

                    }

                    person.Context = 'primary';

                    request.Persons.add(person);

                }

            }

            String jsonRequest = CreditWS_LexisNexisRDP.jsonKeywordSafeReplace(JSON.serializePretty(request, true), true);

            HttpRequest httpRequest = new HttpRequest();

            httpRequest.setEndpoint(lexisNexisBIIDSettings.Endpoint_URL__c);

            httpRequest.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(lexisNexisBIIDSettings.Username__c + ':' + lexisNexisBIIDSettings.Password__c)));
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setMethod('POST');

            httpRequest.setBody(jsonRequest);

            Http http = new Http();

            HTTPResponse httpResponse = http.send(httpRequest);

            System.debug('Lexis Nexis RDP repsonse body: ' + httpResponse.getBody());

            CreditWSUtil_LexisNexisBIID response = CreditWSUtil_LexisNexisBIID.parse(CreditWS_LexisNexisRDP.jsonKeywordSafeReplace(httpResponse.getBody(), false));

            System.debug('Lexis Nexis RDP response: ' + response);

            if(response != null) {

                for(CreditWSUtil_LexisNexisBIID.cls_Products product : response.Products) {

                    lexisNexisBIIDResponse.biidWorkflowResult = product.ProductStatus;

                    for(CreditWSUtil_LexisNexisBIID.cls_ParameterDetails parameterDetail : product.ParameterDetails) {

                        if((parameterDetail.Group_x).equalsIgnoreCase('BVI') && (parameterDetail.Name).equalsIgnoreCase('BusinessVerification')) {

                            lexisNexisBIIDResponse.biidScore = Integer.valueOf(parameterDetail.Values[0].Value);

                        }
                        else if((parameterDetail.Group_x).equalsIgnoreCase('VERIFICATION_SUMMARIES') && (parameterDetail.Name).equalsIgnoreCase('AR_1_ComprehensiveVerificationIndex')) {

                            lexisNexisBIIDResponse.biidScore = Integer.valueOf(parameterDetail.Values[0].Value);

                        }
                    }
                }
            }

        } catch (Exception e) {

            System.debug('### ERROR: ' + e.getMessage() + '\n' + e.getStackTraceString());

        }

        if(String.isEmpty(lexisNexisBIIDResponse.biidWorkflowResult)) {
            lexisNexisBIIDResponse.biidWorkflowResult = 'Fail';
        }

        return lexisNexisBIIDResponse;

    }

    public static LexisNexisIIDResponse lexisNexisConsumerInstantId(LexisNexisIIDRequest lexisNexisIIDRequest) {

        LexisNexisIIDResponse lexisNexisIIDResponse = new LexisNexisIIDResponse();

        try {

            CreditWSUtil_LexisNexisIID request = new CreditWSUtil_LexisNexisIID();

            request.Type_x = 'Initiate';

            request.Settings = new CreditWSUtil_LexisNexisIID.cls_Settings();
            request.Settings.Mode = lexisNexisIIDSettings.Operating_Mode__c;
            request.Settings.Reference = lexisNexisIIDRequest.applicationId;
            request.Settings.Locale = 'en_US';
            request.Settings.Venue = 'online';

            CreditWSUtil_LexisNexisIID.cls_Persons person = new CreditWSUtil_LexisNexisIID.cls_Persons();

            person.Name = new CreditWSUtil_LexisNexisIID.cls_Name();

            person.Name.FirstName = lexisNexisIIDRequest.firstName;
            person.Name.LastName = lexisNexisIIDRequest.lastName;

            CreditWSUtil_LexisNexisIID.cls_Addresses addresses = new CreditWSUtil_LexisNexisIID.cls_Addresses();

            addresses.StreetAddress1 = lexisNexisIIDRequest.streetAddress;
            addresses.City = lexisNexisIIDRequest.city;
            addresses.State = lexisNexisIIDRequest.state;
            addresses.Zip5 = lexisNexisIIDRequest.postalCode;
            if ((addresses.Zip5).length() > 5) {
                addresses.Zip5 = (addresses.Zip5).substring(0, 5);
            }
            addresses.Country = 'US';
            addresses.Context = 'primary';

            person.Addresses = new CreditWSUtil_LexisNexisIID.cls_Addresses[]{
                    addresses
            };

            person.SSN = new CreditWSUtil_LexisNexisIID.cls_SSN();

            if (!String.isBlank(lexisNexisIIDRequest.socialSecurityNumber)) {
                person.SSN.Number_x = lexisNexisIIDRequest.socialSecurityNumber.replaceAll('[^0-9]', '');
            }
            person.SSN.Type_x = 'ssn9';

            if (lexisNexisIIDRequest.dateOfBirth != null) {

                person.DateOfBirth = new CreditWSUtil_LexisNexisIID.cls_DateOfBirth();

                person.DateOfBirth.Year = String.valueOf(lexisNexisIIDRequest.dateOfBirth.year());
                person.DateOfBirth.Day = String.valueOf(lexisNexisIIDRequest.dateOfBirth.day());
                person.DateOfBirth.Month = String.valueOf(lexisNexisIIDRequest.dateOfBirth.month());

            }

            if (!String.isBlank(lexisNexisIIDRequest.phoneNumber)) {

                CreditWSUtil_LexisNexisIID.cls_Phones phones = new CreditWSUtil_LexisNexisIID.cls_Phones();

                phones.Number_x = lexisNexisIIDRequest.phoneNumber.replaceAll('[^0-9]', '');
                phones.Context = 'primary';

            }

            person.Context = 'primary';

            request.Persons = new CreditWSUtil_LexisNexisIID.cls_Persons[]{
                    person
            };

            String jsonRequest = CreditWS_LexisNexisRDP.jsonKeywordSafeReplace(JSON.serializePretty(request, true), true);

            System.debug(jsonRequest);

            HttpRequest httpRequest = new HttpRequest();

            httpRequest.setEndpoint(lexisNexisIIDSettings.Endpoint_URL__c);

            httpRequest.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(lexisNexisIIDSettings.Username__c + ':' + lexisNexisIIDSettings.Password__c)));
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setMethod('POST');

            httpRequest.setBody(jsonRequest);

            Http http = new Http();

            HTTPResponse httpResponse = http.send(httpRequest);

            CreditWSUtil_LexisNexisIID response = CreditWSUtil_LexisNexisIID.parse(CreditWS_LexisNexisRDP.jsonKeywordSafeReplace(httpResponse.getBody(), false));

            if (response != null) {
                for (CreditWSUtil_LexisNexisIID.cls_Products product : response.Products) {

                    if ((product.ExecutedStepName).equalsIgnoreCase('InstantID')) {
                        lexisNexisIIDResponse.iidWorkflowResult = product.ProductStatus;
                    }
                    else if((product.ExecutedStepName).equalsIgnoreCase('FraudPoint')) {
                        lexisNexisIIDResponse.fraudPointWorkflowResult = product.ProductStatus;
                    }

                    if (product.ParameterDetails != null) {


                        for (CreditWSUtil_LexisNexisIID.cls_ParameterDetails parameterDetails : product.ParameterDetails) {

                            if (!String.isBlank(parameterDetails.Group_x) && !String.isBlank(parameterDetails.Name)
                                    && (parameterDetails.Group_x).equalsIgnoreCase('FRAUD_POINT') && (parameterDetails.Name).equalsIgnoreCase('LexID')) {

                                lexisNexisIIDResponse.fraudPointScore = Integer.valueOf(parameterDetails.Values[0].Value);
                            }
                            if((parameterDetails.Group_x).equalsIgnoreCase('COMPREHENSIVE_VERIFICATION_INDEX') && (parameterDetails.Name).equalsIgnoreCase('CVI')) {

                                lexisNexisIIDResponse.cviScore = Integer.valueOf(parameterDetails.Values[0].Value);
                            }

                        }

                    }

                }
            }

        } catch (Exception e) {

            System.debug('### ' + e.getMessage() + '\n' + e.getStackTraceString());

        }

        if(String.isBlank(lexisNexisIIDResponse.iidWorkflowResult)) {
            lexisNexisIIDResponse.iidWorkflowResult = 'Fail';
        }
        if(String.isBlank(lexisNexisIIDResponse.fraudPointWorkflowResult)) {
            lexisNexisIIDResponse.fraudPointWorkflowResult = 'Fail';
        }
        if(lexisNexisIIDResponse.fraudPointScore == null) {
            lexisNexisIIDResponse.fraudPointScore = 0;
        }

        return lexisNexisIIDResponse;

    }

    public static LexisNexisSBAResponse lexisNexisSmallBusinessAnalytics(LexisNexisSBARequest lexisNexisSBARequest) {

        LexisNexisSBAResponse lexisNexisSBAResponse = new LexisNexisSBAResponse();

        try {

            CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsRequest_element smallBusinessAnalyticsRequestElement = new CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsRequest_element();

            smallBusinessAnalyticsRequestElement.User_x = new CreditWSUtil_LexisNexisSBA.User_x();

            smallBusinessAnalyticsRequestElement.User_x.ReferenceCode = 'test';
            smallBusinessAnalyticsRequestElement.User_x.GLBPurpose = '1';

            smallBusinessAnalyticsRequestElement.Options = new CreditWSUtil_LexisNexisSBA.SBAOptions();

            smallBusinessAnalyticsRequestElement.Options.IncludeModels = new CreditWSUtil_LexisNexisSBA.SBAModels();

            CreditWSUtil_LexisNexisSBA.Names_element namesElement = new CreditWSUtil_LexisNexisSBA.Names_element();

            namesElement.Name = new String[]{
                    'BOFM1812_1_0'
            };

            smallBusinessAnalyticsRequestElement.Options.IncludeModels.Names = namesElement;

            smallBusinessAnalyticsRequestElement.SearchBy = new CreditWSUtil_LexisNexisSBA.SBASearchBy();

            smallBusinessAnalyticsRequestElement.SearchBy.Company = new CreditWSUtil_LexisNexisSBA.SBACompany();
            smallBusinessAnalyticsRequestElement.SearchBy.Company.CompanyName = lexisNexisSBARequest.companyName;

            smallBusinessAnalyticsRequestElement.SearchBy.Company.Address = new CreditWSUtil_LexisNexisSBA.Address();
            smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.StreetAddress1 = lexisNexisSBARequest.streetAddress;
            smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.City = lexisNexisSBARequest.city;
            smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.State = lexisNexisSBARequest.state;
            smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.Zip5 = lexisNexisSBARequest.postalCode;
            if ((smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.Zip5).length() > 5) {
                smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.Zip5 = (smallBusinessAnalyticsRequestElement.SearchBy.Company.Address.Zip5).substring(0, 5);
            }

            if(!String.isEmpty(lexisNexisSBARequest.phoneNumber)) {
                smallBusinessAnalyticsRequestElement.SearchBy.Company.Phone = lexisNexisSBARequest.phoneNumber.replaceAll('[^0-9]', '');
            }
            if(!String.isEmpty(lexisNexisSBARequest.federalTaxID)) {
                smallBusinessAnalyticsRequestElement.SearchBy.Company.FEIN = lexisNexisSBARequest.federalTaxId.replaceAll('[^0-9]', '');
            }

            // Dear Lexis Nexis - If you're going to accept multiples - ever heard of an array? Love Derek.
            if (lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives != null && lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives.size() > 0) {

                Integer count = 1;
                for (LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative : lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives) {
                    if (count > 3) {
                        continue;
                    }

                    CreditWSUtil_LexisNexisSBA.SBAAuthRep authRep = new CreditWSUtil_LexisNexisSBA.SBAAuthRep();

                    authRep = new CreditWSUtil_LexisNexisSBA.SBAAuthRep();

                    authRep.Name = new CreditWSUtil_LexisNexisSBA.Name();
                    authRep.Name.First = lexisNexisAuthorizedRepresenative.firstName;
                    authRep.Name.Last = lexisNexisAuthorizedRepresenative.lastName;

                    authRep.Address = new CreditWSUtil_LexisNexisSBA.Address();

                    authRep.Address.StreetAddress1 = lexisNexisAuthorizedRepresenative.streetAddress;
                    authRep.Address.City = lexisNexisAuthorizedRepresenative.city;
                    authRep.Address.State = lexisNexisAuthorizedRepresenative.state;
                    authRep.Address.Zip5 = lexisNexisAuthorizedRepresenative.postalCode;
                    if (!String.isBlank(authRep.Address.Zip5) && (authRep.Address.Zip5).length() > 5) {
                        authRep.Address.Zip5 = (authRep.Address.Zip5).substring(0, 5);
                    }

                    if (!String.isBlank(lexisNexisAuthorizedRepresenative.socialSecurityNumber)) {
                        authRep.SSN = lexisNexisAuthorizedRepresenative.socialSecurityNumber.replaceAll('[^0-9]', '');
                    }
                    if (!String.isBlank(lexisNexisAuthorizedRepresenative.phoneNumber)) {
                        authRep.Phone = lexisNexisAuthorizedRepresenative.phoneNumber.replaceAll('[^0-9]', '');
                    }

                    if (lexisNexisAuthorizedRepresenative.dateOfBirth != null) {

                        authRep.DOB = new CreditWSUtil_LexisNexisSBA.Date_x();

                        authRep.DOB.Month = lexisNexisAuthorizedRepresenative.dateOfBirth.month();
                        authRep.DOB.Day = lexisNexisAuthorizedRepresenative.dateOfBirth.day();
                        authRep.DOB.Year = lexisNexisAuthorizedRepresenative.dateOfBirth.year();

                    }

                    // I can't even...
                    switch on count {
                        when 1 {
                            smallBusinessAnalyticsRequestElement.SearchBy.AuthorizedRep1 = authRep;
                        }
                        when 2 {
                            smallBusinessAnalyticsRequestElement.SearchBy.AuthorizedRep2 = authRep;
                        }
                        when 3 {
                            smallBusinessAnalyticsRequestElement.SearchBy.AuthorizedRep3 = authRep;
                        }
                        when else { // do nothing }
                        }

                    }

                }

            }

            CreditWSUtil_LexisNexisSBA.WsAnalyticsServiceSoap lexisNexisSBACalloutSOAP = new CreditWSUtil_LexisNexisSBA.WsAnalyticsServiceSoap();

            lexisNexisSBACalloutSOAP.endpoint_x = lexisNexisSmallBusinessAnalyticsSettings.Endpoint_URL__c;
            lexisNexisSBACalloutSOAP.inputHttpHeaders_x = new Map<String, String>();
            lexisNexisSBACalloutSOAP.inputHttpHeaders_x.put('Authorization', 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(lexisNexisSmallBusinessAnalyticsSettings.Username__c + ':' + lexisNexisSmallBusinessAnalyticsSettings.Password__c)));

            System.debug('### ' + lexisNexisSBACalloutSOAP);
            System.debug('### ' + smallBusinessAnalyticsRequestElement);

            CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponse smallBusinessAnalyticsResponse = lexisNexisSBACalloutSOAP.SmallBusinessAnalytics(smallBusinessAnalyticsRequestElement.User_x, smallBusinessAnalyticsRequestElement.Options, smallBusinessAnalyticsRequestElement.SearchBy);

            System.debug('Lexis Nexis SBA response: ' + smallBusinessAnalyticsResponse);

            try {

                lexisNexisSBAResponse.fraudScore = smallBusinessAnalyticsResponse.Result.Models.Model[0].Scores.Score[0].Value;

            }
            catch (Exception e) {

                System.debug('### ' + e.getMessage() + '\n' + e.getStackTraceString());

                lexisNexisSBAResponse.fraudScore = 0;

            }


        } catch (Exception e) {

            System.debug('### ' + e.getMessage() + '\n' + e.getStackTraceString());

        }

        return lexisNexisSBAResponse;

    }

    public class LexisNexisBIIDRequest {

        public String applicationId { get; set; }
        public String businessName { get; set; }
        public String streetAddress { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String emailAddress { get; set; }
        public String phoneNumber { get; set; }
        public String ipAddress { get; set; }
        public String federalTaxId { get; set; }

        public List<LexisNexisAuthorizedRepresenative> lexisNexisAuthorizedRepresenatives { get; set; }

        public LexisNexisBIIDRequest() {

        }


    }

    public class LexisNexisBIIDResponse {

        public String biidWorkflowResult { get; set; }
        public Integer biidScore { get; set; }

        public LexisNexisBIIDResponse() {

        }

    }

    public class LexisNexisIIDRequest {

        public String applicationId { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String streetAddress { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String phoneNumber { get; set; }
        public String socialSecurityNumber { get; set; }
        public Date dateOfBirth { get; set; }
        public String emailAddress { get; set; }
        public String ipAddress { get; set; }

        public LexisNexisIIDRequest() {

        }

    }

    public class LexisNexisIIDResponse {

        public String iidWorkflowResult { get; set; }
        public String fraudPointWorkflowResult { get; set; }
        public Integer fraudPointScore { get; set; }
        public Integer cviScore { get; set; }

        public LexisNexisIIDResponse() {

        }

    }

    public class LexisNexisAuthorizedRepresenative {

        public String firstName { get; set; }
        public String lastName { get; set; }
        public String streetAddress { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String socialSecurityNumber { get; set; }
        public String phoneNumber { get; set; }
        public Date dateOfBirth { get; set; }

        public LexisNexisAuthorizedRepresenative() {

        }

    }

    public class LexisNexisSBARequest {

        public String companyName { get; set; }
        public String streetAddress { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String phoneNumber { get; set; }
        public String federalTaxId { get; set; }

        public List<LexisNexisAuthorizedRepresenative> lexisNexisAuthorizedRepresenatives { get; set; }

        public LexisNexisSBARequest() {

        }

    }

    public class LexisNexisSBAResponse {

        public Integer fraudScore { get; set; }

        public LexisNexisSBAResponse() {

        }

    }

    // Lexis/Nexis returns keywords in the body for the keys
    // TODO - Move to a utility class for all Salesforce keywords
    public static String jsonKeywordSafeReplace(String jsonBody, Boolean reverse) {

        String regexPattern = '(?m)^\\s*"{0}"\\s*:';

        String replacementPattern = '"{0}" :';

        Map<String, String> keysToReplace = new Map<String, String>{
                'Type' => 'Type_x',
                'Group' => 'Group_x',
                'Number' => 'Number_x'
        };

        // For sending requests back out to Lexis / Nexis
        if (reverse) {

            Map<String, String> newMap = new Map<String, String>();

            for (String key : keysToReplace.keySet()) {
                newMap.put(keysToReplace.get(key), key);
            }

            keysToReplace = newMap;

        }

        String prettyJSON = JSON.serializePretty(JSON.deserializeUntyped(jsonBody));

        for (String jsonKey : keysToReplace.keySet()) {

            String regex = String.format(regexPattern, new List<String>{
                    jsonKey
            });

            String replacement = String.format(replacementPattern, new List<String>{
                    keysToReplace.get(jsonKey)
            });

            prettyJSON = prettyJSON.replaceAll(regex, replacement);

        }

        return prettyJSON;

    }

}