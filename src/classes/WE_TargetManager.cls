// revision history https://gist.github.com/aplssf/bdc62e9c9da89d9eff90/revisions
public class WE_TargetManager {
//
//    Map<Id, Opportunity> oldOpps;
    //Map<Id, Opportunity> newOpps;
    //Id userId;
    //Id userProfileId;
    //List<Opportunity> opps = new List<Opportunity>();
    //Set<String> createdDateIdentifiers = new Set<String>();
    //Set<String> closeDateIdentifiers = new Set<String>();
    //Id closeDateTarget;
    //Id createdDateTarget;
    //Map<String,Target__c> targets = new Map <String,Target__c>();
    //List<TargetxOpp__c> newJuncRecs = new List<TargetxOpp__c>();
    //List<Opportunity> reassignedOpps = new List<Opportunity>();
    //List<Opportunity> oppsWNewCD = new List<Opportunity>();
    //List<Opportunity> oppsNeedingTargets = new List<Opportunity>();
    //List<TargetxOpp__c> targetsToDel = new list<TargetxOpp__c>();
    //Map<String,Id> newTargets = new Map <String,Id>();
    //List<TargetxOpp__c> targetsToCreate = new List<TargetxOpp__c>();
//
//    // constructor
    //public WE_TargetManager(
    //    Map<Id, Opportunity> newTriggerOpps) {
        //newOpps = newTriggerOpps;
    //}
//
//    // method
    //public void generateNewTargets()
    //{
    //    if (WE_ApexUtility.apxCntrlrTargetManagerStatusAssessed == false) {
        //    WE_ApexUtility.checkApexControllerStatus('Target Manager');
        //}
//
//        if (!WE_ApexUtility.targetManagerDisabled.contains(true)) {
        //    Map<Id,Id> userProfileIdbyUserId = new Map<Id,Id>();
            //Set<Id> userProfileIds = new Set<Id>();
            //Set<Id> userProfilesToAssess = new Set<Id>();
            //
            //for(Opportunity o : [SELECT Id,OwnerId,Owner.ProfileId FROM Opportunity WHERE Id IN :newOpps.keySet()])
            //{
            //    userProfileIdbyUserId.put(o.OwnerId,o.Owner.ProfileId);
                //if (!WE_ApexUtility.evaluatedRegionsProfiles.contains(o.Owner.ProfileId)) {
                //    userProfilesToAssess.add(o.Owner.ProfileId);
                //}
            //}
            //if (userProfilesToAssess.size() > 0) {
            //    WE_ApexUtility.checkValidProfile(userProfilesToAssess);
            //}
            //
            //if (WE_ApexUtility.validEuNaRecordTypeIds.isEmpty()) {
            //    // create Object from Class
                //WE_ApexUtility apxUtil = new WE_ApexUtility();
                //apxUtil.retrieveValidRecordTypes('EU NA Opps');
            //}
//
//            for(Opportunity o : newOpps.values()) {
            //    if (WE_ApexUtility.validEuNaRecordTypeIds.contains(o.RecordTypeId)) {
                //    // !!! can retrive Opportunity owner's Id with a query for identifier & remove Profile check, once class is executing in @future context
                    //if (WE_ApexUtility.validEuNaSalesRmProfiles.contains(userProfileIdbyUserId.get(o.OwnerId)) == true) {
                    //    closeDateIdentifiers.add(o.Close_Date_Identifier__c);
                        //createdDateIdentifiers.add(o.Created_Date_Identifier__c);
                        //opps.add(o);
                    //} else {
                    //    o.addError(' Please contact the Salesforce administrator for the virtual team, if you need to create an Opportunity with this record type [WE_TargetManager]');
                    //}
                //} else {
                //    System.debug('Opportunity\'s Record Type is not listed in validEuNaRecordTypeIds');
                //}
            //}
            //System.debug('WE_TargetManager: opps size is ' + opps.size());
            //System.debug('WE_TargetManager: closeDateIdentifiers contains ' + closeDateIdentifiers);
            //System.debug('WE_TargetManager: createdDateIdentifiers contains ' + createdDateIdentifiers);
//
//            if (opps.isEmpty() == true) {
            //    System.debug('WE_TargetManager: No Opportunities with a valid Record Type Id were found');
            //} else {
            //    //create map of Target records with an identifier that matches the Opportunity's
                //for(Target__c t : [SELECT Identifier__c,Date_Type__c,Id
                //                     FROM Target__c
                                    //WHERE (Identifier__c in :closeDateIdentifiers AND Date_Type__c = 'Close Date') OR (Identifier__c in :createdDateIdentifiers AND Date_Type__c = 'Created Date')])
                //{
                //    targets.put(t.Identifier__c, t);
                    //System.debug('WE_TargetManager: targets contains ' + targets);
                //}
//
//                for(Opportunity o : opps) {
                //    // Targets will not be found if a matching record does not exist
                    //try {
                    //    closeDateTarget = targets.get(o.Close_Date_Identifier__c).Id;
                    //} catch(nullPointerException e) {
                    //    // no need to add error, as Opportunities without Targets will be picked up by Opportunities Without Close Date Targets report 00O70000004XI7L
                        //System.debug('WE_TargetManager: Close Date Target was not found for Opportunity with Id ' + o.Id);
                    //}
                    //try {
                    //    createdDateTarget = targets.get(o.Created_Date_Identifier__c).Id;
                    //} catch(nullPointerException e) {
                    //    // no need to add error, as Opportunities without Targets will be picked up by Opportunities Without Created Date Targets report
                        //System.debug('WE_TargetManager: Created Date Target was not found for Opportunity with Id ' + o.Id);
                    //}
//
//                    TargetxOpp__c closeDateJunc = new TargetxOpp__c();
                    //// fetch Id of Target record, based on Opportunity identifier
                    //closeDateJunc.Opportunity__c = o.Id;
                    //closeDateJunc.Target__c = closeDateTarget;
                    //newJuncRecs.add(closeDateJunc);
//
//                    TargetxOpp__c createdDateJunc = new TargetxOpp__c();
                    //createdDateJunc.Opportunity__c = o.Id;
                    //createdDateJunc.Target__c = createdDateTarget;
                    //newJuncRecs.add(createdDateJunc);
                //}
                //// Database Class Method (DML operation)
                //Database.SaveResult[] srList = Database.insert(newJuncRecs, false);
//
//                // Iterate through each returned result
                //for (Database.SaveResult sr : srList) {
                //    if (sr.isSuccess())  {
                    //    // Operation was successful, so get the ID of the record that was processed
                        //System.debug('WE_TargetManager: Successfully inserted TargetxOpp record. TargetxOpp ID: ' + sr.getId());
                    //} else {
                    //    // Operation failed, so get all errors
                        //for(Database.Error err : sr.getErrors()){
                        //    System.debug('WE_TargetManager: The following error has occurred.');
                            //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            //System.debug('TargetxOpp fields that affected this error: ' + err.getFields());
                        //}
                    //}
                //}
            //}
        //} else {
        //    System.debug('WE_TargetManager: targetManagerDisabled is true');
        //}
    //}
//
//    // updateTargets constructor
    //public WE_TargetManager(
    //Map<Id, Opportunity> oldTriggerOpps,
    //Map<Id, Opportunity> newTriggerOpps)
    //{
    //    oldOpps = oldTriggerOpps;
        //newOpps = newTriggerOpps;
    //}
//
//    public void updateTargets() {
    //    if (WE_ApexUtility.apxCntrlrTargetManagerStatusAssessed == false) {
        //    WE_ApexUtility.checkApexControllerStatus('Target Manager');
        //}
//
//        if (!WE_ApexUtility.targetManagerDisabled.contains(true)) {
        //    Map<Id,Id> userProfileIdbyUserId = new Map<Id,Id>();
            //Set<Id> userProfileIds = new Set<Id>();
            //Set<Id> userProfilesToAssess = new Set<Id>();
            //
            //for(Opportunity o : [SELECT Id,OwnerId,Owner.ProfileId FROM Opportunity WHERE Id IN :newOpps.keySet()])
            //{
            //    userProfileIdbyUserId.put(o.OwnerId,o.Owner.ProfileId);
                //if (!WE_ApexUtility.evaluatedRegionsProfiles.contains(o.Owner.ProfileId)) {
                //    userProfilesToAssess.add(o.Owner.ProfileId);
                //}
            //}
            //if (userProfilesToAssess.size() > 0) {
            //    WE_ApexUtility.checkValidProfile(userProfilesToAssess);
            //}
            //
            //if (WE_ApexUtility.validEuNaRecordTypeIds.isEmpty()) {
            //    // create Object from Class
                //WE_ApexUtility apxUtil = new WE_ApexUtility();
                //apxUtil.retrieveValidRecordTypes('EU NA Opps');
            //}
//
//            for(Opportunity o : newOpps.values()) {
            //    //check that Opportunity record type is valid
                //if (WE_ApexUtility.validEuNaRecordTypeIds.contains(o.RecordTypeId)) {
                //    Opportunity oldOpp = oldOpps.get(o.Id);
//
//                    //check whether Opportunity owner has changed
                    //if (oldOpp != null &&
                    //    oldOpp.OwnerId != null && // will only be null if Opp created from Lead conversion
                        //oldOpp.OwnerId != o.OwnerId)
                    //{
                    //    if (WE_ApexUtility.validEuNaSalesRmProfiles.contains(userProfileIdbyUserId.get(o.OwnerId)) == true) {
                        //    closeDateIdentifiers.add(o.Close_Date_Identifier__c);
                            //reassignedOpps.add(o);
                            //oppsNeedingTargets.add(o);
                        //} else {
                        //    o.addError(' Please contact the Salesforce administrator for the virtual team, if you need to edit this Opportunity [WE_TargetManager]');
                        //}
                    //}
                    ////check whether close date month or year has changed
                    //else if (oldOpp != null &&
                    //    (oldOpp.CloseDate.month() != o.CloseDate.month() ||
                        // oldOpp.CloseDate.year() != o.CloseDate.year() ))
                    //{
                    //    closeDateIdentifiers.add(o.Close_Date_Identifier__c);
                        //oppsWNewCD.add(o);
                        //oppsNeedingTargets.add(o);
                    //}
                //} else {
                //    System.debug('Opportunity\'s Record Type is not listed in validEuNaRecordTypeIds');
                //}
            //}
        //}
//
//        // no need to print debug lines if remainder of code won't be executed
        //if (oppsWNewCD.size() > 0) {
        //    // delete debug lines after testing
            //System.debug('WE_TargetManager: closeDateIdentifiers contains ' + closeDateIdentifiers);
            //System.debug('WE_TargetManager: reassignedOpps contains ' + reassignedOpps);
            //System.debug('WE_TargetManager: oppsWNewCD contains ' + oppsWNewCD);
        //}
        //if (reassignedOpps.isEmpty() == true) {
        //    System.debug('WE_TargetManager: no Opportunities had new owners');
        //}
        //if (oppsWNewCD.isEmpty() == true) {
        //    System.debug('WE_TargetManager: no Opportunities had a close date with a new month or year');
        //}
//
//        if (reassignedOpps.size() > 0 ||
        //    oppsWNewCD.size() > 0)
        //{
        //    for(Opportunity o : [SELECT Id, RecordTypeId,
            //                    (SELECT Id
                                //   FROM TargetxOpp__r
                                  //WHERE Target__r.Date_Type__c = 'Close Date')
                                  // FROM Opportunity
                                  //WHERE (Id IN :reassignedOpps OR Id IN :oppsWNewCD)])
            //{
            //    targetsToDel.addAll(o.TargetxOpp__r);
            //}
            //delete targetsToDel;
        //}
//
//        if (oppsNeedingTargets.size() > 0) {
        //    //populate map of target records with an identifier that matches the Opportunity's
            //for(Target__c t : [SELECT Identifier__c, Id
            //                     FROM Target__c
                                //WHERE Identifier__c in :closeDateIdentifiers])
            //{
            //    newTargets.put(t.Identifier__c, t.Id);
            //}
            //System.debug('WE_TargetManager: newTargets contains ' + newTargets);
//
//            for(Opportunity o: oppsNeedingTargets) {
            //    TargetxOpp__c txo = new TargetxOpp__c();
                //txo.Opportunity__c = o.Id;
                //txo.Target__c = newTargets.get(o.Close_Date_Identifier__c);
//
//                if (txo.Target__c != null) {
                //    targetsToCreate.add(txo);
                //} else {
                //    o.addError(' Please ask your Salesforce Administrator to add a target record, for the month & year of your Opportunity\'s close date [WE_TargetManager]');
                //}
            //}
//
//            // Database Class Method (DML operation)
            //Database.SaveResult[] srList = Database.insert(targetsToCreate, false);
//
//            // Iterate through each returned result
            //for(Database.SaveResult sr : srList) {
            //    if (sr.isSuccess()) {
                //    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('WE_TargetManager: Successfully inserted TargetxOpp record. TargetxOpp ID: ' + sr.getId());
                //} else {
                //    // Operation failed, so get all errors
                    //for(Database.Error err : sr.getErrors()) {
                    //    System.debug('WE_TargetManager: The following error has occurred.');
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('TargetxOpp fields that affected this error: ' + err.getFields());
                    //}
                //}
            //}
        //}
    //}
//
  }