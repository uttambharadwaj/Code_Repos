@isTest
public class FleetEnrollmentDataTest {

    public static void test_fleetEnrollmentHasData() {

        List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c];
        Map<Id, List<SObject>> fleetContactMap = FleetEnrollmentUtils.listToFleetIdMap(fleetEnrollmentContacts);

        // Because data is inserted as part of the test class framework, unrelated contact data could exist.
        Map<Id, Boolean> hasDataMap = FleetEnrollmentUtils.hasFleetEnrollmentData(fleetContactMap.keySet());

        Test.startTest();
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        Test.stopTest();


        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Has_Fleet_Enrollment_Data__c FROM FleetEnrollment__c WHERE Id IN :fleetContactMap.keySet()];

        for (FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
            System.assertEquals(hasDataMap.get(fleetEnrollment.id), fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }
    }

    public static void test_fleetEnrollmentNoData() {

        List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c];
        Map<Id, List<SObject>> fleetContactMap = FleetEnrollmentUtils.listToFleetIdMap(fleetEnrollmentContacts);
        delete [SELECT Id FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c IN :fleetContactMap.keySet()];

        Map<Id, Boolean> hasDataMap = FleetEnrollmentUtils.hasFleetEnrollmentData(fleetContactMap.keySet());

        Test.startTest();
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        Test.stopTest();


        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Has_Fleet_Enrollment_Data__c FROM FleetEnrollment__c WHERE Id IN :fleetContactMap.keySet()];

        for (FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
            System.assertEquals(false, fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }

    }
}