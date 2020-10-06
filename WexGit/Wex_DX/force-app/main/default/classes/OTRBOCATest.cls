/*
Description:        Test class for OTRBocaController and OTRSetupController
Revision History:   3/27/2019 Jason Arbegast IADJUDICAT-929 utilize test setup method; add test method for generating pdf
                    4/15/2019 Jason Arbegast IADJUDICAT-966 remove selectedaddressoption
*/
@isTest
public class OTRBOCATest {

    @testSetup
    static void setup(){
    
        UtilityTestLoader.setAutomation(false);
    
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
        onlineApplicationOffer.PSR_ATM_Limit__c = 1.00;
        onlineApplicationOffer.PSR_Card_Fee__c = 1.00;
        onlineApplicationOffer.PSR_Fuel_Cash__c = 1.00;
        onlineApplicationOffer.PSR_Marketing_Fee__c = 1.00;
        onlineApplicationOffer.PSR_Money_Code__c = 1.00;
        onlineApplicationOffer.PSR_Scales__c = 1.00;

        insert onlineApplicationOffer;

        Attachment terms = new Attachment();
        terms.Name = 'TestVersion-01';
        Blob termsBlob = Blob.valueOf('Unit Test Attachment Body');
        terms.body = termsBlob;
        terms.parentId = onlineApplicationOffer.Id;
        upsert terms;

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

        program.Name = 'OTRTestBOCAX';
        program.Form_Template__c = 'OTRBOCA';
        program.Brand_Short_Name__c = 'OTRTESTX';
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

        insert program;

        onlineApplicationOffer.Program__c = program.Id;

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

        Campaign_Program__c campaignProgram = new Campaign_Program__c();
        //create campaign program test data
        campaignProgram.Name = 'OTR Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'OTR Test Heading';
        brandingUtility.Brand_Tagline__c = 'OTR Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'OTR Test Sidebar Title';
        brandingUtility.SideBar__c = 'OTR Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'OTRTest';
        brandingUtility.Program_Sell_Sheets__c = 'www.sellsheet.com';

        insert brandingUtility;

        WexProgramUtility wpu = new WexProgramUtility();

        System.assert(wpu.hasAnotherDefaultTermsAndConditionsSet(campaignProgram) == false);
        System.assert(wpu.isDefault(campaignProgram) == true);
        System.assert(wpu.hasDefaultTermsAndConditions(program.Id) == true);

        PostCode__c postalCode = new PostCode__c();
        postalCode.State__c = 'ME';
        postalCode.Postcode__c = '4106';
        insert postalCode;

        Opportunity opportunity = new Opportunity(name= 'TestOpp',closedate= Date.today() ,stagename='5) Signed', fleet_size__c = 10, sourcesystem__c = 'BOCA', Legal_Structure__c = 'Corporation');
        opportunity.Fueling_Methos__c = 'BP';

        insert opportunity;

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
//        onlineApplication.Payment_Method__c = 'Customer ACH';
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
        //onlineApplication.Day_of_Payment__c = 'Monday;Tuesday';
//        onlineApplication.Payment_Method__c = 'Auto Draft';
        onlineApplication.ThreatMetrix_Request_ID__c = '123456789';
        onlineApplication.Program__c = program.Id;
        onlineApplication.Account__c = offerAccount.Id;
        onlineApplication.Opportunity__c = opportunity.Id;
        onlineApplication.Trip__c = true;
        onlineApplication.Odometer__c = true;
        onlineApplication.Unit__c = true;
        onlineApplication.PDF_Token__c = '123456';

        insert onlineApplication;

    }

    static testMethod void testOTRBOCA() {

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'IS Sales'];

        User user = new User(Alias = 'tUse', Email='stanTestuser@wexinc.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='stanarduser@wexinc.com', Territory_Code__c = 'E3');

        insert user;

        User sinte = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.debug('Found Credit User: ' + sinte.Id);

        System.runAs(sinte) {

            Program__c program = [SELECT Id, Brand_Short_Name__c, Publish_BOCA__c FROM Program__c LIMIT 1];

            // THREATMETRIX!
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('r_WE_orchestraPageSupport');
            mock.setStatusCode(200); // Or other appropriate HTTP status code
            mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);

            TestUtils.enable_isRunningTest = true;

            PageReference otrBOCA = Page.OTRBOCA;

            Test.setCurrentPage(otrBOCA);

            OTRBOCAController otrBOCAController = new OTRBOCAController();

            PageReference errorPage = otrBOCAController.init();

            System.assert(errorPage != null);

            // Test with non-existent program passed in
            otrBOCA = Page.OTRBOCA;
            otrBOCA.getParameters().put('pgm', 'someProgram');

            Test.setCurrentPage(otrBOCA);

            errorPage = otrBOCAController.init();

            System.assert(errorPage != null);

            // Test with a non-published program passed in
            otrBOCA = Page.OTRBOCA;
            otrBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);

            Test.setCurrentPage(otrBOCA);

            errorPage = otrBOCAController.init();

            System.assert(errorPage != null);

            // Publish the BOCA
            program.Publish_BOCA__c = true;
            upsert program;

            // Test with non-existant BOCA to Prospect
            otrBOCA = Page.OTRBOCA;
            otrBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            otrBOCA.getParameters().put('priority', 'true');
            otrBOCA.getParameters().put('customer', '0000');

            Test.setCurrentPage(otrBOCA);

            errorPage = otrBOCAController.init();

            System.assert(errorPage != null);

            // Test with a published BOCA
            otrBOCA = Page.OTRBOCA;
            otrBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            otrBOCA.getParameters().put('pg', 'a');
            otrBOCA.getParameters().put('territorycode', 'E3');

            Test.setCurrentPage(otrBOCA);

            errorPage = otrBOCAController.init();

            otrBOCAController.sendToConfirmation = true;

            System.assert(otrBOCAController.salesRep != null);

            System.assert(otrBOCAController.businessDescriptionOptions != null);
            System.assert(otrBOCAController.paymentMethodOptions != null);
            //System.assert(otrBOCAController.dayOfPaymentOptions != null);

            System.assert(otrBOCAController.fleetIdentifier == null);

            System.assert(otrBOCAController.termsAndConditionsId != null);

            if(otrBOCAController.onlineApplication != null) {

                otrBOCAController.onlineApplication.ABA_Routing_Number__c = '123456789';
                otrBOCAController.onlineApplication.AO_Address__c = '100 N. State';
                otrBOCAController.onlineApplication.AO_City__c = 'Chicago';
                otrBOCAController.onlineApplication.AO_Confirm_Social_Security_Number__c = '123456789';
                otrBOCAController.onlineApplication.Contact_Name__c = 'PD James';
                otrBOCAController.onlineApplication.Contact_First_Name__c = 'PD';
                otrBOCAController.onlineApplication.Contact_Last_Name__c = 'James';
                otrBOCAController.onlineApplication.AO_Date_of_Birth__c = Date.today().addYears(-20);
                otrBOCAController.onlineApplication.AO_Home_Phone_Number__c = '3123127788';
                otrBOCAController.onlineApplication.AO_Name__c = 'George Smiley';
                otrBOCAController.onlineApplication.AO_Social_Security_Number__c = '123456789';
                otrBOCAController.onlineApplication.AO_State__c = 'IL';
                otrBOCAController.onlineApplication.AO_Title__c = 'CEO';
                otrBOCAController.onlineApplication.AO_Work_Email__c = 'dcraigmile@forseva.com';
                otrBOCAController.onlineApplication.AO_Zip_Code__c = '60603';
                otrBOCAController.onlineApplication.Application_Title__c = 'Living Will for Homer Simpson';
                otrBOCAController.onlineApplication.Branch_Address__c = '100 East Washington';
                otrBOCAController.onlineApplication.Branch_City__c = 'Chicago';
                otrBOCAController.onlineApplication.Branch_Phone_Number__c = '3128889999';
                otrBOCAController.onlineApplication.Branch_State__c = 'IL';
                otrBOCAController.onlineApplication.Branch_Zip_Code__c = '60603';
                otrBOCAController.onlineApplication.Business_Street_Address__c = '200 East Adams';
                otrBOCAController.onlineApplication.Cell_Number__c = '3124449999';
                otrBOCAController.onlineApplication.Change_to_Authorizing_Officer_Address__c = false;
                otrBOCAController.onlineApplication.Checking_Account_Number__c = '1234567890123';
                otrBOCAController.onlineApplication.City__c = 'Peoria';
                otrBOCAController.onlineApplication.Confirm_ABA_Routing_Number__c = '123456789';
                otrBOCAController.onlineApplication.Confirm_Checking_Account_Number__c = '1234567890123';
                otrBOCAController.onlineApplication.Credit_Line_Requested__c = 10000;
                otrBOCAController.onlineApplication.Data_Entry_Stage__c = null;
                otrBOCAController.onlineApplication.Days_of_Payment__c = 'Monday';
                otrBOCAController.onlineApplication.DUNS__c = '123456789';
                otrBOCAController.onlineApplication.Email__c = 'dcraigmile@forseva.com';
                otrBOCAController.onlineApplication.Embossing_Line_1_Company_Name__c = 'Forseva Trucking';
                otrBOCAController.onlineApplication.Fax_Number__c = '3129998888';
                otrBOCAController.onlineApplication.Federal_Tax_ID__c = '123456789';
                otrBOCAController.onlineApplication.Financial_Institution__c = 'Chase Bank';
                otrBOCAController.onlineApplication.How_Did_You_Hear_About_Us__c = 'Brochure';
                otrBOCAController.onlineApplication.I_Have_Read_and_Agree__c = false;
                otrBOCAController.onlineApplication.Invoice_Delivery_Method__c = 'Email';
                otrBOCAController.onlineApplication.Invoice_Delivery_Method_Email__c = 'dcraigmile@forseva.com';
                otrBOCAController.onlineApplication.Invoice_Delivery_Method_Fax__c = '3129998888';
                otrBOCAController.onlineApplication.Legal_Business_Name__c = 'Legal Name';
                otrBOCAController.onlineApplication.Lead_Source_Subtype__c = null;
                otrBOCAController.onlineApplication.Name_of_Parent_Company__c ='Parent Company';
                otrBOCAController.onlineApplication.Number_of_Drivers__c = 10;
                otrBOCAController.onlineApplication.Number_of_Trailers__c = 20;
                otrBOCAController.onlineApplication.Number_of_Trucks__c = 55;
                otrBOCAController.onlineApplication.Number_of_Vehicles__c = 40;
                otrBOCAController.onlineApplication.Odometer__c = true;
                otrBOCAController.onlineApplication.Offer__c = otrBOCAController.onlineApplicationOffer.Id;
                //otrBOCAController.onlineApplication.Payment_Method__c = 'Customer ACH';
                otrBOCAController.onlineApplication.Phone_Number__c = '3123339999';
                otrBOCAController.onlineApplication.Product_Type__c = 'OTR';
                otrBOCAController.onlineApplication.Promotional_Code__c = 'promo12345';
                otrBOCAController.onlineApplication.State__c = 'IL';
                otrBOCAController.onlineApplication.Status__c = 'App-Incomplete';
                otrBOCAController.onlineApplication.Trade_Name__c = 'Forseva LLC';
                otrBOCAController.onlineApplication.Trip__c = false;
                otrBOCAController.onlineApplication.Type_of_Business__c = 'Sole Proprietorship';
                otrBOCAController.onlineApplication.Type_of_Business_Other__c = 'Online Delivery';
                otrBOCAController.onlineApplication.Unit__c = false;
                otrBOCAController.onlineApplication.Year_Established__c = '1980';
                otrBOCAController.onlineApplication.Zip_Code__c = '60606';
                otrBOCAController.onlineApplication.OwnerId = UserInfo.getUserId();
                otrBOCAController.onlineApplication.Days_of_Payment__c = 'Monday / Tuesday';
                //otrBOCAController.onlineApplication.Payment_Method__c = 'Auto Draft';

                otrBOCAController.onlineApplication.AO_Title__c = 'President';
                otrBOCAController.onlineApplication.AO_Name__c = 'Test McTesterson';
                otrBOCAController.onlineApplication.AO_Work_Email__c = 'test@test.com';
                otrBOCAController.onlineApplication.AO_Address__c = '123 Darling Ave';
                otrBOCAController.onlineApplication.AO_City__c = 'South Portland';
                otrBOCAController.onlineApplication.AO_State__c = 'ME';
                otrBOCAController.onlineApplication.AO_Zip_Code__c = '04106';
                otrBOCAController.onlineApplication.AO_Country__c = 'US';
                otrBOCAController.onlineApplication.AO_Home_Phone_Number__c = '555-555-5555';

                otrBOCAController.recalculatePG();

                otrBOCAController.setCreditLineRequested();
                //eeee

                //onlineApplication.Status__c = 'App-Incomplete';

                //upsert onlineApplication;

                PageReference redirect = otrBOCAController.submitApplication();

                System.assert(otrBOCAController.usStateList != null);
                System.assert(otrBOCAController.beneficialOwnerSettings != null);

                // Test OTR Setup error
                PageReference OTRSetup = Page.OTRSetup;
                OTRSetup.getParameters().put('pgm', program.Brand_Short_Name__c);
                OTRSetup.getParameters().put('lang', 'en_us');

                Test.setCurrentPage(OTRSetup);

                OTRSetupController otrSetupController = new OTRSetupController();

                redirect = otrSetupController.init();

                System.assert(redirect != null);

                // Testing OTR Setup
                OTRSetup = Page.OTRSetup;
                OTRSetup.getParameters().put('pgm', program.Brand_Short_Name__c);
                OTRSetup.getParameters().put('customer', otrBOCAController.onlineApplication.Id);
                OTRSetup.getParameters().put('lang', 'en_us');

                Test.setCurrentPage(OTRSetup);

                otrSetupController = new OTRSetupController();

                otrSetupController.init();

                otrSetupController.populateAddress();

                otrSetupController.numberOfCards = 15;

                otrSetupController.addDriver();

                otrSetupController.selectedDriverIndex = '0';

                otrSetupController.selectedUnitIndex = '0';

                otrSetupController.removeDriver();

                otrSetupController.removeVehicle();

                System.assert(otrSetupController.otherServicesSize != null);
                System.assert(otrSetupController.programParameter != null);

                System.assert(otrSetupController.salesRep == null);
                System.assert(otrSetupController.salesCode == null);

                otrSetupController.submitForm();

                otrSetupController.generatePDFandConfirm();

                System.assert(redirect != null);

            }

            Test.stopTest();

        }

    }

    static testMethod void testBOCAToPDF() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, PDF_Token__c FROM OnlineApplication__c LIMIT 1];

        if(onlineApplications.size() > 0) {

            BOCAToPDFController bocaToPDFController = new BOCAToPDFController();

            PageReference bocaToPDF = Page.BOCAToPDF;
            bocaToPDF.getParameters().put('applicationId', onlineApplications[0].Id);
            bocaToPDF.getParameters().put('token', onlineApplications[0].PDF_Token__c);

            Test.setCurrentPage(bocaToPDF);

            bocaToPDFController.init();

            System.assert(bocaToPDFController.brandingLogo != null);
            System.assert(bocaToPDFController.languageCode != null);
            System.assert(bocaToPDFController.containsPG != null);
            System.assert(bocaToPDFController.termsAndConditions != null);
            System.assert(bocaToPDFController.termsAndConditionsId != null);



        }

    }

    static testMethod void testOTRBOCAConfirmationPage() {

        Test.startTest();

        Program__c program = [SELECT Id, Brand_Short_Name__c FROM Program__c LIMIT 1];

        List<OnlineApplication__c> onlineApplications = [SELECT Id, PDF_Token__c FROM OnlineApplication__c LIMIT 1];

        if(onlineApplications.size() > 0) {

            // Testing OTR Confirmation Page
            PageReference OTRBOCAConfirmation = Page.OTRBOCAConfirmation;
            OTRBOCAConfirmation.getParameters().put('pgm', program.Brand_Short_Name__c);
            OTRBOCAConfirmation.getParameters().put('customer', onlineApplications[0].Id);
            OTRBOCAConfirmation.getParameters().put('lang', 'en_us');

            Test.setCurrentPage(OTRBOCAConfirmation);

            OTRBOCAConfirmationController otrBOCAConfirmationController = new OTRBOCAConfirmationController();

            otrBOCAConfirmationController.init();

            System.assert(otrBOCAConfirmationController.brandingLogo != null);
            System.assert(otrBOCAConfirmationController.brandingCard != null);

        }

        Test.stopTest();

    }

    static testMethod void testProgramPublishTrigger() {

        Test.startTest();

        // Setup Program
        Program__c program = new Program__c();

        program.Name = 'OTRTestBOCA';
        program.Form_Template__c = 'OTRBOCA';
        program.Brand_Short_Name__c = 'OTRTest';
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

        insert program;

        try {
            program.Publish_BOCA__c = true;
            update program;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('An OTR BOCA must have an associated default Online Application Offer') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Program__c updatedProgram = [SELECT Id, Publish_BOCA__c FROM Program__c WHERE Id = :program.Id];

        System.assert(updatedProgram.Publish_BOCA__c != true);

        Test.stopTest();

    }

    static testMethod void testGeneratePDFMethod() {

        Program__c program = [SELECT Id, Name, Brand_Short_Name__c FROM Program__c LIMIT 1];

        List<OnlineApplication__c> onlineApplications = [SELECT Id, PDF_Token__c, Name FROM OnlineApplication__c LIMIT 1];
        OnlineApplication__c onlineApp;
        if(onlineApplications.size()>0)
            onlineApp = onlineApplications[0];

        Attachment pdfAttachment;

        Test.startTest();
        TestUtils.enable_isRunningTest = true;
        pdfAttachment = OTRSetupController.generatePDF(onlineApp, '(Partial)');
        Test.stopTest();

        system.assertEquals(onlineApp.Id, pdfAttachment.parentId);

        PageReference otrBOCA = Page.OTRBOCA;
        otrBOCA = Page.OTRBOCA;
        otrBOCA.getParameters().put('pgm', program.Name);

        Test.setCurrentPage(otrBOCA);
        OTRBOCAController otrBOCAController = new OTRBOCAController();
        PageReference errorPage = otrBOCAController.init();
        otrBOCAController.onlineApplication = onlineApp;
        otrBOCAController.program = program;
        otrBOCAController.generatePDF();

    }

}