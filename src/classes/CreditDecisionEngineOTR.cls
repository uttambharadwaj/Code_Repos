/*
*
* Credit Decisioning Process
* Module: Main Runner
* Author: Derek Gilbert
* Initial Date: 3/26/2018
* Revision History: 4/23/2019 Jason Arbegast IADJUDICAT-1188 escape single quotes on business name
*                   4/25/2019 IADJUDICAT-739 move dnb lookup logic to just before upsert; gotta wait for that response; also do the constructor thing
*                   3/26/2020: Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components - Uttam Bharadwaj
*                   5/4/2020: Release 20.09: EAPT-1618: Added a check for Legal Structure vs Company Name
*/
global class CreditDecisionEngineOTR {

    public static Boolean decisionEngineRunning = false;

    // If called from a button
    webservice static void runOTRDecisioningProcessButton(Id onlineApplicationId) {
        runHandler(onlineApplicationId);
    }

    @future(callout=true)
    public static void runOTRDecisioningProcessFuture(Id onlineApplicationId) {
        runHandler(onlineApplicationId);
    }

    /**
     * Allows the application to still run through the final decision business logic rules without doing
     * any callouts or any other business logic. If there are other scenarios that need this in the future, add
     * an additional if else.
     * If you need to bypass the entire credit decision engine, including the final decision use the
     * Disable_Instant_Decisioning__c checkbox on the OnlineApplication, Opty, or Program.
     */
    private static Boolean bypassCallouts(OnlineApplication__c onlineApp) {
        Boolean bypassCallouts = false;
        if (onlineApp.Application_Type__c != null && onlineApp.Application_Type__c.equalsIgnoreCase('Credit Reallocation') && onlineApp.Credit_Line_Requested__c == 1) {
            bypassCallouts = true;
        }
        return bypassCallouts;
    }

    public static void runHandler(Id onlineApplicationId) {

        List<OnlineApplication__c> onlineApplications = [
                SELECT Id, Automatically_Generated_Number__c, Name, Legal_Business_Name__c, Application_Stage__c, ThreatMetrix_Request_ID__c, ThreatMetrix_Session_ID__c,
                        ThreatMetrix_Result__c, Sanctions_Business_Check__c, Sanctions_Individual_Check__c, ABA_Routing_Number__c, Checking_Account_Number__c,
                        Business_Street_Address__c, City__c, State__c, Zip_Code__c, Sanctions_Individual_Result_ID__c, Contact_First_Name__c, Contact_Last_Name__c, AO_First_Name__c, AO_Last_Name__c,
                        AO_Name__c, AO_Work_Email__c, AO_Address__c, AO_City__c, Contact_Name__c, AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c, Running_Credit_Decisioning__c,
                        DUNS__c, PG_Required__c, Type_of_Business__c, AO_Home_Phone_Number__c, Program__c, CreatedBy.Alias, Fraud_Flag__c, Previous_Fraud__c, Opportunity__c,
                        Opportunity__r.SourceSystem__c, Account__r.Name, Trade_Name__c, Federal_Tax_ID__c, Card_Shipping_Address_Line_1__c, Card_Shipping_City__c, Card_Shipping_State__c,
                        Card_Shipping_Postal_Code__c, Email__c, Phone_Number__c, IP_Address__c, Credit_Line_Requested__c, Application_Signer_IP__c, DNB_Credit_Line_Recommendation__c,
                        DNB_Reason_Code__c,Team_Drivers_Slip_Seat__c, Number_of_Trucks__c, DNB_Confidence_Code__c, DOT_Number__c, DNB_Resolved_DUNS__c, Country__c,
                        Business_Address_Line_2__c, Bureau_Tax_ID__c, Offer__r.Funding__c, BPAV_Check__c, Application_Type__c, Credit_Analyst__c, Charged_Off_Account_Found__c, DNB_Name_Match_Score__c
                FROM OnlineApplication__c
                WHERE Id = :onlineApplicationId
        ];

        if (onlineApplications.size() > 0 && onlineApplications[0].Offer__r.Funding__c !='Parent Funded') {

            OnlineApplication__c onlineApp = onlineApplications[0];
            if (!bypassCallouts(onlineApp)) {
                runOTRDecisioningProcess(onlineApp);
            } else {
                System.debug('Bypassing callouts...');
                runFinalCreditDecision(onlineApp);
            }
        }
    }

    public static void runOTRDecisioningProcess(OnlineApplication__c onlineApplication) {

        decisionEngineRunning = true;

        onlineApplication.Running_Credit_Decisioning__c = true;

        // Check for Legal Structure Matching Company Name for US as a Physical Country
        // EAPT - 1618
        if (onlineApplication.Country__c == 'US' && null != onlineApplication.Legal_Business_Name__c && null != onlineApplication.Type_of_Business__c){

            System.debug('Checking for Legal Structure Issues...');

            onlineApplication.Legal_Name_Matches_Company_Name__c = CreditWS_Utils.checkLegalStructure(onlineApplication.Legal_Business_Name__c, onlineApplication.Type_of_Business__c);
        }

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

        lexisNexisBridgerBusinessRequest.companyName = String.escapeSingleQuotes(onlineApplication.Legal_Business_Name__c);//IADJUDICAT-1188 get those singlies outta there
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

        //EAPT-1562 retiring LN RDP / BIID / CVI but I don't trust they won't re-add it. Going to leave it just commented out for a while then delete.
        // Lexis Nexis RDP - SBA
//            System.debug('Running Lexis Nexis RDP...');
//            CreditWS_LexisNexisRDP.LexisNexisSBARequest lexisNexisSBARequest = new CreditWS_LexisNexisRDP.LexisNexisSBARequest();
//
//            lexisNexisSBARequest.companyName = onlineApplication.Legal_Business_Name__c;
//            lexisNexisSBARequest.streetAddress = onlineApplication.Business_Street_Address__c;
//            lexisNexisSBARequest.city = onlineApplication.City__c;
//            lexisNexisSBARequest.state = onlineApplication.State__c;
//            lexisNexisSBARequest.postalCode = onlineApplication.Zip_Code__c;
//            lexisNexisSBARequest.phoneNumber = onlineApplication.Phone_Number__c;
//            lexisNexisSBARequest.federalTaxId = onlineApplication.Federal_Tax_ID__c;
//
//            if(!String.isEmpty(onlineApplication.AO_Address__c) && !String.isEmpty(onlineApplication.AO_City__c) && !String.isEmpty(onlineApplication.AO_State__c) && !String.isEmpty(onlineApplication.AO_Zip_Code__c)) {
//
//                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();
//
//                lexisNexisAuthorizedRepresenative.firstName = onlineApplication.Contact_First_Name__c;
//                lexisNexisAuthorizedRepresenative.lastName = onlineApplication.Contact_Last_Name__c;
//                lexisNexisAuthorizedRepresenative.streetAddress = onlineApplication.AO_Address__c;
//                lexisNexisAuthorizedRepresenative.city = onlineApplication.AO_City__c;
//                lexisNexisAuthorizedRepresenative.state = onlineApplication.AO_State__c;
//                lexisNexisAuthorizedRepresenative.postalCode = onlineApplication.AO_Zip_Code__c;
//
//                lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{ lexisNexisAuthorizedRepresenative };
//
//            }
//
//            CreditWS_LexisNexisRDP.LexisNexisSBAResponse lexisNexisSBAResponse = CreditWS_LexisNexisRDP.lexisNexisSmallBusinessAnalytics(lexisNexisSBARequest);
//
//            onlineApplication.Lexis_Nexis_Custom_Model_Score__c = lexisNexisSBAResponse.fraudScore;
//
//            // Lexis Nexis - BIID
//            CreditWS_LexisNexisRDP.LexisNexisBIIDRequest lexisNexisBIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisBIIDRequest();
//
//            lexisNexisBIIDRequest.applicationId = onlineApplication.Id;
//            lexisNexisBIIDRequest.businessName = onlineApplication.Legal_Business_Name__c;
//            lexisNexisBIIDRequest.streetAddress = onlineApplication.Business_Street_Address__c;
//            lexisNexisBIIDRequest.city = onlineApplication.City__c;
//            lexisNexisBIIDRequest.state = onlineApplication.State__c;
//            lexisNexisBIIDRequest.postalCode = onlineApplication.Zip_Code__c;
//            lexisNexisBIIDRequest.phoneNumber = onlineApplication.Phone_Number__c;
//            lexisNexisBIIDRequest.federalTaxId = onlineApplication.Federal_Tax_ID__c;
//
//            if(!String.isEmpty(onlineApplication.AO_Address__c) && !String.isEmpty(onlineApplication.AO_City__c) && !String.isEmpty(onlineApplication.AO_State__c) && !String.isEmpty(onlineApplication.AO_Zip_Code__c)) {
//
//                CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();
//
//                lexisNexisAuthorizedRepresenative.firstName = onlineApplication.Contact_First_Name__c;
//                lexisNexisAuthorizedRepresenative.lastName = onlineApplication.Contact_Last_Name__c;
//                lexisNexisAuthorizedRepresenative.streetAddress = onlineApplication.AO_Address__c;
//                lexisNexisAuthorizedRepresenative.city = onlineApplication.AO_City__c;
//                lexisNexisAuthorizedRepresenative.state = onlineApplication.AO_State__c;
//                lexisNexisAuthorizedRepresenative.postalCode = onlineApplication.AO_Zip_Code__c;
//
//                lexisNexisBIIDRequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>{
//                        lexisNexisAuthorizedRepresenative
//                };
//
//            }
//
//            CreditWS_LexisNexisRDP.LexisNexisBIIDResponse lexisNexisBIIDResponse = CreditWS_LexisNexisRDP.lexisNexisBusinessInstantID(lexisNexisBIIDRequest);
//
//            if(lexisNexisBIIDResponse != null && !String.isEmpty(lexisNexisBIIDResponse.biidWorkflowResult)) {
//
//                // set result in object
//                onlineApplication.Lexis_Nexis_BIID_Result__c = (lexisNexisBIIDResponse.biidWorkflowResult).capitalize();
//                onlineApplication.Lexis_Nexis_BIID_Score__c = lexisNexisBIIDResponse.biidScore;
//
//                // If we fail, go to Fraud Point
//                if(!(lexisNexisBIIDResponse.biidWorkflowResult).equalsIgnoreCase('pass') && !String.isEmpty(onlineApplication.AO_Address__c) && !String.isEmpty(onlineApplication.AO_City__c)
//                        && !String.isEmpty(onlineApplication.AO_State__c) && !String.isEmpty(onlineApplication.AO_Zip_Code__c)) {
//
//                    CreditWS_LexisNexisRDP.LexisNexisIIDRequest lexisNexisIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisIIDRequest();
//
//                    LexisNexisIIDRequest.applicationId = onlineApplication.Id;
//                    lexisNexisIIDRequest.firstName = onlineApplication.Contact_First_Name__c;
//                    lexisNexisIIDRequest.lastName = onlineApplication.Contact_Last_Name__c;
//                    lexisNexisIIDRequest.streetAddress = onlineApplication.AO_Address__c;
//                    lexisNexisIIDRequest.city = onlineApplication.AO_City__c;
//                    lexisNexisIIDRequest.state = onlineApplication.AO_State__c;
//                    lexisNexisIIDRequest.postalCode = onlineApplication.AO_Zip_Code__c;
//                    lexisNexisIIDRequest.phoneNumber = onlineApplication.AO_Home_Phone_Number__c;
//                    lexisNexisIIDRequest.socialSecurityNumber = onlineApplication.AO_Social_Security_Number__c;
//
//                    CreditWS_LexisNexisRDP.LexisNexisIIDResponse lexisNexisIIDResponse = CreditWS_LexisNexisRDP.lexisNexisConsumerInstantId(LexisNexisIIDRequest);
//
//                    onlineApplication.Lexis_Nexis_FraudPoint_Score__c = lexisNexisIIDResponse.fraudPointScore;
//                    onlineApplication.Lexis_Nexis_FraudPoint_Result__c = (lexisNexisIIDResponse.fraudPointWorkflowResult).capitalize();
//                    onlineApplication.Lexis_Nexis_IID_Result__c = (lexisNexisIIDResponse.iidWorkflowResult).capitalize();
//                    onlineApplication.Lexis_Nexis_CVI_Score__c = lexisNexisIIDResponse.cviScore;
//
//                }
//
//            }

        // SAFER
        System.debug('Running SAFER Matching...');

        if (onlineApplication.DOT_Number__c != null && !onlineApplication.DOT_Number__c.equals('')) {
            List<SAFER_Carrier__c> saferCarriers = [SELECT Id, DOT_Number__c, Name from SAFER_Carrier__c where DOT_Number__c = :onlineApplication.DOT_Number__c];

            if (saferCarriers.size() > 0) {

                Double matchPercentage = 0;

                if (saferCarriers[0].Name != null) {
                    // validate business name
                    matchPercentage = JaroWinklerDistance.getScore(onlineApplication.Legal_Business_Name__c, saferCarriers[0].Name);
                    System.debug('SAFER Name Match Percentage: ' + matchPercentage);

                    // having the SAFER Carrier ID populated will signify it's good to use for BPAV
                    if (matchPercentage >= .75) {
                        onlineApplication.SAFER_Carrier__c = saferCarriers[0].Id;
                    }
                }
            }
        }

        // DNB Resolution
        System.debug('Running DNB Matching...');

        //IADJUDICAT 739 set up constructor for our class that uses online app.
        CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest(onlineApplication);

        CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

        if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates.size() == 1 && dnbDirectMatchResponse.matchCandidates[0].OperatingStatus != null && (dnbDirectMatchResponse.matchCandidates[0].OperatingStatus).equalsIgnoreCase('Active')) {

            //Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components - Uttam Bharadwaj
            onlineApplication.DNB_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchGradeString;
            onlineApplication.DNB_Street_Name_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StreetNameMatchGradeString;
            onlineApplication.DNB_State_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StateMatchGradeString;
            onlineApplication.DNB_Street_Number_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].StreetNumberMatchGradeString;
            onlineApplication.DNB_City_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].CityMatchGradeString;
            onlineApplication.DNB_Postal_Code_Match_Grade__c = dnbDirectMatchResponse.matchCandidates[0].PostalCodeMatchGradeString;
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
            onlineApplication.DNB_Name_Match_Score__c = dnbDirectMatchResponse.matchCandidates[0].NameMatchScore;

            // Execute BREeze for pre-processing
            BREeze.ProcessRules.ruleDataSet breezeResults = BREeze.ProcessRules.processRuleLogic('OTRCreditDecisioningBPAVMatch', new List<SObject>{
                    onlineApplication
            });

            Boolean pullCredit = pullCredit(breezeResults, onlineApplication.DUNS__c);
            System.debug('Pull Commercial Credit: ' + pullCredit);

            if (pullCredit) {

                System.debug('Running DNB...');
                onlineApplication.DUNS__c = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                onlineApplication.Automatically_Generated_Number__c = dnbDirectMatchResponse.matchCandidates[0].AGN;

                if (dnbDirectMatchResponse.matchCandidates[0].DUNSNumber != null) {
                    if (onlineApplication.Country__c == null || (onlineApplication.Country__c).equalsIgnoreCase('US')) {

                        CreditWS_DNB.DNBOTRModelRequest dnbOTRModelRequest = new CreditWS_DNB.DNBOTRModelRequest();

                        dnbOTRModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbOTRModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(onlineApplication.Credit_Line_Requested__c));
                        dnbOTRModelRequest.TeamDriversSlipSeat = onlineApplication.Team_Drivers_Slip_Seat__c;
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
                        } else {
                            onlineApplication.DNB_Score__c = 0;
                        }

                    } else if (onlineApplication.Country__c != null && (onlineApplication.Country__c).equalsIgnoreCase('CA')) {

                        CreditWS_DNB.DNBCAModelRequest dnbCAModelRequest = new CreditWS_DNB.DNBCAModelRequest();

                        dnbCAModelRequest.DnB_DUNS_Number = dnbDirectMatchResponse.matchCandidates[0].DUNSNumber;
                        dnbCAModelRequest.RequestedCreditLimit = String.valueOf(Integer.valueOf(onlineApplication.Credit_Line_Requested__c));
                        dnbCAModelRequest.Platforms = 'OTR';
                        dnbCAModelRequest.TeamDriversSlipSeat = onlineApplication.Team_Drivers_Slip_Seat__c;
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
                        } else {
                            onlineApplication.DNB_Score__c = 0;
                        }

                    }

                }
            }
            else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

                dnbDirectMatchRequest.SingleResolution = false;
                dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            }

        } else if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null) {

            dnbDirectMatchRequest.SingleResolution = false;
            dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

            System.debug('Failed to verify business via DNB, attempt to user SAFER...');
            BREeze.ProcessRules.processRuleLogic('OTRCreditDecisioningBPAVMatch', new List<SObject>{
                    onlineApplication
            });
        }

        // Existing Exposure - Application/Account Exposure
        System.debug('Running Existing Exposure...');
        CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();

        existingExposureRequest.applicationId = onlineApplication.Id;
        existingExposureRequest.applicationName = onlineApplication.Name;
        existingExposureRequest.legalBusinessName = String.escapeSingleQuotes(onlineApplication.Legal_Business_Name__c);//IADJUDICAT-1188 get those singlies outta there
        existingExposureRequest.addressLine1 = onlineApplication.Business_Street_Address__c;
        existingExposureRequest.city = onlineApplication.City__c;
        existingExposureRequest.state = onlineApplication.State__c;
        existingExposureRequest.postalCode = onlineApplication.Zip_Code__c;
        existingExposureRequest.fraudFlag = onlineApplication.Fraud_Flag__c;
        existingExposureRequest.duns = onlineApplication.DNB_Resolved_DUNS__c;
        existingExposureRequest.taxID = onlineApplication.Federal_Tax_ID__c;
        existingExposureRequest.phone = onlineApplication.Phone_Number__c;
        existingExposureRequest.pgSSN = onlineApplication.AO_Social_Security_Number__c;

        List<CreditUtil_ExistingExposure.ExistingExposureApplications> existingExposureApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);
        List<CreditUtil_ExistingExposure.ExistingExposureAccounts> existingExposureAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);

        for (CreditUtil_ExistingExposure.ExistingExposureApplications existingExposureApplication : existingExposureApplications) {
            if (existingExposureApplication.fraudFlag) {
                onlineApplication.Previous_Fraud__c = true;
            }
        }

        // GIACT - only available for US applicants
        System.debug('Running GIACT...');
        if(!String.isBlank(onlineApplication.ABA_Routing_Number__c) && !String.isBlank(onlineApplication.Checking_Account_Number__c) && onlineApplication.Country__c.equalsIgnoreCase('US')) {

            CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

            giactVerifyRequest.UniqueId = String.valueOf(onlineApplication.Id);
            giactVerifyRequest.RoutingNumber = onlineApplication.ABA_Routing_Number__c;
            giactVerifyRequest.AccountNumber = onlineApplication.Checking_Account_Number__c;
            giactVerifyRequest.BusinessName = String.escapeSingleQuotes(onlineApplication.Legal_Business_Name__c);//IADJUDICAT-1188 be gone, singlies
            giactVerifyRequest.FederalTaxId = onlineApplication.Federal_Tax_ID__c;

            if (!TestUtils.isRunningTest()) {

                CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

                if (giactVerifyResponse != null && String.isBlank(giactVerifyResponse.GiactErrorMessage) && giactVerifyResponse.AccountResponseCode.equals('12')) {
                    // if GIACT returned with a verified checking account but incorrect name and or tax id, re-run using PG information
                    if (giactVerifyResponse.CustomerResponseCode.equals('1') && onlineApplication.AO_First_Name__c != null && onlineApplication.AO_Last_Name__c != null && onlineApplication.AO_Social_Security_Number__c != null) {
                        //re-run using both PG name and SSN
                        System.debug('Re-running GIACT using PG name and SSN...');
                        giactVerifyRequest.BusinessName = null;
                        giactVerifyRequest.FirstName = onlineApplication.AO_First_Name__c;
                        giactVerifyRequest.LastName = onlineApplication.AO_Last_Name__c;
                        giactVerifyRequest.FederalTaxId = onlineApplication.AO_Social_Security_Number__c;
                        giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                    }
                    else if (giactVerifyResponse.CustomerResponseCode.equals('3') && onlineApplication.AO_First_Name__c != null && onlineApplication.AO_Last_Name__c != null) {
                        //re-run using both PG name
                        System.debug('Re-running GIACT using PG name...');
                        giactVerifyRequest.BusinessName = null;
                        giactVerifyRequest.FirstName = onlineApplication.AO_First_Name__c;
                        giactVerifyRequest.LastName = onlineApplication.AO_Last_Name__c;
                        giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                    }
                    else if (giactVerifyResponse.CustomerResponseCode.equals('4') && onlineApplication.AO_Social_Security_Number__c != null) {
                        //re-run using both PG SSN
                        System.debug('Re-running GIACT using PG SSN...');
                        giactVerifyRequest.FederalTaxId = onlineApplication.AO_Social_Security_Number__c;
                        giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);
                    }
                }


                if (giactVerifyResponse != null && String.isBlank(giactVerifyResponse.GiactErrorMessage))   {

                    onlineApplication.GIACT_Account_Response_Code__c = giactVerifyResponse.AccountResponseCode;
                    onlineApplication.GIACT_Account_Response_Message__c = giactVerifyResponse.AccountResponseMessage;
                    onlineApplication.GIACT_Response_Code__c = giactVerifyResponse.VerificationResponseCode;
                    onlineApplication.GIACT_Response_Message__c = giactVerifyResponse.VerificationResponseMessage;

                    onlineApplication.GIACT_Account_Response_Code_Name__c = giactVerifyResponse.AccountResponseCodeName;
                    onlineApplication.GIACT_Verify_Response_Code_Name__c = giactVerifyResponse.VerificationResponseCodeName;

                    onlineApplication.GIACT_Customer_Response_Code__c = giactVerifyResponse.CustomerResponseCode;
                    onlineApplication.GIACT_Customer_Response_Message__c = giactVerifyResponse.CustomerResponseCodeMessage;
                    onlineApplication.GIACT_Customer_Response_Code_Name__c = giactVerifyResponse.CustomerResponseCodeName;

                } else {

                    onlineApplication.GIACT_Check__c = 'Error';
                    if(giactVerifyResponse != null) {
                        onlineApplication.GIACT_Response_Message__c = giactVerifyResponse.GiactErrorMessage;
                    }
                }
            }
        }


        onlineApplication.Application_Exposure_Hits__c = existingExposureApplications.size();
        onlineApplication.Existing_Account_Exposure_Hits__c = existingExposureAccounts.size();
        // iterate through the found existing Accounts to see if any have charge off balances
        for (CreditUtil_ExistingExposure.ExistingExposureAccounts existingAccounts : existingExposureAccounts) {
            if (existingAccounts.chargeOffAmount > 0) onlineApplication.Charged_Off_Account_Found__c = true;
        }

        //IADJUDICAT-739 wait until the last moment to set dnb hits bc we live life on the edge
        if (dnbDirectMatchResponse != null && dnbDirectMatchResponse.matchCandidates != null)
            onlineApplication.DNB_Lookup_Hits__c = dnbDirectMatchResponse.matchCandidates.size();
        else
            onlineApplication.DNB_Lookup_Hits__c = 0;

        // Upsert and execute BREeze
        upsert onlineApplication;

        // Make a safe copy so we don't overwrite any fields
        List<OnlineApplication__c> onlineApplications = [SELECT Id, Running_Credit_Decisioning__c FROM OnlineApplication__c WHERE Id = :onlineApplication.Id LIMIT 1];

        if (onlineApplications.size() > 0) {

            // Flag the Credit Decision Engine as not running
            onlineApplications[0].Running_Credit_Decisioning__c = false;

            upsert onlineApplications;

        }

        // Run counter-offer processes
        onlineApplications = [SELECT Id, PG_Required__c, PG_Data__c, AO_Country__c, Opportunity__r.Pull_PG_Credit__c, PG_Score__c FROM OnlineApplication__c WHERE Id = :onlineApplication.Id LIMIT 1];

        if (onlineApplications.size() > 0) {

            Boolean sendToFinalDecision = true;
            OnlineApplication__c onlineApp = onlineApplications[0];

            if (onlineApp.PG_Required__c == true
                    && (onlineApp.Opportunity__r.Pull_PG_Credit__c == null || onlineApp.Opportunity__r.Pull_PG_Credit__c.equalsIgnoreCase('Yes'))
                    && onlineApp.PG_Score__c == null // the PG's credit has not already been run
                    && !TestUtils.isRunningTest()) {

                if(onlineApp.AO_Country__c == null || (onlineApp.AO_Country__c).equalsIgnoreCase('US')) {
                    System.debug('Attemping to pull Experian credit report...');
                    CreditDecisionEngineQueueable.runExperianPGChecks(onlineApp.Id);
                    sendToFinalDecision = false;
                }
                else if(onlineApp.AO_Country__c != null && (onlineApp.AO_Country__c).equalsIgnoreCase('CA')) {
                    System.debug('Attemping to pull Equifax credit report...');
                    CreditDecisionEngineQueueable.runEquifaxPGChecks(onlineApp.Id);
                    sendToFinalDecision = false;
                }
            }

            if (sendToFinalDecision) {
                runFinalCreditDecision(onlineApp);
            }
        }
    }

    public static void runFinalCreditDecision(OnlineApplication__c onlineApplication) {

        String query = UtilityClass.selectStar('OnlineApplication__c');
        Id appId = onlineApplication.Id;
        query += 'WHERE Id = :appId';

        try {

            onlineApplication = (OnlineApplication__c) Database.query(query);
            BREeze.ProcessRules.processRuleLogic('OTRFraudDecisioningFraudDecision', new List<SObject>{
                    onlineApplication
            });
            BREeze.ProcessRules.processRuleLogic('OTRCreditDecisioningCalculateRecommendedDecision', new List<SObject>{
                    onlineApplication
            });
            upsert onlineApplication;
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'CreditDecisionEngineOTR.runFinalCreditDecision', true, '', onlineApplication.id);
        }
    }

    public static Boolean pullCredit(BREeze.ProcessRules.ruleDataSet breezeResults, String DUNS) {

        if (breezeResults.records != null && breezeResults.records[0].get('BPAV_Check__c') != null && (breezeResults.records[0].get('BPAV_Check__c').toString()).equalsIgnoreCase('Passed')) {
            return true;
        }
        else if (DUNS != null) {
            // if a credit analyst manually selected the business
            return true;
        }
        return false;
    }
}