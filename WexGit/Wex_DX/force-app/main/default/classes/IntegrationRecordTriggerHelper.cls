public class IntegrationRecordTriggerHelper {

    public static void updateContact(Map<Id, Id> intCtMap) {
        Map<Id, Contact> ctMap = new Map<Id, Contact>(
            [SELECT Id, Phone, MobilePhone, Phone2__c, Phone3__c, Phone4__c, Phone5__c,
             Email, Email_Address_2__c, Email_Address_3__c, Email_Address_4__c, Email_Address_5__c, Fax,
             (SELECT Id, Phone__c, Mobile_Phone__c, Email__c, Fax__c FROM Integration_Record__r WHERE Id IN : intCtMap.keySet())
             FROM Contact WHERE Id IN : intCtMap.values()]);

        for (Id ctId : ctMap.keySet()) {
            Contact ct = ctMap.get(ctId);

            for (IntegrationRecord__c ir : ct.Integration_Record__r)  {
                if (ir.Phone__c != null && ct.Phone != ir.Phone__c) {
                    if (ct.Phone4__c!=null) ct.Phone5__c = ct.Phone4__c;
                    if (ct.Phone3__c!=null) ct.Phone4__c = ct.Phone3__c;
                    if (ct.Phone2__c!=null) ct.Phone3__c = ct.Phone2__c;
                    if (ct.Phone!=null) ct.Phone2__c = ct.Phone;
                    ct.Phone = ir.Phone__c;
                }
                if (ir.Mobile_Phone__c != null && ct.MobilePhone != ir.Mobile_Phone__c) {
                    if (ct.Phone4__c!=null) ct.Phone5__c = ct.Phone4__c;
                    if (ct.Phone3__c!=null) ct.Phone4__c = ct.Phone3__c;
                    if (ct.Phone2__c!=null) ct.Phone3__c = ct.Phone2__c;
                    if (ct.MobilePhone!=null) ct.Phone2__c = ct.MobilePhone;
                    ct.MobilePhone = ir.Mobile_Phone__c;
                }
                if (ir.Email__c != null && ct.Email != ir.Email__c) {
                    if (ct.Email_Address_4__c!=null) ct.Email_Address_5__c = ct.Email_Address_4__c;
                    if (ct.Email_Address_3__c!=null) ct.Email_Address_4__c = ct.Email_Address_3__c;
                    if (ct.Email_Address_2__c!=null) ct.Email_Address_3__c = ct.Email_Address_2__c;
                    if (ct.Email!=null) ct.Email_Address_2__c = ct.Email;
                    ct.Email = ir.Email__c;
                }
                if(ir.Fax__c != null && ct.Fax != ir.Fax__c){
                    ct.Fax = ir.Fax__c;
                }
            }
        }

        if (!ctMap.isEmpty()) {
            update ctMap.values();
        }
    }

    public static void reRunInsertLogic(List<ID> recordIDs){
        List<IntegrationRecord__c> recordsToUpdate = new List<IntegrationRecord__c>();
        //List<Contact> contactsToUpdate = new List<Contact>();
        Map<ID, Contact> mapContactsToUpdate = new Map<ID, Contact>();
        Map<ID, ID> mapContactToAccountToRemove = new Map<ID, ID>();
        // For all the Contacts that are being removed from the IntegrationRecord's reference
        // we need to check if there are other IntegrationRecords pointing at them
        // if there are none, we set them a Status__c value of "Inactive"
        List<ID> contactsPotentiallyInactive = new List<ID>();
        List<Contact> contactsToUpdateInactive = new List<Contact>();
        List<IntegrationRecord__c> records = [SELECT ID, Contact_Row_Id__c, Contact__r.Contact_Row_Id__c, Contact__c,
                                                    Account__c, Acct_Row_Id__c, CreatedDate, First_Name__c, Middle_Name__c, Last_Name__c,
                                                    Suffix__c, Contact_Type__c, Email__c, Phone__c, Mobile_Phone__c, Fax__c,
                                                    SourceCreatedDate__c, SourceLastModifiedDate__c, SourceModifiedBy__c
                                                FROM IntegrationRecord__c
                                                WHERE ID in :recordIDs];
        System.debug(LoggingLevel.INFO, '#debug: These are the records that triggered the future method: ' + records);
        for(IntegrationRecord__c rec : records){
            // If the integration record where the name change occurs' contact_row_id is the same as the contact_row_id of the contact it originates from
            // then then null out the old contacts contact_row_id
            if(rec.Contact_Row_Id__c == rec.Contact__r.Contact_Row_Id__c){
                Contact auxContact = new Contact(ID = rec.Contact__c);
                auxContact.Contact_Row_Id__c = null;
                mapContactsToUpdate.put(auxContact.ID, auxContact);
                mapContactToAccountToRemove.put(rec.Contact__c, rec.Account__c);
            }
            contactsPotentiallyInactive.add(rec.Contact__c);
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
                    recordsToUpdate.add(rec);
                }
            }
        }
        // Prepare to delete the old AccountContactRelations
        List<AccountContactRelation> accountContactRelationList = [SELECT ID, AccountId, ContactId, IsDirect
                                                                    FROM AccountContactRelation
                                                                    WHERE AccountID in :mapContactToAccountToRemove.values()
                                                                    AND ContactID in :mapContactToAccountToRemove.keySet()];
        List<AccountContactRelation> ACRToDelete = new List<AccountContactRelation>();
        for(AccountContactRelation auxACR : accountContactRelationList){
            if(mapContactToAccountToRemove.get(auxACR.ContactID) != null 
                && mapContactToAccountToRemove.get(auxACR.ContactID) == auxACR.AccountID
                && !auxACR.isDirect){
                ACRToDelete.add(auxACR);
            }
        }
        update recordsToUpdate;
        // Check the previous contacts for inactivation in case they are not referenced by other IntegrationRecords
        List<IntegrationRecord__c> relatedIntegrationRecords = [SELECT ID, Contact__c
                                                                FROM IntegrationRecord__c
                                                                WHERE Contact__c in :contactsPotentiallyInactive];
        for(ID auxContactID : contactsPotentiallyInactive){
            Boolean referencedByRecord = false;
            for(IntegrationRecord__c auxIntegrationRecord : relatedIntegrationRecords){
                if(auxContactID == auxIntegrationRecord.Contact__c){
                    referencedByRecord = true;
                    break;
                }
            }
            if(!referencedByRecord){
                if(mapContactsToUpdate.get(auxContactID) != null){
                    mapContactsToUpdate.get(auxContactID).Status__c = 'Inactive';
                }else{
                    Contact auxContact = new Contact(ID = auxContactID, Status__c = 'Inactive');
                    mapContactsToUpdate.put(auxContactID, auxContact);
                }
            }
        }
        delete ACRToDelete;
        //update contactsToUpdate;
        update mapContactsToUpdate.values();
    }

}