trigger FleetEnrollmentTrigger on FleetEnrollment__c (before insert, after insert) {

    /*
    Fleet_Enrollment_Settings__c FES = Fleet_Enrollment_Settings__c.getOrgDefaults();
    
    if(FES.Enable_Siebel_Opportunity_Update__c == false) {
        return; 
    }
    
    FleetEnrollmentTriggerHandler handler = new FleetEnrollmentTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore) {
        try {
			handler.tieToApplicationRequest(trigger.New);
        }
        catch(Exception e) {
            System.debug('Can\'t tie to application request..');
        }
    }
    else if(Trigger.isInsert && Trigger.isAfter) {
        try {
			handler.tieToFleetImplementationCase(trigger.New);
        }
        catch(Exception e) {
            System.debug('Can\'t tie to implementation case..');
        }
    }

     */
}