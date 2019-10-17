/**
 * Created by W083158 on 10/17/2019.
 */
@IsTest
public with sharing class RefundAdjustmentTriggerTest {

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

        List<Program__c> genericPrograms = [SELECT Id, Siebel_Program_Row_Id__c, Partner__c FROM Program__c WHERE RecordType.Name = 'CPS Program' AND Brand_Short_Name__c = 'WEXGeneric'];

        System.debug('### Generic Program search returns '+genericPrograms);
        if (genericPrograms.size() > 0) {
            genericProgramId = genericPrograms[0].Id;
            genericPartnerId = genericPrograms[0].Partner__c;
            programRowId = genericPrograms[0].Siebel_Program_Row_Id__c;
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

        /* todo reinstate this
        IntegrationRecord__c integrationRecord = new IntegrationRecord__c();
        integrationRecord.Contact__c = contactId;
        integrationRecord.Account__c = accountId;
        integrationRecord.Contact_Row_Id__c = '1-1ZZZZZ';
        insert integrationRecord;

         */

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
                ProfileId = profile.Id,
                CompanyName = 'Test',
                CurrencyIsoCode = 'USD',
                UserRoleId = role.Id
        );

        insert user;
        return user;
    }

    private static User getApproverUser() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Service Operations Manager'];
        List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name IN ('Contact Center','NA Customer Service')];
        UserRole role = roles[0];
        String nowString = getGenerateTimeStamp();

        User user = new User(
                FirstName = 'Test',
                LastName = 'Manager',
                Email = 'testMgr@wexinc.com',
                Alias = 'test2',
                Username = nowString+'testMgr@wexinc.com',
                TimeZoneSidKey = 'GMT',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profile.Id,
                CompanyName = 'Test',
                CurrencyIsoCode = 'USD',
                UserRoleId = role.Id
        );
        insert user;

        List<PermissionSet> approvalSetList = [SELECT Id FROM PermissionSet WHERE Name = 'RefAdj_CS_Manager' ];
        //List<PermissionSet> approvalSetList = [SELECT Id FROM PermissionSet WHERE Name = 'RefAdj_CS_Team_Lead' ];
        PermissionSet approvalSet = approvalSetList[0];
        PermissionSetAssignment assignment = new PermissionSetAssignment(
                PermissionSetId = approvalSet.Id,
                AssigneeId = user.Id
        );
        insert assignment;
        update user;

        return user;
    }

    static testMethod void testLowRefund() {

        Id refundId;

        User user = getTestUser();
        User approver = getApproverUser();
        user.ManagerId = approver.Id;
        update user;

        Test.startTest();

        System.runAs(user) {

            TestUtils.enable_isRunningTest = true;

            Id refundRecordTypeId = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Refund').getRecordTypeId();

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            List<Account> accountIdList = [SELECT Id from Account WHERE RecordTypeId =: accountRecordTypeId AND Wex_Account__c = '9100000000000'];
            Account accountId;

            if (accountIdList.size() > 0) {
                accountId = accountIdList[0];
            }



            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id,
                    Account = accountId
            );
            upsert xCase;

            Refund_Adjustment__c refund = new Refund_Adjustment__c(
                    RecordTypeId = refundRecordTypeId,
                    CaseNumber__c = xCase.Id,
                    Amount_Waived__c = 400.00,
                    Refund_Code__c = 'REFND',
                    Department__c = 'CS',
                    Reason_Comment__c = 'Testing refund'
            ) ;


            insert refund;

            refundId = refund.Id;

            Refund_Adjustment__c refundVerify = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refund.Id];

            System.assert(refundVerify.Approver_Name__c == null, 'Approver Name='+refundVerify.Approver_Name__c);
            System.assert(refundVerify.Approval_Comment__c == null, 'Approval Comment='+refundVerify.Approval_Comment__c);
            System.assert(refundVerify.Decision_Date__c == null, 'Decision Date='+refundVerify.Decision_Date__c);
            System.assert(refundVerify.Approval_Status__c == 'Pending', 'Approval Status='+refundVerify.Approval_Status__c);


        }

        System.runAs(approver) {
            Refund_Adjustment__c refund = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refundId];
            refund.Approval_Status__c = 'Approved';
            String approvalComment = 'Refund sent';
            refund.Approval_Comment__c = approvalComment;

            update refund;

            Refund_Adjustment__c refundVerify = [SELECT Id, Reason_Description__c, Unified_Fee_Code__c, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refundId];

            System.debug('refundVerify.reasonDescription = '+refundVerify.Reason_Description__c);
            System.debug('refundVerify.UnifiedFeeCode = '+refundVerify.Unified_Fee_Code__c);

            System.assert(refundVerify.Approver_Name__c == approver.Id, 'Approver Name='+refundVerify.Approver_Name__c);
            System.assert(refundVerify.Approval_Comment__c == approvalComment, 'Approval Comment='+refundVerify.Approval_Comment__c);
            System.assert(refundVerify.Decision_Date__c > (System.now() - 15000), 'Decision Date='+refundVerify.Decision_Date__c); // 15 seconds
            System.assert(refundVerify.Approval_Status__c == 'Approved', 'Approval Status='+refundVerify.Approval_Status__c);
            
        }


        Test.stopTest();
    }

    static testMethod void testHighRefund() {

        Id refundId;

        User user = getTestUser();
        User approver = getApproverUser();
        user.ManagerId = approver.Id;
        update user;

        Test.startTest();

        System.runAs(user) {

            TestUtils.enable_isRunningTest = true;

            Id refundRecordTypeId = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Refund').getRecordTypeId();

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            List<Account> accountIdList = [SELECT Id FROM Account WHERE RecordTypeId =: accountRecordTypeId AND Wex_Account__c = '9100000000000'];
            Account accountId;

            if (accountIdList.size() > 0) {
                accountId = accountIdList[0];
            }



            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id,
                    Account = accountId
            );
            upsert xCase;

            Refund_Adjustment__c refund = new Refund_Adjustment__c(
                    RecordTypeId = refundRecordTypeId,
                    CaseNumber__c = xCase.Id,
                    Amount_Waived__c = 30000.00,
                    Refund_Code__c = 'REFND',
                    Department__c = 'CS',
                    Reason_Comment__c = 'Testing high refund'
            ) ;


            insert refund;

            refundId = refund.Id;

            Refund_Adjustment__c refundVerify = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refund.Id];

            System.assert(refundVerify.Approver_Name__c == null, 'Approver Name='+refundVerify.Approver_Name__c);
            System.assert(refundVerify.Approval_Comment__c == null, 'Approval Comment='+refundVerify.Approval_Comment__c);
            System.assert(refundVerify.Decision_Date__c == null, 'Decision Date='+refundVerify.Decision_Date__c);
            System.assert(refundVerify.Approval_Status__c == 'Held', 'Approval Status='+refundVerify.Approval_Status__c);

        }

        System.runAs(approver) {
            Boolean hasManagerPermission = System.FeatureManagement.checkPermission('CS_Manager');
            System.debug('User has CS Manager permission='+hasManagerPermission);
            Refund_Adjustment__c refund = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refundId];
            refund.Approval_Status__c = 'Approved';
            String approvalComment = 'Refund sent';
            refund.Approval_Comment__c = approvalComment;

            update refund;

            Refund_Adjustment__c refundVerify = [SELECT Id, Reason_Description__c, Unified_Fee_Code__c, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: refundId];

            System.debug('refundVerify.reasonDescription = '+refundVerify.Reason_Description__c);
            System.debug('refundVerify.UnifiedFeeCode = '+refundVerify.Unified_Fee_Code__c);

            System.assert(refundVerify.Approver_Name__c == approver.Id, 'Approver Name='+refundVerify.Approver_Name__c);
            System.assert(refundVerify.Approval_Comment__c == approvalComment, 'Approval Comment='+refundVerify.Approval_Comment__c);
            System.assert(refundVerify.Decision_Date__c > (System.now() - 15000), 'Decision Date='+refundVerify.Decision_Date__c); // 15 seconds
            System.assert(refundVerify.Approval_Status__c == 'Approved', 'Approval Status='+refundVerify.Approval_Status__c);

        }


        Test.stopTest();
    }

    static testMethod void testLowAdjustment() {

        Id adjustmentId;

        User user = getTestUser();
        User approver = getApproverUser();
        user.ManagerId = approver.Id;
        update user;

        Test.startTest();

        System.runAs(user) {

            TestUtils.enable_isRunningTest = true;

            Id adjustmentRecordTypeId = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            List<Account> accountIdList = [SELECT Id from Account WHERE RecordTypeId =: accountRecordTypeId AND Wex_Account__c = '9100000000000'];
            Account accountId;

            if (accountIdList.size() > 0) {
                accountId = accountIdList[0];
            }



            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id,
                    Account = accountId
            );
            upsert xCase;

            Refund_Adjustment__c adjustment = new Refund_Adjustment__c(
                    RecordTypeId = adjustmentRecordTypeId,
                    CaseNumber__c = xCase.Id,
                    Total_Late_Fee__c = 400.00,
                    Amount_Waived__c = 400.00,
                    Fee_Type__c = 'LATE',
                    Fee_Code__c = 'ONLFEE',
                    Department__c = 'CS',
                    Reason_Comment__c = 'Testing adjustment'
            ) ;

            System.debug('Adjustment='+adjustment);
            insert adjustment;

            adjustmentId = adjustment.Id;

            Refund_Adjustment__c adjustmentVerify = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustment.Id];

            System.assert(adjustmentVerify.Approver_Name__c == null, 'Approver Name='+adjustmentVerify.Approver_Name__c);
            System.assert(adjustmentVerify.Approval_Comment__c == null, 'Approval Comment='+adjustmentVerify.Approval_Comment__c);
            System.assert(adjustmentVerify.Decision_Date__c == null, 'Decision Date='+adjustmentVerify.Decision_Date__c);
            System.assert(adjustmentVerify.Approval_Status__c == 'Pending', 'Approval Status='+adjustmentVerify.Approval_Status__c);


        }

        System.runAs(approver) {
            Refund_Adjustment__c adjustment = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustmentId];
            adjustment.Approval_Status__c = 'Approved';
            String approvalComment = 'Adjustment sent';
            adjustment.Approval_Comment__c = approvalComment;

            update adjustment;

            Refund_Adjustment__c adjustmentVerify = [SELECT Id, Reason_Description__c, Unified_Fee_Code__c, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustmentId];

            System.debug('adjustmentVerify.reasonDescription = '+adjustmentVerify.Reason_Description__c);
            System.debug('adjustmentVerify.UnifiedFeeCode = '+adjustmentVerify.Unified_Fee_Code__c);

            System.assert(adjustmentVerify.Approver_Name__c == approver.Id, 'Approver Name='+adjustmentVerify.Approver_Name__c);
            System.assert(adjustmentVerify.Approval_Comment__c == approvalComment, 'Approval Comment='+adjustmentVerify.Approval_Comment__c);
            System.assert(adjustmentVerify.Decision_Date__c > (System.now() - 15000), 'Decision Date='+adjustmentVerify.Decision_Date__c); // 15 seconds
            System.assert(adjustmentVerify.Approval_Status__c == 'Approved', 'Approval Status='+adjustmentVerify.Approval_Status__c);

        }


        Test.stopTest();
    }

    static testMethod void testHighAdjustment() {

        Id adjustmentId;

        User user = getTestUser();
        User approver = getApproverUser();
        user.ManagerId = approver.Id;
        update user;

        Test.startTest();

        System.runAs(user) {

            TestUtils.enable_isRunningTest = true;

            Id adjustmentRecordTypeId = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();

            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

            List<Account> accountIdList = [SELECT Id FROM Account WHERE RecordTypeId =: accountRecordTypeId AND Wex_Account__c = '9100000000000'];
            Account accountId;

            if (accountIdList.size() > 0) {
                accountId = accountIdList[0];
            }



            Case xCase = new Case(
                    Subject = 'Test case',
                    Type = 'Service Operations',
                    RecordTypeId = caseRecordTypeId,
                    OwnerId = user.Id,
                    Account = accountId
            );
            upsert xCase;

            Refund_Adjustment__c adjustment = new Refund_Adjustment__c(
                    RecordTypeId = adjustmentRecordTypeId,
                    CaseNumber__c = xCase.Id,
                    Total_Late_Fee__c = 35000.00,
                    Amount_Waived__c = 30000.00,
                    Negotiated__c = true,
                    Fee_Type__c = 'LATE',
                    Fee_Code__c = 'ONLFEE',
                    Department__c = 'CS',
                    Reason_Comment__c = 'Testing high adjustment'
            ) ;
            System.debug('Adjustment='+adjustment);

            insert adjustment;

            adjustmentId = adjustment.Id;

            Refund_Adjustment__c adjustmentVerify = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustment.Id];

            System.assert(adjustmentVerify.Approver_Name__c == null, 'Approver Name='+adjustmentVerify.Approver_Name__c);
            System.assert(adjustmentVerify.Approval_Comment__c == null, 'Approval Comment='+adjustmentVerify.Approval_Comment__c);
            System.assert(adjustmentVerify.Decision_Date__c == null, 'Decision Date='+adjustmentVerify.Decision_Date__c);
            System.assert(adjustmentVerify.Approval_Status__c == 'Held', 'Approval Status='+adjustmentVerify.Approval_Status__c);

        }

        System.runAs(approver) {
            Boolean hasManagerPermission = System.FeatureManagement.checkPermission('CS_Manager');
            System.debug('User has CS Manager permission='+hasManagerPermission);
            Refund_Adjustment__c adjustment = [SELECT Id, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustmentId];
            adjustment.Approval_Status__c = 'Approved';
            String approvalComment = 'Adjustment sent';
            adjustment.Approval_Comment__c = approvalComment;

            update adjustment;

            Refund_Adjustment__c adjustmentVerify = [SELECT Id, Reason_Description__c, Reason_Comment__c, Unified_Fee_Code__c, Approval_Status__c,Approval_Comment__c, Decision_Date__c, Approver_Name__c FROM Refund_Adjustment__c WHERE Id =: adjustmentId];

            System.debug('adjustmentVerify.reasonDescription = '+adjustmentVerify.Reason_Description__c);
            System.debug('adjustmentVerify.UnifiedFeeCode = '+adjustmentVerify.Unified_Fee_Code__c);

            System.assert(adjustmentVerify.Approver_Name__c == approver.Id, 'Approver Name='+adjustmentVerify.Approver_Name__c);
            System.assert(adjustmentVerify.Approval_Comment__c == approvalComment, 'Approval Comment='+adjustmentVerify.Approval_Comment__c);
            System.assert(adjustmentVerify.Decision_Date__c > (System.now() - 15000), 'Decision Date='+adjustmentVerify.Decision_Date__c); // 15 seconds
            System.assert(adjustmentVerify.Approval_Status__c == 'Approved', 'Approval Status='+adjustmentVerify.Approval_Status__c);

            Boolean updateFailed = false;

            try {
                adjustmentVerify.Reason_Comment__c = 'This should provoke a failure';
                update adjustmentVerify;
            }
            catch(Exception e) {
                System.Assert(e.getMessage().contains('Refund/Adjustment entries cannot be changed once they have been Approved or Denied.'));
                updateFailed = true;
            }
            System.assert(updateFailed, 'UpdateFailed to fail!');

        }


        Test.stopTest();
    }

}