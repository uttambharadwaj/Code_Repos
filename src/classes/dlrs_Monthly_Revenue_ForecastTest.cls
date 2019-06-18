/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Monthly_Revenue_ForecastTest
{
    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Monthly_Revenue_ForecastTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Monthly_Revenue_Forecast__c());
    }
}