/**
 * Created by lhowland on 7/24/2018.
 */

global with sharing class PGIntegrationButton {

    public class CustomException extends Exception {}

    webService static void requestPGCreditScore(Id appId) {

        String objectType = appID.getSobjectType().getDescribe().getName();

        if (objectType.equalsIgnoreCase('OnlineApplication__c')) {

            System.debug('Online App ID: ' + appID);
            List<OnlineApplication__c> appInfo = [
                    SELECT Id, Contact_First_Name__c, Contact_Last_Name__c, Contact_Name__c, AO_Name__c,AO_First_Name__c, AO_Last_Name__c, AO_Address__c, AO_City__c, AO_State__c, AO_Zip_Code__c, AO_Home_Phone_Number__c,
                            AO_Date_of_Birth__c, AO_Social_Security_Number__c, Type_of_Business__c, PG_Score__c, Experian_Premier_Attributes__c, PG_High_Credit_Amount__c,
                            Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c, PG_Data__c
                    FROM OnlineApplication__c
                    where Id = :appID
            ];
            
            CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();
            OnlineApplication__c app = null;

            try {
                if (appInfo.size() == 1) {
                    app = appInfo[0];
                    experianRequest.socialSecurityNumber = app.AO_Social_Security_Number__c;
                    if (null == app.AO_First_Name__c && null == app.AO_Last_Name__c && null != app.AO_Name__c) {
                        experianRequest.contactFirstName = (app.AO_Name__c).split(' ')[0];
                        experianRequest.contactLastName = (app.AO_Name__c).split(' ')[1];
                    } else {
                        experianRequest.contactFirstName = app.AO_First_Name__c;
                        experianRequest.contactLastName = app.AO_Last_Name__c;
                    }
                    experianRequest.address = app.AO_Address__c;
                    experianRequest.city = app.AO_City__c;
                    experianRequest.state = app.AO_State__c;
                    experianRequest.zipCode = app.AO_Zip_Code__c;
                    experianRequest.phone = app.AO_Home_Phone_Number__c;
                    experianRequest.dateOfBirthMonth = String.valueOf(app.AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                    experianRequest.dateOfBirthDay = String.valueOf(app.AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                    experianRequest.dateOfBirthYear = String.valueOf(app.AO_Date_of_Birth__c.year());

                    if (null != app.Type_of_Business__c && (app.Type_of_Business__c.equals('Sole Proprietorship') || app.Type_of_Business__c.equals('Partnership'))) {
                        experianRequest.accountPurposeCode = '10';
                    } else {
                        experianRequest.accountPurposeCode = '5J';
                    }
                }

                CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));
                System.debug('FICO Score ----------' + experianResponse.creditScore);
                appInfo[0].PG_Score__c = experianResponse.creditScore;
                appInfo[0].PG_Data__c = experianResponse.experianData;
                appInfo[0].Experian_Premier_Attributes__c = experianResponse.premierAtrributes;
                appInfo[0].PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                appInfo[0].Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                appInfo[0].Security_Statement_on_Report__c = experianResponse.securityStatement;
                appInfo[0].On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;

                upsert appInfo[0];

                // Make a safe copy so we don't overwrite any fields
                appInfo = [SELECT Id, Running_Credit_Decisioning__c FROM OnlineApplication__c WHERE Id = :appID];

                if(appInfo.size() > 0) {

                    // Flag the Credit Decision Engine as not running
                    appInfo[0].Running_Credit_Decisioning__c = false;

                    upsert appInfo[0];
                }
            } catch (Exception e) {
                System.debug('No credit info found for application id: ' + appId);
            }
        }

        else if (objectType.equalsIgnoreCase('CP_Application_Request__c')) {

            System.debug('Corporate Payments App ID: ' + appID);
            List<CP_Application_Request__c> appInfo = [
                    SELECT Id, Guarantor_First_Name__c, Guarantor_Last_Name__c, Guarantor_Residential_Address__c, Guarantor_Residential_City__c, Guarantor_Residential_State__c,
                            Guarantor_Residential_Postal_Code__c, Guarantor_Residential_Country__c, Guarantor_Residential_Phone__c, Guarantor_Date_of_Birth__c, Guarantor_Social_Security_Number__c,
                            Legal_Structure__c, PG_FICO_Score__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c, PG_Data__c
                    FROM CP_Application_Request__c
                    where Id = :appID
            ];

            if (appInfo.size() == 1) {

                if (appInfo[0].Guarantor_Residential_Country__c != null && appInfo[0].Guarantor_Residential_Country__c.equalsIgnoreCase('US')) {

                    CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();
                    CP_Application_Request__c app = null;

                    try {
                        app = appInfo[0];
                        experianRequest.socialSecurityNumber = app.Guarantor_Social_Security_Number__c;
                        experianRequest.contactFirstName = app.Guarantor_First_Name__c;
                        experianRequest.contactLastName = app.Guarantor_Last_Name__c;
                        experianRequest.address = app.Guarantor_Residential_Address__c;
                        experianRequest.city = app.Guarantor_Residential_City__c;
                        experianRequest.state = app.Guarantor_Residential_State__c;
                        experianRequest.zipCode = app.Guarantor_Residential_Postal_Code__c;
                        experianRequest.phone = app.Guarantor_Residential_Phone__c;
                        experianRequest.dateOfBirthMonth = String.valueOf(app.Guarantor_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthDay = String.valueOf(app.Guarantor_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthYear = String.valueOf(app.Guarantor_Date_of_Birth__c.year());

                        if (null != app.Legal_Structure__c && (app.Legal_Structure__c.equals('Sole Proprietorship') || app.Legal_Structure__c.equals('Partnership'))) {
                            experianRequest.accountPurposeCode = '10';
                        } else {
                            experianRequest.accountPurposeCode = '5J';
                        }

                        CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));
                        System.debug('FICO Score ----------' + experianResponse.creditScore);
                        appInfo[0].PG_FICO_Score__c = experianResponse.creditScore;
                        appInfo[0].PG_Data__c = experianResponse.experianData;
                        appInfo[0].Experian_Premier_Attributes__c = experianResponse.premierAtrributes;
                        appInfo[0].PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                        appInfo[0].Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                        appInfo[0].Security_Statement_on_Report__c = experianResponse.securityStatement;
                        appInfo[0].On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;

                        upsert appInfo[0];

                        // Make a safe copy so we don't overwrite any fields
                        appInfo = [SELECT Id, Running_Credit_Decisioning__c FROM CP_Application_Request__c WHERE Id = :appID];

                        if(appInfo.size() > 0) {

                            // Flag the Credit Decision Engine as not running
                            appInfo[0].Running_Credit_Decisioning__c = false;

                            upsert appInfo[0];
                        }
                    } catch (Exception e) {
                        System.debug('Issue with data for Experian callout for application Id: ' + appId);
                    }
                }
                else if (appInfo[0].Guarantor_Residential_Country__c != null && appInfo[0].Guarantor_Residential_Country__c.equalsIgnoreCase('CA')) {

                    CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();
                    CP_Application_Request__c app = null;

                    try {
                        app = appInfo[0];
                        equifaxRequest.socialInsuranceNumber = app.Guarantor_Social_Security_Number__c;
                        equifaxRequest.firstName = app.Guarantor_First_Name__c;
                        equifaxRequest.lastName = app.Guarantor_Last_Name__c;
                        equifaxRequest.address = app.Guarantor_Residential_Address__c;
                        equifaxRequest.city = app.Guarantor_Residential_City__c;
                        equifaxRequest.province = app.Guarantor_Residential_State__c;
                        equifaxRequest.postalCode = app.Guarantor_Residential_Postal_Code__c;
                        equifaxRequest.phone = app.Guarantor_Residential_Phone__c;
                        equifaxRequest.dateOfBirthMonth = String.valueOf(app.Guarantor_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthDay = String.valueOf(app.Guarantor_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthYear = String.valueOf(app.Guarantor_Date_of_Birth__c.year());

                        CreditWS_Equifax.EquifaxResponse equifaxeResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));
                        System.debug('FICO Score ----------' + equifaxeResponse.creditScore);
                        appInfo[0].PG_FICO_Score__c = equifaxeResponse.creditScore;
                        appInfo[0].PG_Data__c = equifaxeResponse.equifaxData;
                        appInfo[0].PG_High_Credit_Amount__c = equifaxeResponse.pgHighCredit;

                        upsert appInfo[0];

                        // Make a safe copy so we don't overwrite any fields
                        appInfo = [SELECT Id, Running_Credit_Decisioning__c FROM CP_Application_Request__c WHERE Id = :appID];

                        if(appInfo.size() > 0) {

                            // Flag the Credit Decision Engine as not running
                            appInfo[0].Running_Credit_Decisioning__c = false;

                            upsert appInfo[0];
                        }
                    } catch (Exception e) {
                        System.debug('Issue with data for Equifax callout for application Id: ' + appId);
                    }
                }
            }
            else {
                System.debug('No application found for application Id: ' + appId);
            }
        }

        else if (objectType.equalsIgnoreCase('Application_Request__c')) {

            System.debug('NA Fleet App ID: ' + appID);
            List<Application_Request__c> appInfo = [
                    SELECT Id, Personal_Guarantor_First_Name__c, Personal_Guarantor_Last_Name__c, Personal_Guarantor_Mailing_Street__c, Personal_Guarantor_Mailing_City__c, Personal_Guarantor_Mailing_State__c,
                            Personal_Guarantor_Mailing_Zip__c, Personal_Guarantor_Mailing_Country__c, Personal_Guarantor_Home_Phone__c, Personal_Guarantor_DOB__c, Personal_Guarantor_SSN__c, PG_Data__c,
                            Legal_Structure__c, PG_FICO_Score__c, Experian_Premier_Attributes__c, Experian_Premier_Attribute_Codes__c, PG_High_Credit_Amount__c, Inquiry_Address_High_Risk__c, Security_Statement_on_Report__c, On_File_Address_High_Risk__c
                    FROM Application_Request__c
                    where Id = :appID
            ];

            if (appInfo.size() == 1) {

                System.debug('TEMP here before callout and country = ' + appInfo[0].Personal_Guarantor_Mailing_Country__c);

                if (appInfo[0].Personal_Guarantor_Mailing_Country__c != null && appInfo[0].Personal_Guarantor_Mailing_Country__c.equalsIgnoreCase('US')) {

                    CreditWS_Experian.ExperianRequest experianRequest = new CreditWS_Experian.ExperianRequest();
                    Application_Request__c app = null;

                    try {
                        app = appInfo[0];
                        experianRequest.socialSecurityNumber = app.Personal_Guarantor_SSN__c;
                        experianRequest.contactFirstName = app.Personal_Guarantor_First_Name__c;
                        experianRequest.contactLastName = app.Personal_Guarantor_Last_Name__c;
                        experianRequest.address = app.Personal_Guarantor_Mailing_Street__c;
                        experianRequest.city = app.Personal_Guarantor_Mailing_City__c;
                        experianRequest.state = app.Personal_Guarantor_Mailing_State__c;
                        experianRequest.zipCode = app.Personal_Guarantor_Mailing_Zip__c;
                        experianRequest.phone = app.Personal_Guarantor_Home_Phone__c;
                        experianRequest.dateOfBirthMonth = String.valueOf(app.Personal_Guarantor_DOB__c.month()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthDay = String.valueOf(app.Personal_Guarantor_DOB__c.day()).leftPad(2).replace(' ', '0');
                        experianRequest.dateOfBirthYear = String.valueOf(app.Personal_Guarantor_DOB__c.year());
                        
                        if (app.Legal_Structure__c.equals('Sole Proprietorship') || app.Legal_Structure__c.equals('Partnership')) {
                            experianRequest.accountPurposeCode = '10';
                        } else {
                            experianRequest.accountPurposeCode = '5J';
                        }                
        
                        CreditWS_Experian.ExperianResponse experianResponse = CreditWS_Experian.getCreditScore((experianRequest));
                        System.debug('FICO Score ----------' + experianResponse.creditScore);
                        appInfo[0].PG_FICO_Score__c = experianResponse.creditScore;
                        appInfo[0].PG_Data__c = experianResponse.experianData;
                        appInfo[0].Experian_Premier_Attributes__c = experianResponse.premierAtrributes;
                        appInfo[0].Experian_Premier_Attribute_Codes__c = experianResponse.premierAttributeCodes;
                        appInfo[0].PG_High_Credit_Amount__c = experianResponse.pgHighCredit;
                        appInfo[0].Inquiry_Address_High_Risk__c = experianResponse.inquiryAddressHighRisk;
                        appInfo[0].Security_Statement_on_Report__c = experianResponse.securityStatement;
                        appInfo[0].On_File_Address_High_Risk__c = experianResponse.onFileAddressHighRisk;
        
                        upsert appInfo[0];
        
                        // Make a safe copy so we don't overwrite any fields
                        appInfo = [SELECT Id, Running_Credit_Decisioning__c FROM Application_Request__c WHERE Id = :appID];
        
                        if(appInfo.size() > 0) {
        
                            // Flag the Credit Decision Engine as not running
                            appInfo[0].Running_Credit_Decisioning__c = false;
        
                            upsert appInfo[0];
                        }
                    } catch (Exception e) {
                        System.debug('Issue with data for Experian callout for application Id: ' + appId);
                    }
                }
                else if (appInfo[0].Personal_Guarantor_Mailing_Country__c != null && appInfo[0].Personal_Guarantor_Mailing_Country__c.equalsIgnoreCase('CA')) {
                    
                    CreditWS_Equifax.EquifaxRequest equifaxRequest = new CreditWS_Equifax.EquifaxRequest();
                    Application_Request__c app = null;
        
                    try {                
                        app = appInfo[0];
                        equifaxRequest.socialInsuranceNumber = app.Personal_Guarantor_SSN__c;
                        equifaxRequest.firstName = app.Personal_Guarantor_First_Name__c;
                        equifaxRequest.lastName = app.Personal_Guarantor_Last_Name__c;
                        equifaxRequest.address = app.Personal_Guarantor_Mailing_Street__c;
                        equifaxRequest.city = app.Personal_Guarantor_Mailing_City__c;
                        equifaxRequest.province = app.Personal_Guarantor_Mailing_State__c;
                        equifaxRequest.postalCode = app.Personal_Guarantor_Mailing_Zip__c;
                        equifaxRequest.phone = app.Personal_Guarantor_Home_Phone__c;
                        equifaxRequest.dateOfBirthMonth = String.valueOf(app.Personal_Guarantor_DOB__c.month()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthDay = String.valueOf(app.Personal_Guarantor_DOB__c.day()).leftPad(2).replace(' ', '0');
                        equifaxRequest.dateOfBirthYear = String.valueOf(app.Personal_Guarantor_DOB__c.year());
                                       
                        CreditWS_Equifax.EquifaxResponse equifaxResponse = CreditWS_Equifax.getCreditScore((equifaxRequest));
                        System.debug('FICO Score ----------' + equifaxResponse.creditScore);
                        appInfo[0].PG_FICO_Score__c = equifaxResponse.creditScore;
                        appInfo[0].PG_Data__c = equifaxResponse.equifaxData;
                        appInfo[0].PG_High_Credit_Amount__c = equifaxResponse.pgHighCredit;
        
                        upsert appInfo[0];
        
                        // Make a safe copy so we don't overwrite any fields
                        appInfo = [SELECT Id, Running_Credit_Decisioning__c FROM Application_Request__c WHERE Id = :appID];
        
                        if(appInfo.size() > 0) {
        
                            // Flag the Credit Decision Engine as not running
                            appInfo[0].Running_Credit_Decisioning__c = false;
        
                            upsert appInfo[0];
                        }
                    } catch (Exception e) {
                        System.debug('Issue with data for Equifax callout for application Id: ' + appId);
                    }
                }
            } 
            else {
                System.debug('No application found for application Id: ' + appId);
            }
        }
    }

}