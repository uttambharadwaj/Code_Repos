public class CaseHelper {

    /**
     * The best way to capture the time cards were created for NA Fleet is to look at the closed date on the Fleet Implementation Case on the Opportunity
     * related to the credit application.
     */
    public static void setCardsCreatedDate(List<Case> records) {

        Map<Id, Case> caseToAppReqMap = new Map<Id, Case>();
        List<Application_Request__c> creditApps = new List<Application_Request__c>();
        List<Application_Request__c> creditAppsToUpdate = new List<Application_Request__c>();

        for (Case c : records) {
            // we only care about Fleet Implementation Cases
            if (c.RecordTypeId == UtilityClass.getRecTypeByDevName('Case', 'Fleet_Implementation')) {
                if (c.App_Request_This_Case__c != null) {
                    caseToAppReqMap.put(c.App_Request_This_Case__c, c);
                }
            }
        }

        if (!caseToAppReqMap.isEmpty()) {
            // find the credit apps that are related to these Cases and have no yet had cards created date updated
            creditApps = [SELECT Id, Cards_Created__c FROM Application_Request__c WHERE Id = :caseToAppReqMap.keySet() AND Cards_Created__c = NULL];
        }

        if (!creditApps.isEmpty()) {
            for (Application_Request__c creditApp : creditApps) {
                Case c = caseToAppReqMap.get(creditApp.Id);
                // the type Standard or Data Entry signify that this Fleet Implementation Case is for card creation
                if (c.ClosedDate != null && c.Type != null && (c.Type.equalsIgnoreCase('Standard') || c.Type.equalsIgnoreCase('Data Entry'))) {
                    creditApp.Cards_Created__c = c.ClosedDate;
                    creditAppsToUpdate.add(creditApp);
                }
            }
            upsert creditAppsToUpdate;
        }
    }
}