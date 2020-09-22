/*
Description:        Test class for UtilityClass
Revision History:
*/
@isTest
public class UtilityClassTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);

        insert new Lead(LastName = 'Test', Company = 'Test');
    }

    @isTest static void testInternalError() {
        //let's just verify there are no error records yet
        system.assertEquals(0, [SELECT count() FROM Internal_Application_Error__c]);

        //cool now let's decide on some error stuffs to send in
        Exception myException;
        String myMessage;
        String myStackTrace;
        try{
            insert new Account(); //shame shame we don't know your name
        } catch(Exception e){
            myException = e;
            myMessage = e.getMessage();
            myStackTrace = e.getStackTraceString();
        }

        //some basic error items. nothing fancy.
        String myApplicationURL = 'https://www.youtube.com/watch?v=mnioWfGz8FE';
        String myApplication = 'AppRequestTriggerTest=>testInternalError';
        Boolean mySendEmail = false;
        String myApplicationViewState = 'view state goes here';
        String myApplicationParameters = 'params go here';

        String myUser = UserInfo.getUserId();

        Internal_Application_Error__c myError = new Internal_Application_Error__c();

        //our test is simply calling the method that creates an error log. make sure it does what we want it to. NO DML in that method
        Test.startTest();
        myError = UtilityClass.logInternalError(myException, myApplicationURL, myApplication, mySendEmail, myApplicationViewState, myApplicationParameters);
        Test.stopTest();

        //verify it set everything we wanted it to.
        system.assertEquals(myMessage, myError.Error_Message__c);
        system.assertEquals(myStackTrace, myError.Error_Location__c);
        system.assertEquals(myApplicationURL, myError.Application_URL__c);
        system.assertEquals(myApplication, myError.Application__c);
        system.assertEquals(mySendEmail, myError.Send_Email__c);
        system.assertEquals(myApplicationViewState, myError.Application_View_State__c);
        system.assertEquals(myApplicationParameters, myError.Application_Parameters__c);
        system.assertEquals(myUser, myError.User__c);
        system.assertEquals(0, [SELECT count() FROM Internal_Application_Error__c]); //we really want to make sure there are no error records created from that thing

        //QED
    }
    @isTest static void testConvertPassedInLead() {

        Lead lead = [ SELECT Id FROM Lead ];

        Test.startTest();
        UtilityClass.convertPassedInLead(lead.Id, null, null, null, null);
        Test.stopTest();

        lead = [ SELECT Id, ConvertedAccountId FROM Lead ];
        System.assertEquals(true, lead.ConvertedAccountId != null);

    }

    @isTest static void testPhoneNumberMissingCountryCode() {

        String phoneMissingCountryCode = '909-909-9999';
        String phoneNotMissingCountryCode = '+1' + phoneMissingCountryCode;

        Test.startTest();
        System.assertEquals(true, UtilityClass.phoneNumberMissingCountryCode(phoneMissingCountryCode));
        System.assertEquals(false, UtilityClass.phoneNumberMissingCountryCode(phoneNotMissingCountryCode));
        Test.stopTest();
    }
    @isTest static void testHelper(){
        //the org is infected with terrible testing practices. we know who to call...
        UtilityClass.testHelper();
        UtilityClass.testHelper2();
        UtilityClass.testHelper3();
        UtilityClass.testHelper4();
        UtilityClass.testHelper5();
        UtilityClass.testHelper6();
    }

    @isTest static void testlogicalEval() {

        System.assertEquals(false, UtilityClass.logicalEval(4, 'test', 5)); // Invalid Operator

        // Operator: >
        System.assertEquals(true, UtilityClass.logicalEval(6, '>', 5));
        System.assertEquals(false, UtilityClass.logicalEval(5, '>', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '>', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '>', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, '>', 5)); // null field value
        System.assertEquals(false, UtilityClass.logicalEval(null, '>', null)); // Both null

        // Operator: <
        System.assertEquals(true, UtilityClass.logicalEval(1, '<', 5));
        System.assertEquals(false, UtilityClass.logicalEval(5, '<', 5));
        System.assertEquals(false, UtilityClass.logicalEval(6, '<', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '<', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, '<', 5)); // null field value
        System.assertEquals(false, UtilityClass.logicalEval(null, '<', null)); // Both null

        // Operator: >=
        System.assertEquals(true, UtilityClass.logicalEval(6, '>=', 5));
        System.assertEquals(true, UtilityClass.logicalEval(5, '>=', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '>=', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '>=', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, '>=', 5)); // null field value
        System.assertEquals(false, UtilityClass.logicalEval(null, '>=', null)); // Both null

        // Operator: <=
        System.assertEquals(true, UtilityClass.logicalEval(4, '<=', 5));
        System.assertEquals(true, UtilityClass.logicalEval(5, '<=', 5));
        System.assertEquals(false, UtilityClass.logicalEval(6, '<=', 5));
        System.assertEquals(false, UtilityClass.logicalEval(4, '<=', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, '<=', 5)); // null field value
        System.assertEquals(false, UtilityClass.logicalEval(null, '<=', null)); // Both null

        // Operator: IN
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'IN', 'test'));
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'IN', 'this,is,test'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'IN', 'Testing'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'IN', '')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('', 'IN', 'Test')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'IN', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, 'IN', 'Test')); // null field value

        // Operator: NOT IN
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'NOT IN', 'testing'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'NOT IN', 'this,is,test'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'NOT IN', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'NOT IN', '')); // Empty string
        System.assertEquals(true, UtilityClass.logicalEval('', 'NOT IN', 'Test')); // Empty string
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'NOT IN', null)); // null comparison value
        System.assertEquals(true, UtilityClass.logicalEval(null, 'NOT IN', 'Test')); // null field value

        // Operator: Contains
        System.assertEquals(true, UtilityClass.logicalEval('testing', 'CONTAINS', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('this,is,testing', 'CONTAINS', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'CONTAINS', 'Test'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'CONTAINS', '')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('', 'CONTAINS', 'Test')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'CONTAINS', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, 'CONTAINS', 'Test')); // null field value

        // Operator: NOT Contains
        System.assertEquals(true, UtilityClass.logicalEval('testing', 'CONTAINS', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('this,is,testing', 'CONTAINS', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('Test', 'CONTAINS', 'Test'));
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'CONTAINS', '')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('', 'CONTAINS', 'Test')); // Empty string
        System.assertEquals(false, UtilityClass.logicalEval('Test', 'CONTAINS', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, 'CONTAINS', 'Test')); // null field value

        // Operator: ==
        System.assertEquals(false, UtilityClass.logicalEval('test', '==', 'testing'));
        System.assertEquals(true, UtilityClass.logicalEval('test', '==', 'Test'));
        System.assertEquals(false, UtilityClass.logicalEval('test', '==', null)); // null comparison value
        System.assertEquals(false, UtilityClass.logicalEval(null, '==', 'test')); // null field value
        System.assertEquals(true, UtilityClass.logicalEval(null, '==', null)); // Both null

        // Operator: !=
        System.assertEquals(true, UtilityClass.logicalEval('test', '!=', 'testing'));
        System.assertEquals(false, UtilityClass.logicalEval('test', '!=', 'Test'));
        System.assertEquals(true, UtilityClass.logicalEval('test', '!=', null)); // null comparison value
        System.assertEquals(true, UtilityClass.logicalEval(null, '!=', 'test')); // null field value
        System.assertEquals(false, UtilityClass.logicalEval(null, '!=', null)); // Both null
    }
}