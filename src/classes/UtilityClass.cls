/*
* Utility Class
* Author: All the Team
* Initial Date: 4/26/2019
* Description: methods used by all the classes to go here. this allows for complete consistency across the org
* Test Class:
* Last Known Test Coverage:
* Revision History:
*
*/
global class UtilityClass {

    //log an error. no dml bc it accepts only one exception at a time.
    //TODO: combine Internal and External error objects into one
    public static Internal_Application_Error__c logInternalError(Exception e, String theURL, String whereFrom, Boolean sendIt, String viewState, String params) {
        Internal_Application_Error__c error = new Internal_Application_Error__c();

        error.Error_Message__c = e.getMessage();
        error.Error_Location__c = String.valueOf(e.getStackTraceString());
        error.Application__c = whereFrom;
        error.Application_URL__c = theURL;
        error.User__c = UserInfo.getUserId();
        error.Send_Email__c = sendIt;
        error.Application_View_State__c = viewState;
        error.Application_Parameters__c = params;

        return error;
    }

}