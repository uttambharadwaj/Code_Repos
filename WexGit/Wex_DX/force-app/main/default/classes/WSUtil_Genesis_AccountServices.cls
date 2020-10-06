/*
    Type:       Web Service Callout
    Purpose:    Methods to callout to WEX AU Genesis to create Accounts and Cards.
                Manipulation of data and population of objects should occur here to minimise
                the code in the WS class in case it needs to be re-generated.

                Note: Pricing values should only be sent to Genesis if they are "overrides"
                Refer to integration documentation for field formats, max lengths, and mapping.

    Used By:    AccountAndCardsToGenesis_ExCon.cls
    ---------------------------------------------------------------
    History:
    01-May-2014 M.Erwin (Salesforce.com)    Created
    28-May-2014 M.Erwin (Salesforce.com)    Closes requirement #173: The Genesis "Application" really should map to the Salesforce Opportunity
    09-Mar-2016 M. Bickford (WEX)           Added Wholesaler Discount Codes and associated start and end dates.
    11-May-2016 D. Gilbert  (WEX)           Removed assumption of not sending date fields when Wholesaler Discount Codes are blank. 
    27-Jun-2016 R. Beattie  (WEX)           Added Discount Wholesaler Fields (formula from campaign)
*/
public without sharing class WSUtil_Genesis_AccountServices {

    /* CONSTANTS */
    private static final Integer GENESIS_ADDRESS_LENGTH = 35;

    /* PRIVATE VARIABLES AND METHODS */
    private String booleanToTrueFalse(Boolean theBoolean) {
        String returnString = 'false';
        if (theBoolean) {
            returnString = 'true';
        }
        return returnString;
    }
    private String booleanToYN(Boolean theBoolean) {
        String returnString = 'N';
        if (theBoolean) {
            returnString = 'Y';
        }
        return returnString;
    }
    private String generateUid(Id recordId) {
        String recordIdAsString = recordId;
        Integer currentTimeMillisInteger = System.currentTimeMillis().intValue();
        String uid = recordIdAsString.substring(10) + String.valueOf(System.currentTimeMillis());
        return uid;
    }
    private String splitOnColon(String inputString) {
        String returnString = null;
        if (inputString != null) {
            returnString = inputString.split(':', 0)[0];
        }
        return returnString;
    }
    private String substring35(String sourceString, Integer block) {
        String returnString;
        Integer totalLength = sourceString.length();
        Integer lengthOfBlockToEnd = totalLength - ((block-1)*35);
        if (lengthOfBlockToEnd >= 35) {
            returnString = sourceString.substring((block-1)*35, (block)*35);
        } else {
            // Avoid out of bounds error
            returnString = sourceString.substring((block-1)*35);
        }
        return returnString;
    }
    private String dateToGenesisFormat(Date sourceDate) {
        String returnString;
        returnString = sourceDate.year() +'/'+ sourceDate.month() +'/'+ sourceDate.day();
        return returnString;
    }

    /* PUBLIC VARIABLES AND METHODS */
    public String createAccountUid { get; set; }
    public String addCardsUid { get; set; }
    public String addVehiclesUid { get; set; }
    public Id opportunityId { get; set; }
    public String genesisAccountNumber { get; set; }
    public WS_Genesis_AccountServices.CreateAccountResponse_element createAccount(AU_Application_Request__c appRequest) {
        WS_Genesis_AccountServices.CreateAccount_element createAccountElement = new WS_Genesis_AccountServices.CreateAccount_element();
        WS_Genesis_AccountServices.CreateAccountResponse_element response;

        List<Contact> additionalContacts = new List<Contact>();

        appRequest = [SELECT Id,
                            Application_Status__c,
                            Approval_Status__c,
                            Credit_Limit__c,
                            Positive_Balance_Account__c,
                            Positive_Balance_Account_Credit__c,
                            Positive_Balance_Limit__c,

                            Account__r.Id,
                            Account__r.AU_ABN__c,
                            Account__r.AU_ACN__c,
                            Account__r.Account_Email_Address__c,
                            Account__r.BillingStreet,
                            Account__r.BillingCity,
                            Account__r.BillingPostalCode,
                            Account__r.BillingState,
                            Account__r.AU_Business_Structure__c,
                            Account__r.AU_Business_Trading_Name__c,
                            Account__r.Client_Reference__c,
                            Account__r.AU_Date_Business_Commenced__c,
                            Account__r.Industry,
                            Account__r.Name,
                            Account__r.AU_Postal_Address__c,
                            Account__r.AU_Postal_Suburb__c,
                            Account__r.AU_Postal_Postcode__c,
                            Account__r.AU_Postal_State__c,
                            Account__r.AU_Trustee__c,
                            Account__r.Account_Card_Dispatch_Address_1__c,
                            Account__r.Account_Card_Dispatch_Address_2__c,
                            Account__r.Account_Card_Dispatch_State__c,
                            Account__r.Account_Card_Dispatch_Suburb__c,
                            Account__r.Account_Card_Dispatch_Postcode__c,
                            Account__r.AU_GST_Required__c,
                            //New discount fields added 3/9/2016
                            Opportunity__r.Wholesaler_Discount_Code_1__c,
                            Opportunity__r.Discount_Code_1_Start_Date__c,
                            Opportunity__r.Discount_Code_1_End_Date__c,
                            Opportunity__r.Wholesaler_Discount_Code_2__c,
                            Opportunity__r.Discount_Code_2_Start_Date__c,
                            Opportunity__r.Discount_Code_2_End_Date__c,

                            Opportunity__r.Id,
                            Opportunity__r.AU_Account_PIN_Setting__c,
                            Opportunity__r.Area_Manager__c,
                            Opportunity__r.Bank_Account_Name__c,
                            Opportunity__r.Bank_Account_Number__c,
                            Opportunity__r.BAS_Email_Address__c,
                            Opportunity__r.AU_BSB__c,
                            Opportunity__r.Billing_Frequency__c,
                            Opportunity__r.AU_Drivers_Licence_No__c,
                            Opportunity__r.AU_Date_of_Birth__c,
                            Opportunity__r.AU_Email_PIN_Notification__c,
                            Opportunity__r.AU_Employer_Phone__c,
                            Opportunity__r.AU_Employment_Commenced__c,
                            Opportunity__r.Exception_Level_Reporting__c,
                            Opportunity__r.AU_Exception_Reporting_Email_Address_1__c,
                            Opportunity__r.AU_Exception_Reporting_Email_Address_2__c,
                            Opportunity__r.AU_Exception_Reporting_Email_Address_3__c,
                            Opportunity__r.AU_Financial_Institution__c,
                            Opportunity__r.AU_Financial_Institution_Suburb__c,
                            Opportunity__r.Genesis_Account_Number__c,
                            Opportunity__r.Group_Code__c,
                            Opportunity__r.AU_Joining_Fee_Override__c,
                            Opportunity__r.AU_Monthly_Card_Fee__c,
                            Opportunity__r.AU_Merchant_Incentive_Reference_Number__c,
                            Opportunity__r.Paper_Statements__c,
                            Opportunity__r.LeadSource,
                            Opportunity__r.Product_Type__c,
                            Opportunity__r.AU_Reporting_odometer_Incorrect__c,
                            Opportunity__r.AU_Reporting_Odometer_Missing__c,
                            Opportunity__r.BAS_Reporting_Type__c,
                            Opportunity__r.Promotional_Code__c,
                            Opportunity__r.AU_Sales_Channel__c,
                            Opportunity__r.Submitted_For_Assessment_Date_Time__c,
                            Opportunity__r.AU_Title__c,

                            Opportunity__r.Primary_Contact__r.Email,
                            Opportunity__r.Primary_Contact__r.Fax,
                            Opportunity__r.Primary_Contact__r.Salutation,
                            Opportunity__r.Primary_Contact__r.FirstName,
                            Opportunity__r.Primary_Contact__r.LastName,
                            Opportunity__r.Primary_Contact__r.MobilePhone,
                            Opportunity__r.Primary_Contact__r.Phone,

                            Opportunity__r.AU_Aggregate_Amount__c,
                            Opportunity__r.AU_Excess__c,

                            Opportunity__r.Campaign__r.Genesis_Incentive_Scheme_Code__c

                            FROM AU_Application_Request__c
                            WHERE Id = :appRequest.Id];


        additionalContacts = [
            SELECT Id, Contact_Type__c, AU_Licence_Number__c, AU_Additional_Sub_Agent__c, Lead__c, Salutation, FirstName, LastName, Phone, MobilePhone, Email, MerchantID__c, Birthdate, Decision_Maker__c, Preferred_Contact_Method__c, Middle_Name__c
            FROM Contact
            WHERE AccountId =: appRequest.Account__r.Id
        ];

        try {
            createAccountElement.Source = 'SF';
            // Set createAccountUid for use by calling class
            opportunityId = appRequest.Opportunity__r.Id;
            createAccountUid = generateUid(opportunityId);
            createAccountElement.UID = createAccountUid;
            // Set genesisAccountNumber for use by calling class
            genesisAccountNumber = appRequest.Opportunity__r.Genesis_Account_Number__c;
            createAccountElement.AccountNumber = genesisAccountNumber;
            createAccountElement.Status = appRequest.Approval_Status__c;
            if (appRequest.Account__r.AU_Business_Structure__c != null) {
                createAccountElement.ApplicationType = splitOnColon(appRequest.Account__r.AU_Business_Structure__c);
            }
            createAccountElement.RegisteredName = appRequest.Account__r.Name;
            createAccountElement.ABN = appRequest.Account__r.AU_ABN__c;
            createAccountElement.Salutation = appRequest.Opportunity__r.Primary_Contact__r.Salutation;
            createAccountElement.FirstName = appRequest.Opportunity__r.Primary_Contact__r.FirstName;
            createAccountElement.Surname = appRequest.Opportunity__r.Primary_Contact__r.LastName;
            createAccountElement.MainTelephone = appRequest.Opportunity__r.Primary_Contact__r.Phone;
            if (appRequest.Opportunity__r.Product_Type__c != null) {
                Map<String, GenesisProductTypeToCodeMapping__c> genesisProductTypeToCodeMapping = GenesisProductTypeToCodeMapping__c.getAll();
                if (genesisProductTypeToCodeMapping.containsKey(appRequest.Opportunity__r.Product_Type__c)) {
                    createAccountElement.AccountType = genesisProductTypeToCodeMapping.get(appRequest.Opportunity__r.Product_Type__c).Genesis_Code__c;
                }
            }
            createAccountElement.BillingCycle = splitOnColon(appRequest.Opportunity__r.Billing_Frequency__c);
            if (appRequest.Credit_Limit__c != null) {
                createAccountElement.CreditLimit = String.valueOf(appRequest.Credit_Limit__c);
            }
            createAccountElement.Identifier = opportunityId;

            // If Salesforce Account.BillingStreet is > 35 will split into chunks of 35 and pass to successive web service fields.
            // The Genesis street address lines 1 and 2 are built up from PhysicalPropertyName, PhysicalUnitType, PhysicalUnitNumber,
            // PhysicalLevelType, PhysicalLevelNumber, PhysicalStreetNumber, PhysicalStreetName, and PhysicalStreetType.
            if (appRequest.Account__r.BillingStreet != null) {
                if (appRequest.Account__r.BillingStreet.length() > 0 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalPropertyName = substring35(appRequest.Account__r.BillingStreet, 1);
                }
                if (appRequest.Account__r.BillingStreet.length() > 1 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalUnitType = substring35(appRequest.Account__r.BillingStreet, 2);
                }
                if (appRequest.Account__r.BillingStreet.length() > 2 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalUnitNumber = substring35(appRequest.Account__r.BillingStreet, 3);
                }
                if (appRequest.Account__r.BillingStreet.length() > 3 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalLevelType = substring35(appRequest.Account__r.BillingStreet, 4);
                }
                if (appRequest.Account__r.BillingStreet.length() > 4 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalLevelNumber = substring35(appRequest.Account__r.BillingStreet, 5);
                }
                if (appRequest.Account__r.BillingStreet.length() > 5 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalStreetNumber = substring35(appRequest.Account__r.BillingStreet, 6);
                }
                if (appRequest.Account__r.BillingStreet.length() > 6 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalStreetName = substring35(appRequest.Account__r.BillingStreet, 7);
                }
                if (appRequest.Account__r.BillingStreet.length() > 7 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PhysicalStreetType = substring35(appRequest.Account__r.BillingStreet, 8);
                }
            }
            createAccountElement.PhysicalSuburb = appRequest.Account__r.BillingCity;
            createAccountElement.PhysicalPostcode = appRequest.Account__r.BillingPostalCode;
            createAccountElement.PhysicalState = appRequest.Account__r.BillingState;
            createAccountElement.PaperStatements = booleanToTrueFalse(appRequest.Opportunity__r.Paper_Statements__c);
            createAccountElement.ProductName = appRequest.Opportunity__r.Product_Type__c;
            createAccountElement.GroupCode = appRequest.Opportunity__r.Group_Code__c;
            if (appRequest.Opportunity__r.Submitted_For_Assessment_Date_Time__c != null) {
                createAccountElement.ApplicationAcceptanceDate = dateToGenesisFormat(appRequest.Opportunity__r.Submitted_For_Assessment_Date_Time__c.date());
            }
            if (appRequest.Account__r.AU_Date_Business_Commenced__c != null) {
                createAccountElement.BusinessCommencementDate = dateToGenesisFormat(appRequest.Account__r.AU_Date_Business_Commenced__c);
            }
            createAccountElement.Trustee = appRequest.Account__r.AU_Trustee__c;
            createAccountElement.BusinessTradingName = appRequest.Account__r.AU_Business_Trading_Name__c;
            createAccountElement.ACN = appRequest.Account__r.AU_ACN__c;
            createAccountElement.MobilePhone = appRequest.Opportunity__r.Primary_Contact__r.MobilePhone;
            createAccountElement.CorrespondenceEmail = appRequest.Opportunity__r.Primary_Contact__r.Email;
            createAccountElement.InvoiceEmail = appRequest.Account__r.Account_Email_Address__c;
            createAccountElement.LicenceNumber = appRequest.Opportunity__r.AU_Drivers_Licence_No__c;
            if (appRequest.Opportunity__r.AU_Date_of_Birth__c != null) {
                createAccountElement.DOB = dateToGenesisFormat(appRequest.Opportunity__r.AU_Date_of_Birth__c);
            }
            createAccountElement.ContactFax = appRequest.Opportunity__r.Primary_Contact__r.Fax;
            createAccountElement.EmploymentPosition = appRequest.Opportunity__r.AU_Title__c;
            createAccountElement.EmploymentContactNumber = appRequest.Opportunity__r.AU_Employer_Phone__c;
            if (appRequest.Opportunity__r.AU_Employment_Commenced__c != null) {
                createAccountElement.EmploymentCommencement = dateToGenesisFormat(appRequest.Opportunity__r.AU_Employment_Commenced__c);
            }

            if (appRequest.Account__r.AU_Postal_Address__c != null) {
                if (appRequest.Account__r.AU_Postal_Address__c.length() > 0 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PostalAddress1 = substring35(appRequest.Account__r.AU_Postal_Address__c, 1);
                }
                if (appRequest.Account__r.AU_Postal_Address__c.length() > 1 * GENESIS_ADDRESS_LENGTH) {
                    createAccountElement.PostalAddress2 = substring35(appRequest.Account__r.AU_Postal_Address__c, 2);
                }
            }
            createAccountElement.PostalSuburb = appRequest.Account__r.AU_Postal_Suburb__c;
            createAccountElement.PostalPostcode = appRequest.Account__r.AU_Postal_Postcode__c;
            createAccountElement.PostalState = appRequest.Account__r.AU_Postal_State__c;
            createAccountElement.AccountCardDispatchAddress1 = appRequest.Account__r.Account_Card_Dispatch_Address_1__c;
            createAccountElement.AccountCardDispatchAddress2 = appRequest.Account__r.Account_Card_Dispatch_Address_2__c;
            createAccountElement.AccountCardDispatchSuburb = appRequest.Account__r.Account_Card_Dispatch_Suburb__c;
            if (appRequest.Account__r.Account_Card_Dispatch_Postcode__c != null) {
                createAccountElement.AccountCardDispatchPostcode = String.valueOf(appRequest.Account__r.Account_Card_Dispatch_Postcode__c);
            }
            createAccountElement.AccountCardDispatchState = appRequest.Account__r.Account_Card_Dispatch_State__c;
            createAccountElement.ExceptionReportingEmail1 = appRequest.Opportunity__r.AU_Exception_Reporting_Email_Address_1__c;
            createAccountElement.ExceptionReportingEmail2 = appRequest.Opportunity__r.AU_Exception_Reporting_Email_Address_2__c;
            createAccountElement.ExceptionReportingEmail3 = appRequest.Opportunity__r.AU_Exception_Reporting_Email_Address_3__c;
            createAccountElement.ExceptionReportingOdometerMissing = booleanToTrueFalse(appRequest.Opportunity__r.AU_Reporting_odometer_Incorrect__c);
            createAccountElement.ExceptionReportingOdometerIncorrect = booleanToTrueFalse(appRequest.Opportunity__r.AU_Reporting_Odometer_Missing__c);
            createAccountElement.ExceptionReportingLevel = appRequest.Opportunity__r.Exception_Level_Reporting__c;
            createAccountElement.DirectDebitBSB = appRequest.Opportunity__r.AU_BSB__c;
            createAccountElement.DirectDebitBankName = appRequest.Opportunity__r.AU_Financial_Institution__c;
            createAccountElement.DirectDebitBankSuburb = appRequest.Opportunity__r.AU_Financial_Institution_Suburb__c;
            createAccountElement.DirectDebitAccountNumber = appRequest.Opportunity__r.Bank_Account_Number__c;
            createAccountElement.DirectDebitAccountName = appRequest.Opportunity__r.Bank_Account_Name__c;
            createAccountElement.AccountPINSetting = splitOnColon(appRequest.Opportunity__r.AU_Account_PIN_Setting__c);
            createAccountElement.EmailPINNotification = appRequest.Opportunity__r.AU_Email_PIN_Notification__c;
            createAccountElement.GSTRegistered = booleanToYN(appRequest.Account__r.AU_GST_Required__c);
            if (appRequest.Opportunity__r.AU_Joining_Fee_Override__c != null) {
                createAccountElement.JoiningFee = String.valueOf(appRequest.Opportunity__r.AU_Joining_Fee_Override__c);
            }
            if (appRequest.Opportunity__r.AU_Monthly_Card_Fee__c != null) {
                createAccountElement.MonthlyCardFee = String.valueOf(appRequest.Opportunity__r.AU_Monthly_Card_Fee__c);
            }
            createAccountElement.PromoCode = appRequest.Opportunity__r.Promotional_Code__c;
            createAccountElement.RepCode = appRequest.Opportunity__r.Area_Manager__c;
            createAccountElement.ReferenceNumber = appRequest.Opportunity__r.AU_Merchant_Incentive_Reference_Number__c;
            createAccountElement.SalesChannel = appRequest.Opportunity__r.AU_Sales_Channel__c;
            createAccountElement.LeadSource = appRequest.Opportunity__r.LeadSource;
            createAccountElement.BASReportingType = appRequest.Opportunity__r.BAS_Reporting_Type__c;
            createAccountElement.BASReportingEmail = appRequest.Opportunity__r.BAS_Email_Address__c;
            createAccountElement.IncentiveScheme = appRequest.Opportunity__r.Campaign__r.Genesis_Incentive_Scheme_Code__c;
            createAccountElement.ClientNumber = appRequest.Account__r.Client_Reference__c;
            createAccountElement.PositiveBalanceAccountCust = booleanToYN(appRequest.Positive_Balance_Account__c);
            createAccountElement.PositiveBalanceAccountCredit = booleanToYN(appRequest.Positive_Balance_Account_Credit__c);
            if (appRequest.Positive_Balance_Limit__c != null) {
                createAccountElement.PositiveBalanceLimit = String.valueOf(appRequest.Positive_Balance_Limit__c);
            }
            if (appRequest.Account__r.Industry != null) {
                Map<String, GenesisIndustryToCodeMapping__c> genesisIndustryToCodeMapping = GenesisIndustryToCodeMapping__c.getAll();
                if (genesisIndustryToCodeMapping.containsKey(appRequest.Account__r.Industry)) {
                    createAccountElement.IndustryClassification = genesisIndustryToCodeMapping.get(appRequest.Account__r.Industry).Genesis_Code__c;
                }
            }
            
            if (appRequest.Opportunity__r.Wholesaler_Discount_Code_1__c != null) {
                createAccountElement.WholesalerDiscountCode1 = appRequest.Opportunity__r.Wholesaler_Discount_Code_1__c;
            }    
            
            if (appRequest.Opportunity__r.Discount_Code_1_Start_Date__c != null) {
                createAccountElement.DiscountDateEffective1 = dateToGenesisFormat(appRequest.Opportunity__r.Discount_Code_1_Start_Date__c);
            }
                
            if (appRequest.Opportunity__r.Discount_Code_1_End_Date__c != null) {
                createAccountElement.DiscountExpiryDate1 = dateToGenesisFormat(appRequest.Opportunity__r.Discount_Code_1_End_Date__c);
            } 
            
            if (appRequest.Opportunity__r.Wholesaler_Discount_Code_2__c != null) {
                createAccountElement.WholesalerDiscountCode2 = appRequest.Opportunity__r.Wholesaler_Discount_Code_2__c;
            }    
            
            if (appRequest.Opportunity__r.Discount_Code_2_Start_Date__c != null) {
                createAccountElement.DiscountDateEffective2 = dateToGenesisFormat(appRequest.Opportunity__r.Discount_Code_2_Start_Date__c);
            }
                
            if (appRequest.Opportunity__r.Discount_Code_2_End_Date__c != null) {
                createAccountElement.DiscountExpiryDate2 = dateToGenesisFormat(appRequest.Opportunity__r.Discount_Code_2_End_Date__c);
            }

            if (appRequest.Opportunity__r.AU_Aggregate_Amount__c != null) {
                createAccountElement.AggregateDeductible = String.valueOf(appRequest.Opportunity__r.AU_Aggregate_Amount__c);
            }

            if (appRequest.Opportunity__r.AU_Excess__c != null) {
                createAccountElement.Excess = String.valueOf(appRequest.Opportunity__r.AU_Excess__c);
            }

            if(additionalContacts.size() > 0) {

                WS_Genesis_AccountServices.AdditionalContactsBlock_element contactsBlockElement = new WS_Genesis_AccountServices.AdditionalContactsBlock_element();

                contactsBlockElement.AdditionalContact = new WS_Genesis_AccountServices.AdditionalContact_element[]{};

                for(Contact additionalContact : additionalContacts) {

                    WS_Genesis_AccountServices.AdditionalContact_element contactElement = new WS_Genesis_AccountServices.AdditionalContact_element();

                    contactElement.Type = additionalContact.Contact_Type__c;
                    contactElement.Salutation = additionalContact.Salutation;
                    contactElement.FirstName = additionalContact.FirstName;
                    contactElement.MiddleName = additionalContact.Middle_Name__c;
                    contactElement.Surname = additionalContact.LastName;
                    contactElement.Phone = additionalContact.Phone;
                    contactElement.MobilePhone = additionalContact.MobilePhone;
                    contactElement.Email = additionalContact.Email;

                    contactElement.MerchantID = additionalContact.MerchantID__c;
                    contactElement.AFSLNumber = additionalContact.AU_Licence_Number__c;
                    contactElement.SubAgent = additionalContact.AU_Additional_Sub_Agent__c;
                    contactElement.Birthdate = String.valueOf(additionalContact.Birthdate);
                    contactElement.DecisionMaker = String.valueOf(additionalContact.Decision_Maker__c);
                    contactElement.PreferredContactMethod = additionalContact.Preferred_Contact_Method__c;

                    contactsBlockElement.AdditionalContact.add(contactElement);

                }

                createAccountElement.AdditionalContactsBlock = contactsBlockElement;

            }

            System.debug('### DEREK DEBUG: ' + createAccountElement.AdditionalContactsBlock);

            // Invoke and return the WS
            WS_Genesis_AccountServices.GenesisAccountServices genesisAccountServices = new WS_Genesis_AccountServices.GenesisAccountServices();
            response = genesisAccountServices.CreateAccount(createAccountElement);

            System.debug('### DEREK DEBUG - FULL CREATE ELEMENT - ' + createAccountElement);
            System.debug('### DEREK DEBUG - RESPONSE - ' + response);
        } catch (NullPointerException nullEx) {
            System.debug(System.LoggingLevel.ERROR, '##DEBUG: nullEx: ' + nullEx + '(' + nullEx.getLineNumber() + ')');
            throw new WS_Exception('Problem with referencing an empty record - please contact system administrator. Error message: ' + nullEx.getMessage());
        } catch (Exception ex) {
            // Handle any errors
            System.debug(System.LoggingLevel.ERROR, '##DEBUG: ex: ' + ex);
            throw new WS_Exception('Problem with web service - please contact system administrator. Error message: ' + ex.getMessage());
        }

        return response;
    }
    public WS_Genesis_AccountServices.AddCardResponse_element addCards(String genesisAccountNumber, List<AU_Card_Details__c> providedCards) {

        List<WS_Genesis_AccountServices.Card_element> cards = new List<WS_Genesis_AccountServices.Card_element>();
        for (AU_Card_Details__c auCard : [SELECT Id,
                                        Name,
                                        AU_Additional_Card_Text__c,
                                        BAS_Flag__c,
                                        BAS_Reporting_Fee_Override__c,
                                        Card_Bulk_PIN__c,
                                        Card_Controls__c,
                                        AU_Card_Dispatch_Address_1__c,
                                        AU_Card_Dispatch_Address_2__c,
                                        AU_Card_Dispatch_Address_Suburb__c,
                                        Card_Dispatch_Address_State__c,
                                        AU_Card_Dispatch_Address_Postcode__c,
                                        AU_card_PIN_setting__c,
                                        Card_Type__c,
                                        AU_Cost_Centre_Code__c,
                                        AU_Cost_Centre_Description__c,
                                        AU_Drivers_Name__c,
                                        AU_Card_Holder_Diesel_Card_Marketing_Are__c,
                                        AU_Card_Holder_email_address__c,
                                        AU_Cardholder_Mobile_Phone_Number__c,
                                        Cardholder_Employer_Name__c,
                                        Express_Delivery__c,
                                        Odometer_Required__c,
                                        Product_Restriction_Groups__c,
                                        AU_Reference_Required__c,
                                        Roadside_Assist_Fee_Frequency__c,
                                        Roadside_Assist_Fee_Override__c,
                                        Roadside_Assist_Key_Code__c,
                                        Roadside_Assist_VIN__c,
                                        AU_Signature_Strip__c,
                                        Site_Restriction__c,
                                        AU_Vehicle_Registration__c,
                                        AU_Vehicle_Make__c,
                                        AU_Vehicle_Model__c,
                                        Vehicle_Body_Type__c,
                                        Vehicle_Year__c,
                                        Vehicle_Colour__c
                                        FROM AU_Card_Details__c
                                        WHERE Id IN :providedCards]) {
            WS_Genesis_AccountServices.Card_element cardElement = new WS_Genesis_AccountServices.Card_element();

            cardElement.CardIdentifier = auCard.Name;
            cardElement.CardType = splitOnColon(auCard.Card_Type__c);
            cardElement.ExpressDelivery = booleanToTrueFalse(aucard.Express_Delivery__c);
            cardElement.SignatureStrip = booleanToTrueFalse(auCard.AU_Signature_Strip__c);
            cardElement.VehicleOdometerRequired = booleanToTrueFalse(auCard.Odometer_Required__c);
            cardElement.VehicleReferenceRequired = booleanToTrueFalse(auCard.AU_Reference_Required__c);
            cardElement.BASReporting = booleanToTrueFalse(auCard.BAS_Flag__c);
            cardElement.NameOnCard = auCard.AU_Drivers_Name__c;
            cardElement.CostCentre = auCard.AU_Cost_Centre_Code__c;
            cardElement.CostCentreDescription = auCard.AU_Cost_Centre_Description__c;
            if (auCard.AU_Vehicle_Registration__c != null) {
                cardElement.VehicleRegistration = String.valueOf(auCard.AU_Vehicle_Registration__c);
            }
            cardElement.VehicleMake = auCard.AU_Vehicle_Make__c;
            cardElement.VehicleModel = auCard.AU_Vehicle_Model__c;
            if (auCard.Vehicle_Year__c != null) {
                cardElement.VehicleYear = String.valueOf(auCard.Vehicle_Year__c);
            }
            cardElement.VehicleBodyType = auCard.Vehicle_Body_Type__c;
            cardElement.VehicleColour = auCard.Vehicle_Colour__c;
            cardElement.AlternateDeliveryAddress1 = auCard.AU_Card_Dispatch_Address_1__c;
            cardElement.AlternateDeliveryAddress2 = auCard.AU_Card_Dispatch_Address_2__c;
            cardElement.AlternateDeliveryAddressSuburb = auCard.AU_Card_Dispatch_Address_Suburb__c;
            cardElement.AlternateDeliveryAddressState = auCard.Card_Dispatch_Address_State__c;
            cardElement.AlternateDeliveryAddressPostcode = auCard.AU_Card_Dispatch_Address_Postcode__c;
            cardElement.CardholderEmail = auCard.AU_Card_Holder_email_address__c;
            cardElement.CardholderMobile = auCard.AU_Cardholder_Mobile_Phone_Number__c;
            cardElement.CardholderEmployerName = auCard.Cardholder_Employer_Name__c;
            if (auCard.BAS_Reporting_Fee_Override__c != null) {
                cardElement.BASReportingFeeOverride = String.valueOf(auCard.BAS_Reporting_Fee_Override__c);
            }
            cardElement.RoadsideAssistBillingPeriod = auCard.Roadside_Assist_Fee_Frequency__c;
            cardElement.RoadsideAssistVIN = auCard.Roadside_Assist_VIN__c;
            if (auCard.Roadside_Assist_Fee_Override__c != null) {
                cardElement.RoadsideAssistFeeOverride = String.valueOf(auCard.Roadside_Assist_Fee_Override__c);
            }
            if (auCard.Roadside_Assist_Key_Code__c != null) {
                cardElement.RoadsideAssistKeyCode = String.valueOf(auCard.Roadside_Assist_Key_Code__c);
            }
            cardElement.CardLevelPINSetting = splitOnColon(auCard.AU_card_PIN_setting__c);
            cardElement.CardBulkPIN = auCard.Card_Bulk_PIN__c;
            cardElement.SiteRestriction = auCard.Site_Restriction__c;
            cardElement.AdditionalCardText = auCard.AU_Additional_Card_Text__c;
            if (auCard.AU_Card_Holder_Diesel_Card_Marketing_Are__c != null) {
                List<WS_Genesis_AccountServices.GoldenNetwork_element> goldenNetworkElements = new List<WS_Genesis_AccountServices.GoldenNetwork_element>();
                for (String cardholderDieselMarketingArea : auCard.AU_Card_Holder_Diesel_Card_Marketing_Are__c.split(';', 0)) {
                    WS_Genesis_AccountServices.GoldenNetwork_element goldenNetworkElement = new WS_Genesis_AccountServices.GoldenNetwork_element();
                    goldenNetworkElement.GoldenNetworkId = splitOnColon(cardholderDieselMarketingArea);
                    goldenNetworkElements.add(goldenNetworkElement);
                }
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG: goldenNetworkElements: ' + goldenNetworkElements);
                cardElement.GoldenNetwork = goldenNetworkElements;
            }
            if (auCard.Card_Controls__c != null) {
                List<WS_Genesis_AccountServices.ProductRestrictionCategories_element> productRestrictionCategories = new List<WS_Genesis_AccountServices.ProductRestrictionCategories_element>();
                if (auCard.Card_Controls__c == 'Fuel & Oil Only') {
                    //Fuel & Oil Only = F, O
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_F = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_F.CategoryId = 'F';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_F);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_O = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_O.CategoryId = 'O';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_O);
                }
                if (auCard.Card_Controls__c == 'All Vehicle Expenses') {
                    //All Vehicle Expenses = F, V, O
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_F = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_F.CategoryId = 'F';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_F);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_V = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_V.CategoryId = 'V';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_V);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_O = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_O.CategoryId = 'O';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_O);
                }
                if (auCard.Card_Controls__c == 'All Expenses') {
                    //All Expenses = F, V, O, X
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_F = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_F.CategoryId = 'F';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_F);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_V = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_V.CategoryId = 'V';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_V);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_O = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_O.CategoryId = 'O';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_O);
                    WS_Genesis_AccountServices.ProductRestrictionCategories_element productRestrictionCategoriesElement_X = new WS_Genesis_AccountServices.ProductRestrictionCategories_element();
                    productRestrictionCategoriesElement_X.CategoryId = 'X';
                    productRestrictionCategories.add(productRestrictionCategoriesElement_X);
                }
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG: productRestrictionCategories: ' + productRestrictionCategories);
                cardElement.ProductRestrictionCategories = productRestrictionCategories;
            }
            if (auCard.Product_Restriction_Groups__c != null) {
                List<WS_Genesis_AccountServices.ProductRestrictionGroups_element> productRestrictionGroups = new List<WS_Genesis_AccountServices.ProductRestrictionGroups_element>();
                for (String productRestrictionGroup : auCard.Product_Restriction_Groups__c.split(';', 0)) {
                    WS_Genesis_AccountServices.ProductRestrictionGroups_element productRestrictionGroupElement = new WS_Genesis_AccountServices.ProductRestrictionGroups_element();
                    productRestrictionGroupElement.GroupId = splitOnColon(productRestrictionGroup);
                    productRestrictionGroups.add(productRestrictionGroupElement);
                }
                System.debug(System.LoggingLevel.DEBUG, '##DEBUG: productRestrictionGroups: ' + productRestrictionGroups);
                cardElement.ProductRestrictionGroups = productRestrictionGroups;
            }

            // Add the Card to the collection
            cards.add(cardElement);
        }

        WS_Genesis_AccountServices.AddCardResponse_element response = new WS_Genesis_AccountServices.AddCardResponse_element();
        if (!cards.isEmpty()) {
            System.debug(System.LoggingLevel.DEBUG, '##DEBUG: Cards exist - proceed: ');
            addCardsUid = generateUid(opportunityId);
            WS_Genesis_AccountServices.Cards_element cardsElement = new WS_Genesis_AccountServices.Cards_element();
            cardsElement.Card = cards;

            // Invoke and return the WS
            try {
                WS_Genesis_AccountServices.GenesisAccountServices genesisAccountServices = new WS_Genesis_AccountServices.GenesisAccountServices();
                response = genesisAccountServices.AddCard('SF', addCardsUid, genesisAccountNumber, cardsElement);
            } catch (Exception ex) {
                // Handle any errors
                System.debug(System.LoggingLevel.ERROR, '##DEBUG: ex: ' + ex);
                throw new WS_Exception('Problem with web service - please contact system administrator. Error message: ' + ex.getMessage());
            }
        }
        return response;
    }

    public WS_Genesis_AccountServices.AddVehicleResponse_element addVehicles(String genesisAccountNumber, List<AU_Vehicle__c> providedVehicles) {

        WS_Genesis_AccountServices.AddVehicleResponse_element response = new WS_Genesis_AccountServices.AddVehicleResponse_element();

        WS_Genesis_AccountServices.Vehicles_element vehiclesElement = new WS_Genesis_AccountServices.Vehicles_element();

        vehiclesElement.Vehicle = new WS_Genesis_AccountServices.Vehicle_element[]{};

        addVehiclesUid = generateUid(opportunityId);

        for(AU_Vehicle__c auVehicle : [SELECT Id,
                                        AU_Vehicle_Body_Type__c,
                                        AU_Vehicle_Colour__c,
                                        AU_Vehicle_Make_Code__c,
                                        AU_Vehicle_Make_Description__c,
                                        AU_Vehicle_Model_Code__c,
                                        AU_Vehicle_Model_Description__c,
                                        AU_Vehicle_Registration__c,
                                        AU_Vehicle_Expiry_Date__c,
                                        AU_Vehicle_Registration_State__c,
                                        AU_Vehicle_Engine_Number__c,
                                        AU_Vehicle_VIN__c,
                                        AU_Vehicle_Status__c,
                                        AU_Vehicle_Vehicle_Type__c
                                       FROM AU_Vehicle__c WHERE Id IN :providedVehicles]) {

            WS_Genesis_AccountServices.Vehicle_element vehicleElement = new WS_Genesis_AccountServices.Vehicle_element();

            vehicleElement.RegistrationState = auVehicle.AU_Vehicle_Registration_State__c;
            vehicleElement.Registration = auVehicle.AU_Vehicle_Registration__c;
            vehicleElement.VIN = auVehicle.AU_Vehicle_VIN__c;
            vehicleElement.MakeCode = auVehicle.AU_Vehicle_Make_Code__c;
            vehicleElement.MakeDescription = auVehicle.AU_Vehicle_Make_Description__c;
            vehicleElement.ModelCode = auVehicle.AU_Vehicle_Model_Code__c;
            vehicleElement.ModelDescription = auVehicle.AU_Vehicle_Model_Description__c;
            vehicleElement.Colour = auVehicle.AU_Vehicle_Colour__c;
            vehicleElement.BodyType = auVehicle.AU_Vehicle_Body_Type__c;
            vehicleElement.VehicleType = auVehicle.AU_Vehicle_Vehicle_Type__c;
            vehicleElement.EngineNumber = auVehicle.AU_Vehicle_Engine_Number__c;
            vehicleElement.Status = auVehicle.AU_Vehicle_Status__c;
            if(auVehicle.AU_Vehicle_Expiry_Date__c != null) vehicleElement.ExpiryDate = dateToGenesisFormat(auVehicle.AU_Vehicle_Expiry_Date__c);

            vehiclesElement.Vehicle.add(vehicleElement);

        }

        if(vehiclesElement != null) {

            try {
                WS_Genesis_AccountServices.GenesisAccountServices genesisAccountServices = new WS_Genesis_AccountServices.GenesisAccountServices();
                response = genesisAccountServices.AddVehicle('SF', addVehiclesUid, genesisAccountNumber, vehiclesElement);

                System.debug(response);
            } catch (Exception ex) {
                // Handle any errors
                System.debug(System.LoggingLevel.ERROR, '##DEBUG: ex: ' + ex);
                throw new WS_Exception('Problem with web service - please contact system administrator. Error message: ' + ex.getMessage());
            }

        }

        return response;

    }

}