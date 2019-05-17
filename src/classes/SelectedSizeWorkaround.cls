/**
 * Created by W083158 on 4/24/2019.
 */

public with sharing class SelectedSizeWorkaround {
    ApexPages.StandardSetController setCon;

    public selectedSizeWorkaround(ApexPages.StandardSetController controller) {
        setCon = controller;
        ((Refund_Adjustment__c)(setCon.getRecord())).Approver_Name__c = UserInfo.getUserId();
        ((Refund_Adjustment__c)(setCon.getRecord())).Decision_Date__c = System.now();
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
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
        return setCon.save();
    }
}