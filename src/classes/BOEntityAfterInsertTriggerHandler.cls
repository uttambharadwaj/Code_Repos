public class BOEntityAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        BOEntityHelper.updateOpportunity((List<Beneficial_Owner_Entity__c>) tp.newList); // set the beneficialownerentity on oppty
    }

}