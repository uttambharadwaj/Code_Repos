// TODO - This can be decommissioned along with TMTDDispatchUpdates
trigger WeFormObjectMain on WeFormObject__c (after insert, after update)
{
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
		// Disabling this because we're moving to the credit decision engine
		if(Test.isRunningTest()) {
			TMTDDispatchUpdates.mainEntry(Trigger.oldMap, Trigger.new);
		}
}