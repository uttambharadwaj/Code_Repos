@IsTest
public class CustomerDetailsTest {

    @TestSetup
    static void setupTestData() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        CustomerDetailsWSUtilv2.customerDetails details = CustomerDetailsController.getCustomerDetails('9100000000000','',null, false);
        String jsonAccountString = JSON.serialize(details);
        System.debug('### jsonAccountString='+jsonAccountString);
        List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContacts('9100000000000');

        String contactJsonString = JSON.serialize(contacts);
        System.debug('### contactJsonString='+contactJsonString);
        UtilityTestLoader.setAutomation(false);
        Id genericProgramId;
        Id genericOtrProgramId;
        Id genericPartnerId;
        String programRowId;


        programRowId =  '1-12N3P99';

        Partner__c partner = new Partner__c();
        partner.Name = 'WEXGeneric';

        insert partner;

        genericPartnerId = partner.Id;
        System.debug('genericPartnerId = '+genericPartnerId);

        Program__c program = new Program__c();
        Id serviceOpsProgramRecordTypeId = Schema.SObjectType.Program__c.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

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
        program.RecordTypeId = serviceOpsProgramRecordTypeId;


        insert program;
        genericProgramId = program.Id;
        System.debug('genericProgramId = '+genericProgramId);

        Program__c otrProgram = new Program__c();

        otrProgram.Name = 'EFSLLC';
        otrProgram.Form_Template__c = 'WEXGeneric';
        otrProgram.Brand_Short_Name__c = 'EFSLLC';
        otrProgram.Service_Program_Name__c = 'EFSLLC';
        otrProgram.Service_Program_Website__c = 'https://www.emanager.com';
        otrProgram.Preferred_Language_Indicator__c = 'ENU';
        otrProgram.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        otrProgram.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        otrProgram.Brand_Long_Name__c = 'Test BOCA';
        otrProgram.Upload_Pricing_Data_Flag__c = false;
        otrProgram.Auto_Send_BOCA_to_Siebel__c = false;
        otrProgram.T_C__c = 'WEX_BOCA_TNC';
        otrProgram.Analytics_Body_Block__c = '';
        otrProgram.Analytics_Head_Block__c = '';
        otrProgram.Brand_Color_1__c = '#ccc';
        otrProgram.Brand_Color_2__c = '#fff';
        otrProgram.Siebel_Program_Row_Id__c = 'EFSLLC';
        otrProgram.Partner__c = genericPartnerId;
        otrProgram.RecordTypeId = serviceOpsProgramRecordTypeId;


        insert otrProgram;
        genericOtrProgramId = otrProgram.Id;
        System.debug('genericOtrProgramId = '+genericOtrProgramId);
            

        
        

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

        Id serviceOpsAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();
        Id serviceOpsContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        Account parentOtrAccount = new Account();
        parentOtrAccount.Customer_Segmentation__c = 0;
        parentOtrAccount.CurrencyIsoCode = 'USD';
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
        parentOtrAccount.RecordTypeId = serviceOpsAccountRecordTypeId;
        parentOtrAccount.Program__c = genericOtrProgramId;
        parentOtrAccount.Platform__c = 'EFSLLC';
        parentOtrAccount.Acct_Row_Id__c = 'EFSLLC-123456';

        otrAccount.Sponsor_Acct__c = '123457';

        insert parentOtrAccount;
        Id parentOtrAccountId = parentOtrAccount.Id;

        otrAccount.Customer_Segmentation__c = 0;
        otrAccount.CurrencyIsoCode = 'USD';
        otrAccount.Status__c = 'X';
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
        otrAccount.RecordTypeId = serviceOpsAccountRecordTypeId;
        otrAccount.ParentId = parentOtrAccountId;
        otrAccount.Program__c = genericOtrProgramId;
        otrAccount.Platform__c = 'EFSLLC';
        otrAccount.Acct_Row_Id__c = 'EFSLLC-123457';
        otrAccount.Primary_Contact_TXT__c = 'EFSLLC-123457-0001';
        otrAccount.Admin_Contact_TXT__c = 'EFSLLC-123457-0002';
        otrAccount.Billing_Contact_TXT__c = 'EFSLLC-123457-0002';
        otrAccount.Shipping_Contact_TXT__c = 'EFSLLC-123457-0002';
        otrAccount.Mailing_Contact_TXT__c = 'EFSLLC-123457-0002';

        otrAccount.Sponsor_Acct__c = '123456';

        insert otrAccount;

        Id otrAccountId = otrAccount.Id;

        Contract__c otrContract = new Contract__c();
        otrContract.Account__c = otrAccountId;
        otrContract.Status__c = 'A';
        otrContract.Name = 'Contract';
        otrContract.AR_Number__c = '9100000000000';

        insert otrContract;

        Contact otrContact = new Contact();
        otrContact.RecordTypeId = serviceOpsContactRecordTypeId;
        otrContact.FirstName = 'Generic';
        otrContact.LastName = 'Boss';
        otrContact.Phone = '207-773-8171';
        otrContact.AccountId = otrAccountId;
        otrContact.Contact_Type__c = 'PRIMARY';
        otrContact.Contact_Row_Id__c = 'EFSLLC-123457-0001';
        insert otrContact;

        Contact otrContact1 = new Contact();
        otrContact1.RecordTypeId = serviceOpsContactRecordTypeId;
        otrContact1.FirstName = 'Generic';
        otrContact1.LastName = 'Servant';
        otrContact1.Phone = '207-773-8171';
        otrContact1.AccountId = otrAccountId;
        otrContact1.Contact_Type__c = 'Accounts Payable';
        otrContact1.Contact_Row_Id__c = 'EFSLLC-123457-0002';
        insert otrContact1;

        Contact otrContact2 = new Contact();
        otrContact2.RecordTypeId = serviceOpsContactRecordTypeId;
        otrContact2.FirstName = 'Generic';
        otrContact2.LastName = 'Serf';
        otrContact2.Phone = '207-773-8171';
        otrContact2.AccountId = otrAccountId;
        otrContact2.Contact_Row_Id__c = 'EFSLLC-123457-0003';
        insert otrContact2;



        List<Contact> otrContacts = [SELECT Id, FirstName, LastName, Contact_Type__c, Phone, Contact_Row_Id__c, AccountId FROM Contact WHERE AccountId =: otrAccountId];
        Contact contact;
        for (Integer i=0; i < otrContacts.size(); i++) {
            System.debug('### Contact: '+otrContacts[i]);
        }

        System.debug('### parentOtrAccountId = '+parentOtrAccountId);
        System.debug('### otrAccountId = '+otrAccountId);
        String[] acctIds = new String[]{parentOtrAccountId,otrAccountId};
        List<Account> otrAccounts = [SELECT Id, Name, Platform__c, Program__c, Program__r.Name, Sponsor_Acct__c FROM Account WHERE Id IN :acctIds];
        for (Account acct : otrAccounts) {
            System.debug(acct);
        }
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

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest, null, null,false);

            System.assert(customerDetails.pdAsset == null);

            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContactsFromAnywhere(accountNumberToTest,null,null);

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

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest, null, pdRowId,false);

            System.assert(customerDetails.pdAsset != null);

            System.assert(customerDetails.pdAsset.pdRowId == pdRowId);

            System.assert(customerDetails.pdAsset.wexAcctNbr == accountNumberToTest);

            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContactsFromAnywhere(accountNumberToTest,null,null);

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

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(accountNumberToTest,null,null,false);
            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContactsFromAnywhere(accountNumberToTest,null,null);

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

    static testMethod void testGetPaymentsForOTR() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'OTR';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.payments payments =  CustomerDetailsController.getPayments(accountNumberToTest,sourceSys);
            System.assert(!(payments.paymentHistory.isEmpty()));
            System.assert(!(payments.paymentDetails.isEmpty()));
            System.assert(!(payments.pendingPayments.isEmpty()));
            //System.assert(String.isEmpty(payments.errorMsg));
            System.debug('ErrorMsg='+payments.errorMsg);

            Test.stopTest();
        }
    }

    static testMethod void testGetOTRContracts() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'EFSLLC';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.otrContractsResponse contractsResponse =  customerDetailsCallout.getOtrContracts(accountNumberToTest,sourceSys);
            System.assert(contractsResponse.contracts != null);
            System.assert(contractsResponse.errorMsg == null);
            System.assert(contractsResponse.contracts.entry.size() > 0);

            Test.stopTest();
        }
    }

    static testMethod void testGetRefundAggregatesWithAccount() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO refundsResponse =  CustomerDetailsController.getRefAdjTotals(accountNumberToTest,'Refund');
            System.debug('### Refunds ' + refundsResponse);

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

    static testMethod void testGetInvoicesforOTR() {
        User user = getTestUser();

        System.runAs(user) {
            String accountNumberToTest = '9100000000000';
            String sourceSys           = 'OTR';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            CustomerDetailsWSUtilv2.invoices invoices =  CustomerDetailsController.getInvoices(accountNumberToTest,sourceSys);
            System.assert(invoices.invoices.isEmpty());
            System.assert(String.isEmpty(invoices.errorMsg));

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

            Id fleetAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Account otrAccount = [SELECT Id FROM Account WHERE Sponsor_Acct__c =: carrierIdToTest AND RecordTypeId =: fleetAccountRecordTypeId LIMIT 1];

            Id serviceAccountId = otrAccount.Id;

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(null, serviceAccountId, null,true);
            System.debug('### customerDetails=' + customerDetails);

            System.assert('EFSLLC'.equals(customerDetails.programNm),'Program Name was: '+ customerDetails.programNm);
            System.assert('https://www.emanager.com'.equals(customerDetails.onlineApplication),'Online Application was: '+ customerDetails.onlineApplication);

            Integer numberOfCasesToday = CustomerDetailsController.getNumberOfCasesTodayByAccountRecordId(serviceAccountId);

            System.assert(numberOfCasesToday == 0, 'Number of cases today was: '+numberOfCasesToday);

            List<Case> existingCases = CustomerDetailsController.getExistingCasesByAccountRecordId(serviceAccountId);

            System.assert(existingCases.size() == 0, 'Number of existing cases was: '+existingCases.size());

            System.assert(customerDetails.pdAsset == null);

            List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContactsFromAnywhere(null,serviceAccountId,null);
            String contactRowId = null;
            if (contacts.size() > 0) {
                contactRowId = contacts[0].rowId;
            }
            System.assert(contacts.size() == 7, 'Improper number of contacts detected: '+contacts.size()); //Should be one for each role except AP, plus one unassigned
            for (CustomerDetailsWSUtilv2.contact ct : contacts) {
                if (ct.role == null  && !('CONTACT'.equalsIgnoreCase(ct.contactType))) {
                    System.debug('*** NULL ROLE DETECTED!');
                    System.debug('RowId = '+ct.rowId);
                    System.debug('ContactType = '+ct.contactType);
                    System.assert(false, 'Null role detected!');
                }

                if ('PRIMARY'.equalsIgnoreCase(ct.role)) {
                    System.assert('EFSLLC-123457-0001'.equals(ct.rowId), 'Bad Primary Contact Detected! :'+ct.rowId);
                }
                else if ('ADMIN'.equalsIgnoreCase(ct.role)) {
                    System.assert('EFSLLC-123457-0002'.equals(ct.rowId), 'Bad Admin Contact Detected! :'+ct.rowId);
                }
                System.debug(ct);
            }

            List<CustomerDetailsWSUtilv2.authLogRecord> declinedAuths = CustomerDetailsController.getRecentDeclinedAuths(carrierIdToTest, 'OTR');
            System.assert(declinedAuths.isEmpty());

            List<Case> cases = CustomerDetailsController.getExistingOpenCasesByAccountId(serviceAccountId);

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

    static testMethod void testOTRContracts() {

        User user = getTestUser();

        System.runAs(user) {

            String carrierIdToTest = '123456';

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            System.assert(CustomerDetailsController.genericProgram != null);

            Id fleetAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Account otrAccount = [SELECT Id FROM Account WHERE Sponsor_Acct__c =: carrierIdToTest AND RecordTypeId =: fleetAccountRecordTypeId LIMIT 1];

            Id serviceAccountId = otrAccount.Id;

            CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(null, serviceAccountId, null,true);
            System.debug('### customerDetails=' + customerDetails);
            String arNumber = customerDetails.arNumber;
            System.assert('9100000000000'.equalsIgnoreCase(arNumber));
            String sourceSys = customerDetails.sourceSys;
            System.assert('EFSLLC'.equalsIgnoreCase(sourceSys));



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

                CustomerDetailsWSUtilv2.customerDetails customerDetails = CustomerDetailsController.getCustomerDetails(null, '0000',null,false);

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

                List<CustomerDetailsWSUtilv2.contact> contacts = CustomerDetailsController.getCustomerContactsFromAnywhere('0000',null,null);

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

    static testMethod void testGetRefundTotalsWithoutAccount() {
        User user = getTestUser();

        System.runAs(user) {

            Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

            Test.startTest();

            TestUtils.enable_isRunningTest = true;

            try {

                CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO refundsResponse =  CustomerDetailsController.getRefAdjTotals('0000','Refund');

                if (refundsResponse.errorMsg != null)
                    throw new AuraHandledException(refundsResponse.errorMsg) ;

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

    static testMethod void testInitcap() {
        String name1 = 'MARK H. BICKFORD';
        String name2 = 'michael   dubyak  ';
        String name3 = 'rANDOm 324efd545$%^(*& sTUfe';

        String nameResult1 = CustomerDetailsController.initcap(name1);
        System.assertEquals('Mark H. Bickford',nameResult1,'Test 1 failed, produced '+nameResult1);

        String nameResult2 = CustomerDetailsController.initcap(name2);
        System.assertEquals('Michael Dubyak',nameResult2,'Test 2 failed, produced '+nameResult2);

        String nameResult3 = CustomerDetailsController.initcap(name3);
        System.assertEquals('Random 324efd545$%^(*& Stufe',nameResult3,'Test 2 failed, produced '+nameResult3);
    }

}