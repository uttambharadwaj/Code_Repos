/**
 * Created by dgilbert on 8/21/2018.
 */
@isTest
public with sharing class CPBOCAToProspectTest {

    @testSetup
    static void setupData(){

        UtilityTestLoader.setAutomation(false);
    
        // Revisit this later..
        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        insert bocaId;

        Campaign campaign = new Campaign();

        //create campaign test data
        campaign.Coupon_Code__c = 'TEST1';
        campaign.Name = 'TestCPCampaign';
        campaign.Type = 'Online Form';
        campaign.Status = 'In Progress';
        campaign.Drop_Date__c = date.today();
        campaign.EndDate = date.today();
        campaign.CurrencyIsoCode = 'USD';
        campaign.IsActive = true;

        insert campaign;

        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Peoplesoft_rel_code__c = '012011';
        program.Form_Template__c = 'CPBOCA';
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
        program.BOCA_To_Prospect_Template__c = '00X70000001EfPG';

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

        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

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

        Partner__c partner = new Partner__c();

        partner.Name = 'Partners';

        insert partner;

        program.Partner__c = partner.Id;
        program.Publish_BOCA__c = true;

        upsert program;

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales'];

        User user = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');

        insert user;

        System.debug('### Campaign_Program__c Id: ' + campaignProgram.Campaign__c + ', Campaign Id: ' + campaign.Id);

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runAs(user) {

            Account account = new account();
            
            account.name = 'TestAcc';
            
            insert account;
            
            Opportunity opportunity = new Opportunity();
            
            opportunity.Name = 'TestOpp';
            opportunity.AccountId = account.Id;
            opportunity.CloseDate = Date.newinstance(2099,1,1);
            opportunity.StageName = '1) Qualified';
            opportunity.Fleet_Size__c = 10;
            opportunity.OwnerId = user.Id;
            opportunity.SourceSystem__c = 'test';
            opportunity.Fueling_Methos__c = 'BP';
            opportunity.CampaignId = campaign.Id;
            opportunity.Campaign_Program__c = campaignProgram.Id;
            opportunity.Years_In_Business__c = 5;

            insert opportunity;

            Contact contact = new Contact();

            contact.FirstName = 'Tester';
            contact.LastName = 'Tester Last';
            contact.Email = 'Tester@UnitTest.com';

            insert contact;

            OpportunityContactRole opportunityContact = new OpportunityContactRole(contactId = contact.id, isPrimary = true, OpportunityId = opportunity.id);

            insert opportunityContact;

        }

    }

    @isTest
    static void testCPBOCAToProspectErrorHandler() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runAs(integrationUser) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];

            // Test without opportunity to test error handling
            PageReference cpBOCAToProspectPage = Page.CPBOCAToProspect;
            cpBOCAToProspectPage.getParameters().put('id', '');
            Test.setCurrentPage(cpBOCAToProspectPage);

            Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
            CPBOCAToProspectController cpbocaToProspectController = new CPBOCAToProspectController(standardController);

            cpbocaToProspectController.init();

            System.assertEquals(true, cpbocaToProspectController.hasError);

            Test.stopTest();

        }

    }

    @isTest
    static void testCPBOCAToProspect() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runAs(integrationUser) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Opportunity opportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Name = 'TestOpp'];

            // Test with opportunity
            PageReference cpBOCAToProspect = Page.CPBOCAToProspect;
            cpBOCAToProspect.getParameters().put('id', opportunity.Id);
            Test.setCurrentPage(cpBOCAToProspect);

            Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
            CPBOCAToProspectController cpbocaToProspectController  = new CPBOCAToProspectController(standardController);

            cpbocaToProspectController.init();

            URLgenAttachmentLookupController ugalc = new URLgenAttachmentLookupController();
            System.assert(ugalc.folders != null);
            ugalc.displayDocuments();
            ugalc.clearSearch();

            Document tempDocument = new Document();
            tempDocument.Name = 'info.pdf';
            Blob tempDocumentBlob = Blob.valueOf('Unit Test Attachment Body');
            tempDocument.body = tempDocumentBlob;
            tempDocument.FolderId = UserInfo.getUserId();
            insert tempDocument;

            cpbocaToProspectController.attachments = '["' + tempDocument.Id + '"]';

            PageReference bocaToProspectRedirect = cpbocaToProspectController.bocaToProspect();

            List<user> salesReps = [SELECT Id, Name, FirstName, LastName, Email, Phone, Sales_Code__c FROM User WHERE Id =: opportunity.OwnerId LIMIT 1];
            System.debug('Opportunity Id: ' + opportunity.Id);
            System.debug('SalesRep: ' + Opportunity.OwnerId);
            System.debug('SalesRep Name: ' + salesReps[0].Name);
            System.assertNotEquals(null, cpbocaToProspectController.salesRepName);

            // Test the components
            CPBOCAToProspectComponentController cpBOCAToProspectComponentController = new CPBOCAToProspectComponentController();

            cpBOCAToProspectComponentController.bocaToProspectId = cpbocaToProspectController.bocaToProspect.Id;

            System.assertNotEquals(null, cpBOCAToProspectComponentController.bocaToProspect);
            System.assertNotEquals(null, cpBOCAToProspectComponentController.programId);
            System.assertNotEquals(null, cpBOCAToProspectComponentController.primaryBrandingCard);
            System.assertNotEquals(null, cpBOCAToProspectComponentController.primaryBrandingUtility);

            // Test the reminder function
            cpBOCAToProspect = Page.CPBOCAToProspect;
            cpBOCAToProspect.getParameters().put('bocaToProspectId', cpbocaToProspectController.bocaToProspect.Id);
            Test.setCurrentPage(cpBOCAToProspect);

            cpbocaToProspectController.init();

            bocaToProspectRedirect = cpbocaToProspectController.bocaToProspectReminder();

            // Test confirmation
            cpBOCAToProspect = Page.CPBOCAToProspect;
            cpBOCAToProspect.getParameters().put('bocaToProspectConfirm', 'true');
            Test.setCurrentPage(cpBOCAToProspect);

            cpbocaToProspectController.init();

            cpBOCAToProspect = Page.CPBOCAToProspect;
            cpBOCAToProspect.getParameters().put('bocaToProspectConfirm', 'false');
            Test.setCurrentPage(cpBOCAToProspect);

            cpbocaToProspectController.init();

            Test.stopTest();

        }

    }

}