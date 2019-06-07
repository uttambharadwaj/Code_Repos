/*
* Trigger Framework Handler Interface
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  Interface for trigger factory framework's handlers
*               first time events are placed in mainEntry method
*               reentries are placed in inProgressEntry method
* Revision History:
*/

public interface ITriggerHandler {
    /*
    * description: Called for the first time in the execution context.
    * param TriggerParameters The trigger parameters, ie list of records before and after update.
    */
    void mainEntry(TriggerParameters tp);

    /*
    * description: Called for the subsequent times in the same execution context.
    * param TriggerParameters The trigger parameters, ie list of records before and after update.
    */
    void inProgressEntry(TriggerParameters tp);

    /*
    * description: Updates the objects, if any.
    */
    void updateObjects();

    /*
    * description: Updates the objects, if any.
    */
    void insertObjects();
}