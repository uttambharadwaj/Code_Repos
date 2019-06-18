@isTest
public class CustomerDetailsTest {

    @testSetup
    static void setupTestData() {

        UtilityTestLoader.setAutomation(false);
    
        Id genericProgramId;

        List<Program__c> genericPrograms = [SELECT Id FROM Program__c WHERE RecordType.Name = 'CPS Program' AND Brand_Short_Name__c = 'WEXGeneric'];

        System.debug('### Generic Program search returns '+genericPrograms);
        if (genericPrograms.size() > 0) {
            genericProgramId = genericPrograms[0].Id;
        }
        else {

            Program__c program = new Program__c();

            program.Name = 'WEXGeneric';
            program.Form_Template__c = 'WEXGeneric';
            program.Brand_Short_Name__c = 'WEXGeneric';
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
            genericProgramId = program.Id;
        }

        Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();
        System.debug('### CDS Before='+CDS);

        CDS.Customer_Details_EndPoint__c = 'https://webservices-dev.wexinc.com/SalesforceCustomerServices/ProxyServices/CustomerDetails';
        CDS.API_Timeout_ms__c = 120000;
        CDS.Generic_Program__c = genericProgramId;
        System.debug('### CDS After='+CDS);

        upsert CDS;
    }

    public static String getGenerateTimeStamp()
    {
        return String.valueOf(Datetime.now().getTime());
    }

    private static User getTestUser() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Service Operations Agent'];
        List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name IN ('Contact Center','NA Customer Service')];
        UserRole role = roles[0];
        String nowString = getGenerateTimeStamp();

        User user = new User(
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'test@wexinc.com',
                Alias = 'testl',
                Username = nowString+'test@wexinc.com',
                TimeZoneSidKey = 'GMT',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profile.id,
                CompanyName = 'Test',
                CurrencyIsoCode = 'EUR',
                UserRoleId = role.Id
        );

        insert user;
        return user;
    }

    // Happy path test with account number passed in
    static testMethod void testCustomerDetailsWithAccount() {

        User user = getTestUser();

        System.runAs(user) {

            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'SIEBEL';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            System.assert(CustomerDetailsController.genericProgram != null);

            Integer numberOfCasesToday = CustomerDetailsController.getNumberOfCasesToday(accountNumberToTest);

            List<Case> existingCases = CustomerDetailsController.getExistingCases(accountNumberToTest);

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest, null, null);

            System.assert(customerDetails.pdAsset == null);

            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts(accountNumberToTest);

            CustomerDetailsWSUtilv2.agingHistory agingHistory = CustomerDetailsController.getAgingHistory(accountNumberToTest);

            List<CustomerDetailsWSUtilv2.authLogRecord> declinedAuths = CustomerDetailsController.getRecentDeclinedAuths(accountNumberToTest, sourceSys);

            List<Case> cases = CustomerDetailsController.getExistingOpenCases(accountNumberToTest);

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            //Need to create a case so we'll have an owner in the attachToCase function.  Otherwise the triggers complain.
            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id
            );
            upsert xCase;

            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, 'Contact#1-1ZZZZZ', JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

            Support_Operation_Settings__c sos = CustomerDetailsController.getSupportOperationsSettings();
            String dummyDriverId = sos.ContactDriverRecordID__c;

            Id dummyDrivercontactId = CustomerDetailsController.attachToCase(null, dummyDriverId, JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### dummyDrivercontactId=' + dummyDrivercontactId);

            String accountIdString = CustomerDetailsController.getAccountId('9100000000000');
            System.debug('### accountIdString=' + accountIdString);

            String accountNumber = CustomerDetailsController.getAccountNumber(accountIdString);
            System.debug('### accountNumber=' + accountNumber);

            String contactIdString = CustomerDetailsController.getContactId(accountIdString, 'Contact#1-1ZZZZZ');
            System.debug('### contactIdString=' + contactIdString);

            Test.stopTest();
        }

    }

    // Happy path test with account number passed in
    static testMethod void testCustomerDetailsWithAccountAndPdRowId() {

        User user = getTestUser();

        System.runAs(user) {

            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'SIEBEL';
            String pdRowId = 'I-1234-Q';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            System.assert(CustomerDetailsController.genericProgram != null);

            Integer numberOfCasesToday = CustomerDetailsController.getNumberOfCasesToday(accountNumberToTest);

            List<Case> existingCases = CustomerDetailsController.getExistingCases(accountNumberToTest);

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest, null, pdRowId);

            System.assert(customerDetails.pdAsset != null);

            System.assert(customerDetails.pdAsset.pdRowId == pdRowId);

            System.assert(customerDetails.pdAsset.wexAcctNbr == accountNumberToTest);

            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts(accountNumberToTest);

            CustomerDetailsWSUtilv2.agingHistory agingHistory = CustomerDetailsController.getAgingHistory(accountNumberToTest);

            List<CustomerDetailsWSUtilv2.authLogRecord> declinedAuths = CustomerDetailsController.getRecentDeclinedAuths(accountNumberToTest, sourceSys);

            List<Case> cases = CustomerDetailsController.getExistingOpenCases(accountNumberToTest);

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            //Need to create a case so we'll have an owner in the attachToCase function.  Otherwise the triggers complain.
            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id
            );
            upsert xCase;

            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, 'Contact#1-1ZZZZZ', JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

            Support_Operation_Settings__c sos = CustomerDetailsController.getSupportOperationsSettings();
            String dummyDriverId = sos.ContactDriverRecordID__c;

            Id dummyDrivercontactId = CustomerDetailsController.attachToCase(null, dummyDriverId, JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### dummyDrivercontactId=' + dummyDrivercontactId);

            String accountIdString = CustomerDetailsController.getAccountId('9100000000000');
            System.debug('### accountIdString=' + accountIdString);

            String accountNumber = CustomerDetailsController.getAccountNumber(accountIdString);
            System.debug('### accountNumber=' + accountNumber);

            String contactIdString = CustomerDetailsController.getContactId(accountIdString, 'Contact#1-1ZZZZZ');
            System.debug('### contactIdString=' + contactIdString);

            Test.stopTest();
        }

    }

    static testMethod void testGetPaymentsWithAccount() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'SIEBEL';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.payments payments =  CustomerDetailsController.getPayments(accountNumberToTest,sourceSys);
            System.debug('### PaymentHistory' + payments.paymentHistory);
            System.debug('### PaymentDetails' + payments.paymentDetails);

            Test.stopTest();
        }
    }

    static testMethod void testGetInvoicesWithAccount() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'SIEBEL';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.invoices invoices =  CustomerDetailsController.getInvoices(accountNumberToTest,sourceSys);
            System.debug('### Invoices' + invoices.invoices);

            Test.stopTest();
        }
    }

    // Negative test with bad account number passed in
    static testMethod void testCustomerDetailsWithoutAccount() {

        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(null, '0000',null);

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;
                System.assertEquals(expectedExceptionThrown, false);

            }

            try {

                CustomerDetailsWSUtilv2.agingHistory agingHistory = CustomerDetailsController.getAgingHistory('9100000000001');

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;
                System.assertEquals(expectedExceptionThrown, false);

            }

            try {

                List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts('0000');

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;

                System.debug('### Exception: ' + e);

                System.assertEquals(expectedExceptionThrown, false);

            }
            try {

                List<CustomerDetailsWSUtilv2.authLogRecord> authResponse = CustomerDetailsController.getRecentDeclinedAuths('0000', 'SEEBEL');

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;

                System.debug('### Exception: ' + e);

                System.assertEquals(expectedExceptionThrown, false);

            }

            Test.stopTest();
        }

    }

    static testMethod void testGetPaymentsWithoutAccount() {
        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.payments payments = CustomerDetailsController.getPayments('0000','SIEBEL');
                if (payments.errorMsg != null)
                    throw new AuraHandledException(payments.errorMsg) ;

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;

                System.debug('### Exception: ' + e);

                System.assertEquals(expectedExceptionThrown, false);

            }

            Test.stopTest();
        }
    }

    static testMethod void testGetInvoicesWithoutAccount() {
        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.invoices invoices = CustomerDetailsController.getInvoices('0000','SIEBEL');

                if (invoices.errorMsg != null)
                    throw new AuraHandledException(invoices.errorMsg) ;

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;

                System.debug('### Exception: ' + e);

                System.assertEquals(expectedExceptionThrown, false);

            }
            Test.stopTest();
        }
    }

    static testMethod void testEmailValidation() {
        String badEmailAddress = 'test.user@@wexinc.com';

        System.assertEquals(false,CustomerDetailsController.checkEmailFormat(badEmailAddress) );
    }

}