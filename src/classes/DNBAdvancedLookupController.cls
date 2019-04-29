/*
*
* Credit Decisioning Process
* Module: DNB Advanced Lookup Controller
* Author: Derek Gilbert
* Initial Date: 5/29/2018
* Revision History: 4/29/2019 IADJUDICAT-739 use constructor w/ parameter so we can have consistency between automation and this page
 */

public with sharing class DNBAdvancedLookupController {

    public final static String APPLICATION_NAME = 'DNB Advanced Lookup';

    public String applicationId {
        get {
            if (ApexPages.currentPage().getParameters().get('applicationId') != null) {
                return ApexPages.currentPage().getParameters().get('applicationId');
            }
            return null;
        }
    }

    public List<CreditWS_DNB.DNBDirect_MatchCandidate> lookupResults { get; set; }

    public String selectedDunsNumber { get; set; }
    public Integer selectedIndex { get; set; }

    // Used for display purposes only
    public ApplicationInformation applicationInformation { get; set; }

    public class dnbAdvancedLookupException extends Exception {
    }

    public DNBAdvancedLookupController() {

    }

    public void init() {

        applicationInformation = new ApplicationInformation();

        if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

            List<OnlineApplication__c> onlineApplications = [
                    SELECT Id, DUNS__c, Legal_Business_Name__c, Business_Street_Address__c, City__c, State__c, Zip_Code__c, Country__c, Phone_Number__c, Trade_Name__c
                    FROM OnlineApplication__c
                    WHERE Id = :applicationId
            ];

            if (onlineApplications.size() == 1) {

                applicationInformation.companyName = onlineApplications[0].Legal_Business_Name__c;
                applicationInformation.addressLine1 = onlineApplications[0].Business_Street_Address__c;
                applicationInformation.city = onlineApplications[0].City__c;
                applicationInformation.state = onlineApplications[0].State__c;
                applicationInformation.postalCode = onlineApplications[0].Zip_Code__c;
                applicationInformation.dunsNumber = onlineApplications[0].DUNS__c;

                //IADJUDICAT 739 set up constructor for our class that uses online app.
                CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest(onlineApplications[0]);
                dnbDirectMatchRequest.SingleResolution = false;
                CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if (dnbDirectMatchResponse != null) {
                    lookupResults = dnbDirectMatchResponse.matchCandidates;
                }

            }

        } else if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

            List<CP_Application_Request__c> cpApplicationRequests = [
                    SELECT Id, DUNS_Number__c, Company_Legal_Name__c, Physical_Address_Line_1__c, Physical_City__c,
                            Physical_State__c, Physical_Postal_Code__c
                    FROM CP_Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (cpApplicationRequests.size() == 1) {

                applicationInformation.companyName = cpApplicationRequests[0].Company_Legal_Name__c;
                applicationInformation.addressLine1 = cpApplicationRequests[0].Physical_Address_Line_1__c;
                applicationInformation.city = cpApplicationRequests[0].Physical_City__c;
                applicationInformation.state = cpApplicationRequests[0].Physical_State__c;
                applicationInformation.postalCode = cpApplicationRequests[0].Physical_Postal_Code__c;
                applicationInformation.dunsNumber = cpApplicationRequests[0].DUNS_Number__c;

                CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

                dnbDirectMatchRequest.SubjectName = cpApplicationRequests[0].Company_Legal_Name__c;
                dnbDirectMatchRequest.StreetAddressLine1 = cpApplicationRequests[0].Physical_Address_Line_1__c;
                dnbDirectMatchRequest.PrimaryTownName = cpApplicationRequests[0].Physical_City__c;
                dnbDirectMatchRequest.TerritoryName = cpApplicationRequests[0].Physical_State__c;
                dnbDirectMatchRequest.FullPostalCode = cpApplicationRequests[0].Physical_Postal_Code__c;
                dnbDirectMatchRequest.CountryISOAlpha2Code = 'US';
                dnbDirectMatchRequest.DUNSNumber = cpApplicationRequests[0].DUNS_Number__c;

                CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if (dnbDirectMatchResponse != null) {
                    lookupResults = dnbDirectMatchResponse.matchCandidates;
                }

            }

        } else if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

            List<Application_Request__c> applicationRequests = [
                    SELECT Id, DUNS_Number__c, Opportunity_Name_Text__c, Physical_Street__c, Physical_City__c,
                            Physical_State__c, Physical_Zip_Postal_Code__c, Physical_Country__c
                    FROM Application_Request__c
                    WHERE Id = :applicationId
            ];

            if (applicationRequests.size() == 1) {

                applicationInformation.companyName = applicationRequests[0].Opportunity_Name_Text__c;
                applicationInformation.addressLine1 = applicationRequests[0].Physical_Street__c;
                applicationInformation.city = applicationRequests[0].Physical_City__c;
                applicationInformation.state = applicationRequests[0].Physical_State__c;
                applicationInformation.postalCode = applicationRequests[0].Physical_Zip_Postal_Code__c;
                applicationInformation.dunsNumber = applicationRequests[0].DUNS_Number__c;

                CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

                dnbDirectMatchRequest.SubjectName = applicationRequests[0].Opportunity_Name_Text__c;
                dnbDirectMatchRequest.StreetAddressLine1 = applicationRequests[0].Physical_Street__c;
                dnbDirectMatchRequest.PrimaryTownName = applicationRequests[0].Physical_City__c;
                dnbDirectMatchRequest.TerritoryName = applicationRequests[0].Physical_State__c;
                dnbDirectMatchRequest.FullPostalCode = applicationRequests[0].Physical_Zip_Postal_Code__c;
                dnbDirectMatchRequest.CountryISOAlpha2Code = applicationRequests[0].Physical_Country__c;
                dnbDirectMatchRequest.DUNSNumber = applicationRequests[0].DUNS_Number__c;

                CreditWS_DNB.DNBDirect_MatchResponse dnbDirectMatchResponse = CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

                if (dnbDirectMatchResponse != null) {
                    lookupResults = dnbDirectMatchResponse.matchCandidates;
                }

            }

        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find specified application.'));
        }

    }

    public PageReference populateDUNS() {

        try {

            if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('OnlineApplication__c')) {

                List<OnlineApplication__c> onlineApplications = [SELECT Id, DUNS__c, DNB_Name_Match_Grade__c, DNB_Name_Match_Data_Profile__c, DNB_Street_Name_Match_Data_Profile__c,
                        DNB_Street_Number_Match_Data_Profile__c, DNB_City_Match_Data_Profile__c, DNB_State_Match_Data_Profile__c, DNB_Postal_Code_Match_Data_Profile__c FROM OnlineApplication__c WHERE Id = :applicationId];

                if (onlineApplications.size() == 1) {

                    onlineApplications[0].DUNS__c = selectedDunsNumber;
                    onlineApplications[0].DNB_Name_Match_Grade__c = lookupResults[selectedIndex].NameMatchGradeString;
                    onlineApplications[0].DNB_Name_Match_Data_Profile__c = lookupResults[selectedIndex].NameMatchDataProfile;
                    onlineApplications[0].DNB_Street_Name_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNameMatchDataProfile;
                    onlineApplications[0].DNB_Street_Number_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNumberMatchDataProfile;
                    onlineApplications[0].DNB_City_Match_Data_Profile__c = lookupResults[selectedIndex].CityMatchDataProfile;
                    onlineApplications[0].DNB_State_Match_Data_Profile__c = lookupResults[selectedIndex].StateMatchDataProfile;
                    onlineApplications[0].DNB_Postal_Code_Match_Data_Profile__c = lookupResults[selectedIndex].PostalCodeMatchDataProfile;

                    Database.UpsertResult result = Database.upsert(onlineApplications[0], false);
                    if (result.isSuccess()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Application updated!'));
                    } else {
                        throw new dnbAdvancedLookupException(String.valueOf(result.getErrors()));
                    }

                }

            } else if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('CP_Application_Request__c')) {

                List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, DUNS_Number__c, DNB_Name_Match_Grade__c, DNB_Name_Match_Data_Profile__c, DNB_Street_Name_Match_Data_Profile__c,
                        DNB_Street_Number_Match_Data_Profile__c, DNB_City_Match_Data_Profile__c, DNB_State_Match_Data_Profile__c, DNB_Postal_Code_Match_Data_Profile__c FROM CP_Application_Request__c WHERE Id = :applicationId];

                if (cpApplicationRequests.size() == 1) {

                    cpApplicationRequests[0].DUNS_Number__c = selectedDunsNumber;
                    cpApplicationRequests[0].DNB_Name_Match_Grade__c = lookupResults[selectedIndex].NameMatchGradeString;
                    cpApplicationRequests[0].DNB_Name_Match_Data_Profile__c = lookupResults[selectedIndex].NameMatchDataProfile;
                    cpApplicationRequests[0].DNB_Street_Name_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNameMatchDataProfile;
                    cpApplicationRequests[0].DNB_Street_Number_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNumberMatchDataProfile;
                    cpApplicationRequests[0].DNB_City_Match_Data_Profile__c = lookupResults[selectedIndex].CityMatchDataProfile;
                    cpApplicationRequests[0].DNB_State_Match_Data_Profile__c = lookupResults[selectedIndex].StateMatchDataProfile;
                    cpApplicationRequests[0].DNB_Postal_Code_Match_Data_Profile__c = lookupResults[selectedIndex].PostalCodeMatchDataProfile;

                    Database.UpsertResult result = Database.upsert(cpApplicationRequests[0], false);
                    if (result.isSuccess()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Application updated!'));
                    } else {
                        throw new dnbAdvancedLookupException(String.valueOf(result.getErrors()));
                    }

                }

            } else if (((Id.valueOf(applicationId)).getSobjectType().getDescribe().getName()).equalsIgnoreCase('Application_Request__c')) {

                List<Application_Request__c> applicationRequests = [
                        SELECT Id, DUNS_Number__c, DNB_Name_Match_Grade__c, DNB_Name_Match_Data_Profile__c, DNB_Street_Name_Match_Data_Profile__c,
                                DNB_Street_Number_Match_Data_Profile__c, DNB_City_Match_Data_Profile__c, DNB_State_Match_Data_Profile__c, DNB_Postal_Code_Match_Data_Profile__c
                        FROM Application_Request__c
                        WHERE Id = :applicationId
                ];

                if (applicationRequests.size() == 1) {

                    applicationRequests[0].DUNS_Number__c = selectedDunsNumber;
                    applicationRequests[0].DNB_Name_Match_Grade__c = lookupResults[selectedIndex].NameMatchGradeString;
                    applicationRequests[0].DNB_Name_Match_Data_Profile__c = lookupResults[selectedIndex].NameMatchDataProfile;
                    applicationRequests[0].DNB_Street_Name_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNameMatchDataProfile;
                    applicationRequests[0].DNB_Street_Number_Match_Data_Profile__c = lookupResults[selectedIndex].StreetNumberMatchDataProfile;
                    applicationRequests[0].DNB_City_Match_Data_Profile__c = lookupResults[selectedIndex].CityMatchDataProfile;
                    applicationRequests[0].DNB_State_Match_Data_Profile__c = lookupResults[selectedIndex].StateMatchDataProfile;
                    applicationRequests[0].DNB_Postal_Code_Match_Data_Profile__c = lookupResults[selectedIndex].PostalCodeMatchDataProfile;

                    Database.UpsertResult result = Database.upsert(applicationRequests[0], false);
                    if (result.isSuccess()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Application updated!'));
                    } else {
                        throw new dnbAdvancedLookupException(String.valueOf(result.getErrors()));
                    }

                }

            }

        } catch (Exception e) {
            String errorCode = WEXDEVErrorReporting.reportInternalError(APPLICATION_NAME, ApexPages.currentPage().getUrl(), UserInfo.getUserId(), e);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occured while updating the application. Your support organization has been notified (Error Tracking Code: ' + errorCode + ').'));
        }

        return null;

    }

    public class ApplicationInformation {

        public String companyName { get; set; }
        public String addressLine1 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postalCode { get; set; }
        public String dunsNumber { get; set; }

    }

}