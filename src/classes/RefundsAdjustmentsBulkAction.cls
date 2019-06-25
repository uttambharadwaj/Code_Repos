/**
 * Created by W083158 on 4/24/2019.
 */

public with sharing class RefundsAdjustmentsBulkAction {
    ApexPages.StandardSetController setCon;

    public RefundsAdjustmentsBulkAction(ApexPages.StandardSetController controller) {
        setCon = controller;
        ((Refund_Adjustment__c)(setCon.getRecord())).Approver_Name__c = UserInfo.getUserId();
        ((Refund_Adjustment__c)(setCon.getRecord())).Decision_Date__c = System.now();
    }

    public Integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public Integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }

    public List<SelectOption> getApprovalOptions() {
        List<SelectOption> newApprovalOptions = new List<SelectOption>();
        newApprovalOptions.add(new SelectOption('Pending','Pending',true)); //That last boolean is isDisabled.
        newApprovalOptions.add(new SelectOption('Approved','Approved'));
        newApprovalOptions.add(new SelectOption('Held','Held'));
        newApprovalOptions.add(new SelectOption('Denied','Denied'));
        return newApprovalOptions;
    }

    public PageReference updateRecords() {
        //IF all the records were selected, and all the records are the same record type,
        //forward to the appropriate report to extract and send to Finance.
        String recordTypeName;
        Boolean allAlike = (setCon.getSelected().size() == setCon.getResultSize());
        if (((Refund_Adjustment__c)(setCon.getRecord())).Approval_Status__c == 'Held') {
            ((Refund_Adjustment__c) (setCon.getRecord())).Decision_Date__c = null;
        } else if (((Refund_Adjustment__c)(setCon.getRecord())).Approval_Status__c == 'Approved') {
            for (Refund_Adjustment__c refadj : (List<Refund_Adjustment__c>)(setCon.getSelected())) {
                if (recordTypeName == null) {
                    recordTypeName = refadj.RecordType.DeveloperName;
                } else {
                    allAlike = (allAlike && (recordTypeName.equals(refadj.RecordType.DeveloperName)));
                }
                refadj.Iten_id__c = RefundsAdjustmentsCommon.getItemId(refadj);
            }
        }
        PageReference ref = setCon.save();
        if (allAlike && recordTypeName != null) {
            String url;
            if ('Refund'.equals(recordTypeName)) {
                url = RefundsAdjustmentsCommon.getRefundsPageRef();
            } else if ('Adjustment'.equals(recordTypeName)) {
                url = RefundsAdjustmentsCommon.getAdjustmentsPageRef();
            }
            if (url != null) {
                ref = new PageReference(url);
            }
        }
        System.debug('Ref='+ref);
        return ref;
    }
}