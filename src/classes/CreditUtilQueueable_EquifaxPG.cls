/*
*
* Credit Decisioning Queueable
* Module: Experian PG Callouts
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/
public class CreditUtilQueueable_EquifaxPG implements Queueable, Database.AllowsCallouts {

    private ID applicationId;

    public CreditUtilQueueable_EquifaxPG(Id applicationId) {

        this.applicationId = applicationId;

    }

    public void execute(QueueableContext context) {

        String objectType = (Id.valueOf(applicationId)).getSobjectType().getDescribe().getName();

        if (objectType != null && (objectType).equalsIgnoreCase('OnlineApplication__c')) {

            List<OnlineApplication__c> onlineApplications = [
                    SELECT Id, Contact_First_Name__c, Contact_Last_Name__c, AO_Address__c, AO_City__c,
                            AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c, AO_Home_Phone_Number__c,
                            Running_Credit_Decisioning__c, PG_Required__c, Type_of_Business__c, PG_Score__c, PG_High_Credit_Amount__c, PG_Data__c
                    FROM OnlineApplication__c
                    WHERE Id = :applicationId
            ];

            if (onlineApplications.size() == 1) {

                OnlineApplication__c onlineApplication = onlineApplications[0];

                onlineApplication.Running_Credit_Decisioning__c = true;

                if (onlineApplication.PG_Required__c) {

                    CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();

                    equifaxRequest.socialInsuranceNumber = onlineApplication.AO_Social_Security_Number__c;
                    if(null == onlineApplication.Contact_First_Name__c && null == onlineApplication.Contact_Last_Name__c && null != onlineApplication.Contact_Name__c) {
                        equifaxRequest.firstName = (onlineApplication.Contact_Name__c).split(' ')[0];
                        equifaxRequest.lastName = (onlineApplication.Contact_Name__c).split(' ')[1];
                    }
                    else {
                        equifaxRequest.firstName = onlineApplication.Contact_First_Name__c;
                        equifaxRequest.lastName = onlineApplication.Contact_Last_Name__c;
                    }
                    equifaxRequest.address = onlineApplication.AO_Address__c;
                    equifaxRequest.city = onlineApplication.AO_City__c;
                    equifaxRequest.province = onlineApplication.AO_State__c;
                    equifaxRequest.postalCode = onlineApplication.AO_Zip_Code__c;
                    equifaxRequest.phone = onlineApplication.AO_Home_Phone_Number__c;
                    if (onlineApplication.AO_Date_of_Birth__c != null) {
                        equifaxRequest.dateOfBirthMonth = String.valueOf(onlineApplication.AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthDay = String.valueOf(onlineApplication.AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthYear = String.valueOf(onlineApplication.AO_Date_of_Birth__c.year());
                    }

                    CreditWS_Equifax.EquifaxResponse equifaxResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));

                    if (equifaxResponse != null) {
                        onlineApplication.PG_Score__c = equifaxResponse.creditScore;
                        onlineApplication.PG_Data__c = equifaxResponse.equifaxData;
                        onlineApplication.PG_High_Credit_Amount__c = equifaxResponse.pgHighCredit;
                    }
                    else if (equifaxResponse == null || equifaxResponse.calloutFailed){
                        System.debug('Equifax callout failed. Response: ' + equifaxResponse);
                    }
                }

                upsert onlineApplication;

                // Make a safe copy so we don't overwrite any fields
                onlineApplications = [SELECT Id, Running_Credit_Decisioning__c FROM OnlineApplication__c WHERE Id = :applicationId LIMIT 1];

                if(onlineApplications.size() > 0) {

                    // Flag the Credit Decision Engine as not running
                    onlineApplications[0].Running_Credit_Decisioning__c = false;

                    upsert onlineApplications;
                }
            }
        }
        else if (objectType != null && (objectType).equalsIgnoreCase('CP_Application_Request__c')) {

            List<CP_Application_Request__c> cpApplications = [
                    SELECT Id, Guarantor_First_Name__c, Guarantor_Last_Name__c, Guarantor_Residential_Address__c, Guarantor_Residential_City__c,
                            Guarantor_State_Province__c, Guarantor_Residential_Postal_Code__c, Guarantor_Date_of_Birth__c, Guarantor_Social_Security_Number__c, Guarantor_Residential_Phone__c,
                            Running_Credit_Decisioning__c, PG_Required__c, Legal_Structure__c, PG_FICO_Score__c, PG_High_Credit_Amount__c, PG_Data__c
                    FROM CP_Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (cpApplications.size() == 1) {

                CP_Application_Request__c cpApplicant = cpApplications[0];

                cpApplicant.Running_Credit_Decisioning__c = true;

                if (cpApplicant.PG_Required__c) {

                    CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();

                    equifaxRequest.socialInsuranceNumber = cpApplicant.Guarantor_Social_Security_Number__c;
                    equifaxRequest.firstName = cpApplicant.Guarantor_First_Name__c;
                    equifaxRequest.lastName = cpApplicant.Guarantor_Last_Name__c;
                    equifaxRequest.address = cpApplicant.Guarantor_Residential_Address__c;
                    equifaxRequest.city = cpApplicant.Guarantor_Residential_City__c;
                    equifaxRequest.province = cpApplicant.Guarantor_State_Province__c;
                    equifaxRequest.postalCode = cpApplicant.Guarantor_Residential_Postal_Code__c;
                    equifaxRequest.phone = cpApplicant.Guarantor_Residential_Phone__c;
                    if (cpApplicant.Guarantor_Date_of_Birth__c != null) {
                        equifaxRequest.dateOfBirthMonth = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthDay = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthYear = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.year());
                    }

                    CreditWS_Equifax.EquifaxResponse equifaxResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));

                    if (equifaxResponse != null) {
                        cpApplicant.PG_FICO_Score__c = equifaxResponse.creditScore;
                        cpApplicant.PG_Data__c = equifaxResponse.equifaxData;
                        cpApplicant.PG_High_Credit_Amount__c = equifaxResponse.pgHighCredit;
                    }
                    else if (equifaxResponse == null || equifaxResponse.calloutFailed) {
                        System.debug('Equifax callout failed. Response: ' + equifaxResponse);
                    }
                }

                upsert cpApplicant;

                // Make a safe copy so we don't overwrite any fields
                cpApplications = [SELECT Id, Running_Credit_Decisioning__c FROM CP_Application_Request__c WHERE Id = :applicationId];

                if(cpApplications.size() > 0) {

                    // Flag the Credit Decision Engine as not running
                    cpApplicant.Running_Credit_Decisioning__c = false;

                    upsert cpApplicant;
                }
            }
        }
        else if (objectType != null && (objectType).equalsIgnoreCase('Application_Request__c')) {

            List<Application_Request__c> naApplications = [
                    SELECT Id, Personal_Guarantor_First_Name__c, Personal_Guarantor_Last_Name__c, Personal_Guarantor_Mailing_Street__c, Personal_Guarantor_Mailing_City__c,
                            Personal_Guarantor_Mailing_State__c, Personal_Guarantor_Mailing_Zip__c, Personal_Guarantor_DOB__c, Personal_Guarantor_SSN__c, Personal_Guarantor_Home_Phone__c,
                            Running_Credit_Decisioning__c, PG_Required__c, Legal_Structure__c, PG_FICO_Score__c, PG_Data__c
                    FROM Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (naApplications.size() == 1) {

                Application_Request__c naApplicant = naApplications[0];

                naApplicant.Running_Credit_Decisioning__c = true;

                CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();
                
                equifaxRequest.socialInsuranceNumber = naApplicant.Personal_Guarantor_SSN__c;
                equifaxRequest.firstName = naApplicant.Personal_Guarantor_First_Name__c;
                equifaxRequest.lastName = naApplicant.Personal_Guarantor_Last_Name__c;
                equifaxRequest.address = naApplicant.Personal_Guarantor_Mailing_Street__c;
                equifaxRequest.city = naApplicant.Personal_Guarantor_Mailing_City__c;
                equifaxRequest.province = naApplicant.Personal_Guarantor_Mailing_State__c;
                equifaxRequest.postalCode = naApplicant.Personal_Guarantor_Mailing_Zip__c;
                equifaxRequest.phone = naApplicant.Personal_Guarantor_Home_Phone__c;
                if (naApplicant.Personal_Guarantor_DOB__c != null) {
                    equifaxRequest.dateOfBirthMonth = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.month()).leftPad(2).replace(' ', '0');
                    equifaxRequest.dateOfBirthDay = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.day()).leftPad(2).replace(' ', '0');
                    equifaxRequest.dateOfBirthYear = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.year());
                }
                
                CreditWS_Equifax.EquifaxResponse equifaxResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));
                
                if (equifaxResponse != null) {
                    naApplicant.PG_FICO_Score__c = equifaxResponse.creditScore;
                    naApplicant.PG_Data__c = equifaxResponse.equifaxData;
                    naApplicant.PG_High_Credit_Amount__c = equifaxResponse.pgHighCredit;
                }
                else if (equifaxResponse == null || equifaxResponse.calloutFailed) {
                    System.debug('Equifax callout failed. Response: ' + equifaxResponse);
                }

                upsert naApplicant;

                // Make a safe copy so we don't overwrite any fields
                naApplications = [SELECT Id, Running_Credit_Decisioning__c FROM Application_Request__c WHERE Id = :applicationId];

                if(naApplications.size() > 0) {

                    // Flag the Credit Decision Engine as not running
                    naApplicant.Running_Credit_Decisioning__c = false;

                    upsert naApplicant;
                }
            }
        }
    }
}