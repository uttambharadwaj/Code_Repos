/**
 * Created by mfarrell on 4/13/20.
 * Used by relatedActivities LWC to get list of activities related to the current object.
 */

public inherited sharing class LWC_TasksController {

    @AuraEnabled(Cacheable = true)
    public static List<Task> getAllTasks(Integer pageNumber, Integer numberOfRecords, Integer pageSize, String recordId) {
        System.debug(pageNumber);
        System.debug(pageSize);
        System.debug(numberOfRecords);
        System.debug(recordId);
        String taskQuery = 'SELECT Id, Subject, Description, Type, CreatedById, Owner.Name, WhatId, ActivityDate, LastModifiedDate FROM Task';
        if (recordId != null && recordId != '') {
            taskQuery += ' WHERE WhatId =: recordId';
        }
        taskQuery += ' ORDER BY ActivityDate DESC';
        taskQuery += ' LIMIT ' + pageSize + ' OFFSET ' + (pageSize * (pageNumber -1));

        return Database.query(taskQuery);
    }

    @AuraEnabled(Cacheable = true)
    public static Integer getTaskCount(String recordId) {
        System.debug(recordId);
        String countQuery = 'SELECT count() FROM Task ';
        if (recordId != null && recordId != '') {
            countQuery += ' WHERE WhatId =: recordId';
        }
        return Database.countQuery(countQuery);
    }

}