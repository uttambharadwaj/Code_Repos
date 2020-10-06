public class MCConnector {

    private static String triggeredEmailCallout = 'callout:Marketing_Cloud_Triggered_Email';
    private final static String authCallout = 'callout:Marketing_Cloud_Authorization';
    private final static String authBody = '{"grant_type": "client_credentials", "client_id": "{!$Credential.UserName}","client_secret": "{!$Credential.Password}","account_id": "100029437"}';
    private String accessToken { get; set; }
    public MCData mcData;

    public MCConnector() {

        try {

            mcData = new MCData();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-type', 'application/json');
            req.setEndpoint(authCallout);
            req.setBody(authBody);

            Http authRequest = new Http();
            HttpResponse authenticateResponse = authRequest.send(req);

            if (authenticateResponse.getStatusCode() == 200) {
                String responseBody = authenticateResponse.getBody();
                MCResponse response = MCResponse.parse(responseBody);
                accessToken = response.access_token;
                System.debug(authenticateResponse.getBody());

            } else {
                insert UtilityClass.logInternalError(authenticateResponse.getBody(), 'MCConnector Init', '', 'MCConnector', true, '', '');
                throw new MCConnectorException('Unable to authenticate with Marketing Cloud.');
            }
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'MCConnector', true, '', '');
            throw new MCConnectorException('Unable to authenticate with Marketing Cloud.');
        }
    }

    public String sendTriggeredEmail(String key) {

        Boolean successful = false;
        String sendId;
        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setEndpoint(triggeredEmailCallout + '/key:' + key + '/send');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + accessToken);

        try {

            req.setBody(mcData.generateJSON());
            System.debug(mcData.generateJSON());
            Http sendEmailReq = new Http();
            HttpResponse postResponse = sendEmailReq.send(req);
            String resBody = postResponse.getBody();
            System.debug(resBody);

            MCResponse response = MCResponse.parse(resBody);
            System.debug(response);
            if (response.responses != null && response.responses[0].hasErrors == false) {
                successful = true;
                sendId = response.responses[0].recipientSendId;
            } else {
                insert UtilityClass.logInternalError(resBody, 'MCConnector sendTriggeredEmail', '', 'MCConnector', true, '', '');
                throw new MCConnectorException('Unable to send message.');
            }

        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'MCConnector', true, '', '');
            throw new MCConnectorException('Unable to send message.');
        }

        return sendId;
    }

    public String getTriggeredEmailStatus(String key, String recipientSendId) {

        //https://mcb9lg4yfkyxd3c4ctrlcfsdpln4.rest.marketingcloudapis.com/messaging/v1/messageDefinitionSends/key:JamesTriggeredSend/deliveryRecords/61129259-b7f9-489e-a7b0-d73561e63db6
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setEndpoint(triggeredEmailCallout + '/key:' + key + '/deliveryRecords/' + recipientSendId);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + accessToken);

        try {

            Http sendEmailReq = new Http();
            HttpResponse getResponse = sendEmailReq.send(req);
            String resBody = getResponse.getBody();
            String status = resBody.substringAfter('"status"').substringBefore(',').replaceAll('[^a-zA-Z0-9\\s+]', '');

            if (status.equalsIgnoreCase('Error')) {
                System.debug(resBody);
                Internal_Application_Error__c internalError = UtilityClass.logInternalError(resBody, 'MCConnector getTriggeredEmailStatus', '', 'MCConnector', true, '', key + '-' + recipientSendId);
                insert internalError;
                status += ' Error ID: ' + internalError.Id;
            }
            return status;
        } catch (Exception e) {
            insert UtilityClass.logInternalError(e, '', 'MCConnector Get Status', true, '', recipientSendId);
            throw new MCConnectorException('Unable to retrieve status for id: ' + recipientSendId);
        }
    }
    public class MCConnectorException extends Exception {
    }
}