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
        }
    } else if (trigger.isAfter) {
        if (trigger.isInsert) {
            UContact.processCountContacts(records, trigger.oldMap);
            UContactShare.communityCheckSharing(records, trigger.oldmap);

        } else if (trigger.isUpdate) {
            UContact.processCountContacts(records, trigger.oldMap);
            UContact.mergei2iDuplicates(records, trigger.oldmap);
            UContactShare.communityCheckSharing(records, trigger.oldmap);
            
            //Route Contact Preferences to SweepBatch
            if(!system.isBatch()) {
                for( Id contId : Trigger.newMap.keySet() ) {
                    if(Trigger.oldMap.get( contId ).DoNotCall != Trigger.newMap.get( contId ).DoNotCall || 
                       Trigger.oldMap.get( contId ).HasOptedOutOfEmail != Trigger.newMap.get( contId ).HasOptedOutOfEmail || 
                       Trigger.oldMap.get( contId ).Mail_Opt_Out__c != Trigger.newMap.get( contId ).Mail_Opt_Out__c ){
                           SweepsBatchService.handleContactUpdate(Trigger.new, Trigger.oldMap);
                       }
                }
            }

        } else if (trigger.isDelete) {
            UContact.processDeleteCountContacts(records, trigger.oldMap);
            DeletedRecordsStageClass.processDelete(records);
        }
    }
}