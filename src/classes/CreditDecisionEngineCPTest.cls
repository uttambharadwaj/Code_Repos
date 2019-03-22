/*
*
* Credit Decisioning Process - Unit Tests
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/

@isTest
public class CreditDecisionEngineCPTest {

    @testSetup
    static void setupUser() {

        Account offerAccount = new Account();
        offerAccount.Name = 'TestAccount-01';

        insert offerAccount;

        //TODO skip offer??
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

        program.Name = 'CPTestBOCAX';
        program.Form_Template__c = 'CPBOCA';
        program.Brand_Short_Name__c = 'CPTESTX';
        program.Preferred_Language_Indicator__c = 'ENU';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        program.Brand_Long_Name__c = 'CP Test BOCA';
        program.Upload_Pricing_Data_Flag__c = false;
        program.Auto_Send_BOCA_to_Siebel__c = false;
        program.T_C__c = 'WEX_BOCA_TNC';
        program.Analytics_Body_Block__c = '';
        program.Analytics_Head_Block__c = '';
        program.Brand_Color_1__c = '#ccc';
        program.Brand_Color_2__c = '#fff';

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
        campaignProgram.Name = 'CP Test';
        campaignProgram.Campaign__c = campaign.Id;
        campaignProgram.Program__c = program.Id;
        campaignProgram.Terms_and_Conditions__c = 'Test T&C';
        campaignProgram.Default__c = true;

        insert campaignProgram;

        Boca_Res__c brandingUtility = new Boca_Res__c();
        brandingUtility.Email_Template_ID__c = '00X70000001EfPG';
        brandingUtility.Brand_Heading__c = 'CP Test Heading';
        brandingUtility.Brand_Tagline__c = 'CP Test Tagline';
        brandingUtility.ISO_code__c = 'en_us';
        brandingUtility.Program__c = program.id;
        brandingUtility.Side_Panel_Title__c = 'CP Test Sidebar Title';
        brandingUtility.SideBar__c = 'CP Test Sidebar';
        brandingUtility.Program_Name__c = program.Name;
        brandingUtility.Name = 'CPTest';
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

        List<CP_Application_Request__c> cpApplications = new List<CP_Application_Request__c>();

        for (Integer i = 0; i < 2; i++) {

            CP_Application_Request__c cpApplication = new CP_Application_Request__c();
            cpApplication.Email__c = 'dcraigmile@forseva.com';
            cpApplication.Company_Legal_Name__c = '';
            cpApplication.First_Name__c = 'Testy';
            cpApplication.Last_Name__c = 'McTesterson';
            cpApplication.Years_in_Business__c = '5';
            cpApplication.Business_Phone__c = '3123339999';
            cpApplication.Title__c = 'CEO';
            cpApplication.Projected_Monthly_Spend__c = 5000;
            cpApplication.Number_of_Cards__c = 20;
            cpApplication.Physical_Address_Line_1__c = '';
            cpApplication.Physical_Address_Line_2__c = '';
            cpApplication.Physical_City__c = '';
            cpApplication.Physical_State_Province__c = '';
            cpApplication.Physical_Postal_Code__c = '';
            cpApplication.Legal_Structure__c = '';
            cpApplication.Taxpayer_ID__c = '123456789';
            cpApplication.DUNS_Number__c = '123456789';
            cpApplication.Billing_Cycle__c = 'Weekly';
            cpApplication.Payment_Due_Date__c = 'Monday';
            cpApplication.Payment_Type__c = 'ET';
            cpApplication.Financial_Institution__c = 'Chase Bank';
            cpApplication.Checking_Account_Number__c = '';
            cpApplication.ABA_Routing_Number__c = '123456789';
            cpApplication.Guarantor_First_Name__c = 'George';
            cpApplication.Guarantor_Last_Name__c = 'Smiley';
            cpApplication.Guarantor_Residential_Address__c = '100 N. State';
            cpApplication.Guarantor_Residential_City__c = 'Chicago';
            cpApplication.Guarantor_State_Province__c = 'IL';
            cpApplication.Guarantor_Country__c = 'US';
            cpApplication.Guarantor_Residential_Postal_Code__c = '60603';
            cpApplication.Guarantor_Social_Security_Number__c = '123456789';
            cpApplication.Credit_Line_Requested__c = 5000;
            cpApplication.PG_Required__c = true;
            cpApplication.Application_Stage__c = 'Application';
            cpApplication.Status__c = 'Application Incomplete';
            cpApplication.OwnerId = UserInfo.getUserId();
            cpApplication.ThreatMetrix_Request_ID__c = '123456789';

            cpApplications.add(cpApplication);
        }

        insert cpApplications;

    }

    static testMethod void testCreditDecisionEngine() {

        User integrationUser = [SELECT Id FROM User WHERE Alias = 'sinte'];

        System.runas(integrationUser) {

            List<CP_Application_Request__c> cpApplications = [SELECT Id FROM CP_Application_Request__c];

            if (cpApplications.size() > 0) {

                Test.startTest();

                TestUtils.enable_isRunningTest = true;

                Test.setMock(HttpCalloutMock.class, new CalloutMock());

                CreditDecisionEngineCP.runCPDecisioningProcess(cpApplications[0].Id);

                Test.stopTest();

            }

        }

    }

    static testMethod void testCreditUtilCalculateCreditLine() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            CreditUtil_CalculateCreditLine cuccl = new CreditUtil_CalculateCreditLine();

            /** TEST: SBRI Risk Grade 1 and 2 */
            // test credit line requested is less than 25k
            cpApplications[0].Risk_Grade__c = '1';
            cpApplications[0].Credit_Line_Requested__c = 24000;
            upsert cpApplications[0];

            Decimal cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(24000, cp);

            // test credit line requested exceeds 25k but the high credit amount covers the amount requested
            cpApplications[0].Credit_Line_Requested__c = 30000;
            cpApplications[0].PG_Required__c = false;
            cpApplications[0].DNB_CSAD_High_Credit__c = 35000;
            cpApplications[0].DNB_Credit_Line_Recommendation__c = 30000;
            upsert cpApplications[0];

            cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(30000, cp);

            // test credit line requested exceeds 25k and the high credit amount does not cover amount requested
            cpApplications[0].Credit_Line_Requested__c = 30000;
            cpApplications[0].DNB_CSAD_High_Credit__c = 20000;
            upsert cpApplications[0];

            cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(20000, cp);

            /** TEST: SBRI Risk Grade 3 and 4 */
            // test credit line requested is less than 10k
            cpApplications[0].Risk_Grade__c = '3';
            cpApplications[0].Credit_Line_Requested__c = 8000;
            upsert cpApplications[0];

            cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(8000, cp);

            // test credit line requested exceeds 10k but high credit amount covers the amount requested
            cpApplications[0].Credit_Line_Requested__c = 30000;
            cpApplications[0].DNB_CSAD_High_Credit__c = 35000;
            upsert cpApplications[0];

            cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(30000, cp);

            // test credit line requested exceeds 10k and the high credit amount does not cover the amount requested
            cpApplications[0].Credit_Line_Requested__c = 30000;
            cpApplications[0].DNB_CSAD_High_Credit__c = 20000;
            upsert cpApplications[0];

            cp = (Decimal) cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);
            System.assertEquals(20000, cp);

            cuccl.postProcess();

            cuccl.preProcess(cpApplications, 'Test', 'Test');

        }

    }
//TODO CreditUtil_FraudCreditLineCheck only allows Online_Application__c - make into formula
    static testMethod void testFraudCreditLineCheck() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            CreditUtil_FraudCreditLineCheck cuccl = new CreditUtil_FraudCreditLineCheck();

            cuccl.getFunctionValue(null, new CP_Application_Request__c(Id = cpApplications[0].Id), 'String', 'String', 'String', cpApplications[0].Id);

            cuccl.postProcess();

            cuccl.preProcess(cpApplications, 'Test', 'Test');

        }

    }

    static testMethod void testExistingExposure() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            PageReference creditExistingExposure = Page.FindDupOnlineApps;

            creditExistingExposure.getParameters().put('id', cpApplications[0].Id);

            Test.setCurrentPage(creditExistingExposure);

            CreditExistingExposureController fdoac = new CreditExistingExposureController();

            fdoac.init();

            System.debug('duplication Account size = ' + fdoac.duplicateAccounts.size());
            System.debug('duplication Applications size = ' + fdoac.duplicateApplications.size());
            System.assert(fdoac.duplicateAccounts.size() == 0);
            System.assert(fdoac.duplicateApplications.size() >= 0);

        }

    }

    static testMethod void testThreatMetrixCallout() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id, ThreatMetrix_Request_ID__c FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            Test.setMock(HttpCalloutMock.class, new ThreatMetrixCalloutMock());

            CreditWS_ThreatMetrix.ThreatMetrixQueryRequest threatMetrixQueryRequest = new CreditWS_ThreatMetrix.ThreatMetrixQueryRequest();
            threatMetrixQueryRequest.threatMetrixRequestId = cpApplications[0].ThreatMetrix_Request_ID__c;
            CreditWS_ThreatMetrix.getThreatMetrixScore(threatMetrixQueryRequest);

            Test.stopTest();

        }

    }

    static testMethod void testLexisNexisBridgerBusinessCallout() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id, Taxpayer_ID__c, Company_Legal_Name__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c
        FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest request = new CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessRequest();

            request.companyName = cpApplications[0].Company_Legal_Name__c;

            request.addressLine1 = cpApplications[0].Physical_Address_Line_1__c;
            request.city = cpApplications[0].Physical_City__c;
            request.state = cpApplications[0].Physical_State_Province__c;
            request.postalCode = cpApplications[0].Physical_Postal_Code__c;

            request.ein = cpApplications[0].Taxpayer_ID__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerBusinessResponse response = CreditWS_LexisNexisBridger.bridgerSearchBusiness(request);

            Test.stopTest();

        }

    }

    static testMethod void testLexisNexisBridgerIndividualCallout() {

        List<CP_Application_Request__c> cpApplications = [SELECT Id, Guarantor_First_Name__c, Guarantor_Last_Name__c, Guarantor_Residential_Address__c, Guarantor_Residential_City__c, Guarantor_State_Province__c, Guarantor_Residential_Postal_Code__c, Guarantor_Date_of_Birth__c, Guarantor_Social_Security_Number__c
        FROM CP_Application_Request__c];

        if (cpApplications.size() > 0) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest request = new CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualRequest();

            request.firstName = cpApplications[0].Guarantor_First_Name__c;
            request.lastName = cpApplications[0].Guarantor_Last_Name__c;
            request.addressLine1 = cpApplications[0].Guarantor_Residential_Address__c;
            request.city = cpApplications[0].Guarantor_Residential_City__c;
            request.state = cpApplications[0].Guarantor_State_Province__c;
            request.postalCode = cpApplications[0].Guarantor_Residential_Postal_Code__c;
            request.dateOfBirth = cpApplications[0].Guarantor_Date_of_Birth__c;
            request.socialSecurityNumber = cpApplications[0].Guarantor_Social_Security_Number__c;

            CreditWS_LexisNexisBridger.LexisNexisBridgerIndividualResponse response = CreditWS_LexisNexisBridger.bridgerSearchIndividual(request);

            Test.stopTest();

        }

    }

    static testMethod void testDNBCustomModelCallout() {

        List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, DUNS_Number__c, Credit_Line_Requested__c FROM CP_Application_Request__c LIMIT 1];

        if (cpApplicationRequests.size() == 1) {

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CreditWS_DNB.DNBCPModelRequest dnbCPModelRequest = new CreditWS_DNB.DNBCPModelRequest();
            dnbCPModelRequest.DnB_DUNS_Number = cpApplicationRequests[0].DUNS_Number__c;

            CreditWS_DNB.DNBCPModelResponse dnbCPModelResponse = CreditWS_DNB.getCPScore(dnbCPModelRequest);

            Test.stopTest();

        }

    }

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

}