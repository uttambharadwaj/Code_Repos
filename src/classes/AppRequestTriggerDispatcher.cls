/**
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions
*               on the ApplicationRequest object. The event handlers support allowing and preventing actions for reentrant scenarios.
*               This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*               to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*               as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
*/

public class AppRequestTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;

    /**
    * @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    */
    public virtual override void beforeInsert(TriggerParameters tp) {
        if(isBeforeInsertProcessing) execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
        else {
            isBeforeInsertProcessing = true;
            execute(new AppRequestBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
            isBeforeInsertProcessing = false;
        }
    }

    /**
    * @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    */
    public virtual override void afterInsert(TriggerParameters tp) {
        if(isAfterInsertProcessing) execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        else {
            isAfterInsertProcessing = true;
            execute(new AppRequstAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isAfterInsertProcessing = false;
        }
    }

    /**
    * @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    */
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(isBeforeUpdateProcessing) execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
        else {
            isBeforeUpdateProcessing = true;
            execute(new AppRequestBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
    }

    /**
    * @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    */
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(isAfterUpdateProcessing) execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        else {
            isAfterUpdateProcessing = true;
            execute(new AppRequestAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }


}