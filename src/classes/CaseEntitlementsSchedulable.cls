global class CaseEntitlementsSchedulable implements Schedulable {
	
	public static String CRON_EXP = '0 59 7 ? * MON *';
	
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
		CaseEntitlementsBatch batchAux = new CaseEntitlementsBatch();
        Database.executeBatch(batchAux);
	}

	public static void scheduleIt(){
		CaseEntitlementsSchedulable auxSchedulable = new CaseEntitlementsSchedulable();
		String jobID = System.schedule('Case Entitlements Update', CRON_EXP, auxSchedulable);
	}

}