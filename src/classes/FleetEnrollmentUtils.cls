public class FleetEnrollmentUtils {

    public static Map<Id, List<SObject>> listToFleetIdMap(List<SObject> fleetDataRecords) {
        System.debug(fleetDataRecords.getSObjectType());
        Map<Id, List<SObject>> fleetDataMap = new Map<Id, List<SObject>>();
        for (SObject fleetDataRecord : fleetDataRecords) {

            Id fId = (Id) (fleetDataRecords.getSObjectType() == Schema.Attachment.getSObjectType() ? fleetDataRecord.get('ParentId') : fleetDataRecord.get('Fleet_Enrollment__c'));

            if (fleetDataMap.get(fId) == null) {
                fleetDataMap.put(fId, new List<SObject>());
            }

            fleetDataMap.get(fId).add(fleetDataRecord);
        }
        return fleetDataMap;
    }

    public static Boolean hasFleetEnrollmentData(Id fleetEnrollmentId) {
        return hasFleetEnrollmentData(new Set<Id>{fleetEnrollmentId}).get(fleetEnrollmentId);
    }

    public static Map<Id, Boolean> hasFleetEnrollmentData(Set<Id> fleetEnrollmentIds) {

        Map<Id, Boolean> hasFleetEnrollmentDataMap = new Map<Id, Boolean>();

        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Association__c FROM FleetEnrollment__c WHERE id IN :fleetEnrollmentIds];
        Map<Id, List<FleetEnrollment_Contact__c>> fleetEnrollmentContacts = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Contact__c WHERE Fleet_Enrollment__c IN :fleetEnrollments AND Fleet_Enrollment__c != NULL]);
        Map<Id, List<FleetEnrollment_Driver__c>> fleetEnrollmentDrivers = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c IN :fleetEnrollments AND Fleet_Enrollment__c != NULL]);
        Map<Id, List<FleetEnrollment_Vehicle__c>> fleetEnrollmentVehicles = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Vehicle__c WHERE Fleet_Enrollment__c IN :fleetEnrollments AND Fleet_Enrollment__c != NULL]);
        Map<Id, List<Attachment>> fleetEnrollmentAttachments = listToFleetIdMap([SELECT Id,ParentId FROM Attachment WHERE ParentId IN :fleetEnrollments AND ParentId != NULL]);

        for (FleetEnrollment__c fleetEnrollment : fleetEnrollments) {

            Boolean hasContactDriverVehicle = fleetEnrollmentContacts.get(fleetEnrollment.Id) != null &&
                    fleetEnrollmentDrivers.get(fleetEnrollment.Id) != null &&
                    fleetEnrollmentVehicles.get(fleetEnrollment.Id) != null;

            Boolean hasAttachments = fleetEnrollmentAttachments.get(fleetEnrollment.Id) != null;
            Boolean hasFleetData = fleetEnrollment.Association__c == null && (hasAttachments || hasContactDriverVehicle) ? true : false;

            hasFleetEnrollmentDataMap.put(fleetEnrollment.Id, hasFleetData);

        }

        return hasFleetEnrollmentDataMap;
    }

}