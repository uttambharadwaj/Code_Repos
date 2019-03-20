global class WE_ScheduledDeadlineUpdate implements Schedulable {

    global void execute(SchedulableContext SC) {
        updProjDeadlineDates();
    }

    global void updProjDeadlineDates() {

        //disable validation rules for running user
        //(assumption is that this is administrator & that job is being run at night)
        Id profileId = userinfo.getProfileId();
        WE_VRC__c setting = WE_VRC__c.getInstance(profileId);
        system.debug('setting1 contains ' + setting);

        setting.Non_Fcst_Disabled__c = True;
        upsert setting;
        system.debug('setting2 contains ' + setting);

        //retrieve all Record Types (names & Ids) from org
        Map<String, Schema.RecordTypeInfo> RT = MPM4_BASE__Milestone1_Project__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        //retrieve all values from list Custom Setting
        List<VRTN__c> weRTs = VRTN__c.getall().values();

        List<String> weRTNames = new List<String>();
        Set<Id> validRecordTypeIds = new Set<Id>();
        List<MPM4_BASE__Milestone1_Project__c> updatedProjs = new List<MPM4_BASE__Milestone1_Project__c>();

        for(VRTN__c weRT : weRTs) {
            try {
                //retrieve Record Types from Custom Setting field
                weRTNames.add(weRT.NAEUProjs__c);
            } catch (System.StringException e) {
                System.debug(System.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NAEUProjs__c);
            }
        }
        system.debug('weRTNames contains ' + weRTNames);

        for(String weRTN : weRTNames) {
            //checks whether the RT is included in the list retrieved from the Custom Setting field
            if (RT.get(weRTN) != null) {
                SYSTEM.debug(RT.get(weRTN).getRecordTypeId());
                //add the RT ids to the list of valid Ids for your trigger logic
                validRecordTypeIds.add(RT.get(weRTN).getRecordTypeId());
            }
        }
        system.debug('validRecordTypeIds contains ' + validRecordTypeIds);

        Date d = system.today().addDays(7);

        List<MPM4_BASE__Milestone1_Project__c> projsToUp = [SELECT Id, MPM4_BASE__Deadline__c FROM MPM4_BASE__Milestone1_Project__c
                                                             WHERE MPM4_BASE__Deadline__c <= :d AND RecordTypeId IN :validRecordTypeIds
                                                                   AND Live__c = True];

        system.debug('projsToUp size is ' + projsToUp.size());

        for(MPM4_BASE__Milestone1_Project__c p : projsToUp) {
            p.MPM4_BASE__Deadline__c = system.today().addDays(21);
            updatedProjs.add(p);
        }

        // DML statement
        Database.SaveResult[] srList = Database.update(updatedProjs, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                }
            }
        }
        //reactivate validation rules
        setting.Non_Fcst_Disabled__c = False;
        upsert setting;
    }
    
}