/**
 * Created by mfarrell on 4/13/20.
 * Used by relatedActivities LWC to get list of activities related to the current object.
 */

public inherited sharing class LWC_TasksController {

    @AuraEnabled(Cacheable = true)
    public static List<Task> getAllTasks(Integer pageNumber, Integer pageSize, String recordId, String taskTypeFilter) {
        List<String> typeFilter = taskTypeFilter.split(',');
        String taskQuery = 'SELECT Id, Subject, Description, Type, CreatedById, OwnerId, Owner.Name, WhatId, ActivityDate, LastModifiedDate FROM Task';
        if (recordId != null && recordId != '') {
            taskQuery += ' WHERE WhatId =: recordId';
            if (taskTypeFilter != null && taskTypeFilter != '') {
                taskQuery += ' AND Type IN :typeFilter';
            }
        }
        taskQuery += ' ORDER BY ActivityDate DESC';
        taskQuery += ' LIMIT ' + pageSize + ' OFFSET ' + (pageSize * (pageNumber -1));
        System.debug('Tasks: ' + taskQuery);

        return Database.query(taskQuery);
    }

    @AuraEnabled(Cacheable = true)
    public static Integer getTaskCount(String recordId, String taskTypeFilter) {
        List<String> typeFilter = taskTypeFilter.split(',');
        String countQuery = 'SELECT count() FROM Task ';
        if (recordId != null && recordId != '') {
            countQuery += ' WHERE WhatId =: recordId';
            if (taskTypeFilter != null && taskTypeFilter != '') {
                countQuery += ' AND Type IN :typeFilter';
            }
        }
        System.debug('Count: ' + countQuery);
        return Database.countQuery(countQuery);
    }

}