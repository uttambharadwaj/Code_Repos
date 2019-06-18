/*
*
* CreditWSUtil_Mock - Unit Test Class For All The SOAPs
*
 */

@isTest
global class CreditWSUtil_Mock implements WebServiceMock {

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        // Lexis Nexis Small Business Analytics Response
        if(request instanceof CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsRequest_element) {

            CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element lexisNexisSBAResponse = new CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element();

            // Shell
            lexisNexisSBAResponse.response = new CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponse();
            lexisNexisSBAResponse.response.Result = new CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResult();

            // Dip to Scores
            CreditWSUtil_LexisNexisSBA.SBAScoreHRI sbaScoreHRI = new CreditWSUtil_LexisNexisSBA.SBAScoreHRI();

            sbaScoreHRI.Value = 718;

            // Wrap with <Scores>
            CreditWSUtil_LexisNexisSBA.Scores_element scoresElement = new CreditWSUtil_LexisNexisSBA.Scores_element();

            scoresElement.Score = new CreditWSUtil_LexisNexisSBA.SBAScoreHRI[]{ sbaScoreHRI };

            // Wrap with <Model>
            CreditWSUtil_LexisNexisSBA.SBAModelHRI sbaModelHRI = new CreditWSUtil_LexisNexisSBA.SBAModelHRI();

            sbaModelHRI.Scores = scoresElement;

            // Wrap with <Models>
            CreditWSUtil_LexisNexisSBA.Models_element modelsElement = new CreditWSUtil_LexisNexisSBA.Models_element();

            modelsElement.Model = new CreditWSUtil_LexisNexisSBA.SBAModelHRI[]{ sbaModelHRI };

            // Add <Models> back to the response
            lexisNexisSBAResponse.response.Result.Models = modelsElement;

            response.put('response_x', lexisNexisSBAResponse);

        }
        else if(request instanceof CreditWSUtil_DNBCustomModel.prodOrderRequest_3) {

        }

    }

}