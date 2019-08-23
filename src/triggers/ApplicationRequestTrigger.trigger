trigger ApplicationRequestTrigger on Application_Request__c (before insert, before update, after insert, after update) {
    
    List<Application_Request__c> records = trigger.isDelete ? trigger.old : trigger.new;

    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            UApplicationRequest.communityUserStampData(records);
            Map<Id, Id> arToOpptyMap = new Map<Id, Id>();

            for(Application_Request__c ar : records) {
                arToOpptyMap.put(ar.Opportunity__c, ar.Id);
            }

            List<FleetEnrollment__c> fleetEnrollments = [
                    SELECT id, Opportunity__c, Opportunity_Number__c, Application_Request__c
                    FROM FleetEnrollment__c
                    WHERE Opportunity__c IN : arToOpptyMap.keySet()
                    LIMIT 1
            ];

            for(Application_Request__c applicationRequest : records) {
                if (applicationRequest.Sales_Person__c == null) {
                    applicationRequest.Sales_Person__c = UserInfo.getUserId();
                }
                if (applicationRequest.Fleet_Enrollment__c == null && fleetEnrollments.size() > 0) {
                    applicationRequest.Fleet_Enrollment__c = fleetEnrollments[0].Id;
                }
            }
        }

        if(trigger.isUpdate) {

            Map<Id, Id> arToOpptyMap = new Map<Id, Id>();

            for(Application_Request__c ar : records) {
                arToOpptyMap.put(ar.Opportunity__c, ar.Id);
            }

            List<FleetEnrollment__c> fleetEnrollments = [
                    SELECT id, Opportunity__c, Opportunity_Number__c, Application_Request__c
                    FROM FleetEnrollment__c
                    WHERE Opportunity__c IN : arToOpptyMap.keySet()
                    LIMIT 1
            ];

            for(Application_Request__c applicationRequest : records) {
                if (fleetEnrollments.size() > 0 && applicationRequest.Fleet_Enrollment__c != null && fleetEnrollments[0].Opportunity_Number__c == null && applicationRequest.Siebel_Oppty__c != null) {
                    fleetEnrollments[0].Opportunity_Number__c = applicationRequest.Siebel_Oppty__c;
                }
                if (fleetEnrollments.size() > 0 && fleetEnrollments[0].Application_Request__c == null) {
                    fleetEnrollments[0].Application_Request__c = applicationRequest.Id;
                }
                if (fleetEnrollments.size() > 0 && fleetEnrollments[0].Debug_Application_Parameter__c == null) {
                    fleetEnrollments[0].Debug_Application_Parameter__c = applicationRequest.Id;
                }
            }
            upsert fleetEnrollments[0];
        }
    }
    else if(trigger.isAfter)
    {
        
        if(trigger.isInsert) {
            //ApplicationRequestWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
            
            for(Application_Request__c applicationRequest : records) {
                if (System.IsBatch() == false && System.isFuture() == false && applicationRequest.Forward_Application_to_Credit__c != null && (applicationRequest.Forward_Application_to_Credit__c).equals('Yes')) {
                    CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
                }
            }
        }
        else if(trigger.isUpdate) {
            //ApplicationRequestWeightedRoundRobin.executeRoundRobin(records, trigger.oldMap);
            
            for(Application_Request__c applicationRequest : records) {
                Application_Request__c old = Trigger.oldMap.get(applicationRequest.Id);
                
                if (System.IsBatch() == false && System.isFuture() == false && (old.Forward_Application_to_Credit__c == null || !(old.Forward_Application_to_Credit__c).equalsIgnoreCase('Yes')) && applicationRequest.Forward_Application_to_Credit__c != null && (applicationRequest.Forward_Application_to_Credit__c).equals('Yes')) {
                    CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
                }
                
                // if Compliance of Fraud had to make a decision on the application, then decisioing needs to be re-run
                if(System.IsBatch() == false && System.isFuture() == false && ((old.Compliance_Decision__c != null && !(old.Compliance_Decision__c).equalsIgnoreCase(applicationRequest.Compliance_Decision__c)) || (old.Fraud_Decision__c != null && !(old.Fraud_Decision__c).equalsIgnoreCase(applicationRequest.Fraud_Decision__c)))
                   && (applicationRequest.Application_Stage__c).equalsIgnoreCase('Adjudication')
                   && (applicationRequest.Status__c).equalsIgnoreCase('Pending Decision') && CreditDecisionEngineNA.decisionEngineRunning == false) {
                       
                       CreditDecisionEngineNA.runNADecisioningProcessFuture(applicationRequest.Id);
                   }
            }
        }
    }
    
}