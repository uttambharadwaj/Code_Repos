/**
 * Created by dgilbert on 5/14/2018.
 */

/** The purpose of this class is to potentially find duplicate applications or accounts based on the current application being submitted.
     */
public with sharing class CreditUtil_ExistingExposure {

    /** Things have gotten a little complicated.
    * First a list of potentially duplicate applications are gathered. The business name and address need to be at least a 75% match to the
    * potential existing application to be considered a duplicate.
     */
    public static List<ExistingExposureApplications> getApplications(ExistingExposureRequest request) {

        List<ExistingExposureApplications> existingExposureApplications = new List<ExistingExposureApplications>();

        if(request.legalBusinessName != null && (request.legalBusinessName).length() > 10){
            request.legalBusinessName = (request.legalBusinessName).subString(0, 10) + '%';
        }
        if(request.postalCode != null) {
            request.postalCode = request.postalCode + '%';
        }

        if(((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

            List<OnlineApplication__c> existingAPplications = getOTRExistingApplications(request);

            for (OnlineApplication__c existingApplication : existingAPplications) {

                if((JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Legal_Business_Name__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Business_Street_Address__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.State__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Zip_Code__c) >= 0.75)
                        || (JaroWinklerDistance.getScore(request.ipAddress, existingApplication.IP_Address__c) == 1.00)
                        || (request.duns != null && (JaroWinklerDistance.getScore(request.duns, existingApplication.DNB_Resolved_DUNS__c)) == 1.00)
                        || (JaroWinklerDistance.getScore(request.taxID, existingApplication.Federal_Tax_ID__c) == 1.00)
                        || (JaroWinklerDistance.getScore(request.phone, existingApplication.Phone_Number__c) == 1.00)) {

                    ExistingExposureApplications duplicateApplication = new ExistingExposureApplications();

                    duplicateApplication.applicationId = existingApplication.Id;
                    duplicateApplication.applicationName = existingApplication.Name;
                    duplicateApplication.legalBusinessName = existingApplication.Legal_Business_Name__c;
                    duplicateApplication.addressLine1 = existingApplication.Business_Street_Address__c;
                    duplicateApplication.city = existingApplication.City__c;
                    duplicateApplication.state = existingApplication.State__c;
                    duplicateApplication.postalCode = existingApplication.Zip_Code__c;
                    duplicateApplication.applicationStatus = existingApplication.Status__c;
                    duplicateApplication.creditDecision = existingApplication.Credit_Decision__c;
                    duplicateApplication.taxId = existingApplication.Federal_Tax_ID__c;
                    duplicateApplication.pgSSN = existingApplication.AO_Social_Security_Number__c;
                    duplicateApplication.program = existingApplication.Program__c;
                    duplicateApplication.fraudFlag = existingApplication.Fraud_Flag__c;
                    duplicateApplication.duns = existingApplication.DNB_Resolved_DUNS__c;
                    duplicateApplication.phone = existingApplication.Phone_Number__c;
                    duplicateApplication.ipAddress = existingApplication.IP_Address__c;
                    if (null != existingApplication.Submitted_to_Credit__c) {
                        duplicateApplication.applicationCreatedDate = date.newInstance(existingApplication.Submitted_to_Credit__c.year(), existingApplication.Submitted_to_Credit__c.month(), existingApplication.Submitted_to_Credit__c.day());
                    }
                    duplicateApplication.creditLineRequested = String.valueOf(existingApplication.Credit_Line_Requested__c);
                    duplicateApplication.creditLineApproved = String.valueOf(existingApplication.Credit_Line_Approved__c);
                    if (null != existingApplication.Date_Decisioned__c) {
                        duplicateApplication.applicationDecisionedDate = date.newInstance(existingApplication.Date_Decisioned__c.year(), existingApplication.Date_Decisioned__c.month(), existingApplication.Date_Decisioned__c.day());
                    }

                    existingExposureApplications.add(duplicateApplication);
                }

            }

        }
        else if(((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

            List<CP_Application_Request__c> existingAPplications = getCPExistingApplications(request);

            for (CP_Application_Request__c existingApplication : existingAPplications) {

                if((JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Company_Legal_Name__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Physical_Address_Line_1__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.Physical_City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.Physical_State__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Physical_Postal_Code__c) >= 0.75)
                        || (JaroWinklerDistance.getScore(request.ipAddress, existingApplication.Application_Signer_IP_Address__c) == 1.00)
                        || (request.duns != null && (JaroWinklerDistance.getScore(request.duns, existingApplication.DNB_Resolved_DUNS__c)) == 1.00)
                       // || (JaroWinklerDistance.getScore(request.taxID, existingApplication.Taxpayer_ID__c) == 1.00) // Cannot query matches on encrypted fields
                        || (JaroWinklerDistance.getScore(request.phone, existingApplication.Business_Phone__c) == 1.00)) {

                    ExistingExposureApplications duplicateApplication = new ExistingExposureApplications();

                    duplicateApplication.applicationId = existingApplication.Id;
                    duplicateApplication.applicationName = existingApplication.Name;
                    duplicateApplication.legalBusinessName = existingApplication.Company_Legal_Name__c;
                    duplicateApplication.addressLine1 = existingApplication.Physical_Address_Line_1__c;
                    duplicateApplication.city = existingApplication.Physical_City__c;
                    duplicateApplication.state = existingApplication.Physical_State__c;
                    duplicateApplication.postalCode = existingApplication.Physical_Postal_Code__c;
                    duplicateApplication.applicationStatus = existingApplication.Status__c;
                    duplicateApplication.creditDecision = existingApplication.Credit_Decision__c;
                    duplicateApplication.taxId = existingApplication.Taxpayer_ID__c;
                    duplicateApplication.pgSSN = existingApplication.Guarantor_Social_Security_Number__c;
                    duplicateApplication.program = existingApplication.Program__c;
                    duplicateApplication.fraudFlag = existingApplication.Fraud_Flag__c;
                    duplicateApplication.duns = existingApplication.DNB_Resolved_DUNS__c;
                    duplicateApplication.phone = existingApplication.Business_Phone__c;
                    duplicateApplication.ipAddress = existingApplication.Application_Signer_IP_Address__c;
                    duplicateApplication.creditLineRequested = String.valueOf(existingApplication.Credit_Line_Requested__c);
                    duplicateApplication.creditLineApproved = String.valueOf(existingApplication.Credit_Line_Approved__c);
                    duplicateApplication.applicationDecisionedDate = existingApplication.Application_Decisioned_Date__c;

                    existingExposureApplications.add(duplicateApplication);

                }

            }

        }
        else if(((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

            for(Application_Request__c existingApplication : [SELECT Id, CreatedDate, Name, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c,
                    Credit_Decision__c, Status__c, App_Submitted_Date__c, Tax_Payer_ID_number__c, Guarantor_SSN__c, Program__c, Fraud_Flag__c, Credit_Line_Requested__c, Approved_Credit_Limit__c, Decision_Date__c
            FROM Application_Request__c
            WHERE Opportunity_Name_Text__c like :request.legalBusinessName and Physical_Zip_Postal_Code__c like :request.postalCode and Id !=: request.applicationId]) {

                if(JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Opportunity_Name_Text__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Physical_Street__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.Physical_City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.Physical_State__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Physical_Zip_Postal_Code__c) >= 0.75) {

                    ExistingExposureApplications duplicateApplication = new ExistingExposureApplications();

                    duplicateApplication.applicationId = existingApplication.Id;
                    duplicateApplication.applicationName = existingApplication.Name;
                    duplicateApplication.legalBusinessName = existingApplication.Opportunity_Name_Text__c;
                    duplicateApplication.addressLine1 = existingApplication.Physical_Street__c;
                    duplicateApplication.city = existingApplication.Physical_City__c;
                    duplicateApplication.state = existingApplication.Physical_State__c;
                    duplicateApplication.postalCode = existingApplication.Physical_Zip_Postal_Code__c;
                    duplicateApplication.applicationStatus = existingApplication.Status__c;
                    duplicateApplication.creditDecision = existingApplication.Credit_Decision__c;
                    duplicateApplication.taxId = existingApplication.Tax_Payer_ID_number__c;
                    duplicateApplication.pgSSN = existingApplication.Guarantor_SSN__c;
                    duplicateApplication.program = existingApplication.Program__c;
                    duplicateApplication.fraudFlag = existingApplication.Fraud_Flag__c;
                    duplicateApplication.creditLineRequested = String.valueOf(existingApplication.Credit_Line_Requested__c);
                    duplicateApplication.creditLineApproved = String.valueOf(existingApplication.Approved_Credit_Limit__c);
                    duplicateApplication.applicationDecisionedDate = existingApplication.Decision_Date__c;

                    existingExposureApplications.add(duplicateApplication);

                }

            }

        }

        return existingExposureApplications;

    }

    /** OTR
    * Dynamically create the query based on whether or not a DUNS number was provided. Each unindexed OR clause slows down the query.
    * Often DUNS is null so let's only look for a match on DUNS when needed.
     */
    private static List<OnlineApplication__c> getOTRExistingApplications(ExistingExposureRequest request) {

        String whereClause = ' WHERE Id != \'' + request.applicationId + '\' AND (' +
                '(Legal_Business_Name__c like \'' + request.legalBusinessName + '\' AND Zip_Code__c like \'' + request.postalCode + '\')' +
                ' OR IP_Address__c = \'' + request.ipAddress + '\'' +
                ' OR Federal_Tax_ID__c = \'' + request.taxID + '\'' +
                ' OR Phone_Number__c = \'' + request.phone + '\'';

        if (request.duns != null) {
            whereClause += ' OR DNB_Resolved_DUNS__c = \'' + request.duns + '\'';
        }

        whereClause += ')';

        String databaseQuery = 'SELECT Id, CreatedDate, Name, Legal_Business_Name__c, Business_Street_Address__c, City__c, State__c, Zip_Code__c,' +
                'Credit_Decision__c, Status__c, Federal_Tax_ID__c, AO_Social_Security_Number__c, Program__c, Fraud_Flag__c, Submitted_to_Credit__c, Credit_Line_Requested__c,' +
                'Credit_Line_Approved__c, Date_Decisioned__c, DNB_Resolved_DUNS__c, Phone_Number__c, IP_Address__c' +
                ' FROM OnlineApplication__c' + whereClause;

        try {
            List<OnlineApplication__c> onlineApplications = Database.query(databaseQuery);
            return onlineApplications;
        } catch (QueryException qe) {
            System.debug('Error when attempting to locate potential existing exposure applications for OnlineApplication__c : ' + qe.getMessage());
        }
        return null;
    }

    /** CP
    * Dynamically create the query based on whether or not a DUNS number was provided. Each unindexed OR clause slows down the query.
    * Often DUNS is null so let's only look for a match on DUNS when needed.
     */
    private static List<CP_Application_Request__c> getCPExistingApplications(ExistingExposureRequest request) {

        String whereClause = ' WHERE Id != \'' + request.applicationId + '\' AND (' +
                '(Company_Legal_Name__c like \'' + request.legalBusinessName + '\' AND Physical_Postal_Code__c like \'' + request.postalCode + '\')' +
                ' OR Application_Signer_IP_Address__c = \'' + request.ipAddress + '\'' +
             //   ' OR Taxpayer_ID__c = \'' + request.taxID + '\'' +  // Cannot query matches on encrypted fields
                ' OR Business_Phone__c = \'' + request.phone + '\'';

        if (request.duns != null) {
            whereClause += ' OR DNB_Resolved_DUNS__c = \'' + request.duns + '\'';
        }

        whereClause += ')';

        String databaseQuery = 'SELECT Id, CreatedDate, Name, Company_Legal_Name__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State__c, Physical_Postal_Code__c, ' +
                'Credit_Decision__c, Status__c, Taxpayer_ID__c, Guarantor_Social_Security_Number__c, Program__c, Fraud_Flag__c, ' +
                'Credit_Line_Requested__c, Credit_Line_Approved__c, Application_Decisioned_Date__c, Application_Signer_IP_Address__c, Business_Phone__c, DNB_Resolved_DUNS__c' +
                ' FROM CP_Application_Request__c' + whereClause;

        try {
            List<CP_Application_Request__c> cpApplications = Database.query(databaseQuery);
            return cpApplications;
        } catch (QueryException qe) {
            System.debug('Error when attempting to locate potential existing exposure applications for CP_Application_Request__c : ' + qe.getMessage());
        }
        return null;
    }

    // This query was taking on average 11 seconds to run in production. Need to index these fields matching on or redesign
//    /** NA
//    * Dynamically create the query based on whether or not a DUNS number was provided. Each unindexed OR clause slows down the query.
//    * Often DUNS is null so let's only look for a match on DUNS when needed.
//     */
//    private static List<Application_Request__c> getNAExistingApplications(ExistingExposureRequest request) {
//
//        String whereClause = ' WHERE Id != \'' + request.applicationId + '\' AND (' +
//                '(Opportunity_Name_Text__c like \'' + request.legalBusinessName + '\' AND Physical_Zip_Postal_Code__c like \'' + request.postalCode + '\')' +
//                ' OR App_Signer_IP_Address__c = \'' + request.ipAddress + '\'' +
//                ' OR Tax_Payer_ID_number__c = \'' + request.taxID + '\'' +
//                ' OR Business_Phone_Number__c = \'' + request.phone + '\'';
//
//        if (request.duns != null) {
//            whereClause += ' OR DNB_Resolved_DUNS__c = \'' + request.duns + '\'';
//        }
//
//        whereClause += ')';
//
//        String databaseQuery = 'SELECT Id, CreatedDate, Name, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c, ' +
//                'Credit_Decision__c, Status__c, App_Submitted_Date__c, Tax_Payer_ID_number__c, Guarantor_SSN__c, Program__c, Fraud_Flag__c, Credit_Line_Requested__c, Approved_Credit_Limit__c, Decision_Date__c, ' +
//                'App_Signer_IP_Address__c, Business_Phone_Number__c, DNB_Resolved_DUNS__c'+
//                ' FROM Application_Request__c' + whereClause;
//
//        try {
//            List<Application_Request__c> naApplications = Database.query(databaseQuery);
//            return naApplications;
//        } catch (QueryException qe) {
//            System.debug('Error when attempting to locate potential existing exposure applications for Application_Request__c : ' + qe.getMessage());
//        }
//        return null;
//    }

    public static List<ExistingExposureAccounts> getAccounts(ExistingExposureRequest request) {

        List<ExistingExposureAccounts> existingExposureAccounts = new List<ExistingExposureAccounts>();

        if(request.legalBusinessName != null && (request.legalBusinessName).length() > 10){
            request.legalBusinessName = (request.legalBusinessName).subString(0, 10) + '%';
        }
        if(request.postalCode != null) {
            request.postalCode = request.postalCode + '%';
        }

        for(FSC_Existing_Exposure__c existingAccount : [SELECT Id, Name, Business_Name__c, Address__c, City__c, State_Province__c , Postal_Code__c, Credit_Limit__c, National_Account_Number__c, Account_Status__c,
                DUNS_Number__c
        FROM FSC_Existing_Exposure__c
        WHERE Business_Name__c like :request.legalBusinessName and Postal_Code__c like :request.postalCode]) {

            if(JaroWinklerDistance.getScore(request.legalBusinessName, existingAccount.Business_Name__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.addressLine1, existingAccount.Address__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.city, existingAccount.City__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.state, existingAccount.State_Province__c ) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.postalCode, existingAccount.Postal_Code__c) >= 0.75
                    || (request.duns != null && (JaroWinklerDistance.getScore(request.duns, existingAccount.DUNS_Number__c)) == 1.00)) {

                ExistingExposureAccounts existingExposureAccount = new ExistingExposureAccounts();

                existingExposureAccount.fscExistingExposureId = existingAccount.Id;
                existingExposureAccount.fscExistingExposureName = existingAccount.Name;
                existingExposureAccount.legalBusinessName = existingAccount.Business_Name__c;
                existingExposureAccount.addressLine1 = existingAccount.Address__c;
                existingExposureAccount.city = existingAccount.City__c;
                existingExposureAccount.state = existingAccount.State_Province__c;
                existingExposureAccount.postalCode = existingAccount.Postal_Code__c;
                existingExposureAccount.nationalId = existingAccount.National_Account_Number__c;
                existingExposureAccount.creditLine = String.valueOf(existingAccount.Credit_Limit__c);
                existingExposureAccount.accountStatus = existingAccount.Account_Status__c;
                existingExposureAccount.duns = existingAccount.DUNS_Number__c;

                existingExposureAccounts.add(existingExposureAccount);

            }

        }

        return existingExposureAccounts;

    }

    public class ExistingExposureRequest {

        public String applicationId { get; set; }
        public String applicationName { get; set; }
        public String legalBusinessName { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public Boolean fraudFlag { get; set; }
        public String duns { get; set; }
        public String taxID { get; set; }
        public String phone { get; set; }
        public String pgSSN { get; set; }
        public String ipAddress { get; set; }
    }

    public class ExistingExposureApplications {

        public String applicationId { get; set; }
        public String applicationName { get; set; }
        public String applicationStatus { get; set; }
        public Date applicationCreatedDate{ get; set; }
        public String creditLineRequested { get; set; }
        public String creditLineApproved { get; set; }
        public String creditDecision { get; set; }
        public Date applicationDecisionedDate { get; set; }
        public String legalBusinessName { get; set; }
        public String addressLine1 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String taxId { get; set; }
        public String pgSSN { get; set; }
        public String program { get; set; }
        public Boolean fraudFlag { get; set; }
        public String duns { get; set; }
        public String phone { get; set; }
        public String ipAddress { get; set; }
    }

    public class ExistingExposureAccounts {

        public String fscExistingExposureId { get; set; }
        public String fscExistingExposureName { get; set; }
        public String legalBusinessName { get; set; }
        public String addressLine1 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String nationalId { get; set; }
        public String creditLine { get; set; }
        public String accountStatus { get; set; }
        public String duns { get; set; }
    }

}