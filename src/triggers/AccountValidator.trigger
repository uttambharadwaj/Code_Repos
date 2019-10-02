trigger AccountValidator on Account (before insert, before update) {

    Set<Id> AU_Acc_RTs = new Set<Id>();
    
    //for(RecordType rt : [select Id from RecordType where sObjectType = 'Account' and DeveloperName IN ('AU_Fuel_Customer', 'EMAP_Fuel_Accounts')]){
        Schema.RecordTypeInfo AUAccRecType = EMAP_Account_TriggerHandler.getRecordTypeInfo('Account', 'AU Fuel/Trade Customer');
        Schema.RecordTypeInfo EMAPAccRecType = EMAP_Account_TriggerHandler.getRecordTypeInfo('Account', 'EMAP Fuel Accounts');
        
        AU_Acc_RTs.add(AUAccRecType.getRecordTypeId());
        AU_Acc_RTs.add(EMAPAccRecType.getRecordTypeId());
        
        //AU_Acc_RTs.add(rt.id);
    //}
        
    List<Account> acts = new List<Account>();
    for(Account a : Trigger.new)
    {
        if(!AU_Acc_RTs.contains(a.RecordTypeId))
            acts.add(a);
    }
    
    if(!acts.isEmpty())
        AccountUtility.removeCarriageReturnsFromAccount(acts);
    
}