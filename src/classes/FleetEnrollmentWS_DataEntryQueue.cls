/**
 * Created by dgilbert on 9/20/2018.
 */
@RestResource(urlMapping='/FleetEnrollmentWS/DataEntryQueue/*')
global with sharing class FleetEnrollmentWS_DataEntryQueue {

    global static Implementation_Automation_Setting__mdt errorQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> errorQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Error'];

            if (errorQueueSettings.size() > 0) {
                return errorQueueSettings[0];
            }

            return null;

        }
    }

    global static Implementation_Automation_Setting__mdt dataEntryQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> dataEntryQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Data_Entry'];

            if (dataEntryQueueSettings.size() > 0) {
                return dataEntryQueueSettings[0];
            }

            return null;

        }
    }

    global static Id errorQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT QueueId FROM QueueSobject WHERE Queue.DeveloperName = :errorQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].QueueId;
            }

            return null;

        }
    }


    global static Id dataEntryQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT QueueId FROM QueueSobject WHERE Queue.DeveloperName = :dataEntryQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].QueueId;
            }

            return null;

        }
    }

    global static Implementation_Automation_Setting__mdt callQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> callQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Call_Queue'];

            if (callQueueSettings.size() > 0) {
                return callQueueSettings[0];
            }

            return null;

        }
    }

    global static Id callQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT QueueId FROM QueueSobject WHERE Queue.DeveloperName = :callQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].QueueId;
            }

            return null;

        }
    }

    global static Set<Id> dataEntryQueueMemberIds {
        get {

            Set<Id> queueMembers = new Set<Id>();

            for (GroupMember groupMember : [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = :dataEntryQueueSettings.Queue_Name__c]) {

                queueMembers.add(groupMember.UserOrGroupId);

            }

            return queueMembers;

        }
    }

    @HttpGet
    global static void getQueueCases() {

        try {

            if (dataEntryQueueMemberIds.contains(UserInfo.getUserId())) {

                GETResponse gResponse = new GETResponse();
                gResponse.result = true;
                gResponse.message = 'Case Queue successfully retrieved!';

                gResponse.availableImplementationCases = [SELECT Id, Fleet_Enrollment__c, Siebel_Oppty__c FROM Case WHERE Status = 'New' and OwnerId = :dataEntryQueueId and Siebel_Oppty__c != null ORDER BY CreatedDate DESC];

                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(gResponse));

            } else {
                throw new fleetEnrollmentWSQueueException('Your login user is not a member of this queue. Please contact the System Administrator.');
            }


        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Account Activation Queue', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new GETResponse(false, e.getMessage())));
        }

    }

    @HttpPost
    global static void updateQueueCase(String id, Boolean dataEntryCompleted, String caseNotes, String numberOfCards) {

        try {

            System.debug('### Payload: ' + RestContext.request);
            
            if (dataEntryQueueMemberIds.contains(UserInfo.getUserId())) {

                List<Case> cases = [SELECT Id, Data_Entry_Completed__c, OwnerId, Status FROM Case WHERE Id = :id LIMIT 1];

                if (cases.size() > 0) {

                    if (dataEntryCompleted == true) {
                        markCaseComplete(cases[0].Id, numberOfCards, caseNotes);

                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, true, 'Case marked as completed.')));
                    } else {
                        updateCaseOwner(cases[0].Id, errorQueueId, caseNotes);

                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, true, 'Case moved to error queue.')));
                    }

                } else {
                    throw new fleetEnrollmentWSQueueException('Unable to find specified record.');
                }

            } else {
                throw new fleetEnrollmentWSQueueException('Your login user is not a member of this queue. Please contact the System Administrator.');
            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Account Activation Queue', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, false, e.getMessage())));
        }

    }

    @future
    global static void markCaseComplete(Id caseId, String numberOfCards, String caseNotes) {

        try {

            List<Case> cases = [SELECT Id, ParentId, Data_Entry_Completed__c, No_Cards__c, AccountId, Opportunity__c, App_Request_This_Case__c, Subject, Description, OwnerId FROM Case WHERE Id = :caseId LIMIT 1];

            if (cases.size() > 0) {

                cases[0].OwnerId = UserInfo.getUserId();

                cases[0].Data_Entry_Completed__c = true;
                if (numberOfCards != null) {
                    cases[0].No_Cards__c = Integer.valueOf(numberOfCards);
                }
                cases[0].Status = 'Closed';
                if (caseNotes.length() > 255) {
                    cases[0].Subject = (caseNotes).substring(0, 255);
                } else {
                    cases[0].Subject = caseNotes;
                }
                if (cases[0].Description != null) {
                    cases[0].Description = cases[0].Description + '\n\n' + caseNotes;
                } else {
                    cases[0].Description = caseNotes;
                }

                upsert cases;

                System.debug('### ' + callQueueId);

                Case implementationCallCase = new Case();

                implementationCallCase.ParentId = cases[0].ParentId;
                implementationCallCase.Subject = 'Implementation Call';
                implementationCallCase.Type = 'Implementation Call';
                implementationCallCase.Status = 'New';
                implementationCallCase.OwnerId = callQueueId;
                implementationCallCase.AccountId = cases[0].AccountId;
                implementationCallCase.Opportunity__c = cases[0].Opportunity__c;
                implementationCallCase.App_Request_This_Case__c = cases[0].App_Request_This_Case__c;

                if (Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation') != null) {
                    implementationCallCase.RecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
                }

                insert implementationCallCase;

            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Account Activation Queue', '', UserInfo.getUserId(), e);
        }
    }

    @future
    global static void updateCaseOwner(Id caseId, Id queueId, String caseNotes) {
        List<Case> cases = [SELECT Id, OwnerId, Subject, Description, AccountId, App_Request_This_Case__c, Opportunity__c FROM Case WHERE Id = :caseId LIMIT 1];

        if (cases.size() > 0) {
            cases[0].OwnerId = queueId;
            if(caseNotes.length() > 255) {
                cases[0].Subject = (caseNotes).substring(0, 255);
            }
            else {
                cases[0].Subject = caseNotes;
            }
            if(cases[0].Description != null) {
                cases[0].Description = cases[0].Description + '\n\n' + caseNotes;
            }
            else {
                cases[0].Description = caseNotes;
            }

            try {
                upsert cases;
            }
            catch(Exception e) {
                WEXDEVErrorReporting.reportInternalError('RPA Account Activation Queue', '', UserInfo.getUserId(), e);
            }

        }
    }

    public class fleetEnrollmentWSQueueException extends Exception {
    }

    public class GETResponse {

        public Boolean result { get; set; }
        public String message { get; set; }

        public List<Case> availableImplementationCases { get; set; }

        public GETResponse() {

        }

        public GETResponse(Boolean result, String message) {
            this.result = result;
            this.message = message;
        }

    }

    public class POSTResponse {

        public String id { get; set; }
        public Boolean result { get; set; }
        public String message { get; set; }

        public POSTResponse(String caseId, Boolean result, String message) {

            this.id = caseId;
            this.result = result;
            this.message = message;

        }

    }

}