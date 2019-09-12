/**
 * Created by mfarrell on 2019-09-12.
 */

public class AppRequestAndFinallyTriggerHandler {

    public static void andFinallyMain() {

        system.debug('*** Hey! You! Im in andFinally!');
        runDecision(); // run app decisioning on ids from After Update Trigger
        clearVariables(); // clear set after decisioning

    }

    public static Set<Id> appsForCreditDecision = new Set<Id>();

    private static void runDecision() {

        if (appsForCreditDecision.size() > 0) {
            for (Id arId : appsForCreditDecision) {
                CreditDecisionEngineNA.runNADecisioningProcessFuture(arId);
            }
        }

    }

    private static void clearVariables() {

        appsForCreditDecision.clear();

    }

}