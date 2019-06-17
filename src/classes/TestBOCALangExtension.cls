@isTest
private class TestBOCALangExtension {
  
    public static String cpId = '';
  	@testSetup public static void setupController(){
        
        UtilityTestLoader.setAutomation(false);
    
        BOCA_IDS__C bi = BOCAtestDataUtility.getBOCAids();
        insert bi;
        //Create a postcode record to validate against
        PostCode__c pc = new PostCode__c();
        pc.State__c = 'ME';
        pc.Postcode__c = '4101';
        insert pc;
        
        Campaign testCamp = new Campaign();
        
        //create campaign test data
        testCamp.Coupon_Code__c = 'A001';
        testCamp.Name = 'testBOCA123';
        testCamp.Type = 'Online Form';
        testCamp.Status = 'In Progress';
        testCamp.Drop_Date__c = date.today();
        testCamp.EndDate = date.today();
        testCamp.CurrencyIsoCode = 'USD';
        testCamp.IsActive = true;
        
        insert testCamp;
        SYSTEM.debug('Here is campaign ' + testCamp.Id);
        //testCamp = [SELECT Id, Name, Coupon_Code__c, IsActive FROM Campaign WHERE Name =: 'testBOCA123'];
        //SYSTEM.debug('here is camp in q: ' + testCamp);
        Campaign_Pricing__c pric = new Campaign_Pricing__c();
        pric.Name = 'test';
        pric.contract_margin__c = 'Y';
        pric.penalty_margin__c = 'Y';
        pric.days_to_pay__c = 21;
        pric.prime_rate__c = 3.25;
        pric.prime_rate_effective_date__c = date.today();
        pric.late_fee_type__c = 'P';
        pric.return_payment_fee__c = 49.99;
        pric.over_limit_fee__c = 39.99;
        pric.paper_delivery_fee__c = 5.00;
        pric.penalty_rate_ceiling__c = 999.99;
        pric.minimum_payment_percentage__c = 29.99;
        pric.Peoplesoft_rel_code__c = '012011';
        pric.coup_code__c = 'A001';
        pric.is_Active__c = true;
        pric.Coupon_Status__c = 'valid';
        pric.risk_code__c = 'No';
        pric.nbr_billing_cyles__c = '1';
        pric.contract_rate_pct__c = 10.15;
        pric.fixed_late_fee__c = 0.00;
        pric.pct_late_fee__c = 2.49;
        pric.pen_rate_pct__c = 27.34;
        pric.promo_periods__c = 1.0;
        pric.promotional_rate__c = 8.17;
        pric.CurrencyIsoCode = 'USD';
        
        insert pric;

        Program__c testProg2 = new Program__c();
        
        testProg2.Name = 'testFlex2';
        testProg2.Form_Template__c = 'WexBOCA';
        testProg2.Brand_Short_Name__c = 'flex2';
        testProg2.Preferred_Language_Indicator__c = 'ENU';
        testProg2.Peoplesoft_rel_code__c = '0001207';
        testProg2.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        testProg2.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        testProg2.Brand_Long_Name__c = 'flex test card';
        testProg2.Section_Titles__c = 'Tell Us About Your Business; Billing Contact Information; Promotional Information; Statement & Report Delivery; Tell Us About Yourself; Authorization; Terms & Conditions';  
        testProg2.Upload_Pricing_Data_Flag__c = false;
        testProg2.Auto_Send_BOCA_to_Siebel__c = true;
        testProg2.T_C__c = 'WEX_BOCA_TNC';
        testProg2.Analytics_Body_Block__c = '';
        testProg2.Analytics_Head_Block__c = '';
        testProg2.Brand_Color_1__c = '#ccc';
        testProg2.Brand_Color_2__c = '#fff';
        
        //remove the below once the BOCAcontroller code has been refactored with the old BOCAcontroller
        testProg2.Brand_Heading__c = 'removethis';
        testProg2.Brand_Long_Name__c = 'removethis';
        testProg2.Brand_Tagline__c = '';
        
        
        insert testProg2;
        //attachments
        Attachment attach3 = new Attachment();
        attach3.Name = 'ui-credit-card.png';
        Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
        attach3.body=bodyBlob3;
        attach3.parentId=testProg2.id;
        insert attach3;
        
        Attachment attach4 = new Attachment();
        attach4.Name = 'ui-logo.png';
        Blob bodyBlob4=Blob.valueOf('Unit Test Attachment Body');
        attach4.body=bodyBlob4;
        attach4.parentId=testProg2.id;
        insert attach4;
        SYSTEM.debug('Here is program ' + testProg2.id);
        
        Campaign_Program__c testCP = new Campaign_Program__c();
        //create campaign program test data
        testCP.Name = 'Flex Test';
        testCP.Campaign__c = testCamp.Id;
        testCP.Program__c = testProg2.Id;
        testCP.Terms_and_Conditions__c = 'Test T&C';
        testCP.Default__c = true;
        
        insert testCP;
        cpId = testCP.Id;
        
        Boca_Res__c bocaRes = new Boca_Res__c();
        bocaRes.Email_Template_ID__c = '00X70000001EfPG';
        bocaRes.Brand_Heading__c = 'Test Heading';
        bocaRes.Brand_Tagline__c = 'Test Tagline';
        bocaRes.ISO_code__c = 'en_us';
        bocaRes.Program__c = testProg2.id;
        bocaRes.Side_Panel_Title__c = 'Test Sidebar Title';
        bocaRes.SideBar__c = 'Test Sidebar';
        bocaRes.Program_Name__c = testProg2.Name;
        bocaRes.Name = 'test';
        bocaRes.Program_Sell_Sheets__c = 'www.sellsheet.com';
        
        insert bocaRes;
        SYSTEM.debug('Here is bocaRes ' + bocaRes.id);
      
        Boca_Res__c bocaRes2 = new Boca_Res__c();
        bocaRes2.Email_Template_ID__c = '00X70000001EfPG';
        bocaRes2.Brand_Heading__c = 'Test Heading';
        bocaRes2.Brand_Tagline__c = 'Test Tagline';
        bocaRes2.ISO_code__c = 'fr';
        bocaRes2.Program__c = testProg2.id;
        bocaRes2.Side_Panel_Title__c = 'Test Sidebar Title';
        bocaRes2.SideBar__c = 'Test Sidebar';
        bocaRes2.Program_Name__c = testProg2.Name;
        bocaRes2.Name = 'test2';
        
        insert bocaRes2;
        
        testProg2.Publish_BOCA__c = true;
        upsert testProg2;
        
        testCamp.Coupon_Code__c = pric.coup_code__c;
        upsert testCamp;
        
    }
        
    public static WeFormObject__c setupApp(){
        WeFormObject__c we1 = new WeFormObject__c();
        we1.Address_Line_2__c = 'Suite 100';
        we1.Billing_Address_Line_2__c = 'Suite 100';
        we1.Billing_City__c = 'Portland';
        we1.Billing_Contact_First_Name__c = 'Professional';
        we1.Billing_Contact_Last_Name__c = 'Services';
        we1.Billing_Email__c = 'ps@stantive.com';
        we1.Billing_Fax__c = '555-555-5555';
        we1.Annual_Gross_Revenue__c = 100000.00;
        we1.Avg_Monthly_Fuel_Service_Expenses__c = 10000.00;
        we1.Billing_Phone__c = '613-555-5556';
        we1.Billing_State__c = 'ME';
        we1.Billing_Street_Address__c = '4 Cataraqui Street';
        we1.Billing_Zip_Code__c = '04101';
        we1.Business_fax__c = '613-555-5554';
        we1.Business_Phone__c = '613-555-5555';
        we1.Business_Street_Address__c = '4 Cataraqui Street';
        we1.Date_of_Birth__c = '10/01/1986';
        we1.PG_SSN__c = '123-45-6789';
        we1.PG_Residential_Street_Address__c = '11 Awesome Street';
        we1.PG_Residential_City__c = 'Portland';
        we1.PG_Residential_State__c = 'ME';
        we1.PG_Residential_Zip__c = '04101'; 
        we1.Email__c = 'test@test.com';
        we1.City__c = 'Portland';
        we1.Company_Name__c = 'Stantive Technologies';
        we1.Doing_Business_As__c = 'Stantive';
        we1.Employee_Id__c = '1234';
        we1.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
        we1.First_Name__c = 'Professional';
        we1.Fiscal_Year_Starts__c = 'January';
        we1.Group_Code__c = 'ABC';
        we1.How_did_you_hear_about_this_offer__c = 'Web';
        we1.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
        we1.Paperless_Flag__c = 'Yes';
        we1.Last_Name__c = 'Services';
        we1.Legal_Structure__c = 'Corporation';
        we1.Location_Code__c = 'NW';
        we1.Fleet_Size__c = 10;
        we1.Promotional_Code__c = 'B1C';
        we1.Sales_Id__c = '663434';
        we1.Same_as_Business_Address__c = true;
        we1.Signer_s_Email__c = 'ps@stantive.com';
        we1.Signer_s_First_Name__c = 'Development';
        we1.Signer_s_Last_Name__c = 'Services';
        we1.Signer_s_Phone__c = '613-555-1111';
        we1.signer_title__c = 'President';
        we1.State__c = 'ME';
        we1.Taxpayer_ID__c = '566436312';
        we1.Years_in_Business__c = '17';
        we1.Zip_code__c = '04101';
        we1.Email__c = 'tester@unitTest.com';
        we1.PG_Residential_Phone__c = '555-555-5555';
        we1.Mobile_Phone__c = '555-555-5555';
        we1.Guarantor_Annual_Income__c = 1000000.00;
        
        return we1;
        
    }
    public class CustomHttpCalloutMock implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req)
        {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            return retVal;
        }
    }
      @future (callout=true)
        public static void calloutOnsubmit() {
        test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock());
        
    }
      
    @isTest static void testLanguageExtensions() {
        
        test.startTest();
        BOCAcontroller cont =  new BOCAcontroller();
        
        PageReference testPage = new PageReference('/apex/WexBOCA?pgm=flex2&lang=en_us&lc=ne');
        Test.setCurrentPage(testPage);
        
        BOCALangExtension ble = new BOCALangExtension(cont);
        
        System.assertEquals('WexBOCA', ble.currentPageName);
        System.assertEquals('en_us', ble.lang);
        System.assertEquals('flex2', ble.pgm);
        System.assertEquals('Submit Application', ble.BOCAText.get('button1'));
        System.assertEquals('testFlex2', ble.displayName);
        System.assertEquals('Test Heading', ble.heading);
        System.assertNotEquals('', ble.disclosure);
        System.assertNotEquals('', ble.termandcondition);
        System.assertEquals('Test Tagline', ble.tagline);
        System.assertEquals('Test Sidebar Title', ble.sidebarTitle);
        System.assertEquals('Test Sidebar', ble.sidebar);
        
        System.assertNotEquals('', ble.emailTemplate);
        
		testPage = new PageReference('/apex/WexBOCA?pgm=flex2&lang=fr&lc=ne');
        Test.setCurrentPage(testPage);
        
        System.assertEquals('en cours', ble.BOCAText.get('message1'));
        
        testPage = new PageReference('/apex/CreditApp_Revolver?pgm=flex2&lang=en_us&lc=ne');
        Test.setCurrentPage(testPage);
        
        System.assertNotEquals('', ble.BOCAText.get('html1'));
        
        test.stopTest();
        
    }

}