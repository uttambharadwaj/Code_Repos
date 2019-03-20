@IsTest
public with sharing class ESSOConversionControllerTest {

    @testSetup
    static void setupData() {

        Customer_Conversion_Data__c conversionData = new Customer_Conversion_Data__c();

        conversionData.Previous_Account_Number__c = '123456789';
        conversionData.Conversion_Record_Key__c = 'ESSO-123456789';

        conversionData.Company_Name__c = 'Test Company';
        conversionData.First_Name__c = 'Test';
        conversionData.Last_Name__c = 'McTesterson';
        conversionData.Phone__c = '207-523-6969';
        conversionData.Email_Address__c = 'test@test.com';

        conversionData.Mailing_Address_Line_1__c = 'First Line';
        conversionData.Mailing_Address_Line_2__c = 'Second Line';
        conversionData.Mailing_City__c = 'Some City';
        conversionData.Mailing_State__c = 'QB';
        conversionData.Mailing_Postal_Code__c = 'A1A-1A1';

        conversionData.Physical_Address_Line_1__c = 'First Line';
        conversionData.Physical_Address_Line_2__c = 'Second Line';
        conversionData.Physical_City__c = 'Some City';
        conversionData.Physical_State__c = 'QB';
        conversionData.Physical_Postal_Code__c = 'A1A-1A1';

        conversionData.BPAV_Needed__c = true;
        conversionData.TIN_Needed__c = true;

        conversionData.Certified_By__c = 'Test McTesterson';
        conversionData.Certified_Date__c = Date.today();

        conversionData.Status__c = 'Pending Customer Response';

        insert conversionData;

    }

    static testmethod void testESSOConversionController() {

        PageReference essoConversionPage = Page.ESSOConversion;
        essoConversionPage.getParameters().put('lang', 'en_ca');

        Test.setCurrentPage(essoConversionPage);

        Test.startTest();

        System.assert(ESSOConversionController.validatePreviousAccountNumber('123456789') == true);

        ESSOConversionController essoConversionController = new ESSOConversionController();

        essoConversionController.init();

        essoConversionController.previousAccountNumber = '123456789';

        essoConversionController.nextStep();

        essoConversionController.mailingAddressSame = false;

        PageReference nullPageReference = essoConversionController.mailingAddressSameToggle();

        essoConversionController.mailingAddressSame = true;

        nullPageReference = essoConversionController.mailingAddressSameToggle();

        essoConversionController.bpavEvidenceBody = Blob.valueOf('This is a test');
        essoConversionController.bpavEvidenceName = 'EvidenceDocument.txt';

        essoConversionController.submitConversionForm();

        System.assert(essoConversionController.cacheControl != null);
        System.assert(essoConversionController.todaysDate != null);
        System.assert(essoConversionController.confirmationNumber == null);

        Test.stopTest();

    }

}