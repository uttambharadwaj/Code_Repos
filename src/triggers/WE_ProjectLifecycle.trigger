//revision history https://gist.github.com/aplssf/ba35a624ec3072a5768a/revisions
trigger WE_ProjectLifecycle on MPM4_BASE__Milestone1_Project__c (after insert, after update) {
    
    //retrieve all Record Types (names & Ids) from org
    Map<String, Schema.RecordTypeInfo> RT = MPM4_BASE__Milestone1_Project__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    //retrieve all values from list Custom Setting
    List<VRTN__c> weRTs = VRTN__c.getall().values();
    List<String> weRTNames = new List<String>();
    Set<Id> validRecordTypeIds = new Set<Id>();
    
    List<MPM4_BASE__Milestone1_Project__c> insProjects = new List<MPM4_BASE__Milestone1_Project__c>();
    List<MPM4_BASE__Milestone1_Project__c> upProjects = new List<MPM4_BASE__Milestone1_Project__c>();
    Map<Id,Integer> projectDuration = new Map<Id,Integer>();
    Map<Integer,String> monthName = new Map<Integer,String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
    List<Project_Month__c> newPMs = new List<Project_Month__c>();
    List<Project_Month__c> existPMs = new List<Project_Month__c>();

    
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
    system.debug('validRecordTypeIds contains ' + validRecordTypeIds);    
    
    If(Trigger.isInsert){
        
        for(MPM4_BASE__Milestone1_Project__c p : Trigger.New){
            
            if(validRecordTypeIds.contains(p.RecordTypeId) && p.MPM4_BASE__Kickoff__c != null && p.MPM4_BASE__Deadline__c != null)
            {
                insProjects.add(p);
                projectDuration.put(p.Id, p.MPM4_BASE__Kickoff__c.monthsBetween(p.MPM4_BASE__Deadline__c));
            }
        }
        system.debug('insProjects contains ' + insProjects);
        system.debug('projectDuration contains ' + projectDuration);
    }
    
    If(Trigger.isUpdate){
        
        for(MPM4_BASE__Milestone1_Project__c p : Trigger.New){
            
            if(validRecordTypeIds.contains(p.RecordTypeId))
            {
                MPM4_BASE__Milestone1_Project__c oldP = Trigger.OldMap.get(p.Id);
                
                if((oldP.MPM4_BASE__Kickoff__c != p.MPM4_BASE__Kickoff__c || oldP.MPM4_BASE__Deadline__c != p.MPM4_BASE__Deadline__c)
                   &&
                   (p.MPM4_BASE__Kickoff__c == null || p.MPM4_BASE__Deadline__c == null)){
                       upProjects.add(p);
                       projectDuration.put(p.Id,-1);//-1 prevents any Project Months being created
                   }else if(oldP.MPM4_BASE__Kickoff__c != p.MPM4_BASE__Kickoff__c
                   ||
                   oldP.MPM4_BASE__Deadline__c != p.MPM4_BASE__Deadline__c)
                   {
                       upProjects.add(p);
                       projectDuration.put(p.Id, p.MPM4_BASE__Kickoff__c.monthsBetween(p.MPM4_BASE__Deadline__c));
                }
            }
        }
        system.debug('upProjects contains ' + upProjects);
        system.debug('projectDuration contains ' + projectDuration);
    }

    if(insProjects.size() > 0){
    
        for(MPM4_BASE__Milestone1_Project__c p : insProjects){
        
            Date k = p.MPM4_BASE__Kickoff__c;
            Integer km = p.MPM4_BASE__Kickoff__c.month();
            Integer dur = projectDuration.get(p.Id);
            
            //create a set of Project Month records for each Project
            for(Integer m = km; m < km + dur + 1; m++){
                
                Project_Month__c pm = new Project_Month__c();
                pm.Project__c = p.Id;
                pm.Name = monthName.get(k.addMonths(m - km).month()) +' '+ k.addMonths(m - km).year();
                pm.month__c = k.addMonths(m - km + 1).toStartOfMonth() - 1;
                pm.Project_Value__c = p.Opportunity_Total_Net_FSR__c;
                newPMs.add(pm);
            }
        }
        system.debug('newPMs contains ' + newPMs);
    }
    
    system.debug('upProjects size is ' + upProjects.size() );
    
    if(upProjects.size() > 0){
        
        for(MPM4_BASE__Milestone1_Project__c p : [SELECT Id,
                                                 (SELECT Id FROM Project_Months__r) FROM MPM4_BASE__Milestone1_Project__c
                                                   WHERE Id IN :upProjects]){
                                                       existPMs.addAll(p.Project_Months__r);
                                                   }
        delete existPMs;
        
        for(MPM4_BASE__Milestone1_Project__c p : upProjects){
            
            Date k = p.MPM4_BASE__Kickoff__c;
            Integer km = 0;
            try{
                Integer i = p.MPM4_BASE__Kickoff__c.month();
                km = i;
            }catch (nullPointerException e){
                Integer i = 0;
                km = i;
            }
            Integer dur = projectDuration.get(p.Id);
            
            for(Integer m = km; m < km + dur + 1; m++){
                
                Project_Month__c pm = new Project_Month__c();
                pm.Project__c = p.Id;
                pm.Name = monthName.get(k.addMonths(m - km).month()) +' '+ k.addMonths(m - km).year();
                pm.month__c = k.addMonths(m - km + 1).toStartOfMonth() - 1;
                pm.Project_Value__c = p.Opportunity_Total_Net_FSR__c;
                newPMs.add(pm);
            }
        }
        system.debug('newPMs contains ' + newPMs);
    }
    insert newPMs;
}