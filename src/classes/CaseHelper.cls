public class CaseHelper {

    public static void completeCaseMilestone(List<Case> records, Map<Id, Case> oldMap) {

        // migrated from trigger completeCaseMilestone as part of trigger factory deployment to case object

        // Code process is to check whether the Case which has been changed's Record Type Id is listed
        // in the Custom Setting. Then it checks whether the Case Owner has been changed, from the
        // Wex Europe Applications Queue, if that has happened, the code finds and completes the related CaseMilestone.

        List<WEID__c> weids = WEID__c.getall().values();
        Set<Id> validRecordTypeIds = new Set<Id>();

        // add Case Record Type Ids from Custom Setting to list of valid Ids
        for (WEID__c weid: weids) {
            try {
                validRecordTypeIds.add(weid.WECaseId__c);
            } catch (System.StringException e) {
                System.debug(
                    System.LoggingLevel.ERROR,
                    'Invalid Record Type Id ' + weid.WECaseId__c
                );
            }
        }

        if (!validRecordTypeIds.isEmpty()) {

            // create a list of Cases with valid Record Types
            List<Case> caseIds = new List<Case>();
            for (Case c : records) {

                if (validRecordTypeIds.contains(c.RecordTypeId)) {
                    caseIds.add(c);
                    System.debug('caseIds size is ' + caseIds.size());
                }
            }

            if (caseIds.isEmpty() == true) {
                System.debug('No Cases with a valid Wex Europe Record Type Id were found');
                // exit trigger if no Cases with valid Record Type Ids are found
                return;

            } else {

                // fetch Id of Queue
                List <Group> wecsQueue = [SELECT Id FROM Group WHERE Name = 'Wex Europe Applications'];

                List<Id> acceptedIds = new List <Id>();
                for (Case c1 : caseIds) {

                    // check whether Case owner has changed, from Queue
                    Case oldCase1 = oldMap.get(c1.Id);
                    if (oldCase1 != null && oldCase1.OwnerId == wecsQueue[0].Id && oldCase1.OwnerId != c1.OwnerId) {
                        acceptedIds.add(c1.Id);
                    }
                }

                if (acceptedIds.isEmpty()) {
                    System.debug('No Milestones linked to the changed Case need to be updated');
                    return;

                } else {

                    // create a map to hold the MilestoneType's Names & Ids
                    Map<String, Id> milestones = new Map <String, Id>();

                    // populate the map with the results of the SOQL query
                    for (MilestoneType mT : [SELECT Name, Id FROM MilestoneType WHERE Name = 'Case Accepted']) {
                        milestones.put(mT.Name, mT.Id);
                    }

                    // fetch the Id of the right Milestone
                    Id acceptedM = milestones.get('Case Accepted');

                    // find the correct CaseMilestone to update
                    List<CaseMilestone> milestonesToUp1 = [SELECT Id FROM CaseMilestone WHERE CaseId = :acceptedIds AND MilestoneTypeId = :acceptedM];

                    for (CaseMilestone cm : milestonesToUp1) {
                        //mark the Milestone as complete
                        cm.CompletionDate = System.now();
                    }

                    update milestonesToUp1;

                }

            }

        }

    }

}