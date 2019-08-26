public with sharing class FleetContactAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        FleetEnrollmentData.fleetEnrollmentDataInserted((List<FleetEnrollment_Contact__c>) tp.newList);
    }
}