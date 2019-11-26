public class OpportunityAssignment {

    @InvocableMethod(label='Opportunity Assignment Handler')
    public static void applicationRequestDeniedHandler(List<Application_Request__c> deniedApplicationRequests) {

        List<Application_Request__c> criteriaMetApplicationRequests = new List<Application_Request__c>();
        List<String> allRoles = new List<String>();
        List<Id> allOpportunityIds = new List<Id>();

        for (Application_Request__c applicationRequest : [
                SELECT Id,Opportunity__c,Decline_Letter_Types__c, Fraud_Flag__c, Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c,Opportunity__r.Opportunity_Number__c, Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c, Opportunity__r.Owner.Alias, Opportunity__r.StageName
                FROM Application_Request__c
                WHERE Id IN :new Map<Id, SObject>(deniedApplicationRequests).keySet()
        ]) {

            if (applicationRequest.Opportunity__c != null && applicationRequest.Opportunity__r.Campaign_Program__c != null && applicationRequest.Opportunity__r.Campaign_Program__r.Program__c != null) {

                Boolean autoAssignmentEnabled = applicationRequest.Opportunity__r.Campaign_Program__r.Program__r.Enable_Opportunity_Auto_Assignment__c;
                if (autoAssignmentEnabled) {

                    // Assignment criteria
                    Boolean opportunityOwnerIsIntegrations = applicationRequest.Opportunity__r.owner.alias == 'sinte';
                    Boolean notDeclinedAppLetterType = applicationRequest.Decline_Letter_Types__c != 'Declined Application';
                    Boolean opportunityStageSigned = applicationRequest.Opportunity__r.StageName == '5) Signed';
                    Boolean fraudCheckFalse = applicationRequest.Fraud_Flag__c == false;
                    Boolean hasRoleAssignment = applicationRequest.Opportunity__r.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c != null;

                    if (opportunityOwnerIsIntegrations && notDeclinedAppLetterType && opportunityStageSigned && fraudCheckFalse && hasRoleAssignment) {
                        criteriaMetApplicationRequests.add(applicationRequest);
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
        Map<String, List<User>> userRoleMap = new Map<String, List<User>>(); // Key: Users Role Name Value: User
        Map<String, Opportunity_Assignments__c> opportunityAssignmentMap = new Map<String, Opportunity_Assignments__c>(); // Key: Role Name Value: Opt Assignment Record

        // Get all needed user roles/users in a map where the key is the role.
        for (User user : [
                SELECT Id, Name, UserRole.Name
                FROM User
                WHERE UserRole.Name IN :allRoles
                AND IsActive = true
                AND Id NOT IN (SELECT UserId FROM OutOfOffice WHERE isEnabled = TRUE)
                order by Name ASC
        ]) {

            if (userRoleMap.get(user.UserRole.Name) == null) {
                userRoleMap.put(user.UserRole.Name, new List<User>());
            }

            userRoleMap.get(user.UserRole.Name).add(user);
        }
        if (userRoleMap.isEmpty()) return;

        // Get all needed Opportunity Assignments
        for (Opportunity_Assignments__c opportunityAssignment : [
                SELECT Id, Name, Last_Assigned_User__c
                FROM Opportunity_Assignments__c
                WHERE Name IN :allRoles
        ]) {
            opportunityAssignmentMap.put(opportunityAssignment.Name, opportunityAssignment);
        }

        // Get all needed opportunities
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT Id, OwnerId, Opportunity_Number__c, Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c FROM Opportunity WHERE Id IN :allOpportunityIds]);

        for (Application_Request__c applicationRequest : applicationRequests) {

            Opportunity opportunity = opportunityMap.get(applicationRequest.Opportunity__c);
            String userRole = opportunity.Campaign_Program__r.Program__r.Opportunity_Role_Assignment__c;
            List<User> roleUsers = userRoleMap.get(userRole);


            if (opportunityAssignmentMap.get(userRole) == null) {
                opportunityAssignmentMap.put(userRole, new Opportunity_Assignments__c(Name = userRole));
            }

            Opportunity_Assignments__c opportunityAssignment = opportunityAssignmentMap.get(userRole);
            Integer indexOfNextUser = getLastUserIndex(roleUsers, opportunityAssignment.Last_Assigned_User__c) + 1;

            opportunity.OwnerId = roleUsers[indexOfNextUser].Id;
            opportunityAssignment.Last_Assigned_User__c = roleUsers[indexOfNextUser].Id;
            opportunityAssignmentMap.put(userRole, opportunityAssignment);

            opportunitiesToUpdate.add(opportunity);
        }
        try {
            upsert opportunityAssignmentMap.values();
            update opportunitiesToUpdate;
            opportunitySplitReset(opportunitiesToUpdate);
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'OpportunityAssignment', false, '', String.valueOf(new Map<Id, SObject>(applicationRequests).keySet()));
        }
    }

    // Set opportunity split of all users to 0% except owner. Owner is set to 100%.
    private static void opportunitySplitReset(List<Opportunity> opportunities) {
        List<OpportunitySplit> opportunitySplitsToUpdate = new List<OpportunitySplit>();
        List<OpportunitySplit> opportunitySplits = [SELECT Id,SplitOwnerId,SplitAmount,SplitPercentage,Opportunity.OwnerId,OpportunityId from OpportunitySplit WHERE OpportunityId IN :new Map<Id, SObject>(opportunities).keySet()];

        for (OpportunitySplit opportunitySplit : opportunitySplits) {
            opportunitySplit.SplitPercentage = opportunitySplit.SplitOwnerId == opportunitySplit.Opportunity.OwnerId ? 100 : 0;
            opportunitySplitsToUpdate.add(opportunitySplit);
        }

        try {
            update opportunitySplitsToUpdate;
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'OpportunityAssignment', false, '', String.valueOf(new Map<Id, SObject>(opportunities).keySet()));
        }
    }

    private static Integer getLastUserIndex(List<User> users, Id lastAssignedUser) {

        if (lastAssignedUser != null) {
            Integer count = 0;

            for (User user : users) {

                if (user.id == lastAssignedUser) {
                    return count >= users.size() - 1 ? -1 : count;
                }
                count++;
            }
        }
        return -1;
    }
}
