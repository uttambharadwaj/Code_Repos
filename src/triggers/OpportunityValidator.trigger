trigger OpportunityValidator on Opportunity (before insert, before update) {
/*
    Set<String> recordTypeNames = new Set<String>{'AU Fuel Direct','AU Fuel Merchant'};
    Map<String, Schema.RecordTypeInfo> rts = new Map<String, Schema.RecordTypeInfo>();
    rts = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
    Set<Id> AU_Opp_RTs = new Set<Id>();
    List<Opportunity> optys = new List<Opportunity>();
    
    for(String rtn : recordTypeNames) {
        if(rts != null && rts.get(rtn) != null) {
        	AU_Opp_RTs.add(rts.get(rtn).getRecordTypeId());
        }
    }
    for(Opportunity opp : Trigger.new) {
        if(!AU_Opp_RTs.contains(opp.RecordTypeId))
            optys.add(opp);
    }
    if(!optys.isEmpty())
        OpportunityUtility.removeCarriageReturnsFromOpty(optys);
    */
}