/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator
 * Verify the Authorized Signer is the same as the PG Signer
 * 
*/
global class CreditUtil_AppSignerCheck implements BREeze.FunctionCheckerPrePost {

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        String returnFlag = 'Passed';

        try {

            List<Application_Request__c> applicationRequests = [
                    SELECT Id, Application_Signer_FirstName_Text__c, App_Signer_Last_Name_Text__c, Personal_Guarantor_First_Name__c, Personal_Guarantor_Last_Name__c
                    FROM Application_Request__c
                    WHERE Id = :so.Id
            ];

            if (applicationRequests.size() > 0) {
                if (!(applicationRequests[0].Application_Signer_FirstName_Text__c.equalsIgnoreCase(applicationRequests[0].Personal_Guarantor_First_Name__c)
                        && applicationRequests[0].App_Signer_Last_Name_Text__c.equalsIgnoreCase(applicationRequests[0].Personal_Guarantor_Last_Name__c))) {
                    returnFlag = 'Failed';
                }
            }
        } catch (Exception e) {
            System.debug('Unable to verify if Auth Signer and PG Signer are the same. Error: ' + e.getMessage() + ' Line Number: ' + e.getLineNumber());
            return 'Error';
        }

        return returnFlag;
    }

    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}