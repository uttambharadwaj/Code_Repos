/**
 * Created by dgilbert on 9/19/2018.
 */

@isTest
public with sharing class CreditDecisionEngineBREezeTest {

    static testMethod void testBREezeAdvancedFraudRule_Phone() {

        TestUtils.enable_isRunningTest = true;

        Test.startTest();

        sObject so = Schema.getGlobalDescribe().get('OnlineApplication__c').newSObject();

        // Test a positive case
        so.put('Phone_Number__c', '111-111-1111');

        CreditUtil_AdvancedFraudChecks_Phone creditUtilAdvancedFraudChecksPhone = new CreditUtil_AdvancedFraudChecks_Phone();

        System.assert(creditUtilAdvancedFraudChecksPhone.getFunctionValue(null, so, 'String', 'String', 'String', so.Id) == 'Passed');

        // Test a negative case
        so.put('Phone_Number__c', CreditUtil_AdvancedFraudChecks_Phone.TEST_STRING + '-111-1111');

        creditUtilAdvancedFraudChecksPhone = new CreditUtil_AdvancedFraudChecks_Phone();

        System.assert(creditUtilAdvancedFraudChecksPhone.getFunctionValue(null, so, 'String', 'String', 'String', so.Id) == 'Failed');

        creditUtilAdvancedFraudChecksPhone.postProcess();

        creditUtilAdvancedFraudChecksPhone.preProcess(new List<SOBject>{so}, 'Test', 'Test');

        Test.stopTest();

    }

}