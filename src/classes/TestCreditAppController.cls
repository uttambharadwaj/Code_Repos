@isTest
public class TestCreditAppController {
//    public static CreditApplicationController cont = new CreditApplicationController();
//    public static Campaign testCamp = new Campaign();
//    public static Campaign_Program__c testCP = new Campaign_Program__c();
//    public static Program__c testProg = new Program__c();
//    public static WeFormObject__c we = setupApp();
//    public static Campaign_Pricing__c pric1{get; set;}
//    public static Campaign_Pricing__c pric2{get; set;}
//
//    @testSetup
//    static void setup(){
//        UtilityTestLoader.setAutomation(false);
//    }
//
//    public static Campaign_Pricing__c setupPricing(){
//    	Campaign_Pricing__c pric = new Campaign_Pricing__c();
//        pric.Name = 'test';
//        pric.contract_margin__c = 'Y';
//        pric.penalty_margin__c = 'Y';
//        pric.days_to_pay__c = 21;
//        pric.prime_rate__c = 3.25;
//        pric.prime_rate_effective_date__c = date.today();
//        pric.late_fee_type__c = 'P';
//        pric.return_payment_fee__c = 49.99;
//        pric.over_limit_fee__c = 39.99;
//        pric.paper_delivery_fee__c = 5.00;
//        pric.penalty_rate_ceiling__c = 999.99;
//        pric.minimum_payment_percentage__c = 29.99;
//        pric.Peoplesoft_rel_code__c = '001207';
//        pric.coup_code__c = 'A01';
//        pric.is_Active__c = true;
//        pric.Coupon_Status__c = 'valid';
//        pric.risk_code__c = 'No';
//        pric.nbr_billing_cyles__c = '1';
//        pric.contract_rate_pct__c = 10.15;
//        pric.fixed_late_fee__c = 0.00;
//        pric.pct_late_fee__c = 2.49;
//        pric.pen_rate_pct__c = 27.34;
//        pric.promo_periods__c = 1.0;
//        pric.promotional_rate__c = 8.17;
//        pric.CurrencyIsoCode = 'USD';
//
//
//        insert pric;
//
//        return pric;
//
//    }
//
//    public static WeFormObject__c setupApp(){
//        WeFormObject__c we1 = new WeFormObject__c();
//        we1.Address_Line_2__c = 'Suite 100';
//        we1.Billing_Address_Line_2__c = 'Suite 100';
//        we1.Billing_City__c = 'Kingston';
//        we1.Billing_Contact_First_Name__c = 'Professional';
//        we1.Billing_Contact_Last_Name__c = 'Services';
//        we1.Billing_Email__c = 'ps@stantive.com';
//        we1.Billing_Fax__c = '555-555-5555';
//        we1.Annual_Gross_Revenue__c = 100000.00;
//        we1.Avg_Monthly_Fuel_Service_Expenses__c = 10000.00;
//        we1.Billing_Phone__c = '613-555-5556';
//        we1.Billing_State__c = 'ON';
//        we1.Billing_Street_Address__c = '4 Cataraqui Street';
//        we1.Billing_Zip_Code__c = '62106';
//        we1.Business_fax__c = '613-555-5554';
//        we1.Business_Phone__c = '613-555-5555';
//        we1.Business_Street_Address__c = '4 Cataraqui Street';
//        we1.Date_of_Birth__c = '10/01/1986';
//        we1.PG_SSN__c = '123-45-6789';
//        we1.PG_Residential_Street_Address__c = '11 Awesome Street';
//        we1.PG_Residential_City__c = 'Adventure Land';
//        we1.PG_Residential_State__c = 'CA';
//        we1.PG_Residential_Zip__c = '43402';
//        we1.Email__c = 'test@test.com';
//        we1.City__c = 'Portland';
//        we1.Company_Name__c = 'Stantive Technologies';
//        we1.Doing_Business_As__c = 'Stantive';
//        we1.Employee_Id__c = '1234';
//        we1.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
//        we1.First_Name__c = 'Professional';
//        we1.Fiscal_Year_Starts__c = 'Jan';
//        we1.Group_Code__c = 'ABC';
//        we1.How_did_you_hear_about_this_offer__c = 'Web';
//        we1.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
//        we1.Paperless_Flag__c = 'Yes';
//        we1.Last_Name__c = 'Services';
//        we1.Legal_Structure__c = 'Corporation';
//        we1.Location_Code__c = 'NW';
//        we1.Promotional_Code__c = 'B1C';
//        we1.Sales_Id__c = '663434';
//        we1.Same_as_Business_Address__c = true;
//        we1.Signer_s_Email__c = 'ps@stantive.com';
//        we1.Signer_s_First_Name__c = 'Development';
//        we1.Signer_s_Last_Name__c = 'Services';
//        we1.Signer_s_Phone__c = '613-555-1111';
//        we1.signer_title__c = 'President';
//        we1.State__c = 'ME';
//        we1.Taxpayer_ID__c = '5664363';
//        we1.Years_in_Business__c = 'Less than 12 months';
//        we1.Zip_code__c = '04101';
//
//        return we1;
//
//    }
//
//    public static Campaign setupCamp(){
//        //create campaign test data
//        testCamp.Coupon_Code__c = 'A01';
//        testCamp.Name = 'test';
//        testCamp.Type = 'Online Form';
//        testCamp.Status = 'In Progress';
//        testCamp.Drop_Date__c = date.today();
//        testCamp.EndDate = date.today();
//        testCamp.CurrencyIsoCode = 'USD';
//        insert testCamp;
//
//        return testCamp;
//    }
//
//    public static Program__c setupProg(){
//
//        //create program test data
//
//
//        testProg.Name = 'testFlex';
//        testProg.Form_Template__c = 'CreditApp_Revolver';
//        testProg.Template__c = 'CreditApp_Revolver';
//        testProg.Brand_Short_Name__c = 'flex';
//        testProg.Preferred_Language_Indicator__c = 'ENU';
//        testProg.Peoplesoft_rel_code__c = '001207';
//        testProg.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
//        testProg.Brand_Heading__c = 'Time is money. Use WEX and save both.';
//        testProg.Brand_Long_Name__c = 'flex test card';
//        testProg.Upload_Pricing_Data_Flag__c = true;
//
//
//        insert testProg;
//
//        //attachments
//        Attachment attach1 = new Attachment();
//        attach1.Name = 'ui-credit-card.png';
//        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
//        attach1.body=bodyBlob;
//        attach1.parentId=testProg.id;
//        insert attach1;
//
//        Attachment attach2 = new Attachment();
//        attach2.Name = 'ui-logo.png';
//        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
//        attach2.body=bodyBlob2;
//        attach2.parentId=testProg.id;
//        insert attach2;
//
//        upsert testProg;
//        return testProg;
//
//    }
//
//    public static Campaign_Program__c setupCP(){
//        //create campaign program test data
//        testCP.Name = 'Flex Test';
//        testCP.Campaign__c = testCamp.Id;
//        testCP.Program__c = testProg.Id;
//        testCP.Default__c = true;
//
//        insert testCP;
//
//        return testCP;
//
//    }
//
//    @isTest static void testPageWithParamOneRow(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        pric1 = setupPricing();
//
//        //Query for pricing to get formula fields to populate
//        pric1 = [SELECT Id, Penalty_Rate_Type__c, Contract_Rate_Type__c, contract_margin__c,
//        penalty_margin__c,
//        days_to_pay__c,
//        prime_rate__c,
//        prime_rate_effective_date__c,
//        late_fee_type__c,
//        return_payment_fee__c,
//        over_limit_fee__c,
//        paper_delivery_fee__c,
//        penalty_rate_ceiling__c ,
//        minimum_payment_percentage__c,
//        Peoplesoft_rel_code__c ,
//        coup_code__c,
//        is_Active__c ,
//        Coupon_Status__c ,
//        risk_code__c ,
//        nbr_billing_cyles__c,
//        contract_rate_pct__c,
//        fixed_late_fee__c ,
//        pct_late_fee__c ,
//        pen_rate_pct__c ,
//        promo_periods__c,
//        promotional_rate__c FROM Campaign_Pricing__c WHERE Id =: pric1.Id];
//
//        update pric1;
//
//
//        testProg.Publish_BOCA__c = true;
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Revolver');
//        testPage.setRedirect(false);
//        Test.setCurrentPageReference(testPage);
//
//   		SYSTEM.currentPageReference().getParameters().put('pgm', 'flex');
//        SYSTEM.currentPageReference().getParameters().put('cc', 'A01');
//        SYSTEM.currentPageReference().getParameters().put('weId', we.Id);
//        SYSTEM.debug('String ' + cont.termAndCond);
//        cont.prog = testProg;
//        PageReference brandTest = cont.initBrandCheck();
//        cont.setupBranding();
//        SYSTEM.debug('pricing' + cont.pricing.size());
//        cont.creditApp = we;
//
//        //test fields
//        SYSTEM.debug('brand check'+
//                     cont.brand1 +
//                     cont.brand2 +
//                     cont.BrandTagline +
//                     cont.BrandLongName +
//                     cont.cardURL +
//                     cont.fieldList +
//                     cont.oppNum +
//                     cont.pricingObj +
//                     cont.confirmation +
//                     cont.emailURL +
//                     cont.terms +
//                     cont.statusInfo +
//                     cont.pricing +
//                     cont.googleAnalyticsBodyBlock +
//                     cont.googleAnalyticsHeadBlock);
//        //get the pricing
//        //cont.fieldList = wp.getPricing(pric);
//
//        PageReference testP = cont.SubmitCreditApplication();
//        //cont.SendEmail();
//
//
//        SYSTEM.debug('we= ' + cont.creditApp);
//
//
//    }
//    @isTest static void testPageWithParamTwoRows(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        pric1 = setupPricing();
//        //create another pricing object
//        pric2 = setupPricing();
//
//        //Query for pricing to get formula fields to populate
//        pric1 = [SELECT Id, Penalty_Rate_Type__c, Contract_Rate_Type__c, contract_margin__c,
//        penalty_margin__c,
//        days_to_pay__c,
//        prime_rate__c,
//        prime_rate_effective_date__c,
//        late_fee_type__c,
//        return_payment_fee__c,
//        over_limit_fee__c,
//        paper_delivery_fee__c,
//        penalty_rate_ceiling__c ,
//        minimum_payment_percentage__c,
//        Peoplesoft_rel_code__c ,
//        coup_code__c,
//        is_Active__c ,
//        Coupon_Status__c ,
//        risk_code__c ,
//        nbr_billing_cyles__c,
//        contract_rate_pct__c,
//        fixed_late_fee__c ,
//        pct_late_fee__c ,
//        pen_rate_pct__c ,
//        promo_periods__c,
//        promotional_rate__c FROM Campaign_Pricing__c WHERE Id =: pric1.Id];
//
//        update pric1;
//
//         //Query for pricing to get formula fields to populate
//        pric2 = [SELECT Id, Penalty_Rate_Type__c, Contract_Rate_Type__c, contract_margin__c,
//        penalty_margin__c,
//        days_to_pay__c,
//        prime_rate__c,
//        prime_rate_effective_date__c,
//        late_fee_type__c,
//        return_payment_fee__c,
//        over_limit_fee__c,
//        paper_delivery_fee__c,
//        penalty_rate_ceiling__c ,
//        minimum_payment_percentage__c,
//        Peoplesoft_rel_code__c ,
//        coup_code__c,
//        is_Active__c ,
//        Coupon_Status__c ,
//        risk_code__c ,
//        nbr_billing_cyles__c,
//        contract_rate_pct__c,
//        fixed_late_fee__c ,
//        pct_late_fee__c ,
//        pen_rate_pct__c ,
//        promo_periods__c,
//        promotional_rate__c FROM Campaign_Pricing__c WHERE Id =: pric2.Id];
//
//        update pric2;
//
//        testProg.Publish_BOCA__c = true;
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Revolver');
//
//        testPage.getParameters().put('pgm','flex');
//        testPage.getParameters().put('cc', 'A01');
//        testPage.getParameters().put('weId', we.Id);
//
//        Test.setCurrentPage(testPage);
//
//        test.startTest();
//        cont.prog = testProg;
//        List<Campaign_Pricing__c> testList = new List<Campaign_Pricing__c>();
//        testList.add(pric1);
//        testList.add(pric2);
//
//        cont.pricing = testList;
//
//        PageReference brandTest = cont.initBrandCheck();
//        cont.setupBranding();
//        SYSTEM.debug('pricing' + cont.pricing.size());
//
//        cont.creditApp = we;
//
//        //test fields
//        SYSTEM.debug('brand check'+
//                     cont.brand1 +
//                     cont.brand2 +
//                     cont.BrandTagline +
//                     cont.BrandLongName +
//                     cont.cardURL +
//                     cont.fieldList +
//                     cont.oppNum +
//                     cont.pricingObj +
//                     cont.confirmation +
//                     cont.emailURL +
//                     cont.terms +
//                     cont.statusInfo +
//                     cont.pricing +
//                     cont.googleAnalyticsBodyBlock +
//                     cont.googleAnalyticsHeadBlock);
//        //get the pricing
//        //cont.fieldList = wp.getPricing(pric);
//
//        PageReference testP = cont.SubmitCreditApplication();
//        //cont.SendEmail();
//
//        test.stopTest();
//        SYSTEM.debug('we= ' + cont.creditApp);
//
//
//    }
//    @isTest static void testPageWithoutParam(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        pric1 = setupPricing();
//
//        testCamp.Coupon_Code__c = pric1.coup_code__c;
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Revolver');
//
//        Test.setCurrentPage(testPage);
//        test.startTest();
//
//        SYSTEM.debug('error' + cont.errorMsg);
//
//        PageReference errP = cont.CreditApplicationError();
//
//        test.stopTest();
//    }
//     @isTest static void testPageInvalidTemplate(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        pric1 = setupPricing();
//
//        testCamp.Coupon_Code__c = pric1.coup_code__c;
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Wrong');
//
//        Test.setCurrentPage(testPage);
//        test.startTest();
//
//        SYSTEM.debug('error' + cont.errorMsg);
//
//        PageReference errP = cont.CreditApplicationError();
//
//        test.stopTest();
//    }
//    @isTest static void testStatusPage(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        testProg.Publish_BOCA__c = true;
//
//        PageReference testPage = new PageReference('/apex/CreditApplicationStatus');
//        testPage.getParameters().put('pgm','flex');
//        Test.setCurrentPage(testPage);
//        test.startTest();
//
//        cont.statusInfo = 'pending';
//
//        SYSTEM.debug('status' + cont.statusInfo);
//
//        test.stopTest();
//
//    }
//     @isTest static void testStatusNoProgPage(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        testProg.Publish_BOCA__c = true;
//
//        PageReference testPage = new PageReference('/apex/CreditApplicationStatus');
//        Test.setCurrentPage(testPage);
//        test.startTest();
//        cont.initBrandCheck();
//        cont.statusInfo = 'pending';
//
//        SYSTEM.debug('status' + cont.statusInfo);
//
//        test.stopTest();
//
//    }
//
//    @isTest static void testConfirmationPage(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//        testProg.Publish_BOCA__c = true;
//
//        PageReference testPage = new PageReference('/apex/CreditApplicationConfirmation');
//        testPage.getParameters().put('pgm','flex');
//        testPage.getParameters().put('oppNum','123456789');
//        Test.setCurrentPage(testPage);
//        test.startTest();
//
//        cont.statusInfo = 'pending';
//
//        SYSTEM.debug('status' + cont.statusInfo);
//
//        test.stopTest();
//
//    }
//
//    @isTest static void testBrandedErrorPage(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//
//        testProg.Publish_BOCA__c = false;
//
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Revolver');
//        testPage.getParameters().put('pgm','flex');
//        Test.setCurrentPage(testPage);
//
//        test.startTest();
//
//        PageReference errP = cont.CreditApplicationError();
//
//        SYSTEM.debug('brand error' + cont.errorMsg);
//
//        test.stopTest();
//
//    }
//    @isTest static void testUtilities(){
//        testCamp = setupCamp();
//        testProg = setupProg();
//        testCP = setupCP();
//
//        PageReference testPage = new PageReference('/apex/CreditApp_Revolver');
//
//        Test.setCurrentPage(testPage);
//
//        test.startTest();
//        testPage.getParameters().put('pgm','flex');
//
//        //brand util
//        WEXBrandUtility util1 = new WEXBrandUtility();
//        testCP = util1.getCampaignProgram(testProg, testCamp);
//        String testcc = util1.getValidCouponCode(testProg.Id, 'A01');
//        boolean testboole = util1.isValidTemplateForProgram(testPage.getUrl(), testProg);
//        util1.getPricing(testProg.Peoplesoft_rel_code__c, 'A01');
//        util1.setProgramFromURL('flex', testPage.getUrl());
//
//        //wex helper
//        WEXHelper.getStates();
//        WEXHelper.IsProduction();
//        WEXHelper.getSecureSitesURL();
//        WEXHelper.getDayOfWeek(date.today());
//        WEXHelper.skipToNextBusinessDay(date.today());
//
//        //error util
//        Map<String, String> testMap = WEXErrorUtility.errorMap;
//        WEXErrorUtility.getErrorMessage(testMap.get('one'));
//
//        //Program Util
//        WEXProgramUtility testProgUt = new WEXProgramUtility();
//        //Boolean testBoole2 = testProgUt.hasAnotherDefaultTermsAndConditionsSet(testCP);
//        testProgUt.hasDefaultTermsAndConditions(testProg.Id);
//        Boolean testBoole3 = testProgUt.isDefault(testCP);
//        //testProgUt.resetDefaultFlagForProgram(testCP);
//
//        PageReference errP = cont.CreditApplicationError();
//
//        SYSTEM.debug('brand error' + cont.errorMsg);
//
//        try{
//        //test campaignProgram delete trigger
//        delete testCP;
//        }
//        catch(SYSTEM.DmlException ex){
//            SYSTEM.assertEquals('The default Terms and Conditions cannot be deleted until a new default is selected.', ex.getDmlMessage(0), 'Trigger Message :');
//        }
//        test.stopTest();
//
//    }
}