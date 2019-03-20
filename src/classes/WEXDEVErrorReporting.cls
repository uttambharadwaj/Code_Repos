/**
 * Created by dgilbert on 5/30/2018.
 */

public with sharing class WEXDEVErrorReporting {

    public class errorReportingException extends Exception {}

    // TODO - Remove references to this function
    public static String reportInternalError(String applicationName, String applicationURL, Id userId, Exception ex) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Application__c = applicationName;
            error.Application_URL__c = applicationURL;
            error.User__c = userId;
            if(ex != null) {
                error.Error_Location__c = ex.getStackTraceString();
                error.Error_Message__c = ex.getMessage();
            }

            Database.upsertResult result = Database.upsert(error, false);
            if (result.isSuccess()) {

                List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id =: error.Id];

                if(errors.size() > 0) { return errors[0].Name; }

            }
            else {
                throw new errorReportingException('Unable to log message');
            }

        }
        catch(Exception e) {
            System.debug('### Unable to log error: ' + e.getMessage());
        }

        return null;

    }

    // Used for non-UI APEX classes
    public static String reportInternalError(String applicationName, Id userId, Exception ex, Boolean sendEmail) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Application__c = applicationName;
            error.User__c = userId;
            if(ex != null) {
                error.Error_Location__c = ex.getStackTraceString();
                error.Error_Message__c = ex.getMessage();
            }
            error.Send_Email__c = sendEmail;

            Database.upsertResult result = Database.upsert(error, false);
            if (result.isSuccess()) {

                List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id =: error.Id];

                if(errors.size() > 0) { return errors[0].Name; }

            }
            else {
                throw new errorReportingException('Unable to log message');
            }

        }
        catch(Exception e) {
            System.debug('### Unable to log error: ' + e.getMessage());
        }

        return null;

    }

    // Used for APEX Classes tied to a UI (VF/Lightning)
    public static String reportInternalError(String applicationName, PageReference currentPage, Id userId, Exception ex, Boolean sendEmail) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            error.Application__c = applicationName;
            error.Application_URL__c = WEXDEVErrorReporting.getCleanURL(currentPage);
            error.Application_Parameters__c = String.valueOf(currentPage.getParameters());
            error.User__c = userId;
            error.Send_Email__c = sendEmail;
            if(ex != null) {
                error.Error_Location__c = ex.getStackTraceString();
                error.Error_Message__c = ex.getMessage();
            }

            Database.upsertResult result = Database.upsert(error, false);
            if (result.isSuccess()) {

                List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id =: error.Id];

                if(errors.size() > 0) { return errors[0].Name; }

            }
            else {
                throw new errorReportingException('Unable to log message');
            }

        }
        catch(Exception e) {
            System.debug('### Unable to log error: ' + e.getMessage());
        }

        return null;

    }

    // TODO - Remove all references and switch to the new PageReference method
    public static String reportExternalError(String applicationName, String applicationURL, Exception ex) {

        try {

            External_Application_Error__c error = new External_Application_Error__c();

            error.Application__c = applicationName;
            error.Application_URL__c = applicationURL;
            error.Error_Location__c = ex.getStackTraceString();
            error.Error_Message__c = ex.getMessage();

            Database.upsertResult result = Database.upsert(error, false);
            if (result.isSuccess()) {

                List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id =: error.Id];

                if(errors.size() > 0) { return errors[0].Name; }

            }
            else {
                throw new errorReportingException('Unable to log message');
            }

        }
        catch(Exception e) {
            System.debug('### Unable to log error: ' + e.getMessage());
        }

        return null;

    }

    // External error reporting for all Force.com sites
    public static String reportExternalError(String applicationName, PageReference currentPage, Exception ex, Boolean sendEmail) {

        try {

            External_Application_Error__c error = new External_Application_Error__c();

            error.Application__c = applicationName;
            error.Application_URL__c = WEXDEVErrorReporting.getCleanURL(currentPage);
            error.Application_Parameters__c = String.valueOf(currentPage.getParameters());
            error.Send_Email__c = sendEmail;
            
            if(ex != null) {
                error.Error_Location__c = ex.getStackTraceString();
                error.Error_Message__c = ex.getMessage();
            }

            Database.upsertResult result = Database.upsert(error, false);
            if (result.isSuccess()) {

                List<External_Application_Error__c> errors = [SELECT Id, Name FROM External_Application_Error__c WHERE Id =: error.Id];

                if(errors.size() > 0) { return errors[0].Name; }

            }
            else {
                throw new errorReportingException('Unable to log message');
            }

        }
        catch(Exception e) {
            System.debug('### Unable to log error: ' + e.getMessage());
        }

        return null;

    }

    // Returns simply the hostname and the page being called
    public static String getCleanURL(PageReference currentPage) {

        String hostVal  = currentPage.getHeaders().get('Host');

        String urlVal = currentPage.getUrl();

        urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');

        string[] urlValExtra = urlVal.split('%3F',0);

        urlVal = urlValExtra[0];

        urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');

        return 'https://' + hostVal + urlVal;

    }

}