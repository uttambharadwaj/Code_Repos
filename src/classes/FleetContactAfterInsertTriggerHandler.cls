public class FleetContactAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        FleetEnrollmentData.fleetEnrollmentDataUpdated((List<FleetEnrollment_Contact__c>) tp.newList);
    }
}