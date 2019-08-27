public class FleetVehicleAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        FleetEnrollmentData.fleetEnrollmentDataInserted((List<FleetEnrollment_Vehicle__c>) tp.newList);
    }
}