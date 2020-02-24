@IsTest
public class MCAuthTest { // TODO move to test class dispatcher

    public final static String TRIGGERED_EMAIL_KEY = 'TestTriggeredEmail';

    @IsTest
    static void testMarketingCloudAuth() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCAuth'}));
        MCAuth mcConnector = new MCAuth();
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);

    }

    @IsTest
    static void testMarketingCloudTriggeredEmail() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCAuth', 'MarketingCloudTriggeredEmail'}));
        MCAuth mcConnector = new MCAuth();
        Boolean sendSuccessful = mcConnector.sendTriggeredEmail(TRIGGERED_EMAIL_KEY);
        Test.stopTest();

        System.assertEquals(true, mcConnector != null);
        System.assertEquals(true, sendSuccessful);

    }
}