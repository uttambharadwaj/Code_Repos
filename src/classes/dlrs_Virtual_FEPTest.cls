/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Virtual_FEPTest
{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Virtual_FEPTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Virtual_FEP__c());
    }
}