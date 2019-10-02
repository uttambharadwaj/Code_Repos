/*
* Trigger Framework Factory Class
* Author: Jason Arbegast
* Initial Date: 5/14/2019
* Description:  creates dispatcher and dispatches events to appropriate handlers
*               dispatchers created with Type API, so no registration needed for each dispatcher
* Revision History:
*/

public class TriggerFactory{

    //some objects have pesky long names. put them here. this should be the only thing that ever needs modifying in this class
    //if this gets too crazy we can create metadata or custom setting. but not yet.
    private static final Map<String, String> objTypeMap = new Map<String,String>{'Beneficial_Owner_Entity__c'=>'BOEntity',
    'Beneficial_Owner_Prong__c'=>'BOProng',
    'Application_Request__c'=>'AppRequest',
    'FleetEnrollment__c'=>'FleetEnroll'};

    /*
    * description Creates the appropriate dispatcher and dispatches the trigger event to the dispatcher's event handler method.
    *               This is the method called by every trigger.
    * param Schema.sObjectType Object type to process (SObject.sObjectType)
    */
    public static void createTriggerDispatcher(Schema.sObjectType soType){

        if(disabledTriggers(soType))
            return;

        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if (dispatcher == null)
            throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);

        execute(dispatcher);
    }

    /*
    check custom settings to see if triggers are turned off
    check for all triggers turned off (for dataloading) or just this object
    */
    public static Boolean disabledTriggers(Schema.sObjectType soType){
        //this isrunningtest try/catch block is only needed until all tests convert to inserting Automation Settings. delete when tests are properly converted
        Automation_Settings__c setting = Automation_Settings__c.getInstance();
        if(setting.Disable_Apex_Triggers__c) return True;

        String fieldName = 'Disable_' + getObjTypeName(soType) + '_Trigger__c';

        return ((Boolean)setting.get(fieldName)) ? True : False;
    }

    //get the object name used by trigger framework
    private static String getObjTypeName(Schema.sObjectType soType){
        String objType = soType.getDescribe().getName();
        if(objTypeMap.containsKey(objType)){
            return objTypeMap.get(objType);
        } else {
            Integer index = objType.toLowerCase().indexOf('__c');
            if(index<0)
                index=objType.length();
            return objType.substring(0,index).replace('_','');
        }
    }

    /*
    * description creates parameter object and dispatch to the dispatcher's event handlers.
    * param ITriggerDispatcher A Trigger dispatcher that dispatches to the appropriate handlers
    */
    private static void execute(ITriggerDispatcher dispatcher){
        TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap,
                Trigger.isBefore, Trigger.isAfter, Trigger.isDelete,
                Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting);
        // Handle before trigger events
        if (Trigger.isBefore) {
            dispatcher.bulkBefore();

            if (Trigger.isDelete){
                dispatcher.beforeDelete(tp);
            }else if (Trigger.isInsert){
                dispatcher.beforeInsert(tp);
            }else if (Trigger.isUpdate){
                dispatcher.beforeUpdate(tp);
            }
        }else{    // Handle after trigger events

            dispatcher.bulkAfter();
            if (Trigger.isDelete)
                dispatcher.afterDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.afterInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.afterUpdate(tp);
        }
        dispatcher.andFinally();
    }

    /*
    * description: Get dispatcher based on the SObject.
    *               Construct the instance of the dispatcher
    * param Schema.sObjectType Object type to create dispatcher for
    * return ITriggerDispatcher A trigger dispatcher if one exists or null.
    */
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType){
        String dispatcherTypeName = getObjTypeName(soType) + 'TriggerDispatcher';

        Type obType = Type.forName(dispatcherTypeName);
        ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
        return dispatcher;
    }
}