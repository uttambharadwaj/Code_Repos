/**
 * Created by lhowland on 7/28/2020.
 */

@IsTest
public with sharing class CreditWS_CLEditEntityRequestTest {

    static testMethod void testParse() {
        String json =  '{'+
                '   \"context\":{'+
                '      \"wfId\":\"00000000-0000-0000-0000-000000000000\",'+
                '      \"taskId\":\"00000000-0000-0000-0000-000000000000\"'+
                '   },'+
                '   \"payLoad\":{'+
                '      \"OperationType\":\"Update\",'+
                '      \"EntityType\":\"CORP\",'+
                '      \"BillingCycle\": \"Monthly\",'+
                '      \"Division\": \"Fleet\",'+
                '      \"LongName\":\"Edit Entity Inc\",'+
                '      \"ShortName\":\"X Silver Inc\",'+
                '      \"EntityId\":1919,'+
                '      \"BusinessPortfolio\":\"USA\",'+
                '      \"CreditPortfolio\":\"WexBank\",'+
                '      \"FirmType\":\"PUB\",'+
                '      \"CountryOfRisk\":\"USA\",'+
                '      \"CountryOfInc\": \"USA\",'+
                '      \"CountryOfListing\": \"USA\",'+
                '      \"Currency\":\"USD\",'+
                '      \"StockCode\": \"NYC\",'+
                '      \"StockExchange\": \"NYSE\",'+
                '      \"OnList\": 4,'+
                '      \"WexDateAdded\": \"2020-07-27\",'+
                '      \"WexBusinessUnit\": \"Payables\",'+
                '      \"WexCreditAnalyst\": \"Leela Howland\",'+
                '      \"WexOriginationModelRecommendat\": \"0.00\",'+
                '      \"WexPrimaryRiskGrade\": \"6\",'+
                '      \"WexRecommendedCreditLine\": \"200005.00\",'+
                '      \"WexRelationshipManager\": \"Carlos Escobar\",'+
                '      \"WexRequestCreditLineAmount\": \"109356.00\"'+
                '   }'+
                '}';

        CreditWS_CLEditEntityRequest obj = CreditWS_CLEditEntityRequest.parse(json);
        System.assert(obj != null);
        System.assert(obj.payLoad.LongName.equalsIgnoreCase('Edit Entity Inc'));
        System.assert(obj.payLoad.EntityId == 1919);
    }
}