/**
 * Created by lhowland on 8/31/2020.
 */

public with sharing class AppHistoryBeforeInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        appHistoryBeforeInsert((List<Application_History__c>) tp.newList);

    }

    private static void appHistoryBeforeInsert(List<Application_History__c> appHistoryList) {

        // When a new history record is created, take that CreatedDate and set it as the End Date for the most recent existing history record.
        // NOTE: if this eventually gets implemented for a different application object, this will need to be split into methods per app object
        List<Id> naFleetAppIds = new List<Id>();
        for (Application_History__c appHistory : appHistoryList) {
            naFleetAppIds.add(appHistory.NA_Fleet_App__c);
        }
        System.debug('List of NA App IDs: from App Histories: ' + naFleetAppIds);

        // For all given App IDs, find the most recent app history objects
        List<AggregateResult> existingHistories = [SELECT NA_Fleet_App__c, Max(Id) appHistoryIdAlias FROM Application_History__c WHERE NA_Fleet_App__c IN :naFleetAppIds AND End_Date__c = NULL GROUP BY NA_Fleet_App__c];

        if (existingHistories != null) {
            List<Application_History__c> updatedExistingAppHistories = new List<Application_History__c>();
            for (AggregateResult ar : existingHistories) {
                Id appHistoryId = (Id)ar.get('appHistoryIdAlias');
                Application_History__c appHistory = new Application_History__c(Id = appHistoryId, End_Date__c = Datetime.now());
                updatedExistingAppHistories.add(appHistory);
            }
            upsert updatedExistingAppHistories;
        } // if null, no need to update End Date field
    }
}