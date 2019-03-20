/**
 * Created by dgilbert on 9/13/2018.
 */

@isTest
public with sharing class WEXBreezeLoggingTest {

    static testMethod void testBreezeDebugLogging() {

        Test.startTest();

        WEXBreezeDebugLogging.debug wexBreezeDebugLogging = new WEXBreezeDebugLogging.debug();
        wexBreezeDebugLogging.info('Test Error');

        Test.stopTest();

    }

    static testMethod void testBreezeInformationLogging() {

        Test.startTest();

        WEXBreezeInformationLogging.debug wexBreezeInformationLogging = new WEXBreezeInformationLogging.debug();
        wexBreezeInformationLogging.info('Test Error');

        Test.stopTest();

    }

    static testMethod void testBreezeTransactionLogging() {

        Test.startTest();

        WEXBreezeTransactionLogging.debug wexBreezeTransactionLogging = new WEXBreezeTransactionLogging.debug();
        wexBreezeTransactionLogging.info('Test Error');

        Test.stopTest();

    }

}