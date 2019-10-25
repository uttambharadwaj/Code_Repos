/**
 * Created by MFarrell on 7/24/2019.
 */

public class OpportunityBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        UOpportunity.getStageId(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.echoBefore(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.setContactRoles(tp.newList);
        UOpportunity.checkProgramAccount(tp.newList, (Map<Id, Opportunity>) tp.oldMap);
        UOpportunity.executeBREeze(tp.newList, (Map<Id, Opportunity>) tp.oldMap);

        checkFleetEnrollment((List<Opportunity>) tp.newList, (Map<Id, Opportunity>) tp.oldMap); // create new or update existing FleetEnrollment__c on Fuel Card Oppty

    }

    private static void checkFleetEnrollment (List<Opportunity> opptyList, Map<Id, Opportunity> opptyOldMap) {

        // check for existing fleet enrollment record on oppty
        // if it doesn't exist, create one using helper class
        List<Opportunity> opptyWithoutFEList = new List<Opportunity>();
        List<Opportunity> opptyWithFEList = new List<Opportunity>();
        Set<Opportunity> fuelCardOpptyIds = new Set<Opportunity>();
        Map<Id, Id> feToOpptyMap = new Map<Id, Id>();
        List<FleetEnrollment__c> feToUpdate = new List<FleetEnrollment__c>();

        // we only do this for Fuel Card Opportunities
        for (Opportunity opp : opptyList) {
            if (opp.RecordTypeId == UtilityClass.getRecordTypeByName(Opportunity.getSObjectType(), 'Fuel Card')) {
                fuelCardOpptyIds.add(opp);
            }
        }

        for (FleetEnrollment__c fe : [
                SELECT  Id, Opportunity__c, Opportunity__r.Campaign_Program__r.Program__c, Program__c, Program_Template_Account__c, Opportunity_Number__c,
                        Billing_Cycle__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Billing_Address_Line_1__c, Billing_City__c,
                        Billing_State__c, Billing_Postal_Code__c, Billing_Email__c, Billing_Phone__c,
                        Opportunity__r.Siebel_Opportunity__c, Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c,
                        Opportunity__r.Billing_Contact_First_Name__c, Opportunity__r.Billing_Contact_Last_Name__c, Opportunity__r.Billing_Street__c,
                        Opportunity__r.Billing_City__c, Opportunity__r.Billing_State__c, Opportunity__r.Billing_Zip_Postal_Code__c,
                        Opportunity__r.Billing_Contact_Email__c, Opportunity__r.Billing_Contact_Phone__c
                FROM FleetEnrollment__c
                WHERE Opportunity__c IN : fuelCardOpptyIds])
        {
            feToOpptyMap.put(fe.Opportunity__c, fe.Id);
            feToUpdate.add(fe);
        }

        for (Opportunity opp : fuelCardOpptyIds) {
            if (feToOpptyMap.containsKey(opp.Id) == true) {
                opptyWithFEList.add(opp);
            } else {
                opptyWithoutFEList.add(opp);
            }
        }

        // create the new fleet enrollment records for the opportunities without a fleet enrollment record.
        if (opptyWithoutFEList.size() > 0) {
            OpportunityHelper.createFleetEnrollment((List<Opportunity>) opptyWithoutFEList);
        }

        // if existing fleet enrollment record, keep it in sync with the opportunity
        if (opptyWithFEList.size() > 0) {
            List<Opportunity> updatedOpptyList = new List<Opportunity>();
            for (Opportunity op : opptyWithFEList) {
                if (op.Campaign_Program__c != opptyOldMap.get(op.Id).Campaign_Program__c) {
                    updatedOpptyList.add(op);
                }
            }

        // if the campaign program changed on the opportunity, update the fleet enrollment record
            if (updatedOpptyList.size() > 0) {
                updateFleetEnrollment((List<Opportunity>) updatedOpptyList, (List<FleetEnrollment__c>) feToUpdate);
            }
        }

    }

    private static void updateFleetEnrollment(List<Opportunity> opptyList, List<FleetEnrollment__c> feUpdateList) {

        Map<Id, Id> opptyToProgramMap = new Map<Id, Id>();
        Map<Id, Id> programTemplateToProgramMap = new Map<Id, Id>();

        // Find all Program in the list of opptys
        List<Opportunity> oppList = [SELECT Id, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Id IN :opptyList];
        for (Opportunity o : oppList) {
            opptyToProgramMap.put(o.Campaign_Program__r.Program__c, o.id);
        }
        // Find all Program Template Accounts for the Programs associated with the oppty list
        List<Program_Template_Account__c> programTemplateAccounts = [SELECT Id, Program__c FROM Program_Template_Account__c WHERE Program_Default__c = TRUE AND Program__c IN : opptyToProgramMap.keySet()];
        for (Program_Template_Account__c pta : programTemplateAccounts) {
            programTemplateToProgramMap.put(pta.Program__c, pta.Id);
        }

        // Keep FleetEnrollment in sync with Oppty
        for (FleetEnrollment__c fe : feUpdateList) {
            if (fe.Program__c != fe.Opportunity__r.Campaign_Program__r.Program__c) {
                fe.Program__c = fe.Opportunity__r.Campaign_Program__r.Program__c;
                fe.Program_Template_Account__c = programTemplateToProgramMap.get(fe.Opportunity__r.Campaign_Program__r.Program__c);
            }
            if (fe.Opportunity__r.Siebel_Opportunity__c != null && fe.Opportunity_Number__c == null) fe.Opportunity_Number__c = fe.Opportunity__r.Siebel_Opportunity__c;
            if (fe.Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c != null && fe.Billing_Cycle__c == null) fe.Billing_Cycle__c = fe.Opportunity__r.Campaign_Program__r.Program__r.Fleet_Default_Billing_Cycle__c;
            if (fe.Opportunity__r.Billing_Contact_First_Name__c != null && fe.Billing_Contact_First_Name__c == null) fe.Billing_Contact_First_Name__c = fe.Opportunity__r.Billing_Contact_First_Name__c;
            if (fe.Opportunity__r.Billing_Contact_Last_Name__c != null && fe.Billing_Contact_Last_Name__c == null) fe.Billing_Contact_Last_Name__c = fe.Opportunity__r.Billing_Contact_Last_Name__c;
            if (fe.Opportunity__r.Billing_Contact_Email__c != null && fe.Billing_Email__c == null) fe.Billing_Email__c = fe.Opportunity__r.Billing_Contact_Email__c;
            if (fe.Opportunity__r.Billing_Contact_Phone__c != null && fe.Billing_Phone__c == null) fe.Billing_Phone__c = fe.Opportunity__r.Billing_Contact_Phone__c;
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