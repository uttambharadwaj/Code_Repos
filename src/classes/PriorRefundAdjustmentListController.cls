/**
 * Created by W083158 on 5/3/2019.
 */

public with sharing class PriorRefundAdjustmentListController {

    public class RefundAdjustmentRecord {
        public RefundAdjustmentRecord(Refund_Adjustment__c refadj) {
            if (refadj.Id != null) {
                this.Id = refadj.Id;
                this.IdLink = '/' +  refadj.Id;
            }
            if (refadj.Name != null)
                this.Name = refadj.Name;
            if ( refadj.RecordType != null && refadj.RecordType.DeveloperName != null)
                this.DeveloperName = refadj.RecordType.DeveloperName;
            if (refadj.CaseNumber__c != null) {
                this.CaseId = refadj.CaseNumber__c;
                this.CaseIdLink = '/' + refadj.CaseNumber__c;
            }

            if ( refadj.CaseNumber__r != null &&  refadj.CaseNumber__r.CaseNumber != null)
                this.CaseNumber = refadj.CaseNumber__r.CaseNumber;
            if (refadj.Total_Late_Fee__c != null)
                this.Amount_Requested = refadj.Total_Late_Fee__c;
            if (refadj.Amount_Waived__c != null)
                this.Amount_Waived = refadj.Amount_Waived__c;
            if (refadj.Approval_Status__c != null)
                this.Approval_Status = refadj.Approval_Status__c;
            if (refadj.Approver_Name__r != null && refadj.Approver_Name__r.Name != null)
                this.Approver_Name = refadj.Approver_Name__r.Name;
            if (refadj.Department__c != null)
                this.Department = refadj.Department__c;
            if (refadj.Decision_Date__c != null)
                this.Decision_Date = refadj.Decision_Date__c.format();
            if (refadj.CreatedDate != null)
                this.CreatedDate = refadj.CreatedDate.format();
            if (refadj.CreatedBy != null)
                this.CreatedBy = refadj.CreatedBy.Name;
        }

        public RefundAdjustmentRecord(RefundAdjustment refadj, String recordTypeName) {
            if (refadj.ID != null) {
                this.Id = String.valueOf(refadj.ID);
                this.IdLink = '';
            }
            if (refadj.Name != null)
                this.Name = refadj.Name;
            if ( recordTypeName != null)
                this.DeveloperName = recordTypeName;
            if (refadj.caseNumber != null) {
                this.CaseNumber = refadj.caseNumber;
            }
            if (refadj.amountRequested != null)
                this.Amount_Requested = refadj.amountRequested;
            if (refadj.amount != null)
                this.Amount_Waived = refadj.amount;
            if (refadj.approvalStatus != null)
                this.Approval_Status = refadj.approvalStatus;
            if (refadj.approverName != null)
                this.Approver_Name = refadj.approverName;
            if (refadj.department != null)
                this.Department = refadj.department;
            if (refadj.decisionDate != null)
                this.Decision_Date = refadj.decisionDate;
            if (refadj.createdDate != null)
                this.CreatedDate = refadj.createdDate;
            if (refadj.createdBy != null)
                this.CreatedBy = refadj.createdBy;
        }

        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String IdLink { get; set; }
        @AuraEnabled public String Name{ get; set; }
        @AuraEnabled public String DeveloperName { get; set; }
        @AuraEnabled public String CaseId { get; set; }
        @AuraEnabled public String CaseIdLink { get; set; }
        @AuraEnabled public String CaseNumber { get; set; }
        @AuraEnabled public Decimal Amount_Requested { get; set; }
        @AuraEnabled public Decimal Amount_Waived { get; set; }
        @AuraEnabled public String Approval_Status { get; set; }
        @AuraEnabled public String Approver_Name { get; set; }
        @AuraEnabled public String Department { get; set; }
        @AuraEnabled public String Decision_Date { get; set; }
        @AuraEnabled public String CreatedDate { get; set; }
        @AuraEnabled public String CreatedBy { get; set; }
    }

    @AuraEnabled
    public static List<RefundAdjustmentRecord> getPriorRefundAdjustments(String accountId, Id recordTypeId) {
        System.debug('"*** Entering getPriorRefundAdjustments for accountId '+accountId+' and recordTypeId '+recordTypeId);
        List<RefundAdjustmentRecord> result = new List<RefundAdjustmentRecord>();
        try {
            for (Refund_Adjustment__c refadj : [SELECT Id, Name, RecordType.DeveloperName,CaseNumber__c, CaseNumber__r.CaseNumber, Total_Late_Fee__c, Amount_Waived__c, Approval_Status__c, Approver_Name__r.Name, Department__c, Decision_Date__c, CreatedDate, CreatedBy.Name FROM Refund_Adjustment__c WHERE Account__c =: accountId AND RecordTypeId =: recordTypeId ORDER BY CreatedDate DESC]) {
                result.add(new RefundAdjustmentRecord (refadj) );
            }

            if (Test.isRunningTest() && accountId == null) {
                Exception x = new NullPointerException();
                x.setMessage('Null account number received');
                throw x;
            }

            System.debug('Number of existing records in Salesforce: '+result.size());

            Account account = [SELECT Id, Wex_Account__c FROM Account WHERE Id =: accountId];
            System.debug('Account number: '+account.Wex_Account__c);

            RecordType recordType = [SELECT Id, DeveloperName FROM RecordType WHERE Id =: recordTypeId];
            System.debug('RecordType: '+recordType.DeveloperName);

            RefundAdjustmentRequest dbRequest = new RefundAdjustmentRequest();
            dbRequest.recordTypeName = recordType.DeveloperName;
            dbRequest.wexAccountNbr = account.Wex_Account__c;

            List<RefundAdjustmentRequest> dbRequestList = new List<RefundAdjustmentRequest>();
            dbRequestList.add(dbRequest);

            System.debug('*** Entering RefundAdjustmentOldDataPuller.getPriorRefundAdjustments');
            List<RefundAdjustmentResult> dbResultList = RefundAdjustmentOldDataPuller.getPriorRefundAdjustments(dbRequestList);
            System.debug('*** Leaving RefundAdjustmentOldDataPuller.getPriorRefundAdjustments; result big list count (should be 1: '+dbResultList.size());
            if (dbResultList.size()>0) {
                List<RefundAdjustment> dbResult = dbResultList.get(0).refundAdjustments;
                System.debug('*** RefundAdjustmentOldDataPuller.getPriorRefundAdjustments inner result count: '+dbResult.size());
                for (RefundAdjustment refadj : dbResult) {
                    result.add(new RefundAdjustmentRecord (refadj,recordType.DeveloperName) );
                }
            }

            System.debug('"*** Leaving getPriorRefundAdjustments, RecordCount '+result.size());
            return result;
        } catch(Exception e) {

            String errorCode = logError(e, accountId);

            throw new AuraHandledException('Unable to retrieve number of cases today for account. (Error Tracking Code: ' + errorCode + ')');

        }
    }

    private static String logError(Exception e, String accountId) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Error_Message__c = String.valueOf(e) + ' For AccountID ' + accountId;
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Prior Refunds and Adjustments';

            insert error;

            List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }

        }
        catch(Exception f) {

            System.debug('Error logging exception.. Skipping..');

            return '';

        }
    }

}