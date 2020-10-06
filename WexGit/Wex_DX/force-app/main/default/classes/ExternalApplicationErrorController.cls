/**
 * Created by dgilbert on 8/1/2018.
 */

public with sharing class ExternalApplicationErrorController {

    public String programParameter {
        get {
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }
    }

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

    public External_Application_Error__c error { get; set; }

    public Id brandingLogo { get; set; }

    public void init() {

        if(programParameter != null) {

            Id programId = WexBrandingController.getProgramIdByBrandShortName(programParameter);

            if(programId != null) {

                brandingLogo = WexBrandingController.getLogoId(programId);

            }

        }

        if(errorCode != null && isSandbox) {

            List<External_Application_Error__c> externalApplicationErrors = [SELECT Id, Error_Message__c, Error_Location__c FROM External_Application_Error__c WHERE Name =: errorCode];

            if(externalApplicationErrors.size() == 1) {
                error = externalApplicationErrors[0];
            }

        }

    }

}