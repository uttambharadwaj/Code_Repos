/**
 * Created by jharrell on 1/28/20.
 */
/*
    Purpose: Files used in WebDAM are kept up to date by various sources. This class pulls updated versions of files
    so that they can be used in Salesforce primarily by the sales team and their curated email templates.
 */
public class WebDAMSync {


    public static void updateFiles() {

        WebDAMConnector webDAMConnector;
        List<Document> documents = new List<Document>();
        Map<String, Blob> assetIds = new Map<String, Blob>();
        try {
            webDAMConnector = new WebDAMConnector();
        } catch (Exception e) {
            System.debug(e);
        }

        if (webDAMConnector != null) {

            // TODO handle no results
            WebDAM_Connector__c webDAMConnectorConfig = WebDAM_Connector__c.getInstance();
            for (WebDAMConnectorAuthResponse.items searchItem : WebDAMConnector.searchByString(webDAMConnectorConfig.WebDAM_Search__c)) {

                saveAsset(searchItem.id, searchItem.name, searchItem.version, '00l70000001Ca9kAAC', searchItem.filetype);

            }

        }
    }

    @future(callout=true)
    public static void saveAsset(String assetId, String name, String version, String folderid, String type) {

        try {

            Document doc = new Document();
            Integer randomNumber = Math.abs(Crypto.getRandomInteger());
            String devName = 'WebDAM_' + assetId;

            // Handle preexisting files
            List<Document> existingDocument = [SELECT Id, Name FROM Document WHERE DeveloperName LIKE :devName + '_%'];
            if (existingDocument.size() > 0) {
                if (existingDocument.size() != 1) insert UtilityClass.logInternalError('More than one file found for developer name: ' + devName, 'WebDAMSync.SaveAsset', '', 'WebDAMSync', false, '', assetId);
                if (existingDocument[0].Name.substringAfterLast('v') == version) return; // Only update files that have increased version numbers
                doc.Id = existingDocument[0].Id;

            } else doc.DeveloperName = devName + '_' + String.valueOf(randomNumber); // Add random number for in the event that the file has existed before and been deleted;

            WebDAMConnector webDAMConnector = new WebDAMConnector();
            doc.Body = WebDAMConnector.getDAMFile(assetId);
            doc.name = name + ' v' + version;
            doc.folderid = folderid; // TODO dynamically get folder
            doc.type = type;

            upsert doc;

        } catch (Exception e) {
            System.debug(e);
            insert UtilityClass.logInternalError(e, '', 'WebDAMSync', false, '', assetId);
        }
    }
}