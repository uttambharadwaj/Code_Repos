/*
Description:        Test class for Campaign Program Trigger
Revision History: 
*/
@isTest
public class CmpgnProgramTriggerTest {

    public static void testCampaignProgramDelete() {

        String defaultError = 'The default Terms and Conditions cannot be deleted until a new default is selected.';
        Campaign_Program__c myCP = [SELECT Id FROM Campaign_Program__c WHERE DEFAULT__C = true LIMIT 1];
        String myError = '';

        Test.startTest();
        try{
            delete myCP;
        } catch (Exception e){
            myError = e.getMessage();
        }
        Test.stopTest();

        System.Assert(myError.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 'It did not fail as expected.');
        System.Assert(myError.contains(defaultError), 'The thing failed to fail as expected.');

    }

}