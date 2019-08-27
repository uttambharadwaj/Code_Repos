public class FleetDriverAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        FleetEnrollmentData.fleetEnrollmentDataInserted((List<FleetEnrollment_Driver__c>) tp.newList);
    }
}