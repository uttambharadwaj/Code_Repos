/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityHelper {

    public static void createFleetEnrollment(List<Opportunity> opptys) {

        Set<Opportunity> fuelCardOpptyIds = new Set<Opportunity>();
        Map<Id, Id> opptyToProgramMap = new Map<Id, Id>();
        Map<Id, Id> programTemplateToProgramMap = new Map<Id, Id>();

        for (Opportunity opp : opptys) {
            if (opp.RecordTypeId == UtilityClass.getRecordTypeByName(Opportunity.getSObjectType(), 'Fuel Card')) {
                fuelCardOpptyIds.add(opp);
            }
        }

        // Find all Program in the list of opptys
        List<Opportunity> opptyList = [
                SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c, Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c,
                        AccountId, Account.Name, Siebel_Opportunity__c, OwnerId, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c,
                        Billing_Street__c, Billing_Street_Line_2__c, Billing_City__c, Billing_State__c, Billing_Zip_Postal_Code__c,
                        Billing_Contact_Email__c, Billing_Contact_Phone__c
                FROM Opportunity
                WHERE Id IN :fuelCardOpptyIds
        ];
        for (Opportunity o : opptyList) {
            opptyToProgramMap.put(o.Campaign_Program__r.Program__c, o.Id);
        }

        // Find all Program Template Accounts for the Programs associated with the oppty list
        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program_Default__c = TRUE AND Program__c IN :opptyToProgramMap.keySet()];
        for (Program_Template_Account__c pta : programTemplateAccounts) {
            programTemplateToProgramMap.put(pta.Program__c, pta.Id);
        }

        // create new FleetEnrollment__c record for each opportunity, add records to feSet to limit duplicates
        for (Opportunity opp : opptyList) {
            FleetEnrollment__c fleetEnrollment = new FleetEnrollment__c();
            fleetEnrollment.Opportunity__c = opp.Id;
            fleetEnrollment.Program__c = opp.Campaign_Program__r.Program__c;
            fleetEnrollment.Program_Template_Account__c = programTemplateToProgramMap.get(opp.Campaign_Program__r.Program__c);
            fleetEnrollment.Debug_Opportunity_Parameter__c = opp.Id;
            fleetEnrollment.Status__c = 'New';
            if (opp.Name.length() > 30) {
                fleetEnrollment.Embossing_Company_Name__c = opp.Name.substring(0, 30);
            } else {
                fleetEnrollment.Embossing_Company_Name__c = opp.Name;
            }
            if (opp.Siebel_Opportunity__c != null) fleetEnrollment.Opportunity_Number__c = opp.Siebel_Opportunity__c;
            if (opp.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c != null) fleetEnrollment.Billing_Cycle__c = opp.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c;
            if (opp.Billing_Contact_First_Name__c != null) fleetEnrollment.Billing_Contact_First_Name__c = opp.Billing_Contact_First_Name__c;
            if (opp.Billing_Contact_Last_Name__c != null) fleetEnrollment.Billing_Contact_Last_Name__c = opp.Billing_Contact_Last_Name__c;
            if (opp.Billing_Street__c != null) fleetEnrollment.Billing_Address_Line_1__c = opp.Billing_Street__c;
            if (opp.Billing_City__c != null) fleetEnrollment.Billing_City__c = opp.Billing_City__c;
            if (opp.Billing_State__c != null) fleetEnrollment.Billing_State__c = opp.Billing_State__c;
            if (opp.Billing_Zip_Postal_Code__c != null) fleetEnrollment.Billing_Postal_Code__c = opp.Billing_Zip_Postal_Code__c;
            if (opp.Billing_Contact_Email__c != null) fleetEnrollment.Billing_Email__c = opp.Billing_Contact_Email__c;
            if (opp.Billing_Contact_Phone__c != null) fleetEnrollment.Billing_Phone__c = opp.Billing_Contact_Phone__c;
            if (Schema.SObjectType.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal') != null) {
                fleetEnrollment.RecordTypeId = Schema.SObjectType.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
            }
            OpportunityTriggerDispatcher.feNoDuplicatesSet.add(fleetEnrollment);
        }

    }

    public static void updatePrimaryContact(List<OpportunityContactRole> opportunityContactRoles, List<OpportunityContactRole> oldOpportunityContactRoles) {

        Set<Id> enabledRecordTypes = UtilityClass.getRecTypeByDevName('Opportunity', new List<String>{'Fuel_Card','Fleet_Card','Telamatics','Factoring','Revolver_Record','Truckers_Opportunity','WEX_Clearview'});
        Map<Id, OpportunityContactRole> primaryRoles = new Map<Id, OpportunityContactRole>();
        List<Opportunity> updatedOpportunities = new List<Opportunity>();
        List<Opportunity> nulledContactOpportunities = new List<Opportunity>();
        for (Integer i = 0; i < opportunityContactRoles.size(); i++) {

            Boolean isChangedOrInserted = oldOpportunityContactRoles != null ? !oldOpportunityContactRoles[i].IsPrimary : true;
            if (opportunityContactRoles[i].IsPrimary && isChangedOrInserted) {
                primaryRoles.put(opportunityContactRoles[i].OpportunityId, opportunityContactRoles[i]);
            }
        }

        if (!primaryRoles.isEmpty()) {

            for (Opportunity opportunity : [
                    SELECT Id, Primary_Contact__c
                    FROM Opportunity
                    WHERE Id IN :primaryRoles.keySet()
                    AND RecordTypeId IN :enabledRecordTypes
            ]) {


                if (primaryRoles.get(opportunity.Id).IsPrimary == true) {

                    opportunity.Primary_Contact__c = null;
                    nulledContactOpportunities.add(opportunity);

                    opportunity.Primary_Contact__c = primaryRoles.get(opportunity.Id).ContactId;
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