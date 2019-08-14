// Utilities related to Beneficial Owner that are run
// via button on a Beneficial Owner Entity Button
global class BeneficialOwnerUtilities {
    
    public Id passedBeneficialEntityId { get; set; }
    
    public BeneficialOwnerUtilities(ApexPages.StandardController controller) {
        passedBeneficialEntityId = controller.getRecord().id;
    }
    
    public PageReference runBeneficialOwnerCloneVF() {

        Id newEntityId = deepCloneBORecord(passedBeneficialEntityId);
        
        if(newEntityId != null) {
            
            PageReference redirect = new PageReference('/' + newEntityId);
            
            return redirect;
            
        }
        else {
        
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Unable to clone record. Please try again.')); 
            
        }
        
		return null;
        
    }
    
    // Deep clones the BO Entity/BO child records into a new record set
    webservice static Id deepCloneBORecord(ID boEntityID) {
        
        List<Beneficial_Owner_Entity__c> boEntities = [SELECT Id, RecordTypeId, RecordType.Name, Account__c, Account_Number__c, Application_Request__c, Contract_Number__c, Country_Code__c, 
                                                     Factoring_Underwriting__c, Language_Preference__c, Legal_Structure__c, Online_Application__c, Opportunity__c, Opportunity_Number__c,
                                                     Physical_Address_Line_1__c, Physical_Address_Line_2__c, Physical_City__c, Physical_Country__c, Physical_Postal_Code__c, Physical_State__c,
                                                     Merchant_Name__c, Merchant_Site_Supply_ID__c, Correspondence_Contact__c, No_Beneficial_Owners__c FROM Beneficial_Owner_Entity__c WHERE Id =: boEntityID];
        
        if(boEntities.size() > 0) {
            
            Beneficial_Owner_Entity__c boEntity = boEntities[0];
            
            Beneficial_Owner_Entity__c newBOEntity = boEntity.clone(false);
            newBOEntity.Cloned_From_ID__c = boEntity.Id;
            newBOEntity.Record_Status__c = 'Active';
            newBOEntity.Verification_Status__c = 'Pending Lexis/Nexis';
            
            if(boEntity.RecordType != null && (boEntity.RecordType.Name).equalsIgnoreCase('Fuel Card - Locked')) {
                if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card') != null) {
					newBOEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card').getRecordTypeId();
               	}
            }
            else if(boEntity.RecordType != null && (boEntity.RecordType.Name).equalsIgnoreCase('Fleet Card - Locked')) {
                if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card') != null) {
					newBOEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card').getRecordTypeId();
               	}
            }
            else if(boEntity.RecordType != null && (boEntity.RecordType.Name).equalsIgnoreCase('Factoring - Locked')) {
                if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring') != null) {
					newBOEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring').getRecordTypeId();
               	}
            }
            else {
            	newBOEntity.RecordTypeId = boEntity.RecordTypeId;    
            }

            insert newBOEntity;

            boEntity.Record_Status__c = 'Archived';
            
            upsert boEntity;

            return newBOEntity.Id;
            
        }
        
        return null;
        
    }

    webservice static Boolean cloneProngsToNew(Id oldBOEntityId, Id newBOEntityId) {

        List<Beneficial_Owner_Prong__c> boProngs = [SELECT Id, RecordTypeId, RecordType.Name, Beneficial_Owner_Entity__c, First_Name__c, Last_Name__c, Address_Line_1__c, Address_Line_2__c, City__c,
        State__c, Postal_Code__c, Country__c, Title__c FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: oldBOEntityId];

        List<Beneficial_Owner_Prong__c> newBOProngs = new List<Beneficial_Owner_Prong__c>();

        if(boProngs.size() > 0) {

            for(Beneficial_Owner_Prong__c oldBOProng : boProngs) {

                Beneficial_Owner_Prong__c newBOProng = oldBOProng.clone(false);

                // Saved will allow us to access the record in a re-injection scenario
                newBOProng.Verification_Status__c = 'Saved';
                newBOProng.Beneficial_Owner_Entity__c = newBOEntityId;

                // Clear out the locked record types
                if (oldBOProng.RecordTypeId != null && ((oldBOProng.RecordType.Name).equalsIgnoreCase('Control Person') || (oldBOProng.RecordType.Name).equalsIgnoreCase('Control Person - Locked'))) {
                    if (Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person') != null) {
                        newBOProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person').getRecordTypeId();
                    }
                } else if (oldBOProng.RecordTypeId != null && ((oldBOProng.RecordType.Name).equalsIgnoreCase('Beneficial Owner') || (oldBOProng.RecordType.Name).equalsIgnoreCase('Beneficial Owner - Locked'))) {
                    if (Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner') != null) {
                        newBOProng.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner').getRecordTypeId();
                    }
                }

                newBOProngs.add(newBOProng);

            }

            upsert newBOProngs;

        }

        return true;

    }

}