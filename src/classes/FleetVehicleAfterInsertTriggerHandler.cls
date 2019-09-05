public class FleetVehicleAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        FleetEnrollmentData.fleetEnrollmentDataUpdated((List<FleetEnrollment_Vehicle__c>) tp.newList);
    }
}