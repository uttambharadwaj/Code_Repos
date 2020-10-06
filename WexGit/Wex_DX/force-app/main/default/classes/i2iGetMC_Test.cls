/*
 * Description: Test coverage for i2iGetMC 
 * Author: Lev
 * Date: October 2019
 */
@isTest
public class i2iGetMC_Test {

    @isTest
    public static void testingNoFilters() {
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', '', '', '', '', '', '', '');
        System.Test.stopTest();

        System.assertEquals('', filters);
    }

    @isTest
    public static void testingOneFilters() {
        String company = 'TEST WEX';
        
		System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', '', '', '', '', company, '', '');
        String expectedXml = '<Filter xsi:type="SimpleFilterPart"><Property>Company</Property>'+
            '<SimpleOperator>equals</SimpleOperator><Value>TEST WEX</Value></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingTwoFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, '', '', '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingThreeFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, '', '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>equals</SimpleOperator><Value>Test</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingFourFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>equals</SimpleOperator><Value>Test</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>equals</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingFiveFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        String company = 'Test WEX';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>equals</SimpleOperator><Value>Test</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>equals</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>equals</SimpleOperator><Value>Test WEX</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingSixFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        String company = 'Test WEX';
        String zipcode = '12345';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Test</Property><SimpleOperator>equals</SimpleOperator><Value>ProgramName</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>equals</SimpleOperator><Value>12345678901</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>equals</SimpleOperator><Value>Test WEX</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>PostalCode</Property><SimpleOperator>equals</SimpleOperator><Value>12345</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingAllFilters() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        String company = 'Test WEX';
        String zipcode = '12345';
        String email = 'tester@test.com';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, email);
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' + 
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>equals</SimpleOperator><Value>Test</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>equals</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>equals</SimpleOperator><Value>Test WEX</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>PostalCode</Property><SimpleOperator>equals</SimpleOperator><Value>12345</Value></RightOperand></RightOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>EmailAddress</Property><SimpleOperator>equals</SimpleOperator><Value>tester@test.com</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingOneWildCard() {
        String company = 'Test WEX*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', '', '', '', '', company, '', '');
		String expectedXml = '<Filter xsi:type="SimpleFilterPart"><Property>Company</Property>'+
            '<SimpleOperator>like</SimpleOperator><Value>Test WEX</Value></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }
    
    @isTest
    public static void testingMultipleWildCards() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test*';
        String phonepass = '12345678901';
        String company = 'Test WEX*';
        String zipcode = '12345';
        String email = 'tester@test.com';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, email);
		String expectedXml = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">' + 
            '<LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>equals</SimpleOperator><Value>TEST</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>like</SimpleOperator><Value>Test</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>equals</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>like</SimpleOperator><Value>Test WEX</Value></LeftOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>PostalCode</Property><SimpleOperator>equals</SimpleOperator><Value>12345</Value></RightOperand></RightOperand>' + 
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>EmailAddress</Property><SimpleOperator>equals</SimpleOperator><Value>tester@test.com</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }
    
    @isTest
    public static void testingTwoFilters_wildcard() {
        String couponCode = 'TEST*';
        String programSelected = 'TEST*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, '', programSelected, '', '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingThreeFilters_wildcard() {
        String couponCode = 'TEST*';
        String leadNumber = '1234';
        String programSelected = 'Test*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, '', '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>like</SimpleOperator><Value>Test</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingFourFilters_wildcard() {
        String couponCode = 'TEST*';
        String leadNumber = '1234';
        String programSelected = 'Test*';
        String phonepass = '12345678901*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, '', '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>like</SimpleOperator><Value>Test</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>like</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingFiveFilters_wildcard() {
        String couponCode = 'TEST*';
        String leadNumber = '1234';
        String programSelected = 'Test*';
        String phonepass = '12345678901*';
        String company = 'Test WEX*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, '', '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>like</SimpleOperator><Value>Test</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>like</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>like</SimpleOperator><Value>Test WEX</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingSixFilters_wildcard() {
        String couponCode = 'TEST*';
        String leadNumber = '1234';
        String programSelected = 'Test*';
        String phonepass = '12345678901*';
        String company = 'Test WEX*';
        String zipcode = '12345';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, '');
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Test</Property><SimpleOperator>like</SimpleOperator><Value>ProgramName</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>like</SimpleOperator><Value>12345678901</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>like</SimpleOperator><Value>Test WEX</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>PostalCode</Property><SimpleOperator>equals</SimpleOperator><Value>12345</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testingAllFilters_wildcard() {
        String couponCode = 'TEST*';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901*';
        String company = 'Test WEX';
        String zipcode = '12345*';
        String email = 'tester@test.com*';
        
        System.Test.startTest();
        String filters = i2iGetMC.compileFilterCriteria('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, email);
		String expectedXml = '<Filter xsi:type="ComplexFilterPart">' +
            '<LeftOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>CouponCode</Property><SimpleOperator>like</SimpleOperator><Value>TEST</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>LeadNumber</Property><SimpleOperator>equals</SimpleOperator><Value>1234</Value></RightOperand></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>ProgramName</Property><SimpleOperator>equals</SimpleOperator><Value>Test</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>Phone</Property><SimpleOperator>like</SimpleOperator><Value>12345678901</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart"><Property>Company</Property><SimpleOperator>equals</SimpleOperator><Value>Test WEX</Value></LeftOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>PostalCode</Property><SimpleOperator>like</SimpleOperator><Value>12345</Value></RightOperand></RightOperand>' +
            '<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart"><Property>EmailAddress</Property><SimpleOperator>like</SimpleOperator><Value>tester@test.com</Value></RightOperand></Filter>';
        System.assertEquals(expectedXml, filters);
        System.Test.stopTest();
    }

    @isTest
    public static void testAuthCallout() {
        //Set mock call
        Map<String, String> authHeaders = new Map<String, String>();
        authHeaders.put('Content-type', 'application/json');
        
        String body = '{"access_token": "c7EHVikEffNmRqu5UWdw2","token_type": "Bearer","expires_in": 1079,"scope": "push_read",'  +
    				'"soap_instance_url": "https://mcb9lg4yfkyxd3c4ctrlcfsdpln4.soap.marketingcloudapis.com/", "rest_instance_url": "https://mcb9lg4yfkyxd3c4ctrlcfsdpln4.rest.marketingcloudapis.com/"}';
        i2iGetMC_CalloutTest.TestMock authTokenMock = new i2iGetMC_CalloutTest.TestMock(200, body, authHeaders);
        Map<String, HttpCalloutMock> endpointMock = new Map<String, HttpCalloutMock>();
        endpointMock.put('callout:Marketing_Cloud_Authorization', authTokenMock);

        HttpCalloutMock multiCalloutMock = new i2iGetMC_CalloutTest.MultiRequestMock(endpointMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        System.Test.startTest();
        String authToken = i2iGetMC.authAccessToken();
        System.assertEquals('c7EHVikEffNmRqu5UWdw2', authToken);
        System.Test.stopTest();
    }
    
    @isTest
    public static void testServiceCallout() {
        //Set mock call
        Map<String, String> servicesHeaders = new Map<String, String>();
        servicesHeaders.put('SOAPAction', 'Retrieve');
        servicesHeaders.put('Content-type', 'text/xml');
        servicesHeaders.put('Accept', 'text/xml');
        
        String body = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + 
            'xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
    		'<soap:Header><wsa:Action>RetrieveResponse</wsa:Action><wsa:MessageID>urn:uuid:370f4030-22e6-4706-a5a2-a7190e906678</wsa:MessageID><wsa:RelatesTo>urn:uuid:531a2812-26cf-4fa6-ade9-8b71dd74a927</wsa:RelatesTo>' +
        	'<wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-e1086372-6ef8-43d4-a826-80aa60df4c3b">' +
            '<wsu:Created>2019-10-24T15:58:59Z</wsu:Created><wsu:Expires>2019-10-24T16:03:59Z</wsu:Expires></wsu:Timestamp></wsse:Security></soap:Header><soap:Body>' +
        	'<RetrieveResponseMsg xmlns="http://exacttarget.com/wsdl/partnerAPI"><OverallStatus>MoreDataAvailable</OverallStatus><RequestID>67dd72b4-399e-4d33-8134-5fcad03f3761</RequestID>' +
            '<Results xsi:type="DataExtensionObject"><PartnerKey xsi:nil="true" /><ObjectID xsi:nil="true" /><Type>DataExtensionObject</Type><Properties><Property><Name>EmailAddress</Name><Value>diane@shawneeha.org</Value></Property>' +
            '<Property><Name>FirstName</Name><Value /></Property><Property><Name>LastName</Name><Value /></Property><Property><Name>CouponCode</Name><Value /></Property><Property><Name>SendType</Name>' +
            '<Value>Email</Value></Property><Property><Name>ContactType</Name><Value>Unknown</Value></Property><Property><Name>LeadNumber</Name><Value>0</Value></Property>' +
            '<Property><Name>MobileNumber</Name><Value /></Property><Property><Name>EmailName</Name><Value>TE2NX_20190917_Telematics_T5</Value></Property><Property>'+
            '<Name>MessageName</Name><Value /></Property><Property><Name>SendDate</Name><Value>9/17/2019 7:58:40 AM</Value></Property><Property><Name>ProgramName</Name><Value /></Property>' +
            '<Property><Name>ProgramID</Name><Value /></Property><Property><Name>i2i_id__c</Name><Value /></Property><Property><Name>Company</Name><Value /></Property><Property><Name>City</Name><Value /></Property><Property>' +
            '<Name>State</Name><Value /></Property><Property><Name>Street</Name><Value /></Property><Property><Name>PostalCode</Name><Value /></Property><Property><Name>Phone</Name><Value /></Property>' +
            '<Property><Name>Country</Name><Value /></Property><Property><Name>i2i_Contact_ID__c</Name><Value /></Property></Properties></Results></RetrieveResponseMsg></soap:Body></soap:Envelope>';
        i2iGetMC_CalloutTest.TestMock services = new i2iGetMC_CalloutTest.TestMock(200, body, servicesHeaders);
        Map<String, HttpCalloutMock> endpointMock = new Map<String, HttpCalloutMock>();
        endpointMock.put('callout:Marketing_Cloud_Service', services);

        HttpCalloutMock multiCalloutMock = new i2iGetMC_CalloutTest.MultiRequestMock(endpointMock);
        System.Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        String soapBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> '  + 
            '<soapenv:Header> <fueloauth>c7EHVikEffNmRqu5UWdw2</fueloauth></soapenv:Header><soapenv:Body><RetrieveRequestMsg xmlns="http://exacttarget.com/wsdl/partnerAPI">' +
            '<RetrieveRequest><ObjectType>DataExtensionObject[SendLog_SearchTool]</ObjectType><Properties>EmailAddress</Properties>' +
            '<Properties>FirstName</Properties><Properties>LastName</Properties><Properties>CouponCode</Properties><Properties>SendType</Properties>' +
            '<Properties>ContactType</Properties><Properties>LeadNumber</Properties><Properties>MobileNumber</Properties><Properties>EmailName</Properties>'+
            '<Properties>MessageName</Properties><Properties>SendDate</Properties><Properties>ProgramName</Properties><Properties>ProgramID</Properties>'+
            '<Properties>i2i_id__c</Properties><Properties>Company</Properties><Properties>City</Properties><Properties>State</Properties><Properties>Street</Properties>'+
            '<Properties>PostalCode</Properties><Properties>Phone</Properties><Properties>Country</Properties><Properties>i2i_Contact_ID__c</Properties>'+
            '</RetrieveRequest></RetrieveRequestMsg></soapenv:Body></soapenv:Envelope>';

        
        System.Test.startTest();
        String response = i2iGetMC.makeHttpXMLPost('callout:Marketing_Cloud_Service', soapBody);
        System.assert(response != null);
        System.assertEquals(body, response);
        System.Test.stopTest();
    }
    
    @isTest
    public static void testParseXML() {
        String xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + 
            'xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
    		'<soap:Header><wsa:Action>RetrieveResponse</wsa:Action><wsa:MessageID>urn:uuid:370f4030-22e6-4706-a5a2-a7190e906678</wsa:MessageID><wsa:RelatesTo>urn:uuid:531a2812-26cf-4fa6-ade9-8b71dd74a927</wsa:RelatesTo>' +
        	'<wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-e1086372-6ef8-43d4-a826-80aa60df4c3b">' +
            '<wsu:Created>2019-10-24T15:58:59Z</wsu:Created><wsu:Expires>2019-10-24T16:03:59Z</wsu:Expires></wsu:Timestamp></wsse:Security></soap:Header><soap:Body>' +
        	'<RetrieveResponseMsg xmlns="http://exacttarget.com/wsdl/partnerAPI"><OverallStatus>MoreDataAvailable</OverallStatus><RequestID>67dd72b4-399e-4d33-8134-5fcad03f3761</RequestID>' +
            '<Results xsi:type="DataExtensionObject"><PartnerKey xsi:nil="true" /><ObjectID xsi:nil="true" /><Type>DataExtensionObject</Type><Properties><Property><Name>EmailAddress</Name><Value>diane@shawneeha.org</Value></Property>' +
            '<Property><Name>FirstName</Name><Value>Tester</Value></Property><Property><Name>LastName</Name><Value>Testing</Value></Property><Property><Name>CouponCode</Name><Value>1234</Value></Property><Property><Name>SendType</Name>' +
            '<Value>Email</Value></Property><Property><Name>ContactType</Name><Value>Unknown</Value></Property><Property><Name>LeadNumber</Name><Value>0</Value></Property>' +
            '<Property><Name>MobileNumber</Name><Value>0987654321</Value></Property><Property><Name>EmailName</Name><Value>TE2NX_20190917_Telematics_T5</Value></Property><Property>'+
            '<Name>MessageName</Name><Value>Test</Value></Property><Property><Name>SendDate</Name><Value>9/17/2019 7:58:40 AM</Value></Property><Property><Name>ProgramName</Name><Value>TestClass</Value></Property>' +
            '<Property><Name>ProgramID</Name><Value>123JJJ</Value></Property><Property><Name>i2i_id__c</Name><Value>123Test9702</Value></Property><Property><Name>Company</Name><Value>Wex</Value></Property><Property><Name>City</Name><Value>Indianapolis</Value></Property><Property>' +
            '<Name>State</Name><Value>IN</Value></Property><Property><Name>Street</Name><Value>1234 Testing Lane</Value></Property><Property><Name>PostalCode</Name><Value>46001</Value></Property><Property><Name>Phone</Name><Value>1231231234</Value></Property>' +
            '<Property><Name>Country</Name><Value>USA</Value></Property><Property><Name>i2i_Contact_ID__c</Name><Value>1234FHAL</Value></Property></Properties></Results></RetrieveResponseMsg></soap:Body></soap:Envelope>';
        
        System.Test.startTest();
        List<i2iGet.returnData> returnMap = i2iGetMC.xmlToMap(xml);
        System.assertEquals(1, returnMap.size());
        System.Test.stopTest();
    }
    
    @isTest
    public static void testSendTokenMC() {
        String couponCode = 'TEST';
        String leadNumber = '1234';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        String company = 'Test WEX';
        String zipcode = '12345';
        String email = 'tester@test.com';
        
        System.Test.startTest();
        List<i2iGet.returnData> data = i2iGetMC.sendTokenMC('', couponCode, leadNumber, programSelected, phonepass, company, zipcode, email);
        System.assertEquals(1, data.size());
        System.Test.stopTest();
    }
    
    @isTest
    public static void testSendTokenMCRetry() {
        String promocode = 'AWECS-192753929872';
        String programSelected = 'Test';
        String phonepass = '12345678901';
        String company = 'Test WEX';
        String zipcode = '12345';
        String email = 'tester@test.com';
        String accessToken;
        
        System.Test.startTest();
        List<i2iGet.returnData> data = i2iGetMC.sendTokenMCRetry('', promocode, programSelected, phonepass, company, zipcode, email);
        System.assertEquals(1, data.size());
        System.Test.stopTest();
    }

    @isTest
    public static void testi2iGet_inProduction() {
        String prodInstance = 'https://wexinc.my.salesforce.com';
        String currentInstance = System.URL.getSalesforceBaseUrl().toExternalForm();
        Boolean isProd = prodInstance == currentInstance;

        GlobalSettings__c gs = new GlobalSettings__c();
        gs.productionInstance__c = prodInstance;
        gs.Name = 'Settings';
        insert gs;

        // Test
        System.Test.startTest();
        Boolean returned = i2iGet.inProduction();
        System.Test.stopTest();

        // Assert that prod setting is returned
        System.assertEquals(isProd, returned);
    }
    
    @isTest
    public static void testi2iGet_returnData() {
        i2iGet.returnData r = new i2iGet.returnData();
        r.returnDescription = 'Success';
        r.isiId = 12.00;
        r.firstName = 'Tester';
        r.lastName = 'Testing';
        r.company = 'THE TEST COMPANY';
		r.address = '123 Testing Lane';
        r.city = 'Test City';
        r.state = 'TN';
        r.zip = '46530';
		r.email = 'test@test.com';
        r.title = 'Ms Tester';
		r.leadSource = 'Web';
        r.sicCode = '123';
        r.i2iId = '1234';
        r.CouponCode = '1234';
        r.MailDate = String.valueOf(Date.today());
        r.Offer = 'Testing offer';
		r.phone = '1231231234';
        r.country = 'usa';
    }

    @isTest
    public static void testi2iGet_executeCall() {
        // (string promoCode, string program, string phone, string businessName, string postalCode, string email)
        String promoCode = '1234';
        String program = 'Test';
        String phone = '12345678901';
        String businessName = 'THE TEST COMPANY';
        String postalCode = '12345';
        String email = 'tester@test.com';
        
        i2iGet.returnData r = new i2iGet.returnData();
        r.returnDescription = 'Success';
        r.isiId = 12.00;
        r.firstName = 'Tester';
        r.lastName = 'Testing';
        r.company = 'THE TEST COMPANY';
		r.address = '123 Testing Lane';
        r.city = 'Test City';
        r.state = 'TN';
        r.zip = '46530';
		r.email = 'test@test.com';
        r.title = 'Ms Tester';
		r.leadSource = 'Web';
        r.sicCode = '123';
        r.i2iId = '1234';
        r.CouponCode = '1234';
        r.MailDate = String.valueOf(Date.today());
        r.Offer = 'Testing offer';
		r.phone = '1231231234';
        r.country = 'usa';

        System.Test.setMock(HttpCalloutMock.class, new Test_i2iHttpCallOutMock());

        // Test
        System.Test.startTest();
        List<i2iGet.ReturnData> returnList = i2iGet.executeCall(promoCode, program, phone, businessName, postalCode, email);
        System.Test.stopTest();

        // Assert that a list of 4 ReturnData objects are returned from the mock callout
        System.assertEquals(0, returnList.size());
    }
}