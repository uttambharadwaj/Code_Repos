/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityHelper {

    // After Insert, Before Update
    // check for FleetEnrollment__c record on creation of Fuel Card Opportunity
    public static void checkFleetEnrollment(List<Opportunity> opptyList) {
        Set<Id> opptyIds = new Set<Id>();
        Set<Id> feIds = new Set<Id>();

        for (Opportunity opp : OpptyList) {
            if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId())
                opptyIds.add(opp.id);
        }

        if (opptyIds.size() > 0) {
            for (FleetEnrollment__c fe : [SELECT Id, Opportunity__c FROM FleetEnrollment__c where Opportunity__c IN : opptyIds]) {
                feIds.add(fe.id);
            }
        }

        if (feIds.size() > 0) {
            updateFleetEnrollment(opptyIds);
        } else {
            createFleetEnrollment(opptyIds);
        }
    }

    private static void createFleetEnrollment(Set<ID> opptyIds) {

        List<FleetEnrollment__c> feCreateList = new List<FleetEnrollment__c>();
        Map<Id, Id> opptyToProgramMap = new Map<Id, Id>();
        Map<Id, Id> programTemplateToProgramMap = new Map<Id, Id>();

        // Find all Program in the list of opptys
        List<Opportunity> opptyList = [
                SELECT Id, Name, Campaign_Program__c, Campaign_Program__r.Program__c, Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c,
                        AccountId, Account.Name, Siebel_Opportunity__c, OwnerId, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c,
                        Billing_Street__c, Billing_Street_Line_2__c, Billing_City__c, Billing_State__c, Billing_Zip_Postal_Code__c,
                        Billing_Contact_Email__c, Billing_Contact_Phone__c
                FROM Opportunity
                WHERE Id IN :opptyIds
            ];
            for (Opportunity o : opptyList) {
                opptyToProgramMap.put(o.campaign_program__r.program__c, o.id);
            }
        // Find all Program Template Accounts for the Programs associated with the oppty list
        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program_Default__c = true AND Program__c IN : opptyToProgramMap.keySet()];
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

    private static void updateFleetEnrollment(Set<Id> opptyIds) {

        List<FleetEnrollment__c> feUpdateList = new List<FleetEnrollment__c>();
        Map<Id, Id> opptyToProgramMap = new Map<Id, Id>();
        Map<Id, Id> programTemplateToProgramMap = new Map<Id, Id>();

        // Find all Program in the list of opptys
        List<Opportunity> opptyList = [SELECT Id, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Id IN :opptyIds];
        for (Opportunity o : opptyList) {
            opptyToProgramMap.put(o.campaign_program__r.program__c, o.id);
        }
        // Find all Program Template Accounts for the Programs associated with the oppty list
        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program_Default__c = true AND Program__c IN : opptyToProgramMap.keySet()];
        for (Program_Template_Account__c pta : programTemplateAccounts) {
            programTemplateToProgramMap.put(pta.program__c, pta.Id);
        }

        // Keep Program on related FleetEnrollment in sync with Program on Oppty
        for (FleetEnrollment__c fe : [
                SELECT Id, Opportunity__c, Opportunity__r.Campaign_Program__r.Program__c, Program__c, Program_Template_Account__c, Opportunity_Number__c,
                        Billing_Cycle__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Address_Line_1__c, Billing_City__c,
                        Billing_State__c, Billing_Postal_Code__c, Billing_Email__c, Billing_Phone__c,
                        Opportunity__r.Siebel_Opportunity__c, Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c,
                        Opportunity__r.Billing_Contact_First_Name__c, Opportunity__r.Billing_Contact_Last_Name__c, Opportunity__r.Billing_Street__c,
                        Opportunity__r.Billing_City__c, Opportunity__r.Billing_State__c, Opportunity__r.Billing_Zip_Postal_Code__c,
                        Opportunity__r.Billing_Contact_Email__c, Opportunity__r.Billing_Contact_Phone__c
                FROM FleetEnrollment__c
                WHERE Opportunity__c IN :opptyIds]
        ) {
            if (fe.Program__c != fe.Opportunity__r.Campaign_Program__r.Program__c)
                fe.Program__c = fe.Opportunity__r.Campaign_Program__r.Program__c;
                fe.Program_Template_Account__c = programTemplateToProgramMap.get(fe.Opportunity__r.Campaign_Program__r.Program__c);
            if (fe.Opportunity__r.Siebel_Opportunity__c != null && fe.Opportunity_Number__c == null) fe.Opportunity_Number__c = fe.Opportunity__r.Siebel_Opportunity__c;
            if (fe.Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c != null && fe.Billing_Cycle__c == null) fe.Billing_Cycle__c = fe.Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c;
            if (fe.Opportunity__r.Billing_Contact_First_Name__c != null && fe.Billing_Contact_First_Name__c == null) fe.Billing_Contact_First_Name__c = fe.Opportunity__r.Billing_Contact_First_Name__c;
            if (fe.Opportunity__r.Billing_Contact_Last_Name__c != null && fe.Billing_Contact_Last_Name__c == null) fe.Billing_Contact_Last_Name__c = fe.Opportunity__r.Billing_Contact_Last_Name__c;
            if (fe.Opportunity__r.Billing_Street__c != null && fe.Billing_Address_Line_1__c == null) fe.Billing_Address_Line_1__c = fe.Opportunity__r.Billing_Street__c;
            if (fe.Opportunity__r.Billing_City__c != null && fe.Billing_City__c == null) fe.Billing_City__c = fe.Opportunity__r.Billing_City__c;
            if (fe.Opportunity__r.Billing_State__c != null && fe.Billing_State__c == null) fe.Billing_State__c = fe.Opportunity__r.Billing_State__c;
            if (fe.Opportunity__r.Billing_Zip_Postal_Code__c != null && fe.Billing_Postal_Code__c == null) fe.Billing_Postal_Code__c = fe.Opportunity__r.Billing_Zip_Postal_Code__c;
            if (fe.Opportunity__r.Billing_Contact_Email__c != null && fe.Billing_Email__c == null) fe.Billing_Email__c = fe.Opportunity__r.Billing_Contact_Email__c;
            if (fe.Opportunity__r.Billing_Contact_Phone__c != null && fe.Billing_Phone__c == null) fe.Billing_Phone__c = fe.Opportunity__r.Billing_Contact_Phone__c;
            feUpdateList.add(fe);
        }

        if (feUpdateList.size() > 0) {
            try {
                update feUpdateList;
            } catch (DmlException e) {
                System.debug('Error Updating FleetEnrollment Records: ' + e.getMessage());
            }
        }

    }

}