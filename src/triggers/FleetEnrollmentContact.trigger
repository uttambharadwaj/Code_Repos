trigger FleetEnrollmentContact on FleetEnrollment_Contact__c (after insert) {
    TriggerFactory.createTriggerDispatcher(FleetEnrollment_Contact__c.SObjectType);
}