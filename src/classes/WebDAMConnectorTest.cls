@isTest
public with sharing class WebDAMConnectorTest {

    public static void test_webDAMAuth() {


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator('WebDAMAuthLogin')); //set mock

        WebDAMConnector webDAMConnector = new WebDAMConnector();

        Test.stopTest();

        System.assertEquals(true, webDAMConnector != null);

    }

    public static void test_webDAMSearch() {


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'WebDAMSearch', 'WebDAMAuthLogin'}));

        WebDAMConnector webDAMConnector = new WebDAMConnector();

        List<WebDAMConnectorAuthResponse.items> searchResults = webDAMConnector.searchByString('infopack');
        Test.stopTest();

        System.assertEquals(1, searchResults.size());

    }

    public static void test_webDAMDownload() {


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'WebDAMAuthLogin','WebDAMDownload'}));

        WebDAMConnector webDAMConnector = new WebDAMConnector();

        Blob assetBlob = webDAMConnector.getDAMFile('100240231');
        Test.stopTest();

        System.assertEquals(true, assetBlob != null);

    }
}