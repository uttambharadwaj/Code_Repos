/**
 * Created by lhowland on 12/13/2019.
 */

@IsTest
public class CreditWS_CLCreateEntityResponseTest {

    static testMethod void testParseResponse() {

        String json = MockCalloutGenerator.getCreditLensCreateGoodBody();

        CreditWS_CLCreateEntityResponse obj = CreditWS_CLCreateEntityResponse.parse(json);
        System.assert(obj != null);
    }
}