public class BOEntityHelper {
    //after insert, after update
    public static void updateOpportunity(List<Beneficial_Owner_Entity__c> boList){
        Set<Id> boids = new Set<Id>(); //let's go birdwatching in NYC...check out the 'boids'!
        for(Beneficial_Owner_Entity__c boe : boList) {
            if(boe.Record_Status__c == 'Active')
                boids.add(boe.Id);
        }
        if(boids.size()>0)
            updateOpportunities(boids);
    }
    
    public static void updateOpportunities(Set<Id> boids) {

        List<Opportunity> opptyList = new List<Opportunity>();
        Map<Id,Id> opptyMap = new Map<Id,Id>();
        for(Beneficial_Owner_Entity__c boe : [SELECT Id, Opportunity__c FROM Beneficial_Owner_Entity__c WHERE Id IN :boids])
            opptyMap.put(boe.Opportunity__c, boe.Id);

        for(Opportunity o : [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Id IN :opptyMap.keySet()]){
            o.Beneficial_Owner_Entity__c = opptyMap.get(o.Id);
            opptyList.add(o);
        }

        upsert opptyList; 
    }
    //before insert, before update
    public static void updateExemptionStatus(List<Beneficial_Owner_Entity__c> boList){
        Map<String,Set<String>> countryCodes = new Map<String,Set<String>>();
        for(Beneficial_Owner_Entity__c boe : boList){
            if(!(boe.Verification_Status__c).equalsIgnoreCase('Passed') && !(boe.Verification_Status__c).equalsIgnoreCase('Failed') &&
                boe.Legal_Structure__c != null && boe.Country_Code__c != null)
                countryCodes.put(boe.Country_Code__c, new Set<String>());
        }
        for(Beneficial_Owner_Exemption__mdt exemption : [SELECT Country_Code__c, Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c IN :countryCodes.keySet()]) {
            Set<String> legalSet = countryCodes.get(exemption.Country_Code__c);
            legalSet.add(exemption.Legal_Structure__c);
            countryCodes.put(exemption.Country_Code__c, legalSet);
        }

        for(Beneficial_Owner_Entity__c boe : boList){
            if(!(boe.Verification_Status__c).equalsIgnoreCase('Passed') && !(boe.Verification_Status__c).equalsIgnoreCase('Failed') &&
               boe.Legal_Structure__c != null && boe.Country_Code__c != null) {
                if(countryCodes.get(boe.Country_Code__c).contains(boe.Legal_Structure__c)) {
                    boe.Verification_Status__c = 'Exempted';
                    if(boe.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId()){
                        if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked') != null)
                            boe.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked').getRecordTypeId();
                    }
                    else if(boe.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId()){
                        if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked') != null)
                            boe.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked').getRecordTypeId();
                    }
                    else if(boe.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring').getRecordTypeId()){
                        if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked') != null)
                            boe.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked').getRecordTypeId();
                    }
                }
            }
        }
    }

}