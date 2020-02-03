@isTest
public with sharing class WebDAMSyncTest {

    public final static String FILE_NAME = 'Test_Document.pdf';
    public final static String FILE_VERSION = '5';
    public final static String FINAL_TITLE = 'Test_Document_v' + FILE_VERSION;

    public static void test_generateFileName() {

        Test.startTest();
        String fileName = webDAMSync.generateFileName(FILE_NAME, FILE_VERSION);
        Test.stopTest();

        System.assertEquals(FINAL_TITLE, fileName);
    }

    public static void test_savingAsset() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerator(new Set<String>{'WebDAMAuthLogin', 'WebDAMSearch', 'WebDAMDownload'}));

        WebDAMSync webDAMSync = new WebDAMSync();
        webDAMSync.execute(null);

        Test.stopTest();

        List<Document> docs = [ SELECT Id FROM Document WHERE Name = 'WE_Roadside_InfoPack_v1'];
        System.assertEquals(1, docs.size());

    }
}