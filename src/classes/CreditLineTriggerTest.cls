/**
 * Created by W501611 on 9/24/2020.
 */

@IsTest
public with sharing class CreditLineTriggerTest {
    public static void test_beforeInsert() {
        Credit_Line_Adjustment__c CreditLineInsert = new Credit_Line_Adjustment__c(Platform__c = 'EFSTS',
                Change_User_Operator_ID__c = 'aschneid@efsllc', CL_Change_Date__c = Date.parse('09/09/2020'), Customer_ID__c = '464006283312',
                Set_ID__c = 'EFS', DNB_Highest_Credit__c = 0);
        insert CreditLineInsert;

        Test.startTest();

        System.assert(CreditLineInsert.Id != null, 'Expected Credit Line to be inserted.');
        Test.stopTest();
    }

    public static void test_beforeUpdate() {
        List<Credit_Line_Adjustment__c> CreditLine = [SELECT Id, Platform__c, Change_User_Operator_ID__c FROM Credit_Line_Adjustment__c LIMIT 1];
        Test.startTest();
        CreditLine[0].Customer_ID__c = '464006283312';
        upsert CreditLine;

        List<Credit_Line_Adjustment__c> TestCreditLine = [SELECT Id, Platform__c, Change_User_Operator_ID__c, User_Authority_Limit__c
            FROM Credit_Line_Adjustment__c LIMIT 1];
        System.assert(TestCreditLine[0].User_Authority_Limit__c != null, 'Expected User Authority Limit to be Populated.');
        Test.stopTest();
    }
}