/**
 * Created by dgilbert on 6/20/2018.
 */

@isTest
public class WEXDEVErrorReportingTest {

    @testSetup
    static void setupData() {

        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Peoplesoft_rel_code__c = '012011';
        program.Form_Template__c = 'WexBOCA';
        program.Brand_Short_Name__c = 'TestBOCA';
        program.Preferred_Language_Indicator__c = 'ENU';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        program.Brand_Long_Name__c = 'Test BOCA';
        program.Upload_Pricing_Data_Flag__c = false;
        program.Auto_Send_BOCA_to_Siebel__c = false;
        program.T_C__c = 'WEX_BOCA_TNC';
        program.Analytics_Body_Block__c = '';
        program.Analytics_Head_Block__c = '';
        program.Brand_Color_1__c = '#ccc';
        program.Brand_Color_2__c = '#fff';

        insert program;

        // Setup Attachments
        Attachment cardImage = new Attachment();
        cardImage.Name = 'ui-credit-card.png';
        Blob cardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImage.body = cardImageBlob;
        cardImage.parentId = program.Id;
        upsert cardImage;

        Attachment logo = new Attachment();
        logo.Name = 'ui-logo.png';
        Blob logoBlob = Blob.valueOf('Unit Test Attachment Body');
        logo.body = logoBlob;
        logo.parentId = program.Id;
        upsert logo;

    }

    public class errorReportingException extends Exception {}

    static testMethod void testInternalErrorReporting() {

        WEXDEVErrorReporting.reportInternalError('BOCA', 'https://www.ihavenoidea.com', UserInfo.getUserId(), new errorReportingException('eeee'));

    }

    static testMethod void testExternalErrorReporting() {

        String errorCode = WEXDEVErrorReporting.reportExternalError('BOCA', 'https://www.ihavenoidea.com', new errorReportingException('eeee'));

        PageReference externalApplicationError = Page.ExternalApplicationError;
        externalApplicationError.getParameters().put('pgm', 'TestBOCA');
        externalApplicationError.getParameters().put('errorCode', errorCode);

        Test.setCurrentPage(externalApplicationError);

        ExternalApplicationErrorController externalApplicationErrorController = new ExternalApplicationErrorController();

        externalApplicationErrorController.init();

    }

}