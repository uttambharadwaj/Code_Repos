// This test class exercises the following code --
// 
// FleetEnrollmentController - the main controller of the application
// FleetEnrollmentPrintController - the print page controller
// FleetEnrollmentErrorController - the error page controller
// FDFCValidate - the trigger for enabling the FDCF on a Program
// 
// DDG Jan/2017

@isTest
public class FleetEnrollmentTest {

    @testSetup
    static void setupData() {

        insert new Fleet_Enrollment_Settings__c(Enable_Siebel_Opportunity_Update__c = true);

        Campaign campaign = new Campaign();

        //create campaign test data
        campaign.Coupon_Code__c = 'TEST1';
        campaign.Name = 'TestCampaign';
        campaign.Type = 'Online Form';
        campaign.Status = 'In Progress';
        campaign.Drop_Date__c = date.today();
        campaign.EndDate = date.today();
        campaign.CurrencyIsoCode = 'USD';
        campaign.IsActive = true;

        insert campaign;

        // Setup Program
        Program__c program = new Program__c();

        program.Name = 'Sunoco Fleet' ;
        program.Brand_Short_Name__c = 'sunoco';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Long_Name__c = 'Sunoco Fleet';
        program.Brand_Color_1__c = '#ccc';
        program.Implementation_Team_Number__c = '1-888-888-8888';
        program.Fleet_Data_Capture_Email_Template__c = '0000000';
        program.Fleet_Data_Capture_Form_Delivery__c = '2-3';
        program.Fleet_Available_Card_Types__c = 'Vehicle;Driver';
        program.Fleet_Available_Usage_Types__c = '1:1;1:M';
        program.WEX_Associations__c = 'BizUnite';
        program.Fleet_Available_Billing_Cycles__c = 'Cycle 4';
        program.Allow_Partner_Billed_Overnight_Cards__c = true;

        upsert program;

        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        System.debug(program.Publish_Fleet_Data_Capture_Form__c);

        // Setup Attachments
        Attachment cardImage = new Attachment();
        cardImage.Name = 'ui-credit-card.png';
        Blob cardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImage.body = cardImageBlob;
        cardImage.parentId = program.Id;
        upsert cardImage;

        Attachment cardImageNoText = new Attachment();
        cardImageNoText.Name = 'ui-credit-card-no-text.png';
        Blob cardImageNoTextBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImageNoText.body = cardImageNoTextBlob;
        cardImageNoText.parentId = program.Id;
        upsert cardImageNoText;

        program.Publish_Fleet_Data_Capture_Form__c = true;

        upsert program;

    }

    static testMethod void FDFCTest() {

        Test.startTest();

        List<Program__c> programs = [SELECT Id FROM Program__c LIMIT 1];

        if (programs.size() > 0) {

            Program__c testProgram = WexBrandingController.getProgram(programs[0].Id);

            System.assert(testProgram.Publish_Fleet_Data_Capture_Form__c == true);

            // Test the main fleet enrollment form
            PageReference fleetEnrollment = Page.FleetEnrollment;
            fleetEnrollment.getParameters().put('crd', '5000');
            fleetEnrollment.getParameters().put('program', testProgram.Brand_Short_Name__c);
            fleetEnrollment.getParameters().put('opty', '1-1ABCDE');

            Test.setCurrentPage(fleetEnrollment);

            FleetEnrollmentController fleetEnrollmentController = new FleetEnrollmentController();

            fleetEnrollmentController.init();

            // Page 1
            fleetEnrollmentController.fleetEnrollment.Billing_Full_Name__c = 'Test McTesterson';
            fleetEnrollmentController.fleetEnrollment.Billing_Email__c = 'test@test.com';
            fleetEnrollmentController.fleetEnrollment.Billing_Phone__c = '207-555-5555';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_1__c = '123 Darling Ave';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_2__c = '';
            fleetEnrollmentController.fleetEnrollment.Billing_City__c = 'South Portland';
            fleetEnrollmentController.fleetEnrollment.Billing_State__c = 'Me';
            fleetEnrollmentController.fleetEnrollment.Billing_Postal_Code__c = '04106';

            fleetEnrollmentController.addNewContact();
            fleetEnrollmentController.selectedFleetContact = 1;
            fleetEnrollmentController.removeContact();

            // Page 2
            fleetEnrollmentController.fleetEnrollment.Number_of_Vehicles__c = 2;
            fleetEnrollmentController.fleetEnrollment.Embossing_Company_Name__c = 'Testerson Industries';
            fleetEnrollmentController.fleetEnrollment.Embossing_Second_Line__c = 'License Plate';
            fleetEnrollmentController.fleetEnrollment.Reporting_Dept__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleDesc__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_LicensePlt__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleId__c = true;

            // Page 3
            fleetEnrollmentController.addNewFleetVehicle();
            fleetEnrollmentController.fleetVehicles.get(0).companyVehicleId = '1111';
            fleetEnrollmentController.fleetVehicles.get(0).selectedCardControlOption = 'Custom Controls';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDepartment = 'Parts';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDescription = 'Ford 250';
            fleetEnrollmentController.fleetVehicles.get(0).licensePlate = '1111MV';

            fleetEnrollmentController.addNewFleetVehicle();
            fleetEnrollmentController.changeSelectedCardControlOption();
            fleetEnrollmentController.selectedFleetVehicle = 1;
            fleetEnrollmentController.removeFleetVehicle();

            // Page 4
            fleetEnrollmentController.selectedDriverIdOption = 'custom';

            fleetEnrollmentController.changeDriverIdOption();

            fleetEnrollmentController.fleetDrivers.get(0).firstName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).lastName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).driverId = '1111';

            fleetEnrollmentController.addNewFleetDriver();
            fleetEnrollmentController.selectedFleetDriver = 1;
            fleetEnrollmentController.removeFleetDriver();

            // Whole bunch of asserts..
            System.assert(fleetEnrollmentController.embossingOptions != null);
            System.assert(fleetEnrollmentController.cardControlOptions != null);
            System.assert(fleetEnrollmentController.driverIdOptions != null);
            System.assert(fleetEnrollmentController.creditLineAmount != null);
            System.assert(fleetEnrollmentController.promptOptions != null);
            System.assert(fleetEnrollmentController.program != null);
            System.assert(fleetEnrollmentController.brandingCard != null);
            System.assert(fleetEnrollmentController.dynamicCard != null);
            System.assert(fleetEnrollmentController.previousStep != null);
            System.assert(fleetEnrollmentController.nextStep != null);

            // Pagination love
            fleetEnrollmentController.nextStep();
            fleetEnrollmentController.previousStep();
            fleetEnrollmentController.doNothing();

            fleetEnrollmentController.submitApplication();

            System.assert(fleetEnrollmentController.confirmationNumber != null);
            System.assert(fleetEnrollmentController.printToken != null);

            // Testing the confirmation functionality
            PageReference fleetEnrollmentConfirmation = Page.FleetEnrollmentConfirmation;
            fleetEnrollmentConfirmation.getParameters().put('applicant', fleetEnrollmentController.fleetEnrollment.Id);
            fleetEnrollmentConfirmation.getParameters().put('token', fleetEnrollmentController.printToken);

            Test.setCurrentPage(fleetEnrollmentConfirmation);

            FleetEnrollmentConfirmationController fleetEnrollmentConfirmationController = new FleetEnrollmentConfirmationController();

            System.assert(fleetEnrollmentConfirmationController.printToken != null);
            System.assert(fleetEnrollmentConfirmationController.applicantId != null);
            System.assert(fleetEnrollmentConfirmationController.fleetEnrollment != null);
            System.assert(fleetEnrollmentConfirmationController.program != null);
            System.assert(fleetEnrollmentConfirmationController.brandingCard != null);

            // Testing the print functionality
            PageReference fleetEnrollmentPrint = Page.FleetEnrollmentPrint;
            fleetEnrollmentPrint.getParameters().put('id', fleetEnrollmentController.fleetEnrollment.Id);
            fleetEnrollmentPrint.getParameters().put('token', fleetEnrollmentController.printToken);

            Test.setCurrentPage(fleetEnrollmentPrint);

            FleetEnrollmentPrintController fleetEnrollmentPrintController = new FleetEnrollmentPrintController();

            System.assert(fleetEnrollmentPrintController.fleetEnrollment != null);
            System.assert(fleetEnrollmentPrintController.fleetEnrollmentContacts != null);
            System.assert(fleetEnrollmentPrintController.fleetEnrollmentVehicles != null);
            System.assert(fleetEnrollmentPrintController.fleetEnrollmentDrivers != null);
            System.assert(fleetEnrollmentPrintController.program != null);

            // Testing the print XLS functionality
            PageReference fleetEnrollmentXLS = Page.FleetEnrollmentXLS;
            fleetEnrollmentXLS.getParameters().put('id', fleetEnrollmentController.fleetEnrollment.Id);

            Test.setCurrentPage(fleetEnrollmentXLS);

            FleetEnrollmentXLSController fleetEnrollmentXLSController = new FleetEnrollmentXLSController();

            System.assert(fleetEnrollmentXLSController.fleetEnrollment != null);
            System.assert(fleetEnrollmentXLSController.fleetEnrollmentContacts != null);
            System.assert(fleetEnrollmentXLSController.fleetEnrollmentVehicles != null);
            System.assert(fleetEnrollmentXLSController.fleetEnrollmentDrivers != null);
            System.assert(fleetEnrollmentXLSController.program != null);

            // Test the error functionality
            PageReference fleetEnrollmentError = Page.FleetEnrollmentError;
            fleetEnrollmentError.getParameters().put('errorCode', '1');
            fleetEnrollmentError.getParameters().put('errorReferenceNumber', 'ERROR-0000');
            fleetEnrollmentError.getParameters().put('program', 'sunoco');

            Test.setCurrentPage(fleetEnrollmentError);

            FleetEnrollmentErrorController fleetEnrollmentErrorController = new FleetEnrollmentErrorController();

            System.assert(fleetEnrollmentErrorController.errorReferenceNumber != null);
            System.assert(fleetEnrollmentErrorController.errorTimeStamp != null);
            System.assert(fleetEnrollmentErrorController.program != null);
            System.assert(fleetEnrollmentErrorController.errorCode != null);

            Test.stopTest();

        }

    }

    static testMethod void FDFCTestFromBOCA() {

        List<Program__c> programs = [SELECT Id FROM Program__c LIMIT 1];

        if (programs.size() > 0) {

            Program__c testProgram = WexBrandingController.getProgram(programs[0].Id);

            Test.startTest();

            System.assert(testProgram.Publish_Fleet_Data_Capture_Form__c == true);

            User integrationUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

            Application_Request__c applicationRequest = new Application_Request__c();

            System.runAs(integrationUser) {

                Opportunity opportunity = new Opportunity(name = 'TestOpp', closedate = date.newinstance(2015, 11, 11), stagename = '5) Signed', fleet_size__c = 10, ownerId = integrationUser.Id, sourcesystem__c = 'test');
                opportunity.Fueling_Methos__c = 'BP';

                insert opportunity;

                Contact primaryContact = new Contact();

                primaryContact.FirstName = 'Test';
                primaryContact.LastName = 'McTesterson';
                primaryContact.Phone = '555-555-5555';
                primaryContact.Fax = '555-555-5555';
                primaryContact.Email = 'test@wexinc.com';

                insert primaryContact;

                applicationRequest.Sales_Stage__c = '06 - Approved';
                applicationRequest.Opportunity__c = opportunity.Id;
                applicationRequest.Billing_Contact__c = primaryContact.Id;

                insert applicationRequest;

            }

            // Test the main fleet enrollment form

            PageReference fleetEnrollment = Page.FleetEnrollment;
            fleetEnrollment.getParameters().put('program', testProgram.Brand_Short_Name__c);
            fleetEnrollment.getParameters().put('appId', applicationRequest.Id);

            Test.setCurrentPage(fleetEnrollment);

            FleetEnrollmentController fleetEnrollmentController = new FleetEnrollmentController();

            fleetEnrollmentController.init();

            // Page 1
            fleetEnrollmentController.fleetEnrollment.Billing_Full_Name__c = 'Test McTesterson';
            fleetEnrollmentController.fleetEnrollment.Billing_Email__c = 'test@test.com';
            fleetEnrollmentController.fleetEnrollment.Billing_Phone__c = '207-555-5555';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_1__c = '123 Darling Ave';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_2__c = '';
            fleetEnrollmentController.fleetEnrollment.Billing_City__c = 'South Portland';
            fleetEnrollmentController.fleetEnrollment.Billing_State__c = 'Me';
            fleetEnrollmentController.fleetEnrollment.Billing_Postal_Code__c = '04106';

            fleetEnrollmentController.addNewContact();
            fleetEnrollmentController.selectedFleetContact = 1;
            fleetEnrollmentController.removeContact();

            // Page 2
            fleetEnrollmentController.fleetEnrollment.Number_of_Vehicles__c = 2;
            fleetEnrollmentController.fleetEnrollment.Embossing_Company_Name__c = 'Testerson Industries';
            fleetEnrollmentController.fleetEnrollment.Embossing_Second_Line__c = 'License Plate';
            fleetEnrollmentController.fleetEnrollment.Reporting_Dept__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleDesc__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_LicensePlt__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleId__c = true;

            // Page 3
            fleetEnrollmentController.addNewFleetVehicle();
            fleetEnrollmentController.fleetVehicles.get(0).companyVehicleId = '1111';
            fleetEnrollmentController.fleetVehicles.get(0).selectedCardControlOption = 'Custom Controls';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDepartment = 'Parts';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDescription = 'Ford 250';
            fleetEnrollmentController.fleetVehicles.get(0).licensePlate = '1111MV';

            fleetEnrollmentController.addNewFleetVehicle();
            fleetEnrollmentController.changeSelectedCardControlOption();
            fleetEnrollmentController.selectedFleetVehicle = 1;
            fleetEnrollmentController.removeFleetVehicle();

            // Page 4
            fleetEnrollmentController.selectedDriverIdOption = 'custom';

            fleetEnrollmentController.changeDriverIdOption();

            fleetEnrollmentController.fleetDrivers.get(0).firstName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).lastName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).driverId = '1111';

            fleetEnrollmentController.addNewFleetDriver();
            fleetEnrollmentController.selectedFleetDriver = 1;
            fleetEnrollmentController.removeFleetDriver();

            // Whole bunch of asserts..
            System.assert(fleetEnrollmentController.embossingOptions != null);
            System.assert(fleetEnrollmentController.acceptanceOptions != null);
            System.assert(fleetEnrollmentController.cardControlOptions != null);
            System.assert(fleetEnrollmentController.driverIdOptions != null);
            System.assert(fleetEnrollmentController.promptOptions != null);
            System.assert(fleetEnrollmentController.program != null);
            System.assert(fleetEnrollmentController.brandingCard != null);
            System.assert(fleetEnrollmentController.dynamicCard != null);
            System.assert(fleetEnrollmentController.previousStep != null);
            System.assert(fleetEnrollmentController.nextStep != null);
            System.assert(fleetEnrollmentController.configuredDIDLength != null);
            System.assert(fleetEnrollmentController.selectedDIDLength != null);

            // Pagination love
            fleetEnrollmentController.nextStep();
            fleetEnrollmentController.previousStep();
            fleetEnrollmentController.doNothing();

            fleetEnrollmentController.submitApplication();

            System.assert(fleetEnrollmentController.confirmationNumber != null);

            System.debug('*** DEBUG Fleet Enrollment: ' + fleetEnrollmentController.fleetEnrollment.Id);
            System.debug('*** DEBUG Fleet Enrollment Application ID: ' + fleetEnrollmentController.fleetEnrollment.Application_Request__c);
            System.debug('*** DEBUG Fleet Enrollment Opportunity Number: ' + fleetEnrollmentController.fleetEnrollment.Opportunity_Number__c);

            System.debug('*** DEBUG Application Id: ' + applicationRequest.Id);

            // Test trigger with it disabled
            applicationRequest.Siebel_Oppty__c = '1-ABCDE';

            update applicationRequest;

            List<FleetEnrollment__c> fleetEnrollmentUpdated = [SELECT Id, Opportunity_Number__c FROM FleetEnrollment__c WHERE Id = :fleetEnrollmentController.fleetEnrollment.Id];

            if (!fleetEnrollmentUpdated.isEmpty()) {
                System.assertEquals('1-ABCDE', fleetEnrollmentUpdated[0].Opportunity_Number__c);

                // Test fleet enrollment exports..
                ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name From FleetEnrollment__c Where Id = :fleetEnrollmentUpdated[0].Id]));

                FleetEnrollmentExportController exports = new FleetEnrollmentExportController(standardSetController);

                System.assert(exports.fleetEnrollmentsToDownload != null);

                PageReference exportReference = exports.downloadAttachments();

                System.assert(exportReference != null);
            }

            Test.stopTest();

        }

    }

    static testMethod void FDFCTestInternal() {

        List<Program__c> programs = [SELECT Id FROM Program__c LIMIT 1];

        if (programs.size() > 0) {

            Program__c testProgram = WexBrandingController.getProgram(programs[0].Id);

            Id campaignProgramId = [SELECT Id FROM Campaign_Program__c WHERE Program__c = :testProgram.Id LIMIT 1].Id;
            Id campaignId = [SELECT Campaign__c FROM Campaign_Program__c WHERE Program__c = :testProgram.Id LIMIT 1].Campaign__c;

            Test.startTest();

            System.assert(testProgram.Publish_Fleet_Data_Capture_Form__c == true);

            User integrationUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

            Application_Request__c applicationRequest = new Application_Request__c();

            System.runAs(integrationUser) {

                Opportunity opportunity = new Opportunity(name = 'TestOpp', closedate = date.newinstance(2015, 11, 11), stagename = '5) Signed', fleet_size__c = 10, ownerId = integrationUser.Id, sourcesystem__c = 'test', CampaignId = campaignId, Campaign_Program__c = campaignProgramId);
                opportunity.Fueling_Methos__c = 'BP';

                insert opportunity;

                Contact primaryContact = new Contact();

                primaryContact.FirstName = 'Test';
                primaryContact.LastName = 'McTesterson';
                primaryContact.Phone = '555-555-5555';
                primaryContact.Fax = '555-555-5555';
                primaryContact.Email = 'test@wexinc.com';

                insert primaryContact;

                applicationRequest.Billing_Contact__c = primaryContact.Id;
                applicationRequest.Sales_Stage__c = '06 - Approved';
                applicationRequest.Opportunity__c = opportunity.Id;
                applicationRequest.Siebel_Oppty__c = '1-TEST';

                insert applicationRequest;

                PageReference fleetEnrollmentInternal = Page.FleetEnrollmentInternal;
                fleetEnrollmentInternal.getParameters().put('opportunityId', opportunity.Id);

                Test.setCurrentPage(fleetEnrollmentInternal);

                FleetEnrollmentInternalController fleetEnrollmentInternalController = new FleetEnrollmentInternalController();

                fleetEnrollmentInternalController.init();

                // Asserts
                System.assert(fleetEnrollmentInternalController.errorCode == null);
                System.assert(fleetEnrollmentInternalController.hasError == false);
                System.assert(fleetEnrollmentInternalController.availableCardTypes != null);
                System.assert(fleetEnrollmentInternalController.availableCardTypesSize > 0);
                System.assert(fleetEnrollmentInternalController.availableUsageTypes != null);
                System.assert(fleetEnrollmentInternalController.availableUsageTypesSize > 0);
                System.assert(fleetEnrollmentInternalController.availableAssociations != null);
                System.assert(fleetEnrollmentInternalController.availableAssociationsSize > 0);
                System.assert(fleetEnrollmentInternalController.availableBillingCycles != null);
                System.assert(fleetEnrollmentInternalController.availableBillingCyclesSize > 0);
                System.assert(fleetEnrollmentInternalController.availableStateOptions != null);

                FleetEnrollmentInternalController.FleetEnrollmentInformation fleetEnrollmentInformation = new FleetEnrollmentInternalController.FleetEnrollmentInformation();

                fleetEnrollmentInformation.expeditedCardShipping = true;
                fleetEnrollmentInformation.overnightCardsBillWEX = true;
                fleetEnrollmentInformation.overnightCardsBillPartner = false;
                fleetEnrollmentInformation.overnightCardsBillCustomer = false;
                fleetEnrollmentInformation.overnightCardsFileName = 'File';
                fleetEnrollmentInformation.overnightCardsFileBody = Blob.valueOf('TEST ATTACHMENT');

                fleetEnrollmentInformation.feeWaivers = true;
                fleetEnrollmentInformation.feeWaiversSetupFee = true;
                fleetEnrollmentInformation.feeWaiversSetupFeeAmount = 1.00;
                fleetEnrollmentInformation.feeWaiversCardReplacementDuration = true;
                fleetEnrollmentInformation.feeWaiversCardReplacementDurationAmount = 1.00;
                fleetEnrollmentInformation.feeWaiversMonthlyCardCharges = true;
                fleetEnrollmentInformation.feeWaiversMonthlyCardChargesAmount = 1.00;
                fleetEnrollmentInformation.feeWaiversTFSFileName = 'File';
                fleetEnrollmentInformation.feeWaiversTFSFileBody = Blob.valueOf('TEST ATTACHMENT');

                fleetEnrollmentInformation.billingCycleDifferentThanProgramDefault = true;
                fleetEnrollmentInformation.selectedBillingCycle = 'Cycle 4';
                fleetEnrollmentInformation.hierarchyNeeded = true;
                fleetEnrollmentInformation.stationCard = true;
                fleetEnrollmentInformation.association = true;
                fleetEnrollmentInformation.selectedAssociation = 'ASSOCIATION 1';

                fleetEnrollmentInformation.alternateCardShippingAddress = true;

                fleetEnrollmentInformation.cardShippingAttention = 'Test McTesterson';
                fleetEnrollmentInformation.cardShippingAddressLine1 = '123 Darling Ave';
                fleetEnrollmentInformation.cardShippingAddressLine2 = 'Suite 1';
                fleetEnrollmentInformation.cardShippingCity = 'South Portland';
                fleetEnrollmentInformation.cardShippingState = 'ME';
                fleetEnrollmentInformation.cardShippingPostalCode = '04106';

                fleetEnrollmentInformation.specialShippingAddress = true;

                fleetEnrollmentInformation.specialShippingAttention = 'Test McTesterson';
                fleetEnrollmentInformation.specialShippingAddressLine1 = '123 Darling Ave';
                fleetEnrollmentInformation.specialShippingAddressLine2 = 'Suite 1';
                fleetEnrollmentInformation.specialShippingCity = 'South Portland';
                fleetEnrollmentInformation.specialShippingState = 'ME';
                fleetEnrollmentInformation.specialShippingPostalCode = '04106';

                fleetEnrollmentInformation.fleetDataFileName = 'File';
                fleetEnrollmentInformation.fleetDataFileBody = Blob.valueOf('TEST ATTACHMENT');

                fleetEnrollmentInformation.selectedCardType = 'Vehicle';
                fleetEnrollmentInformation.selectedUsageType = '1:M';

                fleetEnrollmentInformation.overnightCardsFileName = 'TEST';
                fleetEnrollmentInformation.overnightCardsFileBody = Blob.valueOf('123456789');

                fleetEnrollmentInformation.feeWaiversTFSFileName = 'TEST';
                fleetEnrollmentInformation.feeWaiversTFSFileBody = Blob.valueOf('123456789');

                fleetEnrollmentInformation.fleetDataFileName = 'TEST';
                fleetEnrollmentInformation.fleetDataFileBody = Blob.valueOf('123456789');

                fleetEnrollmentInformation.directDebitFileName = 'TEST';
                fleetEnrollmentInformation.directDebitFileBody = Blob.valueOf('123456789');

                fleetEnrollmentInternalController.addNewContact();

                fleetEnrollmentInternalController.selectedContact = '1';

                System.assert(fleetEnrollmentInternalController.additionalContactsSize > -1);

                fleetEnrollmentInternalController.removeContact();

                fleetEnrollmentInformation.fleetEnrollmentContacts.get(0).firstName = 'Test';
                fleetEnrollmentInformation.fleetEnrollmentContacts.get(0).lastName = 'Test';
                fleetEnrollmentInformation.fleetEnrollmentContacts.get(0).emailAddress = 'test@wexinc.com';
                fleetEnrollmentInformation.fleetEnrollmentContacts.get(0).phone = '111-111-1111';

                fleetEnrollmentInternalController.fleetEnrollmentInformation = fleetEnrollmentInformation;

                fleetEnrollmentInternalController.submitForm();

                fleetEnrollmentInternal = Page.FleetEnrollmentInternal;
                fleetEnrollmentInternal.getParameters().put('confirm', 'true');

                Test.setCurrentPage(fleetEnrollmentInternal);

                fleetEnrollmentInternalController.init();

                fleetEnrollmentInternal = Page.FleetEnrollmentInternal;
                fleetEnrollmentInternal.getParameters().put('confirm', 'false');

                Test.setCurrentPage(fleetEnrollmentInternal);

                fleetEnrollmentInternalController.init();

            }

            Test.stopTest();

        }

    }

    static testMethod void testAccountActivationQueue() {

        Case fleetEnrollmentSuccessCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentSuccessCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentSuccessCase.Status = 'New';
        fleetEnrollmentSuccessCase.OwnerId = FleetEnrollmentWS_AccountActivationQueue.activationQueueId;

        insert fleetEnrollmentSuccessCase;

        Case fleetEnrollmentFailedCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentFailedCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentFailedCase.Status = 'New';
        fleetEnrollmentFailedCase.OwnerId = FleetEnrollmentWS_AccountActivationQueue.activationQueueId;

        insert fleetEnrollmentFailedCase;

        Test.startTest();

        System.assert(FleetEnrollmentWS_AccountActivationQueue.errorQueueSettings != null);
        System.assert(FleetEnrollmentWS_AccountActivationQueue.errorQueueId != null);

        // Test the GET
        RestRequest getRestRequest = new RestRequest();

        getRestRequest.requestURI = '/services/apexrest/FleetEnrollmentWS/AccountActivationQueue';
        getRestRequest.httpMethod = 'GET';
        getRestRequest.addHeader('Content-Type', 'application/json');

        RestContext.request = getRestRequest;

        RestResponse getRestResponse = new RestResponse();

        RestContext.response = getRestResponse;

        FleetEnrollmentWS_AccountActivationQueue.getQueueCases();

        // Test the POST - Positive
        FleetEnrollmentWS_AccountActivationQueue.updateQueueCase(fleetEnrollmentSuccessCase.Id, true, '');

        // Test the POST - Negative
        FleetEnrollmentWS_AccountActivationQueue.updateQueueCase(fleetEnrollmentFailedCase.Id, false, '');

        Test.stopTest();

    }

    static testMethod void testAttachmentService() {

        Case fleetEnrollmentSuccessCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentSuccessCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentSuccessCase.Status = 'New';
        fleetEnrollmentSuccessCase.OwnerId = FleetEnrollmentWS_DataEntryQueue.dataEntryQueueId;

        insert fleetEnrollmentSuccessCase;

        Case fleetEnrollmentFailedCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentFailedCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentFailedCase.Status = 'New';
        fleetEnrollmentFailedCase.OwnerId = FleetEnrollmentWS_DataEntryQueue.dataEntryQueueId;

        insert fleetEnrollmentFailedCase;

        Test.startTest();

        // Test the GET
        RestRequest postRestRequest = new RestRequest();

        postRestRequest.requestURI = '/services/apexrest/FleetEnrollmentWS/Attachments';
        postRestRequest.httpMethod = 'POST';
        postRestRequest.addHeader('Content-Type', 'application/json');
        postRestRequest.addParameter('id', fleetEnrollmentFailedCase.Id);
        postRestRequest.addParameter('attachmentName', 'Stuff.txt');
        postRestRequest.requestBody = Blob.valueOf('123456789');

        RestContext.request = postRestRequest;

        RestResponse postRestResponse = new RestResponse();

        RestContext.response = postRestResponse;

        FleetEnrollmentWS_Attachments.updateQueueCase();

        Test.stopTest();

    }

    static testMethod void testDataEntryQueue() {

        Case fleetEnrollmentSuccessCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentSuccessCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentSuccessCase.Status = 'New';
        fleetEnrollmentSuccessCase.OwnerId = FleetEnrollmentWS_DataEntryQueue.dataEntryQueueId;

        insert fleetEnrollmentSuccessCase;

        Case fleetEnrollmentFailedCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentFailedCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentFailedCase.Status = 'New';
        fleetEnrollmentFailedCase.OwnerId = FleetEnrollmentWS_DataEntryQueue.dataEntryQueueId;

        insert fleetEnrollmentFailedCase;

        Test.startTest();

        System.assert(FleetEnrollmentWS_DataEntryQueue.errorQueueSettings != null);
        System.assert(FleetEnrollmentWS_DataEntryQueue.errorQueueId != null);

        // Test the GET
        RestRequest getRestRequest = new RestRequest();

        getRestRequest.requestURI = '/services/apexrest/FleetEnrollmentWS/DataEntryQueue';
        getRestRequest.httpMethod = 'GET';
        getRestRequest.addHeader('Content-Type', 'application/json');

        RestContext.request = getRestRequest;

        RestResponse getRestResponse = new RestResponse();

        RestContext.response = getRestResponse;

        FleetEnrollmentWS_DataEntryQueue.getQueueCases();

        // Test the POST - Positive
        FleetEnrollmentWS_DataEntryQueue.updateQueueCase(fleetEnrollmentSuccessCase.Id, true, '', '2');

        // Test the POST - Negative
        FleetEnrollmentWS_DataEntryQueue.updateQueueCase(fleetEnrollmentFailedCase.Id, false, '', '2');

        Test.stopTest();

    }

    static testMethod void testHierarchyQueue() {

        Case fleetEnrollmentSuccessCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentSuccessCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentSuccessCase.Status = 'New';
        fleetEnrollmentSuccessCase.OwnerId = FleetEnrollmentWS_Hierarchy.hierarchyQueueId;

        insert fleetEnrollmentSuccessCase;

        Case fleetEnrollmentFailedCase = new Case();

        if (Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation') != null) {
            fleetEnrollmentFailedCase.RecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
        }

        fleetEnrollmentFailedCase.Status = 'New';
        fleetEnrollmentFailedCase.OwnerId = FleetEnrollmentWS_Hierarchy.hierarchyQueueId;

        insert fleetEnrollmentFailedCase;

        Test.startTest();

        System.assert(FleetEnrollmentWS_Hierarchy.errorQueueSettings != null);
        System.assert(FleetEnrollmentWS_Hierarchy.errorQueueId != null);

        // Test the GET
        RestRequest getRestRequest = new RestRequest();

        getRestRequest.requestURI = '/services/apexrest/FleetEnrollmentWS/HierarchyQueue';
        getRestRequest.httpMethod = 'GET';
        getRestRequest.addHeader('Content-Type', 'application/json');

        RestContext.request = getRestRequest;

        RestResponse getRestResponse = new RestResponse();

        RestContext.response = getRestResponse;

        FleetEnrollmentWS_Hierarchy.getQueueCases();

        // Test the POST - Positive
        FleetEnrollmentWS_Hierarchy.updateQueueCase(fleetEnrollmentSuccessCase.Id, true, '');

        // Test the POST - Negative
        FleetEnrollmentWS_Hierarchy.updateQueueCase(fleetEnrollmentFailedCase.Id, false, '');

        Test.stopTest();

    }

    static testMethod void testFleetDataWS() {

        List<Program__c> programs = [SELECT Id FROM Program__c LIMIT 1];

        if (programs.size() > 0) {

            Program__c testProgram = WexBrandingController.getProgram(programs[0].Id);

            Test.startTest();

            System.assert(testProgram.Publish_Fleet_Data_Capture_Form__c == true);

            User integrationUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

            Application_Request__c applicationRequest = new Application_Request__c();

            System.runAs(integrationUser) {

                Opportunity opportunity = new Opportunity(name = 'TestOpp', closedate = date.newinstance(2015, 11, 11), stagename = '5) Signed', fleet_size__c = 10, ownerId = integrationUser.Id, sourcesystem__c = 'test');
                opportunity.Fueling_Methos__c = 'BP';

                insert opportunity;

                applicationRequest.Sales_Stage__c = '06 - Approved';
                applicationRequest.Opportunity__c = opportunity.Id;

                insert applicationRequest;

            }

            // Test the main fleet enrollment form

            PageReference fleetEnrollment = Page.FleetEnrollment;
            fleetEnrollment.getParameters().put('program', testProgram.Brand_Short_Name__c);
            fleetEnrollment.getParameters().put('appId', applicationRequest.Id);

            Test.setCurrentPage(fleetEnrollment);

            FleetEnrollmentController fleetEnrollmentController = new FleetEnrollmentController();

            fleetEnrollmentController.fleetEnrollment.Billing_Full_Name__c = 'Test McTesterson';
            fleetEnrollmentController.fleetEnrollment.Billing_Email__c = 'test@test.com';
            fleetEnrollmentController.fleetEnrollment.Billing_Phone__c = '207-555-5555';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_1__c = '123 Darling Ave';
            fleetEnrollmentController.fleetEnrollment.Billing_Address_Line_2__c = '';
            fleetEnrollmentController.fleetEnrollment.Billing_City__c = 'South Portland';
            fleetEnrollmentController.fleetEnrollment.Billing_State__c = 'Me';
            fleetEnrollmentController.fleetEnrollment.Billing_Postal_Code__c = '04106';
            fleetEnrollmentController.fleetEnrollment.Number_of_Vehicles__c = 2;
            fleetEnrollmentController.fleetEnrollment.Embossing_Company_Name__c = 'Testerson Industries';
            fleetEnrollmentController.fleetEnrollment.Embossing_Second_Line__c = 'License Plate';
            fleetEnrollmentController.fleetEnrollment.Reporting_Dept__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleDesc__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_LicensePlt__c = true;
            fleetEnrollmentController.fleetEnrollment.Report_VehicleId__c = true;

            fleetEnrollmentController.addNewFleetVehicle();
            fleetEnrollmentController.fleetVehicles.get(0).companyVehicleId = '1111';
            fleetEnrollmentController.fleetVehicles.get(0).selectedCardControlOption = 'Custom Controls';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDepartment = 'Parts';
            fleetEnrollmentController.fleetVehicles.get(0).vehicleDescription = 'Ford 250';
            fleetEnrollmentController.fleetVehicles.get(0).licensePlate = '1111MV';

            fleetEnrollmentController.selectedDriverIdOption = 'custom';

            fleetEnrollmentController.changeDriverIdOption();

            fleetEnrollmentController.fleetDrivers.get(0).firstName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).lastName = 'Test';
            fleetEnrollmentController.fleetDrivers.get(0).driverId = '1111';

            fleetEnrollmentController.addNewFleetDriver();
            fleetEnrollmentController.selectedFleetDriver = 1;
            fleetEnrollmentController.removeFleetDriver();

            fleetEnrollmentController.submitApplication();

            System.debug('### ' + fleetEnrollmentController.fleetEnrollment.Id);

            List<FleetEnrollment__c> fleetEnrollments = [SELECT Id FROM FleetEnrollment__c];

            // Asserts!
            System.assert(FleetEnrollmentWS_FleetData.availableFleetEnrollmentStatuses != null);

            // Test the GET
            RestRequest getRestRequest = new RestRequest();

            getRestRequest.requestURI = '/services/apexrest/FleetEnrollmentWS/FleetData';
            getRestRequest.httpMethod = 'GET';
            getRestRequest.addHeader('Content-Type', 'application/json');
            getRestRequest.addParameter('id', fleetEnrollments[0].Id);

            RestContext.request = getRestRequest;

            RestResponse getRestResponse = new RestResponse();

            RestContext.response = getRestResponse;

            FleetEnrollmentWS_FleetData.getFleetData();

            FleetEnrollmentWS_FleetData.updateFleetData(fleetEnrollmentController.fleetEnrollment.Id, 'Complete');

            FleetEnrollmentWS_FleetData.updateFleetData(fleetEnrollmentController.fleetEnrollment.Id, 'Completed');

            Test.stopTest();

        }

    }

}