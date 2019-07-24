/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase{

    public override void mainEntry(TriggerParameters tp) {
        OpportunityHelper.checkFleetEnrollment((List<Opportunity>) tp.newList); // create new or update existing FleetEnrollment__c on Fuel Card Oppty
    }

}
