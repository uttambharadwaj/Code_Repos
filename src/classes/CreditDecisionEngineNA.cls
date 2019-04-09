/*
*
* Credit Decisioning Process
* Module: Main Runner
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/
global class CreditDecisionEngineNA {

    public static Boolean decisionEngineRunning = false;

    @future(callout=true)
    public static void runNADecisioningProcessFuture(Id naApplicationId) {
        runNADecisioningProcess(naApplicationId);
    }

    // If called from a button
    webservice static void runNADecisioningProcessButton(Id naApplicationId) {
        runNADecisioningProcess(naApplicationId);
    }

    public static void runNADecisioningProcess(Id naApplicationId) {

        decisionEngineRunning = true;

        List<Application_Request__c> naApplications = [
                SELECT Id, ABA_Routing_Number__c, Application_Signer_FirstName_Text__c, Application_Stage__c, App_Signer_IP_Address__c, App_Signer_Last_Name_Text__c,
                        Billing_City__c, Billing_Contact_First_Name_Text__c, Billing_Contact_Last_Name_Text__c, Billing_Contact__r.Email, Billing_Contact__r.Phone,
                        Billing_State__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Business_Phone_Number__c, Checking_Account_Number__c, CreatedBy.Alias,
                        Doing_Business_As__c, DUNS_Number__c, Forte_Response_Code__c, Legal_Structure__c, Name, Opportunity_Name_Text__c, Opportunity__r.SourceSystem__c,
                        Personal_Guarantor_DOB__c, Personal_Guarantor_First_Name__c, Personal_Guarantor_Home_Phone__c, Personal_Guarantor_Last_Name__c, Personal_Guarantor_Email__c,
                        Personal_Guarantor_Mailing_City__c, Personal_Guarantor_Mailing_Country__c, Personal_Guarantor_Mailing_State__c, Personal_Guarantor_Mailing_Street__c,
                        Personal_Guarantor_Mailing_Zip__c, Personal_Guarantor_SSN__c, PG_Required__c, Physical_City__c, Physical_State__c, Physical_Street__c, Requested_Credit_Limit__c,
                        Physical_Zip_Postal_Code__c, Program__c, Running_Credit_Decisioning__c, Sanctions_Business_Check__c, Sanctions_Business_Result_ID__c,
                        Sanctions_Individual_Check__c, Sanctions_Individual_Result_ID__c, Tax_Payer_ID_number__c, ThreatMetrix_Session_ID__c, ThreatMetrix_Request_ID__c, ThreatMetrix_Result__c,
                        Physical_Country__c, Fraud_Flag__c, DNB_Match_Score__c, DNB_Credit_Line_Recommendation__c, DNB_Confidence_Code__c
                FROM Application_Request__c
                WHERE Id = :naApplicationId
        ];

        if (naApplications.size() > 0) {

            Application_Request__c naApplication = naApplications[0];

            if(!Test.isRunningTest()) {
                naApplication.Running_Credit_Decisioning__c = true;
            }

            // ThreatMetrix
            if ((naApplication.Opportunity__r.SourceSystem__c).equalsIgnoreCase('BOCA')) {

                // If the application hasn't yet been integrated
                if(naApplication.ThreatMetrix_Request_ID__c == null) {

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest threatMetrixSessionQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest();

                    threatMetrixSessionQueryRequest.sessionId = naApplication.ThreatMetrix_Session_ID__c;
                    threatMetrixSessionQueryRequest.transactionId = naApplication.Id;
                    threatMetrixSessionQueryRequest.accountName = naApplication.Opportunity_Name_Text__c;
                    threatMetrixSessionQueryRequest.dbaName = naApplication.Doing_Business_As__c;
                    threatMetrixSessionQueryRequest.federalTaxId = naApplication.Tax_Payer_ID_number__c;

                    threatMetrixSessionQueryRequest.physicalAddressLine1 = naApplication.Physical_Street__c;
                    threatMetrixSessionQueryRequest.physicalCity = naApplication.Physical_City__c;
                    threatMetrixSessionQueryRequest.physicalState = naApplication.Physical_State__c;
                    threatMetrixSessionQueryRequest.physicalPostalCode = naApplication.Physical_Zip_Postal_Code__c;

                    threatMetrixSessionQueryRequest.mailingAddressLine1 = naApplication.Billing_Street__c;
                    threatMetrixSessionQueryRequest.mailingCity = naApplication.Billing_City__c;
                    threatMetrixSessionQueryRequest.mailingState = naApplication.Billing_State__c;
                    threatMetrixSessionQueryRequest.mailingPostalCode = naApplication.Billing_Zip_Postal_Code__c;

                    threatMetrixSessionQueryRequest.guarantorName = naApplication.Billing_Contact_First_Name_Text__c + ' ' + naApplication.Billing_Contact_Last_Name_Text__c;
                    threatMetrixSessionQueryRequest.guarantorEmail = naApplication.Personal_Guarantor_Email__c;

                    threatMetrixSessionQueryRequest.emailAddress = naApplication.Billing_Contact__r.Email;
                    threatMetrixSessionQueryRequest.phoneNumber = naApplication.Billing_Contact__r.Phone;

                    threatMetrixSessionQueryRequest.ipAddress = naApplication.App_Signer_IP_Address__c;

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryResponse threatMetrixSessionQueryResponse = CreditWS_ThreatMetrix.integrateCreditApp(threatMetrixSessionQueryRequest);

                    if (threatMetrixSessionQueryResponse != null) {
                        naApplication.ThreatMetrix_Request_ID__c = threatMetrixSessionQueryResponse.threatMetrixRequestId;
                        naApplication.ThreatMetrix_Result__c = (threatMetrixSessionQueryResponse.threatMetrixReviewStatus).capitalize();
                    }

                }
                else {

                    // Query an already integrated application
                    CreditWS_ThreatMetrix.ThreatMetrixQueryRequest threatMetrixQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixQueryRequest();
                    threatMetrixQueryRequest.threatMetrixRequestId = naApplication.ThreatMetrix_Request_ID__c;
                    CreditWS_ThreatMetrix.ThreatMetrixQueryResponse threatMetrixQueryResponse = CreditWS_ThreatMetrix.getThreatMetrixScore(threatMetrixQueryRequest);

                    naApplication.ThreatMetrix_Result__c = (threatMetrixQueryResponse.reviewStatus).capitalize();

                }

            } else {
                naApplication.ThreatMetrix_Result__c = 'Pass';
            }

            if (naApplication.Personal_Guarantor_SSN__c != null) {

                // LexisNexis Check
                CreditWS_LexisNexis.InstantIDRequest lexisNexisRequest = new CreditWS_LexisNexis.InstantIDRequest();

                lexisNexisRequest.firstName = naApplication.Personal_Guarantor_First_Name__c;
                lexisNexisRequest.lastName = naApplication.Personal_Guarantor_Last_Name__c;
                lexisNexisRequest.addressLine1 = naApplication.Personal_Guarantor_Mailing_Street__c;
                lexisNexisRequest.city = naApplication.Personal_Guarantor_Mailing_City__c;
                lexisNexisRequest.state = naApplication.Personal_Guarantor_Mailing_State__c;
                lexisNexisRequest.postalCode = naApplication.Personal_Guarantor_Mailing_Zip__c;
                lexisNexisRequest.dateOfBirth = naApplication.Personal_Guarantor_DOB__c;
                lexisNexisRequest.socialSecurityNumber = naApplication.Personal_Guarantor_SSN__c;

                CreditWS_LexisNexis.InstantIDResponse lexisNexisResponse = CreditWS_LexisNexis.lexisNexisInstantIDVerification(lexisNexisRequest);

                if (lexisNexisResponse.individualVerified) {

                    naApplication.Social_Security_Check__c = 'Passed';

                } else if (lexisNexisResponse.calloutFailed) {

                    naApplication.Social_Security_Check__c = 'Error';

                } else {

                    naApplication.Social_Security_Check__c = 'Failed';

                }

                // Lexis Nexis Bridger Check - Individual
                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest lexisNexisBridgerIndividualRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest();

                lexisNexisBridgerIndividualRequest.firstName = naApplication.Personal_Guarantor_First_Name__c;
                lexisNexisBridgerIndividualRequest.lastName = naApplication.Personal_Guarantor_Last_Name__c;
                lexisNexisBridgerIndividualRequest.addressLine1 = naApplication.Personal_Guarantor_Mailing_Street__c;
                lexisNexisBridgerIndividualRequest.city = naApplication.Personal_Guarantor_Mailing_City__c;
                lexisNexisBridgerIndividualRequest.state = naApplication.Personal_Guarantor_Mailing_State__c;
                lexisNexisBridgerIndividualRequest.postalCode = naApplication.Personal_Guarantor_Mailing_Zip__c;
                lexisNexisBridgerIndividualRequest.dateOfBirth = naApplication.Personal_Guarantor_DOB__c;
                lexisNexisBridgerIndividualRequest.socialSecurityNumber = naApplication.Personal_Guarantor_SSN__c;
                lexisNexisBridgerIndividualRequest.phoneNumber = naApplication.Personal_Guarantor_Home_Phone__c;

                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualResponse lexisNexisBridgerIndividualResponse = CreditWS_LexisNexisBridger.bridgerSearchIndividual(lexisNexisBridgerIndividualRequest);

                if (lexisNexisBridgerIndividualResponse.calloutFailed) {

                    naApplication.Sanctions_Individual_Check__c = 'Error';

                } else if (lexisNexisBridgerIndividualResponse.individualPassed == true) {

                    naApplication.Sanctions_Individual_Check__c = 'Passed';

                } else {

                    naApplication.Sanctions_Individual_Check__c = 'Failed';
                    naApplication.Sanctions_Individual_Result_ID__c = lexisNexisBridgerIndividualResponse.sanctionsResultId;

                }

            } else {
                // If we don't have a PG - then we can't resolve this person
                naApplication.Social_Security_Check__c = 'Passed';
                naApplication.Sanctions_Individual_Check__c = 'Passed';
            }

            // Lexis Nexis Bridger Check - Business
            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest lexisNexisBridgerBusinessRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest();

            lexisNexisBridgerBusinessRequest.companyName = naApplication.Opportunity_Name_Text__c;
            lexisNexisBridgerBusinessRequest.addressLine1 = naApplication.Physical_Street__c;
            lexisNexisBridgerBusinessRequest.city = naApplication.Physical_City__c;
            lexisNexisBridgerBusinessRequest.state = naApplication.Physical_State__c;
            lexisNexisBridgerBusinessRequest.postalCode = naApplication.Physical_Zip_Postal_Code__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessResponse lexisNexisBridgerBusinessResponse = CreditWS_LexisNexisBridger.bridgerSearchBusiness(lexisNexisBridgerBusinessRequest);

            if (lexisNexisBridgerBusinessResponse.calloutFailed) {

                naApplication.Sanctions_Business_Check__c = 'Error';

            } else if (lexisNexisBridgerBusinessResponse.businessPassed == true) {

                naApplication.Sanctions_Business_Check__c = 'Passed';

            } else {

                naApplication.Sanctions_Business_Check__c = 'Failed';
                naApplication.Sanctions_Business_Result_ID__c = lexisNexisBridgerBusinessResponse.sanctionsResultId;

            }

            // DNB Resolution
            CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

            dnbDirectMatchRequest.SingleResolution = true;
            dnbDirectMatchRequest.SubjectName = naApplication.Opportunity_Name_Text__c;
            dnbDirectMatchRequest.StreetAddressLine1 = naApplication.Physical_Street__c;
            dnbDirectMatchRequest.PrimaryTownName = naApplication.Physical_City__c;
            dnbDirectMatchRequest.TerritoryName = naApplication.Physical_State__c;
            dnbDirectMatchRequest.FullPostalCode = naApplication.Physical_Zip_Postal_Code__c;
            dnbDirectMatchRequest.CountryISOAlpha2Code = naApplication.Physical_Country__c;
            dnbDirectMatchRequest.DUNSNumber = naApplication.DUNS_Number__c;
            dnbDirectMatchRequest.TradeStyleName = naApplication.Doing_Business_As__c;
            dnbDirectMatchRequest.TelephoneNumber = naApplication.Business_Phone_Number__c;

            CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates.size() == 1 && dnbDirectMatchResponse.matchCandidates[0].OperatingStatus != null && (dnbDirectMatchResponse.matchCandidates[0].OperatingStatus).equalsIgnoreCase('Active')) {

                naApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                naApplication.DNB_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchGradeString;
                naApplication.DNB_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchDataProfile;
                naApplication.DNB_Street_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNameMatchDataProfile;
                naApplication.DNB_Street_Number_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNumberMatchDataProfile;
                naApplication.DNB_City_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].CityMatchDataProfile;
                naApplication.DNB_State_Match_Data_Profile__c  = dnbDirectMatchResponse.matchCandidates[0].StateMatchDataProfile;
                naApplication.DNB_Postal_Code_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].PostalCodeMatchDataProfile;
                naApplication.DNB_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].MatchGradeText;
                if (dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue != null) {
                    naApplication.DNB_Confidence_Code__c = String.valueOf(dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue);
                }

                // Execute BREeze for pre-processing
                BREeze.ProcessRules.ruleDataSet breezeResults = BREeze.ProcessRules.processRuleLogic('NACreditDecisioningDNBMatch', new List<SObject>{naApplication});

                if(breezeResults.records != null && breezeResults.records[0].get('DNB_Resolution_Check__c') != null && (breezeResults.records[0].get('DNB_Resolution_Check__c').toString()).equalsIgnoreCase('Passed')) {

                    naApplication.DUNS_Number__c = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;

                    if (naApplication.Physical_Country__c == null || (naApplication.Physical_Country__c).equalsIgnoreCase('US')) {

                        CreditWS_DNB.DNBNAFleetModelRequest dnbNAFleetModelRequest = new CreditWS_DNB.DNBNAFleetModelRequest();

                        dnbNAFleetModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbNAFleetModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(naApplication.Requested_Credit_Limit__c));

                        CreditWS_DNB.DNBNAFleetModelResponse dnbNAFleetModelResponse = CreditWS_DNB.getNAFleetScore(dnbNAFleetModelRequest);

                        if (dnbNAFleetModelResponse != null) {

                            naApplication.DNB_Score__c = dnbNAFleetModelResponse.RawScore;
                            naApplication.DNB_Credit_Line_Recommendation__c = dnbNAFleetModelResponse.RecommendedCreditLimitAmount;
                            naApplication.DNB_Model__c = dnbNAFleetModelResponse.ModelUsed;
                            naApplication.SIC_Code__c = dnbNAFleetModelResponse.PrimarySIC;
                            naApplication.DNB_Resolved_DUNS__c = dnbNAFleetModelResponse.DunsNumber;
                            naApplication.DUNS_Number__c = dnbNAFleetModelResponse.DunsNumber;
                            naApplication.Global_Ultimate_DUNS__c = dnbNAFleetModelResponse.GlobalUltimateDUNS;
                            naApplication.DNB_Resolved_Name__c = dnbNAFleetModelResponse.PrimaryName;
                            naApplication.DNB_Resolved_Address__c = dnbNAFleetModelResponse.AddressLine;
                            naApplication.DNB_Resolved_City__c = dnbNAFleetModelResponse.PostalTown;
                            naApplication.DNB_Resolved_State__c = dnbNAFleetModelResponse.PrimaryGeographicArea;
                            naApplication.DNB_Resolved_Postal_Code__c = dnbNAFleetModelResponse.PostalCode;
                            naApplication.DNB_Resolved_Country__c = dnbNAFleetModelResponse.CountryCode;
                            naApplication.DNB_SBFE_High_Credit__c = dnbNAFleetModelResponse.SBFEHighCredit;
                            naApplication.DNB_CSAD_High_Credit__c = dnbNAFleetModelResponse.CSADHighCredit;
                            naApplication.DNB_SBRI_Card_Score__c = dnbNAFleetModelResponse.SBRICardScore;
                            naApplication.Bankruptcy_Date__c = dnbNAFleetModelResponse.BankruptcyDateOfFiling;
                            naApplication.Bureau_Tax_ID__c = dnbNAFleetModelResponse.FeinTaxID;
                            naApplication.Paydex__c = dnbNAFleetModelResponse.Paydex;
                            naApplication.Control_Year__c = String.valueOf(dnbNAFleetModelResponse.ControlYear);
                            naApplication.Year_Started__c = String.valueOf(dnbNAFleetModelResponse.YearStarted);
                            naApplication.Number_of_Payments_Negative__c = dnbNAFleetModelResponse.NumberPaymentExperiencesNegative;
                            naApplication.Number_of_Payments_Slow__c = dnbNAFleetModelResponse.NumberPaymentExperiencesSlow;
                            naApplication.Satisfactory_Trades__c = dnbNAFleetModelResponse.NumberPaymentExperiencesSatisfactory;
                            naApplication.DNB_Trade_Lines__c = dnbNAFleetModelResponse.NumberOfTrades;
                            naApplication.DNB_Reason_Code__c = String.join(dnbNAFleetModelResponse.ReasonCodes, ', ');

                        }
                        else {
                            naApplication.DNB_Score__c = 0;
                        }

                    } else if (naApplication.Physical_Country__c != null && (naApplication.Physical_Country__c).equalsIgnoreCase('CA')) {

                        CreditWS_DNB.DNBCAModelRequest dnbCAModelRequest = new CreditWS_DNB.DNBCAModelRequest();

                        dnbCAModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbCAModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(naApplication.Requested_Credit_Limit__c));
                        dnbCAModelRequest.Platforms = 'FLEET';
                        dnbCAModelRequest.BOCAType = 1;

                        CreditWS_DNB.DNBCAModelResponse dnbCAModelResponse = CreditWS_DNB.getCAScore(dnbCAModelRequest);

                        if (dnbCAModelResponse != null) {

                            naApplication.DNB_Score__c = dnbCAModelResponse.RawScore;
                            naApplication.DNB_Credit_Line_Recommendation__c = dnbCAModelResponse.RecommendedCreditLimitAmount;
                            naApplication.SIC_Code__c = dnbCAModelResponse.PrimarySIC;
                            naApplication.DNB_Resolved_DUNS__c = dnbCAModelResponse.DunsNumber;
                            naApplication.DUNS_Number__c = dnbCAModelResponse.DunsNumber;
                            naApplication.Global_Ultimate_DUNS__c = dnbCAModelResponse.GlobalUltimateDUNS;
                            naApplication.DNB_Resolved_Name__c = dnbCAModelResponse.PrimaryName;
                            naApplication.DNB_Resolved_Address__c = dnbCAModelResponse.AddressLine;
                            naApplication.DNB_Resolved_City__c = dnbCAModelResponse.PostalTown;
                            naApplication.DNB_Resolved_State__c = dnbCAModelResponse.PrimaryGeographicArea;
                            naApplication.DNB_Resolved_Postal_Code__c = dnbCAModelResponse.PostalCode;
                            naApplication.DNB_Resolved_Country__c = dnbCAModelResponse.CountryCode;
                            naApplication.DNB_SBFE_High_Credit__c = dnbCAModelResponse.SBFEHighCredit;
                            naApplication.DNB_CSAD_High_Credit__c = dnbCAModelResponse.CSADHighCredit;
                            naApplication.DNB_SBRI_Card_Score__c = dnbCAModelResponse.SBRICardScore;
                            naApplication.Bureau_Tax_ID__c = dnbCAModelResponse.FeinTaxID;
                            naApplication.Paydex__c = dnbCAModelResponse.Paydex;
                            naApplication.Control_Year__c = String.valueOf(dnbCAModelResponse.ControlYear);
                            naApplication.Year_Started__c = String.valueOf(dnbCAModelResponse.YearStarted);
                            naApplication.Number_of_Payments_Negative__c = dnbCAModelResponse.NumberPaymentExperiencesNegative;
                            naApplication.Number_of_Payments_Slow__c = dnbCAModelResponse.NumberPaymentExperiencesSlow;
                            naApplication.Satisfactory_Trades__c = dnbCAModelResponse.NumberPaymentExperiencesSatisfactory;
                            naApplication.DNB_Trade_Lines__c = dnbCAModelResponse.NumberOfTrades;
                            naApplication.DNB_Reason_Code__c = String.join(dnbCAModelResponse.ReasonCodes, ', ');

                        }
                        else {
                            naApplication.DNB_Score__c = 0;
                        }

                    }

                }

            } else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                dnbDirectMatchRequest.SingleResolution = false;
                dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if(dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {
                    naApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                }

            } else {
                naApplication.DNB_Lookup_Hits__c = 0;
            }

            // Trust but verify 
            if ((null != naApplication.Tax_Payer_ID_number__c && null != naApplication.Bureau_Tax_ID__c) && naApplication.Tax_Payer_ID_number__c.equals(naApplication.Bureau_Tax_ID__c)) {
                naApplication.DNB_Match_Score__c = 100;
            } else {
                naApplication.DNB_Match_Score__c = JaroWinklerDistance.getScore((naApplication.Opportunity_Name_Text__c).replaceAll('[^0-9A-Za-z]',''), (dnbDirectMatchRequest.SubjectName).replaceAll('[^0-9A-Za-z]',''));
                System.debug('Match Score: ' + naApplication.DNB_Match_Score__c);
            }

//            CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();
//
//            giactVerifyRequest.RoutingNumber = naApplication.ABA_Routing_Number__c;
//            giactVerifyRequest.AccountNumber = naApplication.Checking_Account_Number__c;
//            giactVerifyRequest.FirstName = naApplication.Billing_Contact_First_Name_Text__c;
//            giactVerifyRequest.LastName = naApplication.Billing_Contact_Last_Name_Text__c;
//            giactVerifyRequest.BusinessName = naApplication.Opportunity_Name_Text__c;
//            giactVerifyRequest.AddressLine1 = naApplication.Physical_Street__c;
//            giactVerifyRequest.AddressLine2 = naApplication.Physical_Street_Line_2__c;
//            giactVerifyRequest.City = naApplication.Physical_City__c;
//            giactVerifyRequest.State = naApplication.Physical_State__c;
//            giactVerifyRequest.ZipCode = naApplication.Physical_Zip_Postal_Code__c;
//            giactVerifyRequest.Country = naApplication.Physical_Country__c;
//            giactVerifyRequest.PhoneNumber = naApplication.Business_Phone_Number__c;
//            giactVerifyRequest.FederalTaxId = naApplication.Tax_Payer_ID_number__c;
//            giactVerifyRequest.EmailAddress = naApplication.Billing_Contact_Email__c;
//            giactVerifyRequest.IpAddress = naApplication.App_Signer_IP_Address__c;
//
//            if (!TestUtils.isRunningTest()) {
//
//                CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
//
//                if(giactVerifyResponse != null) {
//
//                    naApplication.GIACT_Account_Response_Code__c = giactVerifyResponse.AccountResponseCode;
//                    naApplication.GIACT_Account_Response_Message__c = giactVerifyResponse.AccountResponseMessage;
//                    naApplication.GIACT_Response_Code__c = giactVerifyResponse.VerificationResponseCode;
//                    naApplication.GIACT_Response_Message__c = giactVerifyResponse.VerificationResponseMessage;
//
//                }
//                else {
//
//                    naApplication.GIACT_Check__c = 'Error';
//                    naApplication.GIACT_Response_Message__c = giactVerifyResponse.GiactErrorMessage;
//
//                }
//
//            }

            // Existing Exposure - Application/Account Exposure
            CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();
            existingExposureRequest.applicationId = naApplication.Id;
            existingExposureRequest.applicationName = naApplication.Name;
            existingExposureRequest.legalBusinessName = naApplication.Opportunity_Name_Text__c;
            existingExposureRequest.addressLine1 = naApplication.Physical_Street__c;
            existingExposureRequest.city = naApplication.Physical_City__c;
            existingExposureRequest.state = naApplication.Physical_State__c;
            existingExposureRequest.postalCode = naApplication.Physical_Zip_Postal_Code__c;
            existingExposureRequest.fraudFlag = naApplication.Fraud_Flag__c;

            List<CreditUtil_ExistingExposure.ExistingExposureApplications> existingExposureApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);
            List<CreditUtil_ExistingExposure.ExistingExposureAccounts> existingExposureAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);

            for (CreditUtil_ExistingExposure.ExistingExposureApplications existingExposureApplication : existingExposureApplications) {
                if (existingExposureApplication.fraudFlag) {
                    naApplication.Previous_Fraud__c = true;
                }
            }

            // Upsert and execute BREeze
            upsert naApplication;
            naApplication.Number_of_Existing_Applications__c = existingExposureApplications.size();
            naApplication.Number_of_Existing_Accounts__c = existingExposureAccounts.size();

            // Make a safe copy so we don't overwrite any fields
            naApplications = [SELECT Id, Running_Credit_Decisioning__c FROM Application_Request__c WHERE Id = :naApplicationId];

            if (naApplications.size() > 0) {

                // Flag the Credit Decision Engine as not running
                naApplications[0].Running_Credit_Decisioning__c = false;

                upsert naApplications;
            }


            // Run counter-offer processes
            naApplications = [SELECT Id, PG_Required__c, Personal_Guarantor__c, Personal_Guarantor_Mailing_Country__c, Opportunity__r.Pull_PG_Credit__c FROM Application_Request__c WHERE Id = :naApplicationId];

            if (naApplications.size() > 0) {

                Application_Request__c appRequest = naApplications[0];

                if (appRequest.PG_Required__c == true
                        && appRequest.Personal_Guarantor__c != null
                        && (appRequest.Opportunity__r.Pull_PG_Credit__c == null || appRequest.Opportunity__r.Pull_PG_Credit__c.equalsIgnoreCase('Yes'))
                        && !TestUtils.isRunningTest()) {

                    if(appRequest.Personal_Guarantor_Mailing_Country__c == null || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('US') || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('United States')) {
                        CreditDecisionEngineQueueable.runExperianPGChecks(naApplications[0].Id);
                    }
                    else if (appRequest.Personal_Guarantor_Mailing_Country__c != null && (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('CA') || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('Canada')) {
                        CreditDecisionEngineQueueable.runEquifaxPGChecks(appRequest.Id);
                    }
                }

            }

        }

    }

}