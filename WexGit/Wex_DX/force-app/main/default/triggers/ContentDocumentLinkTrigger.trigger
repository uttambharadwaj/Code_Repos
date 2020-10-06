/**
 * Created by jharrell on 8/10/20.
 */

trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
	TriggerFactory.createTriggerDispatcher(ContentDocumentLink.SObjectType);
}