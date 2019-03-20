//revision history https://gist.github.com/aplssf/ffd6a3307fc7da16a545/revisions
trigger WE_IMProjCmpltnUp on MPM4_BASE__Milestone1_Project__c (after insert, after update) {
   
    //retrieve all Record Types (names & Ids) from org
    Map<String, Schema.RecordTypeInfo> RT = MPM4_BASE__Milestone1_Project__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    //retrieve all values from list Custom Setting
    List<VRTN__c> weRTs = VRTN__c.getall().values();
    List<String> weRTNames = new List<String>();
    Set<Id> validRecordTypeIds = new Set<Id>();
    
    Set<Id> projects = new Set<Id>();
    Map<Id,Date> deadlineDates = new Map<Id,Date>();
    Map<Id, Opportunity> oppsToUp = new Map<Id, Opportunity>();
    Map<Id, Opportunity> updatedOpps = new Map<Id, Opportunity>();
    
    for(VRTN__c weRT : weRTs) {
        try {
            //retrieve Record Types from Custom Setting field
            weRTNames.add(weRT.NAEUProjs__c);
        } catch (System.StringException e) {
            System.debug(System.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NAEUOpps__c);
        }
    }
    system.debug('weRTNames contains ' + weRTNames);
    
    for(String weRTN : weRTNames) {
        //checks whether the RT is included in the list retrieved from the Custom Setting field
        if(RT.get(weRTN) != null){
            SYSTEM.debug(RT.get(weRTN).getRecordTypeId());
            //add the RT ids to the list of valid Ids for your trigger logic
            validRecordTypeIds.add(RT.get(weRTN).getRecordTypeId());
        }
    }
    
    if(Trigger.isInsert){
        for(MPM4_BASE__Milestone1_Project__c p : Trigger.new){
            if(validRecordTypeIds.contains(p.RecordTypeId) && p.MPM4_BASE__Deadline__c != null)
            {
                projects.add(p.Id);
                deadlineDates.put(p.Id, p.MPM4_BASE__Deadline__c);
            }
        }
    }
    
    if(Trigger.isUpdate){
                for(MPM4_BASE__Milestone1_Project__c p : Trigger.new){
                    if(validRecordTypeIds.contains(p.RecordTypeId) && p.MPM4_BASE__Deadline__c != null)
                    {
                        MPM4_BASE__Milestone1_Project__c oldP = Trigger.oldMap.get(p.Id);
                        
                        if(oldP.MPM4_BASE__Deadline__c != p.MPM4_BASE__Deadline__c){
                            projects.add(p.Id);
                            deadlineDates.put(p.Id, p.MPM4_BASE__Deadline__c);
                        }
                    }
                }
    }
    if(projects.size() > 0){
        
        for(ProjectxOpp__c j : [SELECT Project__c, Opportunity__r.Id, Opportunity__r.Implementation_Revenue__c FROM ProjectxOpp__c
                                 WHERE Project__c In :projects AND Opportunity__c != null]) {
                 
            Id oppId = j.Opportunity__r.Id;
                Opportunity opp = oppsToUp.get(oppId);
            //only add an Opportunity to the list once (check needed in case an Opportunity is related
            //to more than one Project)
            if (opp == null) {
                opp = j.Opportunity__r;
                oppsToUp.put(oppId, opp);
            }
            Date newCompDate = deadlineDates.get(j.Project__c);
            //latest Deadline date will always be used
            //only update Opportunity date if Deadline is further away, for conservative forecasts
            if (newCompDate > opp.Implementation_Revenue__c || opp.Implementation_Revenue__c == null){
                opp.Implementation_Revenue__c = newCompDate;
                updatedOpps.put(oppId, opp);
            }
        }
        // DML statement
        Database.SaveResult[] srList = Database.update(updatedOpps.values(), false);
        
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
    }
    
}