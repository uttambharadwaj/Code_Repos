/*
*
* Credit Decisioning Queueable Router
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
* Description:
*
* The intent of this code is to queue downstream credit decision
* jobs, versus using a future method. If a downstream queued job needs
* to then move onto something else, it can pass the application and
* subsequent operation to this process.
*
*/
public class CreditDecisionEngineQueueable {

    public static void runExperianPGChecks(Id applicationId) {

        System.enqueueJob(new CreditUtilQueueable_ExperianPG(applicationId));

    }

    public static void runEquifaxPGChecks(Id applicationId) {

        System.enqueueJob(new CreditUtilQueueable_EquifaxPG(applicationId));

    }
}