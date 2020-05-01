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

    /*
        ^                                       #Start of expression
        (?!\b(\d)\1+-(\d)\1+-(\d)\1+\b)         #Don't allow all matching digits for every field
        (?!123-45-6789|219-09-9999|078-05-1120) #Don't allow "123-45-6789", "219-09-9999" or "078-05-1120"
        (?!666|000|9\d{2})\d{3}                 #Don't allow the SSN to begin with 666, 000 or
                                                 anything between 900-999
        -                                       #A dash (separating Area and Group numbers)
        (?!00)\d{2}                             #Don't allow the Group Number to be "00"
        -                                       #Another dash (separating Group and Serial numbers)
        (?!0{4})\d{4}                           #Don't allow last four digits to be "0000"
        $                                       #End of expression
        https://www.codeproject.com/articles/651609/validating-social-security-numbers-through-regular
     */
    static final String SSN_PATTERN = '^(?!\\b(\\d)\\1+\\b)(?!123456789|219099999|078051120)(?!666|000|9\\d{2})\\d{3}(?!00)\\d{2}(?!0{4})\\d{4}$';

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        try {
            Pattern ssnValidationPattern = Pattern.compile(SSN_PATTERN); // Matches valid ssn's
            if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

                OnlineApplication__c onlineApplication = (OnlineApplication__c)so.clone();
                String ssn = (onlineApplication.AO_Social_Security_Number__c).replaceAll('[^0-9]','');
                if(!ssnValidationPattern.Matcher(ssn).matches() || JaroWinklerDistance.getScore((ssn), (onlineApplication.Federal_Tax_ID__c).replaceAll('[^0-9]','')) >= 1) {
                    return FAILED_CHECK;
                }

                return PASSED_CHECK;

            }
            else if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

                CP_Application_Request__c cpApplicationRequest = (CP_Application_Request__c)so.clone();
                String ssn = (cpApplicationRequest.Guarantor_Social_Security_Number__c).replaceAll('[^0-9]','');
                if(!ssnValidationPattern.Matcher(ssn).matches() || JaroWinklerDistance.getScore((ssn), (cpApplicationRequest.Taxpayer_ID__c).replaceAll('[^0-9]','')) >= 1) {
                    return FAILED_CHECK;
                }

                return PASSED_CHECK;

            }
            else if(so != null && ((so.Id).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

                Application_Request__c applicationRequest = (Application_Request__c)so.clone();
                String ssn = (applicationRequest.Personal_Guarantor_SSN__c).replaceAll('[^0-9]','');
                if(!ssnValidationPattern.Matcher(ssn).matches() || JaroWinklerDistance.getScore((ssn), (applicationRequest.Tax_Payer_ID_number__c).replaceAll('[^0-9]','')) >= 1) {
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