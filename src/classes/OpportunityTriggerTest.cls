/*
Description:        Test class for Opportunity Trigger
Revision History:
*/
@isTest
public class OpportunityTriggerTest {

    public static void testFleetEnrollmentOpptyInfoOnInsert() {

        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test' LIMIT 1];
        System.debug('Account Id is: ' + acc.id);
        Campaign_Program__c campaignProgram = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram.Program__c);

        Opportunity oppty = new Opportunity();
        oppty.Name = 'Test FE Creation Oppty';
        oppty.AccountId = acc.Id;
        system.debug('Related Account is: ' + oppty.AccountId);
        oppty.CloseDate = Date.today().addDays(30);
        oppty.StageName = '1) Qualified';
        oppty.Type = 'New Customer';
        oppty.CampaignId = campaignProgram.Campaign__c;
        system.debug('Related Campaign is : ' + oppty.CampaignId);
        oppty.Campaign_Program__c = campaignProgram.Id;
        system.debug('Related Campaign Program is : ' + oppty.Campaign_Program__c);
        oppty.Fueling_Methos__c = 'Bank Debit Card';
        oppty.Fleet_Size__c = 10;
        Oppty.Legal_Structure__c = 'Sole Proprietorship';
        oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();

        Test.startTest();
        insert oppty;
        Test.stopTest();

        //Asserts for After Insert logic
        Opportunity oppty2 = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Name = 'Test FE Creation Oppty' LIMIT 1];
        FleetEnrollment__c myFE = [SELECT Id, Opportunity__c, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c, RecordType.Name FROM FleetEnrollment__c WHERE Opportunity__c = :oppty.Id];
        system.assertEquals(oppty2.id, myFE.Opportunity__c);
        system.assertEquals(oppty2.Campaign_Program__r.Program__c, myFE.Program__c);
        system.assertEquals(oppty2.Campaign_Program__r.Program__c, myFE.Program_Template_Account__r.Program__c);
        system.assertEquals('Internal', myFE.RecordType.Name);

    }

    public static void testFleetEnrollmentOpptyInfoOnUpdate() {

        Opportunity oppty = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Name ='Test Oppty 10' LIMIT 1];
        FleetEnrollment__c fe = [SELECT Id, Name, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c FROM FleetEnrollment__c WHERE Opportunity__c =: oppty.Id];
        Campaign_Program__c campaignProgram = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram.Program__c);
        Campaign_Program__c campaignProgram2 = [SELECT Id, Name, Campaign__c, Program__c FROM Campaign_Program__c WHERE Name = 'Test 2' LIMIT 1];
        System.debug('Campaign Program Id is: ' + campaignProgram2.id);
        system.debug('Campaign_Program__r.Program__c is: ' + campaignProgram2.Program__c);

        //Update Oppty, check that FleetEnrollment Record updates
        oppty.Campaign_Program__c = campaignProgram2.Id;

        Test.startTest();
        update oppty;
        Test.stopTest();

        //Asserts for Before Update logic
        Opportunity oppty2 = [SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Name ='Test Oppty 10' LIMIT 1];
        FleetEnrollment__c FE2 = [SELECT Id, Opportunity__c, Program__c, Program_Template_Account__c, Program_Template_Account__r.Program__c, RecordType.Name FROM FleetEnrollment__c WHERE Opportunity__c =:oppty2.Id];
        system.assertNotEquals(FE.Program__c, FE2.Program__c);
        system.assertEquals(FE2.Program__c, Oppty2.Campaign_Program__r.Program__c);

    }

}