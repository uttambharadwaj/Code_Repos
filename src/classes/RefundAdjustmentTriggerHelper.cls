/**
 * Created by W083158 on 10/16/2019.
 */

public with sharing class RefundAdjustmentTriggerHelper {
    public static void insertRefAdj(List<Refund_Adjustment__c> records) {
        for (Refund_Adjustment__c refadj : records) {
            if (refadj.Amount_Waived__c > 500) {
                refadj.Approval_Status__c = 'Held';
            } else {
                refadj.Approval_Status__c = 'Pending';
            }
        }
    }

    public static void updateRefAdj(List<Refund_Adjustment__c> records, Map<Id, Refund_Adjustment__c> oldmap, Id userId) {
        Datetime now = System.now();

        for (Refund_Adjustment__c refadj : records) {
            Refund_Adjustment__c prior = oldmap.get(refadj.Id);
            if ((refadj.Approval_Status__c == 'Approved' || refadj.Approval_Status__c ==  'Denied') && refadj.Approval_Status__c != prior.Approval_Status__c) {
                refadj.Decision_Date__c = now;
                refadj.Approver_Name__c = userId;
            }
            
        }
    }
}