/**
 * Created by lhowland on 5/9/2018.
 */

public class CreditWS_Experian {

    private static String PROD_DB_HOST = 'CIS';
    private static String UAT_DB_HOST = 'STAR';
    private static String PROD_RR_KEYWORD = 'DXP1';
    private static String UAT_RR_KEYWORD = 'XXP1';
    private static String NAMESPACE = 'http://www.experian.com/ARFResponse';
    private static String extraExperianData = '';
    private static String premierAttributes = '';
    private static String premierAttributeCodes = '';
    private static Integer pgHighCredit = 0;
    private static Boolean inquiryAddressHighRisk = false;
    private static Boolean securityStatement = false;
    private static Boolean onFileAddressHighRisk = false;

    public static Credit_Decision_Engine_Endpoints__mdt experianSettings {
        get {

            try {
                Credit_Decision_Engine_Endpoints__mdt experianSettings = [SELECT Id, Username__c, Password__c, Preamble__c, Subcode__c, Endpoint_URL__c, DB_Host__c, RR_Keyword__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Experian_Toolkit'];

                return experianSettings;
            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting Experian Toolkit connection settings.');

            }
            return null;
        }
    }

    public static ExperianResponse getCreditScore(ExperianRequest experianRequest) {

        ExperianResponse experianResponse = new ExperianResponse();

        try {
            Blob headerValue = Blob.valueOf(experianRequest.userId + ':' + experianRequest.password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);

            // Prior to posting data, the Net Connect client must check the URL and digital certificates on the HTTPS server.
            String endpoint = getAuthenticationInfo(experianRequest);

            if(null != endpoint){
                HttpRequest reqNetConnect = buildExperianNetConnectRequest(endpoint, authorizationHeader, experianRequest);
                // System.debug('Auth Header with payload-------' + authorizationHeader);
                System.debug('Experian connect request----' +reqNetConnect);
                System.debug('Experian connect body----' + reqNetConnect.getBody());
                reqNetConnect.setTimeout(30000);

                // Get the Credit Information
                Http httpNetConnect = new Http();
                HTTPResponse consumerIdScoreResponse = httpNetConnect.send(reqNetConnect);

                system.debug('Experian response----' + consumerIdScoreResponse);
                System.debug('Experian response header-server -----' + consumerIdScoreResponse.getHeader('Server'));
                System.debug('Experian response header-Location -----' + consumerIdScoreResponse.getHeader('Location'));
                System.debug('Experian response body----' +consumerIdScoreResponse.getBody());

                if(!TestUtils.isRunningTest()) {
                    String creditScore = parseResponse(consumerIdScoreResponse);
                    experianResponse.creditScore = Integer.valueOf(creditScore);
                    experianResponse.experianData = extraExperianData;
                    experianResponse.premierAtrributes = premierAttributes;
                    experianResponse.premierAttributeCodes = premierAttributeCodes;
                    experianResponse.pgHighCredit = pgHighCredit;
                    experianResponse.inquiryAddressHighRisk = inquiryAddressHighRisk;
                    experianResponse.securityStatement = securityStatement;
                    experianResponse.onFileAddressHighRisk = onFileAddressHighRisk;
                    System.debug('inquiry address high risk being set to the response: ' + inquiryAddressHighRisk);
                }
            }

            return experianResponse;

        } catch(Exception e) {
            System.debug('### ERROR: Unable to retrieve Credit Score');
            System.debug('Error message: ' + e.getMessage());
            experianResponse.calloutFailed = true;
        }

        return null;
    }

    public static String parseResponse(HTTPResponse experianResponse){

        Dom.document doc = experianResponse.getBodyDocument();
        String creditScore = '0';

        try {
            Dom.XmlNode rootNode = doc.getRootElement();
            List<Dom.XmlNode> customSolution = rootNode.getChildElement('Products', NAMESPACE)
                    .getChildElement('CustomSolution', NAMESPACE)
                    .getChildElements();
            for (Dom.XmlNode node : customSolution) {
                if (node.getName().equalsIgnoreCase('RiskModel')) {
                    Dom.XmlNode modelIndicator = node.getChildElement('ModelIndicator', NAMESPACE);
                    // F is the code for FICO2 (Experian/Fair, Isaac Risk Model V2)
                    if (modelIndicator.getAttribute('code',null).equalsIgnoreCase('F') || modelIndicator.getAttribute('code',null).equalsIgnoreCase('F ')) {
                        creditScore = node.getChildElement('Score', NAMESPACE).getText();
                    }
                }
                else if (node.getName().equalsIgnoreCase('FraudServices')) {
                    populateFraudIndicators(node);
                }
                extraExperianData += collectChildrenData(node, extraExperianData);
            }

        } catch(Exception e) {
            System.debug('### ERROR: ' + e.getMessage());
        }

        return creditScore;
    }

    /*
     * Converts a Dom.XmlNode date to a Date object
     * Format of Dom date: MMDDYYYY or MMYY
     */
    private static Date domToDate(Dom.XmlNode domDate) {

        String domDateAsStirng = domDate.getText();
        if (domDateAsStirng.length() == 4) {
            String day = '01';  // day not offered on 4 digit dates
            String month = domDateAsStirng.substring(0,2);
            // fuzzy logic to pick century. Assume 2000's, if that then is future dated, change to 1900's
            String year = '20' + domDateAsStirng.substring(2,4);
            Date statusDate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
            if (statusDate > Date.today()) {
                year = '19' + domDateAsStirng.substring(2,4);
                statusDate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
            }
            return statusDate;
        }
        String month = domDateAsStirng.substring(0,2);
        String day = domDateAsStirng.substring(2,4);
        String year = domDateAsStirng.substring(4,8);
        return Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
    }

    /*
       Until the extra data in the Experian response is being used, traverse through the XML response and store values in a formatted text area
     */
    private static String collectChildrenData(Dom.XmlNode node, String extraExperianData) {

        extraExperianData = node.getName() + '\n';
        List<Dom.XmlNode> children = node.getChildElements();

        if (children.isEmpty()) {
            extraExperianData += ': ' + node.getText() + '\n';
        } else if(children[0].getName().equalsIgnoreCase('Attribute')) {
            // pull Premier Attributes out into a separate field
            populatePremierAttributes(children);
        } else {
            for (Dom.XmlNode child : children) {
                extraExperianData += child.getName();
                if (!child.getChildElements().isEmpty()) {
                    extraExperianData += collectChildrenData(child, extraExperianData);
                } else {
                    extraExperianData += ': ' + child.getText() + '\n';
                }
            }
        }
        return extraExperianData;
    }

    private static void populatePremierAttributes(List<Dom.XmlNode> attributes) {

        Boolean useREH5420 = false;
        Integer reh5420;
        Map<String, String> epadMap = new Map<String, String>();

        for(Experian_Premier_Attributes_Description__mdt epad : [SELECT Code__c, Description__c FROM Experian_Premier_Attributes_Description__mdt])
            epadMap.put(epad.Code__c, epad.Description__c);

        for(Dom.XmlNode child : attributes){ 

            String code = child.getChildElement('Name',NAMESPACE).getText();
            String value = child.getChildElement('Value',NAMESPACE).getText();
        
            // created for reporting
            premierAttributeCodes += code + ':' + value + ',';

            if(epadMap.containsKey(code))
                premierAttributes += epadMap.get(code) + '\n' + value + '\n \n';

            // ILN5420 is custom Premier Attribute
            if (code.equalsIgnoreCase('ILN5420')) {
                // if ILN5420 is all 9's then need to use alternative attribute for high credit amount value
                if (value.startsWith('9999')) {
                    useREH5420 = true;
                } else {
                    pgHighCredit = Integer.valueOf(value);
                }
            } else if (code.equalsIgnoreCase('REH5420')) {
                reh5420 = Integer.valueOf(value);
            }
        }

        if(reh5420 != null && useREH5420)
            pgHighCredit = reh5420;

    }

    private static void populateFraudIndicators(Dom.XmlNode fraudServices) {

        List<Dom.XmlNode> fraudServicesChildren = fraudServices.getChildElements();

        for (Dom.XmlNode node : fraudServicesChildren) {
            if (node.getName().equalsIgnoreCase('Indicator') && node.getText().equals('10')) {
                System.debug('inquiry address high risk 02: ' + inquiryAddressHighRisk);
                inquiryAddressHighRisk = true;
            }
            else if (node.getName().equalsIgnoreCase('Indicator') && node.getText().equals('12')) {
                securityStatement = true;
            }
            else if (node.getName().equalsIgnoreCase('Indicator') && node.getText().equals('16')) {
                onFileAddressHighRisk = true;
            }
        }
        System.debug('inquiry address high risk in method: ' + inquiryAddressHighRisk);
    }

    public static String getAuthenticationInfo(ExperianRequest experianRequest) {

        String url = experianSettings.Endpoint_URL__c;
        HttpRequest reqAuthentication = new HttpRequest();
        reqAuthentication.setEndpoint(url);
        reqAuthentication.setMethod('POST');

        Blob headerValue = Blob.valueOf(experianRequest.userId + ':' + experianRequest.password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        reqAuthentication.setHeader('Authorization', authorizationHeader);
        reqAuthentication.setHeader('Content-Type','application/x-www-form-urlencoded');
        Http http = new Http();

        try {
            HttpResponse resAuthentication = http.send(reqAuthentication);

            if (resAuthentication.getStatusCode() == 200) {
                return resAuthentication.getBody();
            }
        } catch (CalloutException ce) {
            System.debug('Exception occurred when attempting to authenticate with Experian. Error: ' + ce.getMessage());
        }
        return null;
    }

    private static String formatPhoneNumber(String phone) {

        phone = phone.replaceAll('[^0-9]','');
        // Exerian requires a length no longer than 13 characters for phone number
        if (phone.length() > 13) {
            phone = phone.substring(0,13);
        }
        System.debug('Phone post formatting:' + phone);
        return phone;
    }

    public static HttpRequest buildExperianNetConnectRequest(String endpoint, String authorizationHeader, ExperianRequest experianRequest) {

        HttpRequest reqNetConnect = new HttpRequest();
        reqNetConnect.setEndpoint(endpoint);
        reqNetConnect.setMethod('POST');
        reqNetConnect.setHeader('Authorization', authorizationHeader);
        reqNetConnect.setHeader('Content-Type','application/x-www-form-urlencoded');

        String requestConsumerScoreBody =  'NETCONNECT_TRANSACTION=<?xml version="1.0" encoding="UTF-8"?>' +
                                        '<NetConnectRequest xmlns="http://www.experian.com/NetConnect" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.experian.com/NetConnect">' +
                                            '<EAI>' + 'HOIHBLDK' + '</EAI>' +
                                            '<DBHost>' + experianSettings.DB_Host__c + '</DBHost>' +
                                            '<Request xmlns="http://www.experian.com/WebDelivery" version="1.0">' +
                                                '<Products>' +
                                                    '<CustomSolution>' +
                                                        '<Subscriber>' +
                                                            '<Preamble>' + experianSettings.Preamble__c + '</Preamble>'+
                                                            '<OpInitials>'+ 'WX' +'</OpInitials>'+
                                                            '<SubCode>' + experianSettings.Subcode__c + '</SubCode>'+
                                                        '</Subscriber>' +
                                                        '<PrimaryApplicant>' +
                                                            '<Name>' +
                                                                '<Surname>' + experianRequest.contactLastName.subStringBefore(' ').replaceAll('&','').replaceAll('<','').replaceAll('>','').replaceAll('"','').replaceAll('`','') + '</Surname>' +
                                                                '<First>' + experianRequest.contactFirstName.subStringBefore(' ').replaceAll('&','').replaceAll('<','').replaceAll('>','').replaceAll('"','').replaceAll('`','') + '</First>' +
//                                                                '<Middle>' + 'QUINCY' + '</Middle>' +
//                                                                '<Gen>' + 'JR' + '</Gen>' +
                                                            '</Name>';
                                                            if(null != experianRequest.socialSecurityNumber) {
                                                                 requestConsumerScoreBody = requestConsumerScoreBody + '<SSN>' + experianRequest.socialSecurityNumber.replaceAll('\\D','') + '</SSN>';
                                                            }
                                                            System.debug('ADDRESS : ' + experianRequest.address.replaceAll('[^a-z^A-z^0-9 ]', ''));
                                                            requestConsumerScoreBody = requestConsumerScoreBody + '<CurrentAddress>' +
                                                                    // address format required: [A-Za-z0-9\s\-#/\.']
                                                            '<Street>' + experianRequest.address.replaceAll('[^a-z^A-z^0-9 ]', '') + '</Street>' +
                                                            '<City>' + experianRequest.city + '</City>' +
                                                            '<State>' + experianRequest.state + '</State>' +
                                                            '<Zip>' + String.valueOf(experianRequest.zipCode).substring(0,5) + '</Zip>' +
                                                            '</CurrentAddress>';
                                                            if (null != experianRequest.phone) {
                                                                String phoneNumber = formatPhoneNumber(experianRequest.phone);
                                                                requestConsumerScoreBody = requestConsumerScoreBody +
                                                                '<Phone>' +
                                                                        '<Number>' + phoneNumber + '</Number>' +
                                                                        '<Type>' + 'R' + '</Type>' +
                                                                '</Phone>';
                                                            }
                                                            if(null != experianRequest.dateOfBirthDay){
                                                                requestConsumerScoreBody = requestConsumerScoreBody + '<DOB>' +
                                                                        experianRequest.dateOfBirthMonth +
                                                                        experianRequest.dateOfBirthDay +
                                                                        experianRequest.dateOfBirthYear +
                                                                        '</DOB>';
                                                            }
                                                            requestConsumerScoreBody = requestConsumerScoreBody + '</PrimaryApplicant>' +
                                                        '<AddOns>' +
                                                            '<RiskModels>' +
                                                                 '<FICO2>' + 'Y' + '</FICO2>' +
                                                                 '<FraudShield>' + 'Y' + '</FraudShield>' +
                                                                 '<VantageScore>' + 'Y'+ '</VantageScore>' +
                                                                 '<BankruptcyPLUS>' + 'Y' +'</BankruptcyPLUS>' +
//                                                                    '<NationalRisk>' + 'Y' + '</NationalRisk>' +
//                                                                    '<OldNational>' + 'Y' + '</OldNational>' +
                                                            '</RiskModels>' +
                                                            '<CustomRRDashKeyword>' + experianSettings.RR_Keyword__c + '</CustomRRDashKeyword>' +
                                                        '</AddOns>' +
                                                         '<AccountType>' +
                                                                    '<Type>' + experianRequest.accountPurposeCode + '</Type>' +
                                                         '</AccountType>' +
                                                        '<OutputType>' +
                                                            '<XML>' +
                                                                '<ARFVersion>' + '07' + '</ARFVersion>' +
                                                                '<Verbose>' + 'Y' + '</Verbose>' +
                                                                '<Demographics>' + 'Y' + '</Demographics>' +
                                                                '<Y2K>' + 'Y' + '</Y2K>' +
                                                                '<Segment130>' + 'Y' + '</Segment130>' +
                                                            '</XML>' +
                                                        '</OutputType>' +
                                                        '<Vendor>' +
                                                             '<VendorNumber>277</VendorNumber>' +
                                                             '<VendorVersion>1</VendorVersion>' +
                                                         '</Vendor>' +
                                                        '<Options>' +
                                                            '<ReferenceNumber>' + 'WEXPE' + '</ReferenceNumber>'  +
                                                        '</Options>' +
                                                    '</CustomSolution>' +
                                                '</Products>' +
                                            '</Request>' +
                                        '</NetConnectRequest>';

        reqNetConnect.setBody(requestConsumerScoreBody);

        return reqNetConnect;
    }

    public class ExperianRequest {

        public String userId { get; set; }
        public String password { get; set; }

        public String contactFirstName { get; set; }
        public String contactLastName { get; set; }
        public String socialSecurityNumber { get; set; }
        public String address { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String zipCode { get; set; }
        public String phone { get; set; }
        public String dateOfBirthMonth { get; set; }
        public String dateOfBirthDay { get; set; }
        public String dateOfBirthYear { get; set; }
        public String accountPurposeCode { get; set; }

        public ExperianRequest() {

            this.userId = experianSettings.Username__c;
            this.password = experianSettings.Password__c;

        }
    }

    public class ExperianResponse {

        public Integer creditScore { get; set; }
        public String experianData { get; set; }
        public String premierAtrributes { get; set; }
        public String premierAttributeCodes { get; set; }
        public Integer pgHighCredit { get; set; }
        public Boolean calloutFailed { get; set; }
        public Boolean inquiryAddressHighRisk { get; set; }
        public Boolean securityStatement { get; set; }
        public Boolean onFileAddressHighRisk { get; set; }

        public ExperianResponse() {
            this.creditScore = 0;
            this.calloutFailed = false;
        }

    }

}