@IsTest
public with sharing class CustomerConversionTest {

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
        program.Conversion_Key__c = 'SHELL';
        
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
    
    static testmethod void testCustomerConversionController() {

        Customer_Conversion_Data__c conversionData = new Customer_Conversion_Data__c();

        conversionData.Previous_Account_Number__c = '123456789';
        conversionData.Conversion_Record_Key__c = 'SHELL-123456789';

        conversionData.Company_Name__c = 'Test Company';
        conversionData.First_Name__c = 'Test';
        conversionData.Last_Name__c = 'McTesterson';
        conversionData.Phone__c = '207-523-6969';
        conversionData.Email_Address__c = 'test@test.com';

        conversionData.Mailing_Address_Line_1__c = 'First Line';
        conversionData.Mailing_Address_Line_2__c = 'Second Line';
        conversionData.Mailing_City__c = 'Some City';
        conversionData.Mailing_State__c = 'ME';
        conversionData.Mailing_Postal_Code__c = '04106';

        conversionData.Physical_Address_Line_1__c = 'First Line';
        conversionData.Physical_Address_Line_2__c = 'Second Line';
        conversionData.Physical_City__c = 'Some City';
        conversionData.Physical_State__c = 'ME';
        conversionData.Physical_Postal_Code__c = '04106';

        conversionData.BPAV_Needed__c = true;
        conversionData.TIN_Needed__c = true;

        conversionData.Certified_By__c = 'Test McTesterson';
        conversionData.Certified_Date__c = Date.today();

        conversionData.Status__c = 'Pending Customer Response';

        insert conversionData;

        PageReference customerConversion = Page.CustomerConversion;
        customerConversion.getParameters().put('pgm', 'TestBOCA');

        Test.setCurrentPage(customerConversion);

        Test.startTest();

        System.assert(CustomerConversionController.validatePreviousAccountNumber('123456789', 'SHELL') == true);

        CustomerConversionController customerConversionController = new CustomerConversionController();

        customerConversionController.init();

        customerConversionController.previousAccountNumber = '123456789';

        customerConversionController.nextStep();

        customerConversionController.mailingAddressSame = false;

        PageReference nullPageReference = customerConversionController.mailingAddressSameToggle();

        customerConversionController.mailingAddressSame = true;

        nullPageReference = customerConversionController.mailingAddressSameToggle();

        customerConversionController.bpavEvidenceBody = Blob.valueOf('This is a test');
        customerConversionController.bpavEvidenceName = 'EvidenceDocument.txt';

        customerConversionController.submitConversionForm();

        System.assert(customerConversionController.cacheControl != null);
        System.assert(customerConversionController.todaysDate != null);
        System.assert(customerConversionController.confirmationNumber == null);

        Test.stopTest();

    }

}