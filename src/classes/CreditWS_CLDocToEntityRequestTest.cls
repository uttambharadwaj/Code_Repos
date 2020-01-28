/**
 * Created by lhowland on 1/14/2020.
 */

@IsTest
public with sharing class CreditWS_CLDocToEntityRequestTest {

    static testMethod void testParse() {

        String json = MockCalloutGenerator.getCreditLensLinkDocToEntityGoodBody();

        CreditWS_CLDocToEntityRequest obj = CreditWS_CLDocToEntityRequest.parse(json);
        System.assert(obj != null);
}

}