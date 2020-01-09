@IsTest
public class OpportunityAssignmentTest {

    public static void test_opportunityAutoAssignment() {

        Application_Request__c applicationRequests = [SELECT Id,Opportunity__c,Opportunity__r.Campaign_Program__r.Program__c, Decline_Letter_Types__c, Fraud_Flag__c, Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c,Opportunity__r.Opportunity_Number__c, Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c, Opportunity__r.Owner.Alias, Opportunity__r.StageName FROM Application_Request__c WHERE Opportunity__r.Name = 'Test Oppty 10'];
        Program__c program = [SELECT Id, Enable_Opportunity_Auto_Assignment__c, Opportunity_Role_Assignment__c FROM Program__c WHERE Id = :applicationRequests.Opportunity__r.Campaign_Program__r.Program__c];

        program.Enable_Opportunity_Auto_Assignment__c = true;
        program.Opportunity_Role_Assignment__c = 'System Admin';
        update program;

        Opportunity opportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :applicationRequests.Opportunity__c];
        opportunity.OwnerId = [ SELECT Id FROM User WHERE alias = 'sinte' ].Id;
        update opportunity;

        List<User> users = [
                SELECT Id, Name, UserRole.Name
                FROM User
                WHERE UserRole.Name = 'System Admin'
                AND IsActive = true
                AND Id NOT IN (SELECT UserId FROM OutOfOffice WHERE StartDate <= :System.Now() AND EndDate >= :System.Now())
                order by Name ASC
        ];

        Test.startTest();
        OpportunityAssignment.applicationRequestDeniedHandler(new List<Application_Request__c>{
                applicationRequests
        });
        Test.stopTest();

        opportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :applicationRequests.Opportunity__c];

        // Assert that the proper user was assigned as owner
        System.assertEquals(users[0].id, opportunity.ownerId);

        for (OpportunitySplit opportunitySplit : [
                SELECT Id, SplitAmount, SplitPercentage, SplitOwnerId, Opportunity.OwnerId
                FROM OpportunitySplit
                WHERE OpportunityId = :opportunity.Id
        ]) {
            // Assert that the assigned owner was also given a 100% split
            if (opportunitySplit.SplitOwnerId == opportunitySplit.Opportunity.OwnerId) {
                System.assertEquals(true, opportunitySplit.SplitPercentage == 100);
            } else {
                System.assertEquals(true, opportunitySplit.SplitPercentage == 0);
            }
        }
    }
}