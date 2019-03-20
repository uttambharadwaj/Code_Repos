//revision history //revision history https://gist.github.com/aplssf/26e0e832d0e72351c0fb/revisions
trigger WE_OpportunityTargetUpdate on Opportunity (after update) {
    
    List<WEID__c> weids = WEID__c.getall().values();
    Set<Id> validRecordTypeIds = new Set<Id>();
    
    // add Opportunity Record Type Ids from Custom Setting to list of valid Ids      
    for(WEID__c weid: weids) {
        try {
            validRecordTypeIds.add(weid.WEOppId__c);
        } catch (System.StringException e) {
            System.debug(
                System.LoggingLevel.ERROR,
                'Invalid Record Type Id ' + weid.WEOppId__c
            );
        }
    }
    
    List<Opportunity> reassignedOpps = new List<Opportunity>();
    List<Opportunity> updatedOpps = new List<Opportunity>();
    List<TargetxOpp__c> targetsToDel = new list<TargetxOpp__c>();
    Set<String> identifiers = new Set<String>();
    Map<String,Id> newTargets = new Map <String,Id>();
    List<TargetxOpp__c> targetsToCreate = new List<TargetxOpp__c>();
    
    for (Opportunity o : Trigger.new){
        
        //check that Opportunity record type is valid
        if(validRecordTypeIds.contains(o.RecordTypeId))
        {
            //check whether Opportunity owner has changed
            Opportunity oldOpp = Trigger.OldMap.get(o.Id);
            if(oldOpp != null
               &&
               oldOpp.OwnerId != o.OwnerId){
                   identifiers.add(/*o.Identifier__c*/null);
                   reassignedOpps.add(o);
               }else
                //check whether close date month or year has changed
                if(oldOpp != null 
                   &&
                   (oldOpp.CloseDate.month() != o.CloseDate.month()
                    ||
                    oldOpp.CloseDate.year() != o.CloseDate.year()
                   )){
                       identifiers.add(/*o.Identifier__c*/null);
                       updatedOpps.add(o);
                   }
        }
    }
    system.debug('reassignedOpps contains ' + reassignedOpps);
    system.debug('updatedOpps contains ' + updatedOpps);
    system.debug('identifiers contains ' + identifiers);
    
    if(updatedOpps.isEmpty() == true){
        System.debug('no Opportunities had a close date with a new month or year');
    }
    if(reassignedOpps.isEmpty() == true){
        System.debug('no Opportunities had new owners');
    }
       
       if(reassignedOpps.size() > 0 || UpdatedOpps.size() > 0){
           
           for(Opportunity o : [SELECT Id, RecordTypeId,
                               (SELECT Id FROM TargetxOpp__r) FROM Opportunity
                                 WHERE (Id IN :reassignedOpps OR Id IN :updatedOpps)]){
                                    targetsToDel.addAll(o.TargetxOpp__r);
                                }
           delete targetsToDel;
           
           //populate map of target records with an identifier that matches the Opportunity's
           for(Target__c t: [SELECT Identifier__c, Id FROM Target__c
                              WHERE Identifier__c in :identifiers])
               newTargets.put(t.Identifier__c, t.Id);
           
           system.debug('newTargets contains ' + newTargets);
           
           if(reassignedOpps.size() > 0){
               for(Opportunity o : reassignedOpps){
                   
                   TargetxOpp__c txo = new TargetxOpp__c();
                   txo.Opportunity__c = o.Id;
                   txo.Target__c = newTargets.get(/*o.Identifier__c*/null);
                
                   if(txo.Target__c != null){
                       targetsToCreate.add(txo);
                   }else{
                       o.addError(' Please ask your Salesforce Administrator to add a target record, for the month & year of your Opportunity\'s close date');
                   }
               }
           }
           
           if(updatedOpps.size() > 0){
               for(Opportunity o: updatedOpps){
                   
                   TargetxOpp__c txo = new TargetxOpp__c();
                   txo.Opportunity__c = o.Id;
                   txo.Target__c = newTargets.get(/*o.Identifier__c*/null);

                   if(txo.Target__c != null){
                       targetsToCreate.add(txo);
                   }else{
                       o.addError(' Please ask your Salesforce Administrator to add a target record, for the month & year of your Opportunity\'s close date');
                   }       
               }
           }
           insert targetsToCreate;
       }
}