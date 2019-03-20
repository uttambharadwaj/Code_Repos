public class WE_NewOpportunityTarget {
//  class can be removed from production

    Map<Id, Opportunity> newOpps;
    List<Opportunity> opps = new List<Opportunity>();
    Set<String> identifiers = new Set<String>();
    map<String,Id> targets = new map <String,Id>();
    List<TargetxOpp__c> newJuncRecs = new List<TargetxOpp__c>();
    
    // constructor
    public WE_NewOpportunityTarget(
        Map<Id, Opportunity> newTriggerOpps)
    {
        newOpps = newTriggerOpps;
    }    
    
    // method
    public void generateNewTargets(){
        
        WE_ApexUtility.checkApexControllerStatus(
            'Target Manager');
        if (!WE_ApexUtility.targetManagerDisabled.contains(true))
        {
            // create Object from Class
            WE_ApexUtility apxUtil = new WE_ApexUtility();
            apxUtil.retrieveValidRecordTypes('EU Opps');
            
            for (Opportunity o : newOpps.values())
            {
                if (WE_ApexUtility.validEuRecordTypeIds.contains(o.RecordTypeId))
                {
                    identifiers.add(o.Close_Date_Identifier__c);
                    opps.add(o);
                    system.debug('WE_NewOpportunityTarget: opps size is ' + opps.size());
                }
            }
        }
        system.debug('WE_NewOpportunityTarget: identifiers contains ' + identifiers);
        
        if (opps.isEmpty() == true)
        {
            system.debug('WE_NewOpportunityTarget: No Opportunities with a valid Record Type Id were found');
        }
        else
        {
            //create map of target records with an identifier that matches the Opportunity's
            for(Target__c t : [SELECT Identifier__c, Id 
                                 FROM Target__c
                                WHERE Identifier__c in :identifiers])
            {
                targets.put(t.Identifier__c, t.Id);
                system.debug('targets contains ' + targets);
            }
            
            for(Opportunity opp : opps)
            {
                TargetxOpp__c j = new TargetxOpp__c();
                
                // fetch Id of Target record, based on Opportunity identifier
                Id t1 = targets.get(opp.Close_Date_Identifier__c);
                system.debug('t1 contains ' + t1);
                
                j.Opportunity__c = opp.Id;
                j.Target__c = t1;
                
                newJuncRecs.add(j);
            }
            // Database Class Method (DML operation)
            Database.SaveResult[] srList = Database.insert(newJuncRecs, false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) 
            {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted TargetxOpp record. TargetxOpp ID: ' + sr.getId());
                }
                else 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        system.debug('The following error has occurred.');                    
                        system.debug(err.getStatusCode() + ': ' + err.getMessage());
                        system.debug('TargetxOpp fields that affected this error: ' + err.getFields());
                    }
                }
            }    
        }
    }
}