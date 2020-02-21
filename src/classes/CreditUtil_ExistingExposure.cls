/**
 * Created by dgilbert on 5/14/2018.
 * Refactored and added additional match criteria by lhowland on 5/1/2019.
*/

/** The purpose of this class is to potentially find duplicate applications and accounts based on the current application being submitted.
     */
public without sharing class CreditUtil_ExistingExposure {

    private static List<Id> appIds = new List<Id>();
    // The list of application Status that we want to include in what we consider as existing exposure
    private static Set<String> NAFLEET_APP_STATUSES = new Set<String>{'Application Complete', 'Decisioned', 'Implementation Complete', 'Pending Implementation'};
    private static Set<String> OTR_APP_STATUSES = new Set<String>{'Closed/Fraud','Decisioned-Rereview', 'Decisioned', 'Pending Setup','Pending Setup Data','Pending Setup-Generic','Setup Complete','Cards Produced','Cards Shipped','Approved','Prepay','Prepay Requested','Declined','Audit Complete'};
    private static Set<String> CP_APP_STATUSES = new Set<String>{'Application Complete','Cards Produced', 'Cards Shipped','Implementation Complete','Pending Implementation','Pending Setup Data','Pending Setup-Generic','Setup Complete','Audit Complete','Saved - Rereview'};

    /** Things have gotten a little complicated.
    * First a list of potentially duplicate applications are gathered. The business name and address need to be at least a 75% match to the
    * potential existing application to be considered a duplicate.
     */
    public static List<ExistingExposureApplications> getApplications(ExistingExposureRequest request) {

        List<ExistingExposureApplications> existingExposureApplications = new List<ExistingExposureApplications>();
        List<List<SObject>> existingApplications = new List<List<SObject>>();
        appIds.add(request.applicationId);

        // Add FIND wildcard onto business name if longer than 10 chars
        if(request.legalBusinessName != null && (request.legalBusinessName).length() > 10){
            request.legalBusinessName = (request.legalBusinessName).subString(0, 10) + '*';
        }
        if (request.postalCode != null && (request.postalCode).length() > 5) {
            request.postalCode = request.postalCode.substring(0,5) + '*';
        }

        if(((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

            existingApplications = getOTRExistingApplications(request);

        }
        else if (((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

            existingApplications = getNAFleetExistingApplications(request);

        }
        else if (((Id.valueOf(request.applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

            existingApplications = getCPExistingApplications(request);
        }

        if (existingApplications.size() >= 2) {
            existingExposureApplications = getOTRAppMatches(existingApplications[0], request, existingExposureApplications);
            existingExposureApplications = getNAFleetAppMatches(existingApplications[1], request, existingExposureApplications);
            existingExposureApplications = getCPAppMatches(existingApplications[2], request, existingExposureApplications);
        }

        return existingExposureApplications;

    }


    /** For any given list of OnlineApplication__c, find the existing applications that meet the matching criteria
     */
    private static List<ExistingExposureApplications> getOTRAppMatches(List<OnlineApplication__c> existingApplications, ExistingExposureRequest request, List<ExistingExposureApplications> existingExposureApplications) {

        for (OnlineApplication__c existingApplication : existingApplications) {

            // Consider the application for existing exposure if it was created under 12 months ago OR was flagged for fraud
            if (existingApplication.CreatedDate > System.now().addMonths(-12) || existingApplication.Fraud_Flag__c) {

                // Consider existing exposure if the business is a 75% match compared the to current application
                // OR the DUNS # matches the current application
                // OR the business phone matches the current application
                // OR the PG SSN matches the current application
                if ((JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Legal_Business_Name__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Business_Street_Address__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.State__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Zip_Code__c) >= 0.75)
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
                    if (null != existingApplication.Submitted_to_Credit__c) {
                        duplicateApplication.applicationCreatedDate = Date.newInstance(existingApplication.Submitted_to_Credit__c.year(), existingApplication.Submitted_to_Credit__c.month(), existingApplication.Submitted_to_Credit__c.day());
                    }
                    duplicateApplication.creditLineRequested = String.valueOf(existingApplication.Credit_Line_Requested__c);
                    duplicateApplication.creditLineApproved = String.valueOf(existingApplication.Credit_Line_Approved__c);
                    if (null != existingApplication.Date_Decisioned__c) {
                        duplicateApplication.applicationDecisionedDate = Date.newInstance(existingApplication.Date_Decisioned__c.year(), existingApplication.Date_Decisioned__c.month(), existingApplication.Date_Decisioned__c.day());
                    }

                    existingExposureApplications.add(duplicateApplication);
                }
            }
        }
        return existingExposureApplications;
    }

    /** For any given list of Application_Request__c, find the existing applications that meet the matching criteria
  */
    private static List<ExistingExposureApplications> getNAFleetAppMatches(List<Application_Request__c> existingExposuirApps, ExistingExposureRequest request, List<ExistingExposureApplications> existingExposureApplications) {

        for(Application_Request__c existingApplication : existingExposuirApps) {

            // Consider the application for existing exposure if it was created under 12 months ago OR was flagged for fraud
            if (existingApplication.CreatedDate > System.now().addMonths(-12) || existingApplication.Fraud_Flag__c) {

                // Consider existing exposure if the business is a 75% match compared the to current application
                // OR the DUNS # matches the current application
                // OR the business phone matches the current application
                // OR the PG SSN matches the current application
                if (JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Opportunity_Name_Text__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Physical_Street__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.Physical_City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.Physical_State__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Physical_Zip_Postal_Code__c) >= 0.75
                        || (request.duns != null && (JaroWinklerDistance.getScore(request.duns, existingApplication.DNB_Resolved_DUNS__c)) == 1.00)
                        || (JaroWinklerDistance.getScore(request.taxID, existingApplication.Tax_Payer_ID_number__c) == 1.00)
                        || (JaroWinklerDistance.getScore(request.phone, existingApplication.Business_Phone_Number__c) == 1.00)
                        || (request.pgSSN != null && (JaroWinklerDistance.getScore(request.pgSSN, existingApplication.Personal_Guarantor_SSN__c)) == 1.00)) {

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
                    duplicateApplication.pgSSN = existingApplication.Personal_Guarantor_SSN__c;
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

    /** For any given list of CP_Application_Request__c, find the existing applications that meet the matching criteria
  */
    private static List<ExistingExposureApplications> getCPAppMatches(List<CP_Application_Request__c> existingApplications, ExistingExposureRequest request, List<ExistingExposureApplications> existingExposureApplications) {

        for (CP_Application_Request__c existingApplication : existingApplications) {

            // Consider the application for existing exposure if it was created under 12 months ago OR was flagged for fraud
            if (existingApplication.CreatedDate > System.now().addMonths(-12) || existingApplication.Fraud_Flag__c) {

                // Consider existing exposure if the business is a 75% match compared the to current application
                // OR the DUNS # matches the current application
                // OR the business phone matches the current application
                // OR the PG SSN matches the current application
                if((JaroWinklerDistance.getScore(request.legalBusinessName, existingApplication.Company_Legal_Name__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.addressLine1, existingApplication.Physical_Address_Line_1__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.city, existingApplication.Physical_City__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.state, existingApplication.Physical_State_Province__c) >= 0.75 &&
                        JaroWinklerDistance.getScore(request.postalCode, existingApplication.Physical_Postal_Code__c) >= 0.75)
                        || (request.duns != null && (JaroWinklerDistance.getScore(request.duns, existingApplication.DNB_Resolved_DUNS__c)) == 1.00)
                        || (JaroWinklerDistance.getScore(request.phone, existingApplication.Business_Phone__c) == 1.00)
                        || (request.pgSSN != null && (JaroWinklerDistance.getScore(request.pgSSN, existingApplication.Guarantor_Social_Security_Number__c)) == 1.00)) {

                    ExistingExposureApplications duplicateApplication = new ExistingExposureApplications();

                    duplicateApplication.applicationId = existingApplication.Id;
                    duplicateApplication.applicationName = existingApplication.Name;
                    duplicateApplication.legalBusinessName = existingApplication.Company_Legal_Name__c;
                    duplicateApplication.addressLine1 = existingApplication.Physical_Address_Line_1__c;
                    duplicateApplication.city = existingApplication.Physical_City__c;
                    duplicateApplication.state = existingApplication.Physical_State_Province__c;
                    duplicateApplication.postalCode = existingApplication.Physical_Postal_Code__c;
                    duplicateApplication.applicationStatus = existingApplication.Status__c;
                    duplicateApplication.creditDecision = existingApplication.Credit_Decision__c;
                    duplicateApplication.taxId = existingApplication.Taxpayer_ID__c;
                    duplicateApplication.pgSSN = existingApplication.Guarantor_Social_Security_Number__c;
                    duplicateApplication.program = existingApplication.Program__c;
                    duplicateApplication.fraudFlag = existingApplication.Fraud_Flag__c;
                    duplicateApplication.duns = existingApplication.DNB_Resolved_DUNS__c;
                    duplicateApplication.phone = existingApplication.Business_Phone__c;
                    duplicateApplication.creditLineRequested = String.valueOf(existingApplication.Credit_Line_Requested__c);
                    duplicateApplication.creditLineApproved = String.valueOf(existingApplication.Credit_Line_Approved__c);
                    duplicateApplication.applicationDecisionedDate = existingApplication.Application_Decisioned_Date__c;

                    existingExposureApplications.add(duplicateApplication);
                }
            }
        }
        return existingExposureApplications;
    }

    /**
     *
     */
    private static List<List<SObject>> getOTRExistingApplications(ExistingExposureRequest request) {

        String onlineAppRequestSearchVariables = request.legalBusinessName + ' AND ' + request.addressLine1 + ' AND ' + request.city + ' AND ' + request.state + ' AND ' + request.postalCode;

        if (request.phone != null) {
            onlineAppRequestSearchVariables += ' OR ' + request.phone.replaceAll('\\D','');
        }

        if (request.taxID != null) {
            onlineAppRequestSearchVariables +=  ' OR ' + request.taxID.replaceAll('\\D','');
        }

        if (request.duns != null) {
            onlineAppRequestSearchVariables += ' OR ' + request.duns;
        }

        if (request.pgSSN != null) {
            onlineAppRequestSearchVariables += ' OR ' + request.pgSSN.replaceAll('\\D','');
        }

        return queryForAllLOBs(onlineAppRequestSearchVariables);
    }


    private static List<List<SObject>> getCPExistingApplications(ExistingExposureRequest request) {

        String cpAppRequestSearchVariables = request.legalBusinessName + ' AND ' + request.addressLine1 + ' AND ' + request.city + ' AND ' + request.state + ' AND ' + request.postalCode + ' OR ' + request.phone.replaceAll('\\D','');

        if (request.duns != null) {
            cpAppRequestSearchVariables += ' OR ' + request.duns;
        }

        if (request.pgSSN != null) {
            cpAppRequestSearchVariables += ' OR ' + request.pgSSN.replaceAll('\\D','');
        }

        return queryForAllLOBs(cpAppRequestSearchVariables);
    }


    /** Because SOSL doesn't support formula fields nor does it support lists or variables between OR operators, we need to do a little magical ghetto query hacking.
        PG SSN is a formula field, populated from the Contact. So we query all Contacts that match that value.
        Business Phone and Tax ID are formula fields, populated from the Account. So we query all Accounts that match those values.
        Then find the App Requests that have those Account IDs.
        Find the rest of the App Requests that meet the other Existing Exposure criteria.
        Combine lists and return only one complete list. */
    private static List<List<SObject>> getNAFleetExistingApplications(ExistingExposureRequest request) {

        List<SObject> existingExposureApps = new List<SObject>();
        Set<SObject> uniqueExistingExposureApps = null;
        List<List<SObject>> finalList = new List<List<SObject>>(3);

        try {
            // First, look for Contacts that have the same PG SSN, then find the App Request with those Contact Ids.
            List<SObject> appRequestWIthPGSSNMatch = new List<SObject>();
            if (request.pgSSN != null) {
                appRequestWIthPGSSNMatch = getAppRequestViaPGSSN(request);
            }

            // Second, look for Accounts that have the same phone or tax id, then find the App Requests with those Account Ids.
            List<SObject> appRequestWithPhoneOrTaxMatch = getAppRequestsViaPhoneOrTax(request);

            existingExposureApps.addAll(appRequestWIthPGSSNMatch);
            existingExposureApps.addAll(appRequestWithPhoneOrTaxMatch);

            // Remove duplicates
            uniqueExistingExposureApps = new Set<SObject>(existingExposureApps);

            // Lastly, query for the Application Requests that match the remaining existing exposure criteria
            String appRequestSearchVariables = request.legalBusinessName + ' AND ' + request.addressLine1 + ' AND ' + request.city + ' AND ' + request.state + ' AND ' + request.postalCode;

            if (request.duns != null) {
                appRequestSearchVariables += ' OR ' + request.duns;
            }

            finalList = queryForAllLOBs(appRequestSearchVariables);

            // [0] = OTR, [1] = NA, [2] = CP
            if (uniqueExistingExposureApps.size() > 0 && finalList.size() > 0) {

                finalList[1].addAll(uniqueExistingExposureApps);
            }

        } catch (System.QueryException e) {
            System.debug('Error when running Existing Exposure applications for NA Fleet : ' + e);
        }
        return finalList;
    }


    /**
      Because PG SSN is a formula field on the App Request, we must locate the value off of the Contact.
     */
    private static List<SObject> getAppRequestViaPGSSN(ExistingExposureRequest request) {

        // Find PG SSN from the Contact
        String contactSearchVariable = request.pgSSN.replaceAll('\\D','');
        String contactQuery = 'FIND { searchString } IN ALL Fields RETURNING Contact(Id)';
        contactSearchVariable = UtilityClass.removeReservedChars(contactSearchVariable);
        System.debug('getAppRequestViaPGSSN search variables: ' + contactSearchVariable);
        contactQuery = contactQuery.replace('searchString', contactSearchVariable);

        Map<Id, Contact> existingContactMap = new Map<Id, Contact>((List<Contact>) search.query(contactQuery)[0]);

        // Second, take the IDs of the matching contacts and find the Application Request objects with those Account IDs
        List<SObject> appRequestWithPGSSNMatch = [SELECT Id, Name, Account_Name__c, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c,
                Personal_Guarantor_SSN__c, Business_Phone_Number__c, DNB_Resolved_DUNS__c, Status__c, Credit_Decision__c, Tax_Payer_ID_number__c,Program__c, Fraud_Flag__c,
                Credit_Line_Requested__c,Approved_Credit_Limit__c, Decision_Date__c FROM Application_Request__c WHERE Personal_Guarantor__c IN :existingContactMap.keySet() AND Status__c IN :NAFLEET_APP_STATUSES AND Id != :request.applicationId];

        // collect the app request Ids to exclude in the query later
        for (SObject appRequest : appRequestWithPGSSNMatch) {
            appIds.add(appRequest.Id);
        }

        return appRequestWithPGSSNMatch;
    }


    /**
       Because Phone and Tax ID are formula fields on the App Request, we must locate their values off of the Account.
     */
    private static List<SObject> getAppRequestsViaPhoneOrTax(ExistingExposureRequest request) {

        // First find any accounts that have that same business phone number or tax id number.
        String accountSearchVariables = '';
        if (request.phone != null && request.taxId != null) {
            accountSearchVariables = request.phone.replaceAll('\\D','') + ' OR ' + request.taxId.replaceAll('\\D','');
        }
        else if (request.phone != null) {
            accountSearchVariables = request.phone.replaceAll('\\D','');
        }
        else if (request.taxid != null) {
            accountSearchVariables = request.taxId.replaceAll('\\D','');
        }
        else {
            return new List<SObject>();
        }

        String accountQuery = 'FIND { searchString } IN All Fields RETURNING Account(Id)';
        accountSearchVariables = UtilityClass.removeReservedChars(accountSearchVariables);
        System.debug('getAppRequestsViaPhoneOrTax search variables: ' + accountSearchVariables);
        accountQuery = accountQuery.replace('searchString', accountSearchVariables);

        Map<Id, Account> existingAccountMap = new Map<Id, Account>((List<Account>) search.query(accountQuery)[0]);

        // Second, take the IDs of the matching accounts and find the Application Request objects with those Account IDs
        List<SObject> appRequestWithPhoneOrTaxMatch = [SELECT Id, Name, Account_Name__c, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c,
                Personal_Guarantor_SSN__c, Business_Phone_Number__c, DNB_Resolved_DUNS__c, Status__c, Credit_Decision__c, Tax_Payer_ID_number__c,Program__c, Fraud_Flag__c,
                Credit_Line_Requested__c,Approved_Credit_Limit__c, Decision_Date__c
                FROM Application_Request__c
                WHERE Account_Name__c
                IN :existingAccountMap.keySet()
                AND Status__c IN :NAFLEET_APP_STATUSES
                AND Id != :request.applicationId];

        // collect the app request Ids to exclude in the query later
        for (SObject appRequest : appRequestWithPhoneOrTaxMatch) {
            appIds.add(appRequest.Id);
        }

        return appRequestWithPhoneOrTaxMatch;
    }

    /**
       DUNS Numbers are stored from the DNBi file into the FSC_Existing_Exposure__c table in the format XX XXX XXXX, however, they are collected in the format XXXXXXXXX on the credit app.
       Must add da spaces.
     */
    private static String formatDUNs(String duns) {

        return duns.substring(0,2) + ' ' + duns.substring(2,5) + ' ' + duns.substring(5,9);
    }


    private static List<List<SObject>> queryForAllLOBs(String searchVariables) {

        List<List<SObject>> existingExposureApps = new List<List<SObject>>();

        String onlineAppRequestQuery = 'FIND { searchString }IN ALL FIELDS RETURNING ' +
                'OnlineApplication__c( ' +
                'Id, Name, CreatedDate, Legal_Business_Name__c, Business_Street_Address__c, City__c, State__c, Zip_Code__c, ' +
                'AO_Social_Security_Number__c, Phone_Number__c, DNB_Resolved_DUNS__c, ' +
                'Status__c, Credit_Decision__c, Federal_Tax_ID__c,Program__c, Fraud_Flag__c, Credit_Line_Requested__c,Credit_Line_Approved__c, Date_Decisioned__c, Submitted_to_Credit__c ' +
                'WHERE Id NOT IN :appIds ' +
                'AND Status__c IN :OTR_APP_STATUSES ' +
                'ORDER BY Id), ' +
                'Application_Request__c( ' +
                'Id, Name, CreatedDate, Account_Name__c, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c, Physical_State__c, Physical_Zip_Postal_Code__c, ' +
                'Personal_Guarantor_SSN__c, Business_Phone_Number__c, DNB_Resolved_DUNS__c, ' +
                'Status__c, Credit_Decision__c, Tax_Payer_ID_number__c,Program__c, Fraud_Flag__c, Credit_Line_Requested__c,Approved_Credit_Limit__c, Decision_Date__c ' +
                'WHERE Id NOT IN :appIds ' +
                'AND Status__c IN :NAFLEET_APP_STATUSES ' +
                'ORDER BY Id), ' +
                'CP_Application_Request__c( ' +
                'Id, Name, CreatedDate, Company_Legal_Name__c, Physical_Address_Line_1__c, Physical_City__c, Physical_State_Province__c, Physical_Postal_Code__c, ' +
                'Guarantor_Social_Security_Number__c, Business_Phone__c, DNB_Resolved_DUNS__c, ' +
                'Status__c, Credit_Decision__c, Taxpayer_ID__c,Program__c, Fraud_Flag__c, Credit_Line_Requested__c,Credit_Line_Approved__c, Application_Decisioned_Date__c ' +
                'WHERE Id NOT IN :appIds ' +
                'AND Status__c IN :CP_APP_STATUSES ' +
                'ORDER BY Id)';

        searchVariables = UtilityClass.removeReservedChars(searchVariables);
        System.debug('queryForAllLOBs search variables: ' + searchVariables);
        onlineAppRequestQuery = onlineAppRequestQuery.replace('searchString', searchVariables);

        try {
            existingExposureApps = search.query(onlineAppRequestQuery);

        } catch (System.QueryException e) {
            System.debug('Error when querying for Existing Exposure applications: ' + e);
            UtilityClass.logInternalError(e, null, 'CreditUtil_ExistingExposure=>queryForAllLOBs', false, null, null);
        }
        return existingExposureApps;
    }


    public static List<ExistingExposureAccounts> getAccounts(ExistingExposureRequest request) {

        List<FSC_Existing_Exposure__c> existingExposureAccounts = new List<FSC_Existing_Exposure__c>();
        List<ExistingExposureAccounts> existingExposureAccountMatches = new List<ExistingExposureAccounts>();

        if(request.legalBusinessName != null && (request.legalBusinessName).length() > 10){
            request.legalBusinessName = (request.legalBusinessName).subString(0, 10) + '*';
        }

        String accountSearchVariables = request.legalBusinessName + ' AND ' + request.addressLine1 + ' AND ' + request.city + ' AND ' + request.state + ' AND ' + request.postalCode;

        if (request.duns != null) {
            accountSearchVariables += ' OR ' + formatDUNs(request.duns);
        }

        String accountQuery = 'FIND { searchString } IN ALL FIELDS RETURNING FSC_Existing_Exposure__c( ' +
                'Id,  Name, Business_Name__c, Address__c, City__c, State_Province__c , Postal_Code__c, Credit_Limit__c, National_Account_Number__c, Account_Status__c, DUNS_Number__c ' +
                'ORDER BY Id)';

        accountSearchVariables = UtilityClass.removeReservedChars(accountSearchVariables);
        System.debug('getAccounts search variables: ' + accountSearchVariables);
        accountQuery = accountQuery.replace('searchString', accountSearchVariables);

        existingExposureAccounts = ((List<FSC_Existing_Exposure__c>) search.query(accountQuery)[0]);


        for(FSC_Existing_Exposure__c existingAccount : existingExposureAccounts) {

            String formattedDUNs = '';
            if (request.duns != null) formattedDUNs = formatDUNs(request.duns);

            if(JaroWinklerDistance.getScore(request.legalBusinessName, existingAccount.Business_Name__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.addressLine1, existingAccount.Address__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.city, existingAccount.City__c) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.state, existingAccount.State_Province__c ) >= 0.75 &&
                    JaroWinklerDistance.getScore(request.postalCode, existingAccount.Postal_Code__c) >= 0.75
                    || (request.duns != null && (JaroWinklerDistance.getScore(formattedDUNs, existingAccount.DUNS_Number__c)) == 1.00)) {

                ExistingExposureAccounts existingExposureAccountMatch = new ExistingExposureAccounts();

                existingExposureAccountMatch.fscExistingExposureId = existingAccount.Id;
                existingExposureAccountMatch.fscExistingExposureName = existingAccount.Name;
                existingExposureAccountMatch.legalBusinessName = existingAccount.Business_Name__c;
                existingExposureAccountMatch.addressLine1 = existingAccount.Address__c;
                existingExposureAccountMatch.city = existingAccount.City__c;
                existingExposureAccountMatch.state = existingAccount.State_Province__c;
                existingExposureAccountMatch.postalCode = existingAccount.Postal_Code__c;
                existingExposureAccountMatch.nationalId = existingAccount.National_Account_Number__c;
                existingExposureAccountMatch.creditLine = String.valueOf(existingAccount.Credit_Limit__c);
                existingExposureAccountMatch.accountStatus = existingAccount.Account_Status__c;
                existingExposureAccountMatch.duns = existingAccount.DUNS_Number__c;

                existingExposureAccountMatches.add(existingExposureAccountMatch);

            }
        }
        return existingExposureAccountMatches;
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