/**
 * Created by lhowland on 12/5/2019.
 */

global class CreditWS_CreditLens {

    public static String createEntityUnable = '';
    public static String createEntityError = '';

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
                System.debug('TEMP auth response: ' + authenticateResponse);

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
                            DNB_Trade_Lines__c, Paydex__c, Billing_Cycle__c, Control_Year__c, Risk_Grade__c, Risk_Grade_Source__c, Email__c, Business_Phone__c, First_Name__c, Last_Name__c, SIC_Code__c, Credit_Lens_Response__c, Payment_Type__c
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
                creditLensRequest.ProvinceStateOfIncorporation = cpApp.Physical_Country__c + cpApp.Physical_State_Province__c;
                creditLensRequest.BusinessPortfolio = country;
                if (cpApp.Country_of_Contacting_Entity__c != null) creditLensRequest.CountryOfRisk = CLCountry(cpApp.Country_of_Contacting_Entity__c);
                if (cpApp.Country_of_Contracting_Entity_Other__c != null) creditLensRequest.CountryOfRisk = CLCountry(cpApp.Country_of_Contracting_Entity_Other__c);
                if (creditLensRequest.CountryOfRisk == null) creditLensRequest.CountryOfRisk = country; // set default because it's required
                creditLensRequest.SystemId = cpApp.Name;
                creditLensRequest.Division = 'Corporate';
                creditLensRequest.CreditPortfolio = 'WexBank';
                creditLensRequest.WexCreditInformationOn = cpApp.Financials_Completed_For__c;
                if (cpApp.Billing_Cycle__c != null) creditLensRequest.WexBillingCycle = cpApp.Billing_Cycle__c;
//                if (cpApp.Payment_Type__c != null) creditLensRequest.WexPaymentType = cpApp.Payment_Type__c;  //todo can't send until they figure out the dropdown values in CL
                if (cpApp.Credit_Line_Requested__c != null) creditLensRequest.WexRequestCreditLineAmount = String.valueOf(cpApp.Credit_Line_Requested__c);
                if (cpApp.Credit_Line_Recommendation__c != null) creditLensRequest.WexOriginationModelRecommendat = String.valueOf(cpApp.Credit_Line_Recommendation__c);
                if (cpApp.Taxpayer_ID__c != null) creditLensRequest.TaxId = cpApp.Taxpayer_ID__c;
                if (cpApp.DNB_Resolved_DUNS__c != null) creditLensRequest.WexDunsNumber = cpApp.DNB_Resolved_DUNS__c;
                if (cpApp.DNB_Trade_Lines__c != null) creditLensRequest.WexNumberOfCreditExperiences = Integer.valueOf(cpApp.DNB_Trade_Lines__c);
                if (cpApp.Paydex__c != null) creditLensRequest.WexPaydexScore = String.valueOf(cpApp.Paydex__c);
                if (cpApp.Control_Year__c != null) creditLensRequest.WexControlYear = cpApp.Control_Year__c;
                if (cpApp.Risk_Grade__c != null) creditLensRequest.WexPrimaryRiskGrade = cpApp.Risk_Grade__c;
//                if (cpApp.Risk_Grade_Source__c != null) creditLensRequest.WexPrimaryRiskGradeSource = cpApp.Risk_Grade_Source__c; //todo can't send until they figure out the dropdown values in CL
                if (cpApp.Stock_Symbol__c != null) {
                    creditLensRequest.FirmType = 'PUB';
                    creditLensRequest.StockCode = cpApp.Stock_Symbol__c;
                }
                if (cpApp.Stock_Exchange__c != null) {
                    Moodys_CreditLens_Mapping__mdt stockExchangeMapping = CLStockExchange(cpApp.Stock_Exchange__c);
                    if (stockExchangeMapping != null) {
                        creditLensRequest.StockExchange = stockExchangeMapping.Key__c;
                        creditLensRequest.CountryOfListing = country;
                    }
                }
                if (cpApp.CurrencyIsoCode != null) creditLensRequest.Currency_x = cpApp.CurrencyIsoCode; else creditLensRequest.Currency_x = 'USD'; // set a default

                if (cpApp.Opportunity__r != null) creditLensRequest.WexRelationshipManager = getUserName(cpApp.Opportunity__r.OwnerId);
                creditLensRequest.WexCreditAnalyst = UserInfo.getName();

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
                physicalAddress.State = cpApp.Physical_Country__c + cpApp.Physical_State_Province__c;
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
                mailingAddress.State = cpApp.Mailing_Country__c + cpApp.Mailing_State_Province__c;
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

            String jsonRequest = replaceSpeicalCharsJSON(JSON.serializePretty(creditLensRequest, true));

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
                String error = 'Error creating entity in Credit Lens: ' + e.getMessage();
                createEntityError = error;
            }
        }
        return null;
    }

    /**
     * Because Moodys was so kind as so have attribute names start with $ and end in _
     *
     * @param jsonBody
     *
     * @return
     */
    public static String replaceSpeicalCharsJSON(String jsonBody) {

        String regexFormat = '(?m)^\\s*"{0}"\\s*:';

        String replacementFormat = '"{0}" :';

        // Dear Moodys, why do you use $ in your attribute names?
        Map<String, String> replacements = new Map<String, String> {
                'x_new' => '\\$new',
                'x_initialRulesExecuted' => '\\$initialRulesExecuted',
                't_x' => 't_',
                'Currency_x' => 'Currency'
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
        System.debug('TEMP formattedJSON post replacement of things and stuff: ' + formattedJSON);
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