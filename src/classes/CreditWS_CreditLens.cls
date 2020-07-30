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

    public static Credit_Decision_Engine_Endpoints__mdt CLCreateOrGetEntitySettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLCreateOrGetEntitySettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Create_Entity'];

                return CLCreateOrGetEntitySettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Credit Lens Create Entity connection settings.');
                return null;
            }
        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt CLEditEntitySettings {
        get {
            try {
                Credit_Decision_Engine_Endpoints__mdt CLEditEntitySettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Edit_Entity'];

                return CLEditEntitySettings;

            } catch (Exception e) {
                System.debug('### ERROR: Error getting Edit Lens Create Entity connection settings.');
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
                    System.debug('auth response body: ' + responseBody);

                    CreditWS_CLAuthResponse response = CreditWS_CLAuthResponse.parse(responseBody);

                    if (response != null) {

                        CreditWS_CLAuthResponse.PayLoad payload = new CreditWS_CLAuthResponse.PayLoad();
                        payload = response.payLoad;
                        return payload.token;
                    }
                }
            }

        } catch(Exception e) {
            System.debug('### Error authenticating in Credit Lens - Line Number:' + e.getLineNumber() + ' - ' + e.getMessage());

        }

        return null;
    }

    // Invocable method so we can call it from a flow
    @InvocableMethod(Label='CreditLens Create Entity' Description='Sends information to CreditLens to create an entity')
    webService static void creditLensCreateEntityAction (List<Id> appId) {
        creditLensCreateOrUpdateEntity(appId[0]);
    }

    // If called from das button
    webservice static void creditLensCreateEntityButton(Id appId) {
        creditLensCreateOrUpdateEntity(appId);
    }

    /**
     * Dertermine the line of business and build the request to create an Entity record in Credit Lens
     *
     * @param objectId
     */
    public static void creditLensCreateOrUpdateEntity(Id objectId) {

        String token = creditLensAuthentication();

        CreditWS_CLCreateEntityRequest creditLensRequest = new CreditWS_CLCreateEntityRequest();

        String objectType = objectId.getSobjectType().getDescribe().getName();

        // Currently, only designed to create a new Entity record from App Request
        if (objectType.equalsIgnoreCase('Application_Request__c')) {

            System.debug('NA Fleet App ID: ' + objectId);
            List<Application_Request__c> naApplications = [
                    SELECT Id, ABA_Routing_Number__c, Application_Signer_FirstName_Text__c, Application_Stage__c, App_Signer_IP_Address__c, Tax_Payer_ID_number__c, Paydex__c, Risk_Grade__c,
                            Billing_City__c, Billing_Contact_First_Name_Text__c, Billing_Contact_Last_Name_Text__c, Billing_Contact__r.Email, Billing_Contact__r.Phone, DNB_Resolved_DUNS__c,
                            Billing_State__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Business_Phone_Number__c, Checking_Account_Number__c, Financials_Completed_For__c, DNB_Trade_Lines__c,
                            Doing_Business_As__c, DUNS_Number__c, Legal_Structure__c, Name, Opportunity_Name_Text__c, Personal_Guarantor_DOB__c, Personal_Guarantor_First_Name__c, Personal_Guarantor_Home_Phone__c,
                            Personal_Guarantor_Last_Name__c, Personal_Guarantor_Email__c, Personal_Guarantor_Mailing_City__c, Personal_Guarantor_Mailing_Country__c, Personal_Guarantor_Mailing_State__c, Personal_Guarantor_Mailing_Street__c,
                            Personal_Guarantor_Mailing_Zip__c, Personal_Guarantor_SSN__c, PG_Required__c, Physical_City__c, Physical_State__c, Physical_Street__c, Physical_Street_Line_2__c, Requested_Credit_Limit__c,
                            Physical_Zip_Postal_Code__c, Program__c, Physical_Country__c, Fraud_Flag__c, Credit_Line_Recommendation__c, DNB_Credit_Line_Recommendation__c, DNB_Confidence_Code__c, Personal_Guarantor__c,
                            Program_Name__c, Account_Name__r.AccountNumber, Country_of_Contracting_Entity__c, Country_of_Contracting_Entity_Other__c, Stock_Exchange__c, Stock_Symbol__c, CurrencyIsoCode,
                            Security_Type__c, Security_Currency__c, Security_Expiration_Date__c, Credit_Lens_Entity_ID__c, Credit_Lens_Response__c, App_Signer_Email__c, App_Signer_Name_Text__c, App_Signer_Last_Name_Text__c,
                            Opportunity__r.OwnerId, Opportunity__r.Sales_Group__c, Control_Year__c, SIC_Code__c
                    FROM Application_Request__c
                    WHERE Id = :objectId
            ];

            if (naApplications.size() == 1) {
                Application_Request__c naApp = naApplications[0];

                String country = CLCountry(naApp.Physical_Country__c);

                creditLensRequest.EntityType = 'CORP'; // cpApp.Legal_Structure__c; - need to have naming convention solidified
//                if (cpApp.CreditLens_EntityID__c != null) creditLensRequest.EntityId = cpApp.CreditLens_EntityID__c;
                if (naApp.Account_Name__r.AccountNumber != null) creditLensRequest.WexAccountNumber = naApp.Account_Name__r.AccountNumber;
//                if (naApp.National__c !=null) creditLensRequest.LegalEntity = naApp.National__c;
                if (naApp.Program_Name__c !=null) creditLensRequest.WexProgramString = naApp.Program_Name__c;
                creditLensRequest.LongName = naApp.Opportunity_Name_Text__c;
                creditLensRequest.ShortName = naApp.Doing_Business_As__c;
                creditLensRequest.PlaceOfIncorporation = country;
                creditLensRequest.CountryOfInc = country;
                if (naApp.Physical_State__c != null) {
                    creditLensRequest.ProvinceStateOfIncorporation = naApp.Physical_Country__c + naApp.Physical_State__c;
                }
                creditLensRequest.BusinessPortfolio = country;
                if (naApp.Country_of_Contracting_Entity__c != null) creditLensRequest.CountryOfRisk = CLCountry(naApp.Country_of_Contracting_Entity__c);
                if (naApp.Country_of_Contracting_Entity_Other__c != null) creditLensRequest.CountryOfRisk = CLCountry(naApp.Country_of_Contracting_Entity_Other__c);
                if (creditLensRequest.CountryOfRisk == null) creditLensRequest.CountryOfRisk = country; // set default because it's required
                creditLensRequest.SystemId = naApp.Name;
                creditLensRequest.Division = 'Fleet';
                creditLensRequest.CreditPortfolio = 'WexBank';
                creditLensRequest.WexCreditInformationOn = naApp.Financials_Completed_For__c;
//                if (cpApp.Payment_Type__c != null) creditLensRequest.WexPaymentType = cpApp.Payment_Type__c;  //cannot send because the picklist values don't match in Credit Lens
                if (naApp.Requested_Credit_Limit__c != null) creditLensRequest.WexRequestCreditLineAmount = naApp.Requested_Credit_Limit__c;
                if (naApp.Credit_Line_Recommendation__c != null) creditLensRequest.WexRecommendedCreditLine = String.valueOf(naApp.Credit_Line_Recommendation__c);
                if (naApp.DNB_Credit_Line_Recommendation__c != null) creditLensRequest.WexOriginationModelRecommendat = String.valueOf(naApp.DNB_Credit_Line_Recommendation__c);
                if (naApp.Tax_Payer_ID_number__c != null) creditLensRequest.TaxId = naApp.Tax_Payer_ID_number__c;
                if (naApp.DNB_Resolved_DUNS__c != null) creditLensRequest.WexDunsNumber = naApp.DNB_Resolved_DUNS__c;
                if (naApp.DNB_Trade_Lines__c != null) creditLensRequest.WexNumberOfCreditExperiences = Integer.valueOf(naApp.DNB_Trade_Lines__c);
                if (naApp.Paydex__c != null) creditLensRequest.WexPaydexScore = String.valueOf(naApp.Paydex__c);
                if (naApp.Control_Year__c != null) creditLensRequest.WexYearControl = naApp.Control_Year__c;
                if (naApp.Risk_Grade__c != null) creditLensRequest.WexPrimaryRiskGrade = naApp.Risk_Grade__c;
//                if (cpApp.Risk_Grade_Source__c != null) creditLensRequest.WexPrimaryRiskGradeSource = cpApp.Risk_Grade_Source__c; //cannot send because the picklist values don't match in Credit Lens
                if (naApp.Stock_Symbol__c != null) {
                    creditLensRequest.FirmType = 'PUB';
                    creditLensRequest.StockCode = naApp.Stock_Symbol__c;
                } else {
                    creditLensRequest.FirmType = 'PRV'; // set default
                }
                if (naApp.Stock_Exchange__c != null) {
                    Moodys_CreditLens_Mapping__mdt stockExchangeMapping = CLStockExchange(naApp.Stock_Exchange__c);
                    if (stockExchangeMapping != null) {
                        creditLensRequest.StockExchange = stockExchangeMapping.Key__c;
                        creditLensRequest.CountryOfListing = country;
                    }
                }
                if (naApp.CurrencyIsoCode != null) creditLensRequest.Currency_x = naApp.CurrencyIsoCode; else creditLensRequest.Currency_x = 'USD'; // set a default

                if (naApp.Opportunity__r != null) {
                    creditLensRequest.WexRelationshipManager = getUserName(naApp.Opportunity__r.OwnerId);
                    if (naApp.Opportunity__r.Sales_Group__c != null && naApp.Opportunity__r.Sales_Group__c.equalsIgnoreCase('Travel')) {
                        creditLensRequest.WexBusinessUnit = 'Travel';
                    } else {
                        creditLensRequest.WexBusinessUnit = 'Payables';
                    }
                }
                creditLensRequest.WexCreditAnalyst = UserInfo.getName();
                if (naApp.Security_Type__c != null) creditLensRequest.CollateralSecurity = naApp.Security_Type__c;
                if (naApp.Security_Currency__c != null) creditLensRequest.WexRequestCurrency = naApp.Security_Currency__c;
                if (naApp.Security_Expiration_Date__c != null) creditLensRequest.WexExpirationSecurityDate = String.valueOf(naApp.Security_Expiration_Date__c);
                creditLensRequest.BillingCycle = 'Monthly'; // required for integration but NA Fleet does not set this field, this is the requested default

                if (naApp.SIC_Code__c != null) {

                    creditLensRequest.IndClassification = 'SIC';

                    CreditWS_CLCreateEntityRequest.IndustryCode industryCode = new CreditWS_CLCreateEntityRequest.IndustryCode();
                    industryCode = mapSICCode(naApp.SIC_Code__c);

                    if (industryCode != null) {
                        List<CreditWS_CLCreateEntityRequest.IndustrySelection> industrySelections = new List<CreditWS_CLCreateEntityRequest.IndustrySelection>();
                        CreditWS_CLCreateEntityRequest.IndustrySelection industrySelection = new CreditWS_CLCreateEntityRequest.IndustrySelection();
                        industrySelection.x_new = true;
                        industrySelection.Percentage = 1;
                        industrySelection.OperationType = 'Create';
                        industrySelection.IndustryId = -1;
                        industrySelection.Classification = 'SIC';
                        industrySelection.IsPrimary = true;
                        industrySelection.x_initialRulesExecuted = true;
                        industrySelection.IndustryCode = industryCode;

                        industrySelections.add(industrySelection);
                        creditLensRequest.IndustrySelection = industrySelections;
                    }
                }

                //add Applicant as a Contact
                List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit> contacts = new List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit>();
                CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit contact = new CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit();

                contact.x_new = true;
                contact.OperationType = 'Create';
                contact.x_initialRulesExecuted = true;
                contact.Email = naApp.App_Signer_Email__c;
                contact.Id = -1;
                contact.Name = naApp.App_Signer_Name_Text__c + ' ' + naApp.App_Signer_Last_Name_Text__c;
                contact.OfficeNo = naApp.Business_Phone_Number__c;

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
                physicalAddress.Address1 = naApp.Physical_Street__c;
                if (naApp.Physical_Street_Line_2__c != null) physicalAddress.Address2 = naApp.Physical_Street_Line_2__c;
                physicalAddress.Country = country;
                if (naApp.Physical_State__c != null) physicalAddress.State = naApp.Physical_Country__c + naApp.Physical_State__c;
                physicalAddress.City = naApp.Physical_City__c;
                physicalAddress.Zip = naApp.Physical_Zip_Postal_Code__c;
                physicalAddress.t_x = 'Address';

                addresses.add(physicalAddress);
                creditLensRequest.EntityAddress = addresses;

                Integer entityId = createEntity(creditLensRequest, token);

                if (entityId != null) {
                    naApp.Credit_Lens_Entity_ID__c = entityId;
                    naApp.Credit_Lens_Response__c = 'Entity ' + entityId + ' successfully created in Credit Lens!';
                    upsert naApp;
                } else {
                    String createStatus = createEntityUnable + '\n' + createEntityError;
                    if (createStatus.length() > 2000) {
                        naApp.Credit_Lens_Response__c = createStatus.substring(0,1995) + ' ...';
                        upsert naApp;
                    } else {
                        naApp.Credit_Lens_Response__c = createStatus;
                        upsert naApp;
                    }
                }
            }
        }
        // Currently, only designed to create a new Entity record from Online App
        else if (objectType.equalsIgnoreCase('OnlineApplication__c')) {

            System.debug('Online Application App ID: ' + objectId);
            List<OnlineApplication__c> appInfo = [
                    SELECT Id, Name, Legal_Business_Name__c, Trade_Name__c, Country__c, Business_Street_Address__c, Business_Address_Line_2__c, City__c, State__c, Zip_Code__c,
                            Type_of_Business__c, CurrencyIsoCode, Federal_Tax_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, Credit_Lens_Entity_ID__c, Opportunity__r.OwnerId, Opportunity__r.Sales_Group__c,
                            Credit_Line_Recommendation__c, Credit_Line_Requested__c, Account__r.AccountNumber, Country_of_Contracting_Entity__c, Country_of_Contracting_Entity_Other__c,
                            Financials_Completed_For__c, Program__r.Name, DNB_Trade_Lines__c, Paydex__c, Billing_Cycle__c, Control_Year__c, Risk_Grade__c, Risk_Grade_Source__c, Email__c, Phone_Number__c,
                            Contact_First_Name__c, Contact_Last_Name__c, SIC_Code__c, Credit_Lens_Response__c, Payment_Method__c, Security_Type__c, DNB_Credit_Line_Recommendation__c, Payment_Frequency__c,
                            Security_Currency__c, Security_Expiration_Date__c
                    FROM OnlineApplication__c
                    where Id = :objectId
            ];

            if (appInfo.size() == 1) {
                OnlineApplication__c onlineApp = appInfo[0];

                String country = CLCountry(onlineApp.Country__c);

                creditLensRequest.EntityType = 'CORP';
//                if (onlineApp.Credit_Lens_Entity_ID__c != null) creditLensRequest.EntityId = onlineApp.Credit_Lens_Entity_ID__c;
                if (onlineApp.Account__r != null && onlineApp.Account__r.AccountNumber != null) creditLensRequest.WexAccountNumber = onlineApp.Account__r.AccountNumber;
//                if (cpApp.National__c !=null) creditLensRequest.LegalEntity = cpApp.National__c;
                if (onlineApp.Program__r !=null) creditLensRequest.WexProgramString = onlineApp.Program__r.Name;
                creditLensRequest.LongName = onlineApp.Legal_Business_Name__c;
                creditLensRequest.ShortName = onlineApp.Trade_Name__c;
                creditLensRequest.PlaceOfIncorporation = country;
                creditLensRequest.CountryOfInc = country;
                if (onlineApp.State__c != null) {
                    creditLensRequest.ProvinceStateOfIncorporation = onlineApp.Country__c + onlineApp.State__c;
                }
                creditLensRequest.BusinessPortfolio = country;
                if (onlineApp.Country_of_Contracting_Entity__c != null) creditLensRequest.CountryOfRisk = CLCountry(onlineApp.Country_of_Contracting_Entity__c);
                if (onlineApp.Country_of_Contracting_Entity_Other__c != null) creditLensRequest.CountryOfRisk = CLCountry(onlineApp.Country_of_Contracting_Entity_Other__c);
                if (creditLensRequest.CountryOfRisk == null) creditLensRequest.CountryOfRisk = country; // set default because it's required
                creditLensRequest.SystemId = onlineApp.Name;
                creditLensRequest.Division = 'Fleet';
                creditLensRequest.CreditPortfolio = 'WexBank';
                creditLensRequest.WexCreditInformationOn = onlineApp.Financials_Completed_For__c;
                if (onlineApp.Payment_Frequency__c != null) {
                     String billingCycle = mapBillingCycle(onlineApp.Payment_Frequency__c);
                    if (billingCycle != null) creditLensRequest.BillingCycle = billingCycle;
                } else if (onlineApp.Payment_Method__c != null && onlineApp.Payment_Method__c.equalsIgnoreCase('Auto Pay (ACH)')) { creditLensRequest.BillingCycle = 'Daily'; }
//                if (cpApp.Payment_Type__c != null) creditLensRequest.WexPaymentType = cpApp.Payment_Type__c;  // can't send until they figure out the dropdown values in CL
                if (onlineApp.Credit_Line_Requested__c != null) creditLensRequest.WexRequestCreditLineAmount = String.valueOf(onlineApp.Credit_Line_Requested__c);
                if (onlineApp.Credit_Line_Recommendation__c != null) creditLensRequest.WexRecommendedCreditLine = String.valueOf(onlineApp.Credit_Line_Recommendation__c);
                if (onlineApp.DNB_Credit_Line_Recommendation__c != null) creditLensRequest.WexOriginationModelRecommendat = String.valueOf(onlineApp.DNB_Credit_Line_Recommendation__c);
                if (onlineApp.Federal_Tax_ID__c != null) creditLensRequest.TaxId = onlineApp.Federal_Tax_ID__c;
                if (onlineApp.DNB_Resolved_DUNS__c != null) creditLensRequest.WexDunsNumber = onlineApp.DNB_Resolved_DUNS__c;
                if (onlineApp.DNB_Trade_Lines__c != null) creditLensRequest.WexNumberOfCreditExperiences = Integer.valueOf(onlineApp.DNB_Trade_Lines__c);
                if (onlineApp.Paydex__c != null) creditLensRequest.WexPaydexScore = String.valueOf(onlineApp.Paydex__c);
                if (onlineApp.Control_Year__c != null) creditLensRequest.WexYearControl = onlineApp.Control_Year__c;
                if (onlineApp.Risk_Grade__c != null) creditLensRequest.WexPrimaryRiskGrade = onlineApp.Risk_Grade__c;
//                if (cpApp.Risk_Grade_Source__c != null) creditLensRequest.WexPrimaryRiskGradeSource = cpApp.Risk_Grade_Source__c; // can't send until they figure out the dropdown values in CL
                if (onlineApp.Stock_Symbol__c != null) {
                    creditLensRequest.FirmType = 'PUB';
                    creditLensRequest.StockCode = onlineApp.Stock_Symbol__c;
                } else {
                    creditLensRequest.FirmType = 'PRV'; // set default
                }
                if (onlineApp.Stock_Exchange__c != null) {
                    Moodys_CreditLens_Mapping__mdt stockExchangeMapping = CLStockExchange(onlineApp.Stock_Exchange__c);
                    if (stockExchangeMapping != null) {
                        creditLensRequest.StockExchange = stockExchangeMapping.Key__c;
                        creditLensRequest.CountryOfListing = country;
                    }
                }
                if (onlineApp.CurrencyIsoCode != null) creditLensRequest.Currency_x = onlineApp.CurrencyIsoCode; else creditLensRequest.Currency_x = 'USD'; // set a default

                if (onlineApp.Opportunity__r != null) {
                    creditLensRequest.WexRelationshipManager = getUserName(onlineApp.Opportunity__r.OwnerId);
                }
                creditLensRequest.WexCreditAnalyst = UserInfo.getName();
                creditLensRequest.WexBusinessUnit = 'OTR';
                if (onlineApp.Security_Type__c != null) creditLensRequest.CollateralSecurity = onlineApp.Security_Type__c;
                if (onlineApp.Security_Currency__c != null) creditLensRequest.WexRequestCurrency = onlineApp.Security_Currency__c;
                if (onlineApp.Security_Expiration_Date__c != null) creditLensRequest.WexExpirationSecurityDate = String.valueOf(onlineApp.Security_Expiration_Date__c);

                if (onlineApp.SIC_Code__c != null) {

                    creditLensRequest.IndClassification = 'SIC';

                    CreditWS_CLCreateEntityRequest.IndustryCode industryCode = new CreditWS_CLCreateEntityRequest.IndustryCode();
                    industryCode = mapSICCode(onlineApp.SIC_Code__c);

                    if (industryCode != null) {
                        List<CreditWS_CLCreateEntityRequest.IndustrySelection> industrySelections = new List<CreditWS_CLCreateEntityRequest.IndustrySelection>();
                        CreditWS_CLCreateEntityRequest.IndustrySelection industrySelection = new CreditWS_CLCreateEntityRequest.IndustrySelection();
                        industrySelection.x_new = true;
                        industrySelection.Percentage = 1;
                        industrySelection.OperationType = 'Create';
                        industrySelection.IndustryId = -1;
                        industrySelection.Classification = 'SIC';
                        industrySelection.IsPrimary = true;
                        industrySelection.x_initialRulesExecuted = true;
                        industrySelection.IndustryCode = industryCode;

                        industrySelections.add(industrySelection);
                        creditLensRequest.IndustrySelection = industrySelections;
                    }
                }

                //add Applicant as a Contact
                List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit> contacts = new List<CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit>();
                CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit contact = new CreditWS_CLCreateEntityRequest.EntityContactCreateAndEdit();

                contact.x_new = true;
                contact.OperationType = 'Create';
                contact.x_initialRulesExecuted = true;
                contact.Email = onlineApp.Email__c;
                contact.Id = -1;
                contact.Name = onlineApp.Contact_First_Name__c + ' ' + onlineApp.Contact_Last_Name__c;
                contact.OfficeNo = onlineApp.Phone_Number__c;

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
                physicalAddress.Address1 = onlineApp.Business_Street_Address__c;
                if (onlineApp.Business_Address_Line_2__c != null) physicalAddress.Address2 = onlineApp.Business_Address_Line_2__c;
                physicalAddress.Country = country;
                if (onlineApp.State__c != null) physicalAddress.State = onlineApp.Country__c + onlineApp.State__c;
                physicalAddress.City = onlineApp.City__c;
                physicalAddress.Zip = onlineApp.Zip_Code__c;
                physicalAddress.t_x = 'Address';

                addresses.add(physicalAddress);
                creditLensRequest.EntityAddress = addresses;

                Integer entityId = createEntity(creditLensRequest, token);

                if (entityId != null) {
                    onlineApp.Credit_Lens_Entity_ID__c = entityId;
                    onlineApp.Credit_Lens_Response__c = 'Entity ' + entityId + ' successfully created in Credit Lens!';
                    upsert onlineApp;
                } else {
                    String createStatus = createEntityUnable + '\n' + createEntityError;
                    if (createStatus.length() > 2000) {
                        onlineApp.Credit_Lens_Response__c = createStatus.substring(0,1995) + ' ...';
                        upsert onlineApp;
                    } else {
                        onlineApp.Credit_Lens_Response__c = createStatus;
                        upsert onlineApp;
                    }

                }
            }
        }
    // Currently, only designed to create a new Entity record from CP App Request
        else if (objectType.equalsIgnoreCase('CP_Application_Request__c')) {

            System.debug('Corporate Payments App ID: ' + objectId);
            List<CP_Application_Request__c> appInfo = [
                    SELECT Id, Name, Company_Legal_Name__c, Doing_Business_As__c, Physical_Country__c, Physical_Address_Line_1__c, Physical_Address_Line_2__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c,
                            Legal_Structure__c, CurrencyIsoCode, Taxpayer_ID__c, DNB_Resolved_DUNS__c, Stock_Symbol__c, Stock_Exchange__c, CreditLens_EntityID__c, Opportunity__r.OwnerId, Opportunity__r.Sales_Group__c,
                            Credit_Line_Recommendation__c, Credit_Line_Requested__c, Account__r.AccountNumber, Country_of_Contacting_Entity__c, Country_of_Contracting_Entity_Other__c, National__c,
                            Mailing_Address_Line_1__c, Mailing_Address_Line_2__c, Mailing_City__c, Mailing_State_Province__c, Mailing_Postal_Code__c, Mailing_Country__c, Financials_Completed_For__c, Program__r.Name,
                            DNB_Trade_Lines__c, Paydex__c, Billing_Cycle__c, Control_Year__c, Risk_Grade__c, Risk_Grade_Source__c, Email__c, Business_Phone__c, First_Name__c, Last_Name__c, SIC_Code__c, Credit_Lens_Response__c, Payment_Type__c,
                            Security_Type__c, Security_Currency__c, Security_Expiration_Date__c, DNB_Credit_Line_Recommendation__c
                    FROM CP_Application_Request__c
                    where Id = :objectId
            ];

            if (appInfo.size() == 1) {
                CP_Application_Request__c cpApp = appInfo[0];

                String country = CLCountry(cpApp.Physical_Country__c);

                creditLensRequest.EntityType = 'CORP'; // cpApp.Legal_Structure__c; - need to have naming convention solidified
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
                if (cpApp.Billing_Cycle__c != null) {
                    String billingCycle = mapBillingCycle(cpApp.Billing_Cycle__c);
                    if (billingCycle != null) creditLensRequest.BillingCycle = billingCycle;
                }
//                if (cpApp.Payment_Type__c != null) creditLensRequest.WexPaymentType = cpApp.Payment_Type__c;  //cannot send because the picklist values don't match in Credit Lens
                if (cpApp.Credit_Line_Requested__c != null) creditLensRequest.WexRequestCreditLineAmount = String.valueOf(cpApp.Credit_Line_Requested__c);
                if (cpApp.Credit_Line_Recommendation__c != null) creditLensRequest.WexRecommendedCreditLine = String.valueOf(cpApp.Credit_Line_Recommendation__c);
                if (cpApp.DNB_Credit_Line_Recommendation__c != null) creditLensRequest.WexOriginationModelRecommendat = String.valueOf(cpApp.DNB_Credit_Line_Recommendation__c);
                if (cpApp.Taxpayer_ID__c != null) creditLensRequest.TaxId = cpApp.Taxpayer_ID__c;
                if (cpApp.DNB_Resolved_DUNS__c != null) creditLensRequest.WexDunsNumber = cpApp.DNB_Resolved_DUNS__c;
                if (cpApp.DNB_Trade_Lines__c != null) creditLensRequest.WexNumberOfCreditExperiences = Integer.valueOf(cpApp.DNB_Trade_Lines__c);
                if (cpApp.Paydex__c != null) creditLensRequest.WexPaydexScore = String.valueOf(cpApp.Paydex__c);
                if (cpApp.Control_Year__c != null) creditLensRequest.WexYearControl = cpApp.Control_Year__c;
                if (cpApp.Risk_Grade__c != null) creditLensRequest.WexPrimaryRiskGrade = cpApp.Risk_Grade__c;
//                if (cpApp.Risk_Grade_Source__c != null) creditLensRequest.WexPrimaryRiskGradeSource = cpApp.Risk_Grade_Source__c; //cannot send because the picklist values don't match in Credit Lens
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
                if (cpApp.Security_Currency__c != null) creditLensRequest.WexRequestCurrency = cpApp.Security_Currency__c;
                if (cpApp.Security_Expiration_Date__c != null) creditLensRequest.WexExpirationSecurityDate = String.valueOf(cpApp.Security_Expiration_Date__c);

                if (cpApp.SIC_Code__c != null) {

                    creditLensRequest.IndClassification = 'SIC';

                    CreditWS_CLCreateEntityRequest.IndustryCode industryCode = new CreditWS_CLCreateEntityRequest.IndustryCode();
                    industryCode = mapSICCode(cpApp.SIC_Code__c);

                    if (industryCode != null) {
                        List<CreditWS_CLCreateEntityRequest.IndustrySelection> industrySelections = new List<CreditWS_CLCreateEntityRequest.IndustrySelection>();
                        CreditWS_CLCreateEntityRequest.IndustrySelection industrySelection = new CreditWS_CLCreateEntityRequest.IndustrySelection();
                        industrySelection.x_new = true;
                        industrySelection.Percentage = 1;
                        industrySelection.OperationType = 'Create';
                        industrySelection.IndustryId = -1;
                        industrySelection.Classification = 'SIC';
                        industrySelection.IsPrimary = true;
                        industrySelection.x_initialRulesExecuted = true;
                        industrySelection.IndustryCode = industryCode;

                        industrySelections.add(industrySelection);
                        creditLensRequest.IndustrySelection = industrySelections;
                    }
                }

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
        // Only editing an existing Entity can be done from Case
        else if (objectType.equalsIgnoreCase('Case')) {

            System.debug('Case ID: ' + objectId);
            List<Case> caseInfo = [
                    SELECT Id, On_List__c, On_List_Date__c, Entity_ID__c, Credit_Lens_Response__c
                    FROM Case
                    where Id = :objectId
            ];

            if (caseInfo.size() == 1) {
                Case upmarketCase = caseInfo[0];
                // using the EntityID call Get Entity
                if (upmarketCase.Entity_ID__c != null && upmarketCase.Entity_ID__c.isNumeric()) {
                    Integer entityId = Integer.valueOf(upmarketCase.Entity_ID__c);
                    CreditWS_CLGetEntityResponse.PayLoad getEntityPayload = getEntity(entityId, token);
                    System.debug('getEntityPayload: ' + getEntityPayload);

                    // even though we only need to update CL with updated Case values, the EditEntity API needs all required fields be sent.
                    // so first get the existing Entity record from CL so we can gather the most up to date values for those required fields
                    if (getEntityPayload != null) {
                        CreditWS_CLEditEntityRequest editEntityRequest = new CreditWS_CLEditEntityRequest();
                        CreditWS_CLEditEntityRequest.Context context = new CreditWS_CLEditEntityRequest.Context();
                        context.taskId = '00000000-0000-0000-0000-000000000000';
                        context.wfId = '00000000-0000-0000-0000-000000000000';
                        editEntityRequest.context = context;
                        CreditWS_CLEditEntityRequest.PayLoad editEntityPayLoad = new CreditWS_CLEditEntityRequest.PayLoad();
                        editEntityPayLoad.OperationType = 'Update';
                        editEntityPayLoad.EntityId = entityId;
                        if (upmarketCase.On_List__c != null) editEntityPayLoad.OnList = Integer.valueOf(upmarketCase.On_List__c);
                        if (upmarketCase.On_List_Date__c != null) editEntityPayload.WexDateAdded = String.valueOf(upmarketCase.On_List_Date__c);
                        // add to the request all the required fields
                        editEntityPayLoad.LongName = getEntityPayload.LongName;
                        editEntityPayLoad.CountryOfInc = getEntityPayload.CountryOfInc;
                        editEntityPayLoad.BusinessPortfolio = getEntityPayload.BusinessPortfolio;
                        editEntityPayLoad.Division = getEntityPayload.Division;
                        editEntityPayLoad.CreditPortfolio = getEntityPayload.CreditPortfolio;
                        editEntityPayLoad.WexBusinessUnit = getEntityPayload.WexBusinessUnit;
                        editEntityPayLoad.WexRelationshipManager = getEntityPayload.WexRelationshipManager;
                        editEntityPayLoad.WexCreditAnalyst = getEntityPayload.WexCreditAnalyst;
                        editEntityPayLoad.FirmType = getEntityPayload.FirmType;
                        editEntityPayLoad.CountryOfRisk = getEntityPayload.CountryOfRisk;
                        editEntityPayLoad.Currency_x = getEntityPayload.Currency_x;
                        editEntityPayLoad.CountryOfListing = getEntityPayload.CountryOfListing;
                        editEntityPayLoad.StockCode = getEntityPayload.StockCode;
                        editEntityPayLoad.StockExchange = getEntityPayload.StockExchange;
                        editEntityPayLoad.WexRequestCreditLineAmount = String.valueOf(getEntityPayload.WexRequestCreditLineAmount);
                        editEntityPayLoad.WexPrimaryRiskGrade = getEntityPayload.WexPrimaryRiskGrade;
                        editEntityPayLoad.BillingCycle = getEntityPayload.BillingCycle;
                        editEntityPayLoad.WexRecommendedCreditLine = String.valueOf(getEntityPayload.WexRecommendedCreditLine);

                        editEntityRequest.payLoad = editEntityPayLoad;

                        // update the Entity in CL
                        upmarketCase.Credit_Lens_Response__c = editEntity(editEntityRequest, token);
                        upsert upmarketCase;
                    }
                } else {
                    System.debug('Unable to update Credit Lens Entity because either Case EntityID is null or invalid, or required fields are missing on the existing Entity in Credit Lens.');
                    upmarketCase.Credit_Lens_Response__c = 'Unable to update Credit Lens Entity because either Case EntityID is null or invalid, or required fields are missing on the existing Entity in Credit Lens.';
                    upsert upmarketCase;
                }
            }
        }
    }


    /**
     * Retrieve an existing Entity record from Credit Lens and all it's field values.
     */
    private static CreditWS_CLGetEntityResponse.Payload getEntity(Integer entityId, String token) {

        System.debug('Attempting to get Entity : ' + entityId);
        String responseBody = '';

        try {

            Credit_Decision_Engine_Endpoints__mdt CLGetEntitySettings = CLCreateOrGetEntitySettings;

            if (CLCreateOrGetEntitySettings != null) {
                HttpRequest request = new HttpRequest();

                request.setMethod('GET');
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Authorization', 'Bearer ' + token);
                request.setEndpoint(CLGetEntitySettings.Endpoint_URL__c + '/' + entityId); //Entity Id added right to the endpoint to get the given Entity record

                Http http = new Http();
                HttpResponse httpResponse = http.send(request);

                if (httpResponse.getStatusCode() == 200) {
                    responseBody = httpResponse.getBody();
                    System.debug('Get Entity response before parse: ' + responseBody);

                    String jsonResponseWithSpecialChars = replaceSpecialCharsJSON(responseBody, true);
                    CreditWS_CLGetEntityResponse response = CreditWS_CLGetEntityResponse.parse(jsonResponseWithSpecialChars);

                    if (response != null) {
                        List<CreditWS_CLGetEntityResponse.PayLoad> payloads = new List<CreditWS_CLGetEntityResponse.PayLoad>();
                        payloads = response.payLoad;

                        if (!payloads.isEmpty()) {
                            System.debug('Entity found in Credit Lens. Entity ID:  ' + payloads[0].EntityId);
                            return payloads[0];
                        }
                    }
                } else {
                    // good payload but not a Status of 200 - so what happened?
                    System.debug('Unable to get entity in Credit Lens: ' + httpResponse.getBody());
                }
            }

        } catch (Exception e) {
            System.debug('### Error getting entity in Credit Lens - line number: ' + e.getLineNumber() + ' - ' + e.getMessage());
        }
        return null;
    }

    /**
     * Method attempts to edit and save the given Entity record.
     * Returns either a success message with the Entity ID of the record it updated or the http response body of the failure message.
     */
    private static String editEntity(CreditWS_CLEditEntityRequest editEntityRequest, String token) {

        System.debug('Attempting to edit Entity...');
        String jsonRequest = replaceSpecialCharsJSON(JSON.serializePretty(editEntityRequest, true), false);
        String responseBody = '';

        try {

            Credit_Decision_Engine_Endpoints__mdt CLEditEntitySettings = CLEditEntitySettings;

            if (CLEditEntitySettings != null) {

                HttpRequest request = new HttpRequest();

                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Authorization', 'Bearer ' + token);
                request.setEndpoint(CLEditEntitySettings.Endpoint_URL__c);
                request.setBody(jsonRequest);

                Http http = new Http();
                HttpResponse httpResponse = http.send(request);

                if (httpResponse.getStatusCode() == 200) {

                    responseBody = httpResponse.getBody();
                    System.debug('Edit Entity response before parse: ' + responseBody);

                    CreditWS_CLEditEntityResponse response = CreditWS_CLEditEntityResponse.parse(responseBody);

                    if (response != null) {

                        List<CreditWS_CLEditEntityResponse.PayLoad> payloads = new List<CreditWS_CLEditEntityResponse.PayLoad>();
                        payloads = response.payLoad;

                        if (!payloads.isEmpty()) {
                            System.debug('Entity ' + payloads[0].EntityId + ' updated in Credit Lens!');
                            return 'Entity ' + payloads[0].EntityId + ' updated in Credit Lens!';
                        }
                    }
                } else {
                    // good payload but not a Status of 200 - so what happened?
                    System.debug('Unable to edit entity in Credit Lens: ' + httpResponse.getBody());
                    return httpResponse.getBody();
                }
            }

        }  catch (Exception e) {
            System.debug('### Error editing entity in Credit Lens - line number: ' + e.getLineNumber() + ' - ' + e.getMessage());
        }
        return null;
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

            String jsonRequest = replaceSpecialCharsJSON(JSON.serializePretty(creditLensRequest, true), false);

            String responseBody = '';

            try {

                Credit_Decision_Engine_Endpoints__mdt CLCreateEntitySettings = CLCreateOrGetEntitySettings;

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
                        System.debug('Create Entity response before parse: ' + responseBody);

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
                System.debug('### Error creating entity in Credit Lens - line number: ' + e.getLineNumber() + ' - ' + e.getMessage());
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
    public static Boolean linkDocToEntity(String appId, List<String> docIds, String sObjectType) {

        System.debug('Attempting to link uploaded document to the appropriate Entity in Credit Lens...');

        Integer entityId = getEntityId(appId, sObjectType);
        if (entityId == null) {
            System.debug('No Entity related to this application exists yet in Credit Lens.');
            return false;
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

                String jsonRequest = replaceSpecialCharsJSON(JSON.serializePretty(docToEntityRequest, true), false);

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
     * Query for the Credit Lens Entity Id for the given sObject type
     * and convert it from a Decimal to an Integer.
     *
     * @param appId
     * @param sObjectType
     *
     * @return
     */
    private static Integer getEntityId(Id appId, String sObjectType) {

        System.debug('sObjectType: ' + sObjectType);

        Decimal entityDecimal = null;

        // CORPORATE PAYMENTS
        if (sObjectType != null && (sObjectType).equalsIgnoreCase('CP_Application_Request__c')) {
            List<CP_Application_Request__c> cpApps = [SELECT CreditLens_EntityID__c FROM CP_Application_Request__c WHERE Id = :appId];
            if (cpApps.size() > 0) {
                entityDecimal = cpApps[0].CreditLens_EntityID__c;
            }
        }
        // NA FLEET
        else if (sObjectType != null && (sObjectType).equalsIgnoreCase('Application_Request__c')) {
            List<Application_Request__c> naApps = [SELECT Credit_Lens_Entity_ID__c FROM Application_Request__c WHERE Id = :appId];
            if (naApps.size() > 0) {
                entityDecimal = naApps[0].Credit_Lens_Entity_ID__c;
                System.debug('entityDecimal: ' + entityDecimal);
            }
        }
        // OTR
        else if (sObjectType != null && (sObjectType).equalsIgnoreCase('OnlineApplication__c')) {
          List<OnlineApplication__c> otrApps = [SELECT Credit_Lens_Entity_ID__c FROM OnlineApplication__c WHERE Id = :appId];
            if (otrApps.size() > 0) {
                entityDecimal = otrApps[0].Credit_Lens_Entity_ID__c;
            }
        }

        if (entityDecimal != null) {
            return Integer.valueOf(entityDecimal);
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
    public static String replaceSpecialCharsJSON(String jsonBody, Boolean reverse) {

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

        //for taking response and changing them to non-reserved words
        if (reverse) {

            Map<String, String> newMap = new Map<String, String>();

            for (String key : replacements.keySet()) {
                newMap.put(replacements.get(key), key);
            }

            replacements = newMap;

        }

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
        System.debug('Formatted JSON post replacement of things and stuff: ' + formattedJSON);
        return formattedJSON;
    }

    private static String getUserName(Id id) {

        List<User> users = [ SELECT Name from User where id =: id];

        if (users.size() > 0) {
            return users[0].Name;
        }
        return null;
    }

    private static CreditWS_CLCreateEntityRequest.IndustryCode mapSICCode(String SICCode) {

        CreditWS_CLCreateEntityRequest.IndustryCode industryCode = new CreditWS_CLCreateEntityRequest.IndustryCode();

        try {
            SIC_Code_Mapping__mdt industryCodeMapping = [SELECT Id, Description__c, Letter_Group__c, Number__c FROM SIC_Code_Mapping__mdt WHERE Label = :SICCode];

            industryCode.Code = SICCode;
            industryCode.Description = industryCodeMapping.Description__c;
            industryCode.Keys = new list<String> { industryCodeMapping.Letter_Group__c, industryCodeMapping.Number__c, SICCode };

        } catch (Exception e) {
            System.debug('### ERROR: Error getting SIC Code mappings.');
            return null;
        }
        return industryCode;
    }

    /**
     * Ghetto hack for mapping the frequency to a billing cycle that matches values in Credit Lens.
     * OTR has billing cycles that call out specific days of the week, the easiest way to map the
     * Billing Cycle to Credit Lens is to extrapolate the value from the payment frequency.
     * For CP most billing cycles match, aside from Bi-Weekly.
     * @return
     */
    private static String mapBillingCycle(String paymentFrequency) {

        switch on paymentFrequency {
            when 'DAILY' {
                return 'Daily';
            }
            when 'WEEKLY' {
                return 'Weekly';
            }
            when 'SEMI_WEEKLY' {
                return '2xWeekly';
            }
            when 'TRIPLE_PLAY' {
                return '3xWeekly';
            }
            when 'Bi-Weekly' {
                return 'BiWeekly';
            }
            when else {
                return paymentFrequency;
            }
        }
    }
}