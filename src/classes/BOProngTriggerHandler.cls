public class BOProngTriggerHandler {
    
    public static void validateNumberOfRecords(Beneficial_Owner_Prong__c boProng) {
        
        if(boProng.RecordTypeId != null && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person') != null &&
           boProng.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId()) {
               List<Beneficial_Owner_Prong__c> boControlPersons = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE RecordType.Name = 'Control Person' and Beneficial_Owner_Entity__c =: boProng.Beneficial_Owner_Entity__c];
               if(boControlPersons.size() > 0) {
                   boProng.addError('Only one Control Person record is allowed.');
               }
           }
        else if(boProng.RecordTypeId != null && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner') != null &&
                boProng.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId()) {
                    List<Beneficial_Owner_Prong__c> boOwners = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE RecordType.Name = 'Beneficial Owner' and Beneficial_Owner_Entity__c =: boProng.Beneficial_Owner_Entity__c];
                    if(boOwners.size() >= 4) {
                        boProng.addError('Only four Beneficial Owner records are allowed.');
                    }
                }
        
    }
    
}