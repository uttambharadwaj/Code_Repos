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
        for (Refund_Adjustment__c refadj : (List<Refund_Adjustment__c>)(setCon.getSelected())) {
            if (refadj.Approval_Status__c != 'Approved' && refadj.Approval_Status__c != 'Denied') {
                refadj.Approver_Name__c = UserInfo.getUserId();
                refadj.Decision_Date__c = System.now();
                refadj.Approval_Status__c = 'Approved';
                refadj.Approval_Comment__c = '';
            }
        }
        PageReference ref = setCon.save();
        System.debug('Ref='+ref);
        return ref;
    }
}