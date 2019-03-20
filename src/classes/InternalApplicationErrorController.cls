/**
 * Created by dgilbert on 8/1/2018.
 */

public with sharing class InternalApplicationErrorController {

    public String errorCode {
        get {
            return ApexPages.CurrentPage().getParameters().get('errorCode');
        }
    }

    public Boolean isSandbox {
        get {
            List<Organization> orgInfo = [SELECT Id FROM Organization WHERE IsSandbox = true LIMIT 1];

            if(orgInfo.size() == 1) {
                return true;
            }
            return false;
        }
    }

    public Internal_Application_Error__c error { get; set; }

    public Id brandingLogo { get; set; }

    public void init() {

        if(errorCode != null && isSandbox) {

            List<Internal_Application_Error__c> internalApplicationErrors = [SELECT Id, Error_Message__c, Error_Location__c FROM Internal_Application_Error__c WHERE Name =: errorCode];
            
            if(internalApplicationErrors.size() > 0) {
                error = internalApplicationErrors[0];
            }

        }

    }

}