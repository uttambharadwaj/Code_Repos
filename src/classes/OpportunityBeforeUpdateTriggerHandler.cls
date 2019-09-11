/**
 * Created by MFarrell on 7/24/2019.
 */

public class OpportunityBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        OpportunityHelper.checkFleetEnrollment((List<Opportunity>) tp.newList, (Map<Id, Opportunity>) tp.oldMap); // create new or update existing FleetEnrollment__c on Fuel Card Oppty

    }

}