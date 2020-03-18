/**
 * Created by lhowland on 12/5/2019.
 */

global class CreditWS_CreditLens {

    public static String createEntityUnable = '';
    public static String createEntityError = '';
    public static String token = '';

    public static Credit_Decision_Engine_Endpoints__mdt CLAuthSettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLAuthSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Auth'];

                return CLAuthSettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Credit Lens Auth connection settings.');
                return null;
            }
        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Create_Entity'];

                return CLCreateEntitySettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Credit Lens Create Entity connection settings.');
                return null;
            }
        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt CLUploadDocumentsSettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLUploadDocumentsSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Doc_Upload'];

                return CLUploadDocumentsSettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Credit Lens Upload Documents connection settings.');
                return null;
            }
        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt CLDocToEntitySettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLDocToEntitySettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Doc_to_Entity'];

                return CLDocToEntitySettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Credit Lens Document to Entity Association connection settings.');
                return null;
            }
        }
    }

    public static Moodys_CreditLens_Mapping__mdt CLStockExchange(String value) {

        try {
            Moodys_CreditLens_Mapping__mdt CLStockExchange = [SELECT Key__c, Country__c FROM Moodys_CreditLens_Mapping__mdt WHERE Value__c =: value];

            return CLStockExchange;

        } catch (Exception e) {
            System.debug('### ERROR: Error getting Stock Exchange mappings.');
            return null;
        }
    }

    public static String CLCountry(String country) {

        try {
            // this will possibly return duplicates of the same country
            List<Moodys_CreditLens_Mapping__mdt> CLCountries = [SELECT countryKey__c FROM Moodys_CreditLens_Mapping__mdt WHERE WEXCountryKey__c =: country];

            if (!CLCountries.isEmpty()) return CLCountries[0].countryKey__c;

        } catch (Exception e) {
            System.debug('### ERROR: Error getting country mappings.');
            return null;
        }
        return null;
    }

    public class creditLensCalloutException extends Exception {}

    public static String creditLensAuthentication() {

        try {

            Credit_Decision_Engine_Endpoints__mdt CLAuthSettings = CLAuthSettings;

            if (CLAuthSettings != null) {

                HttpRequest authenticateRequest = new HttpRequest();

                authenticateRequest.setMethod('POST');
                authenticateRequest.setHeader('Content-Type', 'application/json');
                authenticateRequest.setEndpoint(CLAuthSettings.Endpoint_URL__c);
                authenticateRequest.setBody('{"UserName":"' + CLAuthSettings.Username__c + '","Password":"' + CLAuthSettings.Password__c + '"}');

                Http authenticationCallout = new Http();

                HttpResponse authenticateResponse = authenticationCallout.send(authenticateRequest);
                System.debug('auth response: ' + authenticateResponse);

                if (authenticateResponse.getStatusCode() == 200) {
                    String responseBody =  authenticateResponse.getBody();

                    CreditWS_CLAuthResponse response = CreditWS_CLAuthResponse.parse(responseBody);

                    if (response != null) {

                        CreditWS_CLAuthResponse.PayLoad payload = new CreditWS_CLAuthResponse.PayLoad();
                        payload = response.payLoad;
                        return payload.token;
                    }
                }
            }

        } catch(Exception e) {
            System.debug('### Error authenticating in Credit Lens - ' + e.getLineNumber() + ' - ' + e.getMessage());

        }

        return null;
    }

    // Invocable method so we can call it from a flow
    @InvocableMethod(Label='CreditLens Create Entity' Description='Sends information to CreditLens to create an entity')
    webService static void creditLensCreateEntityAction (List<Id> appId) {
        creditLensCreateEntity(appId[0]);
    }

    // If called from das button
    webservice static void creditLensCreateEntityButton(Id appId) {
        creditLensCreateEntity(appId);
    }

    /**
     * Dertermine the line of business and build the request to create an Entity record in Credit Lens
     *
     * @param appId
     */
    public static void creditLensCreateEntity(Id appId) {

        String token = creditLensAuthentication();
        System.debug('token = ' + token);

        CreditWS_CLCreateEntityRequest creditLensRequest = new CreditWS_CLCreateEntityRequest();

        String objectType = appID.getSobjectType().getDescribe().getName();

        if (objectType.equalsIgnoreCase('Application_Request__c')) {

            //todo stuff and things for NA Fleet
            // WExBusinessUntit = NAFleet
        }

        else if (objectType.equalsIgnoreCase('OnlineApplication__c')) {

            //todo stuff and things for OTR
            // WExBusinessUntit = OTR

        }

        else if (objectType.equalsIgnoreCase('CP_Application_Request__c')) {

            // todo refactor into a separate method that is called from here, same for all LOBs

            System.debug('Corporate Payments App ID: ' + appID);
            List<CP_Application_Request__c> appInfo = [
                    SELECT Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_Address_Line_2__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c,
                            Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId, Opportunity__r.Sales_Group__c,
                            Credit_Line_Recommendation__c, Credit_Line_Requested__c, Account__r.AccountNumber, Country_of_Contacting_Entity__c, Country_of_Contracting_Entity_Other__c, National__c,
                            Mailing_Address_Line_1__c, Mailing_Address_Line_2__c, Mailing_City__c, Mailing_State_Province__c, Mailing_Postal_Code__c, Mailing_Country__c, Financials_Completed_For__c, Program__r.Name,
                            DNB_Trade_Lines__c, Paydex__c, Billing_Cycle__c, Control_Year__c, Risk_Grade__c, Risk_Grade_Source__c, Email__c, Business_Phone__c, First_Name__c, Last_Name__c, SIC_Code__c, Credit_Lens_Response__c, Payment_Type__c,
                            Security_Type__c, Security_Currency__c, Security_Expiration_Date__c, DNB_Credit_Line_Recommendation__c
                    FROM CP_Application_Request__c
                    where Id = :appID
            ];

            if (appInfo.size() == 1) {
                CP_Application_Request__c cpApp = appInfo[0];

                String country = CLCountry(cpApp.Physical_Country__c);

                creditLensRequest.EntityType = 'CORP'; //todo cpApp.Legal_Structure__c; - need to have naming convention solidified
//                if (cpApp.CreditLens_EntityID__c != null) creditLensRequest.EntityId = cpApp.CreditLens_EntityID__c;
                if (cpApp.Account__r != null && cpApp.Account__r.AccountNumber != null) creditLensRequest.WexAccountNumber = cpApp.Account__r.AccountNumber;
                if (cpApp.National__c !=null) creditLensRequest.LegalEntity = cpApp.National__c;
                if (cpApp.Program__r !=null) creditLensRequest.WexProgramString = cpApp.Program__r.Name;
                creditLensRequest.LongName = cpApp.Company_Legal_Name__c;
                creditLensRequest.ShortName = cpApp.Doing_Business_As__c;
                creditLensRequest.PlaceOfIncorporation = country;
                creditLensRequest.CountryOfInc = country;
                if (cpApp.Physical_State_Province__c != null) {
                    creditLensRequest.ProvinceStateOfIncorporation = cpApp.Physical_Country__c + cpApp.Physical_State_Province__c;
                }
                creditLensRequest.BusinessPortfolio = country;
                if (cpApp.Country_of_Contacting_Entity__c != null) creditLensRequest.CountryOfRisk = CLCountry(cpApp.Country_of_Contacting_Entity__c);
                if (cpApp.Country_of_Contracting_Entity_Other__c != null) creditLensRequest.CountryOfRisk = CLCountry(cpApp.Country_of_Contracting_Entity_Other__c);
                if (creditLensRequest.CountryOfRisk == null) creditLensRequest.CountryOfRisk = country; // set default because it's required
                creditLensRequest.SystemId = cpApp.Name;
                creditLensRequest.Division = 'Corporate';
                creditLensRequest.CreditPortfolio = 'WexBank';
                creditLensRequest.WexCreditInformationOn = cpApp.Financials_Completed_For__c;
                if (cpApp.Billing_Cycle__c != null) creditLensRequest.BillingCycle = cpApp.Billing_Cycle__c;
//                if (cpApp.Payment_Type__c != null) creditLensRequest.WexPaymentType = cpApp.Payment_Type__c;  //todo can't send until they figure out the dropdown values in CL
                if (cpApp.Credit_Line_Requested__c != null) creditLensRequest.WexRequestCreditLineAmount = String.valueOf(cpApp.Credit_Line_Requested__c);
                if (cpApp.Credit_Line_Recommendation__c != null) creditLensRequest.WexRecommendedCreditLine = String.valueOf(cpApp.Credit_Line_Recommendation__c);
                if (cpApp.DNB_Credit_Line_Recommendation__c != null) creditLensRequest.WexOriginationModelRecommendat = String.valueOf(cpApp.DNB_Credit_Line_Recommendation__c);
                if (cpApp.Taxpayer_ID__c != null) creditLensRequest.TaxId = cpApp.Taxpayer_ID__c;
                if (cpApp.DNB_Resolved_DUNS__c != null) creditLensRequest.WexDunsNumber = cpApp.DNB_Resolved_DUNS__c;
                if (cpApp.DNB_Trade_Lines__c != null) creditLensRequest.WexNumberOfCreditExperiences = Integer.valueOf(cpApp.DNB_Trade_Lines__c);
                if (cpApp.Paydex__c != null) creditLensRequest.WexPaydexScore = String.valueOf(cpApp.Paydex__c);
                if (cpApp.Control_Year__c != null) creditLensRequest.WexYearControl = cpApp.Control_Year__c;
                if (cpApp.Risk_Grade__c != null) creditLensRequest.WexPrimaryRiskGrade = cpApp.Risk_Grade__c;
//                if (cpApp.Risk_Grade_Source__c != null) creditLensRequest.WexPrimaryRiskGradeSource = cpApp.Risk_Grade_Source__c; //todo can't send until they figure out the dropdown values in CL
                if (cpApp.Stock_Symbol__c != null) {
                    creditLensRequest.FirmType = 'PUB';
                    creditLensRequest.StockCode = cpApp.Stock_Symbol__c;
                } else {
                    creditLensRequest.FirmType = 'PRV'; // set default
                }
                if (cpApp.Stock_Exchange__c != null) {
                    Moodys_CreditLens_Mapping__mdt stockExchangeMapping = CLStockExchange(cpApp.Stock_Exchange__c);
                    if (stockExchangeMapping != null) {
                        creditLensRequest.StockExchange = stockExchangeMapping.Key__c;
                        creditLensRequest.CountryOfListing = country;
                    }
                }
                if (cpApp.CurrencyIsoCode != null) creditLensRequest.Currency_x = cpApp.CurrencyIsoCode; else creditLensRequest.Currency_x = 'USD'; // set a default

                if (cpApp.Opportunity__r != null) {
                    creditLensRequest.WexRelationshipManager = getUserName(cpApp.Opportunity__r.OwnerId);
                    if (cpApp.Opportunity__r.Sales_Group__c != null && cpApp.Opportunity__r.Sales_Group__c.equalsIgnoreCase('Travel')) {
                        creditLensRequest.WexBusinessUnit = 'Travel';
                    } else {
                        creditLensRequest.WexBusinessUnit = 'Payables';
                    }
                }
                creditLensRequest.WexCreditAnalyst = UserInfo.getName();
                if (cpApp.Security_Type__c != null) creditLensRequest.CollateralSecurity = cpApp.Security_Type__c;
                if (cpApp.Security_Type__c != null) creditLensRequest.WexRequestCurrency = cpApp.Security_Currency__c;
                if (cpApp.Security_Type__c != null) creditLensRequest.WexExpirationSecurityDate = String.valueOf(cpApp.Security_Expiration_Date__c);

                //todo mappings for SIC Code
//                if (cpApp.SIC_Code__c != null) {
//
//                    creditLensRequest.IndClassification = 'SIC';
//
//                    CreditWS_CLCreateEntityRequest.IndustryCode industryCode = new CreditWS_CLCreateEntityRequest.IndustryCode();
//                    industryCode.Code = cpApp.SIC_Code__c;
//                    industryCode.Description = 'Crude petroleum and natural gas';
//                    industryCode.Keys = new list<String> {'B', '13', cpApp.SIC_Code__c};
//
//                    List<CreditWS_CLCreateEntityRequest.IndustrySelection> industrySelections = new List<CreditWS_CLCreateEntityRequest.IndustrySelection>();
//                    CreditWS_CLCreateEntityRequest.IndustrySelection industrySelection = new CreditWS_CLCreateEntityRequest.IndustrySelection();
//                    industrySelection.x_new = true;
//                    industrySelection.Percentage = 1;
//                    industrySelection.OperationType = 'Create';
//                    industrySelection.IndustryId = -1;
//                    industrySelection.Classification = 'SIC';
//                    industrySelection.IsPrimary = true;
//                    industrySelection.x_initialRulesExecuted = true;
//                    industrySelection.IndustryCode = industryCode;
//
//                    industrySelections.add(industrySelection);
//                    creditLensRequest.IndustrySelection = industrySelections;
//                }

                //add Applicant as a Contact
                List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit> contacts = new List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit>();
                CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit contact = new CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit();

                contact.x_new = true;
                contact.OperationType = 'Create';
                contact.x_initialRulesExecuted = true;
                contact.Email = cpApp.Email__c;
                contact.Id = -1;
                contact.Name = cpApp.First_Name__c + ' ' + cpApp.Last_Name__c;
                contact.OfficeNo = cpApp.Business_Phone__c;

                contacts.add(contact);
                creditLensRequest.EntityContactCreateAndEdit = contacts;

                //add physical business address
                List<CreditWS_CLCreateEntityRequest.EntityAddress> addresses = new List<CreditWS_CLCreateEntityRequest.EntityAddress>();
                CreditWS_CLCreateEntityRequest.EntityAddress physicalAddress = new CreditWS_CLCreateEntityRequest.EntityAddress();

                physicalAddress.x_new = true;
                physicalAddress.OperationType = 'Create';
                physicalAddress.AddressId = -1;
                physicalAddress.x_initialRulesExecuted = true;
                physicalAddress.AddressType = 'REGISTERED';
                physicalAddress.Address1 = cpApp.Physical_Address_Line_1__c;
                if (cpApp.Physical_Address_Line_2__c != null) physicalAddress.Address2 = cpApp.Physical_Address_Line_2__c;
                physicalAddress.Country = country;
                if (cpApp.Physical_State_Province__c != null) physicalAddress.State = cpApp.Physical_Country__c + cpApp.Physical_State_Province__c;
                physicalAddress.City = cpApp.Physical_City__c;
                physicalAddress.Zip = cpApp.Physical_Postal_Code__c;
                physicalAddress.t_x = 'Address';

                addresses.add(physicalAddress);

                //add mailing address
                CreditWS_CLCreateEntityRequest.EntityAddress mailingAddress = new CreditWS_CLCreateEntityRequest.EntityAddress();

                mailingAddress.x_new = true;
                mailingAddress.OperationType = 'Create';
                mailingAddress.AddressId = 2;
                mailingAddress.x_initialRulesExecuted = true;
                mailingAddress.AddressType = 'MAILING';
                mailingAddress.Address1 = cpApp.Mailing_Address_Line_1__c;
                if (cpApp.Mailing_Address_Line_2__c != null) physicalAddress.Address2 = cpApp.Mailing_Address_Line_2__c;
                mailingAddress.Country = CLCountry(cpApp.Mailing_Country__c);
                if (cpApp.Mailing_State_Province__c != null) mailingAddress.State = cpApp.Mailing_Country__c + cpApp.Mailing_State_Province__c;
                mailingAddress.City = cpApp.Mailing_City__c;
                mailingAddress.Zip = cpApp.Mailing_Postal_Code__c;
                mailingAddress.t_x = 'Address';

                addresses.add(mailingAddress);
                creditLensRequest.EntityAddress = addresses;

                Integer entityId = createEntity(creditLensRequest, token);

                if (entityId != null) {
                    cpApp.CreditLens_EntityID__c = entityId;
                    cpApp.Credit_Lens_Response__c = 'Entity ' + entityId + ' successfully created in Credit Lens!';
                    upsert cpApp;
                } else {
                    String createStatus = createEntityUnable + '\n' + createEntityError;
                    if (createStatus.length() > 2000) {
                        cpApp.Credit_Lens_Response__c = createStatus.substring(0,1995) + ' ...';
                        upsert cpApp;
                    } else {
                        cpApp.Credit_Lens_Response__c = createStatus;
                        upsert cpApp;
                    }

                }
            }
        }

    }

    /**
     * LOB agnostic callout to Credit Lens to create the Entity record
     *
     * @param creditLensRequest
     * @param token
     *
     * @return
     */
    private static Integer createEntity(CreditWS_CLCreateEntityRequest creditLensRequest, String token) {

        if (creditLensRequest != null) {

            String jsonRequest = replaceSpecialCharsJSON(JSON.serializePretty(creditLensRequest, true));

            String responseBody = '';

            try {

                Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = CLCreateEntitySettings;

                if (CLCreateEntitySettings != null) {

                    HttpRequest request = new HttpRequest();

                    request.setMethod('POST');
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('Authorization', 'Bearer ' + token);
                    request.setEndpoint(CLCreateEntitySettings.Endpoint_URL__c);
                    request.setBody(jsonRequest);

                    Http http = new Http();
                    HttpResponse httpResponse = http.send(request);

                    if (httpResponse.getStatusCode() == 200) {

                        responseBody = httpResponse.getBody();
                        System.debug('Response before parse: ' + responseBody);

                        CreditWS_CLCreateEntityResponse response = CreditWS_CLCreateEntityResponse.parse(responseBody);

                        if (response != null) {

                            List<CreditWS_CLCreateEntityResponse.PayLoad> payloads = new List<CreditWS_CLCreateEntityResponse.PayLoad>();
                            payloads = response.payLoad;

                            if (!payloads.isEmpty()) {
                                System.debug('Entity created in Credit Lens. Entity ID:  ' + payloads[0].EntityId);
                                return payloads[0].EntityId;
                            }
                        }
                    } else {
                        // good payload but not a Status of 200 - so what happened?
                        System.debug('Unable to create entity in Credit Lens: ' + httpResponse.getBody());
                        String unable = 'Unable to create entity in Credit Lens: ' + httpResponse.getBody();
                        createEntityUnable = unable;

                    }

                }
            } catch (Exception e) {
                System.debug('### Error creating entity in Credit Lens - ' + e.getLineNumber() + ' - ' + e.getMessage());
                String error = 'Error creating entity in Credit Lens: ' + e.getMessage() + ' Error: ' + responseBody;
                createEntityError = error;
            }
        }
        return null;
    }


    /**
     * Takes a list of documents that were selected by the user to be uploading into Credit Lens.
     * First, the document is uploaded to Credit Lens and a document ID is returned.
     * Second, an Entity record is given the document Id as a reference.
     *
     * @param attachments
     *
     * @return
     */
    public static List<String> uploadDocuments(List<GenericFile> files) {

        //String token = creditLensAuthentication();
        token = creditLensAuthentication();

        //todo accept multiple files in one request
        Blob fileBody = files[0].body;
        String fileName = files[0].fileName;
        if ((files[0].objectType).equalsIgnoreCase('ContentDocument')) { fileName +=  '.' + files[0].fileExtension; }
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+fileName+'"\r\nContent-Type: ' + files[0].MIMEType;   // String header = '--' + boundary +'\nContent-Disposition: form-data; name="file"; filename="' + fileName +'";\nContent-Type: application/octet-stream';
        String footer = '\r\n--'+boundary+'--';   //String footer = '--' + boundary +'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));

        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(fileBody);

        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        if(last4Bytes.endsWith('==')) {
            // The '==' sequence indicates that the last group contained only one 8 bit byte
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else {
            // Prepend the CR LF to the footer
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }

        String responseBody = '';

        try {

            Credit_Decision_Engine_Endpoints__mdt CLUploadDocumentsSettings = CLUploadDocumentsSettings;

            if (CLUploadDocumentsSettings != null) {

                HttpRequest httpRequest = new HttpRequest();

                httpRequest.setMethod('POST');
                httpRequest.setHeader('Authorization', 'Bearer ' + token);
                httpRequest.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
                httpRequest.setEndpoint(CLUploadDocumentsSettings.Endpoint_URL__c);
                httpRequest.setBodyAsBlob(bodyBlob);
                httpRequest.setTimeout(120000);

                Http docUploadCallout = new Http();
                HttpResponse httpResponse = docUploadCallout.send(httpRequest);
                System.debug('httpResponse body: ' + httpResponse.getBody());

                if (httpResponse.getStatusCode() == 200) {

                    responseBody = httpResponse.getBody();

                    CreditWS_CLUploadDocResponse response = CreditWS_CLUploadDocResponse.parse(responseBody);

                    if (response != null) {

                        List<CreditWS_CLUploadDocResponse.PayLoad> payloads = new List<CreditWS_CLUploadDocResponse.PayLoad>();
                        payloads = response.payLoad;

                        List<String> docIds = new List<String>();

                        if (payloads.size() > 0) {
                            for (CreditWS_CLUploadDocResponse.PayLoad payload: payloads) {
                                docIds.add(payload.DocumentId);
                            }
                        }
                        return docIds;
                    }
                }
            }

        } catch(Exception e) {
            System.debug('### Error uploading document(s) to Credit Lens - ' + e.getLineNumber() + ' - ' + e.getMessage());
            return null;

        }
        return null;
    }


    /**
     * Once the document(s) have been upload to Credit Lens, the returned document ID must be linked to the desired Entity record.
     *
     * @param appId
     * @param docIds
     *
     * @return
     */
    public static Boolean linkDocToEntity(String appId, List<String> docIds) {

        Integer entityId = null;

        List<CP_Application_Request__c> cpApps = [SELECT CreditLens_EntityID__c FROM CP_Application_Request__c WHERE Id = :appId];
        if (cpApps.size() > 0) {
            Decimal entityDecimal = cpApps[0].CreditLens_EntityID__c;
            if (entityDecimal != null) {
                entityId = Integer.valueOf(entityDecimal);
            } else {
                System.debug('No Entity related to this application exists yet in Credit Lens.');
                return false;
            }
        }

        try {

            Credit_Decision_Engine_Endpoints__mdt CLDocToEntitySettings = CLDocToEntitySettings;
            String responseBody = '';

            if (CLDocToEntitySettings != null && docIds.size() > 0 && entityId != null) {

                CreditWS_CLDocToEntityRequest docToEntityRequest = new CreditWS_CLDocToEntityRequest();

                CreditWS_CLDocToEntityRequest.Context context = new CreditWS_CLDocToEntityRequest.Context();
                docToEntityRequest.context = context;

                CreditWS_CLDocToEntityRequest.PayLoad_Y payLoadY = new CreditWS_CLDocToEntityRequest.PayLoad_Y();
                CreditWS_CLDocToEntityRequest.PayLoad payLoad = new CreditWS_CLDocToEntityRequest.PayLoad();

                List<CreditWS_CLDocToEntityRequest.Multi> multis = new List<CreditWS_CLDocToEntityRequest.Multi>();
                CreditWS_CLDocToEntityRequest.Multi multi = new CreditWS_CLDocToEntityRequest.Multi();

                multi.viewModelId = 'SpreadDocumentUpload';
                multi.behavior = 'Save';

                payLoad.SpreadDocumentId = '00000000-0000-0000-0000-000000000000';
                payLoad.EntityId = entityId;
                payLoad.DocumentId = docIds[0]; //todo allow multiple files
                payload.FinancialTemplateId = '6'; //what IS this?
                payload.DocumentStatus = 'SUBMITTED';
                payLoad.StatementDate = String.valueOf(System.now());
                payLoad.SpreadStatementCount = String.valueOf(docIds.size());
                payLoad.SpreadDocumentType = 'FINANCIAL_DOCUMENT';
                payLoad.FilterOutForUI = false;

                List<CreditWS_CLDocToEntityRequest.SpreadStatement> spreadStatements = new List<CreditWS_CLDocToEntityRequest.SpreadStatement>();
                CreditWS_CLDocToEntityRequest.SpreadStatement spreadStatement = new CreditWS_CLDocToEntityRequest.SpreadStatement();

                spreadStatement.StatementPeriod = 12; //todo can I skip this field?
                spreadStatement.StatementType = 'ANNUAL'; //todo find out what other options there are
                spreadStatement.StatementDate = String.valueOf(System.now());
                spreadStatement.OperationType = 'Create';

                spreadStatements.add(spreadStatement);

                payload.SpreadStatement = spreadStatements;
                payLoad.OperationType = 'Create';
                payLoad.Status = 1;
                payLoad.t_x = 'SpreadDocument';

                multi.payLoad = payLoad;
                multis.add(multi);
                payLoadY.multi = multis;

                docToEntityRequest.payLoad = payLoadY;

                String jsonRequest = replaceSpecialCharsJSON(JSON.serializePretty(docToEntityRequest, true));

                HttpRequest httpRequest = new HttpRequest();

                httpRequest.setMethod('POST');
                httpRequest.setHeader('Authorization', 'Bearer ' + token);
                httpRequest.setHeader('Content-Type', 'application/json');
                httpRequest.setEndpoint(CLDocToEntitySettings.Endpoint_URL__c);
                httpRequest.setBody(jsonRequest);

                Http httpCallout = new Http();
                HttpResponse httpResponse = httpCallout.send(httpRequest);

                System.debug('httpResponse body: ' + httpResponse.getBody());

                if (httpResponse.getStatusCode() == 200) {

                    responseBody = httpResponse.getBody();

                    CreditWS_CLDocToEntityResponse response = CreditWS_CLDocToEntityResponse.parse(responseBody);

                    if (response != null) {

                        List<List<CreditWS_CLDocToEntityResponse.PayLoad>> payloadsLists = new List<List<CreditWS_CLDocToEntityResponse.PayLoad>>();
                        payloadsLists = response.payLoad;

                        // there should only ever be one main payload
                        List<CreditWS_CLDocToEntityResponse.PayLoad> payloads = new List<CreditWS_CLDocToEntityResponse.PayLoad>();
                        payloads = payloadsLists[0];

                        for (CreditWS_CLDocToEntityResponse.PayLoad responsePayload : payloads) {
                            CreditWS_CLDocToEntityResponse.Rules rules = responsePayload.Rules;
                            CreditWS_CLDocToEntityResponse.LinkAutoSpreadDocumentToEntity linkAutoSpreadDocumentToEntity = rules.LinkAutoSpreadDocumentToEntity;
                            if (linkAutoSpreadDocumentToEntity.success) {
                                return true;
                            }
                        }
                    }
                }
            }


        } catch(Exception e) {
            System.debug('### Error associating document(s) to Credit Lens Entity - ' + e.getLineNumber() + ' - ' + e.getMessage());
            return false;

        }
        return false;
    }


    /**
     * Because Moodys was so kind as so have attribute names start with $ and end in _
     *
     * @param jsonBody
     *
     * @return
     */
    public static String replaceSpecialCharsJSON(String jsonBody) {

        String regexFormat = '(?m)^\\s*"{0}"\\s*:';

        String replacementFormat = '"{0}" :';

        // Dear Moodys, why do you use $ in your attribute names?
        Map<String, String> replacements = new Map<String, String> {
                'x_new' => '\\$new',
                'x_initialRulesExecuted' => '\\$initialRulesExecuted',
                't_x' => 't_',
                'Currency_x' => 'Currency',
                'VersionId_x' => 'VersionId_',
                'BaseVersionId_x' => 'BaseVersionId_',
                'Payload_Y' => 'Payload',
                'Payload_Z' => 'Payload'
        };

        String formattedJSON = JSON.serializePretty(JSON.deserializeUntyped(jsonBody));

        // Iterate over all the keys we want to replace
        for (String key : replacements.keySet()) {
            // Generate our regex based on the key
            String regex = String.format(
                    regexFormat,
                    new List<String> {key}
            );

            // Generate our replacement
            String replacement = String.format(
                    replacementFormat,
                    new List<String> {replacements.get(key)}
            );

            // Find all and replace
            formattedJSON = formattedJSON.replaceAll(regex, replacement);
        }
        System.debug('FormattedJSON post replacement of things and stuff: ' + formattedJSON);
        return formattedJSON;
    }

    private static String getUserName(Id id) {

        List<User> users = [ SELECT Name from User where id =: id];

        if (users.size() > 0) {
            return users[0].Name;
        }
        return null;
    }

}