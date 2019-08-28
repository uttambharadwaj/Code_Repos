public class AttachmentAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        fleetEnrollmentHandler((List<Attachment>) tp.newList);
    }

    private static void fleetEnrollmentHandler(List<Attachment> attachments) {

        // Get any attachments with a Fleet_Enrollment__c parent
        List<Attachment> fleetEnrollmentAttachments = new List<Attachment>();
        for (Attachment attachment : attachments) {

            if (attachment.parentid.getSObjectType() == FleetEnrollment__c.getSObjectType()) {
                fleetEnrollmentAttachments.add(attachment);
            }
        }

        if (!fleetEnrollmentAttachments.isEmpty()) {
            FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentAttachments);
        }
    }

}