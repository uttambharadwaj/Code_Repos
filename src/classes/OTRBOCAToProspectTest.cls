/*
Description:        test class for otrbocatoprospectcontroller
Test Classes:       OTRBOCAToProspectTest
Revision History:   4/12/2019 Jason Arbegast IADJUDICAT-1085 improve coverage, test setup, test methods
TODO:               clean all the things
                    add asserts
*/
@isTest
public class OTRBOCAToProspectTest {

    @testSetup
    static void setupData(){

        UtilityTestLoader.setAutomation(false);
    
        // Revisit this later..
        // 4/12/2019 NOW IS THE LATER
        // 4/15/2019 but still...revisit this later
        insert new Internal_Application_Error__c(Error_Message__c='Fail all the things!');

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales'];

        User user = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com');

        insert user;

        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        insert bocaId;
        BOCA_To_Prospect_Settings__c btps = new BOCA_To_Prospect_Settings__c();
        btps.OTR_Email_Template_ID__c='00X0g000001Mztx';
        insert btps;

        System.runAs(user){
            Account offerAccount = new Account();
            offerAccount.Name ='TestAccount-01';

            insert offerAccount;

            OnlineApplicationOffer__c onlineApplicationOffer = new OnlineApplicationOffer__c();
            onlineApplicationOffer.Name = 'TestOffer-01';
            onlineApplicationOffer.Application_Title__c = 'TestTitle';
            onlineApplicationOffer.Complete_Later_Text__c = 'Test';
            onlineApplicationOffer.EchoSign_User_Email__c = 'test@test.com';
            onlineApplicationOffer.Terms_and_Conditions_Version__c = 'TestVersion-01';
            onlineApplicationOffer.BOCA_Default_Offer__c = true;
            onlineApplicationOffer.Disclosure__c = 'Test';

            insert onlineApplicationOffer;

            Partner__c partner = new Partner__c();

            partner.Name = 'Partners';

            insert partner;

            Campaign campaign = new Campaign();

            //create campaign test data
            campaign.Coupon_Code__c = 'TESTCOUPONX';
            campaign.Name = 'OTRTestCampaign';
            campaign.Type = 'Online Form';
            campaign.Status = 'In Progress';
            campaign.Drop_Date__c = date.today();
            campaign.EndDate = date.today();
            campaign.CurrencyIsoCode = 'USD';
            campaign.IsActive = true;

            insert campaign;

            Program__c program = new Program__c();

            program.Name = 'OTRTestBOCA';
            program.Form_Template__c = 'OTRBOCA';
            program.Brand_Short_Name__c = 'OTR';
            program.Preferred_Language_Indicator__c = 'ENU';
            program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
            program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
            program.Brand_Long_Name__c = 'OTR Test BOCA';
            program.Upload_Pricing_Data_Flag__c = false;
            program.Auto_Send_BOCA_to_Siebel__c = false;
            program.T_C__c = 'WEX_BOCA_TNC';
            program.Analytics_Body_Block__c = '';
            program.Analytics_Head_Block__c = '';
            program.Brand_Color_1__c = '#ccc';
            program.Brand_Color_2__c = '#fff';
            program.BOCA_Type__c = 'OTR';
            program.Partner__c = partner.Id;

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

            Campaign_Program__c partnerCampaignProgram = new Campaign_Program__c();
            //create campaign program test data
            partnerCampaignProgram.Name = 'Flex Test';
            partnerCampaignProgram.Campaign__c = campaign.Id;
            partnerCampaignProgram.Program__c = partnerProgram.Id;
            partnerCampaignProgram.Terms_and_Conditions__c = 'Test T&C';
            partnerCampaignProgram.Default__c = true;

            insert partnerCampaignProgram;

            Campaign_Program__c campaignProgram = new Campaign_Program__c();
            //create campaign program test data
            campaignProgram.Name = 'OTR Test';
            campaignProgram.Campaign__c = campaign.Id;
            campaignProgram.Program__c = program.Id;
            campaignProgram.Terms_and_Conditions__c = 'Test T&C';
            campaignProgram.Default__c = true;

            insert campaignProgram;

            Boca_Res__c progBrandUtil = new Boca_Res__c();
            progBrandUtil.Email_Template_ID__c = '00X70000001EfPG';
            progBrandUtil.Brand_Heading__c = 'Test Heading';
            progBrandUtil.Brand_Tagline__c = 'Test Tagline';
            progBrandUtil.ISO_code__c = 'en_us';
            progBrandUtil.Program__c = program.id;
            progBrandUtil.Side_Panel_Title__c = 'Test Sidebar Title';
            progBrandUtil.SideBar__c = 'Test Sidebar';
            progBrandUtil.Program_Name__c = program.Name;
            progBrandUtil.Name = 'test';
            progBrandUtil.Program_Sell_Sheets__c = 'www.sellsheet.com';

            insert progBrandUtil;

            onlineApplicationOffer.Program__c = program.Id;
            onlineApplicationOffer.BOCA_Default_Offer__c = true;
            upsert onlineApplicationOffer;

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

            program.Publish_BOCA__c = true;
            upsert program;

            PostCode__c postalCode = new PostCode__c();
            postalCode.State__c = 'ME';
            postalCode.Postcode__c = '4106';
            insert postalCode;

            User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

            Id recordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();

            Opportunity oppty = new Opportunity();

            oppty.Name = 'TestOpp';
            oppty.CloseDate = Date.newinstance(2099,1,1);
            oppty.StageName = '1) Qualified';
            oppty.Fleet_Size__c = 10;
            oppty.OwnerId = user.Id;
            oppty.SourceSystem__c = 'test';
            oppty.RecordTypeId = recordTypeId;
            oppty.Fueling_Methos__c = 'BP';
            oppty.Number_of_18_Wheelers__c = 10;
            oppty.F1_Account__c = '123456';
            oppty.AccountId=offerAccount.Id;
            oppty.Campaign_Program__c = campaignProgram.Id;
            oppty.CampaignId = campaign.Id;
            oppty.Legal_Structure__c = 'Corporation';

            insert oppty;

            Beneficial_Owner_Entity__c boEntity = new Beneficial_Owner_Entity__c();
            boEntity.Opportunity__c = oppty.Id;
            boEntity.RecordTypeId = '0120g000000HrlFAAS';
            insert boEntity;

            Contact contact = new Contact();

            contact.FirstName = 'Tester';
            contact.LastName = 'Tester Last';
            contact.Email = 'Tester@UnitTest.com';

            Contact contact2 = new Contact();

            contact2.FirstName = 'Tester2';
            contact2.LastName = 'Tester Last2';
            contact2.Email = 'Tester2@UnitTest.com';

            insert new List<Contact>{contact,contact2};

            OpportunityContactRole opportunityContact = new OpportunityContactRole(contactId = contact.id, isPrimary = true, OpportunityId = oppty.id);
            OpportunityContactRole opportunityContact2 = new OpportunityContactRole(contactId = contact2.id, isPrimary = false, OpportunityId = oppty.id);

            insert new List<OpportunityContactRole>{opportunityContact, opportunityContact2};

            OnlineApplication__c onlineApplication = new OnlineApplication__c();
            onlineApplication.ABA_Routing_Number__c = '123456789';
            onlineApplication.AO_Address__c = '100 N. State';
            onlineApplication.AO_City__c = 'Chicago';
            onlineApplication.AO_Confirm_Social_Security_Number__c = '123456789';
            onlineApplication.Contact_Name__c = 'PD James';
            onlineApplication.AO_Date_of_Birth__c = Date.today().addYears(-20);
            onlineApplication.AO_Home_Phone_Number__c = '3123127788';
            onlineApplication.AO_Name__c = 'George Smiley';
            onlineApplication.AO_Social_Security_Number__c = '123456789';
            onlineApplication.AO_State__c = 'IL';
            onlineApplication.AO_Title__c = 'CEO';
            onlineApplication.AO_Work_Email__c = 'dcraigmile@forseva.com';
            onlineApplication.AO_Zip_Code__c = '60603';
            onlineApplication.Application_Title__c = 'Living Will for Homer Simpson';
            onlineApplication.Account_Type__c = 'Prepay';
            onlineApplication.Branch_Address__c = '100 East Washington';
            onlineApplication.Branch_City__c = 'Chicago';
            onlineApplication.Branch_Phone_Number__c = '3128889999';
            onlineApplication.Branch_State__c = 'IL';
            onlineApplication.Branch_Zip_Code__c = '60603';
            onlineApplication.Business_Street_Address__c = '200 East Adams';
            onlineApplication.Cell_Number__c = '3124449999';
            onlineApplication.Change_to_Authorizing_Officer_Address__c = false;
            onlineApplication.Checking_Account_Number__c = '1234567890123';
            onlineApplication.City__c = 'Peoria';
            onlineApplication.Confirm_ABA_Routing_Number__c = '123456789';
            onlineApplication.Confirm_Checking_Account_Number__c = '1234567890123';
            onlineApplication.Credit_Line_Requested__c = 10000;
            onlineApplication.Data_Entry_Stage__c = null;
            onlineApplication.DUNS__c = '123456789';
            onlineApplication.Email__c = 'dcraigmile@forseva.com';
            onlineApplication.Embossing_Line_1_Company_Name__c = 'Forseva Trucking';
            onlineApplication.Fax_Number__c = '3129998888';
            onlineApplication.Federal_Tax_ID__c = '123456789';
            onlineApplication.Financial_Institution__c = 'Chase Bank';
            onlineApplication.How_Did_You_Hear_About_Us__c = 'Brochure';
            onlineApplication.I_Have_Read_and_Agree__c = false;
            onlineApplication.Invoice_Delivery_Method__c = 'Email';
            onlineApplication.Invoice_Delivery_Method_Email__c = 'dcraigmile@forseva.com';
            onlineApplication.Invoice_Delivery_Method_Fax__c = '3129998888';
            onlineApplication.Legal_Business_Name__c = 'Legal Name';
            onlineApplication.Lead_Source_Subtype__c = null;
            onlineApplication.Name_of_Parent_Company__c ='Parent Company';
            onlineApplication.Number_of_Drivers__c = 10;
            onlineApplication.Number_of_Trailers__c = 20;
            onlineApplication.Number_of_Trucks__c = 55;
            onlineApplication.Number_of_Vehicles__c = 40;
            onlineApplication.Odometer__c = true;
            onlineApplication.Offer__c = onlineApplicationOffer.Id;
            onlineApplication.Other_Services__c = 'SmartFunds;ATM;Money Codes and ATM;Scales';
            onlineApplication.Payment_Method__c = 'Customer ACH';
            onlineApplication.Phone_Number__c = '3123339999';
            onlineApplication.Product_Type__c = 'OTR';
            onlineApplication.Promotional_Code__c = 'promo12345';
            onlineApplication.State__c = 'IL';
            onlineApplication.Status__c = 'App-Incomplete';
            onlineApplication.Trade_Name__c = 'Forseva LLC';
            onlineApplication.Trip__c = false;
            onlineApplication.Type_of_Business__c = 'Corporation';
            onlineApplication.Type_of_Business_Other__c = 'Online Delivery';
            onlineApplication.Unit__c = false;
            onlineApplication.Year_Established__c = '1980';
            onlineApplication.Zip_Code__c = '60606';
            onlineApplication.OwnerId = UserInfo.getUserId();
            onlineApplication.Payment_Method__c = 'Auto Draft';
            onlineApplication.ThreatMetrix_Request_ID__c = '123456789';
            onlineApplication.Program__c = program.Id;
            onlineApplication.Account__c = offerAccount.Id;
            onlineApplication.Opportunity__c = oppty.Id;
            onlineApplication.Trip__c = true;
            onlineApplication.Odometer__c = true;
            onlineApplication.Unit__c = true;
            onlineApplication.PDF_Token__c = '123456';

            insert onlineApplication;
        }
    }

    @isTest
    static void testBOCAToProspectErrorHandler() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        TestUtils.enable_isRunningTest = true;

        PageReference otrBocaToProspectPage = Page.OTRBOCAToProspect;

        Apexpages.StandardController standardController = new ApexPages.StandardController(new Opportunity());
        OTRBOCAToProspectController otrBocaToProspectController = new OTRBOCAToProspectController(standardController);

        Test.startTest();

        System.runAs(integrationUser) {

            // Test without opportunity to test error handling
            otrBocaToProspectPage.getParameters().put('id', '');
            Test.setCurrentPage(otrBocaToProspectPage);
            otrBocaToProspectController.init();
            System.assertEquals(true, otrBocaToProspectController.hasError);

        }

        Test.stopTest();

    }

    @isTest
    static void testBOCAToProspect() {

        //SET UP WHAT WE NEED FOR TESTS
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'TestOpp'];
        Program__c program = [SELECT Id FROM Program__c LIMIT 1];
        OnlineApplicationOffer__c offer = [SELECT Id FROM OnlineApplicationOffer__c WHERE Program__c =: program.Id LIMIT 1];
        OnlineApplication__c myApplication = [SELECT Id FROM OnlineApplication__c LIMIT 1];
        TestUtils.enable_isRunningTest = true;
        Contact c = new Contact(LastName='TestContact', Email='Test@example.com');
        insert c;

        //set some parameters
        PageReference otrBocaToProspectPage = Page.OTRBOCAToProspect;
        otrBocaToProspectPage.getParameters().put('id', opportunity.Id);
        otrBocaToProspectPage.getParameters().put('applicationId', myApplication.Id);
        Test.setCurrentPage(otrBocaToProspectPage);

        Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
        OTRBOCAToProspectController otrBocaToProspectController = new OTRBOCAToProspectController(standardController);
        String myJSONString = '["Test@example.com"]';
        otrBocaToProspectController.selectedAdditionalContacts=myJSONString;
        String ccEmails = 'test@example.com,test2@example.com';
        otrBocaToProspectController.ccEmail = ccEmails;
        //END SET UP WHAT WE NEED FOR TESTS

        Test.startTest();

        System.runAs(integrationUser) {

            //test init
            otrBocaToProspectController.init();
            System.assert(otrBocaToProspectController.availablePrograms != null);
            System.assert(otrBocaToProspectController.availableOffers != null);

            Boolean b = otrBOCAToProspectController.hasAdditionalContacts;
            otrBOCAToProspectController.additionalContacts = null;
            b = otrBOCAToProspectController.hasAdditionalContacts;

            //set some variables
            otrBOCAToProspectController.selectedProgram = program.Id;
            otrBOCAToProspectController.selectedOffer = offer.Id;

            //set urlgenattachmentlookupcontroller
            URLgenAttachmentLookupController ugalc = new URLgenAttachmentLookupController();
            System.assert(ugalc.folders != null);
            ugalc.displayDocuments();
            ugalc.clearSearch();

            //create document
            Document tempDocument = new Document();
            tempDocument.Name = 'info.pdf';
            Blob tempDocumentBlob = Blob.valueOf('Unit Test Attachment Body');
            tempDocument.body = tempDocumentBlob;
            tempDocument.FolderId = UserInfo.getUserId();
            insert tempDocument;

            //set variables
            otrBocaToProspectController.attachments = '["' + tempDocument.Id + '"]';

            //create pagereference
            PageReference otrBocaToProspectRedirect = otrBocaToProspectController.bocaToProspect();

            //assert some stuff
            System.assertNotEquals(null, otrBocaToProspectController.salesRepName);
            System.assertNotEquals(null, otrBocaToProspectController.resend);

            //do the resend
            otrBocaToProspectController.resendBOCAToProspect();

            //Create the components
            OTRBOCAToProspectComponentController otrBocaToProspectComponentController = new OTRBOCAToProspectComponentController();
            otrBocaToProspectComponentController.bocaToProspectId = otrBocaToProspectController.bocaToProspect.Id;

            //assert some stuff. but not really bc if it's commented we aren't actually doing anything
            //System.assertNotEquals(null, otrBocaToProspectComponentController.bocaToProspect);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.primaryBrandingCard);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.pgValue);
            //System.assertNotEquals(null, otrBocaToProspectComponentController.primaryBrandingUtility);

            // Test the reminder function
            otrBocaToProspectPage = Page.OTRBOCAToProspect;
            otrBocaToProspectPage.getParameters().put('bocaToProspectId', otrBocaToProspectController.bocaToProspect.Id);
            Test.setCurrentPage(otrBocaToProspectPage);

            otrBocaToProspectController.init();

            otrBocaToProspectRedirect = otrBocaToProspectController.bocaToProspectReminder();

        }

        Test.stopTest();

    }

    @isTest
    static void testExtraStuff(){
        //SET UP WHAT WE NEED FOR TESTS
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        a.Name = 'Thisreallylongnameissillybuthastobemorethanthirtycharacterstomakeitfail';
        update a;
        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity WHERE Name = 'TestOpp'];
        Program__c program = [SELECT Id FROM Program__c LIMIT 1];
        OnlineApplicationOffer__c offer = [SELECT Id FROM OnlineApplicationOffer__c WHERE Program__c =: program.Id LIMIT 1];
        OnlineApplication__c myApplication = [SELECT Id FROM OnlineApplication__c LIMIT 1];
        TestUtils.enable_isRunningTest = true;

        //set some parameters
        PageReference otrBocaToProspectPage = Page.OTRBOCAToProspect;
        otrBocaToProspectPage.getParameters().put('id', opportunity.Id);
        otrBocaToProspectPage.getParameters().put('applicationId', myApplication.Id);
        Test.setCurrentPage(otrBocaToProspectPage);

        Apexpages.StandardController standardController = new ApexPages.StandardController(opportunity);
        OTRBOCAToProspectController otrBocaToProspectController = new OTRBOCAToProspectController(standardController);

        String myErrorName = [SELECT Name FROM Internal_Application_Error__c LIMIT 1].Name;

        Test.startTest();

        System.runAs(integrationUser) {

            Boolean b = otrBocaToProspectController.hasError;

            //test init; should fail bc account name is silly
            otrBocaToProspectController.init();
            a.Name='Better';
            update a;

            delete [SELECT Id FROM OpportunityContactRole];
            otrBocaToProspectController.init();

            otrBocaToProspectPage.getParameters().put('bocaToProspectConfirm','true');
            otrBocaToProspectController.init();

            otrBocaToProspectPage.getParameters().put('bocaToProspectConfirm','false');
            otrBocaToProspectPage.getParameters().put('errorCode', myErrorName);
            otrBocaToProspectController.init();
            otrBocaToProspectPage.getParameters().put('errorCode', '000');
            otrBocaToProspectController.init();

            otrBocaToProspectController.applicationId = myApplication.Id;
            String s = otrBocaToProspectController.applicationId;

            otrBocaToProspectController.bocaToProspectId = myApplication.Id;
            s = otrBocaToProspectController.bocaToProspectId;

            otrBocaToProspectController.bocaToProspectConfirm = myApplication.Id;
            s = otrBocaToProspectController.bocaToProspectConfirm;

            b = otrBocaToProspectController.resend;
            otrBocaToProspectPage.getParameters().put('resend', '123');
            b = otrBocaToProspectController.resend;

            Id i = otrBocaToProspectController.contactid;
            i = otrBocaToProspectController.contactid;

            otrBocaToProspectController.salesRep = null;
            s = otrBocaToProspectController.salesRepName;

            s = otrBocaToProspectController.errorCodeDescription;

            Map<String, String> smap = otrBocaToProspectController.associatedOffers;

            otrBocaToProspectController.doNothing();

            otrBocaToProspectController.contact = null;
            otrBocaToProspectController.salesRep = null;
            otrBocaToProspectController.opportunity = null;
            otrBocaToProspectController.bocaToProspect();

            otrBocaToProspectController.selectedAdditionalContacts='incorrectJSONString';
            otrBocaToProspectController.resendBOCAToProspect();
            otrBocaToProspectController.bocaToProspectReminder();
        }
        Test.stopTest();
    }

}