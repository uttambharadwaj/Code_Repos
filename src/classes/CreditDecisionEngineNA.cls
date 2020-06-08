/*
*
* Credit Decisioning Process
* Module: Main Runner
* Author: Derek Gilbert
* Initial Date: 3/26/2018
* Revision History: 4/30/2019 IADJUDICAT-739 do the constructor thing.
* 3/26/2020: Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components - Uttam Bharadwaj
* 5/4/2020: Release 20.09: EAPT-1618: Added a check for Legal Structure vs Company Name
* 5/28/2020: Release 20.11: EAPT-1754: Added ability to skip callouts on Application Request from Campaign
*                           EAPT-1851: Added a callout skip for Natural Persons as the Legal Entity
*/

global class CreditDecisionEngineNA {

    public static Boolean decisionEngineRunning = false;

    @future(callout=true)
    public static void runNADecisioningProcessFuture(Id naApplicationId) {
        runHandler(naApplicationId);
    }

    // If called from a button
    webservice static void runNADecisioningProcessButton(Id naApplicationId) {
        runHandler(naApplicationId);
    }

    /**
    * Allows the application to still run through the final decision business logic rules without doing
    * any callouts or any other business logic. If there are other scenarios that need this in the future, add
    * an additional if else.
    * If you need to bypass the entire credit decision engine, including the final decision use the
    * Run_Final_Decision_Only__c checkbox on the Campaign.
    * Added another scenario with Legal Structure as Natural Person
    **/

    private static Boolean bypassCallouts(Application_Request__c appReq) {
        Boolean bypassCallouts = false;
        if (appReq.Campaign_Program__c != null && appReq.Opportunity__r.Campaign.Run_Final_Decision_Only__c) {
            bypassCallouts = true;
        }
        if (appReq.Legal_Structure__c != null && appReq.Legal_Structure__c.containsIgnoreCase('Natural Person')
                && appReq.Physical_Country__c != null && appReq.Physical_Country__c == 'CA'){
            bypassCallouts = true;
        }
        return bypassCallouts;
    }

    public static void runHandler(Id naApplicationId) {

        List<Application_Request__c> naApplications = [
                SELECT Id, Automatically_Generated_Number__c, ABA_Routing_Number__c, Application_Signer_FirstName_Text__c, Application_Stage__c, App_Signer_IP_Address__c, App_Signer_Last_Name_Text__c,
                        Billing_City__c, Billing_Contact_First_Name_Text__c, Billing_Contact_Last_Name_Text__c, Billing_Contact__r.Email, Billing_Contact__r.Phone,
                        Billing_State__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Business_Phone_Number__c, Checking_Account_Number__c, CreatedBy.Alias,
                        Doing_Business_As__c, DUNS_Number__c, Legal_Structure__c, Name, Opportunity_Name_Text__c, Opportunity__r.SourceSystem__c,
                        Personal_Guarantor_DOB__c, Personal_Guarantor_First_Name__c, Personal_Guarantor_Home_Phone__c, Personal_Guarantor_Last_Name__c, Personal_Guarantor_Email__c,
                        Personal_Guarantor_Mailing_City__c, Personal_Guarantor_Mailing_Country__c, Personal_Guarantor_Mailing_State__c, Personal_Guarantor_Mailing_Street__c,
                        Personal_Guarantor_Mailing_Zip__c, Personal_Guarantor_SSN__c, PG_Required__c, Physical_City__c, Physical_State__c, Physical_Street__c, Requested_Credit_Limit__c,
                        Physical_Zip_Postal_Code__c, Program__c, Running_Credit_Decisioning__c, Sanctions_Business_Check__c, Sanctions_Business_Result_ID__c,
                        Sanctions_Individual_Check__c, Sanctions_Individual_Result_ID__c, Tax_Payer_ID_number__c, ThreatMetrix_Session_ID__c, ThreatMetrix_Request_ID__c, ThreatMetrix_Result__c,
                        Physical_Country__c, Fraud_Flag__c, DNB_Credit_Line_Recommendation__c, DNB_Confidence_Code__c, Personal_Guarantor__c, BPAV_Check__c, Campaign_Program__c,
                        Opportunity__r.Campaign.Run_Final_Decision_Only__c, Only_Final_Decision_Has_Run__c
                FROM Application_Request__c
                WHERE Id = :naApplicationId
        ];

        if (naApplications.size() > 0) {

            Application_Request__c naApplication = naApplications[0];

            if (!bypassCallouts(naApplication)) {
                runNADecisioningProcess(naApplication);
            }
            else {
                naApplication.Only_Final_Decision_Has_Run__c = true;
                upsert naApplication;
                runFinalCreditDecision(naApplication);
            }

        }
    }

    public static void runNADecisioningProcess(Application_Request__c naApplication) {

        decisionEngineRunning = true;



            if(!Test.isRunningTest()) {
                naApplication.Running_Credit_Decisioning__c = true;
            }

            // Check for Legal Structure Matching Company Name for US as a Physical Country
            // EAPT - 1618

            if (naApplication.Physical_Country__c == 'US' && null != naApplication.Opportunity_Name_Text__c && null != naApplication.Legal_Structure__c){

                System.debug('Checking for Legal Structure Issues...');

                naApplication.Legal_Name_Matches_Company_Name__c = CreditWs_Utils.checkLegalStructure(naApplication.Opportunity_Name_Text__c, naApplication.Legal_Structure__c);
            }

            // ThreatMetrix
            System.debug('Running ThreatMetrix....');
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

            System.debug('Running Lexis Nexis....');
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
                System.debug('Running LN Bridger Individual....');
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
            System.debug('Running LN Bridger Business....');
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

            //EAPT-1562 retiring LN RDP / BIID / CVI but I don't trust they won't re-add it. Going to leave it just commented out for a while then delete.
//            // Lexis Nexis RDP - SBA
//            System.debug('Running LN RDP - SBA....');
//            CreditWS_LexisNexisRDP.LexisNexisSBARequest lexisNexisSBARequest = new CreditWS_LexisNexisRDP.LexisNexisSBARequest();
//
//            lexisNexisSBARequest.companyName = naApplication.Opportunity_Name_Text__c;
//            lexisNexisSBARequest.streetAddress = naApplication.Billing_Street__c;
//            lexisNexisSBARequest.city = naApplication.Billing_City__c;
//            lexisNexisSBARequest.state = naApplication.Billing_State__c;
//            lexisNexisSBARequest.postalCode = naApplication.Billing_Zip_Postal_Code__c;
//            lexisNexisSBARequest.phoneNumber = naApplication.Business_Phone_Number__c;
//            lexisNexisSBARequest.federalTaxId = naApplication.Tax_Payer_ID_number__c;
//
//            if(naApplication.Personal_Guarantor__c != null) {
//
//                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();
//
//                lexisNexisAuthorizedRepresenative.firstName = naApplication.Personal_Guarantor_First_Name__c;
//                lexisNexisAuthorizedRepresenative.lastName = naApplication.Personal_Guarantor_Last_Name__c;
//                lexisNexisAuthorizedRepresenative.streetAddress = naApplication.Personal_Guarantor_Mailing_Street__c;
//                lexisNexisAuthorizedRepresenative.city = naApplication.Personal_Guarantor_Mailing_City__c;
//                lexisNexisAuthorizedRepresenative.state = naApplication.Personal_Guarantor_Mailing_State__c;
//                lexisNexisAuthorizedRepresenative.postalCode = naApplication.Personal_Guarantor_Mailing_Zip__c;
//
//                lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{ lexisNexisAuthorizedRepresenative };
//
//            }
//
//            CreditWS_LexisNexisRDP.LexisNexisSBAResponse lexisNexisSBAResponse = CreditWS_LexisNexisRDP.lexisNexisSmallBusinessAnalytics(lexisNexisSBARequest);
//
//            naApplication.Lexis_Nexis_Custom_Model_Score__c = lexisNexisSBAResponse.fraudScore;
//
//            // Lexis Nexis - BIID
//            System.debug('Running LN BIID....');
//            CreditWS_LexisNexisRDP.LexisNexisBIIDRequest lexisNexisBIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisBIIDRequest();
//
//            lexisNexisBIIDRequest.applicationId = naApplication.Id;
//            lexisNexisBIIDRequest.businessName = naApplication.Opportunity_Name_Text__c;
//            lexisNexisBIIDRequest.streetAddress = naApplication.Billing_Street__c;
//            lexisNexisBIIDRequest.city = naApplication.Billing_City__c;
//            lexisNexisBIIDRequest.state = naApplication.Billing_State__c;
//            lexisNexisBIIDRequest.postalCode = naApplication.Billing_Zip_Postal_Code__c;
//            lexisNexisBIIDRequest.phoneNumber = naApplication.Business_Phone_Number__c;
//            lexisNexisBIIDRequest.federalTaxId = naApplication.Tax_Payer_ID_number__c;
//
//            if(naApplication.Personal_Guarantor__c != null) {
//
//                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();
//
//                lexisNexisAuthorizedRepresenative.firstName = naApplication.Personal_Guarantor_First_Name__c;
//                lexisNexisAuthorizedRepresenative.lastName = naApplication.Personal_Guarantor_Last_Name__c;
//                lexisNexisAuthorizedRepresenative.streetAddress = naApplication.Personal_Guarantor_Mailing_Street__c;
//                lexisNexisAuthorizedRepresenative.city = naApplication.Personal_Guarantor_Mailing_City__c;
//                lexisNexisAuthorizedRepresenative.state = naApplication.Personal_Guarantor_Mailing_State__c;
//                lexisNexisAuthorizedRepresenative.postalCode = naApplication.Personal_Guarantor_Mailing_Zip__c;
//
//                lexisNexisBIIDRequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{
//                        lexisNexisAuthorizedRepresenative
//                };
//
//            }
//
//            CreditWS_LexisNexisRDP.LexisNexisBIIDResponse lexisNexisBIIDResponse = CreditWS_LexisNexisRDP.lexisNexisBusinessInstantID(lexisNexisBIIDRequest);
//
//            System.debug(lexisNexisBIIDResponse);
//
//            if(lexisNexisBIIDResponse != null && !String.isEmpty(lexisNexisBIIDResponse.biidWorkflowResult)) {
//
//                // set result in object
//                naApplication.Lexis_Nexis_BIID_Result__c = (lexisNexisBIIDResponse.biidWorkflowResult).capitalize();
//                naApplication.Lexis_Nexis_BIID_Score__c = lexisNexisBIIDResponse.biidScore;
//
//                // If we fail, go to Fraud Point
//                if(!(lexisNexisBIIDResponse.biidWorkflowResult).equalsIgnoreCase('pass') && naApplication.Personal_Guarantor__c != null) {
//
//                    CreditWS_LexisNexisRDP.LexisNexisIIDRequest lexisNexisIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisIIDRequest();
//
//                    LexisNexisIIDRequest.applicationId = naApplication.Id;
//                    lexisNexisIIDRequest.firstName = naApplication.Personal_Guarantor_First_Name__c;
//                    lexisNexisIIDRequest.lastName = naApplication.Personal_Guarantor_Last_Name__c;
//                    lexisNexisIIDRequest.streetAddress = naApplication.Personal_Guarantor_Mailing_Street__c;
//                    lexisNexisIIDRequest.city = naApplication.Personal_Guarantor_Mailing_City__c;
//                    lexisNexisIIDRequest.state = naApplication.Personal_Guarantor_Mailing_State__c;
//                    lexisNexisIIDRequest.postalCode = naApplication.Personal_Guarantor_Mailing_Zip__c;
//                    lexisNexisIIDRequest.phoneNumber = naApplication.Personal_Guarantor_Home_Phone__c;
//                    lexisNexisIIDRequest.socialSecurityNumber = naApplication.Personal_Guarantor_SSN__c;
//
//                    CreditWS_LexisNexisRDP.LexisNexisIIDResponse lexisNexisIIDResponse = CreditWS_LexisNexisRDP.lexisNexisConsumerInstantId(LexisNexisIIDRequest);
//
//                    naApplication.Lexis_Nexis_FraudPoint_Score__c = lexisNexisIIDResponse.fraudPointScore;
//                    naApplication.Lexis_Nexis_FraudPoint_Result__c = (lexisNexisIIDResponse.fraudPointWorkflowResult).capitalize();
//                    naApplication.Lexis_Nexis_IID_Result__c = (lexisNexisIIDResponse.iidWorkflowResult).capitalize();
//                    naApplication.Lexis_Nexis_CVI_Score__c = lexisNexisIIDResponse.cviScore;
//
//                }
//
//            }

            // DNB Resolution. IADJUDCIAT-739 use a constructor for apprequests
            System.debug('Running DNB Matching....');
            CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest(naApplication);

            CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates.size() == 1 && dnbDirectMatchResponse.matchCandidates[0].OperatingStatus != null && (dnbDirectMatchResponse.matchCandidates[0].OperatingStatus).equalsIgnoreCase('Active')) {

                //Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components - Uttam Bharadwaj
                naApplication.DNB_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchGradeString;
                naApplication.DNB_Street_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StreetNameMatchGradeString;
                naApplication.DNB_State_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StateMatchGradeString;
                naApplication.DNB_Street_Number_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StreetNumberMatchGradeString;
                naApplication.DNB_City_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].CityMatchGradeString;
                naApplication.DNB_Postal_Code_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].PostalCodeMatchGradeString;
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
                System.debug('Running DNB BPAV....');
                BREeze.ProcessRules.ruleDataSet breezeResults = BREeze.ProcessRules.processRuleLogic('NACreditDecisioningBPAVMatch', new List<SObject>{naApplication});

                if(breezeResults.records != null && breezeResults.records[0].get('BPAV_Check__c') != null && (breezeResults.records[0].get('BPAV_Check__c').toString()).equalsIgnoreCase('Passed')) {

                    naApplication.Automatically_Generated_Number__c = dnbDirectMatchResponse.matchCandidates[0].AGN;
                    naApplication.DUNS_Number__c = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;

                    if (dnbDirectMatchResponse.matchCandidates[0].DUNSNumber != null) {
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

                            } else {
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

                            } else {
                                naApplication.DNB_Score__c = 0;
                            }

                        }
                    }
                } else if(dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null){
                    dnbDirectMatchRequest.SingleResolution = false;
                    dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);
                }

            } else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                dnbDirectMatchRequest.SingleResolution = false;
                dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            }

            // GIACT - only available for US applicants
            System.debug('Running GIACT....');
            if(!String.isBlank(naApplication.Checking_Account_Number__c) && !String.isBlank(naApplication.ABA_Routing_Number__c) && naApplication.Physical_Country__c.equalsIgnoreCase('US')) {

                CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

                giactVerifyRequest.UniqueId = String.valueOf(naApplication.Id);
                giactVerifyRequest.RoutingNumber = naApplication.ABA_Routing_Number__c;
                giactVerifyRequest.AccountNumber = naApplication.Checking_Account_Number__c;
                giactVerifyRequest.BusinessName = naApplication.Opportunity_Name_Text__c;
                giactVerifyRequest.FederalTaxId = naApplication.Tax_Payer_ID_number__c;

                if (!TestUtils.isRunningTest()) {

                    CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

                    if (giactVerifyResponse != null && giactVerifyResponse.AccountResponseCode.equals('12')) {
                        // if GIACT returned with a verified checking account but incorrect name and or tax id, re-run using PG information
                        if (giactVerifyResponse.CustomerResponseCode.equals('1') && naApplication.Personal_Guarantor_First_Name__c != null && naApplication.Personal_Guarantor_Last_Name__c != null && naApplication.Personal_Guarantor_SSN__c != null) {
                            //re-run using both PG name and SSN
                            System.debug('Re-running GIACT using PG name and SSN...');
                            giactVerifyRequest.FirstName = naApplication.Personal_Guarantor_First_Name__c;
                            giactVerifyRequest.LastName = naApplication.Personal_Guarantor_Last_Name__c;
                            giactVerifyRequest.FederalTaxId = naApplication.Personal_Guarantor_SSN__c;
                            giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                        }
                        if (giactVerifyResponse.CustomerResponseCode.equals('1') && naApplication.Personal_Guarantor_First_Name__c != null && naApplication.Personal_Guarantor_Last_Name__c != null) {
                            //re-run using both PG name
                            System.debug('Re-running GIACT using PG name...');
                            giactVerifyRequest.FirstName = naApplication.Personal_Guarantor_First_Name__c;
                            giactVerifyRequest.LastName = naApplication.Personal_Guarantor_Last_Name__c;
                            giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                        }
                        if (giactVerifyResponse.CustomerResponseCode.equals('1') && naApplication.Personal_Guarantor_SSN__c != null) {
                            //re-run using both PG SSN
                            System.debug('Re-running GIACT using PG SSN...');
                            giactVerifyRequest.FederalTaxId = naApplication.Personal_Guarantor_SSN__c;
                            giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                        }
                    }


                    if (giactVerifyResponse != null && String.isBlank(giactVerifyResponse.GiactErrorMessage))   {

                        naApplication.GIACT_Account_Response_Code__c = giactVerifyResponse.AccountResponseCode;
                        naApplication.GIACT_Account_Response_Message__c = giactVerifyResponse.AccountResponseMessage;
                        naApplication.GIACT_Response_Code__c = giactVerifyResponse.VerificationResponseCode;
                        naApplication.GIACT_Response_Message__c = giactVerifyResponse.VerificationResponseMessage;

                        naApplication.GIACT_Account_Response_Code_Name__c = giactVerifyResponse.AccountResponseCodeName;
                        naApplication.GIACT_Verify_Response_Code_Name__c = giactVerifyResponse.VerificationResponseCodeName;

                        naApplication.GIACT_Customer_Response_Code__c = giactVerifyResponse.CustomerResponseCode;
                        naApplication.GIACT_Customer_Response_Message__c = giactVerifyResponse.CustomerResponseCodeMessage;
                        naApplication.GIACT_Customer_Response_Code_Name__c = giactVerifyResponse.CustomerResponseCodeName;

                    } else {

                        naApplication.GIACT_Check__c = 'Error';
                        if(giactVerifyResponse != null) {
                            naApplication.GIACT_Response_Message__c = giactVerifyResponse.GiactErrorMessage;
                        }
                    }
                }
            }


            // Existing Exposure - Application/Account Exposure
            System.debug('Running Existing Exposure....');
            CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();
            existingExposureRequest.applicationId = naApplication.Id;
            existingExposureRequest.applicationName = naApplication.Name;
            existingExposureRequest.legalBusinessName = String.escapeSingleQuotes(naApplication.Opportunity_Name_Text__c);
            existingExposureRequest.addressLine1 = naApplication.Physical_Street__c;
            existingExposureRequest.city = naApplication.Physical_City__c;
            existingExposureRequest.state = naApplication.Physical_State__c;
            existingExposureRequest.postalCode = naApplication.Physical_Zip_Postal_Code__c;
            existingExposureRequest.fraudFlag = naApplication.Fraud_Flag__c;
            existingExposureRequest.phone = naApplication.Business_Phone_Number__c;
            existingExposureRequest.taxID = naApplication.Tax_Payer_ID_number__c;
            existingExposureRequest.duns = naApplication.DNB_Resolved_DUNS__c;
            existingExposureRequest.pgSSN = naApplication.Personal_Guarantor_SSN__c;

            List<CreditUtil_ExistingExposure.ExistingExposureApplications> existingExposureApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);
            List<CreditUtil_ExistingExposure.ExistingExposureAccounts> existingExposureAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);

            for (CreditUtil_ExistingExposure.ExistingExposureApplications existingExposureApplication : existingExposureApplications) {
                if (existingExposureApplication.fraudFlag) {
                    naApplication.Previous_Fraud__c = true;
                }
            }

            // Upsert and execute BREeze
            naApplication.Number_of_Existing_Applications__c = existingExposureApplications.size();
            naApplication.Number_of_Existing_Accounts__c = existingExposureAccounts.size();

            //IADJUDICAT-739 wait until the last moment to set dnb hits bc we live life on the edge
            if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null)
                naApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
            else
                    naApplication.DNB_Lookup_Hits__c = 0;

            upsert naApplication;

            // Make a safe copy so we don't overwrite any fields
            List<Application_Request__c> naApplications = [SELECT Id, Running_Credit_Decisioning__c FROM Application_Request__c WHERE Id = :naApplication.Id];

            if (naApplications.size() > 0) {

                // Flag the Credit Decision Engine as not running
                naApplications[0].Running_Credit_Decisioning__c = false;

                upsert naApplications;
            }


            // Run counter-offer processes
            naApplications = [SELECT Id, PG_Required__c, PG_Data__c, Personal_Guarantor__c, Personal_Guarantor_Mailing_Country__c, Opportunity__r.Pull_PG_Credit__c, PG_FICO_Score__c FROM Application_Request__c WHERE Id = :naApplication.Id];

            if (naApplications.size() > 0) {

                Boolean sendToFinalDecision = true;
                Application_Request__c appRequest = naApplications[0];

                if (appRequest.PG_Required__c == true
                        && appRequest.Personal_Guarantor__c != null
                        && (appRequest.Opportunity__r.Pull_PG_Credit__c == null || appRequest.Opportunity__r.Pull_PG_Credit__c.equalsIgnoreCase('Yes'))
                        && appRequest.PG_FICO_Score__c == null // the PG's credit has not already been run
                        && !TestUtils.isRunningTest()) {

                    if(appRequest.Personal_Guarantor_Mailing_Country__c == null || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('US') || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('United States')) {
                        System.debug('Running Experian....');
                        CreditDecisionEngineQueueable.runExperianPGChecks(naApplications[0].Id);
                        sendToFinalDecision = false;
                    }
                    else if (appRequest.Personal_Guarantor_Mailing_Country__c != null && (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('CA') || (appRequest.Personal_Guarantor_Mailing_Country__c).equalsIgnoreCase('Canada')) {
                        System.debug('Running Equifax....');
                        CreditDecisionEngineQueueable.runEquifaxPGChecks(appRequest.Id);
                        sendToFinalDecision = false;
                    }
                }
                if (sendToFinalDecision) {
                    runFinalCreditDecision(appRequest);
                }
            }

        }


    public static void runFinalCreditDecision(Application_Request__c appRequest) {

        String query = UtilityClass.selectStar('Application_Request__c');
        Id appId = appRequest.Id;
        query += 'WHERE Id = :appId';

        try {

            appRequest = (Application_Request__c) Database.query(query);
            BREeze.ProcessRules.processRuleLogic('NAFraudDecisioningFraudDecision', new List<SObject>{
                    appRequest
            });
            BREeze.ProcessRules.processRuleLogic('NACreditDecisioningCalculateRecommendedDecision', new List<SObject>{
                    appRequest
            });
            upsert appRequest;
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'CreditDecisionEngineNA.runFinalCreditDecision', true, '', appRequest.id);
        }
    }
}