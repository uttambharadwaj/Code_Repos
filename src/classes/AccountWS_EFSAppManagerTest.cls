@isTest
public class AccountWS_EFSAppManagerTest {

    @testSetup
    static void setupUser() {

        UtilityTestLoader.setAutomation(false);

        EFS_App_Manager_Integration__c efsAppManagerIntegration = new EFS_App_Manager_Integration__c();

        efsAppManagerIntegration.Endpoint__c = 'Test';
        efsAppManagerIntegration.Username__c = 'Test';
        efsAppManagerIntegration.Password__c = 'Test';

        insert efsAppManagerIntegration;

        Account offerAccount = new Account();
        offerAccount.Name ='TestAccount-01';

        insert offerAccount;

        OnlineApplicationOffer__c onlineApplicationOffer = new OnlineApplicationOffer__c();
        onlineApplicationOffer.Name = 'TestOffer-01';
        onlineApplicationOffer.ATM_Use__c = true;
        onlineApplicationOffer.Application_Title__c = 'TestTitle';
        onlineApplicationOffer.Cash_Limit__c = 1;
        onlineApplicationOffer.Complete_Later_Text__c = 'Test';
        onlineApplicationOffer.BOCA_Default_Offer__c = true;
        onlineApplicationOffer.Daily_Cash_Limit__c = 1;
        onlineApplicationOffer.Daily_MC_Limit__c = 1;
        onlineApplicationOffer.Disclosure__c = 'Test';
        onlineApplicationOffer.EchoSign_User_Email__c = 'test@test.com';
        onlineApplicationOffer.Funding__c = 'Parent Funded';
        onlineApplicationOffer.Limit_Method__c = 'Credit Limit';
        // OTRONBOARD-29
        //onlineApplicationOffer.Notice_Type_1__c = 'Percent';
        //onlineApplicationOffer.Notice_Type_1_Value__c = 10;
        //onlineApplicationOffer.Notice_Type_2__c = 'Percent';
        //onlineApplicationOffer.Notice_Type_2_Value__c = 5;
        onlineApplicationOffer.MC_Limit__c = 1;
        // OTRONBOARD-33
        //onlineApplicationOffer.Mcode_Monthly_Account_Fee__c = true;
        //onlineApplicationOffer.Mcode_Monthly_Account_Fee_Value__c = 0;
        //onlineApplicationOffer.Monthly_Account_Fee__c = true;
        //onlineApplicationOffer.Monthly_Account_Fee_Value__c = 0;
        onlineApplicationOffer.PSR_ATM_Limit__c = 1.00;
        onlineApplicationOffer.PSR_Card_Fee__c = 1.00;
        onlineApplicationOffer.PSR_Fuel_Cash__c = 1.00;
        onlineApplicationOffer.PSR_Marketing_Fee__c = 1.00;
        onlineApplicationOffer.PSR_Money_Code__c = 1.00;
        onlineApplicationOffer.PSR_Scales__c = 1.00;
        onlineApplicationOffer.Trans_Limit__c = 1;
        onlineApplicationOffer.Terms_and_Conditions_Version__c = 'TestVersion-01';
        onlineApplicationOffer.Cards_per_1_Requested__c = 1;
        onlineApplicationOffer.Card_Shipping_Method__c = '1';
        onlineApplicationOffer.Card_Style__c = '1';
        onlineApplicationOffer.Card_Type__c = '1';
        onlineApplicationOffer.Issuer_ID__c = '1';
        onlineApplicationOffer.Issuer_Group__c = '1';
        onlineApplicationOffer.Parent_Carrier_ID__c = '1';
        onlineApplicationOffer.Card_Order_Type__c = '1';
        onlineApplicationOffer.Statement_Type__c = '1';
        onlineApplicationOffer.Customer_Type__c = '1';

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
        onlineApplication.Card_Shipping_Country__c ='US';
        onlineApplication.Card_Shipping_First_Name__c ='George';
        onlineApplication.Card_Shipping_City__c ='Nashvile';
        onlineApplication.Card_Shipping_Postal_Code__c ='37214';
        onlineApplication.Card_Shipping_Address_Line_1__c ='123 Anywhere St';
        onlineApplication.Card_Shipping_Last_Name__c ='Smiley';
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



        insert onlineApplication;

        OnlineApplicationDriverSetup__c driverSetup = new OnlineApplicationDriverSetup__c();

        driverSetup.Driver_Name__c = 'Test McTesterson';
        driverSetup.Driver_ID__c = '12345';
        driverSetup.Online_Application__c = onlineApplication.Id;

        insert driverSetup;

        OnlineApplicationUnitNumber__c unitNumber = new OnlineApplicationUnitNumber__c();

        unitNumber.Name = '123456789';
        unitNumber.Online_Application__c = onlineApplication.Id;

        insert unitNumber;

    }

    static testMethod void testAppManagerIntegrationFuture() {

        Test.startTest();

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c LIMIT 1];

        if(onlineApplications.size() > 0) {

            Test.setMock(HttpCalloutMock.class, new CalloutMock());

            AccountWS_EFSAppManager.integrateOnlineApplication_Future(onlineApplications[0].Id);

        }

        Test.stopTest();

    }

    static testMethod void testAppManagerIntegrationButton() {

        Test.startTest();

        List<OnlineApplication__c> onlineApplications = [SELECT Id FROM OnlineApplication__c LIMIT 1];

        if(onlineApplications.size() > 0) {

            Test.setMock(HttpCalloutMock.class, new CalloutMock());

            AccountWS_EFSAppManager.testIntegrationFromButton(onlineApplications[0].Id);

        }

        Test.stopTest();

    }

    public class CalloutMock implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{"status": "SUCCESS" , "clientId": "xxx"}');
            return retVal;
        }
    }

}