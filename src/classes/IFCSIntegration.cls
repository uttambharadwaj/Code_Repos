public with sharing class IFCSIntegration {
    public static final Integer BATCH_SIZE = 4;
    public static Set<Id> processedIds = new Set<Id> ();

    public static void sendApplicationToIFCS(Set<Id> reqIds) {
        List<Id> records = new List<Id>(reqIds);
        for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
            Set<Id> batchIds = new Set<Id> ();
            for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
                batchIds.add(records.get(j));
            }

            if (!batchIds.isEmpty()) {
                doCallouts(batchIds);
            }
        }
    }

    @future(callout = true)
    public static void doCallouts(Set<Id> batchIds) {
        List<WES_Application_Request__c> reqList = [SELECT Agent_User_ID__c,
                                         Company_Name__c,
                                         Default_Additional_Embossed_Line__c,
                                         Company_Reg_Num__c,
                                         Language_Code__c,
                                         DUNS_Number__c,
                                         EnquirySourceID__c,
                                         Approval_Notes__c,
                                         VAT_Reg_Num__c,
                                         Account_ISO_Country_Code__c,
                                         Primary_Contact__r.Title,
                                         Primary_Contact__r.Salutation__c,
                                         Primary_Contact__r.FirstName,
                                         Primary_Contact__r.LastName,
                                         Primary_Contact__r.Phone,
                                         Primary_Contact__r.Fax,
                                         Primary_Contact__r.MobilePhone,
                                         Primary_Contact__r.Email,
                                         Company_Owner__r.Salutation__c,
                                         Company_Owner__r.FirstName,
                                         Company_Owner__r.LastName,
                                         Company_Owner__r.Home_Address_1__c,
                                         Company_Owner__r.Home_Address_2__c,
                                         Company_Owner__r.Home_Address_3__c,
                                         Company_Owner__r.Home_Address_City__c,
                                         Company_Owner__r.Home_Postcode__c,
                                         Company_Owner__r.WES_Home_Country_Code__c,
                                         Company_Owner__r.Date_Of_Birth__c,
                                         Company_Owner__r.Phone,
                                         Company_Owner__r.MobilePhone,
                                         Company_Owner__r.Email,
                                         Account__r.BillingStreet,
                                         Account__r.Physical_Street_Address__c,
                                         Account__r.WES_Address_Line2__c,
                                         Account__r.WES_Address_Line3__c,
                                         Account__r.BillingCity,
                                         Account__r.Physical_City__c,
                                         Account__r.BillingState,
                                         Account__r.Physical_State__c,
                                         Account__r.BillingPostalCode,
                                         Account__r.WES_ISO_Country_Code__c,
                                         Account__r.WES_BusinessCategory__c,
                                         Account__r.Physical_Zip_Postal_Code__c,
                                         Invoice_Format__c,
                                         Account_Billing_Email__c,
                                         Account_Billing_Frequency__c,
                                         ifcs_clientId__c,
                                         requestID__c,
                                         requestedByBusinessNumber__c,
                                         language_isoCode__c,
                                         applicationTypeId__c,
                                         OBU_Device_Required__c,
                                         VAT_Reclaim__c,
                                         VAS_Comments__c,
                                         VATCountryCode__c,
                                         paperlessDDI__c,
                                         TypeonMandate__c,
                                         IsFeeOverride__c,
                                         FeeOverrideComments__c,
                                         CreateVelocityAccount__c,
                                         VelocityAccountEmail__c,
                                         CreditInsuranceDecisions__c,
                                         CreditInsuranceDecisionDate__c,
                                         Dunning_Classification__c,
                                         IFCS_Business_Entity_Code__c,
                                         Primary_Source_CampaignID__c,
                                         BespokeSetupRequired__c,
                                         bespokeSetUpcomments__c,
                                         Account_Payment_Days__c,
                                         PaymentMethod__c,
                                         Payment_Currency__c,
                                         WES_Bank_Name__c,
                                         BankAccountName__c,
                                         BankIdentifier__c,
                                         BankAccountNumber__c,
                                         BankCountryCode__c,
                                         NameofSignature__c,
                                         DateofSignature__c,
                                         Pricing_Notes__c,
                                         FeeComments__c,
                                         Insurer__c,
                                         Policy_Name__c,
                                         Credit_Insurance_Comments__c,
                                         Overall_Credit_Limit__c,
                                         Credit_Authorised_Limit__c,
                                         Insured_Limit__c,
                                         Sign_Off_Limit__c,
                                         Security_Limit__c,
                                         Security_Type__c,
                                         Security_Date_Requested__c,
                                         Security_Date_Received__c,
                                         Security_Expiry_Date__c,
                                         RiskCategory__c,
                                         Periodic_Assessment__c,
                                         Credit_Decision_Comments__c,
                                         (SELECT Card_Type__c, NameOnCard__c, VRN_Driver__c, Additional_Embossed_Line__c, velocityControlProfile__c, TimeLimitCode__c, Toll_Usage__c, National_International__c, Truck_Fleet__c, Other_Networks__c, CardHolderType__c, Purchase_Option_Fuel__c, Purchase_Option_Products__c, Purchase_Option_Services__c, Invoice_Sort_Label__c, PIN__c, PIN_Type__c, POS_Prompt__c FROM WES_Fuel_Cards__r),
                                         (SELECT Card_Type__c, Toll_Usage__c, National_International__c, Truck_Fleet__c, Other_Networks__c, VelocityControlIFCSCode__c, TimeLimitCode__c, Card_Holder_Type__c, Purchase_Option_Fuel__c, Purchase_Option_Products__c, Purchase_Option_Services__c, POS_Prompt__c,  PIN__c, PIN_Type__c FROM WES_Fuel_Card_Defaults_Defaults__r)
                                         FROM
                                         WES_Application_Request__c
                                         WHERE
                                         Id IN :batchIds];

        for (WES_Application_Request__c req : reqList) {
            sendApplicationToIFCS(req);
        }

        // perform DML after callouts
        if (!reqList.isEmpty()) {
            update reqList;
        }
    }

    public static void sendApplicationToIFCS(WES_Application_Request__c req) {
        try {
            String application = 'SalesForce';

            WexRadiusCustomerOnboarding.CustomerDetailType customer = mapApplicationRequest(req);
            WexRadiusCustomerOnboarding.headerContextType headerContext = new WexRadiusCustomerOnboarding.headerContextType();
            headerContext.application = application;

            WexRadiusCustomerOnboarding.CreditInsuranceType creditInsurance = new WexRadiusCustomerOnboarding.CreditInsuranceType();
            creditInsurance.decision = req.CreditInsuranceDecisions__c;
            creditInsurance.decisionDate = req.CreditInsuranceDecisionDate__c;
            creditInsurance.insurer = req.Insurer__c;
            creditInsurance.policyName = req.Policy_Name__c;
            creditInsurance.comments = req.Credit_Insurance_Comments__c;

            WexRadiusCustomerOnboarding.CreditDecisionType creditDecision = new WexRadiusCustomerOnboarding.CreditDecisionType();
            creditDecision.overallCreditLimit = req.Overall_Credit_Limit__c;
            creditDecision.creditAuthorisedLimit = req.Credit_Authorised_Limit__c;
            creditDecision.insuredLimit = req.Insured_Limit__c;
            creditDecision.signOffLimit = req.Sign_Off_Limit__c;
            creditDecision.securityLimit = req.Security_Limit__c;
            creditDecision.securityType = req.Security_Type__c;
            creditDecision.securityDateRequested = req.Security_Date_Requested__c;
            creditDecision.securityDateReceived = req.Security_Date_Received__c;
            creditDecision.securityExpiryDate = req.Security_Expiry_Date__c;
            creditDecision.riskCategory = req.RiskCategory__c;
            creditDecision.periodicAssessment = String.valueOf(req.Periodic_Assessment__c);
            creditDecision.comments = req.Credit_Decision_Comments__c;

            WexRadiusCustomerOnboarding.CreditVettingDetailsType creditVettingDetails = new WexRadiusCustomerOnboarding.CreditVettingDetailsType();
            creditVettingDetails.creditInsurance = creditInsurance;
            creditVettingDetails.creditDecision = creditDecision;

            WexRadiusCustomerOnboarding.RadiusOnboardingSOAPQSPort stub = new WexRadiusCustomerOnboarding.RadiusOnboardingSOAPQSPort();
            stub.headerContext = headerContext;
            stub.endpoint_x = 'callout:Send_App_to_IFCS';

            String requestID = String.valueOf(req.requestID__c);

            /* -- the following is just for logging the request xml in a custom field */
            WexRadiusCustomerOnboarding.OnboardCustomerRequestType request_x = new WexRadiusCustomerOnboarding.OnboardCustomerRequestType();
            request_x.application = application;
            request_x.client = req.ifcs_clientId__c;
            request_x.requestedBy = requestID;
            request_x.requestID = requestID;
            request_x.requestedByBusinessNumber = req.requestedByBusinessNumber__c;
            request_x.customer = customer;
            request_x.creditVettingDetails = creditVettingDetails;
            req.IFCS_Request_Body__c = JSON.serialize(request_x).abbreviate(32000);
            /* -- */

            WexRadiusCustomerOnboarding.OnboardCustomerResponseType response = stub.onboardCustomer(application, req.ifcs_clientId__c, requestID, requestID, req.requestedByBusinessNumber__c, customer, creditVettingDetails);
            System.debug('Response status - ' + response.status);
            req.IFCS_Response__c = response.status;
        } catch(Exception e) {
            System.debug('Error - ' + e.getMessage());
            req.IFCS_Response__c = e.getMessage();
        }
    }

    private static WexRadiusCustomerOnboarding.CustomerDetailType mapApplicationRequest(WES_Application_Request__c req) {
        WexRadiusCustomerOnboarding.CustomerDetailType customer = new WexRadiusCustomerOnboarding.CustomerDetailType();
        customer.companyName = req.Company_Name__c;
        customer.embossingName = req.Default_Additional_Embossed_Line__c;
        customer.businessType = req.IFCS_Business_Entity_Code__c;
        customer.companyRegistration = req.Company_Reg_Num__c;
        customer.dunsNumber = req.DUNS_Number__c;

        WexRadiusCustomerOnboarding.ApplicationSummaryType applicationSummary = new WexRadiusCustomerOnboarding.ApplicationSummaryType();
        applicationSummary.agentId=req.Agent_User_ID__c;
        applicationSummary.enquirySource=req.EnquirySourceID__c;
        applicationSummary.sourceCampaign=req.Primary_Source_CampaignID__c;

        customer.applicationSummary = applicationSummary;

        WexRadiusCustomerOnboarding.VatDetailsType vatDetails = new WexRadiusCustomerOnboarding.VatDetailsType();
        vatDetails.registrationNumber=req.VAT_Reg_Num__c;
        vatDetails.countryCode=req.VATCountryCode__c;

        customer.vatDetails = new WexRadiusCustomerOnboarding.VatDetailsType[] { vatDetails };

        WexRadiusCustomerOnboarding.PrimaryContactDetailType primaryContactDetails = new WexRadiusCustomerOnboarding.PrimaryContactDetailType();
        primaryContactDetails.title=req.Primary_Contact__r.Salutation__c;
        primaryContactDetails.firstName=req.Primary_Contact__r.FirstName;
        primaryContactDetails.lastName=req.Primary_Contact__r.LastName;
        primaryContactDetails.phone=req.Primary_Contact__r.Phone;
        primaryContactDetails.fax=req.Primary_Contact__r.Fax;
        primaryContactDetails.mobile=req.Primary_Contact__r.MobilePhone;
        primaryContactDetails.email=req.Primary_Contact__r.Email;

        customer.PrimaryContactDetails = primaryContactDetails;

        WexRadiusCustomerOnboarding.SecondaryContactDetailType secondaryContactDetails = new WexRadiusCustomerOnboarding.SecondaryContactDetailType();
        secondaryContactDetails.title = req.Company_Owner__r.Salutation__c;
        secondaryContactDetails.firstName = req.Company_Owner__r.FirstName;
        secondaryContactDetails.lastName = req.Company_Owner__r.LastName;
        secondaryContactDetails.addressLine1 = req.Company_Owner__r.Home_Address_1__c;
        secondaryContactDetails.addressLine2 = req.Company_Owner__r.Home_Address_2__c;
        secondaryContactDetails.addressLine3 = req.Company_Owner__r.Home_Address_3__c;
        secondaryContactDetails.town = req.Company_Owner__r.Home_Address_City__c;
        secondaryContactDetails.postCode = req.Company_Owner__r.Home_Postcode__c;
        secondaryContactDetails.countryCode = req.Company_Owner__r.WES_Home_Country_Code__c;
        secondaryContactDetails.dob = String.valueOf(req.Company_Owner__r.Date_Of_Birth__c);
        secondaryContactDetails.phone = req.Company_Owner__r.Phone;
        secondaryContactDetails.mobile = req.Company_Owner__r.MobilePhone;
        secondaryContactDetails.email = req.Company_Owner__r.Email;

        customer.SecondaryContactDetails = new WexRadiusCustomerOnboarding.SecondaryContactDetailType[] {secondaryContactDetails};

        WexRadiusCustomerOnboarding.CompanyAddressType companyAdress = new WexRadiusCustomerOnboarding.CompanyAddressType();
        companyAdress.addressLine1=req.Account__r.Physical_Street_Address__c;
        companyAdress.addressLine2=req.Account__r.WES_Address_Line2__c;
        companyAdress.addressLine3=req.Account__r.WES_Address_Line3__c;
        companyAdress.town=req.Account__r.Physical_City__c;
        companyAdress.county=req.Account__r.Physical_State__c;
        companyAdress.postCode=req.Account__r.Physical_Zip_Postal_Code__c;
        companyAdress.countryCode=req.Account__r.WES_ISO_Country_Code__c;

        customer.companyAdress = companyAdress;

        WexRadiusCustomerOnboarding.InvoicePreferenceType invoicePreference = new WexRadiusCustomerOnboarding.InvoicePreferenceType();
        invoicePreference.invoiceFormat = req.Invoice_Format__c;
        invoicePreference.billingEmail = req.Account_Billing_Email__c;
        invoicePreference.invoiceFrequency = req.Account_Billing_Frequency__c;

        customer.invoicePreference = invoicePreference;

        List<WexRadiusCustomerOnboarding.CardOfferType> cardOffers = new List<WexRadiusCustomerOnboarding.CardOfferType>();
        for (WES_Fuel_Card_Default__c cardDefault : req.WES_Fuel_Card_Defaults_Defaults__r) {
            WexRadiusCustomerOnboarding.CardOfferType ctype = new WexRadiusCustomerOnboarding.CardOfferType();
            ctype.cardOffer = cardDefault.Card_Type__c;
            if (cardDefault.Card_Type__c == 'Esso') {
                ctype.tollUsage = cardDefault.Toll_Usage__c;
                ctype.isInternational = cardDefault.National_International__c;
                ctype.isFleet = cardDefault.Truck_Fleet__c;
                ctype.isReciprocity = cardDefault.Other_Networks__c;
            }
            ctype.velocityProfile = cardDefault.VelocityControlIFCSCode__c;
            ctype.timeLimitCode = cardDefault.TimeLimitCode__c;
            ctype.cardType = cardDefault.Card_Holder_Type__c;
            ctype.fuelType = cardDefault.Purchase_Option_Fuel__c;
            ctype.product = new String[] {cardDefault.Purchase_Option_Products__c};
            ctype.service = new String[] {cardDefault.Purchase_Option_Services__c};
            ctype.inputOption = cardDefault.POS_Prompt__c;
            ctype.PIN = cardDefault.PIN__c;
            ctype.pinType = cardDefault.PIN_Type__c;
            cardOffers.add(ctype);
        }
        WexRadiusCustomerOnboarding.CardOffersType OffersType = new WexRadiusCustomerOnboarding.CardOffersType();
        OffersType.cardOffer = cardOffers;

        customer.cardOffers = OffersType;

        List<WexRadiusCustomerOnboarding.CardGroupType> cardGroups = new List<WexRadiusCustomerOnboarding.CardGroupType>();
        for (WES_Fuel_Card__c card : req.WES_Fuel_Cards__r) {
            WexRadiusCustomerOnboarding.CardGroupType gtype = new WexRadiusCustomerOnboarding.CardGroupType();
            gtype.cardGroupName = card.NameOnCard__c;

            WexRadiusCustomerOnboarding.FuelCardDetailType fuelCardDetailType = new WexRadiusCustomerOnboarding.FuelCardDetailType();
            fuelCardDetailType.driverName = card.VRN_Driver__c;
            fuelCardDetailType.vehicleReg = card.VRN_Driver__c;
            fuelCardDetailType.additionalEmbossedLine = card.Additional_Embossed_Line__c;
            fuelCardDetailType.velocityProfile = card.velocityControlProfile__c;
            fuelCardDetailType.timeLimitCode = card.TimeLimitCode__c;
            fuelCardDetailType.cardOffer = card.Card_Type__c;
            if (card.Card_Type__c == 'Esso') {
                fuelCardDetailType.tollUsage = card.Toll_Usage__c;
                fuelCardDetailType.isInternational = card.National_International__c;
                fuelCardDetailType.isFleet = card.Truck_Fleet__c;
                fuelCardDetailType.isReciprocity = card.Other_Networks__c;
            }
            fuelCardDetailType.cardType = card.CardHolderType__c;
            fuelCardDetailType.fuelType = new String[] {card.Purchase_Option_Fuel__c};
            fuelCardDetailType.product = new String[] {card.Purchase_Option_Products__c};
            fuelCardDetailType.service = new String[] {card.Purchase_Option_Services__c};
            fuelCardDetailType.invoiceSortLabel = card.Invoice_Sort_Label__c;
            fuelCardDetailType.PIN = card.PIN__c;
            fuelCardDetailType.pinType = card.PIN_Type__c;
            fuelCardDetailType.inputOption = card.POS_Prompt__c;

            gtype.fuelCardDetail = new WexRadiusCustomerOnboarding.FuelCardDetailType[] {fuelCardDetailType};
            cardGroups.add(gtype);
        }
        WexRadiusCustomerOnboarding.CardGroupsType groupsType = new WexRadiusCustomerOnboarding.CardGroupsType();
        groupsType.cardGroup = cardGroups;

        customer.cardGroups = groupsType;

        customer.languageCode = req.language_isoCode__c;
        customer.applicationType = req.applicationTypeId__c;
        customer.obuDeviceRequired = Boolean.valueOf(req.OBU_Device_Required__c);
        customer.vatReclaimRequired = Boolean.valueOf(req.VAT_Reclaim__c);
        customer.vasComments = req.VAS_Comments__c;
        customer.isFeeOverride = req.IsFeeOverride__c;
        customer.feeOverrideComments = req.FeeOverrideComments__c;
        customer.createVelocityAccount = req.CreateVelocityAccount__c;
        customer.velocityAccountEmail = req.VelocityAccountEmail__c;
        customer.customerType = req.Dunning_Classification__c;
        customer.industryType = req.Account__r.WES_BusinessCategory__c;
        customer.bespokeSetupRequired = req.BespokeSetupRequired__c;
        customer.bespokeSetUpcomments = req.bespokeSetUpcomments__c;
        customer.pricingOverrideComments = req.Pricing_Notes__c;
        customer.feeComments = req.FeeComments__c;

        WexRadiusCustomerOnboarding.PaymentDetailsType paymentDetails = new WexRadiusCustomerOnboarding.PaymentDetailsType();
        paymentDetails.paymentTerms = req.Account_Payment_Days__c;
        paymentDetails.paymentMethod = req.PaymentMethod__c;
        paymentDetails.paymentCurrency = req.Payment_Currency__c;
        paymentDetails.bankName = req.WES_Bank_Name__c;
        paymentDetails.bankAccountName = req.BankAccountName__c;
        paymentDetails.bankIdentifier = req.BankIdentifier__c;
        paymentDetails.bankAccountNumber = req.BankAccountNumber__c;
        paymentDetails.bankCountryCode = req.BankCountryCode__c;
        paymentDetails.nameofSignature = req.NameofSignature__c;
        paymentDetails.dateofSignture = req.DateofSignature__c;
        paymentDetails.paperlessDDI = req.paperlessDDI__c;
        paymentDetails.typeonMandate = req.TypeonMandate__c;

        customer.paymentDetails = paymentDetails;

        return customer;
    }
}