/**
 * Created by lhowland on 12/6/2019.
 */

    @IsTest
    public class CreditWS_CLAuthResponseTest {

    static testMethod void testParse() {

            String json = MockCalloutGenerator.getCreditLensAuthGoodBody();

            CreditWS_CLAuthResponse obj = CreditWS_CLAuthResponse.parse(json);
            System.assert(obj != null);
    }
}

