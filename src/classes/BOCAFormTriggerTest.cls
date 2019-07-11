/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
private class BOCAFormTriggerTest {

    static Program__c program { get; set; }
    static Campaign_Program__c campaignProgram { get; set; }
    static Campaign campaign { get; set; }
    static OnlineApplicationOffer__c onlineApplicationOffer { get; set; }

    @testSetup
    static void setup(){
       UtilityTestLoader.setAutomation(false);
    }

    public static void setupFuelCardBOCA() {

        User bocaUser = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

        BOCA_IDS__C bocaId = BOCAtestDataUtility.getBOCAids();
        bocaId.Email_Address__c = bocaUser.Username;
        insert bocaId;

        program = new Program__c();

        program.Name = 'TestBOCA';
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
        program.BOCA_Type__c = 'Fuel Card';

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

        campaign = new Campaign();

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

        campaignProgram = new Campaign_Program__c();

        //create campaign program test data
        campaignProgram.Name = 'Flex Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        // Publish the BOCA once the campaigns are all set
        program.Publish_BOCA__c = true;
        upsert program;


        PO_Box_Validation__c poBoxValidate = new PO_Box_Validation__c();
        poBoxValidate.po_box_formats__c = 'PO';
        insert poBoxValidate;

    }

    static testMethod void testWexBOCA() {

        User salesforceIntegration = [SELECT Id FROM User WHERE Name = 'Salesforce Integration'];

        System.debug('Found SFI User: ' + salesforceIntegration.Id);

        System.runAs(salesforceIntegration) {

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('r_WE_orchestraPageSupport');
            mock.setStatusCode(200); // Or other appropriate HTTP status code
            mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);

            TestUtils.enable_isRunningTest = true;

            setupFuelCardBOCA();

            WeFormObject__c we = new WeFormObject__c();

            we.Program__c = program.Id;

            we.Address_Line_2__c = 'Suite 100';
            we.Billing_Address_Line_2__c = 'Suite 100';
            we.Billing_City__c = 'Kingston';
            we.Billing_Contact_First_Name__c = 'Professional';
            we.Billing_Contact_Last_Name__c = 'Services';
            we.Billing_Email__c = 'ps@stantive.com';
            we.Billing_Fax__c = '';
            we.Billing_Phone__c = '613-555-5556';
            we.Billing_State__c = 'ON';
            we.Billing_Street_Address__c = '4 Cataraqui Street';
            we.Billing_Zip_Code__c = '62106';
            we.Business_fax__c = '613-555-5554';
            we.Business_Phone__c = '613-555-5555';
            we.Business_Street_Address__c = '123 Main Street';

            we.Date_of_Birth__c = '10/01/1986';
            we.PG_SSN__c = '123-45-6789';
            we.PG_Residential_Street_Address__c = '11 Awesome Street';
            we.PG_Residential_City__c = 'Adventure Land';
            we.PG_Residential_State__c = 'CA';
            we.PG_Residential_Zip__c = '43402';

            we.Campaign_Program_Id__c = campaignProgram.Id;
            we.City__c = 'Kingston';
            we.Company_Name__c = 'Stantive Technologies';
            we.Doing_Business_As__c = 'Stantive';
            we.Email__c = 'ps@stantive.com';
            we.Employee_Id__c = '1234';
            we.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
            we.First_Name__c = 'Professional';
            we.Fiscal_Year_Starts__c = 'Jan';
            we.Group_Code__c = 'ABC';
            we.How_did_you_hear_about_this_offer__c = 'Web';
            we.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
            we.Last_Name__c = 'Services';
            we.Legal_Structure__c = 'Corporation';
            we.Location_Code__c = 'NW';
            we.Promotional_Code__c = 'B1C';
            we.Sales_Id__c = '663434';
            we.Same_as_Business_Address__c = true;
            we.Signer_s_Email__c = 'ps@stantive.com';
            we.Signer_s_First_Name__c = 'Development';
            we.Signer_s_Last_Name__c = 'Services';
            we.Signer_s_Phone__c = '613-555-1111';
            we.signer_title__c = 'President';
            we.State__c = 'ON';
            we.Taxpayer_ID__c = '5664363';
            we.Years_in_Business__c = 'Less than 12 months';
            we.Zip_code__c = '62106';

            we.status__c = 'complete';

            try {
                upsert we;
            } catch (Exception e) {
                System.assertEquals(null, we.Id);
            }

            System.debug('### TEST DEBUG: weFormObject: ' + we.Id);

            System.assertNotEquals(null, we.Id);

            WeFormObject__c insertedCreditApp = [SELECT Id, Application_Request__c FROM WeFormObject__c WHERE Id = :we.Id];

            System.debug('### TEST DEBUG: weFormObject -> applicationRequest: ' + insertedCreditApp.Application_Request__c);

            System.assertNotEquals(null, insertedCreditApp.Application_Request__c);

            Test.stopTest();
        }

    }

    static testMethod void testIndividualBOCA() {

        User salesforceIntegration = [SELECT Id FROM User WHERE Name = 'Salesforce Integration'];

        System.debug('Found SFI User: ' + salesforceIntegration.Id);

        System.runAs(salesforceIntegration) {

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('r_WE_orchestraPageSupport');
            mock.setStatusCode(200); // Or other appropriate HTTP status code
            mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);

            TestUtils.enable_isRunningTest = true;

            setupFuelCardBOCA();

            WeFormObject__c creditApp = new WeFormObject__c();

            creditApp.Program__c = program.Id;

            creditApp.Email__c = 'testBoca@wexinc.com';
            creditApp.First_Name__c = 'Test';
            creditApp.Last_Name__c = 'Test';
            creditApp.Business_Phone__c = '207555555';
            creditApp.Company_Name__c = 'Test Company';
            creditApp.Doing_Business_As__c = 'Test Company';
            creditApp.Fleet_Size__c = 20;
            creditApp.Years_in_Business__c = 'Years';
            creditApp.Years_in_Business__c = '1';
            creditApp.Business_Street_Address__c = '123 Darling Ave';
            creditApp.Address_Line_2__c = 'Suite 2';
            creditApp.City__c = 'South Portland';
            creditApp.State__c = 'ME';
            creditApp.Zip_code__c = '04106';

            creditApp.Legal_Structure__c = 'Corporation';
            creditApp.Taxpayer_ID__c = '000000000';
            creditApp.Avg_Monthly_Fuel_Service_Expenses__c = 22222.00;
            creditApp.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
            creditApp.Fiscal_Year_Starts__c = 'January';

            creditApp.PG_SSN__c = '000-00-0000';
            creditApp.Date_of_Birth__c = '1/1/1986';
            creditApp.Guarantor_Annual_Income__c = 22222.00;
            creditApp.PG_Residential_Phone__c = '2075555555';
            creditApp.PG_Residential_Street_Address__c = '123 Darling Ave';
            creditApp.PG_Residential_City__c = 'South Portand';
            creditApp.PG_Residential_State__c = 'ME';
            creditApp.PG_Residential_Zip__c = '04106';

            creditApp.status__c = 'complete';

            try {
                upsert creditApp;
            } catch (Exception e) {
                System.assertEquals(null, creditApp.Id);
            }

            System.debug('### TEST DEBUG: weFormObject: ' + creditApp.Id);

            System.assertNotEquals(null, creditApp.Id);

            WeFormObject__c insertedCreditApp = [SELECT Id, Application_Request__c FROM WeFormObject__c WHERE Id = :creditApp.Id];

            System.debug('### TEST DEBUG: weFormObject -> applicationRequest: ' + insertedCreditApp.Application_Request__c);

            System.assertNotEquals(null, insertedCreditApp.Application_Request__c);

            Test.stopTest();
        }

    }

    // Want to ensure that no downstream workflows/etc enable instant decisioning if 
    // it is disabled at the Program level
    static testMethod void testNAFleetInstantDecisioningDisabled() {

        User salesforceIntegration = [SELECT Id FROM User WHERE Name = 'Salesforce Integration'];

        System.debug('Found SFI User: ' + salesforceIntegration.Id);

        System.runAs(salesforceIntegration) {

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('r_WE_orchestraPageSupport');
            mock.setStatusCode(200); // Or other appropriate HTTP status code
            mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);

            TestUtils.enable_isRunningTest = true;

            setupFuelCardBOCA();
            
            program.Disable_Instant_Decisioning__c = true;
            
            upsert program;

            WeFormObject__c creditApp = new WeFormObject__c();

            creditApp.Program__c = program.Id;

            creditApp.Email__c = 'testBoca@wexinc.com';
            creditApp.First_Name__c = 'Test';
            creditApp.Last_Name__c = 'Test';
            creditApp.Business_Phone__c = '207555555';
            creditApp.Company_Name__c = 'Test Company';
            creditApp.Doing_Business_As__c = 'Test Company';
            creditApp.Fleet_Size__c = 20;
            creditApp.Years_in_Business__c = 'Years';
            creditApp.Years_in_Business__c = '1';
            creditApp.Business_Street_Address__c = '123 Darling Ave';
            creditApp.Address_Line_2__c = 'Suite 2';
            creditApp.City__c = 'South Portland';
            creditApp.State__c = 'ME';
            creditApp.Zip_code__c = '04106';

            creditApp.Legal_Structure__c = 'Corporation';
            creditApp.Taxpayer_ID__c = '000000000';
            creditApp.Avg_Monthly_Fuel_Service_Expenses__c = 22222.00;
            creditApp.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
            creditApp.Fiscal_Year_Starts__c = 'January';

            creditApp.PG_SSN__c = '000-00-0000';
            creditApp.Date_of_Birth__c = '1/1/1986';
            creditApp.Guarantor_Annual_Income__c = 22222.00;
            creditApp.PG_Residential_Phone__c = '2075555555';
            creditApp.PG_Residential_Street_Address__c = '123 Darling Ave';
            creditApp.PG_Residential_City__c = 'South Portand';
            creditApp.PG_Residential_State__c = 'ME';
            creditApp.PG_Residential_Zip__c = '04106';

            creditApp.status__c = 'complete';

            try {
                upsert creditApp;
            } catch (Exception e) {
                System.assertEquals(null, creditApp.Id);
            }

            System.debug('### TEST DEBUG: weFormObject: ' + creditApp.Id);

            System.assertNotEquals(null, creditApp.Id);

            WeFormObject__c insertedCreditApp = [SELECT Id, Application_Request__c FROM WeFormObject__c WHERE Id = :creditApp.Id];

            System.debug('### TEST DEBUG: weFormObject -> applicationRequest: ' + insertedCreditApp.Application_Request__c);

            System.assertNotEquals(null, insertedCreditApp.Application_Request__c);
            
            List<Application_Request__c> applicationRequests = [SELECT Id, Application_Stage__c, Status__c FROM Application_Request__c WHERE Id =: insertedCreditApp.Application_Request__c];
            
            if(applicationRequests.size() > 0) {
                
                System.assertEquals(applicationRequests[0].Application_Stage__c, 'Application');
                System.assertEquals(applicationRequests[0].Status__c, 'Application Complete');
                
            }

            Test.stopTest();
        }

    }

}