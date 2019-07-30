public class BOEntityBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
    	BOEntityHelper.updateExemptionStatus((List<Beneficial_Owner_Entity__c>) tp.newList);
    }

}