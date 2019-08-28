public class FleetEnrollmentData {

    public static void fleetEnrollmentDataUpdated(List<SObject> fleetDatas) {

        List<FleetEnrollment__c> fleetEnrollmentsToUpdate = new List<FleetEnrollment__c>();
        Set<Id> fleetEnrollmentIds = FleetEnrollmentUtils.listToFleetIdMap(fleetDatas).keySet();
        Map<Id, Boolean> fleetEnrollmentHasData = FleetEnrollmentUtils.hasFleetEnrollmentData(fleetEnrollmentIds);

        for (FleetEnrollment__c fleetEnrollment : [
                SELECT Id, Has_Fleet_Enrollment_Data__c
                FROM FleetEnrollment__c
                WHERE Id IN :fleetEnrollmentIds
        ]) {

            if (fleetEnrollment.Has_Fleet_Enrollment_Data__c != fleetEnrollmentHasData.get(fleetEnrollment.Id)) {
                fleetEnrollment.Has_Fleet_Enrollment_Data__c = fleetEnrollmentHasData.get(fleetEnrollment.Id);
                fleetEnrollmentsToUpdate.add(fleetEnrollment);
            }

        }

        update fleetEnrollmentsToUpdate;
    }

}