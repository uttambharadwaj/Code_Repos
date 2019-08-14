/**
 * Created by dgilbert on 9/25/2018.
 */

@isTest
public with sharing class AttachmentUploadControllerTest {

    static testMethod void testAttachmentUploadController() {

        User sinte = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runas(sinte) {

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

            Test.startTest();

            PageReference attachmentUpload = Page.AttachmentUpload;
            attachmentUpload.getParameters().put('parentRecordId', program.Id);

            Test.setCurrentPage(attachmentUpload);

            // Happy Path
            AttachmentUploadController attachmentUploadController = new AttachmentUploadController();

            attachmentUploadController.init();

            System.assert(attachmentUploadController.parentRecordId != null);
            System.assert(attachmentUploadController.parentRecordType != null);
            System.assert(attachmentUploadController.recordName != null);
            System.assert(attachmentUploadController.hasError != true);

            attachmentUploadController.attachmentName = 'ui-logo.png';
            attachmentUploadController.attachmentBody = Blob.valueOf('Unit Test Attachment Body');

            PageReference redirect = attachmentUploadController.uploadFile();

            System.assert(redirect != null);

            attachmentUpload = Page.AttachmentUpload;
            attachmentUpload.getParameters().put('parentRecordId', program.Id);
            attachmentUpload.getParameters().put('confirmUpload', 'true');

            Test.setCurrentPage(attachmentUpload);

            attachmentUploadController = new AttachmentUploadController();

            attachmentUploadController.init();

            // Error Path
            attachmentUpload = Page.AttachmentUpload;
            attachmentUpload.getParameters().put('parentRecordId', program.Id);
            attachmentUpload.getParameters().put('confirmUpload', 'false');
            attachmentUpload.getParameters().put('errorCode', '123456');

            Test.setCurrentPage(attachmentUpload);

            attachmentUploadController = new AttachmentUploadController();

            attachmentUploadController.init();

            System.assert(attachmentUploadController.hasError == true);

            Test.stopTest();

        }


    }

}