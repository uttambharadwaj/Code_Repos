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

    @isTest static void testDataLoaderBatch() {
        DataLoaderBatchTest.testDataLoaderBatch();
    }

}