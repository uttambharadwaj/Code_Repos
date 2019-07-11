/*
* Trigger Framework Handler Base
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  implements ITriggerHandler to implement methods only as needed. Except mainEntry, which is required.
* Revision History:
*/

public abstract class TriggerHandlerBase implements ITriggerHandler {
    protected Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();
    protected Map<Id, SObject> sObjectsToInsert = new Map<Id, SObject>();

    /*
    * description: Called for the first time in the execution context. Trigger handlers need to implement this method.
    * param TriggerParameters: trigger parameters, ie list of records before and after the update.
    */
    public abstract void mainEntry(TriggerParameters tp);

    /*
    * description: Called for the subsequent times in the same execution context. Method is only needed for reentrants.
    * param TriggerParameters: trigger parameters, ie list of records before and after the update.
    */
    public virtual void inProgressEntry(TriggerParameters tp) {

    }

    /*
    * description: Updates objects
    */
    public virtual void updateObjects() {
        if(sObjectsToUpdate.size() > 0)
            update sObjectsToUpdate.values();
    }

    /*
    * description: Inserts objects
    */
    public virtual void insertObjects() {
        if(sObjectsToInsert.size() > 0)
            insert sObjectsToInsert.values();
    }
}