/**
 * Created by W501611 on 9/24/2020.
 */

public with sharing class CreditLineHelper {

    public static void SetCreditLineDataFields(List<Credit_Line_Adjustment__c> CreditLineList){
        {
            List<AR_User_Cross_Reference__c> queryResults = new List<AR_User_Cross_Reference__c>();
            List<Credit_Line_Adjustment__c> ListToUpdate = new List<Credit_Line_Adjustment__c>();
            Set<String> PlatformList = new Set<String>();
            List<String> OperatorId = new List<String>();
            for (Credit_Line_Adjustment__c CreditLine: CreditLineList){
                PlatformList.add(CreditLine.Platform__c);
                OperatorId.add(CreditLine.Change_User_Operator_ID__c);
            }
            queryResults = [SELECT Id, User__c, User_Authority_Limit__c, User_Email__c, User_Full_Name__c, User_Manager__c, User_Manager_Email__c,
                    Platform__c, User_Operator_ID__c, Non_User_Email_Address__c, Non_User_Full_Name__c, Non_User_Manager__c, Non_User_Manager_Email__c FROM AR_User_Cross_Reference__c WHERE Platform__c IN :PlatformList AND User_Operator_ID__c IN :OperatorId];
            if (queryResults.size() > 0){
                for (String Platform: PlatformList){
                    for (Credit_Line_Adjustment__c CreditLine: CreditLineList) {
                        if (CreditLine.Platform__c == Platform){
                            for (AR_User_Cross_Reference__c queryResult: queryResults){
                                if (CreditLine.Change_User_Operator_ID__c == queryResult.User_Operator_ID__c){
                                    try {

                                        if (queryResult.User__c == null) {
                                            CreditLine.User_Authority_Limit__c = queryResult.User_Authority_Limit__c;
                                            CreditLine.User_Email_Address__c = queryResult.Non_User_Email_Address__c;
                                            CreditLine.User_Full_Name__c = queryResult.Non_User_Full_Name__c;
                                            CreditLine.User_Manager__c = queryResult.Non_User_Manager__c;
                                            CreditLine.User_Manager_Email_ID__c = queryResult.Non_User_Manager_Email__c;
                                        } else {
                                            CreditLine.Change_User__c = queryResult.User__c;
                                            CreditLine.User_Authority_Limit__c = queryResult.User_Authority_Limit__c;
                                            CreditLine.User_Email_Address__c = queryResult.User_Email__c;
                                            CreditLine.User_Full_Name__c = queryResult.User_Full_Name__c;
                                            CreditLine.User_Manager__c = queryResult.User_Manager__c;
                                            CreditLine.User_Manager_Email_ID__c = queryResult.User_Manager_Email__c;

                                        }
                                        ListToUpdate.add(CreditLine);


                                    } catch (System.QueryException e) {
                                        System.debug('Error when querying for AR User Cross Reference For Credit Line Authorization Update: ' + e);
                                        UtilityClass.logInternalError(e, null, 'CreditLineAfterInsertHandler=>CreditLineAdjustmentAfterInsert', false, null, null);
                                    }
                                }
                            }
                        }
                    }

                }
                if (ListToUpdate.size() > 0) {
                    try {
                        Database.upsert(ListToUpdate);
                    } catch (DmlException e) {
                        System.debug('Error Updating Credit Line Adjustment Records: ' + e.getMessage());
                    }
                }
            }
        }
    }

}