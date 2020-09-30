/**
 * Created by mfarrell on 9/24/20.
 */

public class CollectionsTriggerDispatcher extends TriggerDispatcherBase {
    private static Boolean isBeforeUpdateProcessing = false;

    /**
    * @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
    *               existing call running on the same context, the rentrant call will utilize the handler that was created
    *               in the original call.
    * @param tp (trigger parameters) Contains the trigger parameters which includes the record(s) that got updated.
    */
    public virtual override void beforeUpdate(TriggerParameters tp) {
        if (isBeforeUpdateProcessing) {
            execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
        } else {
            isBeforeUpdateProcessing = true;
            execute(new CollectionsBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
    }

}