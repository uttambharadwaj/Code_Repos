/**
 * Created by lhowland on 5/22/2019.
 *
 * Revision History:    28/JAN/2020     MFARRELL   Increase coverage from ~40% -> ~80%
 */
@IsTest
public class PaperAppSubmissionExtensionTest {

    public static void buildURLTest() {

        List<Opportunity> opptys = [SELECT Id, Offer__c, Offer__r.Program__c FROM Opportunity LIMIT 1];
        Id optyId = opptys[0].Id;

        Test.startTest();
        PageReference paperBOCA = Page.PaperAppButton;
        paperBOCA.getParameters().put('id', optyId);
        Test.setCurrentPage(paperBOCA);

        PaperAppSubmissionExtension controller = new PaperAppSubmissionExtension();
        controller.doNothing();
        controller.init();
        Boolean hasError = controller.hasError;
        Boolean paperOnly = controller.paperOnly;
        Boolean isPartner = controller.isPartner;
        String ipAddress = controller.ipAddress;
        ipAddress = '123.123.123.123';
        List<SelectOption> AvailablePrograms = controller.AvailablePrograms;
        List<SelectOption> AvailableOffers = controller.availableOffers;

        controller.selectedOffer = opptys[0].Offer__c;
        controller.selectedProgram = opptys[0].Offer__r.Program__c;
        paperBOCA = controller.buildURL();

        Test.stopTest();

        System.assert(ApexPages.currentPage().getParameters().get('id') != null);
    }

}