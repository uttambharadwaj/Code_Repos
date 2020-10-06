/**
 * Created by dgilbert on 9/20/2018.
 *
* Revision History: 11/Sep/2019 CJackson    NAFONBOARD-96   API contains the Account Short Name.
*
*/
@RestResource(urlMapping='/FleetEnrollmentWS/FleetData/*')
global with sharing class FleetEnrollmentWS_FleetData {

    global static Set<String> availableFleetEnrollmentStatuses {
        get {

            Set<String> availableFleetEnrollmentStatuses = new Set<String>();

            for (Schema.PicklistEntry f : (FleetEnrollment__c.Status__c.getDescribe()).getPicklistValues()) {
                availableFleetEnrollmentStatuses.add(f.getValue());
            }

            return availableFleetEnrollmentStatuses;

        }
    }

    @HttpGet
    global static void getFleetData() {

        String fleetEnrollmentId = RestContext.request.params.get('id');

        try {
            List <String> fleetFields = new List<String>((FleetEnrollment__c.getSObjectType().getDescribe()).fields.getMap().keySet());
            fleetFields.add('Opportunity__r.Account.Account_Short_Name__c');
            List<FleetEnrollment__c> fleetEnrollments = Database.query(' SELECT ' + String.join(fleetFields, ',') + ' FROM ' + FleetEnrollment__c.getSObjectType().getDescribe().getName() + ' WHERE ' + ' id = :fleetEnrollmentId ' + ' LIMIT 1 ');

            if (fleetEnrollments.size() > 0) {

                GETResponse gResponse = new GETResponse();

                gResponse.id = fleetEnrollmentId;
                gResponse.result = true;
                gResponse.message = 'Fleet Data Retrieved Successfully!';

                gResponse.fleetEnrollment = fleetEnrollments[0];

                gResponse.fleetEnrollmentDrivers = Database.query(' SELECT ' + String.join(new List<String>((FleetEnrollment_Driver__c.getSObjectType().getDescribe()).fields.getMap().keySet()), ',') + ' FROM ' + FleetEnrollment_Driver__c.getSObjectType().getDescribe().getName() + ' WHERE ' + ' Fleet_Enrollment__c = :fleetEnrollmentId');

                gResponse.fleetEnrollmentContacts = Database.query(' SELECT ' + String.join(new List<String>((FleetEnrollment_Contact__c.getSObjectType().getDescribe()).fields.getMap().keySet()), ',') + ' FROM ' + FleetEnrollment_Contact__c.getSObjectType().getDescribe().getName() + ' WHERE ' + ' Fleet_Enrollment__c = :fleetEnrollmentId');

                gResponse.fleetEnrollmentVehicles = Database.query(' SELECT ' + String.join(new List<String>((FleetEnrollment_Vehicle__c.getSObjectType().getDescribe()).fields.getMap().keySet()), ',') + ' FROM ' + FleetEnrollment_Vehicle__c.getSObjectType().getDescribe().getName() + ' WHERE ' + ' Fleet_Enrollment__c = :fleetEnrollmentId');

                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(gResponse));

            } else {
                throw new fleetEnrollmentWSFleetDataException('Unable to find specified record.');
            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Fleet Data Service', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new GETResponse(fleetEnrollmentId, false, e.getMessage())));
        }

    }

    @HttpPost
    global static void updateFleetData(String id, String fleetEnrollmentStatus) {

        try {

            if (availableFleetEnrollmentStatuses.contains(fleetEnrollmentStatus)) {

                List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Status__c FROM FleetEnrollment__c WHERE Id = :id];

                if (fleetEnrollments.size() > 0) {

                    fleetEnrollments[0].Status__c = fleetEnrollmentStatus;

                    upsert fleetEnrollments[0];

                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, true, 'Status updated successfully!')));

                } else {
                    throw new fleetEnrollmentWSFleetDataException('Unable to find specified record.');
                }

            } else {
                throw new fleetEnrollmentWSFleetDataException('Invalid status provided. (Available Status Values: ' + String.valueOf(availableFleetEnrollmentStatuses) + ')');
            }

        } catch (Exception e) {
            WEXDEVErrorReporting.reportInternalError('RPA Fleet Data Service', '', UserInfo.getUserId(), e);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(id, false, e.getMessage())));
        }

    }

    public class fleetEnrollmentWSFleetDataException extends Exception {
    }

    public class POSTResponse {

        public String id { get; set; }
        public Boolean result { get; set; }
        public String message { get; set; }

        public POSTResponse(String fleetEnrollmentId, Boolean result, String message) {

            this.id = fleetEnrollmentId;
            this.result = result;
            this.message = message;

        }

    }

    public class GETResponse {

        public String id { get; set; }
        public Boolean result { get; set; }
        public String message { get; set; }

        public FleetEnrollment__c fleetEnrollment { get; set; }
        public List<FleetEnrollment_Contact__c> fleetEnrollmentContacts { get; set; }
        public List<FleetEnrollment_Driver__c> fleetEnrollmentDrivers { get; set; }
        public List<FleetEnrollment_Vehicle__c> fleetEnrollmentVehicles { get; set; }

        public GETResponse() {

        }

        public GETResponse(String fleetEnrollmentId, Boolean result, String message) {
            this.id = fleetEnrollmentId;
            this.result = result;
            this.message = message;
        }

    }

}