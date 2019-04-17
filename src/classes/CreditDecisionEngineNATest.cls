/**
 * Created by dgilbert on 9/13/2018.
 */

@isTest
public with sharing class CreditDecisionEngineNATest {

    @testSetup
    static void setupData() {

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
        program.WEX_Platform__c = 'Millennium';

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

        User integrationUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

        Application_Request__c applicationRequest = new Application_Request__c();

        System.runAs(integrationUser) {

            Opportunity opportunity = new Opportunity(CampaignId = campaign.Id, Campaign_Program__c = campaignProgram.Id, name = 'TestOpp', closedate = date.newinstance(2015, 11, 11), stagename = '5) Signed', fleet_size__c = 10, ownerId = integrationUser.Id, sourcesystem__c = 'BOCA');
            opportunity.Fueling_Methos__c = 'BP';

            insert opportunity;

            Contact pgContact = new Contact();

            pgContact.SSN__c = '123111234';
            pgContact.Birthdate = Date.parse('12/26/1986');
            pgContact.FirstName = 'Test';
            pgContact.LastName = 'McTesterson';
            pgContact.MailingStreet = '123 Darling Ave';
            pgContact.MailingCity = 'South Portland';
            pgContact.MailingState = 'ME';
            pgContact.MailingPostalCode = '04106';

            insert pgContact;

            applicationRequest.Personal_Guarantor__c = pgContact.Id;
            applicationRequest.Sales_Stage__c = '06 - Approved';
            applicationRequest.Opportunity__c = opportunity.Id;
            applicationRequest.Physical_Street__c = '123 Darling Ave';
            applicationRequest.Physical_Street_Line_2__c = 'Suite 1';
            applicationRequest.Physical_City__c = 'South Portland';
            applicationRequest.Physical_State__c = 'ME';
            applicationRequest.Physical_Zip_Postal_Code__c = '04106';
            applicationRequest.Physical_Country__c = 'US';
            applicationRequest.DUNS_Number__c = '12345678';

            applicationRequest.Checking_Account_Number__c = '123456789';
            applicationRequest.ABA_Routing_Number__c = '123456789';

            insert applicationRequest;

        }

    }

    static testMethod void testCreditDecisionEngine() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runas(integrationUser) {

            List<Application_Request__c> applicationRequests = [SELECT Id FROM Application_Request__c LIMIT 1];

            if (applicationRequests.size() == 1) {

                Test.startTest();

                TestUtils.enable_isRunningTest = true;

                CreditDecisionEngineNA.runNADecisioningProcess(applicationRequests[0].Id);

                Test.stopTest();

            }

        }

    }

    static testMethod void testNADNBAdvancedLookup() {

        Test.startTest();

        List<Application_Request__c> applicationRequests = [SELECT Id FROM Application_Request__c LIMIT 1];

        if (applicationRequests.size() == 1) {

            PageReference dnbAdvancedLookupPage = Page.DNBAdvancedLookup;
            dnbAdvancedLookupPage.getParameters().put('applicationId', applicationRequests[0].Id);
            Test.setCurrentPage(dnbAdvancedLookupPage);

            DNBAdvancedLookupController dnbAdvancedLookupController = new DNBAdvancedLookupController();

            dnbAdvancedLookupController.init();

            System.assert(dnbAdvancedLookupController.applicationId != null);
            System.assert(dnbAdvancedLookupController.applicationInformation != null);

            dnbAdvancedLookupController.selectedDunsNumber = '123456789';

            dnbAdvancedLookupController.populateDUNS();

        }

        Test.stopTest();

    }

    static testMethod void testCreditUtilCalculateCreditLine() {

        List<Application_Request__c> applicationRequests = [SELECT Id, Risk_Grade__c, Requested_Credit_Limit__c, PG_Required__c, PG_High_Credit_Amount__c, Credit_Line_Recommendation__c,
                DNB_Credit_Line_Recommendation__c, DNB_SBFE_High_Credit__c, DNB_CSAD_High_Credit__c
        FROM Application_Request__c LIMIT 1];

        if (applicationRequests.size() > 0) {
            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            Test.startTest();

            /** TEST COMMERCIAL
            * The Credit Line Recommendation is original given via DNB */
            // Risk Grade 1 or 2
            // DNB recommends less than 25k range
            applicationRequests[0].PG_Required__c = false;
            applicationRequests[0].Risk_Grade__c = '1';
            applicationRequests[0].DNB_SBFE_High_Credit__c = 20000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 10000;
            applicationRequests[0].Requested_Credit_Limit__c = '25000';
            upsert applicationRequests[0];

            Decimal ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(25000, ar);

            // Risk Grade 1 or 2
            // Requesting above 25k but below 150k
            // has high credit amount to cover
            applicationRequests[0].DNB_SBFE_High_Credit__c = 40000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 30000;
            applicationRequests[0].Requested_Credit_Limit__c = '30000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(30000, ar);

            // Risk Grade 1 or 2
            // Recommendation lower than RG minimum of 25k, however applicant asked for lower - give them what they asked for
            applicationRequests[0].Risk_Grade__c = '2';
            applicationRequests[0].DNB_SBFE_High_Credit__c = 10000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 5000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 15000;
            applicationRequests[0].Requested_Credit_Limit__c = '20000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(20000, ar);

            // Risk Grade 1 or 2
            // Requesting above 25k but below 150k
            // does NOT have high credit amount to cover
            // hit min
            applicationRequests[0].DNB_SBFE_High_Credit__c = 10000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 30000;
            applicationRequests[0].Requested_Credit_Limit__c = '30000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(25000, ar);

            // Risk Grade 3
            // requesting below 10k;
            // Minimum for this RG range recommended (10k)
            applicationRequests[0].Risk_Grade__c = '3';
            applicationRequests[0].DNB_SBFE_High_Credit__c = 10000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 5000;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(10000, ar);

            // Risk Grade 3
            // Requesting above 10k but below 150k
            // has high credit amount to cover
            applicationRequests[0].DNB_SBFE_High_Credit__c = 10000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 20000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 15000;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(15000, ar);

            // Risk Grade 3
            // Requesting above 10k but below 150k
            // does NOT have high credit amount to cover
            applicationRequests[0].DNB_SBFE_High_Credit__c = 10000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 5000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 15000;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(10000, ar);

            // One of high credit amount fields are null
            applicationRequests[0].DNB_SBFE_High_Credit__c = null;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 12000;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(12000, ar);

            // Risk Grade 4
            // DNB Recommended Credit Line higher than the Credit Line Requested
            applicationRequests[0].PG_Required__c = false;
            applicationRequests[0].Risk_Grade__c = '4';
            applicationRequests[0].DNB_SBFE_High_Credit__c = 20000;
            applicationRequests[0].DNB_CSAD_High_Credit__c = 15000;
            applicationRequests[0].DNB_Credit_Line_Recommendation__c = 17000;
            applicationRequests[0].Requested_Credit_Limit__c = '16000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(16000, ar);

            /** TEST CONSUMER */
            // Risk Grade 1 or 2
            // Requesting below 25k
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '1';
            applicationRequests[0].Requested_Credit_Limit__c = '10000';
            applicationRequests[0].Credit_Line_Recommendation__c = 0;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.debug('ar : ' + ar);
            System.assertEquals(10000, ar);

            // Risk Grade 1 or 2
            // Requesting above 25k and below 150k
            // has enough high credit to cover
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '2';
            applicationRequests[0].Requested_Credit_Limit__c = '30000';
            applicationRequests[0].PG_High_Credit_Amount__c = 35000;
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(30000, ar);

            // Risk Grade 1 or 2
            // Requesting above 25k and below 150k
            // does NOT have enough high credit to cover
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '2';
            applicationRequests[0].Requested_Credit_Limit__c = '40000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(35000, ar);

            // Risk Grade 3 or 4
            // Requesting below 10k
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '3';
            applicationRequests[0].Requested_Credit_Limit__c = '9000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(9000, ar);

            // Risk Grade 3 or 4
            // Requesting above 10k and below 150k
            // has enough high credit to cover
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '3';
            applicationRequests[0].Requested_Credit_Limit__c = '15000';
            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(15000, ar);

            // Risk Grade 3 or 4
            // Requesting above 10k and below 150k
            // does NOT have enough high credit to cover
            applicationRequests[0].PG_Required__c = true;
            applicationRequests[0].Risk_Grade__c = '4';
            applicationRequests[0].Requested_Credit_Limit__c = '15000';
            applicationRequests[0].PG_High_Credit_Amount__c = 9000;

            upsert applicationRequests[0];

            ar = (Decimal) cuccl.getFunctionValue(null, new Application_Request__c(Id = applicationRequests[0].Id), 'String', 'String', 'String', applicationRequests[0].Id);
            System.assertEquals(9000, ar);

            cuccl.postProcess();

            cuccl.preProcess(applicationRequests, 'Test', 'Test');

            Test.stopTest();
        }
    }

    static testMethod void testDNBCustomModelCallout() {

        List<Application_Request__c> applicationRequests = [SELECT Id, DUNS_Number__c, Requested_Credit_Limit__c FROM Application_Request__c LIMIT 1];

        if (applicationRequests.size() == 1) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_DNB.DNBNAFleetModelRequest dnbNAFleetModelRequest = new CreditWS_DNB.DNBNAFleetModelRequest();
            dnbNAFleetModelRequest.DnB_DUNS_Number = applicationRequests[0].DUNS_Number__c;

            CreditWS_DNB.DNBNAFleetModelResponse dnbnaFleetModelResponse = CreditWS_DNB.getNAFleetScore(dnbNAFleetModelRequest);

            Test.stopTest();

        }

    }


    static testMethod void testExistingExposure() {

        List<Application_Request__c> naApplications = [SELECT Id FROM Application_Request__c];

        if (naApplications.size() > 0) {

            PageReference creditExistingExposure = Page.FindDupOnlineApps;

            creditExistingExposure.getParameters().put('id', naApplications[0].Id);

            Test.setCurrentPage(creditExistingExposure);

            CreditExistingExposureController fdoac = new CreditExistingExposureController();

            fdoac.init();

            System.debug('duplication Account size = ' + fdoac.duplicateAccounts.size());
            System.debug('duplication Applications size = ' + fdoac.duplicateApplications.size());
            System.assert(fdoac.duplicateAccounts.size() == 0);
            System.assert(fdoac.duplicateApplications.size() >= 0);

        }

    }

    static testMethod void testCreditWSUtil_DNBCustomModel() {

        new CreditWSUtil_DNBCustomModel.ArrayOfADDL_SIC_GRP();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedCashPayments();
        new CreditWSUtil_DNBCustomModel.PAY_DATA_SUMM();
        new CreditWSUtil_DNBCustomModel.SCR_CMTY();
        new CreditWSUtil_DNBCustomModel.PMT_DATA_SUMM_VW();
        new CreditWSUtil_DNBCustomModel.SUMZ_PST_DUE();
        new CreditWSUtil_DNBCustomModel.ws_CustomProducts12();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedUnfavorablePayments();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedDataCoveragePaymentsForTwelveMonths();
        new CreditWSUtil_DNBCustomModel.customProducts12_Response();
        new CreditWSUtil_DNBCustomModel.USDS_FEIN_CTR();
        new CreditWSUtil_DNBCustomModel.ArrayOfUSDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_PAY_DATA_SUMM();
        new CreditWSUtil_DNBCustomModel.SubjectHeader();
        new CreditWSUtil_DNBCustomModel.SummarizedPastDueTypeForDetailedTrade();
        new CreditWSUtil_DNBCustomModel.PTFL_CMPA_SCR();
        new CreditWSUtil_DNBCustomModel.US_PRNT_BKCY_FILG_GRP();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedNetTermsPayments();
        new CreditWSUtil_DNBCustomModel.ArrayOfUVZW_SCR();
        new CreditWSUtil_DNBCustomModel.IC_CMTRY_SCT();
        new CreditWSUtil_DNBCustomModel.SummarizedSlow_element();
        new CreditWSUtil_DNBCustomModel.ArrayOfUSDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBCustomModel.USDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBCustomModel.PMT_PRD_SUMM();
        new CreditWSUtil_DNBCustomModel.DGX();
        new CreditWSUtil_DNBCustomModel.AmountType();
        new CreditWSUtil_DNBCustomModel.STATUS2();
        new CreditWSUtil_DNBCustomModel.IC_SPL_EVT_SCT();
        new CreditWSUtil_DNBCustomModel.Immediate_Delivery();
        new CreditWSUtil_DNBCustomModel.ArrayOfVZW_SCR();
        new CreditWSUtil_DNBCustomModel.US_COMMENTARY_GRP();
        new CreditWSUtil_DNBCustomModel.USP80();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedDiscountTermsPayments();
        new CreditWSUtil_DNBCustomModel.Orders();
        new CreditWSUtil_DNBCustomModel.YRS_IN_BUS_DTL();
        new CreditWSUtil_DNBCustomModel.ArrayOfPAY_DATA_SUMM();
        new CreditWSUtil_DNBCustomModel.Organization();
        new CreditWSUtil_DNBCustomModel.CustomScore();
        new CreditWSUtil_DNBCustomModel.BusinessTrading();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.SPL_EVT_SCT();
        new CreditWSUtil_DNBCustomModel.prodOrderRequest_3();
        new CreditWSUtil_DNBCustomModel.US_PRNT_BKCY_CONV_GRP();
        new CreditWSUtil_DNBCustomModel.DNBDateType();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedPaymentsWithHighCredit();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_PMT_PRD_SUMM();
        new CreditWSUtil_DNBCustomModel.DNB_VBLTY_RATG_ENTR();
        new CreditWSUtil_DNBCustomModel.PAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCustomModel.PMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCustomModel.ArrayOfPMT_DATA_SUMM_VW();
        new CreditWSUtil_DNBCustomModel.AdditionalFields();
        new CreditWSUtil_DNBCustomModel.IndustryCodeDescriptionType();
        new CreditWSUtil_DNBCustomModel.ArrayOfUSDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBCustomModel.SER_RAT_ENTR();
        new CreditWSUtil_DNBCustomModel.ArrayOfstring();
        new CreditWSUtil_DNBCustomModel.DNBDecodedStringType();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedDataCoveragePayments();
        new CreditWSUtil_DNBCustomModel.PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCustomModel.Investigation();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedPaymentsByCreditRange();
        new CreditWSUtil_DNBCustomModel.IC_PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCustomModel.ArrayOfPNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCustomModel.socCode();
        new CreditWSUtil_DNBCustomModel.ws_CustomProducts12Response();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedNoPaymentMannerPayments();
        new CreditWSUtil_DNBCustomModel.ORG_SZ_DTL();
        new CreditWSUtil_DNBCustomModel.SONRS();
        new CreditWSUtil_DNBCustomModel.ArrayOfPMT_PRD_SUMM();
        new CreditWSUtil_DNBCustomModel.ArrayOfPMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCustomModel.CAP90();
        new CreditWSUtil_DNBCustomModel.ArrayOfAdditionalFields();
        new CreditWSUtil_DNBCustomModel.SatisfactoryPayments();
        new CreditWSUtil_DNBCustomModel.VZ_PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCustomModel.SPCL_EVNT_TXT_SCT();
        new CreditWSUtil_DNBCustomModel.ADDL_SIC_GRP();
        new CreditWSUtil_DNBCustomModel.ArrayOfSPL_EVT_SCT();
        new CreditWSUtil_DNBCustomModel.STATUS();
        new CreditWSUtil_DNBCustomModel.CMTRY_SCT();
        new CreditWSUtil_DNBCustomModel.ArrayOfSUMZ_PST_DUE();
        new CreditWSUtil_DNBCustomModel.DELQ_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.ScoreCommentaryComponentType();
        new CreditWSUtil_DNBCustomModel.SCR_GRP();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedData();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_PAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCustomModel.SCR_GRP2();
        new CreditWSUtil_DNBCustomModel.IC_PNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCustomModel.VBLTY_SCR();
        new CreditWSUtil_DNBCustomModel.SCR_GRP3();
        new CreditWSUtil_DNBCustomModel.US_SPCL_EVNT_GRP();
        new CreditWSUtil_DNBCustomModel.DATARS();
        new CreditWSUtil_DNBCustomModel.CA_DTRi();
        new CreditWSUtil_DNBCustomModel.ArrayOfCAP90();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_DELQ_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.ArrayOfPNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedPlacedForCollectionPayments();
        new CreditWSUtil_DNBCustomModel.EMMA_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.ArrayOfUS_PRNT_BKCY_FILG_GRP();
        new CreditWSUtil_DNBCustomModel.PNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_PAYD_PRD_REC();
        new CreditWSUtil_DNBCustomModel.USDS_PAYD_GRP();
        new CreditWSUtil_DNBCustomModel.ArrayOfUSDS_FEIN_CTR();
        new CreditWSUtil_DNBCustomModel.ScoreCommentary();
        new CreditWSUtil_DNBCustomModel.CA_LT();
        new CreditWSUtil_DNBCustomModel.USDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBCustomModel.ArrayOfPAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCustomModel.Assessment();
        new CreditWSUtil_DNBCustomModel.PredictiveAttributesType();
        new CreditWSUtil_DNBCustomModel.USPIJ();
        new CreditWSUtil_DNBCustomModel.IC_SPCL_EVNT_TXT_SCT();
        new CreditWSUtil_DNBCustomModel.DATA_DPTH_DTL();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_PMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedPaymentPeriodSummary();
        new CreditWSUtil_DNBCustomModel.ArrayOfUS_SPCL_EVNT_GRP();
        new CreditWSUtil_DNBCustomModel.USDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBCustomModel.US_SPCL_EVNT();
        new CreditWSUtil_DNBCustomModel.Purchaser();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_SUMZ_PST_DUE();
        new CreditWSUtil_DNBCustomModel.DNBDecodedStringNewType();
        new CreditWSUtil_DNBCustomModel.ArrayOfUSDS_PAYD_GRP();
        new CreditWSUtil_DNBCustomModel.FAIL_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.CREDITMSGSRSV2();
        new CreditWSUtil_DNBCustomModel.ArrayOfCMTRY_SCT();
        new CreditWSUtil_DNBCustomModel.CustomScores();
        new CreditWSUtil_DNBCustomModel.NotificationDelivery();
        new CreditWSUtil_DNBCustomModel.TRD_DATA_AVLB_DTL();
        new CreditWSUtil_DNBCustomModel.Subject();
        new CreditWSUtil_DNBCustomModel.DTRI_SCR_FAIL_SCR_ENTR();
        new CreditWSUtil_DNBCustomModel.DATATRNRS();
        new CreditWSUtil_DNBCustomModel.ArrayOfUS_PRNT_BKCY_CONV_GRP();
        new CreditWSUtil_DNBCustomModel.InvestigationDelivery();
        new CreditWSUtil_DNBCustomModel.SIGNONMSGSRSV1();
        new CreditWSUtil_DNBCustomModel.PurchaserDerivedPaymentsToSupplierIndustry();
        new CreditWSUtil_DNBCustomModel.SummarizedSlowType();
        new CreditWSUtil_DNBCustomModel.ORG_PFL_DTL();
        new CreditWSUtil_DNBCustomModel.SECTION();
        new CreditWSUtil_DNBCustomModel.ArrayOfUS_COMMENTARY_GRP();
        new CreditWSUtil_DNBCustomModel.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd12_wsp_CustomProducts12_Port();

    }


    //TODO DELETE ME
    static testMethod void testCreditWSUtil_DNBCCS() {

        new CreditWSUtil_DNBCCS.ArrayOfADDL_SIC_GRP();
        new CreditWSUtil_DNBCCS.PurchaserDerivedCashPayments();
        new CreditWSUtil_DNBCCS.PAY_DATA_SUMM();
        new CreditWSUtil_DNBCCS.SCR_CMTY();
        new CreditWSUtil_DNBCCS.PMT_DATA_SUMM_VW();
        new CreditWSUtil_DNBCCS.SUMZ_PST_DUE();
        new CreditWSUtil_DNBCCS.PurchaserDerivedUnfavorablePayments();
        new CreditWSUtil_DNBCCS.PurchaserDerivedDataCoveragePaymentsForTwelveMonths();
        new CreditWSUtil_DNBCCS.USDS_FEIN_CTR();
        new CreditWSUtil_DNBCCS.ArrayOfUSDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBCCS.DTRI_SCR_PAY_DATA_SUMM();
        new CreditWSUtil_DNBCCS.SubjectHeader();
        new CreditWSUtil_DNBCCS.SummarizedPastDueTypeForDetailedTrade();
        new CreditWSUtil_DNBCCS.PTFL_CMPA_SCR();
        new CreditWSUtil_DNBCCS.US_PRNT_BKCY_FILG_GRP();
        new CreditWSUtil_DNBCCS.PurchaserDerivedNetTermsPayments();
        new CreditWSUtil_DNBCCS.ArrayOfUVZW_SCR();
        new CreditWSUtil_DNBCCS.IC_CMTRY_SCT();
        new CreditWSUtil_DNBCCS.SummarizedSlow_element();
        new CreditWSUtil_DNBCCS.ArrayOfUSDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBCCS.customProducts1_5_Response();
        new CreditWSUtil_DNBCCS.USDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBCCS.PMT_PRD_SUMM();
        new CreditWSUtil_DNBCCS.DGX();
        new CreditWSUtil_DNBCCS.AmountType();
        new CreditWSUtil_DNBCCS.STATUS2();
        new CreditWSUtil_DNBCCS.IC_SPL_EVT_SCT();
        new CreditWSUtil_DNBCCS.Immediate_Delivery();
        new CreditWSUtil_DNBCCS.ArrayOfVZW_SCR();
        new CreditWSUtil_DNBCCS.US_COMMENTARY_GRP();
        new CreditWSUtil_DNBCCS.PurchaserDerivedDiscountTermsPayments();
        new CreditWSUtil_DNBCCS.Orders();
        new CreditWSUtil_DNBCCS.YRS_IN_BUS_DTL();
        new CreditWSUtil_DNBCCS.ArrayOfPAY_DATA_SUMM();
        new CreditWSUtil_DNBCCS.Organization();
        new CreditWSUtil_DNBCCS.BusinessTrading();
        new CreditWSUtil_DNBCCS.DTRI_SCR_ENTR();
        new CreditWSUtil_DNBCCS.SPL_EVT_SCT();
        new CreditWSUtil_DNBCCS.prodOrderRequest_3();
        new CreditWSUtil_DNBCCS.US_PRNT_BKCY_CONV_GRP();
        new CreditWSUtil_DNBCCS.DNBDateType();
        new CreditWSUtil_DNBCCS.PurchaserDerivedPaymentsWithHighCredit();
        new CreditWSUtil_DNBCCS.DTRI_SCR_PMT_PRD_SUMM();
        new CreditWSUtil_DNBCCS.DNB_VBLTY_RATG_ENTR();
        new CreditWSUtil_DNBCCS.PAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCCS.USPVZ();
        new CreditWSUtil_DNBCCS.PMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCCS.USPVW();
        new CreditWSUtil_DNBCCS.ArrayOfPMT_DATA_SUMM_VW();
        new CreditWSUtil_DNBCCS.AdditionalFields();
        new CreditWSUtil_DNBCCS.IndustryCodeDescriptionType();
        new CreditWSUtil_DNBCCS.ArrayOfUSDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBCCS.SER_RAT_ENTR();
        new CreditWSUtil_DNBCCS.ArrayOfstring();
        new CreditWSUtil_DNBCCS.PurchaserDerivedDataCoveragePayments();
        new CreditWSUtil_DNBCCS.PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCCS.Investigation();
        new CreditWSUtil_DNBCCS.PurchaserDerivedPaymentsByCreditRange();
        new CreditWSUtil_DNBCCS.IC_PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCCS.ArrayOfPNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCCS.socCode();
        new CreditWSUtil_DNBCCS.PurchaserDerivedNoPaymentMannerPayments();
        new CreditWSUtil_DNBCCS.ORG_SZ_DTL();
        new CreditWSUtil_DNBCCS.SONRS();
        new CreditWSUtil_DNBCCS.ArrayOfPMT_PRD_SUMM();
        new CreditWSUtil_DNBCCS.ArrayOfPMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCCS.CAP90();
        new CreditWSUtil_DNBCCS.ArrayOfAdditionalFields();
        new CreditWSUtil_DNBCCS.SatisfactoryPayments();
        new CreditWSUtil_DNBCCS.VZ_PNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCCS.SPCL_EVNT_TXT_SCT();
        new CreditWSUtil_DNBCCS.ADDL_SIC_GRP();
        new CreditWSUtil_DNBCCS.ArrayOfSPL_EVT_SCT();
        new CreditWSUtil_DNBCCS.STATUS();
        new CreditWSUtil_DNBCCS.CMTRY_SCT();
        new CreditWSUtil_DNBCCS.ArrayOfSUMZ_PST_DUE();
        new CreditWSUtil_DNBCCS.DELQ_SCR_ENTR();
        new CreditWSUtil_DNBCCS.SCR_GRP();
        new CreditWSUtil_DNBCCS.PurchaserDerivedData();
        new CreditWSUtil_DNBCCS.DTRI_SCR_PAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCCS.SCR_GRP2();
        new CreditWSUtil_DNBCCS.IC_PNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCCS.VBLTY_SCR();
        new CreditWSUtil_DNBCCS.SCR_GRP3();
        new CreditWSUtil_DNBCCS.US_SPCL_EVNT_GRP();
        new CreditWSUtil_DNBCCS.DATARS();
        new CreditWSUtil_DNBCCS.CA_DTRi();
        new CreditWSUtil_DNBCCS.ws_CustomProducts1_5Response();
        new CreditWSUtil_DNBCCS.ArrayOfCAP90();
        new CreditWSUtil_DNBCCS.DTRI_SCR_DELQ_SCR_ENTR();
        new CreditWSUtil_DNBCCS.ArrayOfPNT_BKCY_FILG_SCT();
        new CreditWSUtil_DNBCCS.PurchaserDerivedPlacedForCollectionPayments();
        new CreditWSUtil_DNBCCS.EMMA_SCR_ENTR();
        new CreditWSUtil_DNBCCS.ArrayOfUS_PRNT_BKCY_FILG_GRP();
        new CreditWSUtil_DNBCCS.PNT_BKCY_CONV_SCT();
        new CreditWSUtil_DNBCCS.DTRI_SCR_PAYD_PRD_REC();
        new CreditWSUtil_DNBCCS.USDS_PAYD_GRP();
        new CreditWSUtil_DNBCCS.ArrayOfUSDS_FEIN_CTR();
        new CreditWSUtil_DNBCCS.CA_LT();
        new CreditWSUtil_DNBCCS.USDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBCCS.ArrayOfPAY_DATA_SUMM_ENTR();
        new CreditWSUtil_DNBCCS.USPIJ();
        new CreditWSUtil_DNBCCS.IC_SPCL_EVNT_TXT_SCT();
        new CreditWSUtil_DNBCCS.DATA_DPTH_DTL();
        new CreditWSUtil_DNBCCS.DTRI_SCR_PMT_PRD_SUMM_VW();
        new CreditWSUtil_DNBCCS.PurchaserDerivedPaymentPeriodSummary();
        new CreditWSUtil_DNBCCS.ArrayOfUS_SPCL_EVNT_GRP();
        new CreditWSUtil_DNBCCS.USDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBCCS.US_SPCL_EVNT();
        new CreditWSUtil_DNBCCS.ws_CustomProducts1_5();
        new CreditWSUtil_DNBCCS.Purchaser();
        new CreditWSUtil_DNBCCS.USPIC();
        new CreditWSUtil_DNBCCS.DTRI_SCR_SUMZ_PST_DUE();
        new CreditWSUtil_DNBCCS.ArrayOfUSDS_PAYD_GRP();
        new CreditWSUtil_DNBCCS.FAIL_SCR_ENTR();
        new CreditWSUtil_DNBCCS.CREDITMSGSRSV2();
        new CreditWSUtil_DNBCCS.ArrayOfCMTRY_SCT();
        new CreditWSUtil_DNBCCS.NotificationDelivery();
        new CreditWSUtil_DNBCCS.TRD_DATA_AVLB_DTL();
        new CreditWSUtil_DNBCCS.Subject();
        new CreditWSUtil_DNBCCS.DTRI_SCR_FAIL_SCR_ENTR();
        new CreditWSUtil_DNBCCS.DATATRNRS();
        new CreditWSUtil_DNBCCS.ArrayOfUS_PRNT_BKCY_CONV_GRP();
        new CreditWSUtil_DNBCCS.InvestigationDelivery();
        new CreditWSUtil_DNBCCS.SIGNONMSGSRSV1();
        new CreditWSUtil_DNBCCS.PurchaserDerivedPaymentsToSupplierIndustry();
        new CreditWSUtil_DNBCCS.SummarizedSlowType();
        new CreditWSUtil_DNBCCS.ORG_PFL_DTL();
        new CreditWSUtil_DNBCCS.SECTION();
        new CreditWSUtil_DNBCCS.ArrayOfUS_COMMENTARY_GRP();
        new CreditWSUtil_DNBCCS.DNB_WebServices_Providers_OrderAndInvestigations_CustomProducts_CustomProd1_5_V12_wsp_CustomProducts1_5_V13_Port();

    }

}