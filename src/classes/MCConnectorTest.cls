@IsTest
public class MCConnectorTest {

    public final static String TRIGGERED_EMAIL_KEY = 'TestTriggeredEmail';

    public static void testMarketingCloudAuth() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCConnector'}));
        MCConnector mcConnector = new MCConnector();
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);

    }

    public static void testMarketingCloudTriggeredEmail() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCConnector', 'MarketingCloudTriggeredEmail'}));
        MCConnector mcConnector = new MCConnector();
        Boolean sendSuccessful = mcConnector.sendTriggeredEmail(TRIGGERED_EMAIL_KEY);
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);
        System.assertEquals(true, sendSuccessful);

    }
}