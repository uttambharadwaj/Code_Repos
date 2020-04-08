/**
 * Created by jharrell on 1/27/20.
 */

public class WebDAMConnector {

    private final String BASE_URL = 'https://apiv2.webdamdb.com';
    private String refresh_token {
        get;
        set;
    }
    private String accessToken {
        get;
        set;
    }

    private WebDAM_Connector__c webDAMConnectorConfig { get; set; }

    public WebDAMConnector() {

        webDAMConnectorConfig = WebDAM_Connector__c.getInstance();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(BASE_URL + '/oauth2/token');
        String requestBody = 'grant_type=password&client_id='+webDAMConnectorConfig.client_id__c+'&client_secret='+webDAMConnectorConfig.client_secret__c+'&username='+webDAMConnectorConfig.username__c+'&password='+webDAMConnectorConfig.password__c;
        req.setBody(requestBody);

        Http authRequest = new Http();
        HttpResponse authenticateResponse = authRequest.send(req);
        if (authenticateResponse.getStatusCode() == 200) {
            String responseBody = authenticateResponse.getBody();

            WebDAMConnectorAuthResponse response = WebDAMConnectorAuthResponse.parse(responseBody);

            this.refresh_token = response.refresh_token;
            this.accessToken = response.access_token;

        } else {
            insert UtilityClass.logInternalError(authenticateResponse.getBody(), 'WebDAMConnector Init', '', 'WebDAMConnector', true, '', '');
            throw new WebDAMConnectorException(authenticateResponse.getBody());
        }
    }

    public List<WebDAMConnectorAuthResponse.items> searchByString(String searchParam, String searchOptions) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(BASE_URL + '/search?query=' + searchParam + searchOptions);
        req.setHeader('Authorization', 'Bearer ' + accessToken);

        Http searchRequuest = new Http();
        HttpResponse searchResponse = searchRequuest.send(req);
        WebDAMConnectorAuthResponse response = WebDAMConnectorAuthResponse.parse(searchResponse.getBody());

        if (searchResponse.getStatusCode() == 200) {
            return response.items;
        } else {
            insert UtilityClass.logInternalError(searchResponse.getBody(), 'WebDAMConnector SearchByString', '', 'WebDAMConnector', true, '', '');
            throw new WebDAMConnectorException(searchResponse.getBody());
        }
    }

    public Blob getDAMFile(String assetId) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(BASE_URL + '/assets/' + assetId + '/download');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        Http getDAMFile = new Http();

        HttpResponse downloadResponse = getDAMFile.send(req);

        if (downloadResponse.getStatusCode() == 200) {
            return downloadResponse.getBodyAsBlob();
        } else {
            insert UtilityClass.logInternalError(downloadResponse.getBody(), 'WebDAMConnector SearchByString', '', 'WebDAMConnector', true, '', '');
            throw new WebDAMConnectorException(downloadResponse.getBody());
        }
    }

    public class WebDAMConnectorException extends Exception {}
}