trigger CPProjectsTrigger on CP_Projects__c (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate) {

        System.debug(Trigger.new);
        
        List<Id> lockedRecords = new List<Id>();

        for (CP_Projects__c cpProject : Trigger.new) {

            CP_Projects__c oldCPProject = Trigger.oldMap.get(cpProject.Id);
            
            if (oldCPProject != null && oldCPProject.WF_Approval_Submitted__c != cpProject.WF_Approval_Submitted__c) {
                lockedRecords.add(cpProject.Id);
            }

        }

        if (lockedRecords.size() > 0) {
            ApprovalProcessHandler.unlockRecord(lockedRecords);
        }

    }

}