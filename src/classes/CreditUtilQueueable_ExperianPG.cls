/*
*
* Credit Decisioning Queueable
* Module: Experian PG Callouts
* Author: Derek Gilbert
* Initial Date: 3/26/2018
*
*/
public class CreditUtilQueueable_ExperianPG implements Queueable, Database.AllowsCallouts {

    private ID applicationId;

    public CreditUtilQueueable_ExperianPG(Id applicationId) {

        this.applicationId = applicationId;

    }

    public void execute(QueueableContext context) {

        String objectType = (Id.valueOf(applicationId)).getSobjectType().getDescribe().getName(); 

        if (objectType != null && (objectType).equalsIgnoreCase('OnlineApplication__c')) {

            List<OnlineApplication__c> onlineApplications = [
                    SELECT Id, Contact_First_Name__c, Contact_Last_Name__c, AO_Name__c, AO_First_Name__c, AO_Last_Name__c, AO_Address__c, AO_City__c,
                            AO_State__c, AO_Zip_Code__c, AO_Date_of_Birth__c, AO_Social_Security_Number__c, AO_Home_Phone_Number__c,
                            Running_Credit_Decisioning__c, PG_Required__c, Type_of_Business__c, PG_Score__c, PG_Data__c, PG_High_Credit_Amount__c,
                            Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c
                    FROM OnlineApplication__c
                    WHERE Id = :applicationId
            ];

            if (onlineApplications.size() == 1) {

                OnlineApplication__c onlineApplication = onlineApplications[0];

                onlineApplication.Running_Credit_Decisioning__c = true;

                if (onlineApplication.PG_Required__c) {

                    CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();

                    /** Permissible Purpose Type Code (aka Account Purpose Type Code) denotes the loan purpose type and amount.
                * For WEX's given subcode we have the following options:
                *   5K: Should be used when business owner is applying for a non-credit financing product. Net term less than 30 days
                *   5J: Should be used when a business is applying for a credit product and the you are checking credit of the sole guarantor of the business (Companies, corp or LLCs, etc)
                *   10: Should be used when the business owner is applying for a credit product (loan) and the business is a sole prop or partnership where the owner has personal liability
                */
                    if (null != onlineApplication.Type_of_Business__c && (onlineApplication.Type_of_Business__c.equals('Proprietorship') || onlineApplication.Type_of_Business__c.equals('Partnership'))) {
                        experianRequest.accountPurposeCode = '10';
                    } else {
                        experianRequest.accountPurposeCode = '5J';
                    }

                    experianRequest.socialSecurityNumber = onlineApplication.AO_Social_Security_Number__c;
                    if(null == onlineApplication.AO_First_Name__c && null == onlineApplication.AO_Last_Name__c && null != onlineApplication.AO_Name__c) {
                        experianRequest.contactFirstName = (onlineApplication.AO_Name__c).split(' ')[0];
                        experianRequest.contactLastName = (onlineApplication.AO_Name__c).split(' ')[1];
                    }
                    else {
                        experianRequest.contactFirstName = onlineApplication.AO_First_Name__c;
                        experianRequest.contactLastName = onlineApplication.AO_Last_Name__c;
                    }
                    experianRequest.address = onlineApplication.AO_Address__c;
                    experianRequest.city = onlineApplication.AO_City__c;
                    experianRequest.state = onlineApplication.AO_State__c;
                    experianRequest.zipCode = onlineApplication.AO_Zip_Code__c;
                    experianRequest.phone = onlineApplication.AO_Home_Phone_Number__c;
                    if (onlineApplication.AO_Date_of_Birth__c != null) {
                        experianRequest.dateOfBirthMonth = String.valueOf(onlineApplication.AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthDay = String.valueOf(onlineApplication.AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthYear = String.valueOf(onlineApplication.AO_Date_of_Birth__c.year());
                    }

                    CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));

                    if (experianResponse != null) {
                        onlineApplication.PG_Score__c = experianResponse.creditScore;
                        onlineApplication.PG_Data__c = experianResponse.experianData;
                        onlineApplication.Experian_Premier_Attributes__c  = experianResponse.premierAtrributes;
                        onlineApplication.PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                        onlineApplication.Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                        onlineApplication.Security_Statement_on_Report__c = experianResponse.securityStatement;
                        onlineApplication.On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;
                    }
                    else if (experianResponse == null || experianResponse.calloutFailed){
                        System.debug('Experian callout failed. Response: ' + experianResponse);
                        onlineApplication.PG_Data__c = 'Callout Failed';
                    }
                }

                upsert onlineApplication;

                CreditDecisionEngineOTR.runFinalCreditDecision(onlineApplication);

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
                            Running_Credit_Decisioning__c, PG_Required__c, Legal_Structure__c, PG_FICO_Score__c, PG_Data__c, PG_High_Credit_Amount__c, Experian_Premier_Attributes__c,
                            Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c
                    FROM CP_Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (cpApplications.size() == 1) {

                CP_Application_Request__c cpApplicant = cpApplications[0];

                cpApplicant.Running_Credit_Decisioning__c = true;

                if (cpApplicant.PG_Required__c) {

                    CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();

                    /** Permissible Purpose Type Code (aka Account Purpose Type Code) denotes the loan purpose type and amount.
                * For WEX's given subcode we have the following options:
                *   5K: Should be used when business owner is applying for a non-credit financing product. Net term less than 30 days
                *   5J: Should be used when a business is applying for a credit product and the you are checking credit of the sole guarantor of the business (Companies, corp or LLCs, etc)
                *   10: Should be used when the business owner is applying for a credit product (loan) and the business is a sole prop or partnership where the owner has personal liability
                */
                    if (cpApplicant.Legal_Structure__c.equals('Proprietorship') || cpApplicant.Legal_Structure__c.equals('Partnership')) {
                        experianRequest.accountPurposeCode = '10';
                    } else {
                        experianRequest.accountPurposeCode = '5J';
                    }

                    experianRequest.socialSecurityNumber = cpApplicant.Guarantor_Social_Security_Number__c;
                    experianRequest.contactFirstName = cpApplicant.Guarantor_First_Name__c;
                    experianRequest.contactLastName = cpApplicant.Guarantor_Last_Name__c;
                    experianRequest.address = cpApplicant.Guarantor_Residential_Address__c;
                    experianRequest.city = cpApplicant.Guarantor_Residential_City__c;
                    experianRequest.state = cpApplicant.Guarantor_State_Province__c;
                    experianRequest.zipCode = cpApplicant.Guarantor_Residential_Postal_Code__c;
                    experianRequest.phone = cpApplicant.Guarantor_Residential_Phone__c;
                    if (cpApplicant.Guarantor_Date_of_Birth__c != null) {
                        experianRequest.dateOfBirthMonth = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthDay = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthYear = String.valueOf(cpApplicant.Guarantor_Date_of_Birth__c.year());
                    }

                    CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));

                    if (experianResponse != null) {
                        cpApplicant.PG_FICO_Score__c = experianResponse.creditScore;
                        cpApplicant.PG_Data__c = experianResponse.experianData;
                        cpApplicant.Experian_Premier_Attributes__c = experianResponse.premierAtrributes;
                        cpApplicant.PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                        cpApplicant.Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                        cpApplicant.Security_Statement_on_Report__c = experianResponse.securityStatement;
                        cpApplicant.On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;
                    }
                    else if (experianResponse == null || experianResponse.calloutFailed) {
                        System.debug('Experian callout failed. Response: ' + experianResponse);
                        cpApplicant.PG_Data__c = 'Callout Failed';
                    }
                }

                upsert cpApplicant;
                CreditDecisionEngineCP.runFinalCreditDecision(cpApplicant);
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
                            Running_Credit_Decisioning__c, PG_Required__c, Legal_Structure__c, PG_FICO_Score__c, PG_Data__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c,
                            On_File_Address_High_Risk__c, Experian_Premier_Attribute_Codes__c
                    FROM Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (naApplications.size() == 1) {

                Application_Request__c naApplicant = naApplications[0];

                naApplicant.Running_Credit_Decisioning__c = true;

                if (naApplicant.PG_Required__c) {

                    CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();

                    /** Permissible Purpose Type Code (aka Account Purpose Type Code) denotes the loan purpose type and amount.
                * For WEX's given subcode we have the following options:
                *   5K: Should be used when business owner is applying for a non-credit financing product. Net term less than 30 days
                *   5J: Should be used when a business is applying for a credit product and the you are checking credit of the sole guarantor of the business (Companies, corp or LLCs, etc)
                *   10: Should be used when the business owner is applying for a credit product (loan) and the business is a sole prop or partnership where the owner has personal liability
                */
                    if (null != naApplicant.Legal_Structure__c && (naApplicant.Legal_Structure__c.equals('Proprietorship') || naApplicant.Legal_Structure__c.equals('Partnership'))) {
                        experianRequest.accountPurposeCode = '10';
                    } else {
                        experianRequest.accountPurposeCode = '5J';
                    }

                    experianRequest.socialSecurityNumber = naApplicant.Personal_Guarantor_SSN__c;
                    experianRequest.contactFirstName = naApplicant.Personal_Guarantor_First_Name__c;
                    experianRequest.contactLastName = naApplicant.Personal_Guarantor_Last_Name__c;
                    experianRequest.address = naApplicant.Personal_Guarantor_Mailing_Street__c;
                    experianRequest.city = naApplicant.Personal_Guarantor_Mailing_City__c;
                    experianRequest.state = naApplicant.Personal_Guarantor_Mailing_State__c;
                    experianRequest.zipCode = naApplicant.Personal_Guarantor_Mailing_Zip__c;
                    experianRequest.phone = naApplicant.Personal_Guarantor_Home_Phone__c;
                    if (naApplicant.Personal_Guarantor_DOB__c != null) {
                        experianRequest.dateOfBirthMonth = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.month()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthDay = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.day()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthYear = String.valueOf(naApplicant.Personal_Guarantor_DOB__c.year());
                    }

                    CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));

                    if (experianResponse != null) {
                        naApplicant.PG_FICO_Score__c = experianResponse.creditScore;
                        naApplicant.PG_Data__c = experianResponse.experianData;
                        naApplicant.Experian_Premier_Attributes__c = experianResponse.premierAtrributes;
                        naApplicant.Experian_Premier_Attribute_Codes__c = experianResponse.premierAttributeCodes;
                        naApplicant.PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                        naApplicant.Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                        naApplicant.Security_Statement_on_Report__c = experianResponse.securityStatement;
                        naApplicant.On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;
                    }
                    else if (experianResponse == null || experianResponse.calloutFailed) {
                        System.debug('Experian callout failed. Response: ' + experianResponse);
                        naApplicant.PG_Data__c = 'Callout Failed';
                    }
                }

                upsert naApplicant;
                CreditDecisionEngineNA.runFinalCreditDecision(naApplicant);
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