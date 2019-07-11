/**
 * Created by dgilbert on 10/26/2018.
 */
@IsTest
public with sharing class BOCAAttachmentControllerTest {

    @testSetup
    static void setupData(){

        UtilityTestLoader.setAutomation(false);
    
        // Revisit this later..
        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        insert bocaId;

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

        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Peoplesoft_rel_code__c = '012011';
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

        System.runAs(user) {

            Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= date.newinstance(2099,1,1),stagename='1) Qualified', fleet_size__c = 10, ownerId = user.id, sourcesystem__c = 'test', CampaignId = campaign.Id, Campaign_Program__c = campaignProgram.Id);
            opportunity.Fueling_Methos__c = 'BP';

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

    static testMethod void testBOCAAttachmentController() {

        Test.startTest();

        List<Opportunity> opportunities = [SELECT Id FROM Opportunity LIMIT 1];

        if(opportunities.size() > 0) {

            PageReference bocaAttachment = Page.BOCAAttachment;
            bocaAttachment.getParameters().put('applicationId', opportunities[0].Id);
            bocaAttachment.getParameters().put('pgm', 'TestBOCA');
            Test.setCurrentPage(bocaAttachment);

            BOCAAttachmentController bocaAttachmentController = new BOCAAttachmentController();

            bocaAttachmentController.init();

            System.assert(bocaAttachmentController.applicationId != null);
            System.assert(bocaAttachmentController.program != null);
            System.assert(bocaAttachmentController.brandingUtility != null);
            System.assert(bocaAttachmentController.existingAttachments != null);
            System.assert(bocaAttachmentController.existingAttachmentsSize == 0);

            bocaAttachmentController.attachmentName = 'Test';
            bocaAttachmentController.attachmentBody = Blob.valueOf('Unit Test Attachment Body');

            PageReference result = bocaAttachmentController.uploadFile();

            System.assert(result != null);

            System.assert(bocaAttachmentController.existingAttachmentsSize == 1);

            bocaAttachmentController.selectedFile = bocaAttachmentController.existingAttachments[0].Id;

            result = bocaAttachmentController.deleteFile();

            System.assert(result != null);

        }

        Test.stopTest();

    }

}