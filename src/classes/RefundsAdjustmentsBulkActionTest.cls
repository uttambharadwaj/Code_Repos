/**
 * Created by W083158 on 5/7/2019.
 */

@IsTest
private class RefundsAdjustmentsBulkActionTest {
    @testSetup
    static void setup() {

        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        Id CaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Operations').getRecordTypeId();

        List<User> userList = [SELECT Id, Name FROM User WHERE IsActive = TRUE LIMIT 1];

        List<User> ownerList = [SELECT Id, Name, Role_Name__c FROM User WHERE IsActive = TRUE AND Role_Name__c <> NULL LIMIT 1];

        Id owner = ownerList[0].Id;

        insert new VProfileId__c(Virtual_User__c = false);

        Account account = new Account(Name='TestAccount',RecordTypeId=AccountRecordType);
        insert account;

        Case testCase = new Case(Account = account, Subject = 'TestCase', RecordTypeId = CaseRecordType, OwnerId = owner);
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
                            Total_Late_Fee__c = i*150,
                            Approval_Status__c = approvalStatus,
                            Approver_Name__c   = tempUser,
                            Decision_Date__c   = decisionDate,
                            Department__c = 'CS',
                            Reason_Comment__c = 'Test comment'
                    );
            System.debug('### RefAdj '+i+': '+refadj);
            insert refadj;
        }

    }

    @IsTest
    static void testBehavior() {
        Test.startTest();
        Test.setCurrentPage(Page.Refunds_Adjustments_Bulk_Approver);
        Account testAccount = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        List<Refund_Adjustment__c> refadjs = [SELECT Id, Name, RecordType.DeveloperName,CaseNumber__c, CaseNumber__r.CaseNumber, Amount_Waived__c, Approval_Status__c, Approver_Name__r.Name, Decision_Date__c, CreatedDate FROM Refund_Adjustment__c WHERE Account__c =: testAccount.Id ORDER BY CreatedDate DESC];
        List<Refund_Adjustment__c> selectedRefadjs = [SELECT Id, Name, RecordType.DeveloperName,CaseNumber__c, CaseNumber__r.CaseNumber, Amount_Waived__c, Approval_Status__c, Approver_Name__r.Name, Decision_Date__c, CreatedDate FROM Refund_Adjustment__c WHERE Account__c =: testAccount.Id LIMIT 1];
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(refadjs);
        stdSetController.setSelected(selectedRefadjs);
        RefundsAdjustmentsBulkAction ext = new RefundsAdjustmentsBulkAction(stdSetController);
        List<SelectOption> approvalOptions = ext.getApprovalOptions();
        System.assert(approvalOptions.size() == 4);
        System.assert(approvalOptions.get(0).getDisabled() == true);
        System.assert(ext.getMyRecordsSize() == 5);
        System.assert(ext.getMySelectedSize() == 1);
        PageReference pageReference = ext.updateRecords();
        System.assert(pageReference != null);
        System.debug('### ref = '+ pageReference);
        Test.stopTest();
    }

}