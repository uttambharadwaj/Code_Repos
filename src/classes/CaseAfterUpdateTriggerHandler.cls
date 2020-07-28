/**
 * Created by mfarrell on 7/26/20.
 */

public class CaseAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        //TODO Move all UCase methods to CaseHelper, refactoring may be required
//        UCase.EmailToCaseOwernshipAssignment(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.sendCaseCloseEmailToOpportunityOwner(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.sendCaseCloseSurveyEmail(tp.newList, (Map<Id, Case>) tp.oldMap);
        UCase.associateWithEntitlement(tp.newList);

        CaseHelper.completeCaseMilestone(tp.newList, (Map<Id, Case>) tp.oldMap);

    }

}