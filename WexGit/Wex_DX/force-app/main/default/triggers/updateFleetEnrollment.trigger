trigger updateFleetEnrollment on Application_Request__c (after update) {

/*
    Fleet_Enrollment_Settings__c FES = Fleet_Enrollment_Settings__c.getOrgDefaults();
    
    if(FES.Enable_Siebel_Opportunity_Update__c == false) {
        return; 
    }
    
    for (Application_Request__c applicationRequest : Trigger.new){
		try{
	        
            System.debug('*** DEBUG Application ID: ' + applicationRequest.Id);
            
            // Only select any fleet enrollments that have the same ID as the app request, and the opportunity number is null
            List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Application_Request__c, Opportunity_Number__c FROM FleetEnrollment__c WHERE Application_Request__c = :applicationRequest.Id and Opportunity_Number__c = null];
            
            System.debug('*** DEBUG # of Fleet Enrollments: ' + fleetEnrollments.size());
            
            for(FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
                
                System.debug('*** DEBUG Updating Fleet Enrollment ' + fleetEnrollment.Id + ' with Opportunity # ' + applicationRequest.Siebel_Oppty__c + ' from Application Request ' + applicationRequest.Id);
                
                fleetEnrollment.Opportunity_Number__c = applicationRequest.Siebel_Oppty__c;
                
                update fleetEnrollment;
                
            }

        }
        catch (Exception ex){
         system.debug('ERROR: FleetEnrollment error is: ' + ex.getMessage());
        }
    }

 */
    
}