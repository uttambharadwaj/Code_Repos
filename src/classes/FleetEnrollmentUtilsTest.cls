@isTest
public class FleetEnrollmentUtilsTest {

    public static void test_hasFleetEnrollmentData() {

        Id fleetEnrollmentId = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c WHERE Name = 'FleetEnrollmentDataTest' LIMIT 1].Fleet_Enrollment__c;

        Test.startTest();
        Boolean hasFleetEnrollmentData = FleetEnrollmentUtils.hasFleetEnrollmentData(fleetEnrollmentId);
        Test.stopTest();

        System.assertEquals(true, hasFleetEnrollmentData);
    }
}