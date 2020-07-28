/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UCase.setDefaultEntitlement(tp.newList, (Map<Id, Case>) tp.oldMap);

    }

}