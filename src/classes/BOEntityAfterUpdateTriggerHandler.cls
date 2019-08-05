public class BOEntityAfterUpdateTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        checkOpptyChanges((List<Beneficial_Owner_Entity__c>) tp.newList, (Map<Id,Beneficial_Owner_Entity__c>) tp.oldMap); //check to see if oppty has changed
    }

    public static void checkOpptyChanges(List<Beneficial_Owner_Entity__c> boList, Map<Id, Beneficial_Owner_Entity__c> boOldMap){
        List<Beneficial_Owner_Entity__c> opptyChanged = new List<Beneficial_Owner_Entity__c>();
        for(Beneficial_Owner_Entity__c boe : boList) {
            if(boe.Opportunity__c != boOldMap.get(boe.Id).Opportunity__c)
                opptyChanged.add(boe); 
        }
        BOEntityHelper.updateOpportunity(opptyChanged);
    }

}