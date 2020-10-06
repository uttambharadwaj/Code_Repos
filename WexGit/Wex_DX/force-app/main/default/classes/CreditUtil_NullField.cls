/* Breeze doesn't allow setting a field to null. This function can be called from
 Any breeze rule to set a specific field as null.
 */
global class CreditUtil_NullField implements BREeze.FunctionCheckerPrePost {

	global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {
		return null;
	}

	global void postProcess() {
	}

	global void preProcess(List<sObject> records, String RuleName, String objectName) {
	}
}