public class AttachmentAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        //TODO only pass attachments for fleet enrollment
        FleetEnrollmentData.fleetEnrollmentDataUpdated((List<Attachment>) tp.newList);
    }
}