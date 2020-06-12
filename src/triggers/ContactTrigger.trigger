/* ************************************************************
* Created By : Sean Fielding (GearsCRM)
* Created Date: 8/9/2013
* Description : Trigger ContactTrigger
*
* Modified By :
* Modified Date :
* Description :
*
* ************************************************************/

trigger ContactTrigger on Contact (before insert, before update, after insert, after update, after delete) {
    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if (bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Contact_Automation__c) {
        return;
    }

    List<Contact> records = trigger.isDelete ? trigger.old : trigger.new;

    if (trigger.isBefore) {
        if (trigger.isInsert) {
            UContact.updateCountryCode(records, trigger.oldMap);
            UContact.executeBREeze(records, trigger.oldMap);
        } else if (trigger.isUpdate) {
            UContact.updateCountryCode(records, trigger.oldMap);
            UContact.executeBREeze(records, trigger.oldMap);

            // TODO make this not so damn ugly
            //Route Contact Preferences to SweepBatch
            if(!system.isBatch()) {
                for (Id contId : Trigger.newMap.keySet()) {
                    Contact contact = Trigger.newMap.get(contId);
                    // Phone Opt
                    if (Trigger.oldMap.get(contId).DoNotCall != Trigger.newMap.get(contId).DoNotCall ||
                            Trigger.oldMap.get(contId).Outbound_Call_Opt_In__c != Trigger.newMap.get(contId).Outbound_Call_Opt_In__c ||
                            Trigger.oldMap.get(contId).Direct_Mail_Opt_In__c != Trigger.newMap.get(contId).Direct_Mail_Opt_In__c) {


                        if (contact.Opt_Status_Updated__c != null)
                            contact.Opt_Status_Updated__c += ';phone';
                        else
                                contact.Opt_Status_Updated__c = 'phone';
                    }

                    // Mail Opt
                    if (Trigger.oldMap.get(contId).Mail_Opt_Out__c != Trigger.newMap.get(contId).Mail_Opt_Out__c) {
                        if (contact.Opt_Status_Updated__c != null)
                            contact.Opt_Status_Updated__c += ';mail';
                        else
                                contact.Opt_Status_Updated__c = 'mail';
                    }

                    // Email Opt
                    if (Trigger.oldMap.get(contId).Email_Opt_In_Contact__c != Trigger.newMap.get(contId).Email_Opt_In_Contact__c ||
                            Trigger.oldMap.get(contId).HasOptedOutOfEmail != Trigger.newMap.get(contId).HasOptedOutOfEmail ||
                            Trigger.oldMap.get(contId).et4ae5__HasOptedOutOfMobile__c != Trigger.newMap.get(contId).et4ae5__HasOptedOutOfMobile__c ||
                            Trigger.oldMap.get(contId).HasOptedInOfMobile__c != Trigger.newMap.get(contId).HasOptedInOfMobile__c) {
                        //SweepsBatchService.handleContactUpdate(Trigger.new, Trigger.oldMap);
                        if (contact.Opt_Status_Updated__c != null && contact.Opt_Status_Updated__c != '')
                            contact.Opt_Status_Updated__c += ';Email';
                        else
                                contact.Opt_Status_Updated__c = 'Email';
                    }
                }
            }
        }
    } else if (trigger.isAfter) {
        if (trigger.isInsert) {
            UContact.processCountContacts(records, trigger.oldMap);
            UContactShare.communityCheckSharing(records, trigger.oldmap);

        } else if (trigger.isUpdate) {
            UContact.processCountContacts(records, trigger.oldMap);
            UContact.mergei2iDuplicates(records, trigger.oldmap);
            UContactShare.communityCheckSharing(records, trigger.oldmap);
            


        } else if (trigger.isDelete) {
            UContact.processDeleteCountContacts(records, trigger.oldMap);
            DeletedRecordsStageClass.processDelete(records);
        }
    }
}