/**
 * Created by lhowland on 6/12/2020.
 */

@IsTest
public with sharing class OTRBOCAFinancialsControllerTest {

    public static void OTRBOCAFinancialsTest() {

        Program__c program = [SELECT Id, Brand_Short_Name__c, BOCA_Requested_Financial_Documents__c FROM Program__c WHERE Brand_Short_Name__c = 'OTRUPMARKET' LIMIT 1];
        OnlineApplication__c onlineApp = [SELECT Id, Direct_Debit_Form__c, Voided_Check__c, Copy_Of_Driver_s_License__c, Audited_Financials__c, Country_of_Contracting_Entity__c FROM OnlineApplication__c WHERE AO_Name__c = 'Sylvanas Windrunner' LIMIT 1];

        User CreditUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.debug('Found Credit User: ' + CreditUser.Id);

        System.runAs(CreditUser) {

            Test.startTest();

            PageReference otrBOCAFinancials = Page.OTRBOCAFinancials;
            otrBOCAFinancials.getParameters().put('pgm', program.Brand_Short_Name__c);
            otrBOCAFinancials.getParameters().put('customer', onlineApp.Id);
            otrBOCAFinancials.getParameters().put('lang', 'en_us');

            Test.setCurrentPage(otrBOCAFinancials);

            OTRBOCAFinancialsController financialsController = new OTRBOCAFinancialsController();
            List<Attachment> attachments = financialsController.existingAttachments;
            Integer attachmentSize = financialsController.existingAttachmentsSize;

            System.assert(attachmentSize == 0);

            financialsController.init();
            System.assert(financialsController.defaultBrandingUtility != null);
            financialsController.logError(new WexBOCAFinancialsController.creditApplicationException('test'));
            financialsController.creditApp = onlineApp;
            financialsController.docTypeList[0].attachmentName = 'test';
            financialsController.docTypeList[0].attachmentBody = Blob.valueOf('test');
            financialsController.uploadFile();
            financialsController.submitApplication();

            Test.stopTest();
        }
    }
}