/**
 * Created by dgilbert on 10/30/2018.
 */

trigger FSCCreditTaskTrigger on Task (after insert) {
/*
    static Boolean fscCreditTaskTriggerRunning = false;

    BOCA_Settings__c bocaSettings = BOCA_Settings__c.getOrgDefaults();

    System.debug('### ' + bocaSettings);

    if((bocaSettings.Enable_Credit_Task_Trigger__c == false || UserInfo.getUserId() == bocaSettings.BOCA_Integration_User_ID__c) && TestUtils.isRunningTest() == false) {
        return;
    }

    if(Trigger.isInsert && Trigger.isAfter) {

        if(System.isBatch() == false && System.isFuture() == false && FSCCreditTaskHandler.alreadyRunning == false) {
            FSCCreditTaskHandler.syncFSCTask(Trigger.new);
        }

    }
*/
}