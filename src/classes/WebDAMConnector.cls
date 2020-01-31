/**
 * Created by jharrell on 1/27/20.
 */

public class WebDAMConnector {
    private final String BASE_URL = 'https://apiv2.webdamdb.com/';
    private String refresh_token {
        get;
        set;
    }
    private String accessToken {
        get;
        set;
    }
    public Boolean isAuthed {
        get;
        set;
    }
    private WebDAM_Connector__c webDAMConnectorConfig { get; set; }

    public WebDAMConnector() {

        webDAMConnectorConfig = WebDAM_Connector__c.getInstance();
        this.isAuthed = false;

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://apiv2.webdamdb.com/oauth2/token');
        //req.setHeader('Content-Type', 'application/json');
        String requestBody = 'grant_type=password&client_id='+webDAMConnectorConfig.client_id__c+'&client_secret='+webDAMConnectorConfig.client_secret__c+'&username='+webDAMConnectorConfig.username__c+'&password='+webDAMConnectorConfig.password__c;
        req.setBody(requestBody);
        Http reqCallOut = new Http();

        HttpResponse authenticateResponse = reqCallOut.send(req);
        if (authenticateResponse.getStatusCode() == 200) {
            String responseBody = authenticateResponse.getBody();

            WebDAMConnectorAuthResponse response = WebDAMConnectorAuthResponse.parse(responseBody);

            this.refresh_token = response.refresh_token;
            this.accessToken = response.access_token;
            this.isAuthed = true;

        } else {
            insert UtilityClass.logInternalError(authenticateResponse.getBody(), 'WebDAMConnector Init', '', 'WebDAMConnector', true, '', '');
            throw new WebDAMConnectorException(authenticateResponse.getBody());
        }
    }


    // Asset download curl -L https://apiv2.webdamdb.com/assets/123123123/download
    // Search curl https://apiv2.webdamdb.com/search?sortby=filename&sortdir=desc&limit=20&offset=0&query=dog&folderid=405352

    public List<WebDAMConnectorAuthResponse.items> searchByString(String searchParam) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(BASE_URL + 'search?sortby=datemodified&sortdir=desc&offset=0&query=' + searchParam);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        Http reqCallOut = new Http();

        HttpResponse authenticateResponse = reqCallOut.send(req);

        System.debug(authenticateResponse);
        System.debug(authenticateResponse.getBody());
        WebDAMConnectorAuthResponse response = WebDAMConnectorAuthResponse.parse(authenticateResponse.getBody());

        System.debug('File name: ' + response.items[0].filename);
        // TODO handle return being null
        return response.items;

    }

    // 00l70000001Ca9kAAC inside sales folder
    public Blob getDAMFile(String assetId) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(BASE_URL + 'assets/' + assetId + '/download');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        Http reqCallOut = new Http();

        HttpResponse authenticateResponse = reqCallOut.send(req);
        // TODO Handle unexpectec body
        return authenticateResponse.getBodyAsBlob();

    }

    public class WebDAMConnectorException extends Exception {}
}