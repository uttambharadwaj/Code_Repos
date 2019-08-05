/* *************************
    Purpose:
        Tests for AccountAndCardsToGenesis_ExCon extension controller.
        Also exercises underlying WSUtil_Genesis_AccountServices.

        Note: SeeAllData is true in order to access Custom Settings

    History:
        01-May-2014 M.Erwin (Salesforce.com)    Created
        17-May-2015 B.Sotoudeh (WEX AU)    Added new classes
************************* */

@isTest
private class AccountAndCardsToGenesis_ExConTest {

    @isTest static void accountFails() {
        // Set up test data
        Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> accRtMapByName = accountSobject.getRecordTypeInfosByName();
        Id accAuFuelCustomerRtId = accRtMapByName.get('AU Fuel/Trade Customer').getRecordTypeId();
        Account testAcc = new Account();
        testAcc.Name = 'accountFails';
        testAcc.RecordTypeId = accAuFuelCustomerRtId;
        testAcc.AU_ABN__c = '123456789';
        testAcc.AU_ACN__c = '123456783';
        testAcc.Account_Email_Address__c = 'testing@test.com';
        testAcc.BillingStreet = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.BillingCity = 'Melbourne';
        testAcc.BillingPostalCode = '3000';
        testAcc.BillingState = 'VIC';
        testAcc.AU_Business_Structure__c = '01: Private Company';
        testAcc.AU_Business_Trading_Name__c = 'Testing';
        testAcc.Client_Reference__c = 'testing';
        testAcc.AU_Date_Business_Commenced__c = System.today().addDays(-3650);
        testAcc.Industry = 'Recreation/Sport';
        testAcc.AU_Postal_Address__c = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.AU_Postal_Suburb__c = 'Melbourne';
        testAcc.AU_Postal_Postcode__c = '3000';
        testAcc.AU_Postal_State__c = 'VIC';
        testAcc.AU_Trustee__c = 'Testing';
        testAcc.Account_Card_Dispatch_Address_1__c = 'Disrupt American Apparel High Life,';
        testAcc.Account_Card_Dispatch_Address_2__c = 'Cosby sweater literally YOLO';
        testAcc.Account_Card_Dispatch_Suburb__c = 'Melbourne';
        testAcc.Account_Card_Dispatch_Postcode__c = 3000;
        testAcc.Account_Card_Dispatch_State__c = 'VIC';
        testAcc.AU_GST_Required__c = true;

        insert testAcc;

        Schema.DescribeSObjectResult contactSobject = Contact.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> conRtMapByName = contactSobject.getRecordTypeInfosByName();
        Id conAuFuelCustomerRtId = conRtMapByName.get('AU Contact').getRecordTypeId();
        Contact testCon = new Contact();
        testCon.FirstName = 'accountFails';
        testCon.LastName = 'accountFails';
        testCon.AccountId = testAcc.Id;
        testCon.RecordTypeId = conAuFuelCustomerRtId;
        testCon.Email = 'testing@test.com';
        testCon.Fax = '03 1234 5000';
        testCon.Salutation = 'Mr';
        testCon.FirstName = 'Jolly';
        testCon.LastName = 'Roger';
        testCon.MobilePhone = '0410 123 456';
        testCon.Phone = '03 1234 5678';

        insert testCon;

        Schema.DescribeSObjectResult oppSobject = Opportunity.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> oppRtMapByName = oppSobject.getRecordTypeInfosByName();
        Id oppAuFuelDirectRtId = oppRtMapByName.get('AU Fuel Direct').getRecordTypeId();
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'accountFails';
        testOpp.CloseDate = System.today() + 10;
        testOpp.StageName = '1) Qualified';
        testOpp.RecordTypeId = oppAuFuelDirectRtId;
        testOpp.AccountId = testAcc.Id;
        testOpp.Primary_Contact__c = testCon.Id;
        testOpp.Pricing_Approval_Received__c = true;
        testOpp.Opportunity_Status__c = 'Pricing Approved';
        testOpp.AU_Will_supply_credit_documents__c = 'Y';
        testOpp.AU_Account_PIN_Setting__c = 'O: Optional';
        testOpp.Area_Manager__c = 'KJ';
        testOpp.Bank_Account_Name__c = 'Testing';
        testOpp.Bank_Account_Number__c = 'Testing';
        testOpp.BAS_Email_Address__c = 'testing@test.com';
        testOpp.AU_BSB__c = '012004';
        testOpp.Billing_Frequency__c = 'A: 1st of the month';
        testOpp.AU_Drivers_Licence_No__c = 'testing';
        testOpp.AU_Date_of_Birth__c = System.today().addDays(-10950);
        testOpp.Paper_Statements__c = false;
        testOpp.AU_Email_PIN_Notification__c = 'Y';
        testOpp.AU_Employer_Phone__c = '03 1234 5678';
        testOpp.AU_Employment_Commenced__c = System.today().addDays(-800);
        testOpp.Exception_Level_Reporting__c = 'Account';
        testOpp.AU_Exception_Reporting_Email_Address_1__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_2__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_3__c = 'testing@test.com';
        testOpp.AU_Financial_Institution__c = 'Testing';
        testOpp.AU_Financial_Institution_Suburb__c = 'Melbourne';
        testOpp.Group_Code__c = 'TEST';
        testOpp.AU_Joining_Fee_Override__c = 12.00;
        testOpp.AU_Monthly_Card_Fee__c = 20.00;
        testOpp.AU_Merchant_Incentive_Reference_Number__c = 'Testing';
        testOpp.LeadSource = 'Existing Motorpass Customer';
        testOpp.Product_Type__c = 'Motorpass';
        testOpp.AU_Reporting_odometer_Incorrect__c = true;
        testOpp.AU_Reporting_Odometer_Missing__c = true;
        testOpp.BAS_Reporting_Type__c = 'E';
        testOpp.Promotional_Code__c = 'TEST';
        testOpp.AU_Sales_Channel__c = 'Inbound Team';
        testOpp.Submitted_For_Assessment_Date_Time__c = System.today().addDays(-2);
        testOpp.AU_Title__c = 'Chief Sweeper';
        //      testOpp.Wholesaler_Discount_Code_1__c = 'GOLD1';
        //      testOpp.Discount_Code_1_Start_Date__c = date.today();
        //      testOpp.Discount_Code_1_End_Date__c = date.today().addDays(7);
        //      testOpp.Wholesaler_Discount_Code_2__c = 'SILVER';        
        //      testOpp.Discount_Code_2_Start_Date__c = date.today();
        //      testOpp.Discount_Code_2_End_Date__c = date.today().addDays(7);

        insert testOpp;

        Schema.DescribeSObjectResult auApplicationSobject = AU_Application_Request__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> appRtMapByName = auApplicationSobject.getRecordTypeInfosByName();
        Id appAuRtId = appRtMapByName.get('AU Application Request').getRecordTypeId();
        AU_Application_Request__c testApp = new AU_Application_Request__c();
        testApp.Opportunity__c = testOpp.Id;
        testApp.Account__c = testAcc.Id;
        testApp.RecordTypeId = appAuRtId;
        testApp.Credit_Limit__c = 3000;
        testApp.Application_Status__c = 'Pending Assessment';
        testApp.Approval_Status__c = 'Approved';
        testApp.Positive_Balance_Account__c = true;
        testApp.Positive_Balance_Account_Credit__c = true;
        testApp.Positive_Balance_Limit__c = 500;
        insert testApp;

        Test.startTest();
        WS_Testing_Util.TEST_PATH_ACCOUNT_PASS = false;
        Test.setMock(WebServiceMock.class, new WS_Genesis_AccountServicesMock());
        Test.setCurrentPage(Page.AccountAndCardsToGenesis);
        ApexPages.StandardController standardController = new ApexPages.StandardController(testApp);
        AccountAndCardsToGenesis_ExCon accountAndCardsToGenesisController = new AccountAndCardsToGenesis_ExCon(standardController);
        PageReference pageRef = accountAndCardsToGenesisController.submitAccountAndCards();
        Test.stopTest();
    }
    @isTest static void accountSucceedsCardsSucceed() {
        // Set up test data
        Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> accRtMapByName = accountSobject.getRecordTypeInfosByName();
        Id accAuFuelCustomerRtId = accRtMapByName.get('AU Fuel/Trade Customer').getRecordTypeId();
        Account testAcc = new Account();
        testAcc.Name = 'accountSucceedsCardsSucceed';
        testAcc.RecordTypeId = accAuFuelCustomerRtId;
        testAcc.AU_ABN__c = '123456789';
        testAcc.AU_ACN__c = '123456783';
        testAcc.Account_Email_Address__c = 'testing@test.com';
        testAcc.BillingStreet = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.BillingCity = 'Melbourne';
        testAcc.BillingPostalCode = '3000';
        testAcc.BillingState = 'VIC';
        testAcc.AU_Business_Structure__c = '01: Private Company';
        testAcc.AU_Business_Trading_Name__c = 'Testing';
        testAcc.Client_Reference__c = 'testing';
        testAcc.AU_Date_Business_Commenced__c = System.today().addDays(-3650);
        testAcc.Industry = 'Recreation/Sport';
        testAcc.AU_Postal_Address__c = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.AU_Postal_Suburb__c = 'Melbourne';
        testAcc.AU_Postal_Postcode__c = '3000';
        testAcc.AU_Postal_State__c = 'VIC';
        testAcc.AU_Trustee__c = 'Testing';
        testAcc.Account_Card_Dispatch_Address_1__c = 'Disrupt American Apparel High Life,';
        testAcc.Account_Card_Dispatch_Address_2__c = 'Cosby sweater literally YOLO';
        testAcc.Account_Card_Dispatch_Suburb__c = 'Melbourne';
        testAcc.Account_Card_Dispatch_Postcode__c = 3000;
        testAcc.Account_Card_Dispatch_State__c = 'VIC';
        testAcc.AU_GST_Required__c = true;

        insert testAcc;

        Schema.DescribeSObjectResult contactSobject = Contact.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> conRtMapByName = contactSobject.getRecordTypeInfosByName();
        Id conAuFuelCustomerRtId = conRtMapByName.get('AU Contact').getRecordTypeId();
        Contact testCon = new Contact();
        testCon.FirstName = 'accountSucceedsCardsSucceed';
        testCon.LastName = 'accountSucceedsCardsSucceed';
        testCon.AccountId = testAcc.Id;
        testCon.RecordTypeId = conAuFuelCustomerRtId;
        testCon.Email = 'testing@test.com';
        testCon.Fax = '03 1234 5000';
        testCon.Salutation = 'Mr';
        testCon.FirstName = 'Jolly';
        testCon.LastName = 'Roger';
        testCon.MobilePhone = '0410 123 456';
        testCon.Phone = '03 1234 5678';

        insert testCon;

        Schema.DescribeSObjectResult oppSobject = Opportunity.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> oppRtMapByName = oppSobject.getRecordTypeInfosByName();
        Id oppAuFuelDirectRtId = oppRtMapByName.get('AU Fuel Direct').getRecordTypeId();
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'accountSucceedsCardsSucceed';
        testOpp.CloseDate = System.today() + 10;
        testOpp.StageName = '1) Qualified';
        testOpp.RecordTypeId = oppAuFuelDirectRtId;
        testOpp.AccountId = testAcc.Id;
        testOpp.Primary_Contact__c = testCon.Id;
        testOpp.Pricing_Approval_Received__c = true;
        testOpp.Opportunity_Status__c = 'Pricing Approved';
        testOpp.AU_Will_supply_credit_documents__c = 'Y';
        testOpp.AU_Account_PIN_Setting__c = 'O: Optional';
        testOpp.Area_Manager__c = 'KJ';
        testOpp.Bank_Account_Name__c = 'Testing';
        testOpp.Bank_Account_Number__c = 'Testing';
        testOpp.BAS_Email_Address__c = 'testing@test.com';
        testOpp.AU_BSB__c = '012004';
        testOpp.Billing_Frequency__c = 'A: 1st of the month';
        testOpp.AU_Drivers_Licence_No__c = 'testing';
        testOpp.AU_Date_of_Birth__c = System.today().addDays(-10950);
        testOpp.Paper_Statements__c = false;
        testOpp.AU_Email_PIN_Notification__c = 'Y';
        testOpp.AU_Employer_Phone__c = '03 1234 5678';
        testOpp.AU_Employment_Commenced__c = System.today().addDays(-800);
        testOpp.Exception_Level_Reporting__c = 'Account';
        testOpp.AU_Exception_Reporting_Email_Address_1__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_2__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_3__c = 'testing@test.com';
        testOpp.AU_Financial_Institution__c = 'Testing';
        testOpp.AU_Financial_Institution_Suburb__c = 'Melbourne';
        testOpp.Group_Code__c = 'TEST';
        testOpp.AU_Joining_Fee_Override__c = 12.00;
        testOpp.AU_Monthly_Card_Fee__c = 20.00;
        testOpp.AU_Merchant_Incentive_Reference_Number__c = 'Testing';
        testOpp.LeadSource = 'Internet OA';
        testOpp.AU_Sales_Channel__c = 'Internet OA';
        testOpp.Product_Type__c = 'Motorpass';
        testOpp.AU_Reporting_odometer_Incorrect__c = true;
        testOpp.AU_Reporting_Odometer_Missing__c = true;
        testOpp.BAS_Reporting_Type__c = 'E';
        testOpp.Promotional_Code__c = 'TEST';

        testOpp.Submitted_For_Assessment_Date_Time__c = System.today().addDays(-2);
        testOpp.AU_Title__c = 'Chief Sweeper';
        //      testOpp.Wholesaler_Discount_Code_1__c = 'GOLD1';
        //      testOpp.Discount_Code_1_Start_Date__c = date.today();
        //      testOpp.Discount_Code_1_End_Date__c = date.today().addDays(7);
        //      testOpp.Wholesaler_Discount_Code_2__c = 'SILVER';        
        //      testOpp.Discount_Code_2_Start_Date__c = date.today();
        //      testOpp.Discount_Code_2_End_Date__c = date.today().addDays(7);
        insert testOpp;

        Schema.DescribeSObjectResult auApplicationSobject = AU_Application_Request__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> appRtMapByName = auApplicationSobject.getRecordTypeInfosByName();
        Id appAuRtId = appRtMapByName.get('AU Application Request').getRecordTypeId();
        AU_Application_Request__c testApp = new AU_Application_Request__c();
        testApp.Opportunity__c = testOpp.Id;
        testApp.Account__c = testAcc.Id;
        testApp.RecordTypeId = appAuRtId;
        testApp.Credit_Limit__c = 3000;
        testApp.Application_Status__c = 'Pending Assessment';
        testApp.Approval_Status__c = 'Approved';
        testApp.Positive_Balance_Account__c = true;
        testApp.Positive_Balance_Account_Credit__c = true;
        testApp.Positive_Balance_Limit__c = 500;
        insert testApp;

        Schema.DescribeSObjectResult cardSobject = AU_Card_Details__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> cardRtMapByName = cardSobject.getRecordTypeInfosByName();
        Id cardAuFuelRtId = cardRtMapByName.get('AU Fuel Business').getRecordTypeId();
        List<AU_Card_Details__c> testcards = new List<AU_Card_Details__c>();
        for (Integer counter = 0; counter < 151; counter++) {
            AU_Card_Details__c auCard = new AU_Card_Details__c();
            aucard.Opportunity__c = testOpp.Id;
            auCard.Account__c = testAcc.Id;
            auCard.AU_Additional_Card_Text__c = 'accYesCardYes';
            auCard.BAS_Flag__c = true;
            auCard.BAS_Reporting_Fee_Override__c = 12.00;
            auCard.Card_Bulk_PIN__c = '0123';
            auCard.Card_Controls__c = 'Fuel & Oil Only';
            auCard.AU_Card_Dispatch_Address_1__c = 'Disrupt American Apparel High Life';
            auCard.AU_Card_Dispatch_Address_2__c = 'flexitarian synth chambray. Etsy';
            auCard.AU_Card_Dispatch_Address_Suburb__c = 'Melbourne';
            auCard.Card_Dispatch_Address_State__c = 'VIC';
            auCard.AU_Card_Dispatch_Address_Postcode__c = '3000';
            auCard.AU_card_PIN_setting__c = 'O: Optional';
            auCard.Card_Type__c = 'MP: Motorpass';
            auCard.AU_Cost_Centre_Code__c = '123456789012';
            auCard.AU_Cost_Centre_Description__c = 'Testing Cost Centre';
            auCard.AU_Drivers_Name__c = 'Test Test';
            auCard.AU_Card_Holder_Diesel_Card_Marketing_Are__c = 'MELB: Melbourne Metro, VIC; NQLD: North QLD';
            auCard.AU_Card_Holder_email_address__c = 'testing@test.com';
            auCard.AU_Cardholder_Mobile_Phone_Number__c = '0408 123 456';
            auCard.Cardholder_Employer_Name__c = 'Test Limited';
            auCard.Express_Delivery__c = true;
            auCard.Odometer_Required__c = true;
            auCard.Product_Restriction_Groups__c = '20: Unleaded; 80: Insurance';
            auCard.AU_Reference_Required__c = true;
            auCard.Roadside_Assist_Fee_Frequency__c = 'M';
            auCard.Roadside_Assist_Fee_Override__c = 54321;
            auCard.Roadside_Assist_Key_Code__c = 54321;
            auCard.Roadside_Assist_VIN__c = 'Testing VIN';
            auCard.AU_Signature_Strip__c = true;
            auCard.Site_Restriction__c = 'TESTS';
            auCard.AU_Vehicle_Registration__c = 'Testing';
            auCard.AU_Vehicle_Make__c = 'Test';
            auCard.AU_Vehicle_Model__c = 'Test';
            auCard.Vehicle_Body_Type__c = 'Test';
            auCard.Vehicle_Year__c = 2014;
            auCard.Vehicle_Colour__c = 'OARSUM';
            testcards.add(auCard);
        }
        testcards[0].Card_Controls__c = 'All Vehicle Expenses';
        testcards[1].Card_Controls__c = 'All Expenses';
        insert testcards;

        Test.startTest();
        WS_Testing_Util.TEST_PATH_ACCOUNT_PASS = true;
        WS_Testing_Util.TEST_PATH_CARD_PASS = true;
        Test.setMock(WebServiceMock.class, new WS_Genesis_AccountServicesMock());
        Test.setCurrentPage(Page.AccountAndCardsToGenesis);
        ApexPages.StandardController standardController = new ApexPages.StandardController(testApp);
        AccountAndCardsToGenesis_ExCon accountAndCardsToGenesisController = new AccountAndCardsToGenesis_ExCon(standardController);
        PageReference pageRef = accountAndCardsToGenesisController.submitAccountAndCards();
        Test.stopTest();
    }
    @isTest static void accountSucceedsCardsFail() {
        // Set up test data
        Schema.DescribeSObjectResult accountSobject = Account.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> accRtMapByName = accountSobject.getRecordTypeInfosByName();
        Id accAuFuelCustomerRtId = accRtMapByName.get('AU Fuel/Trade Customer').getRecordTypeId();
        Account testAcc = new Account();
        testAcc.Name = 'accountSucceedsCardsFail';
        testAcc.RecordTypeId = accAuFuelCustomerRtId;
        testAcc.AU_ABN__c = '123456789';
        testAcc.AU_ACN__c = '123456783';
        testAcc.Account_Email_Address__c = 'testing@test.com';
        testAcc.BillingStreet = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.BillingCity = 'Melbourne';
        testAcc.BillingPostalCode = '3000';
        testAcc.BillingState = 'VIC';
        testAcc.AU_Business_Structure__c = '01: Private Company';
        testAcc.AU_Business_Trading_Name__c = 'Testing';
        testAcc.Client_Reference__c = 'testing';
        testAcc.AU_Date_Business_Commenced__c = System.today().addDays(-3650);
        testAcc.Industry = 'Recreation/Sport';
        testAcc.AU_Postal_Address__c = 'Disrupt American Apparel High Life, Cosby sweater literally YOLO gentrify four loko occupy before they sold out' +
            ' flexitarian synth chambray. Etsy butcher kogi YOLO fanny pack roof party church-key, banh mi bicycle rights scenester cray mixtape paleo.';
        testAcc.AU_Postal_Suburb__c = 'Melbourne';
        testAcc.AU_Postal_Postcode__c = '3000';
        testAcc.AU_Postal_State__c = 'VIC';
        testAcc.AU_Trustee__c = 'Testing';
        testAcc.Account_Card_Dispatch_Address_1__c = 'Disrupt American Apparel High Life,';
        testAcc.Account_Card_Dispatch_Address_2__c = 'Cosby sweater literally YOLO';
        testAcc.Account_Card_Dispatch_Suburb__c = 'Melbourne';
        testAcc.Account_Card_Dispatch_Postcode__c = 3000;
        testAcc.Account_Card_Dispatch_State__c = 'VIC';
        testAcc.AU_GST_Required__c = true;

        insert testAcc;

        Schema.DescribeSObjectResult contactSobject = Contact.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> conRtMapByName = contactSobject.getRecordTypeInfosByName();
        Id conAuFuelCustomerRtId = conRtMapByName.get('AU Contact').getRecordTypeId();
        Contact testCon = new Contact();
        testCon.FirstName = 'accountSucceedsCardsFail';
        testCon.LastName = 'accountSucceedsCardsFail';
        testCon.AccountId = testAcc.Id;
        testCon.RecordTypeId = conAuFuelCustomerRtId;
        testCon.Email = 'testing@test.com';
        testCon.Fax = '03 1234 5000';
        testCon.Salutation = 'Mr';
        testCon.FirstName = 'Jolly';
        testCon.LastName = 'Roger';
        testCon.MobilePhone = '0410 123 456';
        testCon.Phone = '03 1234 5678';

        insert testCon;

        Schema.DescribeSObjectResult oppSobject = Opportunity.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> oppRtMapByName = oppSobject.getRecordTypeInfosByName();
        Id oppAuFuelDirectRtId = oppRtMapByName.get('AU Fuel Direct').getRecordTypeId();
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'accountSucceedsCardsFail';
        testOpp.CloseDate = System.today() + 10;
        testOpp.StageName = '1) Qualified';
        testOpp.RecordTypeId = oppAuFuelDirectRtId;
        testOpp.AccountId = testAcc.Id;
        testOpp.Primary_Contact__c = testCon.Id;
        testOpp.Pricing_Approval_Received__c = true;
        testOpp.Opportunity_Status__c = 'Pricing Approved';
        testOpp.AU_Will_supply_credit_documents__c = 'Y';
        testOpp.AU_Account_PIN_Setting__c = 'O: Optional';
        testOpp.Area_Manager__c = 'KJ';
        testOpp.Bank_Account_Name__c = 'Testing';
        testOpp.Bank_Account_Number__c = 'Testing';
        testOpp.BAS_Email_Address__c = 'testing@test.com';
        testOpp.AU_BSB__c = '012004';
        testOpp.Billing_Frequency__c = 'A: 1st of the month';
        testOpp.AU_Drivers_Licence_No__c = 'testing';
        testOpp.AU_Date_of_Birth__c = System.today().addDays(-10950);
        testOpp.Paper_Statements__c = false;
        testOpp.AU_Email_PIN_Notification__c = 'Y';
        testOpp.AU_Employer_Phone__c = '03 1234 5678';
        testOpp.AU_Employment_Commenced__c = System.today().addDays(-800);
        testOpp.Exception_Level_Reporting__c = 'Account';
        testOpp.AU_Exception_Reporting_Email_Address_1__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_2__c = 'testing@test.com';
        testOpp.AU_Exception_Reporting_Email_Address_3__c = 'testing@test.com';
        testOpp.AU_Financial_Institution__c = 'Testing';
        testOpp.AU_Financial_Institution_Suburb__c = 'Melbourne';
        testOpp.Group_Code__c = 'TEST';
        testOpp.AU_Joining_Fee_Override__c = 12.00;
        testOpp.AU_Monthly_Card_Fee__c = 20.00;
        testOpp.AU_Merchant_Incentive_Reference_Number__c = 'Testing';
        testOpp.LeadSource = 'Existing Motorpass Customer';
        testOpp.Product_Type__c = 'Motorpass';
        testOpp.AU_Reporting_odometer_Incorrect__c = true;
        testOpp.AU_Reporting_Odometer_Missing__c = true;
        testOpp.BAS_Reporting_Type__c = 'E';
        testOpp.Promotional_Code__c = 'TEST';
        testOpp.AU_Sales_Channel__c = 'Inbound Team';
        testOpp.Submitted_For_Assessment_Date_Time__c = System.today().addDays(-2);
        testOpp.AU_Title__c = 'Chief Sweeper';
        //      testOpp.Wholesaler_Discount_Code_1__c = 'GOLD1';
        //      testOpp.Discount_Code_1_Start_Date__c = date.today();
        //      testOpp.Discount_Code_1_End_Date__c = date.today().addDays(7);
        //      testOpp.Wholesaler_Discount_Code_2__c = 'SILVER';        
        //      testOpp.Discount_Code_2_Start_Date__c = date.today();
        //      testOpp.Discount_Code_2_End_Date__c = date.today().addDays(7);
        insert testOpp;

        Schema.DescribeSObjectResult auApplicationSobject = AU_Application_Request__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> appRtMapByName = auApplicationSobject.getRecordTypeInfosByName();
        Id appAuRtId = appRtMapByName.get('AU Application Request').getRecordTypeId();
        AU_Application_Request__c testApp = new AU_Application_Request__c();
        testApp.Opportunity__c = testOpp.Id;
        testApp.Account__c = testAcc.Id;
        testApp.RecordTypeId = appAuRtId;
        testApp.Credit_Limit__c = 3000;
        testApp.Application_Status__c = 'Pending Assessment';
        testApp.Approval_Status__c = 'Approved';
        testApp.Positive_Balance_Account__c = true;
        testApp.Positive_Balance_Account_Credit__c = true;
        testApp.Positive_Balance_Limit__c = 500;
        insert testApp;

        Schema.DescribeSObjectResult cardSobject = AU_Card_Details__c.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> cardRtMapByName = cardSobject.getRecordTypeInfosByName();
        Id cardAuFuelRtId = cardRtMapByName.get('AU Fuel Business').getRecordTypeId();
        List<AU_Card_Details__c> testcards = new List<AU_Card_Details__c>();
        for (Integer counter = 0; counter < 151; counter++) {
            AU_Card_Details__c auCard = new AU_Card_Details__c();
            aucard.Opportunity__c = testOpp.Id;
            auCard.Account__c = testAcc.Id;
            auCard.AU_Additional_Card_Text__c = 'accYesCardsFail';
            auCard.BAS_Flag__c = true;
            auCard.BAS_Reporting_Fee_Override__c = 12.00;
            auCard.Card_Bulk_PIN__c = '0123';
            auCard.Card_Controls__c = 'Fuel & Oil Only';
            auCard.AU_Card_Dispatch_Address_1__c = 'Disrupt American Apparel High Life';
            auCard.AU_Card_Dispatch_Address_2__c = 'flexitarian synth chambray. Etsy';
            auCard.AU_Card_Dispatch_Address_Suburb__c = 'Melbourne';
            auCard.Card_Dispatch_Address_State__c = 'VIC';
            auCard.AU_Card_Dispatch_Address_Postcode__c = '3000';
            auCard.AU_card_PIN_setting__c = 'O: Optional';
            auCard.Card_Type__c = 'MP: Motorpass';
            auCard.AU_Cost_Centre_Code__c = '123456789012';
            auCard.AU_Cost_Centre_Description__c = 'Testing Cost Centre';
            auCard.AU_Drivers_Name__c = 'Test Test';
            auCard.AU_Card_Holder_Diesel_Card_Marketing_Are__c = 'MELB: Melbourne Metro, VIC; NQLD: North QLD';
            auCard.AU_Card_Holder_email_address__c = 'testing@test.com';
            auCard.AU_Cardholder_Mobile_Phone_Number__c = '0408 123 456';
            auCard.Cardholder_Employer_Name__c = 'Test Limited';
            auCard.Express_Delivery__c = true;
            auCard.Odometer_Required__c = true;
            auCard.Product_Restriction_Groups__c = '20: Unleaded; 80: Insurance';
            auCard.AU_Reference_Required__c = true;
            auCard.Roadside_Assist_Fee_Frequency__c = 'M';
            auCard.Roadside_Assist_Fee_Override__c = 54321;
            auCard.Roadside_Assist_Key_Code__c = 54321;
            auCard.Roadside_Assist_VIN__c = 'Testing VIN';
            auCard.AU_Signature_Strip__c = true;
            auCard.Site_Restriction__c = 'TESTS';
            auCard.AU_Vehicle_Registration__c = 'Testing';
            auCard.AU_Vehicle_Make__c = 'Test';
            auCard.AU_Vehicle_Model__c = 'Test';
            auCard.Vehicle_Body_Type__c = 'Test';
            auCard.Vehicle_Year__c = 2014;
            auCard.Vehicle_Colour__c = 'OARSUM';
            testcards.add(auCard);
        }
        testcards[0].Card_Controls__c = 'All Vehicle Expenses';
        testcards[1].Card_Controls__c = 'All Expenses';
        insert testcards;

        Test.startTest();
        WS_Testing_Util.TEST_PATH_ACCOUNT_PASS = true;
        WS_Testing_Util.TEST_PATH_CARD_PASS = false;
        Test.setMock(WebServiceMock.class, new WS_Genesis_AccountServicesMock());
        Test.setCurrentPage(Page.AccountAndCardsToGenesis);
        ApexPages.StandardController standardController = new ApexPages.StandardController(testApp);
        AccountAndCardsToGenesis_ExCon accountAndCardsToGenesisController = new AccountAndCardsToGenesis_ExCon(standardController);
        PageReference pageRef = accountAndCardsToGenesisController.submitAccountAndCards();
        Test.stopTest();
    }
}