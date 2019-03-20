trigger EMAP_RiskFlag on Risk_Flag__c (before insert, before update) {
    EMAP_RiskFlag_Handler.updateClosedFields(Trigger.new, Trigger.oldMap);
}