/*
*
* Credit Decisioning Process
* Module: ThreatMetrix
* Author: Derek Gilbert
* Initial Date: 3/18/2018
*  
*/
public class CreditWS_ThreatMetrix {
    
    public CreditWS_ThreatMetrix() {
        
    }
    
    // Call-out for OTR ThreatMetrix
    // 
    // The ThreatMetrix call-out from Online Application utilizes the ID of the record as the key
    public static ThreatMetrixQueryResponse getThreatMetrixScore(ThreatMetrixQueryRequest threatMetrixQueryRequest) {

        try {

            ThreatMetrixQueryResponse threatMetrixQueryResponse = new ThreatMetrixQueryResponse();

            String baseURL = 'https://h-api.online-metrix.net/api/query';

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(120000);
            req.setMethod('GET');

            List<String> parameters = new List<String>();
            parameters.add('org_id=' + EncodingUtil.urlEncode('bkwau9ws', 'UTF-8'));
            parameters.add('api_key=' + EncodingUtil.urlEncode('6wwgbf2gdnx6wy2z', 'UTF-8'));
            parameters.add('request_id=' + threatMetrixQueryRequest.threatMetrixRequestId);
            parameters.add('action=check_review_status');

            String endpoint = baseURL + '?' + String.join(parameters, '&');
            req.setEndpoint(endpoint);
            HttpResponse res = h.send(req);

            if (res.getStatusCode() == 200) {

                Map<String, String> results = new Map<String, String>();

                System.debug(res.getBody());

                for (String pair : (res.getBody()).split('&')) {

                    try {
                    	results.put(pair.split('=')[0], pair.split('=')[1]);
                    } catch (ListException lex) {
                        System.debug('No variable value returned.');
                    }

                }

                threatMetrixQueryResponse.reviewStatus = results.get('review_status');

            }

            return threatMetrixQueryResponse;

        }
        catch(Exception e) {

            System.debug('### Error querying ThreatMetrix: ' + e.getMessage() + '(Line: ' + e.getLineNumber() + ')');

        }

        return null;

    }

    public static ThreatMetrixSessionQueryResponse integrateCreditApp(ThreatMetrixSessionQueryRequest threatMetrixSessionQueryRequest) {

        try {

            ThreatMetrixSessionQueryResponse threatMetrixSessionQueryResponse = new ThreatMetrixSessionQueryResponse();

            String baseURL = 'https://h-api.online-metrix.net/api/session-query';

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setTimeout(120000);
            req.setMethod('GET');

            List<String> parameters = new List<String>();
            parameters.add('org_id=' + EncodingUtil.urlEncode('bkwau9ws', 'UTF-8'));
            parameters.add('api_key=' + EncodingUtil.urlEncode('6wwgbf2gdnx6wy2z', 'UTF-8'));
            parameters.add('session_id=' + threatMetrixSessionQueryRequest.sessionId);
            parameters.add('service_type=all');
            parameters.add('event_type=ACCOUNT_CREATION');
            parameters.add('transaction_id=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.transactionId, 'UTF-8'));
            parameters.add('account_name=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.accountName, 'UTF-8'));
            if (threatMetrixSessionQueryRequest.dbaName != null) {
                parameters.add('local_attrib_1=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.dbaName, 'UTF-8'));
            }
            if (threatMetrixSessionQueryRequest.federalTaxId != null) {
                parameters.add('ssn_hash=' + EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(threatMetrixSessionQueryRequest.federalTaxId))));
            }
            parameters.add('account_address_street1=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.physicalAddressLine1, 'UTF-8'));
            parameters.add('account_address_city=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.physicalCity, 'UTF-8'));
            parameters.add('account_address_state=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.physicalState, 'UTF-8'));
            parameters.add('account_address_zip=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.physicalPostalCode, 'UTF-8'));
            parameters.add('account_telephone=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.phoneNumber, 'UTF-8'));
            parameters.add('local_attrib_2=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.phoneNumber, 'UTF-8'));
            if (threatMetrixSessionQueryRequest.guarantorName != null) {
                parameters.add('local_attrib_3=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.guarantorName, 'UTF-8'));
            }
            parameters.add('account_email=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.emailAddress, 'UTF-8'));
            parameters.add('shipping_address_street1=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.mailingAddressLine1, 'UTF-8'));
            parameters.add('shipping_address_city=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.mailingCity, 'UTF-8'));
            parameters.add('shipping_address_state=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.mailingState, 'UTF-8'));
            parameters.add('shipping_address_zip=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.mailingPostalCode, 'UTF-8'));
            if (threatMetrixSessionQueryRequest.guarantorName != null) {
                parameters.add('local_attrib_4=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.guarantorName, 'UTF-8'));
            }
            if (threatMetrixSessionQueryRequest.guarantorEmail != null) {
                parameters.add('local_attrib_5=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.guarantorEmail, 'UTF-8'));
            }
            parameters.add('input_ip_address=' + EncodingUtil.urlEncode(threatMetrixSessionQueryRequest.ipAddress, 'UTF-8'));

            String endpoint = baseURL + '?' + String.join(parameters, '&');
            req.setEndpoint(endpoint);
            HttpResponse res = h.send(req);

            if (res.getStatusCode() == 200) {

                Map<String, String> results = new Map<String, String>();

                System.debug(res.getBody());

                for (String pair : (res.getBody()).split('&')) {
					
                    try {
                    	results.put(pair.split('=')[0], pair.split('=')[1]);
                    } catch (ListException lex) {
                        System.debug('No variable value returned.');
                    }

                }

                threatMetrixSessionQueryResponse.threatMetrixRequestId = EncodingUtil.urlDecode(results.get('request_id'), 'UTF-8');
                threatMetrixSessionQueryResponse.threatMetrixReviewStatus = EncodingUtil.urlDecode(results.get('review_status'), 'UTF-8');

            }

            return threatMetrixSessionQueryResponse;

        }
        catch(Exception e) {

            System.debug('### Error integrating application to ThreatMetrix: ' + e.getMessage() + '(Line: ' + e.getLineNumber() + ')');

        }

        return null;

    }

    public class ThreatMetrixQueryRequest {

        public String threatMetrixRequestId { get; set; }

    }

    public class ThreatMetrixQueryResponse {
        
        public String reviewStatus { get; set; }
        
    }

    public class ThreatMetrixSessionQueryRequest {

        public String sessionId { get; set; }
        public String transactionId { get; set; }
        public String accountName { get; set; }
        public String dbaName { get; set; }
        public String federalTaxId { get; set; }
        public String physicalAddressLine1 { get; set; }
        public String physicalCity { get; set; }
        public String physicalState { get; set; }
        public String physicalPostalCode { get; set; }
        public String mailingAddressLine1 { get; set; }
        public String mailingCity { get; set; }
        public String mailingState { get; set; }
        public String mailingPostalCode { get; set; }
        public String phoneNumber { get; set; }
        public String emailAddress { get; set; }
        public String guarantorName { get; set; }
        public String guarantorEmail { get; set; }
        public String ipAddress { get; set; }

    }

    public class ThreatMetrixSessionQueryResponse {

        public String threatMetrixRequestId { get; set; }
        public String threatMetrixReviewStatus { get; set; }

    }
    
}