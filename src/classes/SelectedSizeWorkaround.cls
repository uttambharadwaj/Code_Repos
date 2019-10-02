/**
 * Created by W083158 on 4/24/2019.
 */

public with sharing class SelectedSizeWorkaround {
    ApexPages.StandardSetController setCon;

    public selectedSizeWorkaround(ApexPages.StandardSetController controller) {
        setCon = controller;
        
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }

    public PageReference updateRecords() {
        ((Refund_Adjustment__c)(setCon.getRecord())).Approver_Name__c = UserInfo.getUserId();
        ((Refund_Adjustment__c)(setCon.getRecord())).Decision_Date__c = System.now();
        return setCon.save();
    }
}