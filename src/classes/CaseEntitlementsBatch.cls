global class CaseEntitlementsBatch implements Database.Batchable<SObject> {

	global CaseEntitlementsBatch() {
		
	}
	
	/**
	 * @description gets invoked when the batch job starts
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		Entitlement auxEntitlementsList = [SELECT Name, Id
                                            FROM Entitlement WHERE Name = 'Shell SLA Weekend'];
        ID weekendEntitlementID = auxEntitlementsList.ID;
		return Database.getQueryLocator('SELECT Id FROM Case WHERE EntitlementID = :weekendEntitlementID');
	}
    /*global List<Case> start(Database.BatchableContext context) {
        Entitlement auxEntitlementsList = [SELECT Name, Id
                                            FROM Entitlement WHERE Name = 'Shell SLA Weekend'];
        ID weekendEntitlementID = auxEntitlementsList.ID;
        return [SELECT Id FROM Case WHERE EntitlementID = :weekendEntitlementID];
    }*/

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Case> scope) {
        Entitlement auxEntitlement = [SELECT Name, Id
                                            FROM Entitlement WHERE Name = 'Shell SLA'];
		List<Case> casesToUpdate = new List<Case>();
		for(Case auxCase : scope){
			auxCase.EntitlementID = auxEntitlement.ID;
			casesToUpdate.add(auxCase);
		}
		update casesToUpdate;
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
		
	}
}