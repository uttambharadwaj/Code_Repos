/**
 * Created by mfarrell on 4/13/20.
 * Used by relatedActivities LWC to get list of activities related to the current object.
 */

public inherited sharing class LWC_TasksController {

    @AuraEnabled(Cacheable = true)
    public static List<Task> getAllTasks(Integer pageNumber, Integer pageSize, String recordId, String taskTypeFilter, Boolean taskHistoricalDateFilter, Boolean taskFutureDateFilter) {

        if (recordId != null && recordId != '') {
            String taskQuery = 'SELECT Id, Subject, Description, Type, CreatedById, OwnerId, Owner.Name, WhatId, ActivityDate, LastModifiedDate, Status, Activity_Type__c FROM Task';

            List<Id> whatIds = getAllPotentialWhatIds(recordId); // used in WHERE
            taskQuery += getTaskWhereClause(recordId, taskTypeFilter, taskHistoricalDateFilter, taskFutureDateFilter);

            taskQuery += ' ORDER BY ActivityDate DESC';
            taskQuery += ' LIMIT ' + pageSize + ' OFFSET ' + (pageSize * (pageNumber - 1));
            System.debug('Tasks: ' + taskQuery);
            return Database.query(taskQuery);
        }

        return new List<Task>();
    }

    @AuraEnabled(Cacheable = true)
    public static Integer getTaskCount(String recordId, String taskTypeFilter, Boolean taskHistoricalDateFilter, Boolean taskFutureDateFilter) {

        if (recordId != null && recordId != '') {

            String countQuery = 'SELECT count() FROM Task';
            List<Id> whatIds = getAllPotentialWhatIds(recordId); // used in WHERE
            countQuery += getTaskWhereClause(recordId, taskTypeFilter, taskHistoricalDateFilter, taskFutureDateFilter);

            System.debug('Count: ' + countQuery);
            return Database.countQuery(countQuery);
        }

        return 0;
    }

    /**
        * Purpose: Construct WHERE clause used by all get task queries
        * Input: (String, String, Boolean, Boolean) Record ID, type filter, historical date filter, future date filter
        * Output: (String) (SPACE)WHERE ..criteria(NO SPACE)
    */
    public static String getTaskWhereClause(String recordId, String taskTypeFilter, Boolean taskHistoricalDateFilter, Boolean taskFutureDateFilter) {

        String whereClause = ' WHERE WhatId != NULL';
        List<String> typeFilter = taskTypeFilter.split(',');
        Boolean futureTasks = (taskFutureDateFilter != null && taskFutureDateFilter) ? true : false;
        Boolean historicalTasks = (taskHistoricalDateFilter != null && taskHistoricalDateFilter) ? true : false;

        whereClause += ' AND WhatId IN :whatIds';

        // are we filtering by task type?
        if (taskTypeFilter != null && taskTypeFilter != '') {
            whereClause += ' AND (Type IN :typeFilter OR Activity_Type__c IN :typeFilter)';
        }
        // are we filtering by task date range?
        if (historicalTasks && !futureTasks) {
            whereClause += ' AND ActivityDate <= TODAY';
        } else if (futureTasks && !historicalTasks) {
            whereClause += ' AND ActivityDate > TODAY';
        }

        return whereClause;
    }

    /**
		* Purpose: Component needs to display all related tasks. For example if on Case record, display tasks related to both
		*          the Account and Collections__c in addition to those related to the Case.
		* Input: (String) Record ID of current record component is on
		* Output: (List<Id>) List of WhatIds related to input record id.
	*/
    public Static List<Id> getAllPotentialWhatIds(String recordId) {

        List<Id> whatIds = new List<Id>();
        whatIds.add(recordId);

        // When on Account also display tasks from Collections__c and Case
        if (UtilityClass.getObjName(recordId) == 'Account') {

            for (Collections__c collectionRecord : [
                    SELECT Id
                    FROM Collections__c
                    WHERE Account__c = :recordId
            ]) {
                whatIds.add(collectionRecord.Id);
            }

            for (Case caseRecord : [
                    SELECT Id
                    FROM Case
                    WHERE Accountid = :recordId
            ]) {
                whatIds.add(caseRecord.Id);
            }

        // When on Case also display tasks from Collections__c and Account
        } else if (UtilityClass.getObjName(recordId) == 'Case') {

            for (Collections__c collectionRecord : [
                    SELECT Id
                    FROM Collections__c
                    WHERE Case__c = :recordId
            ]) {
                whatIds.add(collectionRecord.Id);
            }
            for (Account accountRecord : [
                    SELECT Id
                    FROM Account
                    WHERE Id IN (SELECT AccountId FROM Case WHERE Id = :recordId)
            ]) {
                whatIds.add(accountRecord.Id);
            }

        // When on Collections__c also display tasks from Case and Account
        } else if (UtilityClass.getObjName(recordId) == 'Collections__c') {

            for (Case caseRecord : [
                    SELECT Id
                    FROM Case
                    WHERE Id IN (SELECT Case__c FROM Collections__c WHERE Id = :recordId)
            ]) {
                whatIds.add(caseRecord.Id);
            }
            for (Account accountRecord : [
                    SELECT Id
                    FROM Account
                    WHERE Id IN (SELECT Account__c FROM Collections__c WHERE Id = :recordId)
            ]) {
                whatIds.add(accountRecord.Id);
            }
        }

        return whatIds;
    }

}