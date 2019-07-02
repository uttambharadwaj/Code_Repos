public class BOEntityTriggerHandler {
    /*
    public static boolean alreadyRunning = false;

    public static void updateExemptionStatus(Beneficial_Owner_Entity__c boEntity) {
        
        if(!(boEntity.Verification_Status__c).equalsIgnoreCase('Passed') && !(boEntity.Verification_Status__c).equalsIgnoreCase('Failed') &&
           boEntity.Legal_Structure__c != null && boEntity.Country_Code__c != null) {
               
               Boolean isExempt = false;
               
               for(Beneficial_Owner_Exemption__mdt exemption : [SELECT Legal_Structure__c FROM Beneficial_Owner_Exemption__mdt WHERE Country_Code__c =: boEntity.Country_Code__c]) {
                   
                   if((boEntity.Legal_Structure__c).equalsIgnoreCase(exemption.Legal_Structure__c)) {
                       isExempt = true;
                   }
                   
               }
               
               if(isExempt) {
                   boEntity.Verification_Status__c = 'Exempted';
                   
                   if(boEntity.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId()) {
                       if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked') != null) {
                           boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked').getRecordTypeId();
                       }
                   }
                   
                   if(boEntity.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId()) {
                       if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked') != null) {
                           boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked').getRecordTypeId();
                       }
                   }
                   
                   if(boEntity.RecordTypeId == Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring').getRecordTypeId()) {
                       if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked') != null) {
                           boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked').getRecordTypeId();
                       }
                   }
               }
               
           }
        
    }
    
    public static void mapLegalStructure(Beneficial_Owner_Entity__c boEntity) {
        
        if(boEntity.Opportunity__c != null) {
            
            List<Opportunity> opportunities = [SELECT Id, Legal_Structure__c FROM Opportunity WHERE Id =: boEntity.Opportunity__c];
            
            if(opportunities.size() > 0 && opportunities[0].Legal_Structure__c != null) {
                
                boEntity.Legal_Structure__c = opportunities[0].Legal_Structure__c;
                
            }
            else {
                
                boEntity.addError('Please ensure you have selected a Legal Structure on the Opportunity, then try again!');
                
            }
            
        }
        
    }
    
    public static void mapLanguagePreference(Beneficial_Owner_Entity__c boEntity) {
        
        List<Account> accounts = [SELECT Id, Preferred_Language__c FROM Account WHERE Id =: boEntity.Account__c];
        
        if(accounts.size() > 0 && accounts[0].Preferred_Language__c  != null) {
            boEntity.Language_Preference__c = accounts[0].Preferred_Language__c;
        }
        else {
            boEntity.Language_Preference__c = 'English';
        }
        
    }
    
    public static void archiveSiblings(Beneficial_Owner_Entity__c boEntity) {
        
        alreadyRunning = true;
        
        if(boEntity.Opportunity__c != null) {
        
            for(Beneficial_Owner_Entity__c boEntitySibling : [SELECT Id, Record_Status__c FROM Beneficial_Owner_Entity__c WHERE Opportunity__c =: boEntity.Opportunity__c and Id != null and Id !=: boEntity.Id and Record_Status__c = 'Active']) {
            
                boEntitySibling.Record_Status__c = 'Archived';
            
                update boEntitySibling;
            
            }
            
        }
        
    }

    @future
    public static void updateOpportunity(Id boEntityId) {
        
        System.debug('### updateOpportunity: ' + boEntityId);

        List<Beneficial_Owner_Entity__c> beneficialOwnerEntities = [SELECT Id, Opportunity__c FROM Beneficial_Owner_Entity__c WHERE Id =: boEntityId and Record_Status__c = 'Active'];

        if(beneficialOwnerEntities.size() > 0) {

            List<Opportunity> opportunities = [SELECT Id, Beneficial_Owner_Entity__c FROM Opportunity WHERE Id =: beneficialOwnerEntities[0].Opportunity__c LIMIT 1];
            
            System.debug('### Opportunities: ' + opportunities);
            
            if(opportunities.size() > 0) {
                
                Opportunity opportunity = opportunities[0].clone(true);
                
                opportunity.Beneficial_Owner_Entity__c = boEntityId;
                
                upsert opportunity;
                
            }
            
        }
        
        
        
    }
*/
}