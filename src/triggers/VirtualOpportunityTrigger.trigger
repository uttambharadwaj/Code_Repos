trigger VirtualOpportunityTrigger on Opportunity (before insert, before update, after update, after insert) {
/*
    if(Trigger.isBefore && Trigger.isInsert) {

        for(Opportunity opportunity : Trigger.new) {

            VirtualOpportunityTriggerHandler.setRamp(opportunity);

        }

    }
    else if(Trigger.isBefore && Trigger.isUpdate) {

        for(Opportunity opportunity : Trigger.new) {

            if(opportunity.Implementation_Revenue__c == null) {
                VirtualOpportunityTriggerHandler.setRamp(opportunity);
            }

            VirtualOpportunityTriggerHandler.updateRamp(Trigger.oldMap.get(opportunity.Id), opportunity);

        }

        WE_ImpProjectManager projectManager = new WE_ImpProjectManager(Trigger.oldMap,Trigger.newMap);
        projectManager.evaluateOpportunities();

        WE_WinLossSurvey survey = new WE_WinLossSurvey(Trigger.oldMap,Trigger.newMap);

    }
    else if(Trigger.isAfter && Trigger.isUpdate) {

        List<Id> lockedRecords = new List<Id>();

        for(Opportunity opportunity : Trigger.new) {

            if(Approval.isLocked(opportunity.Id)) {
                lockedRecords.add(opportunity.Id);
            }

            VirtualOpportunityTriggerHandler.generateMonthlyRevenueForecast(Trigger.oldMap.get(opportunity.Id), opportunity);

        }

        if(lockedRecords.size() > 0) {
            ApprovalProcessHandler.unlockRecord(lockedRecords);
        }

		WE_TargetManager target = new WE_TargetManager(Trigger.oldMap,Trigger.newMap);
        target.updateTargets();

        WE_ImpProjectManager projectManager = new WE_ImpProjectManager(Trigger.oldMap,Trigger.newMap);
        projectManager.evaluateOpportunities();

        WE_WinLossSurvey survey = new WE_WinLossSurvey(Trigger.oldMap,Trigger.newMap);

    }
*/
}