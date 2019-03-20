@isTest
public class BOCAToProspectTest {
    
    @testSetup 
    static void setupData(){
        
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
        
        Program__c partnerProgram = new Program__c();
        
        partnerProgram.Name = 'SecondBOCA';
        partnerProgram.Peoplesoft_rel_code__c = '012011';
        partnerProgram.Form_Template__c = 'WexBOCA2';
        partnerProgram.Brand_Short_Name__c = 'TestBOCA2';
        partnerProgram.Preferred_Language_Indicator__c = 'ENU';
        partnerProgram.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        partnerProgram.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        partnerProgram.Brand_Long_Name__c = 'Test BOCA';
        partnerProgram.Upload_Pricing_Data_Flag__c = false;
        partnerProgram.Auto_Send_BOCA_to_Siebel__c = false;
        partnerProgram.T_C__c = 'WEX_BOCA_TNC';
        partnerProgram.Analytics_Body_Block__c = '';
        partnerProgram.Analytics_Head_Block__c = '';
        partnerProgram.Brand_Color_1__c = '#ccc';
        partnerProgram.Brand_Color_2__c = '#fff';
        partnerProgram.BOCA_To_Prospect_Template__c = '00X70000001EfPG';
        
        insert partnerProgram;
        
        // Setup Attachments
        Attachment cardImage = new Attachment();
        cardImage.Name = 'ui-credit-card.png';
        Blob cardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImage.body = cardImageBlob;
        cardImage.parentId = program.Id;
        upsert cardImage;
        
        Attachment partnerCardImage = new Attachment();
        partnerCardImage.Name = 'ui-credit-card.png';
        Blob partnerCardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        partnerCardImage.body = partnerCardImageBlob;
        partnerCardImage.parentId = partnerProgram.Id;
        upsert partnerCardImage;
        
        Attachment logo = new Attachment();
        logo.Name = 'ui-logo.png';
        Blob logoBlob = Blob.valueOf('Unit Test Attachment Body');
        logo.body = logoBlob;
        logo.parentId = program.Id;
        upsert logo;
        
        Attachment partnerLogo = new Attachment();
        partnerLogo.Name = 'ui-logo.png';
        Blob partnerLogoBlob = Blob.valueOf('Unit Test Attachment Body');
        partnerLogo.body = partnerLogoBlob;
        partnerLogo.parentId = partnerProgram.Id;
        upsert partnerLogo;
        
        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;
        
        insert campaignProgram;
        
        Campaign_Program__c partnerCampaignProgram = new Campaign_Program__c();
        //create campaign program test data
        partnerCampaignProgram.Name = 'Flex Test';
        partnerCampaignProgram.Campaign__c = campaign.Id;
        partnerCampaignProgram.Program__c = partnerProgram.Id;
        partnerCampaignProgram.Terms_and_Conditions__c = 'Test T&C';
        partnerCampaignProgram.Default__c = true;
        
        insert partnerCampaignProgram;
        
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
        
        Boca_Res__c partnerBrandingUtility = new Boca_Res__c();
        partnerBrandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        partnerBrandingUtility.Brand_Heading__c = 'Test Heading';
        partnerBrandingUtility.Brand_Tagline__c = 'Test Tagline';
        partnerBrandingUtility.ISO_code__c = 'en_us';
        partnerBrandingUtility.Program__c = partnerProgram.id;
        partnerBrandingUtility.Side_Panel_Title__c = 'Test Sidebar Title';
        partnerBrandingUtility.SideBar__c = 'Test Sidebar';
        partnerBrandingUtility.Program_Name__c = program.Name;
        partnerBrandingUtility.Name = 'test';
        partnerBrandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';
        
        insert partnerBrandingUtility;
        
        Partner__c partner = new Partner__c();
        
		partner.Name = 'Partners';
        
        insert partner;
        
        program.Partner__c = partner.Id;
        program.Publish_BOCA__c = true;
        
        upsert program;
        
        partnerProgram.Partner__c = partner.Id;
        partnerProgram.Publish_BOCA__c = true;
       
        upsert partnerProgram;

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales']; 
        
        User user = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profile.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');
        
        insert user;
        
        System.debug('### Campaign_Program__c Id: ' + campaignProgram.Campaign__c + ', Campaign Id: ' + campaign.Id);
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
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
    
    @isTest
    static void testBOCAToProspectErrorHandler() {
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];
        
        // Test without opportunity to test error handling
        PageReference bocaToProspectPage = Page.BocaToProspect;
        bocaToProspectPage.getParameters().put('id', '');
		Test.setCurrentPage(bocaToProspectPage);
        
        Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
        BOCAToProspectController bocaToProspectController = new BOCAToProspectController(standardController);

        bocaToProspectController.init();
        
        System.assertEquals(true, bocaToProspectController.hasError);
        
        Test.stopTest();
            
        }
        
    }
    
    @isTest
    static void testBOCAToProspect() {
        
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        
        System.runAs(integrationUser) {
        
        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];
        
        Program__c secondProgram = [SELECT Id FROM Program__c WHERE Name = 'SecondBOCA'];
        
        // Test with opportunity
        PageReference bocaToProspectPage = Page.BocaToProspect;
        bocaToProspectPage.getParameters().put('id', opportunity.Id);
		Test.setCurrentPage(bocaToProspectPage);
        
        Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
        BOCAToProspectController bocaToProspectController = new BOCAToProspectController(standardController);
        
        bocaToProspectController.init();
        
        bocaToProspectController.selectedPrograms = '["' + secondProgram.Id + '"]';
        
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
        
        bocaToProspectController.attachments = '["' + tempDocument.Id + '"]';
        
        PageReference bocaToProspectRedirect = bocaToProspectController.bocaToProspect();
        
        System.assertNotEquals(null, bocaToProspectController.additionalPrograms);
        System.assertNotEquals(null, bocaToProspectController.salesRepName);
        
        // Test the components
        BOCAToProspectComponentController bocaToProspectComponentController = new BOCAToProspectComponentController();
        
        bocaToProspectComponentController.bocaToProspectId = bocaToProspectController.bocaToProspect.Id;
        
        System.assertNotEquals(null, bocaToProspectComponentController.bocaToProspect);
		System.assertNotEquals(null, bocaToProspectComponentController.weFormObject);
		System.assertNotEquals(null, bocaToProspectComponentController.programId);
		System.assertNotEquals(null, bocaToProspectComponentController.primaryBrandingCard);
		System.assertNotEquals(null, bocaToProspectComponentController.secondaryProgramSize);
		System.assertNotEquals(null, bocaToProspectComponentController.pgValue);
		System.assertNotEquals(null, bocaToProspectComponentController.secondaryPrograms);
		System.assertNotEquals(null, bocaToProspectComponentController.primaryBrandingUtility);
        
        // Test the reminder function
        bocaToProspectPage = Page.BocaToProspect;
        bocaToProspectPage.getParameters().put('bocaToProspectId', bocaToProspectController.bocaToProspect.Id);
		Test.setCurrentPage(bocaToProspectPage);

        bocaToProspectController.init();

        bocaToProspectRedirect = bocaToProspectController.bocaToProspectReminder();

        Test.stopTest();
            
        }
        
    }
    
}