/*
Description:        Test class for AppRequestTriggers
Revision History:
*/
@isTest
public class AppRequestTriggerTest {

    public static void testInsert() {

        Opportunity o1 = [SELECT Id, External_Referred_By_Account_Name__c, External_Referred_By__c FROM Opportunity WHERE Name='Test Oppty 8' LIMIT 1];
        Opportunity o2 = [SELECT Id, External_Referred_By_Account_Name__c, External_Referred_By__c FROM Opportunity WHERE Name='Test Oppty 6' LIMIT 1];

        Application_Request__c ar1 = new Application_Request__c(); //this will test going to credit decisioning
        ar1.Sales_Stage__c = '04 - Application Received';
        ar1.Opportunity__c = o1.Id;
        ar1.Forward_Application_to_Credit__c = 'Yes';
        ar1.Created_By_Echosign__c = true;

        Application_Request__c ar2 = new Application_Request__c(); //this will test external referred by stamping data
        ar2.Sales_Stage__c = '04 - Application Received';
        ar2.Opportunity__c = o2.Id;

        Test.startTest();
        insert new List<Application_Request__c>{ar1,ar2};
        Test.stopTest();

        ar1 = [SELECT CreatedDate, Running_Credit_Decisioning__c, LastModifiedDate FROM Application_Request__c WHERE Id = :ar1.Id LIMIT 1];
        system.assertEquals(false, ar1.Running_Credit_Decisioning__c);
        system.assertNotEquals(ar1.CreatedDate, ar1.LastModifiedDate);

        ar2 = [SELECT External_Referred_by__c, External_Referring_Contact__c, Forward_Application_to_Credit__c, Sales_Person__c FROM Application_Request__c WHERE Id=:ar2.Id LIMIT 1];
        system.assertEquals(o2.External_Referred_By_Account_Name__c, ar2.External_Referred_by__c);
        system.assertEquals(o2.External_Referred_By__c, ar2.External_Referring_Contact__c);
        system.assertEquals(UserInfo.getUserId(), ar2.Sales_Person__c);
    }

    public static void testUpdate(){
        //ar1 will change compliance decision
        Application_Request__c ar1 = [SELECT Id FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 7' LIMIT 1];
        ar1.Compliance_Decision__c = 'Approved';

        //ar2 will change forward application to credit
        Application_Request__c ar2 = [SELECT Id FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 9' LIMIT 1];
        ar2.Forward_Application_to_Credit__c = 'Yes';
        ar2.Created_By_Echosign__c = true;

        //ar3 has a child fleet enrollment missing opportunity number
        Id o =[SELECT Id FROM Opportunity WHERE Name = 'Test Oppty 10' Limit 1].Id;
        Application_Request__c ar3 = [SELECT Id, Siebel_Oppty__c FROM Application_Request__c WHERE Opportunity__c = :o LIMIT 1];
        FleetEnrollment__c fe1 = [SELECT Id, Opportunity_Number__c FROM FleetEnrollment__c WHERE Opportunity__c = :o and application_request__c=:ar3.Id LIMIT 1];
        //uncomment the following when triggers are converted to use automation settings. can't have a fleet enrollment without oppty number bc triggers.
        //system.assertNotEquals(ar1.Siebel_Oppty__c, fe1.Opportunity_Number__c);

        Test.startTest();
        update new List<Application_Request__c>{ar1, ar2, ar3};
        Test.stopTest();

        ar1 = [SELECT CreatedDate, Running_Credit_Decisioning__c, LastModifiedDate FROM Application_Request__c WHERE Id = :ar1.Id LIMIT 1];
        system.assertEquals(false, ar1.Running_Credit_Decisioning__c);
        system.assertNotEquals(ar1.CreatedDate, ar1.LastModifiedDate);

        ar2 = [SELECT CreatedDate, Running_Credit_Decisioning__c, LastModifiedDate FROM Application_Request__c WHERE Id = :ar2.Id LIMIT 1];
        system.assertEquals(false, ar2.Running_Credit_Decisioning__c);
        system.assertNotEquals(ar2.CreatedDate, ar2.LastModifiedDate);

        fe1 = [SELECT Id, Opportunity_Number__c FROM FleetEnrollment__c WHERE Id = :fe1.Id LIMIT 1];
        system.assertEquals(ar3.Siebel_Oppty__c, fe1.Opportunity_Number__c);
    }

}