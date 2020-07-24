public class FleetEnrollmentUtils {


    /**
    * Purpose: Convert a list of fleet enrollment data into a map where the key is the id of the fleet enrollment record
    * Input: Accepts any object with the field FleetEnrollment__c or Parentid that is SObjectType FleetEnrollment__c
    * Output: Map<Id, List<SObject>> where Id is the FleetEnrollment__c and List<SObject> are the records from the input
    */
    public static Map<Id, List<SObject>> listToFleetIdMap(List<SObject> fleetDataRecords) {

        Map<Id, List<SObject>> fleetDataMap = new Map<Id, List<SObject>>();
        for (SObject fleetDataRecord : fleetDataRecords) {

            Id fId = (Id) (fleetDataRecords.getSObjectType() == Schema.Attachment.getSObjectType() ? fleetDataRecord.get('ParentId') : fleetDataRecord.get('Fleet_Enrollment__c'));
            if (fId != null) {

                if (fleetDataMap.get(fId) == null) {
                    fleetDataMap.put(fId, new List<SObject>());
                }
                fleetDataMap.get(fId).add(fleetDataRecord);
            }
        }
        return fleetDataMap;
    }

    public static Boolean hasFleetEnrollmentData(Id fleetEnrollmentId) {
        return hasFleetEnrollmentData(new Set<Id>{
                fleetEnrollmentId
        }).get(fleetEnrollmentId);
    }

    /**
    * Purpose: Contains logic to determine if the fleet enrollment records have fleet data
    * Input: Accepts set of FleetEnrollment__c ids
    * Output: Map<Id, Boolean> where Id is FleetEnrollment__c and the Boolean is whether or not the record has fleet data
    */
    public static Map<Id, Boolean> hasFleetEnrollmentData(Set<Id> fleetEnrollmentIds) {

        Map<Id, Boolean> hasFleetEnrollmentDataMap = new Map<Id, Boolean>();
        Map<Id, List<FleetEnrollment_Contact__c>> fleetEnrollmentContacts = new Map<Id, List<FleetEnrollment_Contact__c>>();
        Map<Id, List<FleetEnrollment_Driver__c>> fleetEnrollmentDrivers = new Map<Id, List<FleetEnrollment_Driver__c>>();
        Map<Id, List<FleetEnrollment_Vehicle__c>> fleetEnrollmentVehicles = new Map<Id, List<FleetEnrollment_Vehicle__c>>();

        Map<Id, FleetEnrollment__c> fleetEnrollments = new Map<Id, FleetEnrollment__c>([SELECT Id, Association__c FROM FleetEnrollment__c WHERE Id IN :fleetEnrollmentIds AND Association__c = NULL]);
        Map<Id, List<Attachment>> fleetEnrollmentAttachments = listToFleetIdMap([SELECT Id,ParentId FROM Attachment WHERE ParentId IN :fleetEnrollmentIds AND ParentId != NULL AND Createdby.Name != 'CreditApplication Site Guest User']);

        // Determine if additional data is needed for any of the fleetEnrollmentIds
        Set<Id> fleetEnrollmentsNoAttachments = fleetEnrollmentIds.clone();
        fleetEnrollmentsNoAttachments.removeAll(fleetEnrollmentAttachments.keyset());

        if (!fleetEnrollmentsNoAttachments.isEmpty()) {
            fleetEnrollmentContacts = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Contact__c WHERE Fleet_Enrollment__c IN :fleetEnrollmentsNoAttachments AND Fleet_Enrollment__c != NULL]);
            fleetEnrollmentDrivers = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c IN :fleetEnrollmentsNoAttachments AND Fleet_Enrollment__c != NULL]);
            fleetEnrollmentVehicles = listToFleetIdMap([SELECT Id,Fleet_Enrollment__c FROM FleetEnrollment_Vehicle__c WHERE Fleet_Enrollment__c IN :fleetEnrollmentsNoAttachments AND Fleet_Enrollment__c != NULL]);
        }

        for (Id fleetEnrollmentId : fleetEnrollmentIds) {

            Boolean hasContactDriverVehicle = fleetEnrollmentContacts.get(fleetEnrollmentId) != null &&
                    fleetEnrollmentDrivers.get(fleetEnrollmentId) != null &&
                    fleetEnrollmentVehicles.get(fleetEnrollmentId) != null;

            Boolean hasAttachments = fleetEnrollments.get(fleetEnrollmentId) != null && fleetEnrollmentAttachments.get(fleetEnrollmentId) != null;
            Boolean hasFleetData = fleetEnrollments.get(fleetEnrollmentId) != null && (hasAttachments || hasContactDriverVehicle);

            hasFleetEnrollmentDataMap.put(fleetEnrollmentId, hasFleetData);

        }

        return hasFleetEnrollmentDataMap;
    }

}