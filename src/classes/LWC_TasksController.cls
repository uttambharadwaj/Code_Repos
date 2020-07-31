/**
 * Created by mfarrell on 4/13/20.
 * Used by relatedActivities LWC to get list of activities related to the current object.
 */

public inherited sharing class LWC_TasksController {

    @AuraEnabled(Cacheable = true)
    public static List<Task> getAllTasks(Integer pageNumber, Integer pageSize, String recordId, String taskTypeFilter, Boolean taskHistoricalDateFilter, Boolean taskFutureDateFilter) {
        List<String> typeFilter = taskTypeFilter.split(',');
        Boolean futureTasks = (taskFutureDateFilter != null && taskFutureDateFilter) ? true : false;
        // default to showing historical tasks
        Boolean historicalTasks = (taskHistoricalDateFilter == null || taskHistoricalDateFilter) ? true : false;

        String taskQuery = 'SELECT Id, Subject, Description, Type, CreatedById, OwnerId, Owner.Name, WhatId, ActivityDate, LastModifiedDate, Status, Activity_Type__c FROM Task';
        if (recordId != null && recordId != '') {
            taskQuery += ' WHERE WhatId =: recordId';
            // are we filtering by task type?
            if (taskTypeFilter != null && taskTypeFilter != '') {
                taskQuery += ' AND (Type IN :typeFilter OR Activity_Type__c IN :typeFilter)';
            }
            // are we filtering by task date range?
            if (historicalTasks && !futureTasks) {
                taskQuery += ' AND ActivityDate <= TODAY';
            } else if (futureTasks && !historicalTasks) {
                taskQuery += ' AND ActivityDate > TODAY';
            }
        }
        taskQuery += ' ORDER BY ActivityDate DESC';
        taskQuery += ' LIMIT ' + pageSize + ' OFFSET ' + (pageSize * (pageNumber -1));
        System.debug('Tasks: ' + taskQuery);

        return Database.query(taskQuery);
    }

    @AuraEnabled(Cacheable = true)
    public static Integer getTaskCount(String recordId, String taskTypeFilter, Boolean taskHistoricalDateFilter, Boolean taskFutureDateFilter) {
        List<String> typeFilter = taskTypeFilter.split(',');
        Boolean futureTasks = (taskFutureDateFilter != null && taskFutureDateFilter) ? true : false;
        Boolean historicalTasks = (taskHistoricalDateFilter == null || taskHistoricalDateFilter) ? true : false;

        String countQuery = 'SELECT count() FROM Task ';
        if (recordId != null && recordId != '') {
            countQuery += ' WHERE WhatId =: recordId';
            // are we filtering by task type?
            if (taskTypeFilter != null && taskTypeFilter != '') {
                countQuery += ' AND Type IN :typeFilter OR Activity_Type__c IN :typeFilter';
            }
            // are we filtering by task date range?
            if (historicalTasks && !futureTasks) {
                countQuery += ' AND ActivityDate <= TODAY';
            } else if (futureTasks && !historicalTasks) {
                countQuery += ' AND ActivityDate > TODAY';
            }
        }
        System.debug('Count: ' + countQuery);
        return Database.countQuery(countQuery);
    }

}