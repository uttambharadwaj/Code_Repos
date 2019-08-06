/*
Description:        Test class dispatcher. A one-stop shop for test execution.
Revision History:   
*/
@isTest
public class TestClassDispatcher {

    @testSetup
    static void setup(){
        //create all the things!
        UtilityTestLoader.loadTestData();
    }

    @isTest static void testOpportunityTriggerAfterInsert() {
        OpportunityTriggerTest.testFleetEnrollmentOpptyInfoOnInsert();
    }

    @isTest static void testOpportunityTriggerBeforeUpdate() {
        OpportunityTriggerTest.testFleetEnrollmentOpptyInfoOnUpdate();
    }

    @isTest static void testBOEntityTriggerBeforeInsert1() {
        BOEntityTriggerTest.testLegalStructureBeforeInsertFail();
    }

    @isTest static void testBOEntityTriggerBeforeInsert2() {
        BOEntityTriggerTest.testUpdateExemptionStatusBeforeInsert();
    }

    @isTest static void testBOEntityTriggerAfterInsert1() {
        BOEntityTriggerTest.testBOEOpptyInfoOnInsert();
    }

    @isTest static void testBOEntityTriggerBeforeUpdate1() {
        BOEntityTriggerTest.testUpdateExemptionStatusBeforeUpdate();
    }

    @isTest static void testBOEntityTriggerAfterUpdate1() {
        BOEntityTriggerTest.testCheckOpptyChangesAfterUpdate();
    }
    
    @isTest static void testBOEntityBusinessProcesses(){
        BOEntityTriggerTest.testBusinessProcesses();
    }
    
    @isTest static void testAppRequestTriggerInserts() {
        AppRequestTriggerTest.testInsert();
    }

    @isTest static void testAppRequestTriggerUpdates(){
        AppRequestTriggerTest.testUpdate();
    }
    
    @isTest static void testZuoraQuoteInserts(){
        ZQUQuoteTriggerTest.testZQUQuoteOnInsert();
    }
    
    @isTest static void testZuoraQuoteUpdates(){
        ZQUQuoteTriggerTest.testZQUQuoteOnUpdate();
    }

    @isTest static void testBOProngTriggerValidations(){
        BOProngTriggerTest.testValidateNumberOfRecords();
    }

}