/**
 * Created by lhowland on 8/31/2020.
 *
 * @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions
 *               on the ApplicationRequest object. The event handlers support allowing and preventing actions for reentrant scenarios.
 *               This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
 *               to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
 *               as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
 */

public with sharing class AppHistoryTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeInsertProcessing = false;

    /**
    * @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    */
    public virtual override void beforeInsert(TriggerParameters tp) {
        if (isBeforeInsertProcessing) execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert); else {
            isBeforeInsertProcessing = true;
            execute(new AppHistoryBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
    }

}