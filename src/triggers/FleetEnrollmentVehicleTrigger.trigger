trigger FleetEnrollmentVehicleTrigger on FleetEnrollment_Vehicle__c (after insert) {
    TriggerFactory.createTriggerDispatcher(FleetEnrollment_Vehicle__c.SObjectType);
}