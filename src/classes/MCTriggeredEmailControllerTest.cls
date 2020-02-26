@IsTest
public class MCTriggeredEmailControllerTest {


    public static void testMCTriggeredEmailController() {

        Case testCase = [ SELECT Id,RecordTypeId FROM Case WHERE RecordTypeId = '0120g000000N2ONAA0' LIMIT 1 ];

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'MCConnector', 'MarketingCloudTriggeredEmail'}));

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);

        PageReference mcTriggeredEmailPage = Page.MarketingTriggeredEmail;
        Test.setCurrentPage(mcTriggeredEmailPage);

        MCTriggeredEmailController mcTriggerEmailTest = new MCTriggeredEmailController(sc);
        mcTriggerEmailTest.selectedMCTriggeredEmailKey = MCConnectorTest.TRIGGERED_EMAIL_KEY;
        mcTriggerEmailTest.pageObj = testCase;
        mcTriggerEmailTest.init();
        mcTriggerEmailTest.sendMCTriggeredEmail();

        Test.stopTest();

        System.assertEquals(true, mcTriggerEmailTest.emailSent);
    }
}