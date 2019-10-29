/**
 * Created by mfarrell on 2019-10-24.
 */

public class OpportunityAndFinallyTriggerHandler {

    public static void andFinallyMain () {
        insertFleetEnrollmentRecords(); //insert fleet enrollment records after all trigger logic to prevent duplicates
        clearSet(); //clear set after logic
    }

    private static void insertFleetEnrollmentRecords() {

        Set<FleetEnrollment__c> feNoDuplicates = OpportunityTriggerDispatcher.feNoDuplicatesSet;
        List<FleetEnrollment__c> feToInsert = new List<FleetEnrollment__c>();

        if (feNoDuplicates.size() > 0){
            feToInsert.addAll(feNoDuplicates);
        }

        if (feToInsert.size() > 0) {
            try {
                insert feToInsert;
            } catch (DmlException e) {
                System.debug('Error Updating FleetEnrollment Records: ' + e.getMessage());
            }
        }
    }

    private static void clearSet() {

        OpportunityTriggerDispatcher.feNoDuplicatesSet.clear();

    }

}