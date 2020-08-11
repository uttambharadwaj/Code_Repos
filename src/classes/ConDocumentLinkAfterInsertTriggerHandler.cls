public class ConDocumentLinkAfterInsertTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp) {
		ContentDocumentLinkHelper.fleetEnrollmentContentDocumentAdded(tp.newList);
	}
}