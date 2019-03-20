public class FleetEnrollmentTriggerHandler {

    public FleetEnrollmentTriggerHandler() {
        
    }
    
    public void tieToApplicationRequest(FleetEnrollment__c[] newFleetEnrollments) {
        
        for(FleetEnrollment__c fleetEnrollment : newFleetEnrollments) {
            
            if(!String.isEmpty(fleetEnrollment.Opportunity_Number__c)) {
            	List<Application_Request__c> applicationRequests = [SELECT Id FROM Application_Request__c WHERE Siebel_Oppty__c =: fleetEnrollment.Opportunity_Number__c and CreatedDate = LAST_N_DAYS:90];
                
                if(!applicationRequests.isEmpty()) {
                    fleetEnrollment.Application_Request__c = applicationRequests[0].Id;
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