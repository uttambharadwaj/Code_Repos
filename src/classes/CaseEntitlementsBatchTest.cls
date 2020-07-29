@isTest 
private class CaseEntitlementsBatchTest {

    @TestSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

	@isTest
	private static void testBatch() {
		Account auxAccount = new Account();
        auxAccount.Name = 'Test';
		auxAccount.Type = 'Partner';
        insert auxAccount;

        Entitlement auxEntitlementWeek = new Entitlement();
        auxEntitlementWeek.Name = 'Shell SLA';
        auxEntitlementWeek.AccountId = auxAccount.ID;
        insert auxEntitlementWeek;

        Entitlement auxEntitlementWeekEnd = new Entitlement();
        auxEntitlementWeekEnd.Name = 'Shell SLA Weekend';
        auxEntitlementWeekEnd.AccountId = auxAccount.ID;
        insert auxEntitlementWeekEnd;

        Case auxCase = new Case();
        //auxCase.SuppliedEmail = 'test@shell.com';
        auxCase.Program_Email__c = 'Shellfleethelp@wexinc.com';
        insert auxCase;

        // Test.setCreatedDate(auxCase.Id, weekendDay);
        // This ^ method does not work because the Entitlement is evaluated on Insert
        // And this would run afterwards.

        Test.startTest();
        CaseEntitlementsBatch batchAux = new CaseEntitlementsBatch();
        Database.executeBatch(batchAux);
        Test.stopTest();

        // Test that the case has EntitlementID of week Shell SLA.
        Case updatedCase = [SELECT ID, EntitlementID FROM Case WHERE ID = :auxCase.ID];
        System.assertEquals(auxEntitlementWeek.ID, updatedCase.EntitlementId);
	}

	@IsTest
	private static void testSchedule(){
        Account auxAccount = new Account();
        auxAccount.Name = 'Test';
		auxAccount.Type = 'Partner';
        insert auxAccount;

        Entitlement auxEntitlementWeek = new Entitlement();
        auxEntitlementWeek.Name = 'Shell SLA';
        auxEntitlementWeek.AccountId = auxAccount.ID;
        insert auxEntitlementWeek;

        Entitlement auxEntitlementWeekEnd = new Entitlement();
        auxEntitlementWeekEnd.Name = 'Shell SLA Weekend';
        auxEntitlementWeekEnd.AccountId = auxAccount.ID;
        insert auxEntitlementWeekEnd;
        
		Test.startTest();
		CaseEntitlementsSchedulable.scheduleIt();
		Test.stopTest();
	}

}