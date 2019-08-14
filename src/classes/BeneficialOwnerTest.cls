// Test class for all classes/triggers associated to Beneficial Owner
@isTest
public class BeneficialOwnerTest {

    static Opportunity opportunity { get; set; }
    
    @testSetup
    static void setupUser() {
        
        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        PermissionSet permissionSet = [SELECT ID From PermissionSet WHERE Name = 'Beneficial_Owner_All'];
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = permissionSet.Id);
        
        system.runAs(user){
            UtilityTestLoader.setAutomation(false);
        }

    }
    
    static testMethod void testBeneficialOwnerTriggers() {
        
        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;
        
        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
        
        boEntity.Opportunity__c = opportunity.Id;
        
        insert boEntity;
        
    }
    
    static testMethod void testBeneficialOwnerExemptedTriggers() {
        
        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Sole Proprietorship');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;
        
        // Test Fuel Card Exempted Path
        Beneficial_Owner_Entity__c boEntityFuelCard = new Beneficial_Owner_Entity__c();
        
        boEntityFuelCard.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
        boEntityFuelCard.Opportunity__c = opportunity.Id;
        
        insert boEntityFuelCard;
        
        // Upsert to recalculate
        upsert boEntityFuelCard;
                
    }
    
    static testMethod void testBeneficialOwnerCloneFuelCard() {

        Test.startTest();

        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;
        
        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
        
        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        
        insert boEntity;
        
        Id oldBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        BeneficialOwnerUtilities beneficialOwnerUtilities = new BeneficialOwnerUtilities(standardController);
        
        PageReference redirect = beneficialOwnerUtilities.runBeneficialOwnerCloneVF();
        
        System.assert(redirect != null);

        Test.stopTest();
        
        Id newBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        System.assert(oldBeneficialOwnerId != newBeneficialOwnerId);
        
    }
    
    static testMethod void testBeneficialOwnerCloneFleetCard() {

        Test.startTest();

        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;
        
        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
        
        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        
        insert boEntity;
        
        Id oldBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        BeneficialOwnerUtilities beneficialOwnerUtilities = new BeneficialOwnerUtilities(standardController);
        
        PageReference redirect = beneficialOwnerUtilities.runBeneficialOwnerCloneVF();
        
        System.assert(redirect != null);

        Test.stopTest();
        
        Id newBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        System.assert(oldBeneficialOwnerId != newBeneficialOwnerId);
        
    }
    
    static testMethod void testBeneficialOwnerCloneFactoring() {

        Test.startTest();
        
        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        Opportunity opportunity = new Opportunity(name= 'TestOpp', closedate= date.newinstance(2099,1,1), stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
        
        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        
        insert boEntity;
        
        Id oldBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        BeneficialOwnerUtilities beneficialOwnerUtilities = new BeneficialOwnerUtilities(standardController);
        
        PageReference redirect = beneficialOwnerUtilities.runBeneficialOwnerCloneVF();
        
        System.assert(redirect != null);

        Test.stopTest();
        
        Id newBeneficialOwnerId = [SELECT Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: opportunity.Id].Beneficial_Owner_Entity__c;
        
        System.assert(oldBeneficialOwnerId != newBeneficialOwnerId);
        
    }

    static testMethod void testSendBeneficialOwnerForm() {

        User user = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp', closedate= date.newinstance(2099,1,1), stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';

        insert boEntity;

        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        SendBeneficialOwnerFormController sendBeneficialOwnerFormController = new SendBeneficialOwnerFormController(standardController);

        PageReference sendBeneficialOwnerForm = Page.SendBeneficialOwnerForm;
        sendBeneficialOwnerForm.getParameters().put('id', boEntity.Id);

        Test.setCurrentPage(sendBeneficialOwnerForm);

        sendBeneficialOwnerFormController.init();

        SendBeneficialOwnerFormController.NewContact contact = new SendBeneficialOwnerFormController.NewContact();

        contact.firstName = 'Derek';
        contact.lastName = 'Gilbert';
        contact.emailAddress = 'derek.gilbert@wexinc.com';

        sendBeneficialOwnerFormController.newContact = contact;

        sendBeneficialOwnerFormController.sendForm();

        System.assert(sendBeneficialOwnerFormController.selectedContactId == null);
        System.assert(sendBeneficialOwnerFormController.selectedAdditionalContacts == null);
        System.assert(sendBeneficialOwnerFormController.contacts.size() == 0);

        System.assert(sendBeneficialOwnerFormController.hasContacts == false);
        System.assert(sendBeneficialOwnerFormController.hasError == false);
        System.assert(sendBeneficialOwnerFormController.errorMessage == null);
        System.assert(sendBeneficialOwnerFormController.applicationURL != null);

        sendBeneficialOwnerFormController = new SendBeneficialOwnerFormController(standardController);

        sendBeneficialOwnerForm = Page.SendBeneficialOwnerForm;
        sendBeneficialOwnerForm.getParameters().put('formSentConfirm', 'false');
        sendBeneficialOwnerForm.getParameters().put('errorCode', 'ERROR-0001');

        Test.setCurrentPage(sendBeneficialOwnerForm);

        sendBeneficialOwnerFormController.init();

        sendBeneficialOwnerFormController.errorMessage = 'Oh Hai';

        sendBeneficialOwnerFormController.throwErrorFromPage();
        
        sendBeneficialOwnerFormController.logError(new sendBeneficialOwnerFormController.boFormToProspectException('The audience is listening'));

    }

    static testMethod void testBOCertificationFormFromSendForm() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';
        boEntity.Record_Status__c = 'Awaiting Customer';
        boEntity.Save_For_Later_Date__c = Date.today();
        boEntity.Save_For_Later_Key__c = '123456789';

        upsert boEntity;

        Beneficial_Owner_Prong__c ownerProng = new Beneficial_Owner_Prong__c();

        ownerProng.Beneficial_Owner_Entity__c = boEntity.Id;
        ownerProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
        ownerProng.First_Name__c = 'Test';
        ownerProng.Last_Name__c = 'McTesterson';
        ownerProng.Address_Line_1__c = '123 Darling Ave';
        ownerProng.Address_Line_2__c = 'Suite 1';
        ownerProng.City__c = 'South Portland';
        ownerProng.State__c = 'ME';
        ownerProng.Postal_Code__c = '04106';
        ownerProng.Country__c = 'United States';
        ownerProng.Social_Security_Number__c = '111-11-1111';
        ownerProng.Date_Of_Birth__c = Date.parse('12/26/1986');

        upsert ownerProng;

        Beneficial_Owner_Prong__c controlProng = new Beneficial_Owner_Prong__c();

        controlProng.Beneficial_Owner_Entity__c = boEntity.Id;
        controlProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
        controlProng.First_Name__c = 'Test';
        controlProng.Last_Name__c = 'McTesterson';
        controlProng.Title__c = 'CEO';
        controlProng.Address_Line_1__c = '123 Darling Ave';
        controlProng.Address_Line_2__c = 'Suite 1';
        controlProng.City__c = 'South Portland';
        controlProng.State__c = 'ME';
        controlProng.Postal_Code__c = '04106';
        controlProng.Country__c = 'United States';
        controlProng.Social_Security_Number__c = '111-11-1111';
        controlProng.Date_Of_Birth__c = Date.parse('12/26/1986');

        upsert controlProng;

        PageReference beneficialOwnerForm = Page.BOCertification;
        beneficialOwnerForm.getParameters().put('entityId', boEntity.Id);
        beneficialOwnerForm.getParameters().put('formKey', boEntity.Save_For_Later_Key__c);

        Test.setCurrentPage(beneficialOwnerForm);

        BOCertificationController boCertificationController = new BOCertificationController();

        boCertificationController.init();
        
        boCertificationController.doNothing();

        System.assert(boCertificationController.preview == null);
        System.assert(boCertificationController.saved == null);
        System.assert(boCertificationController.alreadySubmitted == false);
        System.assert(boCertificationController.isOwnerAController == false);
        System.assert(boCertificationController.boEntityRecordTypes != null);
        System.assert(boCertificationController.beneficialOwnerRecordTypeId != null);
        System.assert(boCertificationController.controlPersonRecordTypeId != null);
        System.assert(boCertificationController.countriesList != null);
        System.assert(boCertificationController.stateList != null);
        System.assert(boCertificationController.provinceList != null);
        System.assert(boCertificationController.selectedBoOwnerIndex == null);
        System.assert(boCertificationController.brandingLogo == null);
        System.assert(boCertificationController.brandingCard == null);
        System.assert(boCertificationController.program == null);
        System.assert(boCertificationController.brandingUtility == null);
        System.assert(boCertificationController.salesRep == null);
        System.assert(boCertificationController.salesCode == null);
        System.assert(boCertificationController.confirmationNumber == null);
        System.assert(boCertificationController.hasError == false);
        System.assert(boCertificationController.errorMessage == null);

        boCertificationController.addOwner();

        boCertificationController.selectedBoOwnerIndex = 1;

        boCertificationController.removeOwner();

        boCertificationController.selectedBoOwnerIndex = 0;
        boCertificationController.boOwners.get(0).isController = true;
        boCertificationController.boOwners.get(0).dateOfBirth = '12/26/1986';
        boCertificationController.boOwners.get(0).socialSecurityNumber = '111111111';

        boCertificationController.setOwnerSameAsController();

        boCertificationController.boEntity.Certified_By__c = 'Derek Gilbert';
        boCertificationController.boEntity.Certified_Date__c = Date.today();

        boCertificationController.submitForm();

        boCertificationController.submitCreditApp();

        controlProng.Verification_Failures__c = 'All';
        controlProng.Verification_Status__c = 'Failed';

        upsert controlProng;
        
        boCertificationController.removeOwners();
        
        boCertificationController.setOwnerSameAsController();
        
        boCertificationController.clearAddressFieldsOnCountryChange();

    }

    static testMethod void testLexisNexisIIDCallout() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';
        boEntity.Record_Status__c = 'Awaiting Customer';
        boEntity.Save_For_Later_Date__c = Date.today();
        boEntity.Save_For_Later_Key__c = '123456789';

        upsert boEntity;

        Beneficial_Owner_Prong__c ownerProng = new Beneficial_Owner_Prong__c();

        ownerProng.Beneficial_Owner_Entity__c = boEntity.Id;
        ownerProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
        ownerProng.First_Name__c = 'Test';
        ownerProng.Last_Name__c = 'McTesterson';
        ownerProng.Address_Line_1__c = '123 Darling Ave';
        ownerProng.Address_Line_2__c = 'Suite 1';
        ownerProng.City__c = 'South Portland';
        ownerProng.State__c = 'ME';
        ownerProng.Postal_Code__c = '04106';
        ownerProng.Country__c = 'United States';
        ownerProng.Social_Security_Number__c = '111-11-1111';
        ownerProng.Date_Of_Birth__c = Date.parse('12/26/1986');

        upsert ownerProng;

        Beneficial_Owner_Prong__c controlProng = new Beneficial_Owner_Prong__c();

        controlProng.Beneficial_Owner_Entity__c = boEntity.Id;
        controlProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
        controlProng.First_Name__c = 'Test';
        controlProng.Last_Name__c = 'McTesterson';
        controlProng.Title__c = 'CEO';
        controlProng.Address_Line_1__c = '123 Darling Ave';
        controlProng.Address_Line_2__c = 'Suite 1';
        controlProng.City__c = 'South Portland';
        controlProng.State__c = 'ME';
        controlProng.Postal_Code__c = '04106';
        controlProng.Country__c = 'United States';
        controlProng.Social_Security_Number__c = '111-11-1111';
        controlProng.Date_Of_Birth__c = Date.parse('12/26/1986');

        upsert controlProng;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new LexisNexisIIDMockCallout());

        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        CreditWS_LexisNexis.beneficialOwnerVerificationFutureCallout(boEntity.Id);

        Test.stopTest();

    }

    static testMethod void testLexisNexisIVICallout() {

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
        program.Brand_Long_Name__c = 'Sunoco Fleet';

        insert program;

        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Application_Request__c applicationRequest = new Application_Request__c();

        applicationRequest.Sales_Person__c = integrationUser.Id;
        applicationRequest.Sales_Stage__c = '04 - Application Received';
        applicationRequest.Opportunity__c = opportunity.Id;

        insert applicationRequest;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';
        boEntity.Record_Status__c = 'Awaiting Customer';
        boEntity.Save_For_Later_Date__c = Date.today();
        boEntity.Save_For_Later_Key__c = '123456789';
        boEntity.Application_Request__c = applicationRequest.Id;
        boEntity.Certified_By__c = 'DD';
        boEntity.Certified_Date__c = Date.today();

        upsert boEntity;

        Beneficial_Owner_Prong__c ownerProng = new Beneficial_Owner_Prong__c();

        ownerProng.Beneficial_Owner_Entity__c = boEntity.Id;
        ownerProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
        ownerProng.First_Name__c = 'Test';
        ownerProng.Last_Name__c = 'McTesterson';
        ownerProng.Address_Line_1__c = '123 Darling Ave';
        ownerProng.Address_Line_2__c = 'Suite 1';
        ownerProng.City__c = 'South Portland';
        ownerProng.State__c = 'QC';
        ownerProng.Postal_Code__c = 'A1A-1A1';
        ownerProng.Country__c = 'Canada';
        ownerProng.Passport_Number_Other_Government_ID__c = '123456789';
        ownerProng.Country_Of_Issue__c = 'Canada';


        upsert ownerProng;

        Beneficial_Owner_Prong__c controlProng = new Beneficial_Owner_Prong__c();

        controlProng.Beneficial_Owner_Entity__c = boEntity.Id;
        controlProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
        controlProng.First_Name__c = 'Test';
        controlProng.Last_Name__c = 'McTesterson';
        controlProng.Title__c = 'CEO';
        controlProng.Address_Line_1__c = '123 Darling Ave';
        controlProng.Address_Line_2__c = 'Suite 1';
        controlProng.City__c = 'South Portland';
        controlProng.State__c = 'QC';
        controlProng.Postal_Code__c = 'A1A-1A1';
        controlProng.Country__c = 'Canada';
        controlProng.Passport_Number_Other_Government_ID__c = '123456789';
        controlProng.Country_Of_Issue__c = 'Canada';

        upsert controlProng;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new LexisNexisIVIMockCallout());

        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        CreditWS_LexisNexis.beneficialOwnerVerificationFutureCallout(boEntity.Id);

        Test.stopTest();

    }

    static testMethod void testLexisNexisIVICalloutFail() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';
        boEntity.Record_Status__c = 'Awaiting Customer';
        boEntity.Save_For_Later_Date__c = Date.today();
        boEntity.Save_For_Later_Key__c = '123456789';
        boEntity.Certified_By__c = 'DD';
        boEntity.Certified_Date__c = Date.today();

        upsert boEntity;

        Beneficial_Owner_Prong__c ownerProng = new Beneficial_Owner_Prong__c();

        ownerProng.Beneficial_Owner_Entity__c = boEntity.Id;
        ownerProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
        ownerProng.First_Name__c = 'Test';
        ownerProng.Last_Name__c = 'McTesterson';
        ownerProng.Address_Line_1__c = '123 Darling Ave';
        ownerProng.Address_Line_2__c = 'Suite 1';
        ownerProng.City__c = 'South Portland';
        ownerProng.State__c = 'QC';
        ownerProng.Postal_Code__c = 'A1A-1A1';
        ownerProng.Country__c = 'Canada';
        ownerProng.Passport_Number_Other_Government_ID__c = '123456789';
        ownerProng.Country_Of_Issue__c = 'Canada';


        upsert ownerProng;

        Beneficial_Owner_Prong__c controlProng = new Beneficial_Owner_Prong__c();

        controlProng.Beneficial_Owner_Entity__c = boEntity.Id;
        controlProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
        controlProng.First_Name__c = 'Test';
        controlProng.Last_Name__c = 'McTesterson';
        controlProng.Title__c = 'CEO';
        controlProng.Address_Line_1__c = '123 Darling Ave';
        controlProng.Address_Line_2__c = 'Suite 1';
        controlProng.City__c = 'South Portland';
        controlProng.State__c = 'QC';
        controlProng.Postal_Code__c = 'A1A-1A1';
        controlProng.Country__c = 'Canada';
        controlProng.Passport_Number_Other_Government_ID__c = '123456789';
        controlProng.Country_Of_Issue__c = 'Canada';

        upsert controlProng;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new LexisNexisIVIMockCalloutFail());

        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);
        CreditWS_LexisNexis.beneficialOwnerVerificationFutureCallout(boEntity.Id);

        Test.stopTest();

    }

    static testMethod void testLexisNexisPageMethod() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

        Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();

        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
        boEntity.Opportunity__c = opportunity.Id;
        boEntity.Verification_Status__c = 'Pending Lexis/Nexis';
        boEntity.Record_Status__c = 'Awaiting Customer';
        boEntity.Save_For_Later_Date__c = Date.today();
        boEntity.Save_For_Later_Key__c = '123456789';
        boEntity.Certified_By__c = 'DD';
        boEntity.Certified_Date__c = Date.today();

        upsert boEntity;

        Beneficial_Owner_Prong__c ownerProng = new Beneficial_Owner_Prong__c();

        ownerProng.Beneficial_Owner_Entity__c = boEntity.Id;
        ownerProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
        ownerProng.First_Name__c = 'Test';
        ownerProng.Last_Name__c = 'McTesterson';
        ownerProng.Address_Line_1__c = '123 Darling Ave';
        ownerProng.Address_Line_2__c = 'Suite 1';
        ownerProng.City__c = 'South Portland';
        ownerProng.State__c = 'QC';
        ownerProng.Postal_Code__c = 'A1A-1A1';
        ownerProng.Country__c = 'Canada';
        ownerProng.Passport_Number_Other_Government_ID__c = '123456789';
        ownerProng.Country_Of_Issue__c = 'Canada';


        upsert ownerProng;

        Beneficial_Owner_Prong__c controlProng = new Beneficial_Owner_Prong__c();

        controlProng.Beneficial_Owner_Entity__c = boEntity.Id;
        controlProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
        controlProng.First_Name__c = 'Test';
        controlProng.Last_Name__c = 'McTesterson';
        controlProng.Title__c = 'CEO';
        controlProng.Address_Line_1__c = '123 Darling Ave';
        controlProng.Address_Line_2__c = 'Suite 1';
        controlProng.City__c = 'South Portland';
        controlProng.State__c = 'QC';
        controlProng.Postal_Code__c = 'A1A-1A1';
        controlProng.Country__c = 'Canada';
        controlProng.Passport_Number_Other_Government_ID__c = '123456789';
        controlProng.Country_Of_Issue__c = 'Canada';

        upsert controlProng;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new LexisNexisIVIMockCallout());

        Apexpages.StandardController standardController = new ApexPages.StandardController(boEntity);

        PageReference lexisNexisPage = Page.RunLexisNexisCheck;
        lexisNexisPage.getParameters().put('id', boEntity.Id);

        Test.setCurrentPage(lexisNexisPage);

        CreditWS_LexisNexis.passedBeneficialEntityId = boEntity.Id;
        PageReference result = CreditWS_LexisNexis.runBeneficialOwnerVerificationVF();

        Test.stopTest();

    }

    static testMethod void testBOCDDFromBOCA() {
        
        TestUtils.enable_isRunningTest = true;

        User bocaUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        bocaId.Email_Address__c = bocaUser.Username;
        insert bocaId;

        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Form_Template__c = 'WexBOCA2';
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
        program.BOCA_Type__c = 'Fuel Card';

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

        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'Test Heading';
        brandingUtility.Brand_Tagline__c = 'Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'Test Sidebar Title';
        brandingUtility.SideBar__c = 'Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'test';
        brandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';

        insert brandingUtility;

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

        Campaign_Program__c campaignProgram = new Campaign_Program__c();

        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        // Publish the BOCA once the campaigns are all set
        program.Publish_BOCA__c = true;
        upsert program;


        PO_Box_Validation__c poBoxValidate = new PO_Box_Validation__c();
        poBoxValidate.po_box_formats__c = 'PO';
        insert poBoxValidate;

        WeFormObject__c we = new WeFormObject__c();

        we.Program__c = program.Id;

        we.Address_Line_2__c = 'Suite 100';
        we.Billing_Address_Line_2__c = 'Suite 100';
        we.Billing_City__c = 'Kingston';
        we.Billing_Contact_First_Name__c = 'Professional';
        we.Billing_Contact_Last_Name__c = 'Services';
        we.Billing_Email__c = 'ps@stantive.com';
        we.Billing_Fax__c = '';
        we.Billing_Phone__c = '613-555-5556';
        we.Billing_State__c = 'ON';
        we.Billing_Street_Address__c = '4 Cataraqui Street';
        we.Billing_Zip_Code__c = '62106';
        we.Business_fax__c = '613-555-5554';
        we.Business_Phone__c = '613-555-5555';
        we.Business_Street_Address__c = '123 Main Street';

        we.Date_of_Birth__c = '10/01/1986';
        we.PG_SSN__c = '123-45-6789';
        we.PG_Residential_Street_Address__c = '11 Awesome Street';
        we.PG_Residential_City__c = 'Adventure Land';
        we.PG_Residential_State__c = 'CA';
        we.PG_Residential_Zip__c = '43402';

        we.Campaign_Program_Id__c = campaignProgram.Id;
        we.City__c = 'Kingston';
        we.Company_Name__c = 'Stantive Technologies';
        we.Doing_Business_As__c = 'Stantive';
        we.Email__c = 'ps@stantive.com';
        we.Employee_Id__c = '1234';
        we.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
        we.First_Name__c = 'Professional';
        we.Fiscal_Year_Starts__c = 'Jan';
        we.Group_Code__c = 'ABC';
        we.How_did_you_hear_about_this_offer__c = 'Web';
        we.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
        we.Last_Name__c = 'Services';
        we.Legal_Structure__c = 'Corporation';
        we.Location_Code__c = 'NW';
        we.Promotional_Code__c = 'B1C';
        we.Sales_Id__c = '663434';
        we.Same_as_Business_Address__c = true;
        we.Signer_s_Email__c = 'ps@stantive.com';
        we.Signer_s_First_Name__c = 'Development';
        we.Signer_s_Last_Name__c = 'Services';
        we.Signer_s_Phone__c = '613-555-1111';
        we.signer_title__c = 'President';
        we.State__c = 'ON';
        we.Taxpayer_ID__c = '5664363';
        we.Years_in_Business__c = 'Less than 12 months';
        we.Zip_code__c = '62106';

        we.status__c = 'bo-needed';

        upsert we;

        PageReference beneficialOwnerForm = Page.BOCertification;
        beneficialOwnerForm.getParameters().put('weFormId', we.Id);
        beneficialOwnerForm.getParameters().put('pgm', 'TestBOCA');

        Test.setCurrentPage(beneficialOwnerForm);

        BOCertificationController boCertificationController = new BOCertificationController();

        boCertificationController.init();

        beneficialOwnerForm = Page.BOCertification;
        beneficialOwnerForm.getParameters().put('weFormId', '123456');
        beneficialOwnerForm.getParameters().put('pgm', 'TestBOCA');

        Test.setCurrentPage(beneficialOwnerForm);

        boCertificationController = new BOCertificationController();

        boCertificationController.init();

    }
    
    static testMethod void testBrandingControler() {
        
        TestUtils.enable_isRunningTest = true;

        User bocaUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        bocaId.Email_Address__c = bocaUser.Username;
        insert bocaId;

        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Form_Template__c = 'WexBOCA2';
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
        program.BOCA_Type__c = 'Fuel Card';

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

        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'Test Heading';
        brandingUtility.Brand_Tagline__c = 'Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'Test Sidebar Title';
        brandingUtility.SideBar__c = 'Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'test';
        brandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';

        insert brandingUtility;
        
        PageReference faq = Page.BOCertificationFAQ;
        faq.getParameters().put('pgm', program.Brand_Short_Name__c);
        
        Test.setCurrentPageReference(faq);
        
        BrandingController brandingController = new BrandingController();
        
        brandingController.init();
        
        System.assert(brandingController.programParameter != null);
        System.assert(brandingController.brandingLogo != null);
        System.assert(brandingController.brandingCard != null);
        System.assert(brandingController.program != null);
        
    }

    public class LexisNexisIIDMockCallout implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setHeader('Content-Type', 'application/json');
            retVal.setBody('{"PassThroughs":[{"Type":"INSTANT_ID","Data":"{\\\"InstantIDResponseEx\\\":{\\\"response\\\":{\\\"Header\\\":{\\\"Status\\\":0,\\\"TransactionId\\\":\\\"159158863R11447\\\"},\\\"Result\\\":{\\\"AdditionalScore2\\\":0,\\\"UniqueId\\\":374820893,\\\"AdditionalScore1\\\":0,\\\"ComprehensiveVerification\\\":{\\\"RiskIndicators\\\":{\\\"RiskIndicator\\\":[{\\\"RiskCode\\\":11,\\\"Description\\\":\\\"The input address may be invalid according to postal specifications\\\",\\\"Sequence\\\":1},{\\\"RiskCode\\\":30,\\\"Description\\\":\\\"The input address may have been miskeyed\\\",\\\"Sequence\\\":2},{\\\"RiskCode\\\":80,\\\"Description\\\":\\\"The input phone was missing or incomplete\\\",\\\"Sequence\\\":3}]},\\\"ComprehensiveVerificationIndex\\\":40,\\\"PotentialFollowupActions\\\":{\\\"FollowupAction\\\":[{\\\"RiskCode\\\":\\\"C\\\",\\\"Description\\\":\\\"Verify name with Address (via DL, utility bill, Directory Assistance, paycheck stub, or other Government Issued ID)\\\"},{\\\"RiskCode\\\":\\\"D\\\",\\\"Description\\\":\\\"Verify phone (Directory Assistance, utility bill)\\\"}]}},\\\"VerifiedInput\\\":{\\\"Address\\\":{\\\"StreetName\\\":\\\"BABYLON\\\",\\\"State\\\":\\\"MD\\\",\\\"Zip4\\\":4297,\\\"StreetNumber\\\":413,\\\"City\\\":\\\"WESTMINSTER\\\",\\\"County\\\":\\\"CARROLL\\\",\\\"Zip5\\\":21158,\\\"StreetSuffix\\\":\\\"CT\\\",\\\"StreetAddress1\\\":\\\"413 BABYLON CT\\\"},\\\"DOB\\\":{\\\"Month\\\":\\\"09\\\",\\\"Year\\\":1966,\\\"Day\\\":\\\"05\\\"},\\\"SSN\\\":217908984,\\\"Name\\\":{\\\"Last\\\":\\\"CARDWELL\\\",\\\"First\\\":\\\"RICHARD\\\"}},\\\"InstantIDVersion\\\":1,\\\"EmergingId\\\":0,\\\"AddressCMRA\\\":false,\\\"InputEcho\\\":{\\\"DOBRadius\\\":2,\\\"OwnOrRent\\\":\\\"\\\",\\\"Passport\\\":{\\\"MachineReadableLine2\\\":\\\"\\\",\\\"MachineReadableLine1\\\":\\\"\\\",\\\"Number\\\":\\\"\\\",\\\"ExpirationDate\\\":\\\"\\\",\\\"Country\\\":\\\"\\\"},\\\"Address\\\":{\\\"State\\\":\\\"MD\\\",\\\"City\\\":\\\"Westminister\\\",\\\"Zip5\\\":21158,\\\"StreetAddress1\\\":\\\"41311 babylon Ct\\\"},\\\"DOB\\\":{\\\"Month\\\":9,\\\"Year\\\":1966,\\\"Day\\\":5},\\\"Channel\\\":\\\"\\\",\\\"UseDOBFilter\\\":0,\\\"Name\\\":{\\\"Last\\\":\\\"Cardwell\\\",\\\"First\\\":\\\"Richard\\\"},\\\"SSN\\\":217908984},\\\"SSNInfo\\\":{\\\"Valid\\\":\\\"G\\\",\\\"IssuedLocation\\\":\\\"Maryland\\\",\\\"IssuedStartDate\\\":{\\\"Month\\\":\\\"01\\\",\\\"Year\\\":1978,\\\"Day\\\":\\\"01\\\"},\\\"IssuedEndDate\\\":{\\\"Month\\\":12,\\\"Year\\\":1979,\\\"Day\\\":31}},\\\"NameAddressPhone\\\":{\\\"Summary\\\":0},\\\"PassportValidated\\\":0,\\\"StandardizedInputAddress\\\":{\\\"StreetName\\\":\\\"BABYLON\\\",\\\"State\\\":\\\"MD\\\",\\\"StreetNumber\\\":41311,\\\"Latitude\\\":39.62344,\\\"City\\\":\\\"WESTMINSTER\\\",\\\"Longitude\\\":-77.02897,\\\"County\\\":\\\"CARROLL\\\",\\\"StreetSuffix\\\":\\\"CT\\\",\\\"Zip5\\\":21158,\\\"StreetAddress2\\\":\\\"WESTMINSTER, MD 21158\\\",\\\"StreetAddress1\\\":\\\"41311 BABYLON CT\\\"},\\\"NameAddressSSNSummary\\\":12,\\\"AddressSecondaryRangeMismatch\\\":\\\"N\\\",\\\"DOBMatchLevel\\\":8,\\\"InputCorrected\\\":{\\\"Address\\\":{\\\"StreetName\\\":\\\"BABYLON\\\",\\\"StreetNumber\\\":413,\\\"StreetSuffix\\\":\\\"CT\\\",\\\"StreetAddress1\\\":\\\"413 BABYLON CT\\\"}},\\\"DOBVerified\\\":1,\\\"CurrentName\\\":{\\\"Last\\\":\\\"CARDWELL\\\",\\\"First\\\":\\\"RICHARD\\\"},\\\"SSNFoundForLexID\\\":true,\\\"AddressStandardized\\\":0,\\\"ChronologyHistories\\\":{\\\"ChronologyHistory\\\":[{\\\"Address\\\":{\\\"StreetName\\\":\\\"BABYLON\\\",\\\"State\\\":\\\"MD\\\",\\\"Zip4\\\":4297,\\\"StreetNumber\\\":413,\\\"City\\\":\\\"WESTMINSTER\\\",\\\"Zip5\\\":21158,\\\"StreetSuffix\\\":\\\"CT\\\",\\\"StreetAddress1\\\":\\\"413 BABYLON CT\\\"},\\\"DateLastSeen\\\":{\\\"Month\\\":\\\"04\\\",\\\"Year\\\":2018},\\\"Phone\\\":4433751714,\\\"IsBestAddress\\\":1,\\\"DateFirstSeen\\\":{\\\"Year\\\":2005}},{\\\"Address\\\":{\\\"StreetName\\\":\\\"GLENBROOK\\\",\\\"State\\\":\\\"MD\\\",\\\"Zip4\\\":4250,\\\"StreetNumber\\\":970,\\\"City\\\":\\\"WESTMINSTER\\\",\\\"Zip5\\\":21158,\\\"StreetSuffix\\\":\\\"CT\\\",\\\"StreetAddress1\\\":\\\"970 GLENBROOK CT\\\"},\\\"DateLastSeen\\\":{\\\"Month\\\":\\\"09\\\",\\\"Year\\\":2006},\\\"DateFirstSeen\\\":{\\\"Month\\\":\\\"01\\\",\\\"Year\\\":2004}},{\\\"Address\\\":{\\\"StreetName\\\":\\\"WAGON WHEEL\\\",\\\"State\\\":\\\"MD\\\",\\\"Zip4\\\":2597,\\\"StreetNumber\\\":4203,\\\"City\\\":\\\"HAMPSTEAD\\\",\\\"Zip5\\\":21074,\\\"StreetSuffix\\\":\\\"DR\\\",\\\"StreetAddress1\\\":\\\"4203 WAGON WHEEL DR\\\"},\\\"DateLastSeen\\\":{\\\"Month\\\":\\\"04\\\",\\\"Year\\\":2004},\\\"DateFirstSeen\\\":{\\\"Month\\\":11,\\\"Year\\\":2003}}]},\\\"AddressPOBox\\\":false}}}}"}]}');
            return retVal;
        }
    }

    public class LexisNexisIVIMockCallout implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setHeader('Content-Type', 'application/json');
            retVal.setBody('{"Status":{"ConversationId":"31000094424385","RequestId":"284716005","TransactionStatus":"passed","Reference":"Reference1"},"Products":[{"ProductType":"InstantVerify","ExecutedStepName":"International Verification","ProductConfigurationName":"WEX.Bank.RDP.ivi","ProductStatus":"pass","Items":[{"ItemName":"InternationalIdentity","ItemStatus":"pass","ItemReason":{"Code":"elements_verified"},"ItemInformationDetails":[{"Name":"Message001","Value":"Full match was made on Complete Name"},{"Name":"Message002","Value":"Full match was made on First Initial"},{"Name":"Message003","Value":"Full match was made on First Name/Given Name"},{"Name":"Message004","Value":"Full match was made on Last Name/Surname "},{"Name":"Message005","Value":"Full match was made on address elements provided in Address Lines"},{"Name":"Message006","Value":"Full match was made on House Number/Street Number"},{"Name":"Message007","Value":"Full match was made on Street/Thoroughfare"},{"Name":"Message008","Value":"Full match was made on City/Locality"},{"Name":"Message009","Value":"Full match was made on Postal Code/Zip Code"},{"Name":"Message010","Value":"Full match was made on State/Province"}]}]}]}');
            return retVal;
        }
    }

    public class LexisNexisIVIMockCalloutFail implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setHeader('Content-Type', 'application/json');
            retVal.setBody('{"Status":{"ConversationId":"31000094424385","RequestId":"284716005","TransactionStatus":"passed","Reference":"Reference1"},"Products":[{"ProductType":"InstantVerify","ExecutedStepName":"International Verification","ProductConfigurationName":"WEX.Bank.RDP.ivi","ProductStatus":"pass","Items":[{"ItemName":"InternationalIdentity","ItemStatus":"partial","ItemReason":{"Code":"elements_verified"},"ItemInformationDetails":[{"Name":"Message001","Value":"Full match was made on Complete Name"},{"Name":"Message002","Value":"Full match was made on First Initial"},{"Name":"Message003","Value":"Full match was made on First Name/Given Name"},{"Name":"Message004","Value":"Full match was made on Last Name/Surname "},{"Name":"Message005","Value":"Full match was made on address elements provided in Address Lines"},{"Name":"Message006","Value":"Full match was made on House Number/Street Number"},{"Name":"Message007","Value":"Full match was made on Street/Thoroughfare"},{"Name":"Message008","Value":"Full match was made on City/Locality"},{"Name":"Message009","Value":"Full match was made on Postal Code/Zip Code"},{"Name":"Message010","Value":"Full match was made on State/Province"}]}]}]}');
            return retVal;
        }
    }
    
}