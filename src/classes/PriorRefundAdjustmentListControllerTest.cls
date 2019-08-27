/**
 * Created by W083158 on 5/6/2019.
 */

@IsTest
private class PriorRefundAdjustmentListControllerTest {


    @testSetup
    static void setup() {

        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        Id CaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        List<User> userList = [SELECT Id, Name FROM User WHERE IsActive = true LIMIT 1];

        List<User> ownerList = [SELECT Id, Name, Role_Name__c FROM User WHERE IsActive = TRUE AND Role_Name__c <> NULL LIMIT 1];

        Id owner = ownerList[0].Id;

        insert new VProfileId__c(Virtual_User__c = false);

        Account account = new Account(Name='TestAccount',RecordTypeId=AccountRecordType, Type='Customer', Wex_Account__c='9100000000000' );
        insert account;

        Case testCase = new Case(Account = account, Subject = 'TestCase', RecordTypeId = CaseRecordType, OwnerId = owner);
        insert testCase;

        Id[] refundAdjustmentRecordTypes = new Id[2];

        refundAdjustmentRecordTypes[0] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Refund').getRecordTypeId();
        refundAdjustmentRecordTypes[1] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();

        System.debug('RecordTypeId 0 ='+refundAdjustmentRecordTypes[0]);
        System.debug('RecordTypeId 1 ='+refundAdjustmentRecordTypes[1]);

        Id approvingUser = userList[0].Id;
        System.debug('### approvingUser='+approvingUser);

        for (Integer i=1; i<6; i++) {
            String approvalStatus = 'Pending';
            Id tempUser = null;
            Datetime decisionDate = null;
            if (i*150 < 500) {
                approvalStatus = 'Approved';
                tempUser   = approvingUser;
                decisionDate   = System.now();
            }

            Refund_Adjustment__c refadj = new Refund_Adjustment__c
                    (RecordTypeId = refundAdjustmentRecordTypes[Math.mod(i,2)],
                            Account__c = account.Id,
                            CaseNumber__c = testCase.Id,
                            Total_Late_Fee__c = i*150,
                            Amount_Waived__c = i*150,
                            Approval_Status__c = approvalStatus,
                            Approver_Name__c   = tempUser,
                            Department__c  = 'CS',
                            Decision_Date__c   = decisionDate
                    );
            System.debug('### RefAdj '+i+': '+refadj);
            insert refadj;
        }
    }


    @IsTest
    static void testBehavior() {
        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());
        Test.startTest();
        Account testAccount = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        System.debug('### testAccount Id = '+testAccount.Id);
        Integer recordTypeSelector = Math.mod(Integer.valueOf(Math.random() * 10),2);

        Id[] refundAdjustmentRecordTypes = new Id[2];

        refundAdjustmentRecordTypes[0] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Refund').getRecordTypeId();
        refundAdjustmentRecordTypes[1] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();

        System.debug('RecordTypeId 0 ='+refundAdjustmentRecordTypes[0]);
        System.debug('RecordTypeId 1 ='+refundAdjustmentRecordTypes[1]);

        List<PriorRefundAdjustmentListController.RefundAdjustmentRecord> resultList = PriorRefundAdjustmentListController.getPriorRefundAdjustments(testAccount.Id, refundAdjustmentRecordTypes[recordTypeSelector]);
        List<String> desiredDeveloperNameList = new String[2];
        desiredDeveloperNameList[0] = 'Refund';
        desiredDeveloperNameList[1] = 'Adjustment';

        String desiredDeveloperName = desiredDeveloperNameList[recordTypeSelector];
        System.debug('Validating recordTypeSelector ' + recordTypeSelector+ ', '+desiredDeveloperName);
        Integer j=0;
        System.assert(resultList.size() > 0);
        for (PriorRefundAdjustmentListController.RefundAdjustmentRecord record : resultList) {
            System.debug('***** Record '+j);
            System.debug('Id='+record.Id);
            System.debug('IdLink='+record.IdLink);
            System.debug('Name='+record.Name);
            System.debug('DeveloperName='+record.DeveloperName);
            System.debug('CaseId='+record.CaseId);
            System.debug('CaseIdLink='+record.CaseIdLink);
            System.debug('CaseNumber='+record.CaseNumber);
            System.debug('Amount_Waived='+record.Amount_Waived);
            System.debug('Approval_Status='+record.Approval_Status);
            System.debug('Approver_Name='+record.Approver_Name);
            System.debug('Decision_Date='+record.Decision_Date);
            System.debug('CreatedDate='+record.CreatedDate);
            System.assert(record.Amount_Waived < 500 || record.Approval_Status != 'Approved');
            System.assert(record.DeveloperName == desiredDeveloperName);
            j++;
        }
        Test.stopTest();
    }

    @IsTest
    static void throwError() {
        Test.startTest();
        String message = '';
        try {
            List<PriorRefundAdjustmentListController.RefundAdjustmentRecord> resultList = PriorRefundAdjustmentListController.getPriorRefundAdjustments(null,null);
        } catch (Exception e) {
            message = e.getMessage();
        }
        System.assert(message.length() > 0);
        Test.stopTest();
    }
    
}