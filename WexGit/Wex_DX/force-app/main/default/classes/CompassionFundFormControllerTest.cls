/**
 * Created by lhowland on 8/1/2018.
 * 2020-05-12 cjackson Added new fields to test.
 */

@IsTest public with sharing class  CompassionFundFormControllerTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testCompassionFundFormSuccess() {

        Test.startTest();

        Compassion_Fund__c compassionFund = new Compassion_Fund__c();
        compassionFund.Employee_ID__c = '111111';
        compassionFund.Office_Location__c = 'WEX - South Portland, Maine';
        compassionFund.Work_Phone__c = '207-555-5555';
        compassionFund.Home_Street_Address__c = '95 Darling Ave';
        compassionFund.Home_City__c = 'South Portland';
        compassionFund.Home_State__c = 'ME';
        compassionFund.Home_Postal_Code__c = '04106';
        compassionFund.Home_Country__c = 'US';
        compassionFund.Employment_Length__c = 5;
        compassionFund.Qualifying_Event_Type__c = 'Military Deployment';
        compassionFund.Date_of_Event__c = Date.today();
        compassionFund.Reason_for_Request__c = 'Received a lot of moving expenses due to relocation';
        compassionFund.Financial_Assistance_Requested__c = 2500;
        compassionFund.Other_Assistance__c = 'No other assistance received';
        compassionFund.Purpose_of_Funds__c = 'Pay my moving expenses';
        compassionFund.Additional_Information__c = 'Yes';
        compassionFund.Permission_to_Share__c = 'Yes';
        compassionFund.Disclaimer__c = true;

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