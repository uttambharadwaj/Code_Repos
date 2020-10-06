@isTest
public class FleetEnrollmentDataTest {

    public static void test_fleetEnrollmentHasData() {

        List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c WHERE Name = 'FleetEnrollmentDataTest'];
        Set<Id> fleetEnrollmentIds = FleetEnrollmentUtils.listToFleetIdMap(fleetEnrollmentContacts).keySet();

        Test.startTest();
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        Test.stopTest();


        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Has_Fleet_Enrollment_Data__c FROM FleetEnrollment__c WHERE Id IN :fleetEnrollmentIds];

        for (FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
            System.assertEquals(true, fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }
    }

    public static void test_fleetEnrollmentMissingData() {

        List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c WHERE Name = 'FleetEnrollmentDataTest'];
        Set<Id> fleetEnrollmentIds = FleetEnrollmentUtils.listToFleetIdMap(fleetEnrollmentContacts).keySet();

        delete [SELECT Id FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c IN :fleetEnrollmentIds];
        Test.startTest();
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        Test.stopTest();


        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Has_Fleet_Enrollment_Data__c FROM FleetEnrollment__c WHERE Id IN :fleetEnrollmentIds];

        for (FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
            System.assertEquals(false, fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }
    }

    public static void test_fleetEnrollmentHasFile() {

        List<FleetEnrollment_Contact__c> fleetEnrollmentContacts = [SELECT Id, Fleet_Enrollment__c from FleetEnrollment_Contact__c WHERE Name = 'FleetEnrollmentDataTest'];
        Set<Id> fleetEnrollmentIds = FleetEnrollmentUtils.listToFleetIdMap(fleetEnrollmentContacts).keySet();

        delete [SELECT Id FROM FleetEnrollment_Driver__c WHERE Fleet_Enrollment__c IN :fleetEnrollmentIds];

        Test.startTest();

        // Assert that there's no fleet data
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        for (FleetEnrollment__c fleetEnrollment : [
                SELECT Id, Has_Fleet_Enrollment_Data__c
                FROM FleetEnrollment__c
                WHERE Id IN :fleetEnrollmentIds
        ]) {
            System.assertEquals(false, fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }

        // Create the file
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S';
        contentVersion.PathOnClient = 'testing.txt';
        contentVersion.Title = 'Fleet Data Test';
        contentVersion.VersionData = Blob.valueOf('test');
        insert contentVersion;

        // Link file to fleet enrollment
        for (FleetEnrollment__c fleetEnrollment : [
                SELECT Id, Has_Fleet_Enrollment_Data__c
                FROM FleetEnrollment__c
                WHERE Id IN :fleetEnrollmentIds
        ]) {
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.LinkedEntityId = fleetEnrollment.Id;
            contentDocumentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            contentDocumentLink.shareType = 'V';
            insert contentDocumentLink;
        }

        Test.stopTest();

        // Assert that there's fleet data
        FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentContacts);
        for (FleetEnrollment__c fleetEnrollment : [
                SELECT Id, Has_Fleet_Enrollment_Data__c
                FROM FleetEnrollment__c
                WHERE Id IN :fleetEnrollmentIds
        ]) {
            System.assertEquals(true, fleetEnrollment.Has_Fleet_Enrollment_Data__c);
        }
    }
}