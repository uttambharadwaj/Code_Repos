public class IntegrationRecordTriggerHandler {

    public static void createContact(List<IntegrationRecord__c> records) {
        System.debug(LoggingLevel.INFO, '#debug: createContact with records: ' + records);
        //List<IntegrationRecord__c> recordsAux = records;
        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;
        Set<String> contactRowIds = new Set<String>();
        Set<String> acctRowIds = new Set<String>();
        for (IntegrationRecord__c rec : records) {
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                contactRowIds.add(rec.Contact_Row_Id__c);
            }
            if (rec.Account__c==null && rec.Acct_Row_Id__c!=null) {
                acctRowIds.add(rec.Acct_Row_Id__c);
            }
        }
        System.debug(LoggingLevel.INFO, '#debug: contactRowIds: ' + contactRowIds);
        Map<String, Id> existingContactsMap = new Map<String, Id>();
        for (Contact ct : [SELECT Id, Contact_Row_Id__c FROM Contact WHERE RecordTypeId = :rectypeid AND Contact_Row_Id__c IN : contactRowIds]) {
            existingContactsMap.put(ct.Contact_Row_Id__c.toUpperCase(), ct.Id);
        }
        System.debug(LoggingLevel.INFO, '#debug: existingContactsMap: ' + existingContactsMap);
        Map<String, Id> acctsMap = new Map<String, Id>();
        for (Account acct : [SELECT Id, Acct_Row_Id__c FROM Account WHERE Acct_Row_Id__c IN : acctRowIds]) {
            acctsMap.put(acct.Acct_Row_Id__c.toUpperCase(), acct.Id);
        }

        for (IntegrationRecord__c rec : records) {
            System.debug(LoggingLevel.INFO, '#debug: rec.CreatedDate: ' + rec.CreatedDate);
            if(rec.CreatedDate == null || rec.CreatedDate == System.today()){
                if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                    String cRow = rec.Contact_Row_Id__c.toUpperCase();
                    System.debug(LoggingLevel.INFO, '#debug: cRow: ' + cRow);
                    System.debug(LoggingLevel.INFO, '#debug: existingContactsMap: ' + existingContactsMap);
                    if (existingContactsMap.containsKey(cRow)) {
                        System.debug(LoggingLevel.INFO, '#debug: Assignation');
                        rec.Contact__c = existingContactsMap.get(cRow);
                    }
                }
                if (rec.Account__c==null && rec.Acct_Row_Id__c!=null) {
                    String aRow = rec.Acct_Row_Id__c.toUpperCase();
                    if (acctsMap.containsKey(aRow)) {
                        rec.Account__c = acctsMap.get(aRow);
                    }
                }
            }
        }
        
        Map<String, Contact> newContactsMap = new Map<String, Contact>();
        for (IntegrationRecord__c rec : records) {
            System.debug(LoggingLevel.INFO, '#debug: rec.Contact__c: ' + rec.Contact__c);
            System.debug(LoggingLevel.INFO, '#debug: rec.Contact_Row_Id__c: ' + rec.Contact_Row_Id__c);
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                Contact ct = new Contact();
                ct.FirstName = rec.First_Name__c;
                ct.MiddleName = rec.Middle_Name__c;
                ct.LastName = rec.Last_Name__c;
                ct.Suffix__c = rec.Suffix__c;
                ct.AccountId = rec.Account__c;
                ct.RecordTypeId = rectypeid;
                ct.Contact_Type__c = rec.Contact_Type__c;
                ct.Email = rec.Email__c;
                ct.Phone = rec.Phone__c;
                ct.MobilePhone = rec.Mobile_Phone__c;
                ct.Fax = rec.Fax__c;
                ct.SourceCreatedDate__c = rec.SourceCreatedDate__c;
                ct.SourceLastModifiedDate__c = rec.SourceLastModifiedDate__c;
                ct.SourceModifiedBy__c = rec.SourceModifiedBy__c;
                ct.Contact_Row_Id__c = rec.Contact_Row_Id__c;
                ct.Acct_Row_Id__c = rec.Acct_Row_Id__c;
                // ct.WEX_Contact_ID__c = rec.Acct_Contact_Role_Row_Id__c;
                newContactsMap.put(rec.Contact_Row_Id__c.toUpperCase(),ct);
            }
        }
        System.debug(LoggingLevel.INFO, '#debug: newContactsMap.values(): ' + newContactsMap.values());
        insert newContactsMap.values();

        for (IntegrationRecord__c rec : records) {
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                String cRow = rec.Contact_Row_Id__c.toUpperCase();
                if (newContactsMap.containsKey(cRow)) {
                    rec.Contact__c = newContactsMap.get(cRow).Id;
                }
            }
        }

    }

    public static void updateContact(List<IntegrationRecord__c> records, Map<Id, IntegrationRecord__c> oldMap) {
        List<ID> recordIDs = new List<ID>();
        for(IntegrationRecord__c rec : records){
            if (rec.Contact__c!= null) {
                recordIDs.add(rec.Id);
            }
        }
        // If the Integration Record First Name or Last Name is updated to no longer match the Contact 
        // it is associated to we need to remove the integration record from the associated Contact and 
        // create a net new Contact to associate the integration record to (re run through integration trigger logic to insert Contact)
        // This should not happen in subsequent future calls or batch calls
        if(!System.isFuture() && !System.isBatch()){
            List<IntegrationRecord__c> reQueriedRecords = [SELECT ID, Contact__r.LastName, Contact__r.FirstName, Contact__r.Contact_Row_Id__c, 
                                                                Last_Name__c, First_Name__c, Contact_Row_Id__c, Acct_Row_Id__c,
                                                                Middle_Name__c, Suffix__c, Account__c, Contact_Type__c,
                                                                Email__c, Phone__c, Mobile_Phone__c, Fax__c, SourceCreatedDate__c,
                                                                SourceLastModifiedDate__c, SourceModifiedBy__c
                                                        FROM IntegrationRecord__c
                                                        WHERE ID in :recordIDs];

            List<ID> integrationRecordsToRunInsertLogic = new List<ID>();
            Map<Id, Id> intCtMap = new Map<Id, Id>();
            for (IntegrationRecord__c rec : reQueriedRecords) {
                // Only check if Last Name or First Name changed
                if(oldMap != null && (rec.Last_Name__c != oldMap.get(rec.ID).Last_Name__c || rec.First_Name__c != oldMap.get(rec.ID).First_Name__c)){
                    if(rec.Contact__r.LastName != rec.Last_Name__c || rec.Contact__r.FirstName != rec.First_Name__c){
                        integrationRecordsToRunInsertLogic.add(rec.ID);
                    }
                }else{
                    if (rec.Contact__c!= null) {
                        intCtMap.put(rec.Id, rec.Contact__c);
                    }
                }
            }
            if (!intCtMap.isEmpty()) {
                IntegrationRecordTriggerHelper.updateContact(intCtMap);
            }
            if(!integrationRecordsToRunInsertLogic.isEmpty()){
                IntegrationRecordTriggerHelper.reRunInsertLogic(integrationRecordsToRunInsertLogic);
            }
        }
    }

    /*@future
    public static void nullAndRunCreateContactLogic(String jsonPayload){
        List<IntegrationRecord__c> recordsToUpdate = new List<IntegrationRecord__c>();
        List<Contact> contactsToUpdate = new List<Contact>();

        List<IntegrationRecord__c> records = (List<IntegrationRecord__c>) JSON.deserialize(jsonPayload, List<IntegrationRecord__c>.class);
        System.debug(LoggingLevel.INFO, '#debug: These are the records that triggered the future method: ' + records);
        for(IntegrationRecord__c rec : records){
            // If the integration record where the name change occurs' contact_row_id is the same as the contact_row_id of the contact it originates from
            // then then null out the old contacts contact_row_id
            if(rec.Contact_Row_Id__c == rec.Contact__r.Contact_Row_Id__c){
                Contact auxContact = new Contact(ID = rec.Contact__c);
                auxContact.Contact_Row_Id__c = null;
                contactsToUpdate.add(auxContact);
            }
            rec.Contact__c = null;
        }
        
        Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Service_Operations' LIMIT 1].Id;
        Set<String> contactRowIds = new Set<String>();
        Set<String> acctRowIds = new Set<String>();
        for (IntegrationRecord__c rec : records) {
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                contactRowIds.add(rec.Contact_Row_Id__c);
            }
            if (rec.Account__c==null && rec.Acct_Row_Id__c!=null) {
                acctRowIds.add(rec.Acct_Row_Id__c);
            }
        }
        
        Map<String, Id> existingContactsMap = new Map<String, Id>();
        for (Contact ct : [SELECT Id, Contact_Row_Id__c FROM Contact WHERE RecordTypeId = :rectypeid AND Contact_Row_Id__c IN : contactRowIds]) {
            existingContactsMap.put(ct.Contact_Row_Id__c.toUpperCase(), ct.Id);
        }
        
        Map<String, Id> acctsMap = new Map<String, Id>();
        for (Account acct : [SELECT Id, Acct_Row_Id__c FROM Account WHERE Acct_Row_Id__c IN : acctRowIds]) {
            acctsMap.put(acct.Acct_Row_Id__c.toUpperCase(), acct.Id);
        }

        for (IntegrationRecord__c rec : records) {
            if(rec.CreatedDate == null || rec.CreatedDate == System.today()){
                if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                    String cRow = rec.Contact_Row_Id__c.toUpperCase();
                    if (existingContactsMap.containsKey(cRow)) {
                        rec.Contact__c = existingContactsMap.get(cRow);
                        recordsToUpdate.add(rec);
                    }
                }
                if (rec.Account__c==null && rec.Acct_Row_Id__c!=null) {
                    String aRow = rec.Acct_Row_Id__c.toUpperCase();
                    if (acctsMap.containsKey(aRow)) {
                        rec.Account__c = acctsMap.get(aRow);
                        recordsToUpdate.add(rec);
                    }
                }
            }
        }
        
        Map<String, Contact> newContactsMap = new Map<String, Contact>();
        for (IntegrationRecord__c rec : records) {
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                Contact ct = new Contact();
                ct.FirstName = rec.First_Name__c;
                ct.MiddleName = rec.Middle_Name__c;
                ct.LastName = rec.Last_Name__c;
                ct.Suffix__c = rec.Suffix__c;
                ct.AccountId = rec.Account__c;
                ct.RecordTypeId = rectypeid;
                ct.Contact_Type__c = rec.Contact_Type__c;
                ct.Email = rec.Email__c;
                ct.Phone = rec.Phone__c;
                ct.MobilePhone = rec.Mobile_Phone__c;
                ct.Fax = rec.Fax__c;
                ct.SourceCreatedDate__c = rec.SourceCreatedDate__c;
                ct.SourceLastModifiedDate__c = rec.SourceLastModifiedDate__c;
                ct.SourceModifiedBy__c = rec.SourceModifiedBy__c;
                ct.Contact_Row_Id__c = rec.Contact_Row_Id__c;
                ct.Acct_Row_Id__c = rec.Acct_Row_Id__c;
                // ct.WEX_Contact_ID__c = rec.Acct_Contact_Role_Row_Id__c;
                newContactsMap.put(rec.Contact_Row_Id__c.toUpperCase(),ct);
            }
        }
        
        insert newContactsMap.values();

        for (IntegrationRecord__c rec : records) {
            if (rec.Contact__c==null && rec.Contact_Row_Id__c!=null) {
                String cRow = rec.Contact_Row_Id__c.toUpperCase();
                if (newContactsMap.containsKey(cRow)) {
                    rec.Contact__c = newContactsMap.get(cRow).Id;
                    //recordsToUpdate.add(rec);
                    recordsToUpdate.add(rec);
                }
            }
        }
        update recordsToUpdate;
        update contactsToUpdate;
    }*/
}