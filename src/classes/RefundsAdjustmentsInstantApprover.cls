/**
 * Created by W083158 on 4/24/2019.
 */

public with sharing class RefundsAdjustmentsInstantApprover {
    ApexPages.StandardSetController setCon;

    public RefundsAdjustmentsInstantApprover(ApexPages.StandardSetController controller) {
        System.debug('Load RefundsAdjustmentsInstantApprover');
        setCon = controller;
        ((Refund_Adjustment__c)(setCon.getRecord())).Approver_Name__c = UserInfo.getUserId();
        ((Refund_Adjustment__c)(setCon.getRecord())).Decision_Date__c = System.now();

    }

    public PageReference updateRecords() {
        System.debug('Saving RefundsAdjustmentsInstantApprover');
        System.debug('Updating record count: '+setCon.getSelected().size());
        String dateString = System.now().format('MMddYY')+ ' ';

        //IF all the records were selected, and all the records are the same record type,
        //forward to the appropriate report to extract and send to Finance.
        String recordTypeName;
        Boolean allAlike = (setCon.getSelected().size() == setCon.getResultSize());
        for (Refund_Adjustment__c refadj : (List<Refund_Adjustment__c>)(setCon.getSelected())) {
            if (refadj.Approval_Status__c != 'Approved' && refadj.Approval_Status__c != 'Denied') {
                if (recordTypeName == null) {
                    recordTypeName = refadj.RecordType.DeveloperName;
                } else {
                    allAlike = (allAlike && (recordTypeName.equals(refadj.RecordType.DeveloperName)));
                }
                refadj.Approver_Name__c = UserInfo.getUserId();
                refadj.Decision_Date__c = System.now();
                refadj.Approval_Status__c = 'Approved';
                refadj.Approval_Comment__c = '';
                refadj.Iten_id__c = RefundsAdjustmentsCommon.getItemId(refadj);
                System.debug(refadj);
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