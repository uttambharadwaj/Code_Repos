/*
Description:        Test class for Opportunity Trigger
Revision History:
*/
@isTest
public class OpportunityTriggerTest {

    public static void testFleetEnrollmentOpptyInfoOnInsert() {
        Opportunity oppty = [SELECT Id, Campaign_Program__r.Program__c FROM Opportunity WHERE Name = 'Test Oppty' LIMIT 1];
        Program_Template_Account__c pta = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program__c =: oppty.Campaign_Program__r.Program__c LIMIT 1];

        FleetEnrollment__c fleetEnrollment = new FleetEnrollment__c();
        fleetEnrollment.Opportunity__c = oppty.id;
        fleetEnrollment.Program__c = oppty.Campaign_Program__r.Program__c;
        fleetEnrollment.Program_Template_Account__c = pta.Id;
        fleetEnrollment.RecordTypeId = Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();

        Test.startTest();
        insert fleetEnrollment;
        Test.stopTest();

        //Asserts for After Insert logic on mapping parents
        FleetEnrollment__c myFE = [SELECT Id, Opportunity__c, Program__c, Program_Template_Account__c FROM FleetEnrollment__c WHERE Id =:fleetEnrollment.Id];
        system.assertEquals(oppty.id, myFE.Opportunity__c);
        system.assertEquals(oppty.Campaign_Program__r.Program__c, myFE.Program__c);
        system.assertEquals(oppty.Campaign_Program__r.Program__c, myFE.Program_Template_Account__r.Program__c);
        system.assertEquals('Internal', myFE.RecordType.Name);

    }

}