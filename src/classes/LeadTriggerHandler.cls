public class LeadTriggerHandler {
    public static void createRelatedTaskAndNote (List<Lead> records, Map<Id, Lead> oldMap) {
        Boolean isInsert = oldMap==null;
        Map<Id, Lead> leadsMap = new Map<Id, Lead>();
        Id leadRT = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WES_Lead').getRecordTypeId();
        for (Lead rec : records) {
            if (rec.RecordTypeId == leadRT
                    && rec.Call_Outcome__c!=null
                    && (isInsert
                        || rec.Call_Outcome__c != oldMap.get(rec.Id).Call_Outcome__c)) {
                leadsMap.put(rec.Id, rec);
            }
        }

        List<Task> tskList = new List<Task> ();
        Map<Id, ContentNote> leadNoteMap = new Map<Id, ContentNote>();
        for (Id leadId : leadsMap.keySet()) {
            Lead rec = leadsMap.get(leadId);
            Task tsk = new Task();
            tsk.OwnerId = rec.OwnerId;
            tsk.Subject = 'Called - ' + rec.Call_Outcome__c;
            tsk.ActivityDate = Date.today();
            tsk.Status = 'Closed';
            tsk.Description = rec.Call_Outcome_Comments__c;
            tsk.WhoId = rec.Id;
            tskList.add(tsk);

            ContentNote cn = new ContentNote();
            cn.Title = 'Called - ' + rec.Call_Outcome__c;
            cn.Content = Blob.valueOf(rec.Call_Outcome_Comments__c);
            leadNoteMap.put(rec.Id, cn);
        }

        if (!tskList.isEmpty()) {
            insert tskList;
        }

        if (!leadNoteMap.isEmpty()) {
            insert leadNoteMap.values();

            List<ContentDocumentLink> cdLinkList = new List<ContentDocumentLink>();
            for (Id leadId : leadNoteMap.keySet()) {
                ContentDocumentLink  cdLink = new ContentDocumentLink();
                cdLink.ContentDocumentId = leadNoteMap.get(leadId).Id;
                cdLink.LinkedEntityId = leadId;
                cdLink.ShareType = 'I';
                cdLinkList.add(cdLink);
            }

            insert cdLinkList;
        }
    }
}