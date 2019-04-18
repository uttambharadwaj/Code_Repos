/**
 * Created by dgilbert on 2019-03-29.
 */

public with sharing class CreditWS_Giact {

    public static Credit_Decision_Engine_Endpoints__mdt giactVerifySettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt giactVerifySettings = [SELECT Id, Username__c, Password__c, Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'GIACTVerify'];

                return giactVerifySettings;

            } catch (Exception e) {

                System.debug('### ERROR: Error getting Giact connection settings.');

            }

            return null;

        }
    }

    public static GiactVerifyResponse giactVerify(GiactVerifyRequest giactInquiryRequest) {

        try {

            if (giactVerifySettings != null) {

                CreditWSUtil_GiactVerify.GiactInquiryRequest giactRequest = new CreditWSUtil_GiactVerify.GiactInquiryRequest();

                giactRequest.UniqueId = giactInquiryRequest.UniqueId;

                // Checking Account Information
                giactRequest.Check = new CreditWSUtil_GiactVerify.Check();
                giactRequest.Check.AccountNumber = giactInquiryRequest.AccountNumber;
                giactRequest.Check.RoutingNumber = giactInquiryRequest.RoutingNumber;

                // Customer Information
                giactRequest.Customer = new CreditWSUtil_GiactVerify.Customer();
                giactRequest.Customer.EntityType = 0;
                giactRequest.Customer.FirstName = giactInquiryRequest.FirstName;
                giactRequest.Customer.LastName = giactInquiryRequest.LastName;
                giactRequest.Customer.BusinessName = giactInquiryRequest.BusinessName;
                giactRequest.Customer.AddressLine1 = giactInquiryRequest.AddressLine1;
                giactRequest.Customer.AddressLine2 = giactInquiryRequest.AddressLine2;
                giactRequest.Customer.City = giactInquiryRequest.City;
                giactRequest.Customer.State = giactInquiryRequest.State;
                giactRequest.Customer.ZipCode = giactInquiryRequest.ZipCode;
                giactRequest.Customer.Country = giactInquiryRequest.Country;
                if(!String.isBlank(giactInquiryRequest.PhoneNumber)) {
                    giactRequest.Customer.PhoneNumber = giactInquiryRequest.PhoneNumber.replaceAll('[^0-9]', '');
                }
                giactRequest.Customer.TaxId = giactInquiryRequest.FederalTaxId;
                giactRequest.Customer.DateOfBirth = giactInquiryRequest.DateOfBirth;
                giactRequest.Customer.EmailAddress = giactInquiryRequest.EmailAddress;
                giactRequest.Customer.CurrentIpAddress = giactInquiryRequest.IpAddress;

                // General Settings
                giactRequest.GAuthenticateEnabled = true;

                System.debug('### GIACT Verify Request: ' + giactRequest);

                HttpRequest httpRequest = new HttpRequest();

                httpRequest.setEndpoint(giactVerifySettings.Endpoint_URL__c);

                httpRequest.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(giactVerifySettings.Username__c + ':' + giactVerifySettings.Password__c)));
                httpRequest.setHeader('Content-Type', 'application/json');
                httpRequest.setMethod('POST');

                httpRequest.setBody(JSON.serialize(giactRequest));

                Http http = new Http();

                HTTPResponse httpResponse = http.send(httpRequest);

                CreditWSUtil_GiactVerify.GiactInquiryResponse giactResponse = (CreditWSUtil_GiactVerify.GiactInquiryResponse) JSON.deserialize(httpResponse.getBody(), CreditWSUtil_GiactVerify.GiactInquiryResponse.class);

                System.debug('### GIACT Verify Response: ' + giactResponse);

                if(giactResponse != null) {

                    CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = new CreditWS_Giact.GiactVerifyResponse();

                    giactVerifyResponse.GiactErrorMessage = giactResponse.ErrorMessage;
                    giactVerifyResponse.VerificationResponseCode = String.valueOf(giactResponse.VerificationResponse);
                    giactVerifyResponse.VerificationResponseCodeName = CreditWS_Giact.getGiactResponseCodeName('gVerify', 'VerificationResponse', giactVerifyResponse.VerificationResponseCode);
                    giactVerifyResponse.VerificationResponseMessage = CreditWS_Giact.getGiactResponseMessage('gVerify', 'VerificationResponse', giactVerifyResponse.VerificationResponseCode);
                    giactVerifyResponse.AccountResponseCode = String.valueOf(giactResponse.AccountResponseCode);
                    giactVerifyResponse.AccountResponseCodeName = CreditWS_Giact.getGiactResponseCodeName('gVerify', 'AccountResponseCode', giactVerifyResponse.AccountResponseCode);
                    giactVerifyResponse.AccountResponseMessage = CreditWS_Giact.getGiactResponseMessage('gVerify', 'AccountResponseCode', giactVerifyResponse.AccountResponseCode);

                    return giactVerifyResponse;

                }

            }

        } catch (Exception e) {
            System.debug('### Error - ' + e.getLineNumber() + ' - ' + e.getMessage());
        }

        return null;

    }

    public static String getGiactResponseMessage(String service, String field, String responseCode) {

        try {

            List<GIACT_Verify_Response_Codes__mdt> giactVerifyResponseCodes = [SELECT Id, Response_Field_Message__c FROM GIACT_Verify_Response_Codes__mdt WHERE GIACT_Service__c =: service and Response_Field_Name__c =: field and Response_Field_Value__c =: responseCode LIMIT 1];

            if(giactVerifyResponseCodes.size() > 0) {
                return giactVerifyResponseCodes[0].Response_Field_Message__c;
            }

        }
        catch(Exception e) {
            System.debug('### Error - ' + e.getLineNumber() + ' - ' + e.getMessage());
        }

        return null;

    }

    public static String getGiactResponseCodeName(String service, String field, String responseCode) {

        try {

            List<GIACT_Verify_Response_Codes__mdt> giactVerifyResponseCodes = [SELECT Id, Response_Field_Friendly_Value__c FROM GIACT_Verify_Response_Codes__mdt WHERE GIACT_Service__c =: service and Response_Field_Name__c =: field and Response_Field_Value__c =: responseCode LIMIT 1];

            if(giactVerifyResponseCodes.size() > 0) {
                return giactVerifyResponseCodes[0].Response_Field_Friendly_Value__c;
            }

        }
        catch(Exception e) {
            System.debug('### Error - ' + e.getLineNumber() + ' - ' + e.getMessage());
        }

        return null;

    }

    public class GiactVerifyRequest {

        public String UniqueId { get; set; }
        public String RoutingNumber { get; set; }
        public String AccountNumber { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String BusinessName { get; set; }
        public String AddressLine1 { get; set; }
        public String AddressLine2 { get; set; }
        public String City { get; set; }
        public String State { get; set; }
        public String ZipCode { get; set; }
        public String Country { get; set; }
        public String PhoneNumber { get; set; }
        public String FederalTaxId { get; set; }
        public String DateOfBirth { get; set; }
        public String EmailAddress { get; set; }
        public String IpAddress { get; set; }

        public GiactVerifyRequest() {

        }

    }

    public class GiactVerifyResponse {

        public String AccountResponseCode { get; set; }
        public String AccountResponseCodeName { get; set; }
        public String AccountResponseMessage { get; set; }
        public String VerificationResponseCode { get; set; }
        public String VerificationResponseCodeName { get; set; }
        public String VerificationResponseMessage { get; set; }
        public String GiactErrorMessage { get; set; }

        public GiactVerifyResponse() {

        }

    }

}