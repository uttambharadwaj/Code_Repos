/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UCase.EmailToCaseOwernshipAssignment(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.associateWithEntitlement(tp.newList);

    }

}