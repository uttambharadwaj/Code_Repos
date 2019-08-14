/*
* Test Setup Framework Data Loader Test Class
* Author: Jason Arbegast
* Initial Date: 5/15/2019
* Description:  tests all the hard work of loading data for test setups and post-sandbox refreshes
*                this class is exempt from the test class dispatcher framework as it will likely encounter a duplicate setupownerid error if the object inserted is a custom setting
* Revision History: 
*/

@isTest
public class DataLoaderBatchTest {

    /*
    * description: tests DataLoaderBatch class, which is called for test setups
    *       also tests preexecute method in UtilityTestLoader, which will normally be called in a setup method
    */
    @isTest static void testDataLoaderBatch() {

        UtilityTestLoader.preExecute();
        Automation_Settings__c autoSettings = Automation_Settings__c.getOrgDefaults();
        system.assertNotEquals(null, autoSettings);

        // Get the first object in the load list
        Test_Data_Configuration__mdt tdc = [SELECT Object__c, Required_Fields_Only__c, Static_Resource__c, Order__c
                                            FROM Test_Data_Configuration__mdt
                                            ORDER BY Order__c ASC LIMIT 1];
        Integer beforeCount = (Integer)Database.query('SELECT COUNT(Id) FROM ' + tdc.Object__c)[0].get('expr0');
        
        Test.startTest();
            Database.executeBatch(new DataLoaderBatch());
        Test.stopTest();
        
        // Assert the first object count went up
        Integer afterCount = (Integer)Database.query('SELECT COUNT(Id) FROM ' + tdc.Object__c)[0].get('expr0');
        System.assert(beforeCount < afterCount, 'DataLoaderBatch did not insert anything. Before count = ' + beforeCount + ' : After count = ' + afterCount);
    }
    
    /*
    * description: tests DataLoaderBatch methods individually, purely for coverage
    *   nothing to assert on these as they are all private variables
    */
    @isTest static void testDataLoaderBatch_Coverage() {
        // Get the first object in the load list
        Test_Data_Configuration__mdt tdc = [SELECT Object__c, Required_Fields_Only__c, Static_Resource__c, Order__c
                                        FROM Test_Data_Configuration__mdt
                                        ORDER BY Order__c ASC LIMIT 1];
    
        Test.startTest();
            DataLoaderBatch dlb = new DataLoaderBatch();
            DataLoaderBatch dlb2 = new DataLoaderBatch(tdc.Order__c.intValue(), null);
        Test.stopTest();

        //no assertions. coverage only. private variables cannot be accessed.
        
    }

}