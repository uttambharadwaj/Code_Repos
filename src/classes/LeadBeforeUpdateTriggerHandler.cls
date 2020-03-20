/**
 * Created by mfarrell on 3/20/20.
 */

public with sharing class LeadBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        ULead.updateCountryCode(tp.newList, (Map<Id, Lead>) tp.oldMap); // Update Mobile Phone country code based on associated program
        ULead.setTotalVehicles(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.setVehicleCount(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.linktoContactAccount(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.eloquaPassParent(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.setMarketable(tp.newList, (Map<Id, Lead>) tp.oldMap);
        LeadHelper.leadSplitsBeforeUpdate(tp.newList);
        LeadHelper.sfIdtoCardId(tp.newList);
        LeadHelper.auValidateSuburbPostcode(tp.newList);

    }

}