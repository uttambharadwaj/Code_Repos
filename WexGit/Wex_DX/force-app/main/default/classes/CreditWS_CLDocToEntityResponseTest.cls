/**
 * Created by lhowland on 1/14/2020.
 */

@IsTest
public with sharing class CreditWS_CLDocToEntityResponseTest {

    static testMethod void testParse() {

        String json = MockCalloutGenerator.getCreditLensLinkDocToEntityGoodBody();

        CreditWS_CLDocToEntityResponse obj = CreditWS_CLDocToEntityResponse.parse(json);
        System.assert(obj != null);
    }
}