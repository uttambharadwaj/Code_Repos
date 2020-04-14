/**
 * Created by mfarrell on 4/13/20.
 * Used by relatedActivities LWC to get list of activities related to the current object.
 */

public inherited sharing class LWC_ActivitiesController {

    @AuraEnabled(Cacheable=true)
    public static List<Task> getAllActivities(String recordId) {
        return [
            SELECT Id, Subject, Description, Type, CreatedById, Owner.Name, WhatId, ActivityDate, LastModifiedDate
            FROM Task
            WHERE WhatId =: recordId
            ORDER BY ActivityDate DESC
        ];
    }

}