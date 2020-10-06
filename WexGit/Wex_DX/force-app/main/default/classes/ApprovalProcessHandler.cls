/*
*
* Custom hooks for the SFDC Approval Process
*
 */
public with sharing class ApprovalProcessHandler {

    // Custom setting with approval process bypass
    public static List<Id> exemptProcessDefinitionIds { get; set; }
    
    @future
    public static void unlockRecord(List<Id> targetObjectIds) {

        exemptProcessDefinitionIds = new List<Id>();
        for(Approval_Process_Locking_Bypass__mdt approvalProcessLockingBypass : [SELECT Id, Approval_Process_ID__c FROM Approval_Process_Locking_Bypass__mdt WHERE Enable_Bypass__c = true]) {
            exemptProcessDefinitionIds.add(Id.valueOf(approvalProcessLockingBypass.Approval_Process_ID__c));
        }
        
        for(ProcessInstance processInstance : [SELECT Id, TargetObjectId, ProcessDefinitionId FROM ProcessInstance WHERE Status = 'Pending' and TargetObjectId in :targetObjectIds]) {
            
            if(exemptProcessDefinitionIds.contains(processInstance.ProcessDefinitionId)) { Approval.unlock(processInstance.TargetObjectId); }

        }

    }

}