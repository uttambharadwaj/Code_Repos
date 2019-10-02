// Code process is to check whether the Case which has been changed's Record Type Id is listed
// in the Custom Setting. Then it checks whether the Case Owner has been changed, from the
// Wex Europe Applications Queue, if that has happened, the code finds and completes the related CaseMilestone.

// Closed Case sections of the code have been removed, due to the business process being changed.

trigger completeCaseMilestone on Case (after update) {

    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Case_Automation__c) { return; }

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

    // create a list of Cases with valid Record Types
    List<Case> caseIds = new List<Case>();
    for (Case c : Trigger.new) {

        if (validRecordTypeIds.contains(c.RecordTypeId)) {
            caseIds.add(c);
            system.debug('caseIds size is ' + caseIds.size());
        }
    }
    if (caseIds.isEmpty() == true) {
        system.debug('No Cases with a valid Wex Europe Record Type Id were found');
        // exit trigger if no Cases with valid Record Type Ids are found
        return;
    }
    else{

        // fetch Id of Queue
        List <Group> wecsQueue = [SELECT Id
                                    FROM Group
                                   WHERE Name = 'Wex Europe Applications'];

        List<Id> acceptedIds = new List <Id>();
        for (Case c1 : caseIds){

            // check whether Case owner has changed, from Queue
            Case oldCase1 = Trigger.OldMap.get(c1.Id);
            if (oldCase1 != null &&
                oldCase1.OwnerId == wecsQueue[0].Id &&
                oldCase1.OwnerId != c1.OwnerId)
            {
                acceptedIds.add(c1.Id);
            }
        }
/*
        List<Id> closedIds = new List <Id>();
        for (Case c2 : caseIds){

            // check whether Case has been closed
            Case oldCase2 = Trigger.oldMap.get(c2.Id);
            System.debug('oldCase2 isClosed is '+ oldCase2.IsClosed);
            System.debug('c2 isClosed is ' + c2.IsClosed);

            if(oldCase2.IsClosed == false && c2.IsClosed == true)
            {
                closedIds.add(c2.Id);
                System.debug('closedIds size is ' + closedIds.size());
            }
        }

        if(closedIds.isEmpty() == true){
            System.debug('No newly closed Cases were found');}
*/

        if (acceptedIds.isEmpty() == true /*&&
            closedIds.isEmpty() == true*/)
        {
            system.debug('No Milestones, linked to the changed Case, need to be updated');
            return;
        }

        // create a map to hold the MilestoneType's Names & Ids
        map<String, Id> milestones = new map <String, Id>();

            // populate the map with the results of the SOQL query
            for (MilestoneType mT : [SELECT Name, Id
                                       FROM MilestoneType
                                      WHERE Name = 'Case Accepted' /*OR Name = 'Create & CSDM Approve Account'*/])
            {
              milestones.put(mT.Name,mT.Id);
            }

            if (acceptedIds.size() > 0) {

              // fetch the Id of the right Milestone
              Id acceptedM = milestones.get('Case Accepted');

              // find the correct CaseMilestone to update
              List<CaseMilestone> milestonesToUp1 = [SELECT Id
                                                       FROM CaseMilestone
                                                      WHERE CaseId = :acceptedIds AND MilestoneTypeId = :acceptedM];

              for (CaseMilestone cm : milestonesToUp1) {
                //mark the Milestone as complete
                cm.CompletionDate = System.now();
              }
              update milestonesToUp1;
            }
/*
            if (closedIds.size() > 0) {

                Id closedM = milestones.get('Create & CSDM Approve Account');

                List<CaseMilestone> milestonesToUp2 = [SELECT Id
                                                         FROM CaseMilestone
                                                        WHERE CaseId = :closedIds AND MilestoneTypeId = :closedM];
                for(CaseMilestone cm2 : milestonesToUp2) {
                    cm2.CompletionDate = System.now();
                }
                update milestonesToUp2;
            }
*/
    }

}