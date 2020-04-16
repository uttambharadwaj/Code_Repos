/*
*
* Credit Decisioning Process
* Module: Lexis/Nexis
* Author: Derek Gilbert
* Initial Date: 3/5/2018
* Revision History: 4/25/2019 IADJUDICAT-739 make them wait longer for that response. also do the constructor w/ parameter thing
* 3/26/2020: Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components - Uttam Bharadwaj
*/
public class CreditWS_DNB {

    public final static String APPLICATION_NAME = 'Credit Decision Engine - DNB Integration';

    public static Credit_Decision_Engine_Endpoints__mdt dnbSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt dnbSettings = [SELECT Id, Username__c, Password__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'DNB_Toolkit'];

                return dnbSettings;

            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting DNB Toolkit connection settings.');

            }

            return null;

        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt dnbCustomModelSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt dnbSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'DNB_Custom_Model'];

                return dnbSettings;

            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting DNB Custom Model connection settings.');

            }

            return null;

        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt dnbCACustomModelSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt dnbSettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'CA_DNB_Custom_Model'];

                return dnbSettings;

            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting DNB CA Custom Model connection settings.');

            }

            return null;

        }
    }

    public static Credit_Decision_Engine_Endpoints__mdt dnbDirectSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt dnbSettings = [SELECT Id, Client_Key__c, Client_Secret__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'DNB_Direct_Plus'];

                return dnbSettings;

            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting DNB Direct 2.0 connection settings.');

            }

            return null;

        }
    }

    public class dnbCalloutException extends Exception {}

    public CreditWS_DNB() {

    }

    public static String dnbDirectAuthentication() {

        try {

            if (dnbDirectSettings != null) {

                HttpRequest authenticationRequest = new HttpRequest();
                authenticationRequest.setEndpoint(dnbDirectSettings.Endpoint_URL__c + '/V2/token');

                authenticationRequest.setMethod('POST');
                authenticationRequest.setHeader('Content-Type', 'application/json');

                authenticationRequest.setHeader('Authorization', 'Basic ' + dnbDirectSettings.Client_Key__c + ':' + dnbDirectSettings.Client_Secret__c);
                authenticationRequest.setBody('{ \"grant_type\" : \"client_credentials\" }');
                Http authenticationCallout = new Http();

                HTTPResponse authenticationResponse = authenticationCallout.send(authenticationRequest);

                CreditWSUtil_DNBDirect_Auth parsedAuthenticationResponse = CreditWSUtil_DNBDirect_Auth.parse(authenticationResponse.getBody());

                if((parsedAuthenticationResponse.TransactionResult.ResultText).equalsIgnoreCase('SUCCESS')) { // TODO verify response
                    return parsedAuthenticationResponse.access_token;
                }
                else {
                    throw new dnbCalloutException('### Error: Unable to log into DNB: ' + authenticationResponse.getBody());
                }

            }

        }
        catch(Exception e) {
            System.debug('### Error - ' + e.getLineNumber() + ' - ' + e.getMessage());
        }

        return null;

    }

    public static DNBDirect_MatchResponse dnbDirectClenseAndMatch(DNBDirect_MatchRequest dnbDirectMatchRequest) {

        DNBDirect_MatchResponse dnbDirectMatchResponse = new DNBDirect_MatchResponse();

        try {

            String authorizationToken = CreditWS_DNB.dnbDirectAuthentication();
            if(TestUtils.isRunningTest()) {
                authorizationToken = 'TESTTOKEN';
            }

            if (authorizationToken != null && dnbDirectMatchRequest != null) {

                HttpRequest clenseAndMatchRequest = new HttpRequest();

                clenseAndMatchRequest.setMethod('GET');
                clenseAndMatchRequest.setHeader('Authorization', 'Bearer ' + authorizationToken);

                Map<String, String> parameterStrings = new Map<String, String>();

                parameterStrings.put('CountryISOAlpha2Code', dnbDirectMatchRequest.CountryISOAlpha2Code);

                parameterStrings.put('DUNSNumber', dnbDirectMatchRequest.DUNSNumber);
                parameterStrings.put('SubjectName', dnbDirectMatchRequest.SubjectName);
                parameterStrings.put('StreetAddressLine1', dnbDirectMatchRequest.StreetAddressLine1);
                parameterStrings.put('StreetAddressLine2', dnbDirectMatchRequest.StreetAddressLine2);
                parameterStrings.put('PrimaryTownName', dnbDirectMatchRequest.PrimaryTownName);
                parameterStrings.put('TerritoryName', dnbDirectMatchRequest.TerritoryName);
                parameterStrings.put('FullPostalCode', dnbDirectMatchRequest.FullPostalCode);
                if(!String.isEmpty(dnbDirectMatchRequest.TelephoneNumber)) {
                    parameterStrings.put('TelephoneNumber', dnbDirectMatchRequest.TelephoneNumber);
                }

                if(dnbDirectMatchRequest.SingleResolution == true) {
                    parameterStrings.put('CandidateMaximumQuantity', '1');
                }

                parameterStrings.put('cleansematch', 'true');

                clenseAndMatchRequest.setEndpoint(dnbDirectSettings.Endpoint_URL__c + '/V6.0/organizations?' + CreditWS_Utils.buildHTTPCalloutParameterString(parameterStrings));
                clenseAndMatchRequest.setTimeout(120000); //IADJUDICAT-739 make them wait as long as possible. bc everyone needs a little break now and then

                Http cleanseRequestCallout = new Http();

                HTTPResponse cleanseAndMatchResponse = cleanseRequestCallout.send(clenseAndMatchRequest);

                System.debug('### Cleanse And Match Request: ' + clenseAndMatchRequest);

                // Dear DNB - why did you send a $ as a variable name?
                String jsonResponse = cleanseAndMatchResponse.getBody();
                jsonResponse = jsonResponse.replaceAll('"\\$":', '"value":');

                System.debug('### Cleanse And Match Response: ' + jsonResponse);

                CreditWSUtil_DNBDirect_Match cleanseAndMatchResult = CreditWSUtil_DNBDirect_Match.parse(jsonResponse);

                if(cleanseAndMatchResult != null) {

                    if (cleanseAndMatchResult.GetCleanseMatchResponse.TransactionResult.ResultID != null && (cleanseAndMatchResult.GetCleanseMatchResponse.TransactionResult.ResultID).equalsIgnoreCase('CM000')) {

                        if(cleanseAndMatchResult.GetCleanseMatchResponse.GetCleanseMatchResponseDetail.MatchResponseDetail.MatchDataCriteriaText != null &&
                                (cleanseAndMatchResult.GetCleanseMatchResponse.GetCleanseMatchResponseDetail.MatchResponseDetail.MatchDataCriteriaText.value).equalsIgnoreCase('DUNS Number Lookup')) {

                            dnbDirectMatchResponse.exactDUNSMatch = true;

                        }

                        for(CreditWSUtil_DNBDirect_Match.MatchCandidate result : cleanseAndMatchResult.GetCleanseMatchResponse.GetCleanseMatchResponseDetail.MatchResponseDetail.MatchCandidate) {

                            DNBDirect_MatchCandidate matchCandidate = new DNBDirect_MatchCandidate();

                            if(result.DUNSNumber != null) matchCandidate.DUNSNumber = result.DUNSNumber;
                            if(result.OrganizationPrimaryName.OrganizationName.value != null) matchCandidate.OrganizationName = result.OrganizationPrimaryName.OrganizationName.value;
                            if(result.PrimaryAddress.StreetAddressLine != null && result.PrimaryAddress.StreetAddressLine.size() > 0) matchCandidate.StreetAddressLine = result.PrimaryAddress.StreetAddressLine[0].LineText;
                            if(result.PrimaryAddress.PrimaryTownName != null) matchCandidate.PrimaryTownName = result.PrimaryAddress.PrimaryTownName;
                            if(result.PrimaryAddress.TerritoryAbbreviatedName != null) matchCandidate.TerritoryAbbreviatedName = result.PrimaryAddress.TerritoryAbbreviatedName;
                            if(result.PrimaryAddress.PostalCode != null) matchCandidate.PostalCode = result.PrimaryAddress.PostalCode;
                            if(result.PrimaryAddress.CountryISOAlpha2Code != null) matchCandidate.CountryISOAlpha2Code = result.PrimaryAddress.CountryISOAlpha2Code;
                            if(result.MatchQualityInformation.ConfidenceCodeValue != null) matchCandidate.ConfidenceCodeValue = result.MatchQualityInformation.ConfidenceCodeValue;
                            if(result.MatchQualityInformation.MatchGradeText != null) matchCandidate.MatchGradeText = result.MatchQualityInformation.MatchGradeText;
                            if(result.TelephoneNumber != null && result.TelephoneNumber.TelecommunicationNumber != null) matchCandidate.TelephoneNumber = result.TelephoneNumber.TelecommunicationNumber;
                            if(result.OperatingStatusText.value != null) matchCandidate.OperatingStatus = result.OperatingStatusText.value;

                            // Match Grade String represents how close of a match each attribute the applicant supplied compared to what DNB found
                            // Release 20.07: EAPT-1546: Added granularity to the incoming MatchGradeComponent to be split into its components
                            if(result.MatchQualityInformation.MatchGradeComponent != null) {
                                for (CreditWSUtil_DNBDirect_Match.MatchGradeComponent matchGradeComponent : result.MatchQualityInformation.MatchGradeComponent) {

                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('Name')) {
                                        matchCandidate.NameMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('Street Name')) {
                                        matchCandidate.StreetNameMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('State')) {
                                        matchCandidate.StateMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('Street Number')) {
                                        matchCandidate.StreetNumberMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('City')) {
                                        matchCandidate.CityMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                    if ((matchGradeComponent.MatchGradeComponentTypeText.value).equalsIgnoreCase('Postal Code')) {
                                        matchCandidate.PostalCodeMatchGradeString = matchGradeComponent.MatchGradeComponentRating;
                                    }
                                }
                            }

                            // Match Data Profile represents how DNB matched the business. For ex: matched on CEO Name, Former Name, Registered Address, etc
                            if(result.MatchQualityInformation.MatchDataProfileComponent != null) {

                                for (CreditWSUtil_DNBDirect_Match.MatchDataProfileComponent matchDataProfileComponent : result.MatchQualityInformation.MatchDataProfileComponent) {

                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('Name')) {
                                        matchCandidate.NameMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }
                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('Street Number')) {
                                        matchCandidate.StreetNumberMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }
                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('Street Name')) {
                                        matchCandidate.StreetNameMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }
                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('City')) {
                                        matchCandidate.CityMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }
                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('State')) {
                                        matchCandidate.StateMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }
                                    if ((matchDataProfileComponent.MatchDataProfileComponentTypeText.value).equalsIgnoreCase('Postal Code')) {
                                        matchCandidate.PostalCodeMatchDataProfile = matchDataProfileComponent.MatchDataProfileComponentValue;
                                    }

                                }

                            }

                            dnbDirectMatchResponse.matchCandidates.add(matchCandidate);

                        }

                    }
                    else {

                        throw new dnbCalloutException('### Error: Unable to get DNB result: ' + cleanseAndMatchResponse.getBody());

                    }

                }

            }

        }
        catch(Exception e) {
            //IADJUDICAT 739 let's log an error too. we need to know what is happening at all times. we are big brother and we say so.
            System.debug('### Error - ' + e.getLineNumber() + ' - ' + e.getMessage());
            // Removed by DDG - this needs to be queued or futured as the engine needs to continue on even if this call fails..
            // Causing uncommited work errors
            //insert UtilityClass.logInternalError(e, null, 'CreditWS_DNB=>dnbDirectClenseAndMatch', false, null, null);
        }

        return dnbDirectMatchResponse;

    }

    public static DNBCAModelResponse getCAScore(DNBCAModelRequest dnbcaModelRequest) {

        try {

            DNBCAModelResponse dnbCAModelResponse = new DNBCAModelResponse();

            CreditWSUtil_DNBCustomModel.prodOrderRequest_3 dnbCustomModelCalloutRequest = new CreditWSUtil_DNBCustomModel.prodOrderRequest_3();

            dnbCustomModelCalloutRequest.UserId = dnbcaModelRequest.UserId;
            dnbCustomModelCalloutRequest.Password = dnbcaModelRequest.Password;

            // Create an order request for the SBRI product with the associated DUNS
            dnbCustomModelCalloutRequest.Orders = new CreditWSUtil_DNBCustomModel.Orders();

            dnbCustomModelCalloutRequest.Orders.DnB_DUNS_Number = dnbcaModelRequest.DnB_DUNS_Number;
            dnbCustomModelCalloutRequest.Orders.Product = dnbcaModelRequest.Product;
            dnbCustomModelCalloutRequest.Orders.Product_Type = dnbcaModelRequest.Product_Type;


            dnbCustomModelCalloutRequest.Immediate_Delivery = new CreditWSUtil_DNBCustomModel.Immediate_Delivery();

            dnbCustomModelCalloutRequest.Immediate_Delivery.Mode = dnbcaModelRequest.Mode;
            dnbCustomModelCalloutRequest.Immediate_Delivery.Format = dnbcaModelRequest.Format;

            CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields additionalFieldsArray = new CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields();

            additionalFieldsArray.Input_Id = dnbcaModelRequest.InputID;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem = new CreditWSUtil_DNBCustomModel.AdditionalFields[]{};

            CreditWSUtil_DNBCustomModel.AdditionalFields requestedCreditLine = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            requestedCreditLine.FieldName = 'req_cr_lmt';
            requestedCreditLine.FieldValue = dnbcaModelRequest.RequestedCreditLimit;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(requestedCreditLine);

            CreditWSUtil_DNBCustomModel.AdditionalFields platforms = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            platforms.FieldName = 'Platforms';
            platforms.FieldValue = dnbCAModelRequest.Platforms;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(platforms);

            if (dnbcaModelRequest.Platforms.equalsIgnoreCase('OTR')) {

                CreditWSUtil_DNBCustomModel.AdditionalFields numberOfTrucks = new CreditWSUtil_DNBCustomModel.AdditionalFields();
                numberOfTrucks.FieldName = 'number_of_trucks';
                numberOfTrucks.FieldValue = dnbCAModelRequest.NumberOfTrucks;

                additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(numberOfTrucks);

                CreditWSUtil_DNBCustomModel.AdditionalFields teamDriverOrSlipSeat = new CreditWSUtil_DNBCustomModel.AdditionalFields();
                teamDriverOrSlipSeat.FieldName = 'team_drivers_slip_seat';
                teamDriverOrSlipSeat.FieldValue = String.valueOf(dnbCAModelRequest.TeamDriversSlipSeat).equalsIgnoreCase('true') ? '1' : '0';

                additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(teamDriverOrSlipSeat);
            }

            if (dnbcaModelRequest.Platforms.equalsIgnoreCase('FLEET')) {

                CreditWSUtil_DNBCustomModel.AdditionalFields bocaType = new CreditWSUtil_DNBCustomModel.AdditionalFields();
                bocaType.FieldName = 'boca_type';
                bocaType.FieldValue = String.valueOf(dnbcaModelRequest.BOCAType);

                additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(bocaType);
            }

            dnbCustomModelCalloutRequest.AdditionalFields = additionalFieldsArray;

            CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port dnbCustomModelCallOut = new CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port();

            dnbCustomModelCallOut.endpoint_x = String.valueOf(dnbCACustomModelSettings.Endpoint_URL__c);
            dnbCustomModelCallOut.timeout_x = 60000;

            if(!TestUtils.isRunningTest()) {

                System.debug('TEMP DNB full request' + dnbCustomModelCalloutRequest);
                CreditWSUtil_DNBCustomModel.customProducts12_Response dnbCustomModelCalloutResponse = dnbCustomModelCallOut.ws_CustomProducts12(dnbCustomModelCalloutRequest);

                if(dnbCustomModelCalloutResponse != null) {

                    System.debug('DNB Custom Model Callout Response is not null.');

                    dnbCAModelResponse.ModelUsed = dnbCAModelRequest.BOCAType;

                    if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS != null) {

                        // These integers are "implied decimals", hence the division by 10..
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperienceNegative = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT);

                            if(numberPaymentExperienceNegative != null) {
                                dnbCAModelResponse.NumberPaymentExperiencesNegative = (numberPaymentExperienceNegative / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSatisfactory = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSatisfactory != null) {
                                dnbCAModelResponse.NumberPaymentExperiencesSatisfactory = (numberPaymentExperiencesSatisfactory / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSlow = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSlow != null) {
                                dnbCAModelResponse.NumberPaymentExperiencesSlow = (numberPaymentExperiencesSlow / 10);
                            }
                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0] != null) {
                            dnbCAModelResponse.FeinTaxID = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0].USDS_TAX_ID.ArrayOfstringItem[0];
                        }
                        dnbCAModelResponse.DunsNumber = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.DUNS_NBR;
                        dnbCAModelResponse.PrimaryName = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_NME;
                        dnbCAModelResponse.AddressLine = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.ADR_LINE.ArrayOfstringItem[0];
                        dnbCAModelResponse.PostalTown = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_TOWN;
                        dnbCAModelResponse.PrimaryGeographicArea = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_GEO_AREA;
                        dnbCAModelResponse.PostalCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_CODE;
                        dnbCAModelResponse.CountryCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CTRY_CD;
                        dnbCAModelResponse.GlobalUltimateDUNS = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.GBL_ULT_PNT_DUNS;
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR != null) {
                            dnbCAModelResponse.Paydex = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR);
                        }
                        dnbCAModelResponse.PrimarySIC = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_SIC;

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR != null) {
                            dnbCAModelResponse.ControlYear = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR != null) {
                            dnbCAModelResponse.YearStarted = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT != null) {
                            dnbCAModelResponse.NumberOfTrades = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT);
                        }

                        // TODO - Add USDS_BKCY_FILG_DT for Bankruptcy

                        if(null != dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore) {

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore != null) {
                                dnbCAModelResponse.RawScore = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore);
                            }
                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount != null) {
                                System.debug(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0]);
                                dnbCAModelResponse.RecommendedCreditLimitAmount = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount);
                            }

                            dnbCAModelResponse.ReasonCodes = new String[]{};

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary != null) {

                                for(CreditWSUtil_DNBCustomModel.ScoreCommentary scoreCommentary : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary) {

                                    if(scoreCommentary.CommentaryText.DNBCodeValue != null) {
                                        List<DNB_Custom_Model_Reason_Code__mdt> dnbCustomModelReasonCodes = [SELECT Reason_Code_Description__c FROM DNB_Custom_Model_Reason_Code__mdt WHERE Reason_Code__c =: scoreCommentary.CommentaryText.DNBCodeValue];

                                        if(dnbCustomModelReasonCodes.size() == 1) {

                                            dnbCAModelResponse.ReasonCodes.add(String.valueOf(scoreCommentary.CommentaryText.DNBCodeValue) + ': ' + dnbCustomModelReasonCodes[0].Reason_Code_Description__c);

                                        }

                                    }

                                }

                            }

                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes != null) {

                            for(CreditWSUtil_DNBCustomModel.PredictiveAttributesType predictiveAttribute : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes) {

                                if((predictiveAttribute.key).equalsIgnoreCase('hicdtmax')) {
                                    dnbCAModelResponse.CSADHighCredit = Long.valueOf(predictiveAttribute.value);
                                }
                                if((predictiveAttribute.key).equalsIgnoreCase('max_cur_creditlimit_rev_12m')) {
                                    dnbCAModelResponse.SBFEHighCredit = Long.valueOf(predictiveAttribute.value);
                                }
                                if((predictiveAttribute.key).equalsIgnoreCase('sbri_powered_score_card')) {
                                    dnbCAModelResponse.SBRICardScore = Integer.valueOf(predictiveAttribute.value);
                                }

                            }

                        }

                    }

                }
            }

            return dnbCAModelResponse;

        }
        catch(Exception e) {

            System.debug('### Error while reading response from DNB for CA: ' + e + ' Line Number: ' + e.getLineNumber());

        }

        return null;
    }

    public static DNBNAFleetModelResponse getNAFleetScore(DNBNAFleetModelRequest dnbNAFleetModelRequest) {

        try {

            DNBNAFleetModelResponse dnbNAFleetModelResponse = new DNBNAFleetModelResponse();

            CreditWSUtil_DNBCustomModel.prodOrderRequest_3 dnbCustomModelCalloutRequest = new CreditWSUtil_DNBCustomModel.prodOrderRequest_3();

            dnbCustomModelCalloutRequest.UserId = dnbNAFleetModelRequest.UserId;
            dnbCustomModelCalloutRequest.Password = dnbNAFleetModelRequest.Password;

            // Create an order request for the SBRI product with the associated DUNS
            dnbCustomModelCalloutRequest.Orders = new CreditWSUtil_DNBCustomModel.Orders();

            dnbCustomModelCalloutRequest.Orders.DnB_DUNS_Number = dnbNAFleetModelRequest.DnB_DUNS_Number;
            dnbCustomModelCalloutRequest.Orders.Product = dnbNAFleetModelRequest.Product;
            dnbCustomModelCalloutRequest.Orders.Product_Type = dnbNAFleetModelRequest.Product_Type;


            dnbCustomModelCalloutRequest.Immediate_Delivery = new CreditWSUtil_DNBCustomModel.Immediate_Delivery();

            dnbCustomModelCalloutRequest.Immediate_Delivery.Mode = dnbNAFleetModelRequest.Mode;
            dnbCustomModelCalloutRequest.Immediate_Delivery.Format = dnbNAFleetModelRequest.Format;

            CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields additionalFieldsArray = new CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields();

            additionalFieldsArray.Input_Id = dnbNAFleetModelRequest.InputID;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem = new CreditWSUtil_DNBCustomModel.AdditionalFields[]{};

            CreditWSUtil_DNBCustomModel.AdditionalFields requestedCreditLine = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            requestedCreditLine.FieldName = 'req_cr_lmt';
            requestedCreditLine.FieldValue = dnbNAFleetModelRequest.RequestedCreditLimit;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(requestedCreditLine);

            CreditWSUtil_DNBCustomModel.AdditionalFields bocaType = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            bocaType.FieldName = 'boca_type';
            bocaType.FieldValue = String.valueOf(dnbNAFleetModelRequest.BOCAType);

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(bocaType);

            dnbCustomModelCalloutRequest.AdditionalFields = additionalFieldsArray;

            CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port dnbCustomModelCallOut = new CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port();

            dnbCustomModelCallOut.endpoint_x = String.valueOf(dnbCustomModelSettings.Endpoint_URL__c);
            dnbCustomModelCallOut.timeout_x = 60000;

            if(!TestUtils.isRunningTest()) {
                CreditWSUtil_DNBCustomModel.customProducts12_Response dnbCustomModelCalloutResponse = dnbCustomModelCallOut.ws_CustomProducts12(dnbCustomModelCalloutRequest);

                if(dnbCustomModelCalloutResponse != null) {

                    System.debug('DNB Custom Model Callout Response is not null.');

                    dnbNAFleetModelResponse.ModelUsed = dnbNAFleetModelRequest.BOCAType;

                    if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS != null) {

                        // These integers are "implied decimals", hence the division by 10..
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperienceNegative = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT);

                            if(numberPaymentExperienceNegative != null) {
                                dnbNAFleetModelResponse.NumberPaymentExperiencesNegative = (numberPaymentExperienceNegative / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSatisfactory = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSatisfactory != null) {
                                dnbNAFleetModelResponse.NumberPaymentExperiencesSatisfactory = (numberPaymentExperiencesSatisfactory / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSlow = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSlow != null) {
                                dnbNAFleetModelResponse.NumberPaymentExperiencesSlow = (numberPaymentExperiencesSlow / 10);
                            }
                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0] != null) {
                            dnbNAFleetModelResponse.FeinTaxID = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0].USDS_TAX_ID.ArrayOfstringItem[0];
                        }
                        dnbNAFleetModelResponse.DunsNumber = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.DUNS_NBR;
                        dnbNAFleetModelResponse.PrimaryName = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_NME;
                        dnbNAFleetModelResponse.AddressLine = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.ADR_LINE.ArrayOfstringItem[0];
                        dnbNAFleetModelResponse.PostalTown = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_TOWN;
                        dnbNAFleetModelResponse.PrimaryGeographicArea = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_GEO_AREA;
                        dnbNAFleetModelResponse.PostalCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_CODE;
                        dnbNAFleetModelResponse.CountryCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CTRY_CD;
                        dnbNAFleetModelResponse.GlobalUltimateDUNS = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.GBL_ULT_PNT_DUNS;
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR != null) {
                            dnbNAFleetModelResponse.Paydex = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR);
                        }
                        dnbNAFleetModelResponse.PrimarySIC = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_SIC;

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR != null) {
                            dnbNAFleetModelResponse.ControlYear = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR != null) {
                            dnbNAFleetModelResponse.YearStarted = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT != null) {
                            dnbNAFleetModelResponse.NumberOfTrades = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT);
                        }

                        // TODO - Add USDS_BKCY_FILG_DT for Bankruptcy

                        if(null != dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore) {

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore != null) {
                                dnbNAFleetModelResponse.RawScore = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore);
                            }
                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount != null) {
                                System.debug(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0]);
                                dnbNAFleetModelResponse.RecommendedCreditLimitAmount = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount);
                            }

                            dnbNAFleetModelResponse.ReasonCodes = new String[]{};

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary != null) {

                                for(CreditWSUtil_DNBCustomModel.ScoreCommentary scoreCommentary : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary) {

                                    if(scoreCommentary.CommentaryText.DNBCodeValue != null) {
                                        List<DNB_Custom_Model_Reason_Code__mdt> dnbCustomModelReasonCodes = [SELECT Reason_Code_Description__c FROM DNB_Custom_Model_Reason_Code__mdt WHERE Reason_Code__c =: scoreCommentary.CommentaryText.DNBCodeValue];

                                        if(dnbCustomModelReasonCodes.size() == 1) {

                                            dnbNAFleetModelResponse.ReasonCodes.add(String.valueOf(scoreCommentary.CommentaryText.DNBCodeValue) + ': ' + dnbCustomModelReasonCodes[0].Reason_Code_Description__c);

                                        }

                                    }

                                }

                            }

                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes != null) {

                            for(CreditWSUtil_DNBCustomModel.PredictiveAttributesType predictiveAttribute : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes) {

                                if((predictiveAttribute.key).equalsIgnoreCase('hicdtmax')) {
                                    dnbNAFleetModelResponse.CSADHighCredit = Long.valueOf(predictiveAttribute.value);
                                }
                                if((predictiveAttribute.key).equalsIgnoreCase('max_cur_creditlimit_rev_12m')) {
                                    dnbNAFleetModelResponse.SBFEHighCredit = Long.valueOf(predictiveAttribute.value);
                                }
                                if((predictiveAttribute.key).equalsIgnoreCase('sbri_powered_score_card')) {
                                    dnbNAFleetModelResponse.SBRICardScore = Integer.valueOf(predictiveAttribute.value);
                                }

                            }

                        }

                    }

                }
            }

            return dnbNAFleetModelResponse;

        }
        catch(Exception e) {

            System.debug('### Error while reading response from DNB: ' + e + ' Line Number: ' + e.getLineNumber());

        }

        return null;

    }

    public static DNBOTRModelResponse getOTRScore(DNBOTRModelRequest dnbOTRModelRequest) {

        try {

            DNBOTRModelResponse dnbOTRModelResponse = new DNBOTRModelResponse();

            CreditWSUtil_DNBCustomModel.prodOrderRequest_3 dnbCustomModelCalloutRequest = new CreditWSUtil_DNBCustomModel.prodOrderRequest_3();

            dnbCustomModelCalloutRequest.UserId = dnbOTRModelRequest.UserId;
            dnbCustomModelCalloutRequest.Password = dnbOTRModelRequest.Password;

            // Create an order request for the SBRI product with the associated DUNS
            dnbCustomModelCalloutRequest.Orders = new CreditWSUtil_DNBCustomModel.Orders();

            dnbCustomModelCalloutRequest.Orders.DnB_DUNS_Number = dnbOTRModelRequest.DnB_DUNS_Number;
            dnbCustomModelCalloutRequest.Orders.Product = dnbOTRModelRequest.Product;
            dnbCustomModelCalloutRequest.Orders.Product_Type = dnbOTRModelRequest.Product_Type;


            dnbCustomModelCalloutRequest.Immediate_Delivery = new CreditWSUtil_DNBCustomModel.Immediate_Delivery();

            dnbCustomModelCalloutRequest.Immediate_Delivery.Mode = dnbOTRModelRequest.Mode;
            dnbCustomModelCalloutRequest.Immediate_Delivery.Format = dnbOTRModelRequest.Format;

            CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields additionalFieldsArray = new CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields();

            additionalFieldsArray.Input_Id = dnbOTRModelRequest.InputID;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem = new CreditWSUtil_DNBCustomModel.AdditionalFields[]{};

            CreditWSUtil_DNBCustomModel.AdditionalFields requestedCreditLine = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            requestedCreditLine.FieldName = 'req_cr_lmt';
            requestedCreditLine.FieldValue = dnbOTRModelRequest.RequestedCreditLimit;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(requestedCreditLine);

            CreditWSUtil_DNBCustomModel.AdditionalFields numberOfTrucks = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            numberOfTrucks.FieldName = 'number_of_trucks';
            numberOfTrucks.FieldValue = dnbOTRModelRequest.NumberOfTrucks;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(numberOfTrucks);

            CreditWSUtil_DNBCustomModel.AdditionalFields teamDriverOrSlipSeat = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            teamDriverOrSlipSeat.FieldName = 'team_drivers_slip_seat';
            teamDriverOrSlipSeat.FieldValue = String.valueOf(dnbOTRModelRequest.TeamDriversSlipSeat).equalsIgnoreCase('true') ? '1' : '0';

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(teamDriverOrSlipSeat);

            dnbCustomModelCalloutRequest.AdditionalFields = additionalFieldsArray;

            CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port dnbCustomModelCallOut = new CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port();

            dnbCustomModelCallOut.endpoint_x = String.valueOf(dnbCustomModelSettings.Endpoint_URL__c);
            dnbCustomModelCallOut.timeout_x = 60000;

            if(!TestUtils.isRunningTest()) {
                CreditWSUtil_DNBCustomModel.customProducts12_Response dnbCustomModelCalloutResponse = dnbCustomModelCallOut.ws_CustomProducts12(dnbCustomModelCalloutRequest);

                if(dnbCustomModelCalloutResponse != null) {

                    if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS != null) {

                        // These integers are "implied decimals", hence the division by 10..
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperienceNegative = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT);

                            if(numberPaymentExperienceNegative != null) {
                                dnbOTRModelResponse.NumberPaymentExperiencesNegative = (numberPaymentExperienceNegative / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSatisfactory = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSatisfactory != null) {
                                dnbOTRModelResponse.NumberPaymentExperiencesSatisfactory = (numberPaymentExperiencesSatisfactory / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSlow = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSlow != null) {
                                dnbOTRModelResponse.NumberPaymentExperiencesSlow = (numberPaymentExperiencesSlow / 10);
                            }
                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0] != null) {
                            dnbOTRModelResponse.FeinTaxID = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0].USDS_TAX_ID.ArrayOfstringItem[0];
                        }
                        dnbOTRModelResponse.DunsNumber = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.DUNS_NBR;
                        dnbOTRModelResponse.PrimaryName = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_NME;
                        dnbOTRModelResponse.AddressLine = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.ADR_LINE.ArrayOfstringItem[0];
                        dnbOTRModelResponse.PostalTown = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_TOWN;
                        dnbOTRModelResponse.PrimaryGeographicArea = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_GEO_AREA;
                        dnbOTRModelResponse.PostalCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_CODE;
                        dnbOTRModelResponse.CountryCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CTRY_CD;
                        dnbOTRModelResponse.GlobalUltimateDUNS = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.GBL_ULT_PNT_DUNS;
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR != null) {
                            dnbOTRModelResponse.Paydex = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR);
                        }
                        dnbOTRModelResponse.PrimarySIC = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_SIC;

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR != null) {
                            dnbOTRModelResponse.ControlYear = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR != null) {
                            dnbOTRModelResponse.YearStarted = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT != null) {
                            dnbOTRModelResponse.NumberOfTrades = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT);
                        }

                        // TODO - Add USDS_BKCY_FILG_DT for Bankruptcy
                        if (dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment == null) {
                            System.debug('DNB Assessment from the response is null!');
                        }
                        else {

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore != null) {

                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore != null) {
                                    dnbOTRModelResponse.RawScore = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore);
                                }
                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount != null) {
                                    System.debug(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0]);
                                    dnbOTRModelResponse.RecommendedCreditLimitAmount = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount);
                                }

                                dnbOTRModelResponse.ReasonCodes = new String[]{};

                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary != null) {

                                    for(CreditWSUtil_DNBCustomModel.ScoreCommentary scoreCommentary : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary) {

                                        if(scoreCommentary.CommentaryText.DNBCodeValue != null) {
                                            List<DNB_Custom_Model_Reason_Code__mdt> dnbCustomModelReasonCodes = [SELECT Reason_Code_Description__c FROM DNB_Custom_Model_Reason_Code__mdt WHERE Reason_Code__c =: scoreCommentary.CommentaryText.DNBCodeValue];

                                            if(dnbCustomModelReasonCodes.size() == 1) {

                                                dnbOTRModelResponse.ReasonCodes.add(String.valueOf(scoreCommentary.CommentaryText.DNBCodeValue) + ': ' + dnbCustomModelReasonCodes[0].Reason_Code_Description__c);

                                            }

                                        }

                                    }

                                }
                            }


                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes != null) {

                                for(CreditWSUtil_DNBCustomModel.PredictiveAttributesType predictiveAttribute : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes) {

                                    if((predictiveAttribute.key).equalsIgnoreCase('hicdtmax')) {
                                        dnbOTRModelResponse.CSADHighCredit = Long.valueOf(predictiveAttribute.value);
                                    }
                                    if((predictiveAttribute.key).equalsIgnoreCase('max_cur_creditlimit_rev_12m')) {
                                        dnbOTRModelResponse.SBFEHighCredit = Long.valueOf(predictiveAttribute.value);
                                    }
                                    if((predictiveAttribute.key).equalsIgnoreCase('sbri_powered_score_card')) {
                                        dnbOTRModelResponse.SBRICardScore = Integer.valueOf(predictiveAttribute.value);
                                    }

                                }

                            }
                        }
                    }

                }
            }

            return dnbOTRModelResponse;

        }
        catch(Exception e) {

            System.debug('### Error while reading response from DNB: ' + e + ' Line Number: ' + e.getLineNumber());

        }

        return null;

    }

    public static DNBCPModelResponse getCPScore(DNBCPModelRequest dnbCPModelRequest) {

        try {

            DNBCPModelResponse dnbCPModelResponse = new DNBCPModelResponse();

            CreditWSUtil_DNBCustomModel.prodOrderRequest_3 dnbCustomModelCalloutRequest = new CreditWSUtil_DNBCustomModel.prodOrderRequest_3();

            dnbCustomModelCalloutRequest.UserId = dnbCPModelRequest.UserId;
            dnbCustomModelCalloutRequest.Password = dnbCPModelRequest.Password;

            // Create an order request for the SBRI product with the associated DUNS
            dnbCustomModelCalloutRequest.Orders = new CreditWSUtil_DNBCustomModel.Orders();

            dnbCustomModelCalloutRequest.Orders.DnB_DUNS_Number = dnbCPModelRequest.DnB_DUNS_Number;
            dnbCustomModelCalloutRequest.Orders.Product = dnbCPModelRequest.Product;
            dnbCustomModelCalloutRequest.Orders.Product_Type = dnbCPModelRequest.Product_Type;


            dnbCustomModelCalloutRequest.Immediate_Delivery = new CreditWSUtil_DNBCustomModel.Immediate_Delivery();

            dnbCustomModelCalloutRequest.Immediate_Delivery.Mode = dnbCPModelRequest.Mode;
            dnbCustomModelCalloutRequest.Immediate_Delivery.Format = dnbCPModelRequest.Format;

            CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields additionalFieldsArray = new CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields();

            additionalFieldsArray.Input_Id = dnbCPModelRequest.InputID;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem = new CreditWSUtil_DNBCustomModel.AdditionalFields[]{};

            CreditWSUtil_DNBCustomModel.AdditionalFields requestedCreditLine = new CreditWSUtil_DNBCustomModel.AdditionalFields();
            requestedCreditLine.FieldName = 'req_cr_lmt';
            requestedCreditLine.FieldValue = dnbCPModelRequest.RequestedCreditLimit;

            additionalFieldsArray.ArrayOfAdditionalFieldsItem.add(requestedCreditLine);

            dnbCustomModelCalloutRequest.AdditionalFields = additionalFieldsArray;

            CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port dnbCustomModelCallOut = new CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port();

            dnbCustomModelCallOut.endpoint_x = String.valueOf(dnbCustomModelSettings.Endpoint_URL__c);

            if(!TestUtils.isRunningTest()) {
                CreditWSUtil_DNBCustomModel.customProducts12_Response dnbCustomModelCalloutResponse = dnbCustomModelCallOut.ws_CustomProducts12(dnbCustomModelCalloutRequest);

                if(dnbCustomModelCalloutResponse != null) {

                    if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS != null) {

                        // These integers are "implied decimals", hence the division by 10..
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperienceNegative = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_NEGV_PMT_EXPR_CNT);

                            if(numberPaymentExperienceNegative != null) {
                                dnbCPModelResponse.NumberPaymentExperiencesNegative = (numberPaymentExperienceNegative / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSatisfactory = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SATY_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSatisfactory != null) {
                                dnbCPModelResponse.NumberPaymentExperiencesSatisfactory = (numberPaymentExperiencesSatisfactory / 10);
                            }
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT != null) {
                            Integer numberPaymentExperiencesSlow = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_SLOW_PMT_EXPR_CNT);

                            if(numberPaymentExperiencesSlow != null) {
                                dnbCPModelResponse.NumberPaymentExperiencesSlow = (numberPaymentExperiencesSlow / 10);
                            }
                        }

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem != null && dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0] != null) {
                            dnbCPModelResponse.FeinTaxID = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_FEIN_CTR.ArrayOfUSDS_FEIN_CTRItem[0].USDS_TAX_ID.ArrayOfstringItem[0];
                        }
                        dnbCPModelResponse.DunsNumber = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.DUNS_NBR;
                        dnbCPModelResponse.PrimaryName = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_NME;
                        dnbCPModelResponse.AddressLine = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.ADR_LINE.ArrayOfstringItem[0];
                        dnbCPModelResponse.PostalTown = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_TOWN;
                        dnbCPModelResponse.PrimaryGeographicArea = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_GEO_AREA;
                        dnbCPModelResponse.PostalCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.POST_CODE;
                        dnbCPModelResponse.CountryCode = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CTRY_CD;
                        dnbCPModelResponse.GlobalUltimateDUNS = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.GBL_ULT_PNT_DUNS;
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR != null) {
                            dnbCPModelResponse.Paydex = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PAYD_SCR);
                        }
                        dnbCPModelResponse.PrimarySIC = dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.PRIM_SIC;

                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR != null) {
                            dnbCPModelResponse.ControlYear = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_CURR_CNTL_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR != null) {
                            dnbCPModelResponse.YearStarted = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.USDS_STRT_YR);
                        }
                        if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT != null) {
                            dnbCPModelResponse.NumberOfTrades = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.TOT_PMT);
                        }

                        // TODO - Add USDS_BKCY_FILG_DT for Bankruptcy
                        if (dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment == null) {
                            System.debug('DNB Assessment from the response is null!');
                        }
                        else {

                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore != null) {

                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore != null) {
                                    dnbCPModelResponse.RawScore = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RawScore);
                                }
                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount != null) {
                                    System.debug(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0]);
                                    dnbCPModelResponse.RecommendedCreditLimitAmount = Integer.valueOf(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].RecommendedCreditLimitAmount);
                                }

                                dnbCPModelResponse.ReasonCodes = new String[]{};

                                if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary != null) {

                                    for(CreditWSUtil_DNBCustomModel.ScoreCommentary scoreCommentary : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.CustomScore[0].ScoreCommentary) {

                                        if(scoreCommentary.CommentaryText.DNBCodeValue != null) {
                                            List<DNB_Custom_Model_Reason_Code__mdt> dnbCustomModelReasonCodes = [SELECT Reason_Code_Description__c FROM DNB_Custom_Model_Reason_Code__mdt WHERE Reason_Code__c =: scoreCommentary.CommentaryText.DNBCodeValue];

                                            if(dnbCustomModelReasonCodes.size() == 1) {

                                                dnbCPModelResponse.ReasonCodes.add(String.valueOf(scoreCommentary.CommentaryText.DNBCodeValue) + ': ' + dnbCustomModelReasonCodes[0].Reason_Code_Description__c);

                                            }

                                        }

                                    }

                                }
                            }


                            if(dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes != null) {

                                for(CreditWSUtil_DNBCustomModel.PredictiveAttributesType predictiveAttribute : dnbCustomModelCalloutResponse.DGX.CREDITMSGSRSV2.DATATRNRS.DATARS.CustomScores.Organization.Assessment.PredictiveAttributes) {

                                    if((predictiveAttribute.key).equalsIgnoreCase('hicdtmax')) {
                                        dnbCPModelResponse.CSADHighCredit = Long.valueOf(predictiveAttribute.value);
                                    }
                                    if((predictiveAttribute.key).equalsIgnoreCase('max_cur_creditlimit_rev_12m')) {
                                        dnbCPModelResponse.SBFEHighCredit = Long.valueOf(predictiveAttribute.value);
                                    }
                                    if((predictiveAttribute.key).equalsIgnoreCase('sbri_powered_score_card')) {
                                        dnbCPModelResponse.SBRICardScore = Integer.valueOf(predictiveAttribute.value);
                                    }

                                }

                            }
                        }
                    }

                }
            }

            return dnbCPModelResponse;

        }
        catch(Exception e) {

            System.debug('### Error while reading response from DNB: ' + e + ' Line Number: ' + e.getLineNumber());

        }

        return null;

    }

    //TODO DELETE ME AFTER CA NEW MODEL RELEASED
    public class DNBSBRIRequest {

        public String UserId { get; set; }
        public String Password { get; set; }

        public String DnB_DUNS_Number { get; set; }
        public String Product { get; set; }
        public String Product_Type { get; set; }
        public String Mode { get; set; }
        public String Format { get; set; }

        public DNBSBRIRequest() {

            this.UserId = dnbSettings.Username__c;
            this.Password = dnbSettings.Password__c;

            // These are the defaults retrieved from the
            // DNB Toolkit site
            this.Product = 'GACustomProduct8';
            this.Product_Type = 'D';
            this.Mode = 'DIRECT';
            this.Format = 'XML';

        }

    }

    public class DNBNAFleetModelRequest {

        public String UserId { get; set; }
        public String Password { get; set; }

        public String DnB_DUNS_Number { get; set; }

        public String Product { get; set; }
        public String Product_Type { get; set; }
        public String Mode { get; set; }
        public String Format { get; set; }

        public Integer BOCAType { get; set; }
        public String InputID { get; set; }
        public String RequestedCreditLimit { get; set; }

        public DNBNAFleetModelRequest() {

            // Always the value we send for the NA Fleet model
            this.BOCAType = 1;
            this.InputID = 'WEX_FLT_01';

            this.UserId = dnbCustomModelSettings.Username__c;
            this.Password = dnbCustomModelSettings.Password__c;

            // These are the defaults retrieved from the
            // DNB Toolkit site
            this.Product = 'gacustomproduct12';
            this.Product_Type = 'D';
            this.Mode = 'DIRECT';
            this.Format = 'XML';

        }

    }

    public class DNBNAFleetModelResponse {

        public Integer RawScore { get; set; }
        public Integer RecommendedCreditLimitAmount { get; set; }
        public String[] ReasonCodes { get; set; }
        public Integer NumberOfTrades { get; set; }
        public Integer ModelUsed { get; set; }
        public String PrimarySIC { get; set; }
        public String DunsNumber { get; set; }
        public String GlobalUltimateDUNS { get; set; }
        public String PrimaryName { get; set; }
        public String AddressLine { get; set; }
        public String PostalTown { get; set; }
        public String PrimaryGeographicArea { get; set; }
        public String PostalCode { get; set; }
        public String CountryCode { get; set; }
        public Long SBFEHighCredit { get; set; }
        public Long CSADHighCredit { get; set; }
        public Integer SBRICardScore { get; set; }
        public Integer BankruptcyDateOfFiling { get; set; }
        public String FeinTaxID { get; set; }
        public Integer Paydex { get; set; }
        public Integer ControlYear { get; set; }
        public Integer YearStarted { get; set; }
        public Integer NumberPaymentExperiencesNegative { get; set; }
        public Integer NumberPaymentExperiencesSlow { get; set; }
        public Integer NumberPaymentExperiencesSatisfactory { get; set; }

    }

    public class DNBOTRModelRequest {

        public String UserId { get; set; }
        public String Password { get; set; }

        public String DnB_DUNS_Number { get; set; }

        public String Product { get; set; }
        public String Product_Type { get; set; }
        public String Mode { get; set; }
        public String Format { get; set; }

        public String InputID { get; set; }

        public String NumberOfTrucks { get; set; }
        public Boolean TeamDriversSlipSeat { get; set; }
        public String RequestedCreditLimit { get; set; }

        public DNBOTRModelRequest() {

            // Always the value we send for the NA Fleet model
            this.InputID = 'WEX_OTR_01';

            this.UserId = dnbCustomModelSettings.Username__c;
            this.Password = dnbCustomModelSettings.Password__c;

            // These are the defaults retrieved from the
            // DNB Toolkit site
            this.Product = 'gacustomproduct12';
            this.Product_Type = 'D';
            this.Mode = 'DIRECT';
            this.Format = 'XML';

        }

    }

    public class DNBOTRModelResponse {

        public Integer RawScore { get; set; }
        public Integer RecommendedCreditLimitAmount { get; set; }
        public String[] ReasonCodes { get; set; }
        public Integer NumberOfTrades { get; set; }
        public String PrimarySIC { get; set; }
        public String DunsNumber { get; set; }
        public String GlobalUltimateDUNS { get; set; }
        public String PrimaryName { get; set; }
        public String AddressLine { get; set; }
        public String PostalTown { get; set; }
        public String PrimaryGeographicArea { get; set; }
        public String PostalCode { get; set; }
        public String CountryCode { get; set; }
        public Long SBFEHighCredit { get; set; }
        public Long CSADHighCredit { get; set; }
        public Integer SBRICardScore { get; set; }
        public String FeinTaxID { get; set; }
        public Integer Paydex { get; set; }
        public Integer ControlYear { get; set; }
        public Integer YearStarted { get; set; }
        public Integer NumberPaymentExperiencesNegative { get; set; }
        public Integer NumberPaymentExperiencesSlow { get; set; }
        public Integer NumberPaymentExperiencesSatisfactory { get; set; }

    }

    public class DNBCPModelRequest {

        public String UserId { get; set; }
        public String Password { get; set; }

        public String DnB_DUNS_Number { get; set; }

        public String Product { get; set; }
        public String Product_Type { get; set; }
        public String Mode { get; set; }
        public String Format { get; set; }

        public String InputID { get; set; }
        public String RequestedCreditLimit { get; set; }

        public DNBCPModelRequest() {

            // Always the value we send for the NA Fleet model
            this.InputID = 'WEX_MCD_01';

            this.UserId = dnbCustomModelSettings.Username__c;
            this.Password = dnbCustomModelSettings.Password__c;

            // These are the defaults retrieved from the
            // DNB Toolkit site
            this.Product = 'gacustomproduct12';
            this.Product_Type = 'D';
            this.Mode = 'DIRECT';
            this.Format = 'XML';

        }

    }

    public class DNBCPModelResponse {

        public Integer RawScore { get; set; }
        public Integer RecommendedCreditLimitAmount { get; set; }
        public String[] ReasonCodes { get; set; }
        public Integer NumberOfTrades { get; set; }
        public String PrimarySIC { get; set; }
        public String DunsNumber { get; set; }
        public String GlobalUltimateDUNS { get; set; }
        public String PrimaryName { get; set; }
        public String AddressLine { get; set; }
        public String PostalTown { get; set; }
        public String PrimaryGeographicArea { get; set; }
        public String PostalCode { get; set; }
        public String CountryCode { get; set; }
        public Long SBFEHighCredit { get; set; }
        public Long CSADHighCredit { get; set; }
        public Integer SBRICardScore { get; set; }
        public String FeinTaxID { get; set; }
        public Integer Paydex { get; set; }
        public Integer ControlYear { get; set; }
        public Integer YearStarted { get; set; }
        public Integer NumberPaymentExperiencesNegative { get; set; }
        public Integer NumberPaymentExperiencesSlow { get; set; }
        public Integer NumberPaymentExperiencesSatisfactory { get; set; }

    }

    // Canadian DNB
    public class DNBCAModelRequest {

        public String UserId { get; set; }
        public String Password { get; set; }

        public String DnB_DUNS_Number { get; set; }

        public String Product { get; set; }
        public String Product_Type { get; set; }
        public String Mode { get; set; }
        public String Format { get; set; }
        public String Platforms { get; set; }

        public Integer BOCAType { get; set; }
        public String InputID { get; set; }
        public String RequestedCreditLimit { get; set; }
        public String Country { get; set; }
        public String NumberOfTrucks { get; set; }
        public Boolean TeamDriversSlipSeat { get; set; }

        public DNBCAModelRequest() {

            this.InputID = 'WEX_CAN_01';
            this.Country = 'CA';

            this.UserId = dnbCACustomModelSettings.Username__c;
            this.Password = dnbCACustomModelSettings.Password__c;

            // These are the defaults retrieved from the
            // DNB Toolkit site
            this.Product = 'gacustomproduct12';
            this.Product_Type = 'D';
            this.Mode = 'DIRECT';
            this.Format = 'XML';
        }

    }

    public class DNBCAModelResponse {

        public Integer RawScore { get; set; }
        public Integer RecommendedCreditLimitAmount { get; set; }
        public String[] ReasonCodes { get; set; }
        public Integer NumberOfTrades { get; set; }
        public Integer ModelUsed { get; set; }
        public String PrimarySIC { get; set; }
        public String DunsNumber { get; set; }
        public String GlobalUltimateDUNS { get; set; }
        public String PrimaryName { get; set; }
        public String AddressLine { get; set; }
        public String PostalTown { get; set; }
        public String PrimaryGeographicArea { get; set; }
        public String PostalCode { get; set; }
        public String CountryCode { get; set; }
        public Long SBFEHighCredit { get; set; }
        public Long CSADHighCredit { get; set; }
        public Integer SBRICardScore { get; set; }
        public Integer BankruptcyDateOfFiling { get; set; }
        public String FeinTaxID { get; set; }
        public Integer Paydex { get; set; }
        public Integer ControlYear { get; set; }
        public Integer YearStarted { get; set; }
        public Integer NumberPaymentExperiencesNegative { get; set; }
        public Integer NumberPaymentExperiencesSlow { get; set; }
        public Integer NumberPaymentExperiencesSatisfactory { get; set; }
    }

    public class DNBDirect_MatchRequest {

        public Boolean SingleResolution { get; set; }

        public String DUNSNumber { get; set; }
        public String SubjectName { get; set; }
        public String StreetAddressLine1 { get; set; }
        public String StreetAddressLine2 { get; set; }
        public String PrimaryTownName { get; set; }
        public String TerritoryName { get; set; }
        public String FullPostalCode { get; set; }
        public String CountryISOAlpha2Code { get; set; }
        public String TelephoneNumber { get; set; }
        public String TradeStyleName { get; set; }

        public DNBDirect_MatchRequest() {

            this.SingleResolution = false;

        }

        //IADJUDICAT-739 creditdecisionengineotr and dnbadvancedlookupcontroller should do same thing. let's set up one place to do that
        public DNBDirect_MatchRequest(OnlineApplication__c myApp) {

            this.SingleResolution = true;
            this.SubjectName = String.escapeSingleQuotes(myApp.Legal_Business_Name__c);//IADJUDICAT-1188 get those singlies outta there
            this.StreetAddressLine1 = myApp.Business_Street_Address__c;
            this.PrimaryTownName = myApp.City__c;
            this.TerritoryName = myApp.State__c;
            this.FullPostalCode = myApp.Zip_Code__c;
            this.CountryISOAlpha2Code = myApp.Country__c;
            this.DUNSNumber = myApp.DUNS__c;
            this.TelephoneNumber = myApp.Phone_Number__c;
            this.TradeStyleName = myApp.Trade_Name__c;

        }

        //IADJUDICAT-739 creditdecisionenginena and dnbadvancedlookupcontroller should do same thing. let's set up one place to do that
        public DNBDirect_MatchRequest(Application_Request__c myApp) {

            this.SingleResolution = true;
            this.SubjectName = myApp.Opportunity_Name_Text__c;
            this.StreetAddressLine1 = myApp.Physical_Street__c;
            this.PrimaryTownName = myApp.Physical_City__c;
            this.TerritoryName = myApp.Physical_State__c;
            this.FullPostalCode = myApp.Physical_Zip_Postal_Code__c;
            this.CountryISOAlpha2Code = myApp.Physical_Country__c;
            this.DUNSNumber = myApp.DUNS_Number__c;
            this.TelephoneNumber = myApp.Business_Phone_Number__c;
            this.TradeStyleName = myApp.Doing_Business_As__c;

        }

    }

    public class DNBDirect_MatchResponse {

        public Boolean exactDUNSMatch { get; set; }

        public List<DNBDirect_MatchCandidate> matchCandidates { get; set; }

        public DNBDirect_MatchResponse() {

            this.matchCandidates = new List<DNBDirect_MatchCandidate>();

            this.exactDUNSMatch = false;

        }

    }

    public class DNBDirect_MatchCandidate {

        public String OrganizationName { get; set; }
        public String DUNSNumber { get; set; }
        public String StreetAddressLine { get; set; }
        public String PrimaryTownName { get; set; }
        public String TerritoryAbbreviatedName { get; set; }
        public String PostalCode { get; set; }
        public String CountryISOAlpha2Code { get; set; }
        public String OperatingStatus { get; set; }
        public String TelephoneNumber { get; set; }

        public Integer ConfidenceCodeValue { get; set; }
        public String MatchGradeText { get; set; }

        public String NameMatchGradeString { get; set; }
        public String StreetNameMatchGradeString { get; set; }
        public String StateMatchGradeString { get; set; }
        public String StreetNumberMatchGradeString { get; set; }
        public String CityMatchGradeString { get; set; }
        public String PostalCodeMatchGradeString { get; set; }

        public String NameMatchDataProfile { get; set; }
        public String StreetNumberMatchDataProfile { get; set; }
        public String StreetNameMatchDataProfile { get; set; }
        public String CityMatchDataProfile { get; set; }
        public String StateMatchDataProfile { get; set; }
        public String PostalCodeMatchDataProfile { get; set; }

    }

}