trigger WE_AcctSubmitAppEntitlement on Account (after insert) {

    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Account_Automation__c) { return; }
    
    List<WEID__c> weids = WEID__c.getall().values();
    Set<Id> validRecordTypeIds = new Set<Id>();
    List<Entitlement> entitlements = new List<Entitlement>();
    List<Account> acctsToUp = new list<Account>();
    
    // add Account Record Type Ids from Custom Setting to list of valid Ids      
    for(WEID__c weid : weids) {
        try {
            validRecordTypeIds.add(weid.WEAccId__c);
        } 
        catch (system.StringException e) 
        {
            system.debug(System.LoggingLevel.ERROR,'Invalid Record Type Id ' + weid.WEAccId__c);
        }
    }
    
    List<BusinessHours> weBusHrs = [SELECT Id
                                      FROM BusinessHours
                                     WHERE Name = 'Wex Europe CS Working Hours'];

    // Use Name not NameNorm (unique to version) in case versions are activated
    List<SLAProcess> subAppEnt = [SELECT Id
                                    FROM SlaProcess
                                   WHERE Name = 'Applications' AND IsActive = TRUE];

    for(Account newAccount : Trigger.New){
        
        if (validRecordTypeIds.contains(newAccount.RecordTypeId))
        {
            Entitlement newEnt = new Entitlement();
            newEnt.Name = 'Submit Application';
            newEnt.AccountId = newAccount.Id;
            newEnt.StartDate = Date.Today();
            newEnt.EndDate = Date.Today().addYears(50);
            newEnt.BusinessHoursId = weBusHrs[0].Id;
            newEnt.SlaProcessId = subAppEnt[0].Id;
            
            entitlements.add(newEnt);
        }
    }
    insert entitlements;
    
    for(Entitlement e : entitlements){
        
        Account a = new Account(Id = e.AccountId);
        a.Application_Entitlement_ID__c = e.Id;
        
        acctsToUp.add(a);
    }
    update acctsToUp;         
}