/**
 * Created by lhowland on 1/3/2020.
 */

@IsTest
public class CreditWS_CLUploadDocResponseTest {

    static testMethod void testParse() {

        String json = MockCalloutGenerator.getCreditLensUploadDocGoodBody();

        CreditWS_CLUploadDocResponse obj = CreditWS_CLUploadDocResponse.parse(json);
        System.assert(obj != null);
    }
}