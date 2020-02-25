@IsTest
public class MCAuthTest {

    public final static String TRIGGERED_EMAIL_KEY = 'TestTriggeredEmail';

    public static void testMarketingCloudAuth() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCAuth'}));
        MCAuth mcConnector = new MCAuth();
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);

    }

    public static void testMarketingCloudTriggeredEmail() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCAuth', 'MarketingCloudTriggeredEmail'}));
        MCAuth mcConnector = new MCAuth();
        Boolean sendSuccessful = mcConnector.sendTriggeredEmail(TRIGGERED_EMAIL_KEY);
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);
        System.assertEquals(true, sendSuccessful);

    }
}