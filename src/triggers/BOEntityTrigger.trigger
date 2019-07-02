trigger BOEntityTrigger on Beneficial_Owner_Entity__c (before insert, before update, after insert, after update) {
    Automation_Settings__c autoSettings = Automation_Settings__c.getOrgDefaults();
    if(autoSettings != null && autoSettings.Disable_Apex_Triggers__c) return;

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

        if(Trigger.isInsert) {

            for(Beneficial_Owner_Entity__c boEntity : Trigger.new) {

                // Map Legal Structure from Opportunity__c
                BOEntityTriggerHandler.mapLegalStructure(boEntity);

                // Map the language preference from the Account__c
                BOEntityTriggerHandler.mapLanguagePreference(boEntity);

                // Update the exemption status based on Legal Structure
                BOEntityTriggerHandler.updateExemptionStatus(boEntity);

            }

        }
        else if(Trigger.isUpdate) {

            for(Beneficial_Owner_Entity__c boEntity : Trigger.new) {

                // Update the exemption status based on Legal Structure
                BOEntityTriggerHandler.updateExemptionStatus(boEntity);

            }

        }

    }

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {

        for(Beneficial_Owner_Entity__c boEntity : Trigger.new) {

            // Update the opportunity with the active record
            if(Trigger.isInsert) {
                BOEntityTriggerHandler.updateOpportunity(boEntity.Id);
            }
            else if(Trigger.isUpdate) {
                Beneficial_Owner_Entity__c boEntityOld = Trigger.oldMap.get(boEntity.Id);

                if(boEntityOld != null && boEntity.Opportunity__c != boEntityOld.Opportunity__c) {
                    BOEntityTriggerHandler.updateOpportunity(boEntity.Id);
                }
            }

            if(BOEntityTriggerHandler.alreadyRunning == false) {

                // Set any siblings with the same Opportunity__c to 'Archived'
                BOEntityTriggerHandler.archiveSiblings(boEntity);

            }

        }

    }

}