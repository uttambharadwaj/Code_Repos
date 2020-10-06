/**
 * Created by dgilbert on 9/18/2018.
 */

/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator
 *
*/
global class CreditUtil_AdvancedFraudChecks_Phone implements BREeze.FunctionCheckerPrePost {

    static final String PASSED_CHECK = 'Passed';
    static final String FAILED_CHECK = 'Failed';
    static final String ERRORED_CHECK = 'Error';

    public static final String TEST_STRING = '818';

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        try {

            Set<String> fieldValues = new Set<String>();

            if(!TestUtils.isRunningTest()) {
                List<AggregateResult> bRuleDetails = [SELECT BREeze__Field_Value__c FROM BREeze__Rule_Detail__c WHERE BREeze__Rule__c = :ruleId GROUP BY BREeze__Field_Value__c];

                for (AggregateResult aggregateResult : bRuleDetails) {
                    fieldValues.add(String.valueOf(aggregateResult.get('BREeze__Field_Value__c')));
                }
            }
            else {
                fieldValues.add(TEST_STRING);
            }

            Map<String, Object> fieldsToValue = so.getPopulatedFieldsAsMap();

            for(String fieldName : fieldsToValue.keySet()) {

                if(!(fieldName).equalsIgnoreCase('Id') && !(fieldName).equalsIgnoreCase('CurrencyISOCode')) {

                    String phoneNumber = (String.valueOf(fieldsToValue.get(fieldName))).replaceAll('[^0-9]','');

                    for(String fieldValue : fieldValues) {

                        if((phoneNumber).startsWith(fieldValue)) {

                            return FAILED_CHECK;

                        }

                    }

                }

            }

            return PASSED_CHECK;

        }
        catch(Exception e) {

            System.debug('### Error checking phone number: ' + e.getMessage() + ' (Line: ' + e.getLineNumber() + ')');

        }

        return ERRORED_CHECK;

    }

    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}