/*
 * Created by MFarrell on 7/23/2019.
 */

public class OpportunityHelper {

    // After Insert, After Update
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

    public static void createFleetEnrollment(Set<ID> opptyIds) {

        List<FleetEnrollment__c> feCreateList = new List<FleetEnrollment__c>();

        // create new FleetEnrollment__c record for each opportunity, add records to feList
        for (Opportunity opp : [SELECT Id, Campaign_Program__c, Campaign_Program__r.Program__c FROM Opportunity WHERE Id IN :opptyIds]) {
            FleetEnrollment__c fleetEnrollment = new FleetEnrollment__c();
            fleetEnrollment.Opportunity__c = opp.id;
            if (opp.Campaign_Program__c != null)
                fleetEnrollment.Program__c = opp.Campaign_Program__r.Program__c;
            if (Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal') != null)
                fleetEnrollment.RecordTypeId = Schema.Sobjecttype.FleetEnrollment__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();

            feCreateList.add(fleetEnrollment);

        }


        try {
            insert feCreateList;
        } catch (DmlException e){
            System.debug('Error Inserting FleetEnrollment Records: ' + e.getMessage());
        }
    }

    public static void updateFleetEnrollment(Set<Id> opptyIds) {

        List<FleetEnrollment__c> feUpdateList = new List<FleetEnrollment__c>();

        for (FleetEnrollment__c fe : [SELECT Id, Opportunity__c, Opportunity__r.Campaign_Program__r.Program__c, Program__c FROM FleetEnrollment__c WHERE Opportunity__c IN :opptyIds]) {
            if (fe.Program__c != fe.Opportunity__r.Campaign_Program__r.Program__c)
                fe.Program__c = fe.Opportunity__r.Campaign_Program__r.Program__c;
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