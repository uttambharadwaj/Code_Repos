//revision history https://gist.github.com/aplssf/1ecf170c0393f9a10504/revisions
trigger WE_ProjxOppUp on Opportunity (before update) {
    
    //retrieve all Record Types (names & Ids) from org
    Map<String, Schema.RecordTypeInfo> RT = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
    //retrieve all values from list Custom Setting
    List<VRTN__c> weRTs = VRTN__c.getall().values();
    
    List<String> weEURTNames = new List<String>();
    Set<Id> validEURecordTypeIds = new Set<Id>();
    List<String> weNARTNames = new List<String>();
    Set<Id> validNARecordTypeIds = new Set<Id>();
    
    for(VRTN__c weRT : weRTs) {
        try {
            //retrieve Record Types from Custom Setting field
            weEURTNames.add(weRT.EUOpps__c);
        } catch (System.StringException e) {
            System.debug(System.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.EUOpps__c);
        }
        try {
            weNARTNames.add(weRT.NAOpps__c);
        } catch (System.StringException e) {
            System.debug(System.LoggingLevel.ERROR,'Invalid Record Type Name ' + weRT.NAOpps__c);
        }
    }
    system.debug('weEURTNames contains ' + weEURTNames);
    system.debug('weNARTNames contains ' + weNARTNames);
    
    if(weEURTNames.size() > 0){
        for(String weRTN : weEURTNames) {
            //checks whether the RT is included in the list retrieved from the Custom Setting field
            if(RT.get(weRTN) != null){
                SYSTEM.debug(RT.get(weRTN).getRecordTypeId());
                //add the RT ids to the list of valid Ids for your trigger logic
                validEURecordTypeIds.add(RT.get(weRTN).getRecordTypeId());
            }
        }
        system.debug('validEURecordTypeIds contains ' + validEURecordTypeIds);
    }
    
    if(weNARTNames.size() > 0){
        for(String weRTN : weNARTNames) {
            if(RT.get(weRTN) != null){
                SYSTEM.debug(RT.get(weRTN).getRecordTypeId());
                validNARecordTypeIds.add(RT.get(weRTN).getRecordTypeId());
            }
        }
        system.debug('validNARecordTypeIds contains ' + validNARecordTypeIds);
    }
    
    if(validEURecordTypeIds.size() > 0 || validNARecordTypeIds.size() > 0){
        
        Set<Id> opps = new Set<Id>();
        Map<Id,Date> oppCls = new Map<Id,Date>();
        Map<Id,Decimal> oppNetFSR = new Map<Id,Decimal>();
        Map<Id,Date> oppRevCom = new Map<Id,Date>();
        Map<Id,Decimal> oppMCAnnualSpnd = new Map<Id,Decimal>();
        List<ProjectxOpp__c> juncRecs = new List<ProjectxOpp__c>();
        
        for(Opportunity o : Trigger.New){
            //check that Opportunity Record Type Id is valid
            //split EU & NA because no need to check fields which aren't being used
            if(validEURecordTypeIds.contains(o.RecordTypeId)){
                Opportunity oldO = Trigger.oldMap.get(o.Id);
                
                if(oldO.CloseDate != o.CloseDate){
                    opps.add(o.Id);
                    oppCls.put(o.Id, o.CloseDate);
                }
                if(oldO.Net_Full_Service_Revenue__c != o.Net_Full_Service_Revenue__c){
                    opps.add(o.Id);
                    oppNetFSR.put(o.Id, o.Net_Full_Service_Revenue__c);
                }               
                if(oldO.Implementation_Revenue__c != o.Implementation_Revenue__c){
                    opps.add(o.Id);
                    oppRevCom.put(o.Id, o.Implementation_Revenue__c);
                }
                
            } else if (validNARecordTypeIds.contains(o.RecordTypeId)){
                Opportunity oldO = Trigger.oldMap.get(o.Id);
                
                if(oldO.CloseDate != o.CloseDate){
                    opps.add(o.Id);
                    oppCls.put(o.Id, o.CloseDate);
                }
                if(oldO.Net_Full_Service_Revenue__c != o.Net_Full_Service_Revenue__c){
                    opps.add(o.Id);
                    oppNetFSR.put(o.Id, o.Net_Full_Service_Revenue__c);
                }               
            }
        }
        
        system.debug('opps size is ' + opps.size());
        
        if(opps.size() > 0){
            
            system.debug('in juncRecs loop');
            
            for(ProjectxOpp__c junc : [SELECT Opportunity__c, Opportunity_Net_FSR__c, Opportunity_Close_Date__c, Opportunity_Imp_Revenue_Com_Date__c FROM ProjectxOpp__c
                                       WHERE Opportunity__c IN :opps])
            {
                Date clsDt = oppCls.get(junc.Opportunity__c);
                if(clsDt != null){
                    junc.Opportunity_Close_Date__c = clsDt;
                }
                Decimal netFSR = oppNetFSR.get(junc.Opportunity__c);
                if(netFSR != null){
                    junc.Opportunity_Net_FSR__c = netFSR;
                }
                Date impRevComDt = oppRevCom.get(junc.Opportunity__c);
                if(impRevComDt != null){
                    junc.Opportunity_Imp_Revenue_Com_Date__c = impRevComDt;
                }
                juncRecs.add(junc);
            }
            // Database Class Method (DML operation)
            Database.SaveResult[] srList = Database.update(juncRecs, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted ProjectxOpp record. ProjectxOpp ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('ProjectxOpp fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
}