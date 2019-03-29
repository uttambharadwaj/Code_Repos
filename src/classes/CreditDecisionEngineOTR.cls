/*
*
* Credit Decisioning Process
* Module: Main Runner
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/
global class CreditDecisionEngineOTR {

    public static Boolean decisionEngineRunning = false;

    // If called from a button
    webservice static void runOTRDecisioningProcessButton(Id onlineApplicationId) {
        runOTRDecisioningProcess(onlineApplicationId);
    }

    @future(callout=true)
    public static void runOTRDecisioningProcessFuture(Id onlineApplicationId) {
        runOTRDecisioningProcess(onlineApplicationId);
    }

    public static void runOTRDecisioningProcess(Id onlineApplicationId) {

        decisionEngineRunning = true;

        List<OnlineApplication__c> onlineApplications = [
                SELECT Id, Name, Legal_Business_Name__c, Forte_Response_Code__c, Application_Stage__c, ThreatMetrix_Request_ID__c, ThreatMetrix_Session_ID__c,
                        ThreatMetrix_Result__c, Sanctions_Business_Check__c, Sanctions_Individual_Check__c, ABA_Routing_Number__c, Checking_Account_Number__c, Country__c,
                        Business_Street_Address__c, City__c, State__c, Zip_code__c, Sanctions_Individual_Result_ID__c, Contact_First_Name__c, Contact_Last_Name__c,
                        AO_Name__c, AO_Work_Email__c, AO_Address__c, AO_City__c, Contact_Name__c, AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c, Running_Credit_Decisioning__c,
                        DUNS__c, PG_Required__c, Type_of_Business__c, AO_Home_Phone_Number__c, Program__c, CreatedBy.Alias, Fraud_Flag__c, Previous_Fraud__c, Opportunity__c,
                        Opportunity__r.SourceSystem__c, Account__r.Name, Trade_Name__c, Federal_Tax_ID__c, Card_Shipping_Address_Line_1__c, Card_Shipping_City__c, Card_Shipping_State__c,
                        Card_Shipping_Postal_Code__c, Email__c, Phone_Number__c, IP_Address__c, Credit_Line_Requested__c, Application_Signer_IP__c, DNB_Credit_Line_Recommendation__c,
                        DNB_Reason_Code__c,Team_Drivers_Slip_Seat__c, Number_of_Trucks__c, DNB_Confidence_Code__c, DNB_Resolution_Check__c, DOT_Number__c
                FROM OnlineApplication__c
                WHERE Id = :onlineApplicationId
        ];

        if (onlineApplications.size() > 0) {

            OnlineApplication__c onlineApplication = onlineApplications[0];

            onlineApplication.Running_Credit_Decisioning__c = true;

            // ThreatMetrix
            if (null != onlineApplication.Opportunity__c && null != onlineApplication.Opportunity__r.SourceSystem__c && (onlineApplication.Opportunity__r.SourceSystem__c).equalsIgnoreCase('BOCA')) {

                // If the application hasn't yet been integrated
                if (onlineApplication.ThreatMetrix_Request_ID__c == null) {

                    System.debug('Running ThreatMetrix...');

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest threatMetrixSessionQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest();

                    threatMetrixSessionQueryRequest.sessionId = onlineApplication.ThreatMetrix_Session_ID__c;
                    threatMetrixSessionQueryRequest.transactionId = onlineApplication.Id;
                    threatMetrixSessionQueryRequest.accountName = onlineApplication.Account__r.Name;
                    threatMetrixSessionQueryRequest.dbaName = onlineApplication.Trade_Name__c;
                    threatMetrixSessionQueryRequest.federalTaxId = onlineApplication.Federal_Tax_ID__c;

                    threatMetrixSessionQueryRequest.physicalAddressLine1 = onlineApplication.Business_Street_Address__c;
                    threatMetrixSessionQueryRequest.physicalCity = onlineApplication.City__c;
                    threatMetrixSessionQueryRequest.physicalState = onlineApplication.State__c;
                    threatMetrixSessionQueryRequest.physicalPostalCode = onlineApplication.Zip_Code__c;

                    threatMetrixSessionQueryRequest.mailingAddressLine1 = onlineApplication.Card_Shipping_Address_Line_1__c;
                    threatMetrixSessionQueryRequest.mailingCity = onlineApplication.Card_Shipping_City__c;
                    threatMetrixSessionQueryRequest.mailingState = onlineApplication.Card_Shipping_State__c;
                    threatMetrixSessionQueryRequest.mailingPostalCode = onlineApplication.Card_Shipping_Postal_Code__c;

                    threatMetrixSessionQueryRequest.guarantorName = onlineApplication.AO_Name__c;
                    threatMetrixSessionQueryRequest.guarantorEmail = onlineApplication.AO_Work_Email__c;

                    threatMetrixSessionQueryRequest.emailAddress = onlineApplication.Email__c;
                    threatMetrixSessionQueryRequest.phoneNumber = onlineApplication.Phone_Number__c;

                    threatMetrixSessionQueryRequest.ipAddress = onlineApplication.Application_Signer_IP__c;

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryResponse threatMetrixSessionQueryResponse = CreditWS_ThreatMetrix.integrateCreditApp(threatMetrixSessionQueryRequest);

                    if (threatMetrixSessionQueryResponse != null) {
                        onlineApplication.ThreatMetrix_Request_ID__c = threatMetrixSessionQueryResponse.threatMetrixRequestId;
                        onlineApplication.ThreatMetrix_Result__c = (threatMetrixSessionQueryResponse.threatMetrixReviewStatus).capitalize();
                    }

                } else {

                    // Query an already integrated application
                    CreditWS_ThreatMetrix.ThreatMetrixQueryRequest threatMetrixQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixQueryRequest();
                    threatMetrixQueryRequest.threatMetrixRequestId = onlineApplication.ThreatMetrix_Request_ID__c;
                    CreditWS_ThreatMetrix.ThreatMetrixQueryResponse threatMetrixQueryResponse = CreditWS_ThreatMetrix.getThreatMetrixScore(threatMetrixQueryRequest);

                    onlineApplication.ThreatMetrix_Result__c = (threatMetrixQueryResponse.reviewStatus).capitalize();

                }

            } else {
                onlineApplication.ThreatMetrix_Result__c = 'Pass';
            }

            // Existing Exposure - Application/Account Exposure
            CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();

            existingExposureRequest.applicationId = onlineApplication.Id;
            existingExposureRequest.applicationName = onlineApplication.Name;
            existingExposureRequest.legalBusinessName = onlineApplication.Legal_Business_Name__c;
            existingExposureRequest.addressLine1 = onlineApplication.Business_Street_Address__c;
            existingExposureRequest.city = onlineApplication.City__c;
            existingExposureRequest.state = onlineApplication.State__c;
            existingExposureRequest.postalCode = onlineApplication.Zip_Code__c;
            existingExposureRequest.fraudFlag = onlineApplication.Fraud_Flag__c;

            List<CreditUtil_ExistingExposure.ExistingExposureApplications> existingExposureApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);
            onlineApplication.Application_Exposure_Hits__c = existingExposureApplications.size();
            onlineApplication.Existing_Account_Exposure_Hits__c = (CreditUtil_ExistingExposure.getAccounts(existingExposureRequest)).size();

            for (CreditUtil_ExistingExposure.ExistingExposureApplications existingExposureApplication : existingExposureApplications) {
                if (existingExposureApplication.fraudFlag) {
                    onlineApplication.Previous_Fraud__c = true;
                }
            }

            if (onlineApplication.AO_Social_Security_Number__c != null) {

                // LexisNexis Check
                System.debug('Running LexisNexis...');
                CreditWS_LexisNexis.InstantIDRequest lexisNexisRequest = new CreditWS_LexisNexis.InstantIDRequest();

                if (onlineApplication.Contact_First_Name__c == null && onlineApplication.Contact_Last_Name__c == null && onlineApplication.Contact_Name__c != null) {
                    lexisNexisRequest.firstName = (onlineApplication.Contact_Name__c).split(' ')[0];
                    lexisNexisRequest.lastName = (onlineApplication.Contact_Name__c).split(' ')[1];
                } else {
                    lexisNexisRequest.firstName = onlineApplication.Contact_First_Name__c;
                    lexisNexisRequest.lastName = onlineApplication.Contact_Last_Name__c;
                }
                lexisNexisRequest.addressLine1 = onlineApplication.AO_Address__c;
                lexisNexisRequest.city = onlineApplication.AO_City__c;
                lexisNexisRequest.state = onlineApplication.AO_State__c;
                lexisNexisRequest.postalCode = onlineApplication.AO_Zip_Code__c;
                lexisNexisRequest.dateOfBirth = onlineApplication.AO_Date_of_Birth__c;
                lexisNexisRequest.socialSecurityNumber = onlineApplication.AO_Social_Security_Number__c;

                CreditWS_LexisNexis.InstantIDResponse lexisNexisResponse = CreditWS_LexisNexis.lexisNexisInstantIDVerification(lexisNexisRequest);

                if (lexisNexisResponse.individualVerified) {
                    onlineApplication.Social_Security_Check__c = 'Passed';
                } else if (lexisNexisResponse.calloutFailed) {
                    onlineApplication.Social_Security_Check__c = 'Error';
                } else {
                    onlineApplication.Social_Security_Check__c = 'Failed';
                }

                // Lexis Nexis Bridger Check - Individual
                System.debug('Running LexisNexis Individual...');
                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest lexisNexisBridgerIndividualRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest();

                if (onlineApplication.Contact_First_Name__c == null && onlineApplication.Contact_Last_Name__c == null && onlineApplication.Contact_Name__c != null) {
                    lexisNexisBridgerIndividualRequest.firstName = (onlineApplication.Contact_Name__c).split(' ')[0];
                    lexisNexisBridgerIndividualRequest.lastName = (onlineApplication.Contact_Name__c).split(' ')[1];
                } else {
                    lexisNexisBridgerIndividualRequest.firstName = onlineApplication.Contact_First_Name__c;
                    lexisNexisBridgerIndividualRequest.lastName = onlineApplication.Contact_Last_Name__c;
                }
                lexisNexisBridgerIndividualRequest.addressLine1 = onlineApplication.AO_Address__c;
                lexisNexisBridgerIndividualRequest.city = onlineApplication.AO_City__c;
                lexisNexisBridgerIndividualRequest.state = onlineApplication.AO_State__c;
                lexisNexisBridgerIndividualRequest.postalCode = onlineApplication.AO_Zip_Code__c;
                lexisNexisBridgerIndividualRequest.dateOfBirth = onlineApplication.AO_Date_of_Birth__c;
                lexisNexisBridgerIndividualRequest.socialSecurityNumber = onlineApplication.AO_Social_Security_Number__c;
                lexisNexisBridgerIndividualRequest.phoneNumber = onlineApplication.AO_Home_Phone_Number__c;

                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualResponse lexisNexisBridgerIndividualResponse = CreditWS_LexisNexisBridger.bridgerSearchIndividual(lexisNexisBridgerIndividualRequest);

                if (lexisNexisBridgerIndividualResponse.calloutFailed) {
                    onlineApplication.Sanctions_Individual_Check__c = 'Error';
                } else if (lexisNexisBridgerIndividualResponse.individualPassed == true) {
                    onlineApplication.Sanctions_Individual_Check__c = 'Passed';
                } else {
                    onlineApplication.Sanctions_Individual_Check__c = 'Failed';
                    onlineApplication.Sanctions_Individual_Result_ID__c = lexisNexisBridgerIndividualResponse.sanctionsResultId;
                }

            } else {
                // If we don't have a PG - then we can't resolve this person
                onlineApplication.Social_Security_Check__c = 'Passed';
                onlineApplication.Sanctions_Individual_Check__c = 'Passed';
            }

            // Lexis Nexis Bridger Check - Business
            System.debug('Running NexisLexis Business...');
            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest lexisNexisBridgerBusinessRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest();

            lexisNexisBridgerBusinessRequest.companyName = onlineApplication.Legal_Business_Name__c;
            lexisNexisBridgerBusinessRequest.addressLine1 = onlineApplication.Business_Street_Address__c;
            lexisNexisBridgerBusinessRequest.city = onlineApplication.City__c;
            lexisNexisBridgerBusinessRequest.state = onlineApplication.State__c;
            lexisNexisBridgerBusinessRequest.postalCode = onlineApplication.Zip_Code__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessResponse lexisNexisBridgerBusinessResponse = CreditWS_LexisNexisBridger.bridgerSearchBusiness(lexisNexisBridgerBusinessRequest);

            if (lexisNexisBridgerBusinessResponse.calloutFailed) {
                onlineApplication.Sanctions_Business_Check__c = 'Error';
            } else if (lexisNexisBridgerBusinessResponse.businessPassed == true) {
                onlineApplication.Sanctions_Business_Check__c = 'Passed';
            } else {
                onlineApplication.Sanctions_Business_Check__c = 'Failed';
                onlineApplication.Sanctions_Business_Result_ID__c = lexisNexisBridgerBusinessResponse.sanctionsResultId;

            }

            // DNB Resolution
            System.debug('Running DNB Matching...');
            CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

            dnbDirectMatchRequest.SingleResolution = true;
            dnbDirectMatchRequest.SubjectName = onlineApplication.Legal_Business_Name__c;
            dnbDirectMatchRequest.StreetAddressLine1 = onlineApplication.Business_Street_Address__c;
            dnbDirectMatchRequest.PrimaryTownName = onlineApplication.City__c;
            dnbDirectMatchRequest.TerritoryName = onlineApplication.State__c;
            dnbDirectMatchRequest.FullPostalCode = onlineApplication.Zip_Code__c;
            dnbDirectMatchRequest.CountryISOAlpha2Code = onlineApplication.Country__c;
            dnbDirectMatchRequest.DUNSNumber = onlineApplication.DUNS__c;

            CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates.size() == 1) {

                onlineApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                onlineApplication.DNB_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchGradeString;
                onlineApplication.DNB_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchDataProfile;
                onlineApplication.DNB_Street_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNameMatchDataProfile;
                onlineApplication.DNB_Street_Number_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNumberMatchDataProfile;
                onlineApplication.DNB_City_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].CityMatchDataProfile;
                onlineApplication.DNB_State_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StateMatchDataProfile;
                onlineApplication.DNB_Postal_Code_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].PostalCodeMatchDataProfile;
                onlineApplication.DNB_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].MatchGradeText;
                if (dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue != null) {
                    onlineApplication.DNB_Confidence_Code__c = String.valueOf(dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue);
                }

                // Execute BREeze for pre-processing
                BREeze.ProcessRules.ruleDataSet breezeResults = BREeze.ProcessRules.processRuleLogic('OTRCreditDecisioningDNBMatch', new List<SObject>{
                        onlineApplication
                });

                if (breezeResults.records != null && breezeResults.records[0].get('DNB_Resolution_Check__c') != null && (breezeResults.records[0].get('DNB_Resolution_Check__c').toString()).equalsIgnoreCase('Passed')) {

                    System.debug('Running DNB...');
                    onlineApplication.DUNS__c = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;

                    if (onlineApplication.Country__c == null || (onlineApplication.Country__c).equalsIgnoreCase('US')) {

                        CreditWS_DNB.DNBOTRModelRequest dnbOTRModelRequest = new CreditWS_DNB.DNBOTRModelRequest();

                        dnbOTRModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbOTRModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(onlineApplication.Credit_Line_Requested__c));
                        dnbOTRModelRequest.TeamDriversSlipSeat = String.valueOf(onlineApplication.Team_Drivers_Slip_Seat__c);
                        dnbOTRModelRequest.NumberOfTrucks = String.valueOf(onlineApplication.Number_of_Trucks__c);

                        CreditWS_DNB.DNBOTRModelResponse dnbOTRModelResponse = CreditWS_DNB.getOTRScore(dnbOTRModelRequest);

                        if (dnbOTRModelResponse != null) {

                            onlineApplication.DNB_Score__c = dnbOTRModelResponse.RawScore;
                            onlineApplication.DNB_Credit_Line_Recommendation__c = dnbOTRModelResponse.RecommendedCreditLimitAmount;
                            onlineApplication.SIC_Code__c = dnbOTRModelResponse.PrimarySIC;
                            onlineApplication.DNB_Resolved_DUNS__c = dnbOTRModelResponse.DunsNumber;
                            onlineApplication.DUNS__c = dnbOTRModelResponse.DunsNumber;
                            onlineApplication.Global_Ultimate_DUNS__c = dnbOTRModelResponse.GlobalUltimateDUNS;
                            onlineApplication.DNB_Resolved_Name__c = dnbOTRModelResponse.PrimaryName;
                            onlineApplication.DNB_Resolved_Address__c = dnbOTRModelResponse.AddressLine;
                            onlineApplication.DNB_Resolved_City__c = dnbOTRModelResponse.PostalTown;
                            onlineApplication.DNB_Resolved_State__c = dnbOTRModelResponse.PrimaryGeographicArea;
                            onlineApplication.DNB_Resolved_Postal_Code__c = dnbOTRModelResponse.PostalCode;
                            onlineApplication.DNB_Resolved_Country__c = dnbOTRModelResponse.CountryCode;
                            onlineApplication.DNB_SBFE_High_Credit__c = dnbOTRModelResponse.SBFEHighCredit;
                            onlineApplication.DNB_CSAD_High_Credit__c = dnbOTRModelResponse.CSADHighCredit;
                            onlineApplication.DNB_SBRI_Card_Score__c = dnbOTRModelResponse.SBRICardScore;
                            onlineApplication.Bureau_Tax_ID__c = dnbOTRModelResponse.FeinTaxID;
                            onlineApplication.Paydex__c = dnbOTRModelResponse.Paydex;
                            if (dnbOTRModelResponse.ControlYear != null) {
                                onlineApplication.Control_Year__c = String.valueOf(dnbOTRModelResponse.ControlYear);
                            }
                            if (dnbOTRModelResponse.YearStarted != null) {
                                onlineApplication.Year_Started__c = String.valueOf(dnbOTRModelResponse.YearStarted);
                            }
                            onlineApplication.Number_of_Payments_Negative__c = dnbOTRModelResponse.NumberPaymentExperiencesNegative;
                            onlineApplication.Number_of_Payments_Slow__c = dnbOTRModelResponse.NumberPaymentExperiencesSlow;
                            onlineApplication.Satisfactory_Trades__c = dnbOTRModelResponse.NumberPaymentExperiencesSatisfactory;
                            onlineApplication.DNB_Trade_Lines__c = dnbOTRModelResponse.NumberOfTrades;
                            if (dnbOTRModelResponse.ReasonCodes != null) {
                                onlineApplication.DNB_Reason_Code__c = String.join(dnbOTRModelResponse.ReasonCodes, ', ');
                            }
                        }
                        else {
                            onlineApplication.DNB_Score__c = 0;
                        }

                    } else if (onlineApplication.Country__c != null && (onlineApplication.Country__c).equalsIgnoreCase('CA')) {

                        CreditWS_DNB.DNBCAModelRequest dnbCAModelRequest = new CreditWS_DNB.DNBCAModelRequest();

                        dnbCAModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbCAModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(onlineApplication.Credit_Line_Requested__c));
                        dnbCAModelRequest.Platforms = 'OTR';
                        dnbCAModelRequest.TeamDriversSlipSeat = String.valueOf(onlineApplication.Team_Drivers_Slip_Seat__c);
                        dnbCAModelRequest.NumberOfTrucks = String.valueOf(onlineApplication.Number_of_Trucks__c);

                        CreditWS_DNB.DNBCAModelResponse dnbCAModelResponse = CreditWS_DNB.getCAScore(dnbCAModelRequest);

                        if (dnbCAModelResponse != null) {

                            onlineApplication.DNB_Score__c = dnbCAModelResponse.RawScore;
                            onlineApplication.DNB_Credit_Line_Recommendation__c = dnbCAModelResponse.RecommendedCreditLimitAmount;
                            onlineApplication.SIC_Code__c = dnbCAModelResponse.PrimarySIC;
                            onlineApplication.DNB_Resolved_DUNS__c = dnbCAModelResponse.DunsNumber;
                            onlineApplication.DUNS__c = dnbCAModelResponse.DunsNumber;
                            onlineApplication.Global_Ultimate_DUNS__c = dnbCAModelResponse.GlobalUltimateDUNS;
                            onlineApplication.DNB_Resolved_Name__c = dnbCAModelResponse.PrimaryName;
                            onlineApplication.DNB_Resolved_Address__c = dnbCAModelResponse.AddressLine;
                            onlineApplication.DNB_Resolved_City__c = dnbCAModelResponse.PostalTown;
                            onlineApplication.DNB_Resolved_State__c = dnbCAModelResponse.PrimaryGeographicArea;
                            onlineApplication.DNB_Resolved_Postal_Code__c = dnbCAModelResponse.PostalCode;
                            onlineApplication.DNB_Resolved_Country__c = dnbCAModelResponse.CountryCode;
                            onlineApplication.DNB_SBFE_High_Credit__c = dnbCAModelResponse.SBFEHighCredit;
                            onlineApplication.DNB_CSAD_High_Credit__c = dnbCAModelResponse.CSADHighCredit;
                            onlineApplication.DNB_SBRI_Card_Score__c = dnbCAModelResponse.SBRICardScore;
                            onlineApplication.Bureau_Tax_ID__c = dnbCAModelResponse.FeinTaxID;
                            onlineApplication.Paydex__c = dnbCAModelResponse.Paydex;
                            if (dnbCAModelResponse.ControlYear != null) {
                                onlineApplication.Control_Year__c = String.valueOf(dnbCAModelResponse.ControlYear);
                            }
                            if (dnbCAModelResponse.YearStarted != null) {
                                onlineApplication.Year_Started__c = String.valueOf(dnbCAModelResponse.YearStarted);
                            }
                            onlineApplication.Number_of_Payments_Negative__c = dnbCAModelResponse.NumberPaymentExperiencesNegative;
                            onlineApplication.Number_of_Payments_Slow__c = dnbCAModelResponse.NumberPaymentExperiencesSlow;
                            onlineApplication.Satisfactory_Trades__c = dnbCAModelResponse.NumberPaymentExperiencesSatisfactory;
                            onlineApplication.DNB_Trade_Lines__c = dnbCAModelResponse.NumberOfTrades;
                            if (dnbCAModelResponse.ReasonCodes != null) {
                                onlineApplication.DNB_Reason_Code__c = String.join(dnbCAModelResponse.ReasonCodes, ', ');
                            }
                        }
                        else {
                            onlineApplication.DNB_Score__c = 0;
                        }

                    }

                }
                else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                    dnbDirectMatchRequest.SingleResolution = false;
                    dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                    if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {
                        onlineApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                    }

                }

            } else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                dnbDirectMatchRequest.SingleResolution = false;
                dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {
                    onlineApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                }

            } else {
                onlineApplication.DNB_Lookup_Hits__c = 0;
            }

            // SAFER
            if (onlineApplication.DOT_Number__c != null && !onlineApplication.DOT_Number__c.equals('')) {
                List<SAFER_Carrier__c> saferCarriers = [SELECT Id, DOT_Number__c from SAFER_Carrier__c where DOT_Number__c =: onlineApplication.DOT_Number__c];
    
                if (saferCarriers.size() > 0) {
                    onlineApplication.SAFER_Carrier__c = saferCarriers[0].Id;
                }
            }

            // Forte
            System.debug('Running Forte...');
            CreditWS_Forte.ForteRequest forteRequest = new CreditWS_Forte.ForteRequest();

            forteRequest.authorization_amount = 1;
            forteRequest.action = 'verify';
            forteRequest.echeck = new CreditWS_Forte.ForteECheck();
            forteRequest.echeck.account_number = onlineApplication.Checking_Account_Number__c;
            forteRequest.echeck.routing_number = onlineApplication.ABA_Routing_Number__c;

            if (!TestUtils.isRunningTest()) {

                CreditWS_Forte.ForteResponse forteResponse = CreditWS_Forte.verifyBankAccount(forteRequest);

                if (forteResponse != null && forteResponse.response != null) {
                    onlineApplication.Forte_Response_Code__c = forteResponse.response.response_code;
                    onlineApplication.Forte_Response_Message__c = forteResponse.response.response_desc;
                    onlineApplication.Forte_Response_Type__c = forteResponse.response.response_type;
                }

            }

            CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

            giactVerifyRequest.RoutingNumber = onlineApplication.ABA_Routing_Number__c;
            giactVerifyRequest.AccountNumber = onlineApplication.Checking_Account_Number__c;
            giactVerifyRequest.FirstName = onlineApplication.Contact_First_Name__c;
            giactVerifyRequest.LastName = onlineApplication.Contact_Last_Name__c;
            giactVerifyRequest.BusinessName = onlineApplication.Legal_Business_Name__c;
            giactVerifyRequest.AddressLine1 = onlineApplication.Business_Street_Address__c;
            giactVerifyRequest.AddressLine2 = onlineApplication.Business_Address_Line_2__c;
            giactVerifyRequest.City = onlineApplication.City__c;
            giactVerifyRequest.State = onlineApplication.State__c;
            giactVerifyRequest.ZipCode = onlineApplication.Zip_Code__c;
            giactVerifyRequest.Country = onlineApplication.Country__c;
            giactVerifyRequest.PhoneNumber = onlineApplication.Phone_Number__c;
            giactVerifyRequest.FederalTaxId = onlineApplication.Federal_Tax_ID__c;
            giactVerifyRequest.EmailAddress = onlineApplication.Email__c;
            giactVerifyRequest.IpAddress = onlineApplication.IP_Address__c;

            if (!TestUtils.isRunningTest()) {

                CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

                if(giactVerifyResponse != null) {

                    onlineApplication.GIACT_Account_Response_Code__c = giactVerifyResponse.AccountResponseCode;
                    onlineApplication.GIACT_Account_Response_Message__c = giactVerifyResponse.AccountResponseMessage;
                    onlineApplication.GIACT_Response_Code__c = giactVerifyResponse.VerificationResponseCode;
                    onlineApplication.GIACT_Response_Message__c = giactVerifyResponse.VerificationResponseMessage;

                }
                else {

                    onlineApplication.GIACT_Check__c = 'Error';
                    onlineApplication.GIACT_Response_Message__c = giactVerifyResponse.GiactErrorMessage;

                }

            }

            // Upsert and execute BREeze
            upsert onlineApplication;

            // Make a safe copy so we don't overwrite any fields
            onlineApplications = [SELECT Id, Running_Credit_Decisioning__c FROM OnlineApplication__c WHERE Id = :onlineApplicationId LIMIT 1];

            if (onlineApplications.size() > 0) {

                // Flag the Credit Decision Engine as not running
                onlineApplications[0].Running_Credit_Decisioning__c = false;

                upsert onlineApplications;

            }

            // Run counter-offer processes
            onlineApplications = [SELECT Id, PG_Required__c, AO_Country__c, Opportunity__r.Pull_PG_Credit__c FROM OnlineApplication__c WHERE Id = :onlineApplicationId LIMIT 1];

            if (onlineApplications.size() > 0) {

                OnlineApplication__c onlineApp = onlineApplications[0];

                if (onlineApp.PG_Required__c == true
                        && (onlineApp.Opportunity__r.Pull_PG_Credit__c == null || onlineApp.Opportunity__r.Pull_PG_Credit__c.equalsIgnoreCase('Yes'))
                        && !TestUtils.isRunningTest()) {

                    if(onlineApp.AO_Country__c == null || (onlineApp.AO_Country__c).equalsIgnoreCase('US')) {
                        System.debug('Attemping to pull Experian credit report...');
                        CreditDecisionEngineQueueable.runExperianPGChecks(onlineApp.Id);
                    }
                    else if(onlineApp.AO_Country__c != null && (onlineApp.AO_Country__c).equalsIgnoreCase('CA')) {
                        System.debug('Attemping to pull Equifax credit report...');
                        CreditDecisionEngineQueueable.runEquifaxPGChecks(onlineApp.Id);
                    }
                }

            }

        }

    }

}