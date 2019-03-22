@isTest
public with sharing class CPBOCATest {

    public static Program__c setupProgram() {

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

        Campaign_Pricing__c campaignPricing = new Campaign_Pricing__c();
        campaignPricing.Name = 'test';
        campaignPricing.contract_margin__c = 'Y';
        campaignPricing.penalty_margin__c = 'Y';
        campaignPricing.days_to_pay__c = 21;
        campaignPricing.prime_rate__c = 3.25;
        campaignPricing.prime_rate_effective_date__c = Date.today();
        campaignPricing.late_fee_type__c = 'P';
        campaignPricing.return_payment_fee__c = 49.99;
        campaignPricing.over_limit_fee__c = 39.99;
        campaignPricing.paper_delivery_fee__c = 5.00;
        campaignPricing.penalty_rate_ceiling__c = 999.99;
        campaignPricing.minimum_payment_percentage__c = 29.99;
        campaignPricing.Peoplesoft_rel_code__c = '012011';
        campaignPricing.coup_code__c = 'TEST1';
        campaignPricing.is_Active__c = true;
        campaignPricing.Coupon_Status__c = 'valid';
        campaignPricing.risk_code__c = 'No';
        campaignPricing.nbr_billing_cyles__c = '1';
        campaignPricing.contract_rate_pct__c = 10.15;
        campaignPricing.fixed_late_fee__c = 0.00;
        campaignPricing.pct_late_fee__c = 2.49;
        campaignPricing.pen_rate_pct__c = 27.34;
        campaignPricing.promo_periods__c = 1.0;
        campaignPricing.promotional_rate__c = 8.17;
        campaignPricing.CurrencyIsoCode = 'USD';

        insert campaignPricing;


        Program__c program = new Program__c();

        program.Name = 'TestBOCA';
        program.Peoplesoft_rel_code__c = '012011';
        program.Form_Template__c = 'WexBOCA';
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

        return program;

    }

    static testMethod void CPBOCATest() {

        User CreditUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.debug('Found Credit User: ' + CreditUser.Id);

        System.runAs(CreditUser) {

            System.debug('### ' + Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate Payments').getRecordTypeId());

            Program__c program = setupProgram();

            Test.startTest();

            // Test with no program passed in
            PageReference cpBOCA = Page.CPBOCA;

            TestUtils.enable_isRunningTest = true;

            Test.setCurrentPage(cpBOCA);

            CPBOCAController cpbocaController = new CPBOCAController();

            PageReference errorPage = cpbocaController.init();

            System.assert(errorPage != null);

            // Publish the BOCA
            program.BOCA_Type__c = 'Fuel Card';
            program.Publish_BOCA__c = true;
            upsert program;

            // Test with non-existant BOCA to Prospect
            cpBOCA = Page.WexBOCA;
            cpBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            cpBOCA.getParameters().put('priority', 'true');
            cpBOCA.getParameters().put('customer', '0000');

            Test.setCurrentPage(cpBOCA);

            errorPage = cpbocaController.init();

            System.assert(errorPage != null);

            // Test with a published BOCA
            cpBOCA = Page.CPBOCA;
            cpBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            cpBOCA.getParameters().put('pg', 'a');
            cpBOCA.getParameters().put('cc', 'TEST1');
            cpBOCA.getParameters().put('lang', 'en_us');
            cpBOCA.getParameters().put('salescode', 'TEST1');
            cpBOCA.getParameters().put('leadId', '0');

            Test.setCurrentPage(cpBOCA);

            cpbocaController.init();

            System.assert(cpbocaController.isPartial == false);
            System.assert(cpbocaController.isPreview == false);
            System.assert(cpbocaController.partialCustomer == null);
            System.assert(cpbocaController.brandingLogo != null);
            System.assert(cpbocaController.brandingCard != null);
            System.assert(cpbocaController.leadIdParameter != null);
            System.assert(cpbocaController.passedInLead == null);
            System.assert(cpbocaController.disclaimer != null);
            System.assert(cpbocaController.termsAndConditions != null);

            cpbocaController.creditApp.Company_Legal_Name__c = 'Test';
            cpbocaController.creditApp.Email__c = 'testBoca@wexinc.com';
            cpbocaController.creditApp.First_Name__c = 'Test';
            cpbocaController.creditApp.Last_Name__c = 'Test';
            cpbocaController.creditApp.Business_Phone__c = '207555555';
            cpbocaController.creditApp.Legal_Structure__c = 'Partnership';
            cpbocaController.creditApp.Doing_Business_As__c = 'Test Company';
            cpbocaController.creditApp.Years_in_Business__c = '22';

            cpbocaController.createLead();

            cpbocaController.creditApp.Physical_Address_Line_1__c = '123 Darling Ave';
            cpbocaController.creditApp.Physical_Address_Line_2__c = 'Suite 2';
            cpbocaController.creditApp.Physical_City__c = 'South Portland';
            cpbocaController.creditApp.Physical_State_Province__c = 'ME';
            cpbocaController.creditApp.Physical_Postal_Code__c = '04106';

            cpbocaController.creditApp.Legal_Structure__c = 'Corporation';
            cpbocaController.creditApp.Taxpayer_ID__c = '000000000';

            cpbocaController.creditApp.Guarantor_Social_Security_Number__c = '000-00-0000';
            cpbocaController.creditApp.Guarantor_Date_of_Birth__c = Date.parse('1/1/1986');
            cpbocaController.creditApp.Guarantor_Residential_Phone__c = '2075555555';
            cpbocaController.creditApp.Guarantor_Residential_Address__c = '123 Darling Ave';
            cpbocaController.creditApp.Guarantor_Residential_City__c = 'South Portand';
            cpbocaController.creditApp.Guarantor_State_Province__c = 'ME';
            cpbocaController.creditApp.Guarantor_Residential_Postal_Code__c = '04106';
            cpbocaController.creditApp.Guarantor_Country__c = 'US';

            cpbocaController.submitApplication();

            System.assert(cpbocaController.creditApp.Id != null);

            System.assert(cpbocaController.currentPageName != null);
            System.assert(cpbocaController.userSessionId != null);
            System.assert(cpbocaController.locationCode == null);
            System.assert(cpbocaController.pgParameter == 'a');
            System.assert(cpbocaController.groupCode == null);
            System.assert(cpbocaController.isBankInfoNeeded == false);
            System.assert(cpbocaController.defaultBrandingUtility != null);
            System.assert(cpbocaController.statementAndReportDeliveryOptions != null);
            System.assert(cpbocaController.isPGRequired == false);

            cpbocaController.setPaymentDefaults();

            cpBOCA = Page.CPBOCA;
            cpBOCA.getParameters().put('pgm', program.Brand_Short_Name__c);
            cpBOCA.getParameters().put('customer', cpbocaController.creditApp.Id);
            cpBOCA.getParameters().put('priority', 'true');

            Test.setCurrentPage(cpBOCA);

            errorPage = cpbocaController.init();

            System.assert(errorPage != null);

            PageReference cpBOCAConfirmation = Page.CPBOCAConfirmation;
            cpBOCAConfirmation.getParameters().put('pgm', program.Brand_Short_Name__c);
            cpBOCAConfirmation.getParameters().put('id', cpbocaController.creditApp.Id);
            cpBOCAConfirmation.getParameters().put('lang', 'en_us');

            Test.setCurrentPage(cpBOCAConfirmation);

            CPBOCAConfirmationController cpbocaConfirmationController = new CPBOCAConfirmationController();

            cpbocaConfirmationController.init();

            System.assert(cpbocaConfirmationController.brandingLogo != null);
            System.assert(cpbocaConfirmationController.brandingCard != null);

            Test.stopTest();

        }

    }

}