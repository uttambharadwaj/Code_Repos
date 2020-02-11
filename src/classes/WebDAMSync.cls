/*
    Purpose: Files used in WebDAM are kept up to date by various sources. This class pulls updated versions of files
    so that they can be used in Salesforce primarily by the sales team and their curated email templates.
 */
public class WebDAMSync implements Schedulable {

    public void execute(SchedulableContext sc) {

        try {
            WebDAMConnector webDAMConnector = new WebDAMConnector();
            WebDAM_Connector__c webDAMConnectorConfig = WebDAM_Connector__c.getInstance();

            for (WebDAMConnectorAuthResponse.items searchItem : WebDAMConnector.searchByString(webDAMConnectorConfig.WebDAM_Search__c)) {
                saveAsset(searchItem.id, searchItem.name, searchItem.version, webDAMConnectorConfig.Default_Folder_Id__c, searchItem.filetype);
            }

        } catch (Exception e) {
            System.debug(e);
        }
    }

    @future(callout=true)
    private static void saveAsset(String assetId, String name, String version, String folderid, String type) {

        try {

            Document doc = new Document();
            Integer randomNumber = Math.abs(Crypto.getRandomInteger());
            String devName = 'WebDAM_' + assetId;

            // Handle preexisting files
            List<Document> existingDocument = [SELECT Id, Name FROM Document WHERE DeveloperName LIKE :devName + '_%'];
            if (existingDocument.size() > 0) {
                if (existingDocument.size() != 1) insert UtilityClass.logInternalError('More than one file found for developer name: ' + devName, 'WebDAMSync.SaveAsset', '', 'WebDAMSync', false, '', assetId);
                if (existingDocument[0].Name.substringAfterLast('_v') == version) return; // Only update files that have increased version numbers
                doc.Id = existingDocument[0].Id;

            } else doc.DeveloperName = devName + '_' + String.valueOf(randomNumber); // Add random number for in the event that the file has existed before and been deleted;
            // ------

            WebDAMConnector webDAMConnector = new WebDAMConnector();
            doc.Body = WebDAMConnector.getDAMFile(assetId);
            doc.name = generateFileName(name, version);
            doc.folderid = folderid; // TODO dynamically get folder... probably based on folder name in WebDAM.
            doc.type = type;

            upsert doc;

        } catch (Exception e) {
            System.debug(e);
            insert UtilityClass.logInternalError(e, '', 'WebDAMSync', false, '', assetId);
        }
    }
    @TestVisible
    private static String generateFileName(String name, String version) {
        return name.substringBeforeLast('.') + '_v' + version;
    }
}