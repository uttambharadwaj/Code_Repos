public class LiveAgentPostChatFormController {
    public String CaseId {get; set;}
    public String ContactId {get; set;}
    public LiveAgentPostChatFormController() {
        String attRec = ApexPages.currentPage().getParameters().get('attachedRecords');
        if (String.isNotEmpty(attRec)) {
            AttachedRecords att = (AttachedRecords) JSON.deserialize(attRec, AttachedRecords.class);
            CaseId = att.CaseId;
            if (String.isNotEmpty(CaseId)) {
                for (Case c : [SELECT ContactId FROM Case WHERE Id = :CaseId]) {
                    ContactId = c.ContactId;
                }
            }
        }
    }

    public void updateCase() {
        String startTime = ApexPages.currentPage().getParameters().get('startTime');
        if (String.isNotEmpty(startTime) && String.isNotEmpty(CaseId)) {
            for (Case c : [SELECT Id FROM Case WHERE Id = :CaseId]) {
                c.Service_Program_Survey_Sent__c = true;
                update c;
            }
        }
    }

    class AttachedRecords {
        String CaseId;
    }
}