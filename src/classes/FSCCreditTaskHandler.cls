/**
 * Created by dgilbert on 10/30/2018.
 */

public with sharing class FSCCreditTaskHandler {

    public static boolean alreadyRunning = false;

    public static void syncFSCTask(List<Task> tasks) {

        BOCA_Settings__c bocaSettings = BOCA_Settings__c.getOrgDefaults();

        alreadyRunning = true;

        Set<String> taskTypes = new Set<String>{'ACCOUNT SET UP', 'APP FORWARDED TO CREDIT', 'APPLICATION', 'APPLICATION COMMENTS', 'APPROVED APPLICATION', 'BO INFO RETURNED', 'CARD PRODUCTION COMPLETE', 'CONVERTED', 'EMAIL - INBOUND', 'EMAIL - OUTBOUND', 'FYI', 'INCOMPLETE APP', 'INFO NEEDED', 'INFO RETURNED', 'INFORMATION NEEDED', 'NEW TAX DOCS', 'NOTES', 'OREGON FUEL DOCUMENT', 'OTHER', 'PRECARD CALL', 'PRECARD CALL', 'SET UP ACCOUNT', 'TAILORED FEE SCHEDULE', 'TAX COMPLIANCE'};

        try {

            for (Task task : tasks) {

                if (Schema.SObjectType.Task.getRecordTypeInfosByName().get('General') != null
                        && task.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId()
                        && task.Type != null && taskTypes.contains((task.Type).toUpperCase()) && System.IsBatch() == false && System.isFuture() == false) {

                    if ((task.WhatId).getSobjectType().getDescribe().getName().equalsIgnoreCase('Opportunity')) {

                        List<Application_Request__c> applicationRequests = [SELECT Id, Credit_Analyst__c FROM Application_Request__c WHERE Opportunity__c = :task.WhatId LIMIT 1];

                        if (applicationRequests.size() > 0) {

                            Task newTask = (task).clone(false);

                            newTask.Status = 'Not Started';
                            newTask.WhatId = applicationRequests[0].Id;
                            if(applicationRequests[0].Credit_Analyst__c != null) {
                                newTask.OwnerId = applicationRequests[0].Credit_Analyst__c;
                            }
                            else {
                                newTask.OwnerId = bocaSettings.BOCA_Integration_User_ID__c;
                            }

                            upsert newTask;

                        }

                    } else if ((task.WhatId).getSobjectType().getDescribe().getName().equalsIgnoreCase('Application_Request__c')) {

                        List<Application_Request__c> applicationRequests = [SELECT Opportunity__c, Opportunity__r.OwnerId FROM Application_Request__c WHERE Id = :task.WhatId LIMIT 1];

                        if (applicationRequests.size() > 0) {

                            Task newTask = task.clone(false);

                            newTask.Status = 'Not Started';
                            newTask.WhatId = applicationRequests[0].Opportunity__c;
                            if(applicationRequests[0].Opportunity__r.OwnerId != null) {
                                newTask.OwnerId = applicationRequests[0].Opportunity__r.OwnerId;
                            }
                            else {
                                newTask.OwnerId = bocaSettings.BOCA_Integration_User_ID__c;
                            }

                            upsert newTask;

                        }

                    }

                }

            }


        } catch (Exception e) {
            System.debug('### Unable to create task..');
        }

    }

}