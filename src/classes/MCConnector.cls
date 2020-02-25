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

            } else { // TODO Throw exception
                System.debug(authenticateResponse.getBody());
                insert UtilityClass.logInternalError(authenticateResponse.getBody(), 'MCConnector Init', '', 'MCConnector', true, '', '');
                throw new MCConnectorException(authenticateResponse.getBody());
            }
        } catch (Exception e) {

        }
    }

    public Boolean sendTriggeredEmail(String key) {

        Boolean successful = false;

        HttpRequest req = new HttpRequest();

        req.setMethod('POST');
        req.setEndpoint(triggeredEmailCallout +'/key:'+key+'/send?account_id=100029437');

        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + accessToken);




        try {

            req.setBody(mcData.generateJSON());
            Http searchRequuest = new Http();
            HttpResponse postResponse = searchRequuest.send(req);
            String resBody = postResponse.getBody();
            System.debug(resBody);
            if (resBody.contains('"Queued"')) successful = true;

        } catch (Exception e) { // TODO Better error  handling
            System.debug(e);
            System.debug(e.getLineNumber());
        }


        return successful;
    }

    public class MCConnectorException extends Exception {}
}
