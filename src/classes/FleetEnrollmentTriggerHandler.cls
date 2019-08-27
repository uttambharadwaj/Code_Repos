public class FleetEnrollmentTriggerHandler {

    public FleetEnrollmentTriggerHandler() {
        
    }
    
    public void tieToApplicationRequest(FleetEnrollment__c[] newFleetEnrollments) {
        
        for(FleetEnrollment__c fleetEnrollment : newFleetEnrollments) {
            
            if(fleetEnrollment.Application_Request__c == null) {
            	List<Application_Request__c> applicationRequests = [SELECT Id, Opportunity__c, Siebel_Oppty__c FROM Application_Request__c WHERE (Opportunity__c =: fleetEnrollment.Opportunity__c OR Opportunity__c =: fleetEnrollment.Debug_Opportunity_Parameter__c) AND CreatedDate = LAST_N_DAYS:90];
                
                if(!applicationRequests.isEmpty()) {
                    fleetEnrollment.Application_Request__c = applicationRequests[0].Id;
                    fleetEnrollment.Debug_Application_Parameter__c = applicationRequests[0].Id;
                    if(applicationRequests[0].Siebel_Oppty__c != null) {
                        fleetEnrollment.Opportunity_Number__c = applicationRequests[0].Siebel_Oppty__c;
                    }
                }
            }
            else if(String.isEmpty(fleetEnrollment.Opportunity_Number__c) && !String.isEmpty(fleetEnrollment.Application_Request__c)) { 
				List<Application_Request__c> applicationRequests = [SELECT Id, Siebel_Oppty__c FROM Application_Request__c WHERE Id =: fleetEnrollment.Application_Request__c and Siebel_Oppty__c != null];
                
                if(!applicationRequests.isEmpty()) {
                	fleetEnrollment.Opportunity_Number__c = applicationRequests[0].Siebel_Oppty__c;
                }
            }
            
        }
        
    }
    
    // Sorta misleading.. The case doesn't get created until the application is in
    // stage 6.. so we're really telling the Application Request what the enrollment
    // is and then doing a formula from the case.. 
    public void tieToFleetImplementationCase(FleetEnrollment__c[] newFleetEnrollments) {
        
        for(FleetEnrollment__c fleetEnrollment : newFleetEnrollments) {
            
            List<Application_Request__c> appRequests = [SELECT Id, Fleet_Enrollment__c FROM Application_Request__c WHERE Id =: fleetEnrollment.Application_Request__c LIMIT 1];
            
            if(appRequests.size() > 0) {
                appRequests[0].Fleet_Enrollment__c = fleetEnrollment.Id;
            }
            
            upsert appRequests;
            
        }
        
    }
    
}