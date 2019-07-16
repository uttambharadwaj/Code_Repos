/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator
 *
*/
global class CreditUtil_FraudCreditLineCheck implements BREeze.FunctionCheckerPrePost {

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        String returnFlag = 'Passed';

        List<OnlineApplication__c> onlineApplications = [SELECT Id, Credit_Line_Requested__c, Credit_Limit_Per_Truck__c, Credit_Limit_Per_Truck_Slip_Seat__c, Number_of_Trucks__c, Team_Drivers_Slip_Seat__c, Prepaid__c
        FROM OnlineApplication__c WHERE Id =: so.Id];

        if(onlineApplications.size() > 0) {

            Decimal targetCreditLine = 0.00;

            if (onlineApplications[0].Credit_Line_Requested__c == 0 || onlineApplications[0].Prepaid__c) {
                return 'Passed';
            }

            if(onlineApplications[0].Credit_Limit_Per_Truck__c != 0.00 && onlineApplications[0].Credit_Limit_Per_Truck_Slip_Seat__c != 0.00) {
                if(onlineApplications[0].Team_Drivers_Slip_Seat__c == true) {
                    targetCreditLine = onlineApplications[0].Number_of_Trucks__c * onlineApplications[0].Credit_Limit_Per_Truck_Slip_Seat__c;
                }
                else {
                    targetCreditLine = onlineApplications[0].Number_of_Trucks__c * onlineApplications[0].Credit_Limit_Per_Truck__c;
                }
            }
            else {
                if(onlineApplications[0].Team_Drivers_Slip_Seat__c == true) {  targetCreditLine = onlineApplications[0].Number_of_Trucks__c * 3500; }
                else {  targetCreditLine = onlineApplications[0].Number_of_Trucks__c * 2500; }
            }

            Decimal differenceAmount = (onlineApplications[0].Credit_Line_Requested__c - targetCreditLine);

            if(differenceAmount > 0.00 && targetCreditLine != 0) {

                if((differenceAmount / targetCreditLine) > 0.50) {  return 'Failed'; }

            }
        }

        return returnFlag;

    }

    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}