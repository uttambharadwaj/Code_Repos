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

    /**
        * Purpose: Associate primary contacts to Collections and Credit cases automatically on creation.
        * Input: (List<Case>) List of newly created cases
        * Output: void
    */
    public static void associatePrimaryContact(List<Case> records) {

        // A is highest priority
        final Map<String, String> CONTACT_TYPE_PRIORITIES = new Map<String, String>{

                // New mapping using AccountContactRelation
                'BILLING CONTACT' => 'A',
                'PRIMARY CONTACT' => 'B',
                'FLEET CONTACT' => 'C',
                'MAILING CONTACT' => 'D',
                'SHIPPING CONTACT' => 'E',

                // TODO Old mapping using contact type field. This will go away when data has been added to AccountContactRelation for OTR ====>
                'COLLECTIONS' => 'F',
                'BILLING' => 'G',
                'PRIMARY' => 'H',
                'SHIPPING' => 'I',
                'ACCOUNTS PAYABLE' => 'J',
                'CONTACT' => 'K',
                 // <===========================

                'NONE' => 'Z'
        };

        final Set<Id> ENABLED_RECORD_TYPES = UtilityClass.getRecTypeByDevName('Case', new List<String>{
                'Service_Operations',
                'Credit'
        });

        Map<Id, Map<String, Id>> accountToContacts = new Map<Id, Map<String, Id>>();
        Set<Id> accountIds = new Set<Id>();

        // Get all account ids
        for (Case record : records) {
            if (record.AccountId != null) accountIds.add(record.AccountId);
        }

        // Get all contacts via AccountContactRelationship
        for (AccountContactRelation accountContactRelation : [SELECT Id,AccountId,ContactId,Roles FROM AccountContactRelation WHERE AccountId IN :accountIds]) {

            Set<String> contactTypes = new Set<String>();
            String contactTypeString = accountContactRelation.Roles != null ? accountContactRelation.Roles.toUpperCase() : 'NONE';
            contactTypes.addAll(contactTypeString.split(';'));

            for (String contactType : contactTypes) {

                if (CONTACT_TYPE_PRIORITIES.get(contactType) == null) contactType = 'NONE';
                contactType = CONTACT_TYPE_PRIORITIES.get(contactType) + contactType;

                if (accountToContacts.get(accountContactRelation.AccountId) == null) accountToContacts.put(accountContactRelation.AccountId, new Map<String, Id>());
                accountToContacts.get(accountContactRelation.AccountId).put(contactType, accountContactRelation.ContactId);
            }
        }

        // TODO This will go away when data updates for AccountContactRelationship/OTR are finished ======>
        for (Contact contact : [ SELECT Id,AccountId,Contact_Type__c FROM Contact WHERE AccountId IN :accountIds ]) { // get primary via Contact_Type__c

            String contactType = contact.Contact_Type__c != null && CONTACT_TYPE_PRIORITIES.get(contact.Contact_Type__c.toUpperCase()) != null ? contact.Contact_Type__c.toUpperCase() : 'NONE';
            contactType = CONTACT_TYPE_PRIORITIES.get(contactType) + contactType;

            if (accountToContacts.get(contact.AccountId) == null) accountToContacts.put(contact.AccountId, new Map<String,Id>());
            accountToContacts.get(contact.AccountId).put(contactType, contact.Id);

        }
        // <==================================

        // Associate contact to Case
        for (Case caseRecord : records) {

            Boolean isEnabledCase = (caseRecord.RecordTypeId != null && ENABLED_RECORD_TYPES.contains(caseRecord.RecordTypeId) && UserInfo.getName() == 'Credit Monitoring');
            if (isEnabledCase) {

                if (caseRecord.AccountId != null && accountToContacts.get(caseRecord.AccountId) != null) {
                    Map<String, Id> relatedContacts = accountToContacts.get(caseRecord.AccountId);

                    // Primary needs to be selected using priority(If a PRIMARY contact, use it. If not use the SHIPPING... etc. See contactTypePriorities)
                    List<String> priortizedContacts = new List<String>(relatedContacts.keySet());
                    priortizedContacts.sort();

                    caseRecord.ContactId = relatedContacts.get(priortizedContacts[0]);
                }
            }
        }
    }

}