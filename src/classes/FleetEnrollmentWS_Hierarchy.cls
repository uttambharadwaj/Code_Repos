/**
 * Created by dgilbert on 9/20/2018.
 * Revision History:    IADJUDICAT-1199 order by lastmodifieddate
 *                      IADJUDICAT-1200 restrict what goes to Account Activation queue--adding App Channel
 *                      NAFONBOARD-56   16/AUG/2019     MFarrell    Added logic for which case is to be created next after bots close hierarchy case
 *                                                                  Updated class with code from prod, as prod did not match what was in bitbucket.
 */
@RestResource(urlMapping='/FleetEnrollmentWS/HierarchyQueue/*')
global with sharing class FleetEnrollmentWS_Hierarchy {

    global static Implementation_Automation_Setting__mdt errorQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> errorQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Error'];

            if (errorQueueSettings.size() > 0) {
                return errorQueueSettings[0];
            }

            return null;

        }
    }

    global static Implementation_Automation_Setting__mdt hierarchyQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> hierarchyQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Hierarchy'];

            if (hierarchyQueueSettings.size() > 0) {
                return hierarchyQueueSettings[0];
            }

            return null;

        }
    }

    global static Id errorQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT Queue.Id FROM QueueSobject WHERE Queue.DeveloperName = :errorQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].Queue.Id;
            }

            return null;

        }
    }

    global static Implementation_Automation_Setting__mdt activationQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> dataEntryQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Activation'];

            if (dataEntryQueueSettings.size() > 0) {
                return dataEntryQueueSettings[0];
            }

            return null;

        }
    }

    global static Id activationQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT Queue.Id FROM QueueSobject WHERE Queue.DeveloperName = :activationQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].Queue.Id;
            }

            return null;

        }
    }

    global static Id hierarchyQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT Queue.Id FROM QueueSobject WHERE Queue.DeveloperName = :hierarchyQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].Queue.Id;
            }

            return null;

        }
    }

    global static Set<Id> hierarchyQueueMemberIds {
        get {

            Set<Id> queueMembers = new Set<Id>();

            for (GroupMember groupMember : [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = :hierarchyQueueSettings.Queue_Name__c]) {

                queueMembers.add(groupMember.UserOrGroupId);

            }

            return queueMembers;

        }
    }

    global static Implementation_Automation_Setting__mdt manualQueueSettings {
        get {

            List<Implementation_Automation_Setting__mdt> manualQueueSettings = [SELECT Id, Queue_Name__c FROM Implementation_Automation_Setting__mdt WHERE DeveloperName = 'NA_Fleet_Parent_Queue'];

            if (manualQueueSettings.size() > 0) {
                return manualQueueSettings[0];
            }

            return null;

        }
    }

    global static Id manualQueueId {
        get {

            List<QueueSobject> queueSobjects = [SELECT QueueId FROM QueueSobject WHERE Queue.DeveloperName = :manualQueueSettings.Queue_Name__c];

            if (queueSobjects.size() > 0) {
                return queueSobjects[0].QueueId;
            }

            return null;

        }
    }

    @HttpGet
    global static void getQueueCases() {

        try {

            if (hierarchyQueueMemberIds.contains(UserInfo.getUserId())) {

                GETResponse gResponse = new GETResponse();
                gResponse.result = true;
                gResponse.message = 'Case Queue successfully retrieved!';

                //1199 order by lastmodifieddate
                gResponse.availableImplementationCases = [SELECT Id, CaseNumber, Siebel_Oppty__c, App_Request_This_Case__r.Opportunity__r.Campaign_Program__r.Program__r.Default_Hierarchy_Level__c, App_Request_This_Case__r.Opportunity__r.Campaign_Program__r.Program__r.Program_Parent_Account_Number__c, App_Request_This_Case__r.Opportunity__r.Campaign_Program__r.Program__r.Program_Ultimate_Parent_Account_Number__c FROM Case WHERE Status = 'New' and OwnerId = :hierarchyQueueId and Siebel_Oppty__c != null ORDER BY LastModifiedDate ASC LIMIT 10];

                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(gResponse));

            } else {
                throw new fleetEnrollmentWSQueueException('Your login user is not a member of this queue. Please contact the System Administrator.');
            }


        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Hierarchy Queue', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new GETResponse(false, e.getMessage())));
        }

    }

    @HttpPost
    global static void updateQueueCase(String id, Boolean hierarchyCompleted, String caseNotes) {

        try {

            if (hierarchyQueueMemberIds.contains(UserInfo.getUserId())) {

                List<Case> cases = [SELECT Id, Hierarchy_Setup_Completed__c, OwnerId, Status FROM Case WHERE Id = :id LIMIT 1];

                if (cases.size() > 0) {

                    if (hierarchyCompleted == true) {

                        markCaseComplete(cases[0].Id, caseNotes);

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
            WEXDEVErrorReporting.reportInternalError('RPA Hierarchy Queue', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, false, e.getMessage())));
        }

    }

    @future
    global static void markCaseComplete(Id caseId, String caseNotes) {

        try {

            List<Case> cases = [SELECT Id, App_Request_This_Case__r.Fleet_Enrollment__r.Association__c, App_Request_This_Case__r.Fleet_Enrollment__r.Direct_Debit__c, Program_Template_Account__c, Hierarchy_Setup_Completed__c, Subject, Description, ParentId, AccountId, App_Request_This_Case__c, Opportunity__c, Opportunity__r.SourceSystem__c, App_Request_This_Case__r.Sales_Person__r.Alias, Fleet_Enrollment__c, Opportunity__r.Campaign_Program__r.Program__c FROM Case WHERE Id = :caseId LIMIT 1];

            if (cases.size() > 0) {

                cases[0].Hierarchy_Setup_Completed__c = true;
                cases[0].OwnerId = UserInfo.getUserId();
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

                // this section commented out as part of NAFONBOARD-56

                // If there is no Fleet Enrollment and we're headed for the next queue, we at the very
                // least need a Program Template Account associated for das bots.
                if(cases[0].Fleet_Enrollment__c == null) {

/*
                    FleetEnrollment__c fleetEnrollment = new FleetEnrollment__c();

                    fleetEnrollment.Program__c = cases[0].Opportunity__r.Campaign_Program__r.Program__c;
                    fleetEnrollment.Opportunity__c = cases[0].Opportunity__c;
                    fleetEnrollment.Application_Request__c = cases[0].App_Request_This_Case__c;

                    List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id FROM Program_Template_Account__c WHERE Program_Default__c = true and Program__c =: cases[0].Opportunity__r.Campaign_Program__r.Program__c LIMIT 1];

                    if(programTemplateAccounts.size() > 0) {

                        fleetEnrollment.Program_Template_Account__c = programTemplateAccounts[0].Id;

                    }

                    if (Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal') != null) {
                        fleetEnrollment.RecordTypeId = Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
                    }

                    insert fleetEnrollment;
*/

                    //NAFONBOARD-56 - If app req doesn't have a related fleet enrollment, find the one on the oppty, and relate it to the app req.
                    List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Opportunity__c FROM FleetEnrollment__c WHERE Opportunity__c =: cases[0].Opportunity__c LIMIT 1];

                    List<Application_Request__c> applicationRequests = [SELECT Id, Fleet_Enrollment__c FROM Application_Request__c WHERE Id =: cases[0].App_Request_This_Case__c LIMIT 1];

                    if(applicationRequests.size() > 0 && fleetEnrollments.size() > 0) {

                        applicationRequests[0].Fleet_Enrollment__c = fleetEnrollments[0].Id;

                        upsert applicationRequests[0];

                    }

                }

                // Re-fetch the case after insert
                cases = [SELECT Id, Opportunity__r.Campaign_Program__r.Program__r.BOCA_Type__c, Opportunity__r.Name, Opportunity__r.Owner.Alias,
                            App_Request_This_Case__r.Fleet_Enrollment__r.Association__c, App_Request_This_Case__r.Fleet_Enrollment__r.Direct_Debit__c,
                            Program_Template_Account__c, Hierarchy_Setup_Completed__c, Subject, Description, ParentId, AccountId, App_Request_This_Case__c,
                            Opportunity__c, Opportunity__r.SourceSystem__c, App_Request_This_Case__r.Sales_Person__r.Alias, Fleet_Enrollment__c,
                            Opportunity__r.Campaign_Program__r.Program__c, App_Request_This_Case__r.Application_Channel__c,
                            App_Request_This_Case__r.Fleet_Enrollment__r.Submit_Fleet_Data_Form_Used__c, Opportunity__r.Owner.UserRole.Name
                        FROM Case
                        WHERE Id = :caseId
                        LIMIT 1];

                //1200&1201 add app channel criteria
                if (cases[0].Fleet_Enrollment__c != null &&
                        cases[0].App_Request_This_Case__r.Fleet_Enrollment__r.Direct_Debit__c == false &&
                        cases[0].App_Request_This_Case__r.Fleet_Enrollment__r.Association__c == null &&
                        cases[0].Opportunity__r.Campaign_Program__r.Program__r.BOCA_Type__c != null &&
                        !(cases[0].Opportunity__r.Campaign_Program__r.Program__r.BOCA_Type__c).equalsIgnoreCase('Revolver Card') &&
                        //NAFONBOARD-56
                        (
                            (
                                (cases[0].App_Request_This_Case__r.Application_Channel__c).equalsIgnoreCase('BOCA') &&
                                cases[0].Opportunity__r.SourceSystem__c != null &&
                                (cases[0].Opportunity__r.SourceSystem__c).equalsIgnoreCase('BOCA') &&
                                cases[0].Opportunity__r.Owner.Alias != null &&
                                (cases[0].Opportunity__r.Owner.Alias).equalsIgnoreCase('sinte')
                            )
                        ||
                            (
                                cases[0].App_Request_This_Case__r.Fleet_Enrollment__r.Submit_Fleet_Data_Form_Used__c == true &&
                                ( //TODO: store roles in custom metadata, was not able to get that functioning in time to meet deadline
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('System Admin') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('IS Sales Data Admin') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('IS Team Leader') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('IS Sales Rep') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Fleet Outbound Channel Sales') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Fleet Outbound Channel Sales 2') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Fleet Outbound Channel Sales 3') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Lead Development Role') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Chevron IS Inbound') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Chevron IS Outbound') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Shell Inbound Sales') ||
                                    (cases[0].Opportunity__r.Owner.UserRole.Name).equalsIgnoreCase('Shell Outbound Sale')
                                )
                            )
                        )

                    ) {

                    Case implementationCallCase = new Case();

                    implementationCallCase.ParentId = cases[0].Id;
                    implementationCallCase.Subject = 'Account Activation';
                    implementationCallCase.Type = 'Account Activation';
                    implementationCallCase.Status = 'New';
                    implementationCallCase.OwnerId = activationQueueId;
                    implementationCallCase.AccountId = cases[0].AccountId;
                    implementationCallCase.Opportunity__c = cases[0].Opportunity__c;
                    implementationCallCase.App_Request_This_Case__c = cases[0].App_Request_This_Case__c;

                    if (Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation') != null) {
                        implementationCallCase.RecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
                    }

                    insert implementationCallCase;

                } else {

                    Case implementationCallCase = new Case();

                    implementationCallCase.ParentId = cases[0].ParentId;
                    implementationCallCase.Subject = 'Implementation Parent Case - ' + cases[0].Opportunity__r.Name;
                    implementationCallCase.Status = 'New';
                    implementationCallCase.OwnerId = manualQueueId;
                    implementationCallCase.AccountId = cases[0].AccountId;
                    implementationCallCase.Opportunity__c = cases[0].Opportunity__c;
                    implementationCallCase.App_Request_This_Case__c = cases[0].App_Request_This_Case__c;

                    if (Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation') != null) {
                        implementationCallCase.RecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Fleet Implementation').getRecordTypeId();
                    }

                    insert implementationCallCase;

                }
            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Hierarchy Queue', '', UserInfo.getUserId(), e);
        }
    }

    @future
    global static void updateCaseOwner(Id caseId, Id queueId, String caseNotes) {
        List<Case> cases = [SELECT Id, OwnerId, Subject, Description FROM Case WHERE Id = :caseId LIMIT 1];

        if (cases.size() > 0) {
            cases[0].OwnerId = queueId;
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

            try {
                upsert cases;
            } catch (Exception e) {
                WEXDEVErrorReporting.reportInternalError('RPA Hierarchy Queue', '', UserInfo.getUserId(), e);
            }

        }
    }

    public class fleetEnrollmentWSQueueException extends Exception {
    }

    public class GETResponse {

        public Boolean result {
            get;
            set;
        }
        public String message {
            get;
            set;
        }

        public List<Case> availableImplementationCases {
            get;
            set;
        }

        public GETResponse() {

        }

        public GETResponse(Boolean result, String message) {
            this.result = result;
            this.message = message;
        }

    }

    public class POSTResponse {

        public String id {
            get;
            set;
        }
        public Boolean result {
            get;
            set;
        }
        public String message {
            get;
            set;
        }

        public POSTResponse(String caseId, Boolean result, String message) {

            this.id = caseId;
            this.result = result;
            this.message = message;

        }

    }

}