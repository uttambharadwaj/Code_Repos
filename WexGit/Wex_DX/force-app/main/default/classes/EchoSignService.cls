/**
* Forseva online application code.
*/
public with sharing class EchoSignService {

    public EchoSignService() {}

    //------------------
    // getters & setters
    //------------------

    public void setApiKey(String apiKey) {
        m_apiKey = apiKey;
    }    

    public void setFileName(String fileName) {
        m_fileName = fileName;
    }

    public void setFileContents(Blob fileContents) {
        m_fileContents = EncodingUtil.base64Encode(fileContents);
    }

    public void setContractName(String contractName) {
        m_contractName = contractName;
    }

    public void setCustomerEmail(String customerEmail) {
        m_customerEmail = customerEmail;
    }

    public void setSenderEmail(String senderEmail) {
        m_senderEmail = senderEmail;
    }
    
    public void setSenderPassword(String senderPassword) {
        m_senderPassword = senderPassword;
    }
    
    public void setSuccessUrl(String successUrl) {
        m_successUrl = successUrl;
    }

    //-------------------
    // 'action' methods
    //-------------------

    public String getContractJavaScriptUrl() {
    
        String request = m_requestTemplate.replaceAll('__transactionType__', 'createPersonalEmbeddedWidget')
                                          .replace('__apiKey__', m_apiKey) 
                                          .replace('__fileName__', m_fileName)
                                          .replace('__fileContents__', m_fileContents)
                                          .replace('__contractName__', m_contractName)
                                          .replace('__customerEmail__', m_customerEmail)
                                          .replace('__senderEmail__', m_senderEmail)
                                          .replace('__senderPassword__', m_senderPassword == null ? '' : m_senderPassword)
                                          .replace('__successUrl__', m_successUrl);
            
        //System.debug('REQUEST: ' + request);
        String response = formatAndSendRequest(request, m_testResponse);
        //System.debug('RESPONSE: ' + response);
        //<?xml version="1.0" encoding="UTF-8"?>
        //<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        //    <soap:Body>
        //        <createPersonalEmbeddedWidgetResponse xmlns="http://api.echosign">
        //            <embeddedWidgetCreationResult>
        //                <documentKey xmlns="http://dto8.api.echosign">28IZC6X54E6M7H</documentKey>
        //                <errorCode xmlns="http://dto8.api.echosign">OK</errorCode>
        //                <errorMessage xsi:nil="true" xmlns="http://dto8.api.echosign" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />
        //                <javascript xmlns="http://dto8.api.echosign">&lt;script type='text/javascript' language='JavaScript' src='https://secure.echosign.com/public/widget?f=3FCK73S5E4I45&amp;token=EZG90G9K230E59B5LIWTQMEL'>&lt;/script></javascript>
        //                <success xmlns="http://dto8.api.echosign">true</success>
        //            </embeddedWidgetCreationResult>
        //        </createPersonalEmbeddedWidgetResponse>
        //    </soap:Body>
        //</soap:Envelope>            
        response = response.substring(response.indexOf('src=\'')+5, response.indexOf('\'>&lt;/script>'));
        return response;            
    }

    public String getContractUrl() {
    
        String request = m_requestTemplate.replaceAll('__transactionType__', 'createPersonalUrlWidget')
                                          .replace('__apiKey__', m_apiKey) 
                                          .replace('__fileName__', m_fileName)
                                          .replace('__fileContents__', m_fileContents)
                                          .replace('__contractName__', m_contractName)
                                          .replace('__customerEmail__', m_customerEmail)
                                          .replace('__senderEmail__', m_senderEmail)
                                          .replace('__senderPassword__', m_senderPassword == null ? '' : m_senderPassword)
                                          .replace('__successUrl__', m_successUrl);
            
        //System.debug('REQUEST: ' + request);
        String response = formatAndSendRequest(request, m_testResponse);
        //System.debug('RESPONSE: ' + response);
        //<?xml version="1.0" encoding="UTF-8"?>
        //<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        //    <soap:Body>
        //        <createPersonalUrlWidgetResponse xmlns="http://api.echosign">
        //            <urlWidgetCreationResult>
        //                <documentKey xmlns="http://dto8.api.echosign">dXYJ3GQXD67523S</documentKey>
        //                <errorCode xmlns="http://dto8.api.echosign">OK</errorCode>
        //                <errorMessage xmlns="http://dto8.api.echosign" xsi:nil="true" />
        //                <success xmlns="http://dto8.api.echosign">true</success>
        //                <url xmlns="http://dto8.api.echosign">https://secure.echosign.com/public/hostedForm?formid=dEFTEVX3WXX3C&amp;token=Y5RQBSL5GIH9OFIH8PL7TCQ0</url>
        //            </urlWidgetCreationResult>
        //        </createPersonalUrlWidgetResponse>
        //    </soap:Body>
        //</soap:Envelope>

        // THIS URL IS ECHO SIGN ACCOUNT SPECIFIC
        String contractUrl = null;
        //if(response.indexOf('https://fleetone.echosign.com/public/hostedForm') != -1) {
        if(response.indexOf('.echosign.com/public/') != -1) {
            //response = response.substring(response.indexOf('https://fleetone.echosign.com/public/hostedForm'), response.indexOf('</url>'));        
            Integer startPos = response.toLowerCase().indexOf('<url ');
            Integer endPos = response.indexOf('>', startPos);
            contractUrl = response.substring(endPos + 1, response.indexOf('</url>', endPos));
            contractUrl = contractUrl.replace('&amp;', '&');
            System.debug('RP: in EchoSignSvc: contractUrl = ' + contractUrl);
        }
        else {
            //response = response.substring(response.indexOf('https://forseva.echosign.com/public/hostedForm'), response.indexOf('</url>'));
            Integer startPos = response.toLowerCase().indexOf('<url ');
            Integer endPos = response.indexOf('>', startPos);
            contractUrl = response.substring(endPos + 1, response.indexOf('</url>', endPos));
            contractUrl = contractUrl.replace('&amp;', '&');
            System.debug('RP: in EchoSignSvc: contractUrl = ' + contractUrl);
        }
        
        //response = response.replace('&amp;', '&');
        //return response;            
        return contractUrl;            
    }

    //--------------
    // private
    //--------------

    private String m_apiKey;
    private String m_fileName;
    private String m_fileContents;
    private String m_contractName;
    private String m_customerEmail;
    private String m_senderEmail;
    private String m_senderPassword;  // optional field (for multi-user accounts)
    private String m_successUrl;

    private String formatAndSendRequest(String request, String testResponseXml) {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(m_serviceUrl);
        req.setTimeout(60000);
        req.setMethod('POST');
        req.setHeader('Content-Type','text/xml; charset=UTF-8');
        req.setBody(request);
        
        if(Test.isRunningTest()) {
            return testResponseXml;
        }
        else {
            HttpResponse res = h.send(req);
            return res.getBody();            
        }
    }

    private final static String m_serviceUrl = 'https://secure.echosign.com/services/EchoSignDocumentService10';
    private final static String m_testResponse = '<yaba><daba><javascript xmlns="http://dto8.api.echosign">&lt;script type=\'text/javascript\' language=\'JavaScript\' src=\'https://secure.echosign.com/public/widget?f=3FCK73S5E4I45&amp;token=EZG90G9K230E59B5LIWTQMEL\'>&lt;/script></javascript><url xmlns="http://dto8.api.echosign">https://fleetone.echosign.com/public/hostedForm?formid=dEFTEVX3WXX3C&amp;token=Y5RQBSL5GIH9OFIH8PL7TCQ0</url></daba></yaba>';
    private final String m_requestTemplate = 
    
    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
        '<soap:Body>' +
            '<__transactionType__ xmlns="http://api.echosign">' +
                '<apiKey>__apiKey__</apiKey> ' +
                '<senderInfo xmlns:ns3="http://dto9.api.echosign" xmlns:ns2="http://dto.api.echosign">' +
                    '<ns2:email>__senderEmail__</ns2:email>' +
                    (m_senderPassword != null ? '<ns2:password>__senderPassword__</ns2:password>' : '') +
                '</senderInfo>' + 
                '<ns4:widgetInfo xmlns:ns4="http://api.echosign" xmlns:ns3="http://dto9.api.echosign" xmlns:ns2="http://dto.api.echosign" xmlns="http://dto8.api.echosign">' +
                    '<callbackInfo xsi:nil="true" /> ' +
                    '<fileInfos>' +
                        '<ns2:FileInfo>' +
                            '<ns2:file>__fileContents__</ns2:file>' + 
                            '<ns2:fileName>__fileName__</ns2:fileName>' + 
                            '<ns2:formKey xsi:nil="true" /> ' +
                            '<ns2:libraryDocumentKey xsi:nil="true" />' + 
                            '<ns2:libraryDocumentName xsi:nil="true" /> ' +
                            '<ns2:mimeType xsi:nil="true" /> ' +
                            '<ns2:url xsi:nil="true" /> ' +
                        '</ns2:FileInfo>' +
                    '</fileInfos>' +
                    '<locale xsi:nil="true" />' + 
                    '<mergeFieldInfo xsi:nil="true" />' + 
                    '<name>__contractName__</name>' + 
                    '<securityOptions xsi:nil="true" /> ' +
                    '<signatureFlow xsi:nil="true" /> ' +
                    '<widgetCompletionInfo>' +
                        '<deframe>false</deframe>' +
                        '<delay>1</delay>' +
                        '<url>__successUrl__</url>' +
                    '</widgetCompletionInfo>' + 
                '</ns4:widgetInfo>' +
                '<ns4:personalizationInfo xmlns:ns4="http://api.echosign" xmlns:ns3="http://dto9.api.echosign" xmlns:ns2="http://dto.api.echosign" xmlns="http://dto8.api.echosign">' +
                    '<allowManualVerification xsi:nil="true" /> ' +
                    '<comment></comment> ' +
                    '<email>__customerEmail__</email> ' +
                    '<reusable xsi:nil="true" /> ' +
                '</ns4:personalizationInfo>' +
            '</__transactionType__>' +
        '</soap:Body>' +
    '</soap:Envelope>';    


}

// EOF