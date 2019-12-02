/**
* Forseva online application code.
*/
trigger OnlineApplicationUpsert on OnlineApplication__c (before insert, before update, after update) {

    for(OnlineApplication__c oa : Trigger.new) {

        if(Trigger.isBefore) {

            // must have offer when creating application
            if(Trigger.isInsert) {
                if(oa.Offer__c == null) {
                    oa.addError(Label.OfferFieldValidation);
                }
            }
            // cannot change offer for existing application
            else {
                OnlineApplication__c old = Trigger.oldMap.get(oa.Id);
                if(oa.Offer__c != old.Offer__c) {
                    oa.addError(Label.OfferFieldValidation);
                }
            }

        }

        if(Trigger.isAfter && Trigger.isUpdate) {

            OnlineApplication__c old = Trigger.oldMap.get(oa.Id);

            // if Application Stage has just changed to Adjudication
            if(!(old.Application_Stage__c).equalsIgnoreCase('Adjudication') && (oa.Application_Stage__c).equalsIgnoreCase('Adjudication')
                    && (oa.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineOTR.decisionEngineRunning == false && oa.Opportunity__r.Disable_Instant_Decisioning__c == false) {

                CreditDecisionEngineOTR.runOTRDecisioningProcessFuture(oa.Id);

            }

            // if Compliance of Fraud had to make a decision on the application, then decisioing needs to be re-run
            if(((old.Compliance_Decision__c != null && !(old.Compliance_Decision__c).equalsIgnoreCase(oa.Compliance_Decision__c)) || (old.Fraud_Decision__c != null && !(old.Fraud_Decision__c).equalsIgnoreCase(oa.Fraud_Decision__c)))
                    && (oa.Application_Stage__c).equalsIgnoreCase('Adjudication')
                    && (oa.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineOTR.decisionEngineRunning == false && oa.Opportunity__r.Disable_Instant_Decisioning__c == false) {

                CreditDecisionEngineOTR.runOTRDecisioningProcessFuture(oa.Id);
            }

            if(AccountWS_EFSAppManager.integrationRunning != true) {
                if((oa.Application_Stage__c).equalsIgnoreCase('Implementation')
                        && (oa.Status__c).equalsIgnoreCase('Pending Setup') && oa.Sent_To_Application_Manager__c == false && oa.Send_To_App_Manager__c == true) {

                    AccountWS_EFSAppManager.integrationRunning = true;

                    AccountWS_EFSAppManager.integrateOnlineApplication_Future(oa.Id);

                }
            }

        }

    }
}

// EOF