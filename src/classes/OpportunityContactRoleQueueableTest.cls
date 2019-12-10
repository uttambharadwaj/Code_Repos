@isTest
public class OpportunityContactRoleQueueableTest {

    public static void updateOpportunityPrimaryContactTest() {

        Opportunity opportunity = [ SELECT Id FROM Opportunity LIMIT 1 ];
        Contact contact = [ SELECT Id FROM Contact LIMIT 1 ];

        Test.startTest();
        OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
        opportunityContactRole.ContactId = contact.Id;
        opportunityContactRole.OpportunityId = opportunity.Id;
        opportunityContactRole.isPrimary = true;
        insert opportunityContactRole;
        Test.stopTest();

        opportunity = [ SELECT Id, Primary_Contact__c FROM Opportunity WHERE Id = :opportunity.Id ];
        System.assertEquals(true, opportunity.Primary_Contact__c == contact.Id);

    }
}