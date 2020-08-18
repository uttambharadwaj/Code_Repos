public class CaseHelper {

    public static void setCardsCreatedDate(List<Case> records) {

        for (Case c : records) {
            // if this is an NA Fleet Case for card creation and has been completed
            String recordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(c.RecordTypeId).getName();
            if (recordTypeName != null && recordTypeName.equalsIgnoreCase('Fleet Implementation') && c.ClosedDate != null && c.Type != null && (c.Type.equalsIgnoreCase('Standard') || c.Type.equalsIgnoreCase('Data Entry'))) {
                List<Application_Request__c> creditApps = [SELECT Id, Cards_Created__c FROM Application_Request__c WHERE Id = :c.App_Request_This_Case__c];
                for (Application_Request__c creditApp : creditApps) {
                    creditApp.Cards_Created__c = c.ClosedDate;
                    upsert creditApp;
                }
            }
        }
    }

}