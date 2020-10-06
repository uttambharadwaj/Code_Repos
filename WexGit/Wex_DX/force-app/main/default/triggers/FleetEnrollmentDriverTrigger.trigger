trigger FleetEnrollmentDriverTrigger on FleetEnrollment_Driver__c (after insert) {
    TriggerFactory.createTriggerDispatcher(FleetEnrollment_Driver__c.SObjectType);
}