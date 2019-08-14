/**
 * Created by dgilbert on 9/18/2018.
 */

/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator
 *
*/
global class CreditUtil_AdvancedFraudChecks_SSN implements BREeze.FunctionCheckerPrePost {

    static final String PASSED_CHECK = 'Passed';
    static final String FAILED_CHECK = 'Failed';
    static final String ERRORED_CHECK = 'Error';

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        try {

            if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

                OnlineApplication__c onlineApplication = (OnlineApplication__c)so.clone();

                if(JaroWinklerDistance.getScore((onlineApplication.AO_Social_Security_Number__c).replaceAll('[^0-9]',''), (onlineApplication.Federal_Tax_ID__c).replaceAll('[^0-9]','')) >= 1) {
                    return FAILED_CHECK;
                }

                return PASSED_CHECK;

            }
            else if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

                CP_Application_Request__c cpApplicationRequest = (CP_Application_Request__c)so.clone();

                if(JaroWinklerDistance.getScore((cpApplicationRequest.Guarantor_Social_Security_Number__c).replaceAll('[^0-9]',''), (cpApplicationRequest.Taxpayer_ID__c).replaceAll('[^0-9]','')) >= 1) {
                    return FAILED_CHECK;
                }

                return PASSED_CHECK;

            }
            else if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

                Application_Request__c applicationRequest = (Application_Request__c)so.clone();

                if(JaroWinklerDistance.getScore((applicationRequest.Personal_Guarantor_SSN__c).replaceAll('[^0-9]',''), (applicationRequest.Tax_Payer_ID_number__c).replaceAll('[^0-9]','')) >= 1) {
                    return FAILED_CHECK;
                }

                return PASSED_CHECK;

            }

        }
        catch(Exception e) {

            System.debug('### Error comparing TIN to SSN: ' + e.getMessage() + ' (Line: ' + e.getLineNumber() + ')');

        }

        return ERRORED_CHECK;

    }

    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}