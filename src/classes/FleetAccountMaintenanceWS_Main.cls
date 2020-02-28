/**
 * Created by dgilbert on 9/20/2018.
 */

// TODO - The robots are coming.
@RestResource(urlMapping='/FleetAccountMaintenanceWS/ProcessChanges/*')
global with sharing class FleetAccountMaintenanceWS_Main {

    @HttpGet
    global static void getTasks() {

        try {

            List<Account_Maintenance_Task__c> accountMaintenanceTasks = Database.query(' SELECT ' + String.join(new List<String>((Account_Maintenance_Task__c.getSObjectType().getDescribe()).fields.getMap().keySet()), ',') + ' FROM ' + Account_Maintenance_Task__c.getSObjectType().getDescribe().getName() + ' WHERE ' + ' Status__c = \'New\' ');

            if (accountMaintenanceTasks.size() > 0) {

                GETResponse gResponse = new GETResponse();

                gResponse.result = true;
                gResponse.message = 'Account Maintenance Tasks Retrieved Successfully!';

                gResponse.accountMaintenanceTasks = accountMaintenanceTasks;

                if(RestContext.response != null) {
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(gResponse));
                }

                System.debug(JSON.serialize(gResponse));

            } else {
                throw new accountMaintenanceTaskException('No records found.');
            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Account Maintenance Service', '', UserInfo.getUserId(), e);

            if(RestContext.response != null) {
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new GETResponse(false, e.getMessage())));
            }
        }

    }

    @HttpPost
    global static void updateTask(String id, Boolean taskCompleted, String errorLog) {

        try {

            List<Account_Maintenance_Task__c> accountMaintenanceTasks = [SELECT Id, Status__c, Error_Log__c FROM Account_Maintenance_Task__c WHERE Id =: id];

            if(accountMaintenanceTasks.size() > 0) {

                if(taskCompleted) {
                    accountMaintenanceTasks[0].Status__c = 'Complete';
                }
                else {
                    accountMaintenanceTasks[0].Status__c = 'Error';
                }

                accountMaintenanceTasks[0].Error_Log__c = errorLog;

                upsert accountMaintenanceTasks[0];

                if(RestContext.response != null) {
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, true, 'Task marked as completed.')));
                }

                System.debug(JSON.serialize(new POSTResponse(id, true, 'Task marked as completed.')));

            }
            else {
                throw new accountMaintenanceTaskException('Record not found.');
            }

        }
        catch(Exception e) {

            WEXDEVErrorReporting.reportInternalError('RPA Account Maintenance Service', '', UserInfo.getUserId(), e);

            if(RestContext.response != null) {
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new GETResponse(false, e.getMessage())));
            }

        }

    }

    public class accountMaintenanceTaskException extends Exception {
    }

    public class POSTResponse {

        public String id { get; set; }
        public Boolean result { get; set; }
        public String message { get; set; }

        public POSTResponse(String accountMaintenanceTaskId, Boolean result, String message) {

            this.id = accountMaintenanceTaskId;
            this.result = result;
            this.message = message;

        }

    }

    public class GETResponse {

        public Boolean result { get; set; }
        public String message { get; set; }

        public List<Account_Maintenance_Task__c> accountMaintenanceTasks { get; set; }

        public GETResponse() {

        }

        public GETResponse(Boolean result, String message) {
            this.result = result;
            this.message = message;
        }

    }

}