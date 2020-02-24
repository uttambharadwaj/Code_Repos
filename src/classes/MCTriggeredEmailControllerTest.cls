@IsTest
public class MCTriggeredEmailControllerTest {


    @IsTest
    public static void testMCTriggeredEmailController() {

        Test.startTest();

        Case testCase = [ SELECT Id, RecordTypeId FROM Case WHERE RecordTypeId != NULL ];

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);

        PageReference mcTriggeredEmailPage = Page.MarketingTriggeredEmail;
        Test.setCurrentPage(mcTriggeredEmailPage);

        MCTriggeredEmailController mcTriggerEmailTest = new MCTriggeredEmailController(sc);

        // TODO insert metadata records
        Test.stopTest();
    }
}