@IsTest
public class CustomerDetailsTest {

    @TestSetup
    static void setupTestData() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        CustomerDetailsWSUtilv2.customerDetails details = CustomerDetailsController.getCustomerDetails('9100000000000','',null);
        String jsonAccountString = JSON.serialize(details);
        System.debug('### jsonAccountString='+jsonAccountString);
        List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts('9100000000000');

        String contactJsonString = JSON.serialize(contacts);
        System.debug('### contactJsonString='+contactJsonString);
        UtilityTestLoader.setAutomation(false);
        Id genericProgramId;
        Id genericPartnerId;
        String programRowId;

        List<Program__c> genericPrograms = [SELECT Id, Siebel_Program_Row_Id__c, Brand_Short_Name__c, Partner__c,Service_Program_Name__c,Service_Program_Website__c  FROM Program__c WHERE RecordType.Name = 'CPS Program' AND Brand_Short_Name__c = 'WEXGeneric'];

        System.debug('### Generic Program search returns '+genericPrograms);
        if (genericPrograms.size() > 0) {
            genericProgramId = genericPrograms[0].Id;
            genericPartnerId = genericPrograms[0].Partner__c;
            programRowId = genericPrograms[0].Siebel_Program_Row_Id__c;
            if (genericPrograms[0].Service_Program_Name__c == null || genericPrograms[0].Service_Program_Website__c == null) {
                if (genericPrograms[0].Service_Program_Name__c == null)
                    genericPrograms[0].Service_Program_Name__c = genericPrograms[0].Brand_Short_Name__c;

                if (genericPrograms[0].Service_Program_Website__c == null)
                    genericPrograms[0].Service_Program_Website__c =  'https://www.wexgeneric.com';

                update genericPrograms[0];
            }
        }
        else {
            programRowId =  '1-12N3P99';

            Partner__c partner = new Partner__c();
            partner.Name = 'WEXGeneric';

            insert partner;

            genericPartnerId = partner.Id;

            Program__c program = new Program__c();

            program.Name = 'WEXGeneric';
            program.Form_Template__c = 'WEXGeneric';
            program.Brand_Short_Name__c = 'WEXGeneric';
            program.Service_Program_Name__c = 'WEXGeneric';
            program.Service_Program_Website__c = 'https://www.wexgeneric.com';
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
            program.Siebel_Program_Row_Id__c = programRowId;
            program.Partner__c = genericPartnerId;

            insert program;
            genericProgramId = program.Id;
        }

        if (genericPartnerId == null) {
            Partner__c partner = new Partner__c();
            partner.Name = 'WEXGeneric';

            insert partner;

            genericPartnerId = partner.Id;

            Program__c program = [SELECT Id, Partner__c FROM Program__c WHERE Id =: genericProgramId];
            program.Partner__c = genericPartnerId;
            update program;

        }

        Id accountId =  CustomerDetailsController.upsertAccount(jsonAccountString);

        Id contactId = CustomerDetailsController.upsertContacts(accountId,contactJsonString,'1-1ZZZZZ');


        IntegrationRecord__c integrationRecord = new IntegrationRecord__c();
        integrationRecord.Contact__c = contactId;
        integrationRecord.Account__c = accountId;
        integrationRecord.Contact_Row_Id__c = '1-1ZZZZZ';
        upsert integrationRecord;


        //Second record so we can search on different rowId
        integrationRecord = new IntegrationRecord__c();
        integrationRecord.Contact__c = contactId;
        integrationRecord.Account__c = accountId;
        integrationRecord.Contact_Row_Id__c = '1-1ZZZZY';
        upsert integrationRecord;

        System.debug('Upserted contactId = '+contactId);

        Priority_Level_Servicing_Rule__c servicingRule = new Priority_Level_Servicing_Rule__c();
        servicingRule.Partner__c = genericPartnerId;
        servicingRule.Name = 'Generic A';
        servicingRule.Priority_Level__c = 'A';
        servicingRule.Priority_Level_Rule_Detail__c = 'This customer is awesome!';

        insert servicingRule;

        Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();
        System.debug('### CDS Before='+CDS);

        CDS.Customer_Details_EndPoint__c = 'https://nafleet-dit.wexapi.com/salesforcecustomerservices';
        CDS.API_Timeout_ms__c = 120000;
        CDS.Generic_Program__c = genericProgramId;
        System.debug('### CDS After='+CDS);

        upsert CDS;

        Support_Operation_Settings__c sos =Support_Operation_Settings__c.getOrgDefaults();
        sos.ContactDriverRecordID__c = '0030g00002CDTUz';
        upsert sos;

        List<Contact> genericContacts = [SELECT Id FROM Contact  WHERE RecordType.Name = 'Service Operations'  AND WEX_Contact_ID__c = '0030g00002CDTUz'];
        if (genericContacts.size() == 0) {
            Contact dummyDriverContact = new Contact();
            dummyDriverContact.FirstName = 'Generic';
            dummyDriverContact.LastName = 'Driver';
            dummyDriverContact.Phone = '207-773-8171';
            dummyDriverContact.AccountId = accountId;
            dummyDriverContact.WEX_Contact_ID__c = '0030g00002CDTUz';
            insert dummyDriverContact;
        }

        //OTR data
        Account otrAccount = new Account();

        Id fleetAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId();
        Id fleetContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();

        Account parentOtrAccount = new Account();
        parentOtrAccount.Customer_Segmentation__c = 0;
        parentOtrAccount.CurrencyIsoCode = 'USD';
        parentOtrAccount.Program__c = genericProgramId;
        parentOtrAccount.Status__c = 'Active';
        parentOtrAccount.Name = 'Test Parent Account';
        parentOtrAccount.BillingStreet = '1 Hancock St';
        parentOtrAccount.BillingCity = 'Portland';
        parentOtrAccount.BillingState = 'ME';
        parentOtrAccount.BillingCountry = 'USA';
        parentOtrAccount.BillingPostalCode = '04101';
        parentOtrAccount.ShippingStreet = '97 Darling Ave';
        parentOtrAccount.ShippingCity = 'S Portland';
        parentOtrAccount.ShippingState = 'ME';
        parentOtrAccount.ShippingCountry = 'USA';
        parentOtrAccount.ShippingPostalCode = '04106';
        parentOtrAccount.RecordTypeId = fleetAccountRecordTypeId;

        otrAccount.Carrier_ID__c = '123457';

        insert parentOtrAccount;
        Id parentOtrAccountId = parentOtrAccount.Id;

        otrAccount.Customer_Segmentation__c = 0;
        otrAccount.CurrencyIsoCode = 'USD';
        otrAccount.Program__c = genericProgramId;
        otrAccount.Status__c = 'Active';
        otrAccount.Name = 'Test Account';
        otrAccount.BillingStreet = '1 Hancock St';
        otrAccount.BillingCity = 'Portland';
        otrAccount.BillingState = 'ME';
        otrAccount.BillingCountry = 'USA';
        otrAccount.BillingPostalCode = '04101';
        otrAccount.ShippingStreet = '97 Darling Ave';
        otrAccount.ShippingCity = 'S Portland';
        otrAccount.ShippingState = 'ME';
        otrAccount.ShippingCountry = 'USA';
        otrAccount.ShippingPostalCode = '04106';
        otrAccount.RecordTypeId = fleetAccountRecordTypeId;
        otrAccount.ParentId = parentOtrAccountId;

        otrAccount.Carrier_ID__c = '123456';

        insert otrAccount;

        Id otrAccountId = otrAccount.Id;

        Contact otrContact = new Contact();
        otrContact.RecordTypeId = fleetContactRecordTypeId;
        otrContact.FirstName = 'Generic';
        otrContact.LastName = 'Boss';
        otrContact.Phone = '207-773-8171';
        otrContact.AccountId = otrAccountId;
        insert otrContact;
        Id otrContactId = otrContact.Id;
        otrContact.Contact_Row_Id__c = otrContactId;
        update otrContact;

        List<Contact> otrContacts = [SELECT Id, FirstName, LastName, Contact_Type__c, Phone, Contact_Row_Id__c, AccountId FROM Contact WHERE AccountId =: otrAccountId];
        Contact contact;
        for (Integer i=0; i < otrContacts.size(); i++) {
            System.debug('### Contact: '+otrContacts[i]);
        }

        System.debug('### parentOtrAccountId = '+parentOtrAccountId);
        System.debug('### otrAccountId = '+otrAccountId);
        System.debug('### otrContactId = '+otrContactId);

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

            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, '1-1ZZZZZ', JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

            Support_Operation_Settings__c sos = CustomerDetailsController.getSupportOperationsSettings();
            String dummyDriverId = sos.ContactDriverRecordID__c;

            Id dummyDrivercontactId = CustomerDetailsController.attachDummyContactToCase(null, dummyDriverId, JSON.serialize(customerDetails));
            System.debug('### dummyDrivercontactId=' + dummyDrivercontactId);

            String accountIdString = CustomerDetailsController.getAccountId('9100000000000');
            System.debug('### accountIdString=' + accountIdString);

            String accountNumber = CustomerDetailsController.getAccountNumber(accountIdString);
            System.debug('### accountNumber=' + accountNumber);

            String contactIdString = CustomerDetailsController.getContactId(accountIdString, '1-1ZZZZZ');
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

            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, '1-1ZZZZZ', JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

            Support_Operation_Settings__c sos = CustomerDetailsController.getSupportOperationsSettings();
            String dummyDriverId = sos.ContactDriverRecordID__c;

            Id dummyDrivercontactId = CustomerDetailsController.attachDummyContactToCase(null, dummyDriverId, JSON.serialize(customerDetails));
            System.debug('### dummyDrivercontactId=' + dummyDrivercontactId);

            String accountIdString = CustomerDetailsController.getAccountId('9100000000000');
            System.debug('### accountIdString=' + accountIdString);

            String accountNumber = CustomerDetailsController.getAccountNumber(accountIdString);
            System.debug('### accountNumber=' + accountNumber);

            //The different rowId is to test the search by integration record
            Id contactIdString = CustomerDetailsController.getContactId(accountIdString, '1-1ZZZZY#2-ADDRX');
            System.assertNotEquals(contactIdString, null);
            System.debug('### contactIdString=' + contactIdString);

            String servicingRule = CustomerDetailsController.getPriorityLevelServicingRule(customerDetails.programId,'A');
            System.assertEquals(servicingRule,'This customer is awesome!');
            System.debug('### servicingRule=' + servicingRule);

            Test.stopTest();
        }

    }

    // Happy path test with account number passed in , generating new contact from source
    static testMethod void testCustomerDetailsWithNewContact() {

        User user = getTestUser();

        System.runAs(user) {

            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'SIEBEL';
            String pdRowId = 'I-1234-Q';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            System.assert(CustomerDetailsController.genericProgram != null);

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest,null,null);
            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts(accountNumberToTest);

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            //Need to create a case so we'll have an owner in the attachToCase function.  Otherwise the triggers complain.
            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id
            );
            upsert xCase;

            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, '1-1ZZZZX', JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

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

    static testMethod void testGetRefundsWithAccount() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.RefundAdjustmentDTO refundsResponse =  CustomerDetailsController.getRefunds(accountNumberToTest);
            System.debug('### Refunds' + refundsResponse);

            Test.stopTest();
        }
    }

    static testMethod void testGetAdjustmentsWithAccount() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.RefundAdjustmentDTO adjustmentsResponse =  CustomerDetailsController.getAdjustments(accountNumberToTest);
            System.debug('### Adjustments' + adjustmentsResponse);

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

    // Happy path test with carrierId passed in
    static testMethod void testOTRCustomerDetails() {

        User user = getTestUser();

        System.runAs(user) {

            String carrierIdToTest = '123456';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            System.assert(CustomerDetailsController.genericProgram != null);

            Id fleetAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Fleet Account').getRecordTypeId();

            Account otrAccount = [SELECT Id FROM Account WHERE Carrier_ID__c =: carrierIdToTest AND RecordTypeId =: fleetAccountRecordTypeId LIMIT 1];

            Id[] idList = new List<Id>();
            idList.add(otrAccount.Id);
            Id serviceAccountId = null;

            List<Id> serviceAccountIdList = ServiceOperationsAccountCloner.cloneAccountAndContacts(idList);
            if (serviceAccountIdList.size()>0) {
                serviceAccountId = serviceAccountIdList[0];
            }

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(null, serviceAccountId, null);
            System.debug('### customerDetails=' + customerDetails);

            System.assert('WEXGeneric'.equals(customerDetails.programNm),'Program Name was: '+ customerDetails.programNm);
            System.assert('https://www.wexgeneric.com'.equals(customerDetails.onlineApplication),'Online Application was: '+ customerDetails.onlineApplication);

            Integer numberOfCasesToday = CustomerDetailsController.getNumberOfCasesTodayByAccountRecordId(serviceAccountId);

            System.assert(numberOfCasesToday == 0, 'Number of cases today was: '+numberOfCasesToday);

            List<Case> existingCases = CustomerDetailsController.getExistingCasesByAccountRecordId(serviceAccountId);

            System.assert(existingCases.size() == 0, 'Number of existing cases was: '+existingCases.size());

            System.assert(customerDetails.pdAsset == null);

            List<CustomerDetailsWSUtilv2.contact> contacts = customerDetails.contacts.contacts;
            Id contactRowId = null;
            if (contacts.size() > 0) {
                contactRowId = contacts[0].rowId;
            }

            // List<CustomerDetailsWSUtilv2.authLogRecord> declinedAuths = CustomerDetailsController.getRecentDeclinedAuths(carrierIdToTest, sourceSys);

            List<Case> cases = CustomerDetailsController.getExistingOpenCasesByAccountRecordId(serviceAccountId);

            System.assert(cases.size() == 0, 'Number of existing open cases was: '+cases.size());

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            //Need to create a case so we'll have an owner in the attachToCase function.  Otherwise the triggers complain.
            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id
            );
            upsert xCase;



            Id contactId = CustomerDetailsController.attachToCase(xCase.Id, contactRowId, JSON.serialize(customerDetails), JSON.serialize(contacts));
            System.debug('### ContactID=' + contactId);

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

            String servicingRule = CustomerDetailsController.getPriorityLevelServicingRule('NOSUCHPROGRAM','Z');
            System.assertEquals(servicingRule,'Servicing Rule not available; refer to documentation');

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

    static testMethod void testGetRefundsWithoutAccount() {
        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.RefundAdjustmentDTO refunds = CustomerDetailsController.getRefunds('0000');

                if (refunds.errorMsg != null)
                    throw new AuraHandledException(refunds.errorMsg) ;

            }
            catch(Exception e) {

                Boolean expectedExceptionThrown = e.getMessage().contains('Unable to retrieve') ? true : false;

                System.debug('### Exception: ' + e);

                System.assertEquals(expectedExceptionThrown, false);

            }
            Test.stopTest();
        }
    }

    static testMethod void testGetAdjustmentsWithoutAccount() {
        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.RefundAdjustmentDTO Adjustments = CustomerDetailsController.getAdjustments('0000');

                if (Adjustments.errorMsg != null)
                    throw new AuraHandledException(Adjustments.errorMsg) ;

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