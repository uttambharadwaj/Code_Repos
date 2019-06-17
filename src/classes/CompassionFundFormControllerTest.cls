/**
 * Created by lhowland on 8/1/2018.
 */

@IsTest public with sharing class  CompassionFundFormControllerTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testCompassionFundFormSuccess() {

        Test.startTest();

        Compassion_Fund__c compassionFund = new Compassion_Fund__c();
        compassionFund.Additional_Information__c = 'Yes';
        compassionFund.Date_of_Event__c = Date.today();
        compassionFund.Disclaimer__c = true;
        compassionFund.Employee_ID__c = '111111';
        compassionFund.Employment_Length__c = 5;
        compassionFund.Home_City__c = 'South Portland';
        compassionFund.Home_Country__c = 'US';
        compassionFund.Home_State__c = 'ME';
        compassionFund.Home_Street_Address__c = '95 Darling Ave';
        compassionFund.Home_Postal_Code__c = '04106';
        compassionFund.Office_Location__c = 'WEX - South Portland, Maine';
        compassionFund.Permission_to_Share__c = 'Yes';
        compassionFund.Qualifying_Event_Type__c = 'Military Deployment';
        compassionFund.Work_Phone__c = '207-555-5555';

        //TestUtils.enable_isRunningTest = true;

        Compassion_Fund__c compassionFundForm = CompassionFundFormController.saveCompassionFundForm(compassionFund);

        System.assert(compassionFundForm != null);

        Test.stopTest();
    }

    static testMethod void testCompassionFundFormFail() {

        Test.startTest();

        Compassion_Fund__c compassionFund = new Compassion_Fund__c();
        compassionFund.Employee_ID__c = '111111';

        try {

            CompassionFundFormController.saveCompassionFundForm(compassionFund);

        } catch (Exception ex) {

            Boolean expectedExceptionThrown = ex.getMessage().contains('Unable to save form') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }

}