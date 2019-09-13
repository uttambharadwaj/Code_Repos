/**
 * Created by mfarrell on 2019-09-12.
 */

public class AppRequestAndFinallyTriggerHandler {

    public static void andFinallyMain() {

        runDecision(); // run app decisioning on ids from After Update Trigger
        clearVariables(); // clear set after decisioning

    }

    private static void runDecision() {

        Set<Id> arIds = AppRequestTriggerDispatcher.appsForCreditDecision;

        if (arIds.size() > 0) {
            for (Id arId : arIds) {
                CreditDecisionEngineNA.runNADecisioningProcessFuture(arId);
            }
        }

    }

    private static void clearVariables() {

        AppRequestTriggerDispatcher.appsForCreditDecision.clear();

    }

}