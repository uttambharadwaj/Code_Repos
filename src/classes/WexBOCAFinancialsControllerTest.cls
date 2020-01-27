/**
 * Created by mfarrell on 2020-01-22.
 */

@IsTest
public class WexBOCAFinancialsControllerTest {

    public static void WexBOCAFinancialsTest() {

        WeFormObject__c weForm = [SELECT Id, Application_Request__c, Program__c, Program__r.Brand_Short_Name__c FROM WeFormObject__c LIMIT 1];
        Program__c program = [SELECT Id, Brand_Short_Name__c, Require_Financial_Documents__c FROM Program__c WHERE Id =: weForm.Program__c];
        Application_Request__c appReq = [SELECT Id, Direct_Debit_Form__c, Voided_Check__c, Copy_Of_Driver_s_License__c, Audited_Financials__c FROM Application_Request__c WHERE Id =: weForm.Application_Request__c];

        User CreditUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.debug('Found Credit User: ' + CreditUser.Id);

        System.runAs(CreditUser) {

            Test.startTest();

            PageReference wexBOCAFinancials = Page.WexBOCAFinancials;
            wexBOCAFinancials.getParameters().put('pgm', program.Brand_Short_Name__c);
            wexBOCAFinancials.getParameters().put('id', weForm.Id);
            wexBOCAFinancials.getParameters().put('lang', 'en_us');

            Test.setCurrentPage(wexBOCAFinancials);

            WexBOCAFinancialsController financialsController = new WexBOCAFinancialsController();
            Boolean requireFinancials = financialsController.requireFinancials;
            List<Attachment> Attachments = financialsController.existingAttachments;
            Integer howManyAttachments = financialsController.existingAttachmentsSize;

            financialsController.init();
            System.assert(financialsController.defaultBrandingUtility != null);
            financialsController.logError(new WexBOCAFinancialsController.creditApplicationException('test'));
            financialsController.appReq = appReq;
            financialsController.weFrom = weForm;
            financialsController.docTypeList[0].attachmentName = 'test';
            financialsController.docTypeList[0].attachmentBody = Blob.valueOf('test');
            financialsController.uploadFile();
            financialsController.submitApplication();

            Test.stopTest();
        }
    }
}