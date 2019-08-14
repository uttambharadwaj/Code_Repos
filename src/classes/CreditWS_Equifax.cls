/**
 * Created by lhowland on 12/5/2018.
 */

public with sharing class CreditWS_Equifax {

    public static String NAMESPACE = 'http://www.equifax.ca/XMLSchemas/EfxToCust';
    public static String UAT_ENDPOINT = 'https://uat.equifax.ca/efxws/STSRequest.asmx';
    public static String PROD_ENDPOINT = 'https://www.equifax.ca/efxws/STSRequest.asmx';
    public static String UAT_MEMBER_NUMBER = '999ZS01041';
    public static String PROD_MEMBER_NUMBER = '400ZS54843';
    public static String UAT_SECURITY_CODE = '99';
    public static String PROD_SECURITY_CODE = '88';
    public static String UAT_EFX_ENV = 'A01PKSS';
    public static String PROD_EFX_ENV = 'A01PACK';
    public static String UAT_SCHEMA_LOCATION = 'http://www.equifax.ca/XMLSchemas/UAT/CNCustTransmitToEfx.xsd';
    public static String PROD_SCHEMA_LOCATION = 'http://www.equifax.ca/XMLSchemas/Production/CNCustTransmitToEfx.xsd';
    public static List<String> addressNumberAndStreet = new List<String>();
    public static List<String> phoneAreaCodeAndNumber = new List<String>();
    private static String extraEquifaxData = '';
    private static Integer pgHighCreditAmount = 0;

    public static EquifaxResponse getCreditScore(EquifaxRequest equifaxRequest) {

        EquifaxResponse equifaxResponse = new EquifaxResponse();

        // Check that data required to send the request is available
        if (dataPreChecks(equifaxRequest)) {

            try {
                // build request
                HttpRequest httpRequest = new HttpRequest();
                httpRequest.setMethod('POST');
                String xmlRequest = buildRequestBody(equifaxRequest);
                System.debug('Equifax Request = ' + xmlRequest);
                httpRequest.setHeader('Content-Type', 'text/xml; charset=utf-8');
                httpRequest.setHeader('SOAPAction', 'https://www.Equifax.ca/EFXWS/STSRequest/Submit');
                httpRequest.setTimeout(115000);

                httpRequest.setEndpoint(PROD_ENDPOINT);
                httpRequest.setBody(xmlRequest);

                // get response
                Http httpConnect = new Http();
                HttpResponse httpResponse = httpConnect.send(httpRequest);

                if (!TestUtils.isRunningTest()) {
                    equifaxResponse = parseResponse(httpResponse, equifaxResponse);
                }

                return equifaxResponse;

            } catch (Exception e) {
                System.debug('### ERROR: Unable to retrieve Credit Score');
                System.debug('Error message: ' + e.getMessage());
                equifaxResponse.calloutFailed = true;
            }
        } else {
            System.debug('Missing required data to send request to Equifax (missing social insurance number, first name, or last name or unable to parse address.');
        }

        return null;
    }

    private static Boolean dataPrechecks(EquifaxRequest equifaxRequest) {

        if (equifaxRequest.firstName ==  null || equifaxRequest.lastName == null) {
            return false;
        }

        parseAddress(equifaxRequest.address);

        if (addressNumberAndStreet == null || addressNumberAndStreet.size() < 2) {
            return false;
        }
        return true;
    }

    private static void parsePhone(String phone) {

        // Strip phone number of any non-numeric characters
        phone = phone.replaceAll('\\D','');

        // remove country code if there
        if (phone.length() >= 10) {
            phone = phone.substring(phone.length()-10, phone.length());
        }

        phoneAreaCodeAndNumber.add(phone.substring(0,3));
        phoneAreaCodeAndNumber.add(phone.substring(3, phone.length()));
        System.debug('phone area code: '+ phoneAreaCodeAndNumber[0]);
        System.debug('phone number without areacode: '+ phoneAreaCodeAndNumber[1]);
    }

    /**
     * Silly ghetto mapping of provinces because Equifax requires both the abbreviation and full province name
     */
    private static String getProvinceDescription(String provinceCode) {

        if (provinceCode != null) {
            if (provinceCode.equalsIgnoreCase('ON')) return 'Ontario';
            else if (provinceCode.equalsIgnoreCase('QC')) return 'Quebec';
            else if (provinceCode.equalsIgnoreCase('NS')) return 'Nova Scotia';
            else if (provinceCode.equalsIgnoreCase('NB')) return 'New Brunswick';
            else if (provinceCode.equalsIgnoreCase('MB')) return 'Manitoba';
            else if (provinceCode.equalsIgnoreCase('BC')) return 'British Columbia';
            else if (provinceCode.equalsIgnoreCase('PE')) return 'Prince Edward Island';
            else if (provinceCode.equalsIgnoreCase('SK')) return 'Saskatchewan';
            else if (provinceCode.equalsIgnoreCase('AB')) return 'Alberta';
            else if (provinceCode.equalsIgnoreCase('NL')) return 'Newfoundland and Labrador';
        }
        return '';
    }

    public static void parseAddress(String address) {

        String streetNumber = address.substringBefore(' ');

        if (streetNumber.isNumeric()) {
            addressNumberAndStreet.add(streetNumber);
            String streetName = address.substring(addressNumberAndStreet[0].length()+1, address.length());
            addressNumberAndStreet.add(streetName);

            System.debug('address number: ' + addressNumberAndStreet[0]);
            System.debug('address street: ' + addressNumberAndStreet[1]);
        } else {
            System.debug('Incorrect address format. Street Number not all numeric: ' + streetNumber);
        }
    }

    /**
     * A status 200 response will be in this format:
     *
     * <?xml version="1.0" encoding="utf-8"?>
     *     <soap:Envelope>
     *          <soap:Body>
     *               <SubmitResponse>
     *                   <SubmitResult> URL ENCODED XML RESPONSE HERE </SubmitResult>
     *              </SubmitResponse>
     *          </soap:Body>
     *      </soap:Envelope>
     */

    public static EquifaxResponse parseResponse(HttpResponse httpResponse, EquifaxResponse equifaxResponse) {

        Dom.Document doc = httpResponse.getBodyDocument();
        String creditScore = '0';
        String stringResponse = '';
        List<Dom.XmlNode> xmlResponse = new List<Dom.XmlNode>();

        try {
            Dom.XmlNode rootNode = doc.getRootElement();
            List<Dom.XmlNode> response = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                                .getChildElement('SubmitResponse', 'https://www.Equifax.ca/EFXWS/STSRequest')
                                .getChildElements();

            if (response.size() > 0 ) {
                for (Dom.XmlNode node : response) {

                    if (node.getName().equalsIgnoreCase('SubmitResult')) {
                        stringResponse = EncodingUtil.urlDecode(node.getText(), 'UTF-8');
                        System.debug('TEMP decoded response = ' + stringResponse);
                        doc = new Dom.Document();
                        doc.load(stringResponse);
                        rootNode = doc.getRootElement();

                        // first check if the response contains an error report
                        if (rootNode.getChildElement('CNErrorReport', NAMESPACE) != null) {
                            extraEquifaxData += collectChildrenData(rootNode.getChildElement('CNErrorReport', NAMESPACE), extraEquifaxData);
                        }
                        else {
                            xmlResponse = rootNode.getChildElement('EfxReport', NAMESPACE)
                                    .getChildElement('CNConsumerCreditReports', NAMESPACE)
                                    .getChildElement('CNConsumerCreditReport', NAMESPACE)
                                    .getChildElements();

                            for (Dom.XmlNode creditNode : xmlResponse) {
                                if (creditNode.getName().equalsIgnoreCase('CNTrades')) {
                                    equifaxResponse.pgHighCredit = getPGHighCreditAmount(creditNode);
                                }
                                if (creditNode.getName().equalsIgnoreCase('CNScores')) {
                                    creditScore = creditNode.getChildElement('CNScore', NAMESPACE)
                                            .getChildElement('Result', NAMESPACE)
                                            .getChildElement('Value', NAMESPACE)
                                            .getText();
                                    if (creditScore.startsWith('00')) {
                                        // trim off leading 0's
                                        creditScore = creditScore.substring(2, 5);
                                    }
                                    equifaxResponse.creditScore = Integer.valueOf(creditScore);
                                }
                            }
                            extraEquifaxData += collectChildrenData(rootNode, extraEquifaxData);
                        }
                    }
                }
                equifaxResponse.equifaxData = extraEquifaxData;
            }

            return equifaxResponse;

        } catch (Exception e) {
            System.debug('### ERROR: ' + e.getMessage());
            equifaxResponse.calloutFailed = true;
        }
        return null;
    }

    /**
     *  Check every trade line excluding mortgages and keep track of the highest credit amount.
     */
    private static Integer getPGHighCreditAmount(Dom.XmlNode tradeLinePackage) {

        List<Dom.XmlNode> tradeLineNodes = tradeLinePackage.getChildElements();
        String currentNodeHighCreditAmount = '0';

        for (Dom.XmlNode node : tradeLineNodes) {
            Dom.XmlNode porfolioType = node.getChildElement('PortfolioType', NAMESPACE);

            if (!(porfolioType.getAttribute('description',null).equalsIgnoreCase('Mortgage'))) {
                currentNodeHighCreditAmount = node.getChildElement('HighCreditAmount', NAMESPACE).getText();

                if (currentNodeHighCreditAmount != null && (Integer.valueOf(currentNodeHighCreditAmount) >  pgHighCreditAmount)) {
                    pgHighCreditAmount = Integer.valueOf(currentNodeHighCreditAmount);
                }
            }
        }
        return pgHighCreditAmount;
    }

    /**
     * For the given node, traverse the XML taking the value of each child node and add it to a single field.
     * The outcome should look like: NodeName: Value [new line]
     */
    private static String collectChildrenData(Dom.XmlNode node, String extraEquifaxData) {

        extraEquifaxData = node.getName() + '\n';
        List<Dom.XmlNode> children = node.getChildElements();

        if (children.isEmpty()) {
            extraEquifaxData += ': ' + node.getText() + '\n';
        } else {
            for (Dom.XmlNode child : children) {
                extraEquifaxData += child.getName();
                if (!child.getChildElements().isEmpty()) {
                    extraEquifaxData += collectChildrenData(child, extraEquifaxData);
                } else {
                    extraEquifaxData += ': ' + child.getText() + '\n';
                }
            }
        }
        return extraEquifaxData;
    }

    public static String buildRequestBody(EquifaxRequest equifaxRequest) {

        if (equifaxRequest.phone != null) {
          parsePhone(equifaxRequest.phone);
        }

        String provinceDescription = getProvinceDescription(equifaxRequest.province);

        String body = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sts="https://www.Equifax.ca/EFXWS/STSRequest">' +
                    '<soap:Header/>' +
                    '<soap:Body>' +
                        '<sts:Submit>' + //xmlns="https://uat.Equifax.ca/EFXWS/STSRequest">' +
                        '<sts:InputSegment>' +
                                    '<![CDATA[<?xml version="1.0" encoding="utf-8"?><CNCustTransmitToEfx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="' + PROD_SCHEMA_LOCATION + '"xmlns="http://www.equifax.ca/XMLSchemas/CustToEfx">' +
                                        '<CNCustomerInfo>' +
                                            '<CustomerCode>B234</CustomerCode>' +
                                            '<CustomerInfo>' +
                                                '<CustomerNumber>' + PROD_MEMBER_NUMBER + '</CustomerNumber>' +
                                                '<SecurityCode>' + PROD_SECURITY_CODE + '</SecurityCode>' +
                                            '</CustomerInfo>' +
                                        '</CNCustomerInfo>' +
                                        '<CNRequests>' +
                                            '<CNConsumerRequests>' +
                                                '<CNConsumerRequest>' +
                                                    '<Subjects>' +
                                                        '<Subject subjectType="SUBJ">' +
                                                            '<SubjectName>' +
                                                                '<LastName>' + equifaxRequest.lastName + '</LastName>' +
                                                                '<FirstName>' + equifaxRequest.firstName + '</FirstName>' +
                                                            '</SubjectName>';
                                                            if (equifaxRequest.socialInsuranceNumber != null) {  //TODO temp removed
                                                                body += '<SocialInsuranceNumber>' + equifaxRequest.socialInsuranceNumber + '</SocialInsuranceNumber>';
                                                            }
                                                            if (equifaxRequest.dateOfBirthYear != null && equifaxRequest.dateOfBirthMonth != null && equifaxRequest.dateOfBirthDay != null) {
                                                                body += '<DateOfBirth>' + equifaxRequest.dateOfBirthYear + '-' + equifaxRequest.dateOfBirthMonth + '-' + equifaxRequest.dateOfBirthDay + '</DateOfBirth>';
                                                                }
                                                            if (phoneAreaCodeAndNumber.size() > 0) {
                                                                body += '<ParsedTelephones>' +
                                                                '<ParsedTelephone telephoneType="BUS">' +
                                                                    '<AreaCode>' + phoneAreaCodeAndNumber[0] + '</AreaCode>' +
                                                                    '<Number>' + phoneAreaCodeAndNumber[1] + '</Number>' +
                                                                    '</ParsedTelephone>' +
                                                                '</ParsedTelephones>';
                                                            }
                                                       body += '</Subject>' +
                                                        '<Addresses>' +
                                                            '<Address addressType="CURR">' +
                                                                '<CivicNumber>' + addressNumberAndStreet[0] + '</CivicNumber>' +
                                                                '<StreetName>' + addressNumberAndStreet[1] + '</StreetName>' +
                                                                '<City>' + equifaxRequest.city + '</City>' +
                                                                '<Province code="' + equifaxRequest.province + '" description="' + provinceDescription + '"/>' +
                                                                '<PostalCode>' + equifaxRequest.postalCode + '</PostalCode>' +
                                                            '</Address>' +
                                                        '</Addresses>' +
                                                    '</Subjects>' +
                                                        '<ECOAInquiryType>I</ECOAInquiryType>' +
                                                        '<JointAccessIndicator>N</JointAccessIndicator>' +
                                                '</CNConsumerRequest>' +
                                            '</CNConsumerRequests>' +
                                            '<CNOutputParameters>' +
                                                '<Language>' + 'EN' + '</Language>' +
                                                '<OutputParameter outputParameterType="CONS">' +
                                                    '<GenericOutputCode>' + 'X' + '</GenericOutputCode>' +
                                                    '<CustomizationCode>' + 'VVVF0000' + '</CustomizationCode>' +
                                                '</OutputParameter>' +
                                            '</CNOutputParameters>' +
                                        '</CNRequests>' +
                                    '</CNCustTransmitToEfx>]]>' +
                                '</sts:InputSegment>' +
                                '<sts:EFXEnvironment>' + PROD_EFX_ENV + '</sts:EFXEnvironment>' +
                            '</sts:Submit>' +
                         '</soap:Body>' +
                    '</soap:Envelope>';

        return body;
    }

    public class EquifaxRequest {

        public String firstName { get; set; }
        public String lastName { get; set; }
        public String socialInsuranceNumber { get; set; }
        public String address { get; set; }
        public String city { get; set; }
        public String province { get; set; }
        public String postalCode { get; set; }
        public String phone { get; set; }
        public String dateOfBirthMonth { get; set; }
        public String dateOfBirthDay { get; set; }
        public String dateOfBirthYear { get; set; }
    }

    public class EquifaxResponse {

        public Integer creditScore { get; set; }
        public String equifaxData { get; set; }
        public Integer pgHighCredit { get; set; }
        public Boolean calloutFailed { get; set; }

        public EquifaxResponse() {
            this.creditScore = 0;
            this.calloutFailed = false;
        }
    }
}