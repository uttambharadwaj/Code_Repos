/*
*
* Credit Decisioning Process - Unit Tests
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/

@isTest
public class CreditDecisionEngineTest {

    @testSetup
    static void setupUser() {

        Account offerAccount = new Account();
        offerAccount.Name = 'TestAccount-01';

        insert offerAccount;

        OnlineApplicationOffer__c onlineApplicationOffer = new OnlineApplicationOffer__c();
        onlineApplicationOffer.Name = 'TestOffer-01';
        onlineApplicationOffer.Application_Title__c = 'TestTitle';
        onlineApplicationOffer.Complete_Later_Text__c = 'Test';
        onlineApplicationOffer.EchoSign_User_Email__c = 'test@test.com';
        onlineApplicationOffer.Terms_and_Conditions_Version__c = 'TestVersion-01';
        onlineApplicationOffer.BOCA_Default_Offer__c = true;
        onlineApplicationOffer.Disclosure__c = 'Test';
        onlineApplicationOffer.Credit_Limit_Per_Truck__c = 2500.00;
        onlineApplicationOffer.Credit_Limit_Per_Truck_Slip_Seat__c = 3500.00;

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

        List<OnlineApplication__c> onlineApplications = new List<OnlineApplication__c>();

        for (Integer i = 0; i < 2; i++) {

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
            onlineApplication.Branch_Address__c = '100 East Washington';
            onlineApplication.Branch_City__c = 'Chicago';
            onlineApplication.Branch_Phone_Number__c = '3128889999';
            onlineApplication.Branch_State__c = 'IL';
            onlineApplication.Branch_Zip_Code__c = '60603';
            onlineApplication.Business_Street_Address__c = '200 East Adams';
            onlineApplication.Card_Shipping_Address_Line_1__c = '200 East Adams';
            onlineApplication.Cell_Number__c = '3124449999';
            onlineApplication.Change_to_Authorizing_Officer_Address__c = false;
            onlineApplication.Checking_Account_Number__c = '1234567890123';
            onlineApplication.Card_Shipping_City__c = 'Peoria';
            onlineApplication.City__c = 'Peoria';
            onlineApplication.Confirm_ABA_Routing_Number__c = '123456789';
            onlineApplication.Confirm_Checking_Account_Number__c = '1234567890123';
            onlineApplication.Contact_First_Name__c = 'Testy';
            onlineApplication.Contact_Last_Name__c = 'McTesterson';
            onlineApplication.Credit_Line_Requested__c = 10000;
            onlineApplication.Data_Entry_Stage__c = null;
            onlineApplication.Day_of_Payment__c = 'Monday';
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
            onlineApplication.Legal_Business_Name__c = 'Legal Business Name';
            onlineApplication.Lead_Source_Subtype__c = null;
            onlineApplication.Name_of_Parent_Company__c = 'Parent Company';
            onlineApplication.Number_of_Drivers__c = 10;
            onlineApplication.Number_of_Trailers__c = 20;
            onlineApplication.Number_of_Trucks__c = 55;
            onlineApplication.Number_of_Vehicles__c = 40;
            onlineApplication.Odometer__c = true;
            onlineApplication.Offer__c = onlineApplicationOffer.Id;
            onlineApplication.Payment_Method__c = 'Customer ACH';
            onlineApplication.PG_Required__c = true;
            onlineApplication.Phone_Number__c = '3123339999';
            onlineApplication.Product_Type__c = 'OTR';
            onlineApplication.Promotional_Code__c = 'promo12345';
            onlineApplication.State__c = 'IL';
            onlineApplication.Card_Shipping_State__c = 'IL';
            onlineApplication.Status__c = 'App-Incomplete';
            onlineApplication.Trade_Name__c = 'Forseva LLC';
            onlineApplication.Trip__c = false;
            onlineApplication.Type_of_Business__c = 'Corporation';
            onlineApplication.Type_of_Business_Other__c = 'Online Delivery';
            onlineApplication.Unit__c = false;
            onlineApplication.Year_Established__c = '1980';
            onlineApplication.Card_Shipping_Postal_Code__c = '60606-0000';
            onlineApplication.Zip_Code__c = '60606-0000';
            onlineApplication.OwnerId = UserInfo.getUserId();
            onlineApplication.Day_of_Payment__c = 'Monday;Tuesday';
            onlineApplication.Payment_Method__c = 'Auto Draft';
            onlineApplication.ThreatMetrix_Request_ID__c = '123456789';

            onlineApplications.add(onlineApplication);

        }

        insert onlineApplications;

    }

    static testMethod void testCreditDecisionEngine() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runas(integrationUser) {

            List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c];

            if (onlineApplications.size() > 0) {

                Test.startTest();

                TestUtils.enable_isRunningTest = true;

                Test.setMock(HttpCalloutMock.class, new CalloutMock());

                CreditDecisionEngineOTR.runOTRDecisioningProcess(onlineApplications[0].Id);

                Test.stopTest();

            }

        }

    }

    static testMethod void testCreditUtilCalculateCreditLine() {

        List<OnlineApplication__c> onlineApplications = [
                SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,Decision_Comments__c,DNB_CSAD_High_Credit__c,Team_Drivers_Slip_Seat__c,Number_of_Trucks__c,PG_Required__c,PG_High_Credit_Amount__c,PG_Score__c
                FROM OnlineApplication__c
        ];

        if (onlineApplications.size() > 0) {
            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            /** TEST COMMERCIAL  */
            // Risk Grade 1 and 2
            // requesting under 10k
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].Credit_Line_Requested__c = 9000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 9000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 15000;
            onlineApplications[0].Number_of_Trucks__c = 1;
            upsert onlineApplications[0];

            Decimal oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(9000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // has high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '2';
            onlineApplications[0].Credit_Line_Requested__c = 11000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(11000, oa);

            // Risk Grade 1 and 2
            // requesting great than 10k and less than 150k
            // does NOT have high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 20000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 1 and 2
            // requesting less than DNB is suggesting
            onlineApplications[0].Risk_Grade__c = '2';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 25000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 30000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // has high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '3';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 20000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 25000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(20000, oa);

            // Risk Grade 3
            // requesting less than 150k
            // does NOT have high credit amount to cover
            onlineApplications[0].Risk_Grade__c = '3';
            onlineApplications[0].Credit_Line_Requested__c = 20000;
            onlineApplications[0].DNB_Credit_Line_Recommendation__c = 20000;
            onlineApplications[0].DNB_CSAD_High_Credit__c = 10000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(10000, oa);


            /** TEST CONSUMER */
            // FICO 750+
            // High credit covers requested
            onlineApplications[0].PG_Required__c = true;
            onlineApplications[0].PG_Score__c = 760;
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 720 and <= 750
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 740;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 680 and <= 719
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 700;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // FICO >= 660 and <= 679
            // High credit covers requested
            onlineApplications[0].PG_Score__c = 670;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // High credit doesn't cover requested, capped off at high credit amount, approved for high credit
            onlineApplications[0].Credit_Line_Requested__c = 10000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // Number of trucks effect credit recommendation (offering them more than they requested)
            onlineApplications[0].PG_Score__c = 751;
            onlineApplications[0].Number_of_Trucks__c = 3;  // resulting in upping "requested" credit to 7500
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            onlineApplications[0].PG_High_Credit_Amount__c = 11000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(7500, oa);

            // Number of trucks effect credit recommendation and is a slip seat (offering them more than they requested)
            onlineApplications[0].Team_Drivers_Slip_Seat__c = true; // resulting in upping "requested" creit to 10500
            onlineApplications[0].Credit_Line_Requested__c = 5000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(10500, oa);

            /** TEST FOR BOTH COMMERCIAL AND CONSUMER */

            // Risk Grade 4
            // credit line brought down to the minimum of $5000
            onlineApplications[0].Number_of_Trucks__c = 1;
            onlineApplications[0].Risk_Grade__c = '4';
            onlineApplications[0].Credit_Line_Requested__c = 10000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(5000, oa);

            // Didn't have a credit line recommendation higher than the minimum amount of $2500
            onlineApplications[0].Risk_Grade__c = '1';
            onlineApplications[0].Team_Drivers_Slip_Seat__c = false;
            onlineApplications[0].Credit_Line_Requested__c = 2000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(2500, oa);

            // Didn't have a credit line recommendation higher than the minimum slip seat amount of $3500
            onlineApplications[0].Team_Drivers_Slip_Seat__c = true;
            onlineApplications[0].Credit_Line_Requested__c = 3000;
            upsert onlineApplications[0];

            oa = (Decimal) cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);
            System.assertEquals(3500, oa);

            cuccl.postProcess();

            cuccl.preProcess(onlineApplications, 'Test', 'Test');

        }

    }

    static testMethod void testFraudCreditLineCheck() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            CreditUtil_FraudCreditLineCheck cuccl = new CreditUtil_FraudCreditLineCheck();

            cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);

            cuccl.postProcess();

            cuccl.preProcess(onlineApplications, 'Test', 'Test');

        }

    }

    static testMethod void testLocationCheck() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            CreditUtil_LocationCheck cuccl = new CreditUtil_LocationCheck();

            cuccl.getFunctionValue(null, new OnlineApplication__c(Id = onlineApplications[0].Id), 'String', 'String', 'String', onlineApplications[0].Id);

            cuccl.postProcess();

            cuccl.preProcess(onlineApplications, 'Test', 'Test');

        }

    }

    static testMethod void testExistingExposure() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            PageReference creditExistingExposure = Page.CreditExistingExposure;

            creditExistingExposure.getParameters().put('id', onlineApplications[0].Id);

            Test.setCurrentPage(creditExistingExposure);

            CreditExistingExposureController ceec = new CreditExistingExposureController();

            ceec.init();

            System.assert(ceec.duplicateAccounts.size() == 0);
            System.assert(ceec.duplicateApplications.size() > 0);

        }

    }

    static testMethod void testThreatMetrixCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, ThreatMetrix_Request_ID__c FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Test.setMock(HttpCalloutMock.class, new ThreatMetrixCalloutMock());

            CreditWS_ThreatMetrix.ThreatMetrixQueryRequest threatMetrixQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixQueryRequest();
            threatMetrixQueryRequest.threatMetrixRequestId = onlineApplications[0].ThreatMetrix_Request_ID__c;
            CreditWS_ThreatMetrix.getThreatMetrixScore(threatMetrixQueryRequest);

            Test.stopTest();

        }

    }

    static testMethod void testLexisNexisBridgerBusinessCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, Federal_Tax_ID__c, Legal_Business_Name__c, Business_Street_Address__c, City__c, State__c, Zip_code__c FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest request = new CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest();

            request.companyName = onlineApplications[0].Legal_Business_Name__c;

            request.addressLine1 = onlineApplications[0].Business_Street_Address__c;
            request.city = onlineApplications[0].City__c;
            request.state = onlineApplications[0].State__c;
            request.postalCode = onlineApplications[0].Zip_Code__c;

            request.ein = onlineApplications[0].Federal_Tax_ID__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessResponse response = CreditWS_LexisNexisBridger.bridgerSearchBusiness(request);

            Test.stopTest();

        }

    }

    static testMethod void testLexisNexisBridgerIndividualCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, Contact_First_Name__c, Contact_Last_Name__c, AO_Address__c, AO_City__c, AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest request = new CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest();

            request.firstName = onlineApplications[0].Contact_First_Name__c;
            request.lastName = onlineApplications[0].Contact_Last_Name__c;
            request.addressLine1 = onlineApplications[0].AO_Address__c;
            request.city = onlineApplications[0].AO_City__c;
            request.state = onlineApplications[0].AO_State__c;
            request.postalCode = onlineApplications[0].AO_Zip_Code__c;
            request.dateOfBirth = onlineApplications[0].AO_Date_of_Birth__c;
            request.socialSecurityNumber = onlineApplications[0].AO_Social_Security_Number__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualResponse response = CreditWS_LexisNexisBridger.bridgerSearchIndividual(request);

            Test.stopTest();

        }

    }

    static testMethod void testDNBAdvancedLookup() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            PageReference dnbAdvancedLookupPage = Page.FindDupOnlineApps;
            dnbAdvancedLookupPage.getParameters().put('applicationId', onlineApplications[0].Id);
            Test.setCurrentPage(dnbAdvancedLookupPage);

            DNBAdvancedLookupController dalc = new DNBAdvancedLookupController();

            dalc.init();

            System.assert(dalc.applicationId != null);

            dalc.selectedDunsNumber = '123456789';

            dalc.populateDUNS();

        }

    }

    static testMethod void testLexisNexisBridgerWSUtil() {

        Test.startTest();

        new CreditWSUtil_LexisNexisBridger.AddAttachment_element();
        new CreditWSUtil_LexisNexisBridger.AddAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddList_element();
        new CreditWSUtil_LexisNexisBridger.AddListResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddRecordResult();
        new CreditWSUtil_LexisNexisBridger.AddRecords_element();
        new CreditWSUtil_LexisNexisBridger.AddRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddResultRecord_element();
        new CreditWSUtil_LexisNexisBridger.AddResultRecordResponse_element();
        new CreditWSUtil_LexisNexisBridger.ArrayOfAddRecordResult();
        new CreditWSUtil_LexisNexisBridger.ArrayOfAuditItem();
        new CreditWSUtil_LexisNexisBridger.ArrayOfCountryAKA();
        new CreditWSUtil_LexisNexisBridger.ArrayOfCountryLocation();
        new CreditWSUtil_LexisNexisBridger.ArrayOfDataFileInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAKA();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityMatchInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityPhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDAddressHistory();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDAlternateName();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDFEINMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIDataSource();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIDataSourceVerification();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIException_x();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIVerificationResult();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputPhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInt();
        new CreditWSUtil_LexisNexisBridger.ArrayOfListInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfListRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfLong();
        new CreditWSUtil_LexisNexisBridger.ArrayOfOFACInstitutionInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwirePhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022AdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Address();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Field();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022ID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Note();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Party();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Phone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfResultError();
        new CreditWSUtil_LexisNexisBridger.ArrayOfResultRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfRunInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfString();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWatchlistDataFile();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWatchlistMatchState();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLAddressMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLCitizenshipMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLDOBMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLIDMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLMatchSummaryItem();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLPhoneMatch();
        new CreditWSUtil_LexisNexisBridger.AssignmentInfo();
        new CreditWSUtil_LexisNexisBridger.Attachment();
        new CreditWSUtil_LexisNexisBridger.AuditItem();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IAccount();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IListMaintenance();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IResults();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch();
        new CreditWSUtil_LexisNexisBridger.ChangePassword_element();
        new CreditWSUtil_LexisNexisBridger.ChangePasswordResponse_element();
        new CreditWSUtil_LexisNexisBridger.ClientContext();
        new CreditWSUtil_LexisNexisBridger.CountryAKA();
        new CreditWSUtil_LexisNexisBridger.CountryCriteria();
        new CreditWSUtil_LexisNexisBridger.CountryInfo();
        new CreditWSUtil_LexisNexisBridger.CountryLocation();
        new CreditWSUtil_LexisNexisBridger.DataFileInfo();
        new CreditWSUtil_LexisNexisBridger.Date_x();
        new CreditWSUtil_LexisNexisBridger.DeleteAttachment_element();
        new CreditWSUtil_LexisNexisBridger.DeleteAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteList_element();
        new CreditWSUtil_LexisNexisBridger.DeleteListResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRecords_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.DeleteResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRuns_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRunsResponse_element();
        new CreditWSUtil_LexisNexisBridger.EntityAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.EntityAddress();
        new CreditWSUtil_LexisNexisBridger.EntityAKA();
        new CreditWSUtil_LexisNexisBridger.EntityCriteria();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaAddress();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaID();
        new CreditWSUtil_LexisNexisBridger.EntityID();
        new CreditWSUtil_LexisNexisBridger.EntityInfo();
        new CreditWSUtil_LexisNexisBridger.EntityMatchInfo();
        new CreditWSUtil_LexisNexisBridger.EntityName();
        new CreditWSUtil_LexisNexisBridger.EntityPhone();
        new CreditWSUtil_LexisNexisBridger.FPAddress();
        new CreditWSUtil_LexisNexisBridger.FPInput();
        new CreditWSUtil_LexisNexisBridger.FPRedFlag();
        new CreditWSUtil_LexisNexisBridger.FPResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.FPRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.FraudPointConfiguration();
        new CreditWSUtil_LexisNexisBridger.FraudPointResultCriteria();
        new CreditWSUtil_LexisNexisBridger.FraudPointResults();
        new CreditWSUtil_LexisNexisBridger.GetAttachment_element();
        new CreditWSUtil_LexisNexisBridger.GetAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetDataFileList_element();
        new CreditWSUtil_LexisNexisBridger.GetDataFileListResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetDaysUntilPasswordExpires_element();
        new CreditWSUtil_LexisNexisBridger.GetDaysUntilPasswordExpiresResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetList_element();
        new CreditWSUtil_LexisNexisBridger.GetListResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetRecords_element();
        new CreditWSUtil_LexisNexisBridger.GetRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.GetResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetRunInfo_element();
        new CreditWSUtil_LexisNexisBridger.GetRunInfoResponse_element();
        new CreditWSUtil_LexisNexisBridger.IIDAddress();
        new CreditWSUtil_LexisNexisBridger.IIDAddressHistory();
        new CreditWSUtil_LexisNexisBridger.IIDAlternateName();
        new CreditWSUtil_LexisNexisBridger.IIDFEINMatch();
        new CreditWSUtil_LexisNexisBridger.IIDFiling();
        new CreditWSUtil_LexisNexisBridger.IIDIAddress();
        new CreditWSUtil_LexisNexisBridger.IIDIDataSource();
        new CreditWSUtil_LexisNexisBridger.IIDIDataSourceVerification();
        new CreditWSUtil_LexisNexisBridger.IIDIDate();
        new CreditWSUtil_LexisNexisBridger.IIDIException_x();
        new CreditWSUtil_LexisNexisBridger.IIDIHeader();
        new CreditWSUtil_LexisNexisBridger.IIDIIdentification();
        new CreditWSUtil_LexisNexisBridger.IIDIInput();
        new CreditWSUtil_LexisNexisBridger.IIDInput();
        new CreditWSUtil_LexisNexisBridger.IIDIPassport();
        new CreditWSUtil_LexisNexisBridger.IIDIResult();
        new CreditWSUtil_LexisNexisBridger.IIDIResultCriteriaIndividual();
        new CreditWSUtil_LexisNexisBridger.IIDIRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.IIDIVerificationIndex();
        new CreditWSUtil_LexisNexisBridger.IIDIVerificationResult();
        new CreditWSUtil_LexisNexisBridger.IIDRedFlag();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaBusiness();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaIndividual();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.IIDReversePhone();
        new CreditWSUtil_LexisNexisBridger.IIDRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.IIDSSNInfo();
        new CreditWSUtil_LexisNexisBridger.IIDVerificationIndicators();
        new CreditWSUtil_LexisNexisBridger.IIDWatchlist();
        new CreditWSUtil_LexisNexisBridger.IndexList_element();
        new CreditWSUtil_LexisNexisBridger.IndexListResponse_element();
        new CreditWSUtil_LexisNexisBridger.InputAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.InputAddress();
        new CreditWSUtil_LexisNexisBridger.InputBasicID();
        new CreditWSUtil_LexisNexisBridger.InputEFT();
        new CreditWSUtil_LexisNexisBridger.InputEntity();
        new CreditWSUtil_LexisNexisBridger.InputID();
        new CreditWSUtil_LexisNexisBridger.InputName();
        new CreditWSUtil_LexisNexisBridger.InputPhone();
        new CreditWSUtil_LexisNexisBridger.InputRecord();
        new CreditWSUtil_LexisNexisBridger.InputText();
        new CreditWSUtil_LexisNexisBridger.InstantIDBusinessResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDConfiguration();
        new CreditWSUtil_LexisNexisBridger.InstantIDIndividualResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlConfiguration();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlIndividualResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlResultCriteria();
        new CreditWSUtil_LexisNexisBridger.InstantIDResultCriteria();
        new CreditWSUtil_LexisNexisBridger.ListCriteria();
        new CreditWSUtil_LexisNexisBridger.ListInfo();
        new CreditWSUtil_LexisNexisBridger.ListRecord();
        new CreditWSUtil_LexisNexisBridger.ListRecordCriteria();
        new CreditWSUtil_LexisNexisBridger.MergeDuplicates_element();
        new CreditWSUtil_LexisNexisBridger.MergeDuplicatesResponse_element();
        new CreditWSUtil_LexisNexisBridger.OFACInstitutionInfo();
        new CreditWSUtil_LexisNexisBridger.OFACReportInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedACH();
        new CreditWSUtil_LexisNexisBridger.ParsedACHAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedACHAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedACHField();
        new CreditWSUtil_LexisNexisBridger.ParsedACHID();
        new CreditWSUtil_LexisNexisBridger.ParsedACHNote();
        new CreditWSUtil_LexisNexisBridger.ParsedACHParty();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwire();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAmount();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireField();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireID();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireNote();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireParty();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwirePhone();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022AdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Address();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Field();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022ID();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Note();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Party();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Phone();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFT();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAmount();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTField();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTID();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTNote();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTOriginalMessage();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTParty();
        new CreditWSUtil_LexisNexisBridger.RecordState();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaAccount();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaEFT();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaRecordState();
        new CreditWSUtil_LexisNexisBridger.ResultError();
        new CreditWSUtil_LexisNexisBridger.ResultInfo();
        new CreditWSUtil_LexisNexisBridger.ResultRecord();
        new CreditWSUtil_LexisNexisBridger.ResultRecordDetails();
        new CreditWSUtil_LexisNexisBridger.ResultsCriteria();
        new CreditWSUtil_LexisNexisBridger.RunInfo();
        new CreditWSUtil_LexisNexisBridger.RunsCriteria();
        new CreditWSUtil_LexisNexisBridger.Search_x_element();
        new CreditWSUtil_LexisNexisBridger.SearchConfiguration();
        new CreditWSUtil_LexisNexisBridger.SearchInput();
        new CreditWSUtil_LexisNexisBridger.SearchListRecords_element();
        new CreditWSUtil_LexisNexisBridger.SearchListRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchLists_element();
        new CreditWSUtil_LexisNexisBridger.SearchListsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchRecordResults();
        new CreditWSUtil_LexisNexisBridger.SearchResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.SearchResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchResults();
        new CreditWSUtil_LexisNexisBridger.SearchRuns_element();
        new CreditWSUtil_LexisNexisBridger.SearchRunsResponse_element();
        new CreditWSUtil_LexisNexisBridger.ServiceFault();
        new CreditWSUtil_LexisNexisBridger.SetRecordState_element();
        new CreditWSUtil_LexisNexisBridger.SetRecordStateResponse_element();
        new CreditWSUtil_LexisNexisBridger.Time_x();
        new CreditWSUtil_LexisNexisBridger.UpdateList_element();
        new CreditWSUtil_LexisNexisBridger.UpdateListResponse_element();
        new CreditWSUtil_LexisNexisBridger.UpdateRecord_element();
        new CreditWSUtil_LexisNexisBridger.UpdateRecordResponse_element();
        new CreditWSUtil_LexisNexisBridger.WatchlistAutomaticFalsePositiveRules();
        new CreditWSUtil_LexisNexisBridger.WatchlistConfiguration();
        new CreditWSUtil_LexisNexisBridger.WatchlistDataFile();
        new CreditWSUtil_LexisNexisBridger.WatchlistEFTMatchOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistGeneralOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchDispositionRules();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchState();
        new CreditWSUtil_LexisNexisBridger.WatchlistPaymentScreeningOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistResultCriteria();
        new CreditWSUtil_LexisNexisBridger.WatchlistResults();
        new CreditWSUtil_LexisNexisBridger.WLAddressMatch();
        new CreditWSUtil_LexisNexisBridger.WLCitizenshipMatch();
        new CreditWSUtil_LexisNexisBridger.WLCountryDetails();
        new CreditWSUtil_LexisNexisBridger.WLDOBMatch();
        new CreditWSUtil_LexisNexisBridger.WLEntityDetails();
        new CreditWSUtil_LexisNexisBridger.WLIDMatch();
        new CreditWSUtil_LexisNexisBridger.WLMatch();
        new CreditWSUtil_LexisNexisBridger.WLMatchConflicts();
        new CreditWSUtil_LexisNexisBridger.WLMatchFile();
        new CreditWSUtil_LexisNexisBridger.WLMatchSummary();
        new CreditWSUtil_LexisNexisBridger.WLMatchSummaryItem();
        new CreditWSUtil_LexisNexisBridger.WLPhoneMatch();

        Test.stopTest();

    }

    static testMethod void testForteCallout() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new ForteCalloutMock());

        CreditWS_Forte.ForteRequest request = new CreditWS_Forte.ForteRequest();

        request.action = 'verify';
        request.authorization_amount = 1;
        request.echeck = new CreditWS_Forte.ForteECheck();
        request.echeck.account_number = '11111111';
        request.echeck.routing_number = '222222222';

        CreditWS_Forte.ForteResponse response = CreditWS_Forte.verifyBankAccount(request);

        System.assert((response.transaction_id).equalsIgnoreCase('trn_520ed196-e275-4a93-ab6a-3e601c4bf35f'));
        System.assert((response.location_id).equalsIgnoreCase('loc_167635'));
        System.assert(response.authorization_amount == 1);
        System.assert((response.entered_by).equalsIgnoreCase('c28e0b656a521c2f17f559618d85f1be'));

        System.assert((response.echeck.masked_account_number).equalsIgnoreCase('****1111'));
        System.assert((response.echeck.last_4_account_number).equalsIgnoreCase('1111'));
        System.assert((response.echeck.routing_number).equalsIgnoreCase('222222222'));

        System.assert((response.response.environment).equalsIgnoreCase('sandbox'));
        System.assert((response.response.response_type).equalsIgnoreCase('D'));
        System.assert((response.response.response_code).equalsIgnoreCase('U19'));
        System.assert((response.response.response_desc).equalsIgnoreCase('INVALID TRN'));

        Test.stopTest();

    }

    static testMethod void testDNBCustomModelCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, DUNS__c, Credit_Line_Requested__c FROM OnlineApplication__c LIMIT 1];

        if (onlineApplications.size() == 1) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_DNB.DNBOTRModelRequest dnbOTRModelRequest = new CreditWS_DNB.DNBOTRModelRequest();
            dnbOTRModelRequest.DnB_DUNS_Number = onlineApplications[0].DUNS__c;

            CreditWS_DNB.DNBOTRModelResponse dnbOTRModelResponse = CreditWS_DNB.getOTRScore(dnbOTRModelRequest);

            Test.stopTest();

        }

    }

    static testMethod void testDNBCACustomModelCallout() {

        List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, DUNS_Number__c, Credit_Line_Requested__c FROM CP_Application_Request__c LIMIT 1];

        if (cpApplicationRequests.size() == 1) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_DNB.DNBCAModelRequest dnbCAModelRequest = new CreditWS_DNB.DNBCAModelRequest();
            dnbCAModelRequest.DnB_DUNS_Number = cpApplicationRequests[0].DUNS_Number__c;

            CreditWS_DNB.DNBCAModelResponse dnbCAModelResponse = CreditWS_DNB.getCAScore(dnbCAModelRequest);

            Test.stopTest();

        }

    }

    //TODO DELETE ME WHEN CA CUSTOM MODEL RELEASED
//    static testMethod void testDNBSBRICallout() {
//
//        List<OnlineApplication__c> onlineApplications = [
//                SELECT Id, DUNS__c, Legal_Business_Name__c,Business_Street_Address__c, City__c, State__c, Zip_code__c
//                FROM OnlineApplication__c
//        ];
//
//        if (onlineApplications.size() > 0) {
//
//            Test.startTest();
//
//            TestUtils.enable_isRunningTest = true;
//
//            CreditWS_DNB.DNBSBRIRequest dnbSBRIRequest = new CreditWS_DNB.DNBSBRIRequest();
//            dnbSBRIRequest.DnB_DUNS_Number = onlineApplications[0].DUNS__c;
//
//            CreditWS_DNB.DNBSBRIResponse dnbSBRIResponse = CreditWS_DNB.getSBRIScore(dnbSBRIRequest);
//
//            Test.stopTest();
//
//        }
//
//    }
    //TODO DELETE ME WHEN CA CUSTOM MODEL RELEASED
//    static testMethod void testDNBSBRIWSDL() {
//
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORNAMEGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_TOTALS();
//        new CreditWSUtil_DNBSBRI.SBRIResponse();
//        new CreditWSUtil_DNBSBRI.USDS_FEIN_CTR();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORACCTGRP2();
//        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_SIC_NAICS_SECT();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTSUMM2();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHIST2();
//        new CreditWSUtil_DNBSBRI.customProduct8_Response();
//        new CreditWSUtil_DNBSBRI.SBRI_MISC();
//        new CreditWSUtil_DNBSBRI.SECTION2();
//        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_SCDY_SIC_GRP();
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTOR2();
//        new CreditWSUtil_DNBSBRI.USDS_SIC_NAICS_SECT();
//        new CreditWSUtil_DNBSBRI.DGX();
//        new CreditWSUtil_DNBSBRI.SBRI_TOTALS();
//        new CreditWSUtil_DNBSBRI.STATUS4();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILTOTGRP();
//        new CreditWSUtil_DNBSBRI.STATUS3();
//        new CreditWSUtil_DNBSBRI.STATUS2();
//        new CreditWSUtil_DNBSBRI.Immediate_Delivery();
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORACCTGRP2();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTSUMM2();
//        new CreditWSUtil_DNBSBRI.Orders();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHISTTOT2();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORACCTGRP();
//        new CreditWSUtil_DNBSBRI.SBRI_MISCGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILTOTGRP2();
//        new CreditWSUtil_DNBSBRI.prodOrderRequest_2();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTEXPR2();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILTOTGRP2();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILS();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILS2();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTHISTTOT();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHISTTOT();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTHIST();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_TOTALS2();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_MISCGRP2();
//        new CreditWSUtil_DNBSBRI.AdditionalFields();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTGRP2();
//        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_PAYD_NORM_QRTL_GRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfstring();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOT2();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTTOTGRP2();
//        new CreditWSUtil_DNBSBRI.Investigation();
//        new CreditWSUtil_DNBSBRI.socCode();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTGRP();
//        new CreditWSUtil_DNBSBRI.SONRS2();
//        new CreditWSUtil_DNBSBRI.SBRI_IDENTIFICATION2();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTGRP();
//        new CreditWSUtil_DNBSBRI.DGX2();
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORNAMEGRP2();
//        new CreditWSUtil_DNBSBRI.SONRS();
//        new CreditWSUtil_DNBSBRI.SBRI_SBRIDATA();
//        new CreditWSUtil_DNBSBRI.ArrayOfAdditionalFields();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORNAMEGRP2();
//        new CreditWSUtil_DNBSBRI.CREDITMSGSRSV22();
//        new CreditWSUtil_DNBSBRI.STATUS();
//        new CreditWSUtil_DNBSBRI.DATATRNRS2();
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTOR();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOT();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTHISTTOT2();
//        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTTOTGRP();
//        new CreditWSUtil_DNBSBRI.SBRI_TOTALS2();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTGRP2();
//        new CreditWSUtil_DNBSBRI.DATARS();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHIST();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTEXPR();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTSUMM();
//        new CreditWSUtil_DNBSBRI.SBRI_MISC2();
//        new CreditWSUtil_DNBSBRI.USDS_PAYD_GRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_FEIN_CTR();
//        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORACCTGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTTOTGRP2();
//        new CreditWSUtil_DNBSBRI.ws_SBRIResponse();
//        new CreditWSUtil_DNBSBRI.USDS_PAYD_NORM_QRTL_GRP();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTSUMM();
//        new CreditWSUtil_DNBSBRI.SBRI_IDENTIFICATION();
//        new CreditWSUtil_DNBSBRI.USDS_SCDY_SIC_GRP();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILSGRP();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILTOTGRP();
//        new CreditWSUtil_DNBSBRI.ws_CustomProduct8();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTTOTGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_PAYD_GRP();
//        new CreditWSUtil_DNBSBRI.CREDITMSGSRSV2();
//        new CreditWSUtil_DNBSBRI.SIGNONMSGSRSV12();
//        new CreditWSUtil_DNBSBRI.NotificationDelivery();
//        new CreditWSUtil_DNBSBRI.SBRI_MISCGRP2();
//        new CreditWSUtil_DNBSBRI.ws_SBRI();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILSGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILSGRP2();
//        new CreditWSUtil_DNBSBRI.DATATRNRS();
//        new CreditWSUtil_DNBSBRI.SBRI_SBRIDATA2();
//        new CreditWSUtil_DNBSBRI.InvestigationDelivery();
//        new CreditWSUtil_DNBSBRI.SIGNONMSGSRSV1();
//        new CreditWSUtil_DNBSBRI.DATARS2();
//        new CreditWSUtil_DNBSBRI.ws_CustomProduct8Response();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORNAMEGRP();
//        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_MISCGRP();
//        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILSGRP2();
//        new CreditWSUtil_DNBSBRI.SECTION();
//        new CreditWSUtil_DNBSBRI.SBRI_PMTHIST2();
//        new CreditWSUtil_DNBSBRI.DNB_WebServices_Providers_OrderAndInvestigations_OtherProducts_wsp_SBRI_V6_Port();
//
//    }

    static testMethod void testExperianCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, Type_of_Business__c, Contact_First_Name__c, Contact_Last_Name__c, AO_Home_Phone_Number__c, AO_Address__c, AO_City__c, AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Test.setMock(HttpCalloutMock.class, new ExperianCalloutMock());

            CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();

            if (onlineApplications[0].Type_of_Business__c.equals('Proprietorship') || onlineApplications[0].Type_of_Business__c.equals('Partnership')) {
                experianRequest.accountPurposeCode = '10';
            } else {
                experianRequest.accountPurposeCode = '5J';
            }

            experianRequest.socialSecurityNumber = onlineApplications[0].AO_Social_Security_Number__c;
            experianRequest.contactFirstName = onlineApplications[0].Contact_First_Name__c;
            experianRequest.contactLastName = onlineApplications[0].Contact_Last_Name__c;
            experianRequest.address = onlineApplications[0].AO_Address__c;
            experianRequest.city = onlineApplications[0].AO_City__c;
            experianRequest.state = onlineApplications[0].AO_State__c;
            experianRequest.zipCode = onlineApplications[0].AO_Zip_Code__c;
            experianRequest.phone = onlineApplications[0].AO_Home_Phone_Number__c;
            experianRequest.dateOfBirthMonth = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
            experianRequest.dateOfBirthDay = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
            experianRequest.dateOfBirthYear = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.year());

            CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));

            Test.stopTest();

        }

    }

    static testMethod void testExperianParser() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new ExperianParserCalloutMock());

        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.roadtonowhere.com');
        request.setMethod('POST');

        Http experianMock = new Http();

        HttpResponse response = experianMock.send(request);

        CreditWS_Experian.parseResponse(response);

        Test.stopTest();

    }

    static testMethod void testEquifaxCallout() {

        List<OnlineApplication__c> onlineApplications = [SELECT Id, Type_of_Business__c, Contact_First_Name__c, Contact_Last_Name__c, AO_Home_Phone_Number__c, AO_Address__c, AO_City__c, AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c FROM OnlineApplication__c];

        if (onlineApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Test.setMock(HttpCalloutMock.class, new EquifaxCalloutMock());

            CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();

            equifaxRequest.socialInsuranceNumber = onlineApplications[0].AO_Social_Security_Number__c;
            equifaxRequest.firstName = onlineApplications[0].Contact_First_Name__c;
            equifaxRequest.lastName = onlineApplications[0].Contact_Last_Name__c;
            equifaxRequest.address = onlineApplications[0].AO_Address__c;
            equifaxRequest.city = onlineApplications[0].AO_City__c;
            equifaxRequest.province = onlineApplications[0].AO_State__c;
            equifaxRequest.postalCode = onlineApplications[0].AO_Zip_Code__c;
            equifaxRequest.phone = onlineApplications[0].AO_Home_Phone_Number__c;
            equifaxRequest.dateOfBirthMonth = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
            equifaxRequest.dateOfBirthDay = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
            equifaxRequest.dateOfBirthYear = String.valueOf(onlineApplications[0].AO_Date_of_Birth__c.year());

            CreditWS_Equifax.EquifaxResponse equifaxResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));

            Test.stopTest();

        }

    }

    static testMethod void testEquifaxParser() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new EquifaxParserCalloutMock());

        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.roadtonowhere.com');
        request.setMethod('POST');

        Http equifaxMock = new Http();

        HttpResponse response = equifaxMock.send(request);
        CreditWS_Equifax.EquifaxResponse equifaxResponse = new CreditWS_Equifax.EquifaxResponse();

        CreditWS_Equifax.parseResponse(response, equifaxResponse);

        Test.stopTest();

    }

    public class CalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(401);
            return retVal;
        }
    }

    public class ThreatMetrixCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('review_status=passed');
            return retVal;
        }
    }

    public class ForteCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{"transaction_id":"trn_520ed196-e275-4a93-ab6a-3e601c4bf35f","location_id":"loc_167635","action":"verify","authorization_amount":1.00,"entered_by":"c28e0b656a521c2f17f559618d85f1be","echeck":{"masked_account_number":"****1111","last_4_account_number":"1111","routing_number":"222222222"},"response":{"environment":"sandbox","response_type":"D","response_code":"U19","response_desc":"INVALID TRN"}}');
            return retVal;
        }
    }

    public class ExperianCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('https://www.experian.com/stuff/and/things');
            return retVal;
        }
    }

    public class ExperianParserCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            StaticResource xmlResponse = [SELECT Id, Body FROM StaticResource WHERE Name = 'ExperianTestResponse'];

            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody(xmlResponse.Body.toString());
            return retVal;
        }
    }

    public class EquifaxCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('https://www.experian.com/stuff/and/things');
            return retVal;
        }
    }

    public class EquifaxParserCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            StaticResource xmlResponse = [SELECT Id, Body FROM StaticResource WHERE Name = 'ExperianTestResponse'];

            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody(xmlResponse.Body.toString());
            return retVal;
        }
    }

}