/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator
 *
*/
global class CreditUtil_LocationCheck implements BREeze.FunctionCheckerPrePost {

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        String returnFlag = 'Failed';

        String objectType = (Id.valueOf(so.Id)).getSobjectType().getDescribe().getName();

        if (objectType != null && (objectType).equalsIgnoreCase('CP_Application_Request__c')) {
            List<CP_Application_Request__c> cpApplications = [
                    SELECT Id, Mailing_Address_Line_1__c, Mailing_Address_Line_2__c, Mailing_City__c,
                            Mailing_State__c, Mailing_Postal_Code__c, Physical_Address_Line_1__c, Physical_Address_Line_2__c,
                            Physical_City__c, Physical_State__c, Physical_Postal_Code__c
                    FROM CP_Application_Request__c
                    WHERE Id = :so.Id
            ];

            System.debug(cpApplications);

            if (cpApplications.size() > 0) {

                if (cpApplications[0].Mailing_Address_Line_1__c != null && cpApplications[0].Mailing_City__c != null && cpApplications[0].Mailing_State__c != null && cpApplications[0].Mailing_Postal_Code__c != null) {

                    if (JaroWinklerDistance.getScore(cpApplications[0].Mailing_Address_Line_1__c, cpApplications[0].Physical_Address_Line_1__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(cpApplications[0].Mailing_City__c, cpApplications[0].Physical_City__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(cpApplications[0].Mailing_State__c, cpApplications[0].Physical_State__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(cpApplications[0].Mailing_Postal_Code__c, cpApplications[0].Physical_Postal_Code__c) >= 0.75) {

                        return 'Passed';

                    } else {
                        return 'Failed';
                    }
                }

            } else {
                // if shipping address null, then shipping is same as physical address
                return 'Passed';
            }
        }

        else if (objectType != null && (objectType).equalsIgnoreCase('OnlineApplication__c')) {
            List<OnlineApplication__c> onlineApplications = [
                    SELECT Id, Card_Shipping_Address_Line_1__c, Card_Shipping_Address_Line_2__c, Card_Shipping_City__c,
                            Card_Shipping_State__c, Card_Shipping_Postal_Code__c, Business_Street_Address__c, Business_Address_Line_2__c,
                            City__c, State__c, Zip_Code__c
                    FROM OnlineApplication__c
                    WHERE Id = :so.Id
            ];

            System.debug(onlineApplications);

            if (onlineApplications.size() > 0) {

                if (onlineApplications[0].Card_Shipping_Address_Line_1__c != null && onlineApplications[0].Card_Shipping_City__c != null && onlineApplications[0].Card_Shipping_State__c != null && onlineApplications[0].Card_Shipping_Postal_Code__c != null) {

                    if (JaroWinklerDistance.getScore(onlineApplications[0].Card_Shipping_Address_Line_1__c, onlineApplications[0].Business_Street_Address__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(onlineApplications[0].Card_Shipping_City__c, onlineApplications[0].City__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(onlineApplications[0].Card_Shipping_State__c, onlineApplications[0].State__c) >= 0.75 &&
                            JaroWinklerDistance.getScore(onlineApplications[0].Card_Shipping_Postal_Code__c, onlineApplications[0].Zip_Code__c) >= 0.75) {

                        return 'Passed';

                    } else {
                        return 'Failed';
                    }
                }

            } else {
                // if shipping address null, then shipping is same as physical address
                return 'Passed';
            }
        }

        return returnFlag;

    }

    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}