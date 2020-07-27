/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UCase.updateBusinessHours(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.accountDomainMatch(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.setDefaultEntitlement(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.associateContact(tp.newList, (Map<Id, Case>) tp.oldMap);

    }

}