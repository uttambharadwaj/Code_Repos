public class FleetEnrollmentData {

    /**
    * Purpose: When data related to a fleetenrollment__c is updated, this function is called to determine if the checkbox
    * Has_Fleet_Enrollment_Data__c should be checked or unchecked.
    *
    * Input: Accepts any object with the field Fleet_Enrollment__c, LinkedEntityId, or Parentid that is SObjectType FleetEnrollment__c
    */
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