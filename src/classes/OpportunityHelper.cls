/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityHelper {

    public static void createFleetEnrollment(List<Opportunity> opptys) {

        List<FleetEnrollment__c> feCreateList = new List<FleetEnrollment__c>();
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
            opptyToProgramMap.put(o.campaign_program__r.program__c, o.id);
        }

        // Find all Program Template Accounts for the Programs associated with the oppty list
        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program_Default__c = TRUE AND Program__c IN :opptyToProgramMap.keySet()];
        for (Program_Template_Account__c pta : programTemplateAccounts) {
            programTemplateToProgramMap.put(pta.program__c, pta.Id);
        }

        // create new FleetEnrollment__c record for each opportunity, add records to feList
        for (Opportunity opp : opptyList) {
            FleetEnrollment__c fleetEnrollment = new FleetEnrollment__c();
            fleetEnrollment.Opportunity__c = opp.Id;
            fleetEnrollment.Program__c = opp.Campaign_Program__r.Program__c;
            fleetEnrollment.Program_Template_Account__c = programTemplateToProgramMap.get(opp.Campaign_Program__r.Program__c);
            fleetEnrollment.Debug_Opportunity_Parameter__c = opp.Id;
            fleetEnrollment.Status__c = 'New';
            if (opp.name.length() > 30) {
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
            if (Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal') != null)
                fleetEnrollment.RecordTypeId = Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();

            feCreateList.add(fleetEnrollment);

        }

        if (feCreateList.size() > 0) {
            try {
                insert feCreateList;
            } catch (DmlException e) {
                System.debug('Error Inserting FleetEnrollment Records: ' + e.getMessage());
            }
        }
    }
}