/*
*
* Credit Decisioning Process
* Module: Forte
* Author: Derek Gilbert
* Initial Date: 7/25/2018
*
*/

public with sharing class CreditWS_Forte {

    public static Forte_Integration__mdt forteIntegrationSettings {
        get {

            try {
                Forte_Integration__mdt forteIntegrationSettings = [SELECT API_Access_Key__c, API_Secure_Key__c, Endpoint__c, Location_Id__c, Organization_Id__c FROM Forte_Integration__mdt WHERE MasterLabel = 'Authentication'];

                return forteIntegrationSettings;
            } catch (Exception e) {

                System.debug('### ERROR: Error getting Forte connection settings.');

            }
            return null;
        }
    }

    public static ForteResponse verifyBankAccount(ForteRequest request) {

        HttpRequest httpRequest = new HttpRequest();

        httpRequest.setEndpoint(forteIntegrationSettings.Endpoint__c + 'organizations/org_' + forteIntegrationSettings.Organization_Id__c + '/locations/loc_' + forteIntegrationSettings.Location_Id__c + '/transactions');

        httpRequest.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(forteIntegrationSettings.API_Access_Key__c + ':' + forteIntegrationSettings.API_Secure_Key__c)));
        httpRequest.setHeader('X-Forte-Auth-Organization-Id', 'org_' + forteIntegrationSettings.Organization_Id__c);
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setMethod('POST');

        httpRequest.setBody(JSON.serialize(request));

        Http http = new Http();
        try {

            HTTPResponse httpResponse = http.send(httpRequest);

            ForteResponse response = (ForteResponse) JSON.deserialize(httpResponse.getBody(), ForteResponse.class);

            return response;

        } catch (Exception e) {

            System.debug('### Error during Forte Bank Verification Callout: ' + e.getMessage());

        }

        return null;

    }

    public class ForteRequest {

        public Integer authorization_amount { get; set ; }
        public ForteECheck echeck { get; set ; }
        public String action { get; set; }

    }

    public class ForteECheck {

        public String masked_account_number { get; set; }
        public String last_4_account_number { get; set; }
        public String routing_number { get; set; }
        public String account_number { get; set; }

    }

    public class ForteResponse {

        public String transaction_id { get; set; }
        public String location_id { get; set; }
        public String action { get; set; }
        public Double authorization_amount { get; set; }
        public String entered_by { get; set; }

        public ForteECheck echeck { get; set; }

        public ForteCalloutResponse response { get; set; }

    }

    public class ForteCalloutResponse {

        public String environment { get; set; }
        public String response_type { get; set; }
        public String response_code { get; set; }
        public String response_desc { get; set; }

    }

}