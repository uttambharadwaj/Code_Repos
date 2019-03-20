//revision history https://gist.github.com/aplssf/5424f76c9ec41ca9428a/revisions
trigger WE_NewOpportunityTarget on Opportunity (after insert) {
    
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
    
    List<Opportunity> oppIds = new List<Opportunity>();
    Set<String> identifiers = new Set<String>();
    map<String,Id> targets = new map <String,Id>();
    List<TargetxOpp__c> newLinks = new List<TargetxOpp__c>();
    
    for (Opportunity o : Trigger.new){
        //check that Opportunity record type is valid
        if(validRecordTypeIds.contains(o.RecordTypeId))
        {
            identifiers.add(/*o.Identifier__c*/null);
            oppIds.add(o);
            system.debug('oppIds size is ' + oppIds.size());
        }      
    }
    system.debug('identifiers contains ' + identifiers);
    
    if(oppIds.isEmpty() == true){
        system.debug('No Opportunities with a valid Record Type Id were found');
    }else{
        
        //create map of target records with an identifier that matches the Opportunity's
        for(Target__c t: [SELECT Identifier__c, Id FROM Target__c
                          WHERE Identifier__c in :identifiers])
            targets.put(t.Identifier__c, t.Id);
            system.debug('targets contains ' + targets);
        
        for(Opportunity opp : oppIds){
            
            TargetxOpp__c j = new TargetxOpp__c();
            
            // fetch Id of Target record, based on Opportunity identifier
            Id t1 = targets.get(/*opp.Identifier__c*/null);
            system.debug('t1 contains ' + t1);
            
            j.Opportunity__c = opp.Id;
            j.Target__c = t1;
            
            newLinks.add(j);
        }
        // Database Class Method (DML operation)
        Database.SaveResult[] srList = Database.insert(newLinks, false);
        
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted TargetxOpp record. TargetxOpp ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('TargetxOpp fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}