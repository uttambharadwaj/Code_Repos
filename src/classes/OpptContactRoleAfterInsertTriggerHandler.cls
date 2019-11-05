public class OpptContactRoleAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        OpportunityHelper.updatePrimaryContact((List<OpportunityContactRole>) tp.newList, (List<OpportunityContactRole>) tp.oldList); // Updates Primary_Contact__c based on OpportunityContactRole Primary
    }
}