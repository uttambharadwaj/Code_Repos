public class OpportunityContactRole_Queueable implements Queueable {

    private List<Id> opportunityContactRoleIds;

    public OpportunityContactRole_Queueable(List<Id> opportunityContactRoleIds) {
        this.opportunityContactRoleIds = opportunityContactRoleIds;
    }

    public void execute(QueueableContext context) {

        updateOpportunityPrimaryContact();

    }

    // Used to keep Primary_Contact__c on opportunity in sync with the OpportunityContactRole primary contact for marketing cloud.
    private void updateOpportunityPrimaryContact() {

        Set<Id> enabledRecordTypes = UtilityClass.getRecTypeByDevName('Opportunity', new List<String>{
                'Fuel_Card', 'Fleet_Card', 'Telamatics', 'Factoring', 'Revolver_Record', 'Truckers_Opportunity', 'WEX_Clearview'
        });

        List<Opportunity> updatedOpportunities = new List<Opportunity>();
        List<Opportunity> nulledContactOpportunities = new List<Opportunity>();
        Map<Id, OpportunityContactRole> primaryRolesMap = new Map<Id, OpportunityContactRole>();

        for (OpportunityContactRole opptyContactRole : [
                SELECT Id, OpportunityId, IsPrimary, ContactId
                FROM OpportunityContactRole
                WHERE Id = :opportunityContactRoleIds
        ]) {
            primaryRolesMap.put(opptyContactRole.OpportunityId, opptyContactRole);
        }

        if (!primaryRolesMap.isEmpty()) {

            for (Opportunity opportunity : [
                    SELECT Id, Primary_Contact__c
                    FROM Opportunity
                    WHERE Id IN :primaryRolesMap.keySet()
                    AND RecordTypeId IN :enabledRecordTypes
            ]) {

                if (primaryRolesMap.get(opportunity.Id).IsPrimary == true) {

                    opportunity.Primary_Contact__c = null;
                    nulledContactOpportunities.add(opportunity);

                    opportunity.Primary_Contact__c = primaryRolesMap.get(opportunity.Id).ContactId;
                    updatedOpportunities.add(opportunity);
                }
            }

            try {
                update nulledContactOpportunities; // I'm told for SFMC to pull the change the value must go from NULL to lookup. Not lookup to lookup.......
                update updatedOpportunities;
            } catch (Exception e) {
                System.debug('Error updating the primary contact: ' + e);
            }
        }

    }

}