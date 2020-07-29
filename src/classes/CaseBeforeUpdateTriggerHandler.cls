/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        //TODO Move all UCase methods to CaseHelper, refactoring may be required
        UCase.setDefaultEntitlement(tp.newList, (Map<Id, Case>) tp.oldMap);

    }

}