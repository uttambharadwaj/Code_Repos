public with sharing class OpportunityAssignment {

    @InvocableMethod(label='Opportunity Assignment Handler')
    public static void applicationRequestDeniedHandler(List<Application_Request__c> deniedApplicationRequests) {

        List<Application_Request__c> criteriaMetApplicationRequests = new List<Application_Request__c>();
        List<String> allRoles = new List<String>();
        List<Id> allOpportunityIds = new List<Id>();

        for (Application_Request__c applicationRequest : [
                SELECT Id,Opportunity__c,Decline_Letter_Types__c, Fraud_Flag__c, Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c,Opportunity__r.Opportunity_Number__c, Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c, Opportunity__r.Owner.Alias, Opportunity__r.StageName
                FROM application_request__c
                WHERE id IN :new Map<Id, SObject>(deniedApplicationRequests).keySet()
        ]) {

            if (applicationRequest.Opportunity__c != null && applicationRequest.Opportunity__r.Campaign_Program__c != null && applicationRequest.Opportunity__r.Campaign_Program__r.Program__c != null) {

                Boolean autoAssignmentEnabled = applicationRequest.Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c;
                if (autoAssignmentEnabled) {

                    Boolean opportunityOwnerIsIntegrations = applicationRequest.Opportunity__r.owner.alias == 'sinte';
                    Boolean notDeclinedAppLetterType = applicationRequest.Decline_Letter_Types__c != 'Declined Application';
                    Boolean opportunityStageSigned = applicationRequest.Opportunity__r.StageName == '5) Signed';
                    Boolean fraudCheckFalse = applicationRequest.Fraud_Flag__c == false;

                    if (opportunityOwnerIsIntegrations && notDeclinedAppLetterType && opportunityStageSigned && fraudCheckFalse) {
                        criteriaMetApplicationRequests.add(applicationRequest);
                        // TODO Figure out how to handle empty Opportunity_Role_Assignment__c
                        allRoles.add(applicationRequest.Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c);
                        allOpportunityIds.add(applicationRequest.Opportunity__c);
                    }
                }
            }
        }
        if (!criteriaMetApplicationRequests.isEmpty()) {
            opportunityAssignments(criteriaMetApplicationRequests, allRoles, allOpportunityIds);
        }
    }

    private static void opportunityAssignments(List<Application_Request__c> applicationRequests, List<String> allRoles, List<Id> allOpportunityIds) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Map<String, List<User>> userRoleMap = new Map<String, List<User>>();

        // Get all needed user roles/users in a map where the key is the role.
        for (User user : [
                SELECT Id, Name, UserRole.Name
                FROM User
                WHERE UserRole.Name IN :allRoles AND IsActive = true
                order by Name ASC
        ]) {

            if (userRoleMap.get(user.UserRole.Name) == null) {
                userRoleMap.put(user.UserRole.Name, new List<User>());
            }

            userRoleMap.get(user.UserRole.Name).add(user);
        }

        // Get all needed opportunities
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([ SELECT Id, OwnerId, Opportunity_Number__c, Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c FROM Opportunity WHERE Id IN :allOpportunityIds]);

        for (Application_Request__c applicationRequest : applicationRequests) {

            Opportunity opportunity = opportunityMap.get(applicationRequest.Opportunity__c);
            List<User> roleUsers = userRoleMap.get(opportunity.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c);

            Integer optNumber = Integer.valueOf(opportunity.Opportunity_Number__c.substringAfter('-'));

            optNumber = Math.mod(optNumber, roleUsers.size());
            opportunity.OwnerId = roleUsers[optNumber].Id;

            opportunitiesToUpdate.add(opportunity);
        }
        update opportunitiesToUpdate;
    }
}
