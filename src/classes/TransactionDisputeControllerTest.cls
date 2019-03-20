@isTest
public with sharing class TransactionDisputeControllerTest {

    static testMethod void testTransactionDisputeForm() {

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

        System.assert(transactionDisputeController.physicalAddress != null);

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