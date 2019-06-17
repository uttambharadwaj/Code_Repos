/*
*
* Credit Decisioning Process
* Module: Main Runner
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/
global class CreditDecisionEngineCP {

    public static Boolean decisionEngineRunning = false;

    // If called from a button
    webservice static void runCPDecisioningProcessButton(Id cpApplicationId) {  runCPDecisioningProcess(cpApplicationId); }

    @future(callout=true)
    public static void runCPDecisioningProcessFuture(Id cpApplicationId) {
        runCPDecisioningProcess(cpApplicationId);
    }

    public static void runCPDecisioningProcess(Id cpApplicationId) {

        decisionEngineRunning = true;

        List<CP_Application_Request__c> cpApplications = [
                SELECT Id, Name, Company_Legal_Name__c, Forte_Response_Code__c, Application_Stage__c, ThreatMetrix_Request_ID__c,
                        ThreatMetrix_Result__c, Sanctions_Business_Check__c, Sanctions_Individual_Check__c,
                        Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Country__c, Physical_Postal_Code__c, Sanctions_Individual_Result_ID__c,
                        First_Name__c, Last_Name__c, Taxpayer_ID__c, Guarantor_First_Name__c, Guarantor_Last_Name__c, Guarantor_Date_of_Birth__c,
                        Guarantor_Residential_Address__c, Guarantor_Residential_City__c, Guarantor_State_Province__c, Guarantor_Country__c,
                        Guarantor_Residential_Postal_Code__c, Guarantor_Residential_Phone__c, Guarantor_Social_Security_Number__c, Opportunity__r.SourceSystem__c,
                        Running_Credit_Decisioning__c, DUNS_Number__c, Legal_Structure__c, Business_Phone__c,Program__c, CreatedBy.Alias,
                        Checking_Account_Number__c, ABA_Routing_Number__c, Fraud_Flag__c, DNB_Reason_Code__c, DNB_Confidence_Code__c, Credit_Line_Requested__c,
                        Doing_Business_As__c, Account__r.Name, Mailing_Address_Line_1__c, Mailing_City__c, Mailing_State_Province__c, Mailing_Postal_Code__c, Email__c, Application_Signer_IP_Address__c,
                        DNB_Resolved_DUNS__c
                FROM CP_Application_Request__c
                WHERE Id = :cpApplicationId
        ];

        if (cpApplications.size() > 0) {

            CP_Application_Request__c cpApplication = cpApplications[0];

            cpApplication.Running_Credit_Decisioning__c = true;

            // ThreatMetrix
            if ((cpApplication.Opportunity__r.SourceSystem__c).equalsIgnoreCase('BOCA')) {

                // If the application hasn't yet been integrated
                if(cpApplication.ThreatMetrix_Request_ID__c == null) {

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest threatMetrixSessionQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest();

                    threatMetrixSessionQueryRequest.sessionId = cpApplication.ThreatMetrix_Session_ID__c;
                    threatMetrixSessionQueryRequest.transactionId = cpApplication.Id;
                    threatMetrixSessionQueryRequest.accountName = cpApplication.Account__r.Name;
                    threatMetrixSessionQueryRequest.dbaName = cpApplication.Doing_Business_As__c;
                    threatMetrixSessionQueryRequest.federalTaxId = cpApplication.Taxpayer_ID__c;

                    threatMetrixSessionQueryRequest.physicalAddressLine1 = cpApplication.Physical_Address_Line_1__c;
                    threatMetrixSessionQueryRequest.physicalCity = cpApplication.Physical_City__c;
                    threatMetrixSessionQueryRequest.physicalState = cpApplication.Physical_State_Province__c;
                    threatMetrixSessionQueryRequest.physicalPostalCode = cpApplication.Physical_Postal_Code__c;

                    threatMetrixSessionQueryRequest.mailingAddressLine1 = cpApplication.Mailing_Address_Line_1__c;
                    threatMetrixSessionQueryRequest.mailingCity = cpApplication.Mailing_City__c;
                    threatMetrixSessionQueryRequest.mailingState = cpApplication.Mailing_State_Province__c;
                    threatMetrixSessionQueryRequest.mailingPostalCode = cpApplication.Mailing_Postal_Code__c;

                    threatMetrixSessionQueryRequest.guarantorName = cpApplication.Guarantor_First_Name__c + ' ' + cpApplication.Guarantor_Last_Name__c;
                    threatMetrixSessionQueryRequest.guarantorEmail = cpApplication.Email__c;

                    threatMetrixSessionQueryRequest.emailAddress = cpApplication.Email__c;
                    threatMetrixSessionQueryRequest.phoneNumber = cpApplication.Business_Phone__c;

                    threatMetrixSessionQueryRequest.ipAddress = cpApplication.Application_Signer_IP_Address__c;

                    CreditWS_ThreatMetrix.ThreatMetrixSessionQueryResponse threatMetrixSessionQueryResponse = CreditWS_ThreatMetrix.integrateCreditApp(threatMetrixSessionQueryRequest);

                    if (threatMetrixSessionQueryResponse != null) {
                        cpApplication.ThreatMetrix_Request_ID__c = threatMetrixSessionQueryResponse.threatMetrixRequestId;
                        cpApplication.ThreatMetrix_Result__c = (threatMetrixSessionQueryResponse.threatMetrixReviewStatus).capitalize();
                    }

                }
                else {

                    // Query an already integrated application
                    CreditWS_ThreatMetrix.ThreatMetrixQueryRequest threatMetrixQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixQueryRequest();
                    threatMetrixQueryRequest.threatMetrixRequestId = cpApplication.ThreatMetrix_Request_ID__c;
                    CreditWS_ThreatMetrix.ThreatMetrixQueryResponse threatMetrixQueryResponse = CreditWS_ThreatMetrix.getThreatMetrixScore(threatMetrixQueryRequest);

                    if(threatMetrixQueryResponse != null && threatMetrixQueryResponse.reviewStatus != null) cpApplication.ThreatMetrix_Result__c = (threatMetrixQueryResponse.reviewStatus).capitalize();

                }

            } else {
                cpApplication.ThreatMetrix_Result__c = 'Pass';
            }

            if (cpApplication.Guarantor_Social_Security_Number__c != null) {

                // LexisNexis Check
                CreditWS_LexisNexis.InstantIDRequest lexisNexisRequest = new CreditWS_LexisNexis.InstantIDRequest();

                lexisNexisRequest.firstName = cpApplication.Guarantor_First_Name__c;
                lexisNexisRequest.lastName = cpApplication.Guarantor_Last_Name__c;
                lexisNexisRequest.addressLine1 = cpApplication.Guarantor_Residential_Address__c;
                lexisNexisRequest.city = cpApplication.Guarantor_Residential_City__c;
                lexisNexisRequest.state = cpApplication.Guarantor_State_Province__c;
                lexisNexisRequest.postalCode = cpApplication.Guarantor_Residential_Postal_Code__c;
                lexisNexisRequest.dateOfBirth = cpApplication.Guarantor_Date_of_Birth__c;
                lexisNexisRequest.socialSecurityNumber = cpApplication.Guarantor_Social_Security_Number__c;

                CreditWS_LexisNexis.InstantIDResponse lexisNexisResponse = CreditWS_LexisNexis.lexisNexisInstantIDVerification(lexisNexisRequest);

                if (lexisNexisResponse.individualVerified) {

                    cpApplication.Social_Security_Check__c = 'Passed';

                } else if (lexisNexisResponse.calloutFailed) {

                    cpApplication.Social_Security_Check__c = 'Error';

                } else {

                    cpApplication.Social_Security_Check__c = 'Failed';

                }

                // Lexis Nexis Bridger Check - Individual
                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest lexisNexisBridgerIndividualRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest();

                lexisNexisBridgerIndividualRequest.firstName = cpApplication.Guarantor_First_Name__c;
                lexisNexisBridgerIndividualRequest.lastName = cpApplication.Guarantor_Last_Name__c;
                lexisNexisBridgerIndividualRequest.addressLine1 = cpApplication.Guarantor_Residential_Address__c;
                lexisNexisBridgerIndividualRequest.city = cpApplication.Guarantor_Residential_City__c;
                lexisNexisBridgerIndividualRequest.state = cpApplication.Guarantor_State_Province__c;
                lexisNexisBridgerIndividualRequest.postalCode = cpApplication.Guarantor_Residential_Postal_Code__c;
                lexisNexisBridgerIndividualRequest.dateOfBirth = cpApplication.Guarantor_Date_of_Birth__c;
                lexisNexisBridgerIndividualRequest.socialSecurityNumber = cpApplication.Guarantor_Social_Security_Number__c;
                lexisNexisBridgerIndividualRequest.phoneNumber = cpApplication.Guarantor_Residential_Phone__c;

                CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualResponse lexisNexisBridgerIndividualResponse = CreditWS_LexisNexisBridger.bridgerSearchIndividual(lexisNexisBridgerIndividualRequest);

                if (lexisNexisBridgerIndividualResponse.calloutFailed) {

                    cpApplication.Sanctions_Individual_Check__c = 'Error';

                } else if (lexisNexisBridgerIndividualResponse.individualPassed == true) {

                    cpApplication.Sanctions_Individual_Check__c = 'Passed';

                } else {

                    cpApplication.Sanctions_Individual_Check__c = 'Failed';
                    cpApplication.Sanctions_Individual_Result_ID__c = lexisNexisBridgerIndividualResponse.sanctionsResultId;

                }

            } else {
                // If we don't have a PG - then we can't resolve this person
                cpApplication.Social_Security_Check__c = 'Passed';
                cpApplication.Sanctions_Individual_Check__c = 'Passed';
            }

            // Lexis Nexis Bridger Check - Business
            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest lexisNexisBridgerBusinessRequest = new CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest();

            lexisNexisBridgerBusinessRequest.companyName = cpApplication.Company_Legal_Name__c;
            lexisNexisBridgerBusinessRequest.addressLine1 = cpApplication.Physical_Address_Line_1__c;
            lexisNexisBridgerBusinessRequest.city = cpApplication.Physical_City__c;
            lexisNexisBridgerBusinessRequest.state = cpApplication.Physical_State_Province__c;
            lexisNexisBridgerBusinessRequest.postalCode = cpApplication.Physical_Postal_Code__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessResponse lexisNexisBridgerBusinessResponse = CreditWS_LexisNexisBridger.bridgerSearchBusiness(lexisNexisBridgerBusinessRequest);

            if (lexisNexisBridgerBusinessResponse.calloutFailed) {

                cpApplication.Sanctions_Business_Check__c = 'Error';

            } else if (lexisNexisBridgerBusinessResponse.businessPassed == true) {

                cpApplication.Sanctions_Business_Check__c = 'Passed';

            } else {

                cpApplication.Sanctions_Business_Check__c = 'Failed';
                cpApplication.Sanctions_Business_Result_ID__c = lexisNexisBridgerBusinessResponse.sanctionsResultId;

            }

            // Lexis Nexis RDP - SBA
            CreditWS_LexisNexisRDP.LexisNexisSBARequest lexisNexisSBARequest = new CreditWS_LexisNexisRDP.LexisNexisSBARequest();

            lexisNexisSBARequest.companyName = cpApplication.Company_Legal_Name__c;
            lexisNexisSBARequest.streetAddress = cpApplication.Billing_Address_Line_1__c;
            lexisNexisSBARequest.city = cpApplication.Billing_City__c;
            lexisNexisSBARequest.state = cpApplication.Billing_State__c;
            lexisNexisSBARequest.postalCode = cpApplication.Billing_Postal_Code__c;
            lexisNexisSBARequest.phoneNumber = cpApplication.Business_Phone__c;
            lexisNexisSBARequest.federalTaxId = cpApplication.Taxpayer_ID__c;

            if(!String.isEmpty(cpApplication.Guarantor_Social_Security_Number__c)) {

                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();

                lexisNexisAuthorizedRepresenative.firstName = cpApplication.Guarantor_First_Name__c;
                lexisNexisAuthorizedRepresenative.lastName = cpApplication.Guarantor_Last_Name__c;
                lexisNexisAuthorizedRepresenative.streetAddress = cpApplication.Guarantor_Residential_Address__c;
                lexisNexisAuthorizedRepresenative.city = cpApplication.Guarantor_Residential_City__c;
                lexisNexisAuthorizedRepresenative.state = cpApplication.Guarantor_Residential_State__c;
                lexisNexisAuthorizedRepresenative.postalCode = cpApplication.Guarantor_Residential_Postal_Code__c;

                lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{ lexisNexisAuthorizedRepresenative };

            }

            CreditWS_LexisNexisRDP.LexisNexisSBAResponse lexisNexisSBAResponse = CreditWS_LexisNexisRDP.lexisNexisSmallBusinessAnalytics(lexisNexisSBARequest);

            cpApplication.Lexis_Nexis_Custom_Model_Score__c = lexisNexisSBAResponse.fraudScore;

            // Lexis Nexis - BIID
            CreditWS_LexisNexisRDP.LexisNexisBIIDRequest lexisNexisBIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisBIIDRequest();

            lexisNexisBIIDRequest.applicationId = cpApplication.Id;
            lexisNexisBIIDRequest.businessName = cpApplication.Company_Legal_Name__c;
            lexisNexisBIIDRequest.streetAddress = cpApplication.Billing_Address_Line_1__c;
            lexisNexisBIIDRequest.city = cpApplication.Billing_City__c;
            lexisNexisBIIDRequest.state = cpApplication.Billing_State__c;
            lexisNexisBIIDRequest.postalCode = cpApplication.Billing_Postal_Code__c;
            lexisNexisBIIDRequest.phoneNumber = cpApplication.Business_Phone__c;
            lexisNexisBIIDRequest.federalTaxId = cpApplication.Taxpayer_ID__c;

            if(!String.isEmpty(cpApplication.Guarantor_Social_Security_Number__c)) {

                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();

                lexisNexisAuthorizedRepresenative.firstName = cpApplication.Guarantor_First_Name__c;
                lexisNexisAuthorizedRepresenative.lastName = cpApplication.Guarantor_Last_Name__c;
                lexisNexisAuthorizedRepresenative.streetAddress = cpApplication.Guarantor_Residential_Address__c;
                lexisNexisAuthorizedRepresenative.city = cpApplication.Guarantor_Residential_City__c;
                lexisNexisAuthorizedRepresenative.state = cpApplication.Guarantor_Residential_State__c;
                lexisNexisAuthorizedRepresenative.postalCode = cpApplication.Guarantor_Residential_Postal_Code__c;

                lexisNexisBIIDRequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{
                        lexisNexisAuthorizedRepresenative
                };

            }

            CreditWS_LexisNexisRDP.LexisNexisBIIDResponse lexisNexisBIIDResponse = CreditWS_LexisNexisRDP.lexisNexisBusinessInstantID(lexisNexisBIIDRequest);

            if(lexisNexisBIIDResponse != null && !String.isEmpty(lexisNexisBIIDResponse.biidWorkflowResult)) {

                // set result in object
                cpApplication.Lexis_Nexis_BIID_Result__c = lexisNexisBIIDResponse.biidWorkflowResult;

                // If we fail, go to Fraud Point
                if(!(lexisNexisBIIDResponse.biidWorkflowResult).equalsIgnoreCase('passed') && !String.isEmpty(cpApplication.Guarantor_Social_Security_Number__c)) {

                    CreditWS_LexisNexisRDP.LexisNexisIIDRequest lexisNexisIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisIIDRequest();

                    LexisNexisIIDRequest.applicationId = cpApplication.Id;
                    lexisNexisIIDRequest.firstName = cpApplication.Guarantor_First_Name__c;
                    lexisNexisIIDRequest.lastName = cpApplication.Guarantor_Last_Name__c;
                    lexisNexisIIDRequest.streetAddress = cpApplication.Guarantor_Residential_Address__c;
                    lexisNexisIIDRequest.city = cpApplication.Guarantor_Residential_City__c;
                    lexisNexisIIDRequest.state = cpApplication.Guarantor_Residential_State__c;
                    lexisNexisIIDRequest.postalCode = cpApplication.Guarantor_Residential_Postal_Code__c;
                    lexisNexisIIDRequest.phoneNumber = cpApplication.Guarantor_Residential_Phone__c;
                    lexisNexisIIDRequest.socialSecurityNumber = cpApplication.Guarantor_Social_Security_Number__c;

                    CreditWS_LexisNexisRDP.LexisNexisIIDResponse lexisNexisIIDResponse = CreditWS_LexisNexisRDP.lexisNexisConsumerInstantId(LexisNexisIIDRequest);

                    cpApplication.Lexis_Nexis_FraudPoint_Score__c = lexisNexisIIDResponse.fraudPointScore;
                    cpApplication.Lexis_Nexis_FraudPoint_Result__c = lexisNexisIIDResponse.fraudPointWorkflowResult;
                    cpApplication.Lexis_Nexis_IID_Result__c = lexisNexisIIDResponse.iidWorkflowResult;

                }

            }

            // DNB Resolution
            CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

            dnbDirectMatchRequest.SingleResolution = true;
            dnbDirectMatchRequest.SubjectName = cpApplication.Company_Legal_Name__c;
            dnbDirectMatchRequest.StreetAddressLine1 = cpApplication.Physical_Address_Line_1__c;
            dnbDirectMatchRequest.PrimaryTownName = cpApplication.Physical_City__c;
            dnbDirectMatchRequest.TerritoryName = cpApplication.Physical_State_Province__c;
            dnbDirectMatchRequest.FullPostalCode = cpApplication.Physical_Postal_Code__c;
            dnbDirectMatchRequest.CountryISOAlpha2Code = cpApplication.Physical_Country__c;
            dnbDirectMatchRequest.DUNSNumber = cpApplication.DUNS_Number__c;
            dnbDirectMatchRequest.TelephoneNumber = cpApplication.Business_Phone__c;
            dnbDirectMatchRequest.TradeStyleName = cpApplication.Doing_Business_As__c;

            CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates.size() == 1 && dnbDirectMatchResponse.matchCandidates[0].OperatingStatus != null && (dnbDirectMatchResponse.matchCandidates[0].OperatingStatus).equalsIgnoreCase('Active')) {

                cpApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                cpApplication.DNB_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchGradeString;
                cpApplication.DNB_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchDataProfile;
                cpApplication.DNB_Street_Name_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNameMatchDataProfile;
                cpApplication.DNB_Street_Number_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].StreetNumberMatchDataProfile;
                cpApplication.DNB_City_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].CityMatchDataProfile;
                cpApplication.DNB_State_Match_Data_Profile__c  = dnbDirectMatchResponse.matchCandidates[0].StateMatchDataProfile;
                cpApplication.DNB_Postal_Code_Match_Data_Profile__c = dnbDirectMatchResponse.matchCandidates[0].PostalCodeMatchDataProfile;
                cpApplication.DNB_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].MatchGradeText;
                cpApplication.WEX_Match_Score__c = dnbDirectMatchResponse.matchCandidates[0].WEXMatchScore;
                if (dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue != null) {
                    cpApplication.DNB_Confidence_Code__c = String.valueOf(dnbDirectMatchResponse.matchCandidates[0].ConfidenceCodeValue);
                }

                // Execute BREeze for pre-processing
                BREeze.ProcessRules.ruleDataSet breezeResults = BREeze.ProcessRules.processRuleLogic('CPCreditDecisioningDNBMatch', new List<SObject>{cpApplication});

                if(breezeResults.records != null && breezeResults.records[0].get('DNB_Resolution_Check__c') != null && (breezeResults.records[0].get('DNB_Resolution_Check__c').toString()).equalsIgnoreCase('Passed')) {

                    cpApplication.DUNS_Number__c = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;

                    if (cpApplication.Physical_Country__c == null || (cpApplication.Physical_Country__c).equalsIgnoreCase('US')) {

                        CreditWS_DNB.DNBCPModelRequest dnbCPModelRequest = new CreditWS_DNB.DNBCPModelRequest();

                        dnbCPModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbCPModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(cpApplication.Credit_Line_Requested__c));

                        CreditWS_DNB.DNBCPModelResponse dnbCPModelResponse = CreditWS_DNB.getCPScore(dnbCPModelRequest);

                        if (dnbCPModelResponse != null) {

                            cpApplication.DNB_Score__c = dnbCPModelResponse.RawScore;
                            cpApplication.DNB_Credit_Line_Recommendation__c = dnbCPModelResponse.RecommendedCreditLimitAmount;
                            cpApplication.SIC_Code__c = dnbCPModelResponse.PrimarySIC;
                            cpApplication.DNB_Resolved_DUNS__c = dnbCPModelResponse.DunsNumber;
                            cpApplication.DUNS_Number__c = dnbCPModelResponse.DunsNumber;
                            cpApplication.Global_Ultimate_DUNS__c = dnbCPModelResponse.GlobalUltimateDUNS;
                            cpApplication.DNB_Resolved_Name__c = dnbCPModelResponse.PrimaryName;
                            cpApplication.DNB_Resolved_Address__c = dnbCPModelResponse.AddressLine;
                            cpApplication.DNB_Resolved_City__c = dnbCPModelResponse.PostalTown;
                            cpApplication.DNB_Resolved_State__c = dnbCPModelResponse.PrimaryGeographicArea;
                            cpApplication.DNB_Resolved_Postal_Code__c = dnbCPModelResponse.PostalCode;
                            cpApplication.DNB_Resolved_Country__c = dnbCPModelResponse.CountryCode;
                            cpApplication.DNB_SBFE_High_Credit__c = dnbCPModelResponse.SBFEHighCredit;
                            cpApplication.DNB_CSAD_High_Credit__c = dnbCPModelResponse.CSADHighCredit;
                            cpApplication.DNB_SBRI_Card_Score__c = dnbCPModelResponse.SBRICardScore;
                            cpApplication.Bureau_Tax_ID__c = dnbCPModelResponse.FeinTaxID;
                            cpApplication.Paydex__c = dnbCPModelResponse.Paydex;
                            if (dnbCPModelResponse.ControlYear != null) {
                                cpApplication.Control_Year__c = String.valueOf(dnbCPModelResponse.ControlYear);
                            }
                            if (dnbCPModelResponse.YearStarted != null) {
                                cpApplication.Year_Started__c = String.valueOf(dnbCPModelResponse.YearStarted);
                            }
                            cpApplication.Number_of_Payments_Negative__c = dnbCPModelResponse.NumberPaymentExperiencesNegative;
                            cpApplication.Number_of_Payments_Slow__c = dnbCPModelResponse.NumberPaymentExperiencesSlow;
                            cpApplication.Satisfactory_Trades__c = dnbCPModelResponse.NumberPaymentExperiencesSatisfactory;
                            cpApplication.DNB_Trade_Lines__c = dnbCPModelResponse.NumberOfTrades;
                            if (dnbCPModelResponse.ReasonCodes != null) {
                                cpApplication.DNB_Reason_Code__c = String.join(dnbCPModelResponse.ReasonCodes, ', ');
                            }

                        }
                        else {
                            cpApplication.DNB_Score__c = 0;
                        }

                    } else if (cpApplication.Physical_Country__c != null && (cpApplication.Physical_Country__c).equalsIgnoreCase('CA')) {

                        CreditWS_DNB.DNBCAModelRequest dnbCAModelRequest = new CreditWS_DNB.DNBCAModelRequest();

                        dnbCAModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbCAModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(cpApplication.Credit_Line_Requested__c));
                        dnbCAModelRequest.Platforms = 'Wex_MC';

                        CreditWS_DNB.DNBCAModelResponse dnbCAModelResponse = CreditWS_DNB.getCAScore(dnbCAModelRequest);

                        if (dnbCAModelResponse != null) {

                            cpApplication.DNB_Score__c = dnbCAModelResponse.RawScore;
                            cpApplication.DNB_Credit_Line_Recommendation__c = dnbCAModelResponse.RecommendedCreditLimitAmount;
                            cpApplication.SIC_Code__c = dnbCAModelResponse.PrimarySIC;
                            cpApplication.DNB_Resolved_DUNS__c = dnbCAModelResponse.DunsNumber;
                            cpApplication.DUNS_Number__c = dnbCAModelResponse.DunsNumber;
                            cpApplication.Global_Ultimate_DUNS__c = dnbCAModelResponse.GlobalUltimateDUNS;
                            cpApplication.DNB_Resolved_Name__c = dnbCAModelResponse.PrimaryName;
                            cpApplication.DNB_Resolved_Address__c = dnbCAModelResponse.AddressLine;
                            cpApplication.DNB_Resolved_City__c = dnbCAModelResponse.PostalTown;
                            cpApplication.DNB_Resolved_State__c = dnbCAModelResponse.PrimaryGeographicArea;
                            cpApplication.DNB_Resolved_Postal_Code__c = dnbCAModelResponse.PostalCode;
                            cpApplication.DNB_Resolved_Country__c = dnbCAModelResponse.CountryCode;
                            cpApplication.DNB_SBFE_High_Credit__c = dnbCAModelResponse.SBFEHighCredit;
                            cpApplication.DNB_CSAD_High_Credit__c = dnbCAModelResponse.CSADHighCredit;
                            cpApplication.DNB_SBRI_Card_Score__c = dnbCAModelResponse.SBRICardScore;
                            cpApplication.Bureau_Tax_ID__c = dnbCAModelResponse.FeinTaxID;
                            cpApplication.Paydex__c = dnbCAModelResponse.Paydex;
                            if (dnbCAModelResponse.ControlYear != null) {
                                cpApplication.Control_Year__c = String.valueOf(dnbCAModelResponse.ControlYear);
                            }
                            if (dnbCAModelResponse.YearStarted != null) {
                                cpApplication.Year_Started__c = String.valueOf(dnbCAModelResponse.YearStarted);
                            }
                            cpApplication.Number_of_Payments_Negative__c = dnbCAModelResponse.NumberPaymentExperiencesNegative;
                            cpApplication.Number_of_Payments_Slow__c = dnbCAModelResponse.NumberPaymentExperiencesSlow;
                            cpApplication.Satisfactory_Trades__c = dnbCAModelResponse.NumberPaymentExperiencesSatisfactory;
                            cpApplication.DNB_Trade_Lines__c = dnbCAModelResponse.NumberOfTrades;
                            if (dnbCAModelResponse.ReasonCodes != null) {
                                cpApplication.DNB_Reason_Code__c = String.join(dnbCAModelResponse.ReasonCodes, ', ');
                            }

                        }
                        else {
                            cpApplication.DNB_Score__c = 0;
                        }

                    }

                }
                else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                    dnbDirectMatchRequest.SingleResolution = false;
                    dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                    if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {
                        cpApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                    }

                }

            } else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                dnbDirectMatchRequest.SingleResolution = false;
                dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {
                    cpApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
                }

            } else {
                cpApplication.DNB_Lookup_Hits__c = 0;
            }

            // Existing Exposure - Application/Account Exposure
            CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();
            existingExposureRequest.applicationId = cpApplication.Id;
            existingExposureRequest.applicationName = cpApplication.Name;
            existingExposureRequest.legalBusinessName = cpApplication.Company_Legal_Name__c;
            existingExposureRequest.addressLine1 = cpApplication.Physical_Address_Line_1__c;
            existingExposureRequest.city = cpApplication.Physical_City__c;
            existingExposureRequest.state = cpApplication.Physical_State_Province__c;
            existingExposureRequest.postalCode = cpApplication.Physical_Postal_Code__c;
            existingExposureRequest.fraudFlag = cpApplication.Fraud_Flag__c;
            existingExposureRequest.ipAddress = cpApplication.Application_Signer_IP_Address__c;
            existingExposureRequest.phone = cpApplication.Business_Phone__c;
            existingExposureRequest.duns = cpApplication.DNB_Resolved_DUNS__c;
            existingExposureRequest.taxID = cpApplication.Taxpayer_ID__c;

            List<CreditUtil_ExistingExposure.ExistingExposureApplications> existingExposureApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);
            List<CreditUtil_ExistingExposure.ExistingExposureAccounts> existingExposureAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);

            // Forte
            CreditWS_Forte.ForteRequest forteRequest = new CreditWS_Forte.ForteRequest();

            forteRequest.authorization_amount = 1;
            forteRequest.action = 'verify';
            forteRequest.echeck = new CreditWS_Forte.ForteECheck();
            forteRequest.echeck.account_number = cpApplication.Checking_Account_Number__c;
            forteRequest.echeck.routing_number = cpApplication.ABA_Routing_Number__c;

            if (!TestUtils.isRunningTest()) {

                CreditWS_Forte.ForteResponse forteResponse = CreditWS_Forte.verifyBankAccount(forteRequest);

                if (forteResponse != null && forteResponse.response != null) {
                    cpApplication.Forte_Response_Code__c = forteResponse.response.response_code;
                    cpApplication.Forte_Response_Message__c = forteResponse.response.response_desc;
                    cpApplication.Forte_Response_Type__c = forteResponse.response.response_type;
                }

            }

            // GIACT
            if(!String.isBlank(cpApplication.ABA_Routing_Number__c) && !String.isBlank(cpApplication.Checking_Account_Number__c)) {

                CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

                giactVerifyRequest.UniqueId = String.valueOf(cpApplication.Id);
                giactVerifyRequest.RoutingNumber = cpApplication.ABA_Routing_Number__c;
                giactVerifyRequest.AccountNumber = cpApplication.Checking_Account_Number__c;
                giactVerifyRequest.FirstName = cpApplication.First_Name__c;
                giactVerifyRequest.LastName = cpApplication.Last_Name__c;
                giactVerifyRequest.BusinessName = cpApplication.Company_Legal_Name__c;
                giactVerifyRequest.AddressLine1 = cpApplication.Physical_Address_Line_1__c;
                giactVerifyRequest.AddressLine2 = cpApplication.Physical_Address_Line_2__c;
                giactVerifyRequest.City = cpApplication.Physical_City__c;
                giactVerifyRequest.State = cpApplication.Physical_State__c;
                giactVerifyRequest.ZipCode = cpApplication.Physical_Postal_Code__c;
                giactVerifyRequest.Country = cpApplication.Physical_Country__c;
                giactVerifyRequest.PhoneNumber = cpApplication.Business_Phone__c;
                giactVerifyRequest.FederalTaxId = cpApplication.Taxpayer_ID__c;
                giactVerifyRequest.EmailAddress = cpApplication.Email__c;
                giactVerifyRequest.IpAddress = cpApplication.Application_Signer_IP_Address__c;

                if (!TestUtils.isRunningTest()) {

                    CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

                    if (giactVerifyResponse != null && String.isBlank(giactVerifyResponse.GiactErrorMessage)) {

                        cpApplication.GIACT_Account_Response_Code__c = giactVerifyResponse.AccountResponseCode;
                        cpApplication.GIACT_Account_Response_Message__c = giactVerifyResponse.AccountResponseMessage;
                        cpApplication.GIACT_Response_Code__c = giactVerifyResponse.VerificationResponseCode;
                        cpApplication.GIACT_Response_Message__c = giactVerifyResponse.VerificationResponseMessage;

                        cpApplication.GIACT_Account_Response_Code_Name__c = giactVerifyResponse.AccountResponseCodeName;
                        cpApplication.GIACT_Verify_Response_Code_Name__c = giactVerifyResponse.VerificationResponseCodeName;

                    } else {

                        cpApplication.GIACT_Check__c = 'Error';
                        if(giactVerifyResponse != null) {
                            cpApplication.GIACT_Response_Message__c = giactVerifyResponse.GiactErrorMessage;
                        }

                    }

                }

            }

            System.debug(cpApplication);

            // Upsert and execute BREeze
            cpApplication.Number_of_Existing_Applications__c = existingExposureApplications.size();
            cpApplication.Number_of_Existing_Accounts__c = existingExposureAccounts.size();
            upsert cpApplication;

            // Make a safe copy so we don't overwrite any fields
            cpApplications = [SELECT Id, Running_Credit_Decisioning__c FROM CP_Application_Request__c WHERE Id = :cpApplicationId];

            if(cpApplications.size() > 0) {

                // Flag the Credit Decision Engine as not running
                cpApplication.Running_Credit_Decisioning__c = false;

                upsert cpApplication;
            }

//             Run counter-offer processes
            cpApplications = [SELECT Id, PG_Required__c, Guarantor_Country__c, Opportunity__r.Pull_PG_Credit__c FROM CP_Application_Request__c WHERE Id = :cpApplicationId];

            if (cpApplications.size() > 0 && !TestUtils.isRunningTest()) {

                CP_Application_Request__c cpApp = cpApplications[0];

                if (cpApp.PG_Required__c == true
                        && (cpApp.Opportunity__r.Pull_PG_Credit__c == null || cpApp.Opportunity__r.Pull_PG_Credit__c.equalsIgnoreCase('Yes'))) {

                    if (cpApp.Guarantor_Country__c == null || (cpApp.Guarantor_Country__c).equalsIgnoreCase('US')) {
                        CreditDecisionEngineQueueable.runExperianPGChecks(cpApp.Id);

                    } else if (cpApp.Guarantor_Country__c != null && (cpApp.Guarantor_Country__c).equalsIgnoreCase('CA')) {
                        CreditDecisionEngineQueueable.runEquifaxPGChecks(cpApp.Id);
                    }
                }
            }

        }

    }

}
