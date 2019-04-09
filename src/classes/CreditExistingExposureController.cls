/*
*
* Credit Existing Exposure
* Author: Derek Gilbert
* Initial Date: 8/21/2018
*
*/
public with sharing class CreditExistingExposureController {

    public String applicationId {
        get {
            if(ApexPages.currentPage().getParameters().get('id') != null) {
                return ApexPages.currentPage().getParameters().get('id');
            }
            return null;
        }
    }

    // This is for display purposes only..
    public CreditUtil_ExistingExposure.ExistingExposureRequest originalRequest { get; set; }

    public List<CreditUtil_ExistingExposure.ExistingExposureAccounts> duplicateAccounts { get; set; }

    public List<CreditUtil_ExistingExposure.ExistingExposureApplications> duplicateApplications { get; set; }

    public CreditUtil_ExistingExposure.ExistingExposureRequest existingExposureRequest { get; set; }

    public boolean hasNoRecords { get; set; }

    public CreditExistingExposureController(){

    }

    public void init() {

        existingExposureRequest = new CreditUtil_ExistingExposure.ExistingExposureRequest();

        if(((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

            List<OnlineApplication__c> onlineApplications = [SELECT Id, Name, Legal_Business_Name__c, Business_Street_Address__c, Business_Address_Line_2__c,
                                                             City__c, State__c, Zip_Code__c, Federal_Tax_ID__c, DNB_Resolved_DUNS__c, Phone_Number__c, IP_Address__c, AO_Social_Security_Number__c
                                                                FROM OnlineApplication__c WHERE Id =: applicationId];

            if(onlineApplications.size() == 1) {

                existingExposureRequest.applicationId = applicationId;
                existingExposureRequest.applicationName = onlineApplications[0].Name;
                existingExposureRequest.legalBusinessName = onlineApplications[0].Legal_Business_Name__c;
                existingExposureRequest.addressLine1 = onlineApplications[0].Business_Street_Address__c;
                existingExposureRequest.city = onlineApplications[0].City__c;
                existingExposureRequest.state = onlineApplications[0].State__c;
                existingExposureRequest.postalCode = onlineApplications[0].Zip_Code__c;
                existingExposureRequest.phone = onlineApplications[0].Phone_Number__c;
                existingExposureRequest.duns = onlineApplications[0].DNB_Resolved_DUNS__c;
                existingExposureRequest.taxID = onlineApplications[0].Federal_Tax_ID__c;
                existingExposureRequest.pgSSN = onlineApplications[0].AO_Social_Security_Number__c;
                existingExposureRequest.ipAddress = onlineApplications[0].IP_Address__c;

                originalRequest = existingExposureRequest.clone();

                duplicateApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);

                duplicateAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);

            }
        }
        else if(((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

            List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, Name, Company_Legal_Name__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State__c, Physical_Postal_Code__c,
                                                                        Business_Phone__c, Application_Signer_IP_Address__c, DNB_Resolved_DUNS__c, Taxpayer_ID__c
                                                                     FROM CP_Application_Request__c WHERE Id =: applicationId];

            if(cpApplicationRequests.size() == 1) {

                existingExposureRequest.applicationId = applicationId;
                existingExposureRequest.applicationName = cpApplicationRequests[0].Name;
                existingExposureRequest.legalBusinessName = cpApplicationRequests[0].Company_Legal_Name__c;
                existingExposureRequest.addressLine1 = cpApplicationRequests[0].Physical_Address_Line_1__c;
                existingExposureRequest.city = cpApplicationRequests[0].Physical_City__c;
                existingExposureRequest.state = cpApplicationRequests[0].Physical_State__c;
                existingExposureRequest.postalCode = cpApplicationRequests[0].Physical_Postal_Code__c;
                existingExposureRequest.ipAddress = cpApplicationRequests[0].Application_Signer_IP_Address__c;
                existingExposureRequest.phone = cpApplicationRequests[0].Business_Phone__c;
                existingExposureRequest.duns = cpApplicationRequests[0].DNB_Resolved_DUNS__c;
                existingExposureRequest.taxID = cpApplicationRequests[0].Taxpayer_ID__c;

                originalRequest = existingExposureRequest.clone();

                duplicateApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);

                duplicateAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);
            }
        }
        else if(((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

            List<Application_Request__c> naApplicationRequests = [SELECT Id, Name, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c,
                    Business_Phone_Number__c, App_Signer_IP_Address__c, Tax_Payer_ID_number__c, DNB_Resolved_DUNS__c
            FROM Application_Request__c WHERE Id =: applicationId];

            if(naApplicationRequests.size() == 1) {

                existingExposureRequest.applicationId = applicationId;
                existingExposureRequest.applicationName = naApplicationRequests[0].Name;
                existingExposureRequest.legalBusinessName = naApplicationRequests[0].Opportunity_Name_Text__c;
                existingExposureRequest.addressLine1 = naApplicationRequests[0].Physical_Street__c;
                existingExposureRequest.city = naApplicationRequests[0].Physical_City__c;
                existingExposureRequest.state = naApplicationRequests[0].Physical_State__c;
                existingExposureRequest.postalCode = naApplicationRequests[0].Physical_Zip_Postal_Code__c;
                existingExposureRequest.ipAddress = naApplicationRequests[0].App_Signer_IP_Address__c;
                existingExposureRequest.phone = naApplicationRequests[0].Business_Phone_Number__c;
                existingExposureRequest.duns = naApplicationRequests[0].DNB_Resolved_DUNS__c;
                existingExposureRequest.taxID = naApplicationRequests[0].Tax_Payer_ID_number__c;

                originalRequest = existingExposureRequest.clone();

                duplicateApplications = CreditUtil_ExistingExposure.getApplications(existingExposureRequest);

                duplicateAccounts = CreditUtil_ExistingExposure.getAccounts(existingExposureRequest);
            }
        }

    }

}