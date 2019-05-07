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


        Account account = new Account(Name='TestAccount',RecordTypeId=AccountRecordType);
        insert account;

        Case testCase = new Case(Account = account, Subject = 'TestCase', RecordTypeId = CaseRecordType);
        insert testCase;

        Id[] refundAdjustmentRecordTypes = new Id[2];
        refundAdjustmentRecordTypes[0] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Refund').getRecordTypeId();
        refundAdjustmentRecordTypes[1] = Schema.SObjectType.Refund_Adjustment__c.getRecordTypeInfosByName().get('Adjustment').getRecordTypeId();


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
                            Amount_Waived__c = i*150,
                            Approval_Status__c = approvalStatus,
                            Approver_Name__c   = tempUser,
                            Decision_Date__c   = decisionDate
                    );
            System.debug('### RefAdj '+i+': '+refadj);
            insert refadj;
        }
    }


    @IsTest
    static void testBehavior() {
        Test.startTest();
        Account testAccount = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        System.debug('### testAccount Id = '+testAccount.Id);
        List<PriorRefundAdjustmentListController.RefundAdjustmentRecord> resultList = PriorRefundAdjustmentListController.getPriorRefundAdjustments(testAccount.Id);
        integer j=0;
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
            j++;
        }
        Test.stopTest();
    }

    @IsTest
    static void throwError() {
        Test.startTest();
        String message = '';
        try {
            List<PriorRefundAdjustmentListController.RefundAdjustmentRecord> resultList = PriorRefundAdjustmentListController.getPriorRefundAdjustments(null);
        } catch (Exception e) {
            message = e.getMessage();
        }
        System.assert(message.length() > 0);
        Test.stopTest();
    }
    
}