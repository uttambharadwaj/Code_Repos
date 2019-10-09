@IsTest
public class OpportunityAssignmentTest {

    public static void test_appRequestMeetsCriteria() {

        Application_Request__c applicationRequests = [SELECT Id,Opportunity__c,Opportunity__r.Campaign_Program__r.Program__c, Decline_Letter_Types__c, Fraud_Flag__c, Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c,Opportunity__r.Opportunity_Number__c, Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c, Opportunity__r.Owner.Alias, Opportunity__r.StageName FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 10'];
        Program__c program = [ SELECT Id, Enable_Opportunity_Auto_Assignment__c, Opportunity_Role_Assignment__c FROM Program__c WHERE Id = :applicationRequests.Opportunity__r.Campaign_Program__r.Program__c];

        program.Enable_Opportunity_Auto_Assignment__c = true;
        program.Opportunity_Role_Assignment__c = 'System Admin';
        update program;

        List<User> users = [SELECT Id, Name, UserRole.Name FROM User WHERE UserRole.Name = 'System Admin' AND IsActive = true order by Name ASC];
        System.debug(users);
        Test.startTest();
        OpportunityAssignment.applicationRequestDeniedDispatcher(new List<Application_Request__c>{applicationRequests});
        Test.stopTest();

        Opportunity opportunity = [ SELECT ID, OwnerId FROM Opportunity WHERE Id = :applicationRequests.Opportunity__c];

        System.assertEquals(users[0].id, opportunity.ownerId);

    }
}