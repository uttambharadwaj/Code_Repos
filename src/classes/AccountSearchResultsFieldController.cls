/**
 * Created by Sara Schmidt (WEX) on 12/27/2019.
 * Apex controller for Account Search Results Field
 */

public with sharing class AccountSearchResultsFieldController {

    // Checks if OTR NA Fleet Account, if so, clones into Service Operations account
    @AuraEnabled
    public static String cloneOTRAccountIfNeeded(String accountNumber, String accountRecordId) {

        try {

            if (isSalesforceId(accountRecordId)) {
                Id serviceAccountId = ServiceOperationsAccountCloner.cloneAccountAndContacts(accountRecordId);

                System.debug('*** Account Cloner returned Id '+ serviceAccountId + ' for OTR account Id '+ accountRecordId);
                return serviceAccountId;

            } else {
                System.debug('*** Account not recognized as OTR account, continue without cloning');
            }

        }
        catch(Exception e) {

            if (Test.isRunningTest()) {
                throw e;
            } else {
                String errorCode = logError(e);
                throw new AuraHandledException('Unable to retrieve account details. (Error Tracking Code: ' + errorCode + ')');
            }
        }

        return accountRecordId;
    }

    private static Boolean isSalesforceId(String testId) {
        if (String.isEmpty(testId))  {
            return false;
        }
        if (testId.length() != 15 && testId.length() != 18) {
            return false;
        }
        return (Pattern.matches('[A-Za-z0-9]+',testId));
    }

    private static String logError(Exception e) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Error_Message__c = String.valueOf(e);
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'Service Console - Account Search Results Field';

            insert error;

            if (Test.isRunningTest()) {
                System.debug('*** ERROR: '+String.valueOf(e));
                System.debug('*** LOCATION: '+String.valueOf(e.getStackTraceString()));
                System.debug(e.getMessage());
                System.debug('Error at line: '+e.getLineNumber());
                System.debug('Type: '+e.getTypeName());
            }

            List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }

        }
        catch(Exception f) {

            System.debug('Error logging exception.. Skipping..');

            return '';

        }
    }
}