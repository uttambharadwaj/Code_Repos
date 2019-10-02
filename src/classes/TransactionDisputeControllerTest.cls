@isTest
public with sharing class TransactionDisputeControllerTest {

    @testSetup
    static void setup(){
    
        //Copied from CustomerDetailsTest
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        CustomerDetailsWSUtilv2.customerDetails details = CustomerDetailsController.getCustomerDetails('9100000000000','',null);
        String jsonAccountString = JSON.serialize(details);
        System.debug('### jsonAccountString='+jsonAccountString);
        List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts('9100000000000');
                UtilityTestLoader.setAutomation(false);

        String contactJsonString = JSON.serialize(contacts);
        System.debug('### contactJsonString='+contactJsonString);

        Id genericProgramId;
        Id genericPartnerId;
        String programRowId;

        List<Program__c> genericPrograms = [SELECT Id, Siebel_Program_Row_Id__c, Partner__c FROM Program__c WHERE RecordType.Name = 'CPS Program' AND Brand_Short_Name__c = 'WEXGeneric'];

        System.debug('### Generic Program search returns '+genericPrograms);
        if (genericPrograms.size() > 0) {
            genericProgramId = genericPrograms[0].Id;
            genericPartnerId = genericPrograms[0].Partner__c;
            programRowId = genericPrograms[0].Siebel_Program_Row_Id__c;
        }
        else {
            programRowId =  '1-12N3P99';

            Partner__c partner = new Partner__c();
            partner.Name = 'WEXGeneric';

            insert partner;

            genericPartnerId = partner.Id;

            Program__c program = new Program__c();

            program.Name = 'WEXGeneric';
            program.Form_Template__c = 'WEXGeneric';
            program.Brand_Short_Name__c = 'WEXGeneric';
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
            program.Siebel_Program_Row_Id__c = programRowId;
            program.Partner__c = genericPartnerId;

            insert program;
            genericProgramId = program.Id;
        }

        if (genericPartnerId == null) {
            Partner__c partner = new Partner__c();
            partner.Name = 'WEXGeneric';

            insert partner;

            genericPartnerId = partner.Id;

            Program__c program = [SELECT Id, Partner__c FROM Program__c WHERE Id =: genericProgramId];
            program.Partner__c = genericPartnerId;
            update program;

        }

        Id accountId =  CustomerDetailsController.upsertAccount(jsonAccountString);

        Id contactId = CustomerDetailsController.upsertContacts(accountId,contactJsonString,'1-1ZZZZZ');
        
        IntegrationRecord__c integrationRecord = new IntegrationRecord__c();
        integrationRecord.Contact__c = contactId;
        integrationRecord.Account__c = accountId;
        integrationRecord.Contact_Row_Id__c = '1-1ZZZZZ';
        insert integrationRecord;

        System.debug('Upserted contactId = '+contactId);
    }

    static testMethod void testTransactionDisputeForm() {
system.debug('testtransactiondisputeform');
        TestUtils.enable_isRunningTest = true;

        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

        Test.startTest();

        TransactionDisputeController.checkIfAccountExists('9100000000000');

        TransactionDisputeController transactionDisputeController = new TransactionDisputeController();

        transactionDisputeController.accountNumber = '9100000000000';

        transactionDisputeController.init();

        transactionDisputeController.nextStep();

        System.assert(transactionDisputeController.action != null);
        System.assert(transactionDisputeController.claimIdParameter == null);
        System.assert(transactionDisputeController.claimAttachments == null);
        System.assert(transactionDisputeController.sizeOfClaimAttachments == 0);
        System.assert(transactionDisputeController.selectedFile == null);

        System.assert(transactionDisputeController.claim == null);
        System.assert(transactionDisputeController.claimNumber == null);
        System.assert(transactionDisputeController.transactionDispute != null);
        System.assert(transactionDisputeController.customerDetails != null);
        System.assert(transactionDisputeController.customerContacts != null);

        System.assert(transactionDisputeController.sizeOfFraudPurchaseDevices == 1);
        System.assert(transactionDisputeController.selectedAsset == null);
        System.assert(transactionDisputeController.accountNumber != null);

        System.assert(transactionDisputeController.authorizedUserFullName != null);
        System.assert(transactionDisputeController.authorizedUserEmail != null);
        System.assert(transactionDisputeController.todaysDate != null);
        System.assert(transactionDisputeController.previousStep == false);
        System.assert(transactionDisputeController.nextStep == false);

        transactionDisputeController.selectedStep = '2';

        transactionDisputeController.goToSelectedStep();

        transactionDisputeController.addAsset();

        transactionDisputeController.selectedAsset = '1';

        transactionDisputeController.removeAsset();

        transactionDisputeController.transactionDispute.lostOrStolenDate = String.valueOf((Date.today()).format());

        transactionDisputeController.transactionDispute.driverName = 'That Guy';
        transactionDisputeController.transactionDispute.driverEmploymentStartDate = String.valueOf((Date.today()).format());
        transactionDisputeController.transactionDispute.driverEmploymentEndDate = String.valueOf((Date.today()).format());

        transactionDisputeController.transactionDispute.additionalComments = 'Stuff';

        transactionDisputeController.transactionDispute.agencyName1 = 'That Guy';
        transactionDisputeController.transactionDispute.personnelName1 = 'That Guy';
        transactionDisputeController.transactionDispute.dateOfReport1 = String.valueOf((Date.today()).format());
        transactionDisputeController.transactionDispute.reportNumber1 = 'That Guy';
        transactionDisputeController.transactionDispute.agencyPhone1 = '555-555-5555';
        transactionDisputeController.transactionDispute.agencyEmail1 = 'test@test.com';

        transactionDisputeController.transactionDispute.agencyName2 = 'That Guy';
        transactionDisputeController.transactionDispute.personnelName2 = 'That Guy';
        transactionDisputeController.transactionDispute.dateOfReport2 = String.valueOf((Date.today()).format());
        transactionDisputeController.transactionDispute.reportNumber2 = 'That Guy';
        transactionDisputeController.transactionDispute.agencyPhone2 = '555-555-5555';
        transactionDisputeController.transactionDispute.agencyEmail2 = 'test@test.com';

        transactionDisputeController.transactionDispute.fraudPurchaseDevices.get(0).vehicleCardNumber = '1234';
        transactionDisputeController.transactionDispute.fraudPurchaseDevices.get(0).gTag = '1234';
        transactionDisputeController.transactionDispute.fraudPurchaseDevices.get(0).dateAbuseBegan = String.valueOf((Date.today()).format());
        transactionDisputeController.transactionDispute.fraudPurchaseDevices.get(0).dateAbuseEnded = String.valueOf((Date.today()).format());
        transactionDisputeController.transactionDispute.fraudPurchaseDevices.get(0).amountOfAbuse = '1000';

        transactionDisputeController.submitForm();

        transactionDisputeController.attachmentName = 'ThatName';
        transactionDisputeController.attachmentBody = Blob.valueOf('I\'m  a little teapot');

        transactionDisputeController.uploadFile();

        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId =: transactionDisputeController.claim.Id];

        if(attachments.size() > 0) {

            PageReference transactionDisputeForm = Page.TransactionDisputeForm;
            transactionDisputeForm.getParameters().put('id', transactionDisputeController.claim.Id);
            transactionDisputeForm.getParameters().put('selectedFile', attachments[0].Id);
            transactionDisputeForm.getParameters().put('action', 'attachFiles');

            Test.setCurrentPage(transactionDisputeForm);

            transactionDisputeController = new TransactionDisputeController();

            transactionDisputeController.init();

            transactionDisputeController.deleteFile();

        }

        Test.stopTest();

    }

}