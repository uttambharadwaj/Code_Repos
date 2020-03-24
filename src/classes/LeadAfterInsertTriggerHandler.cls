/**
 * Created by mfarrell on 3/20/20.
 */

public with sharing class LeadAfterInsertTriggerHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {

        ULead.processParentLead(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.eloquaPass(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.createCampaignMember(tp.newList);
        ULead.decoupleChildLeadCheck(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULead.mergei2iParentDuplicates(tp.newList, (Map<Id, Lead>) tp.oldMap);
        ULeadShare.communityCheckSharing(tp.newList, (Map<Id, Lead>) tp.oldMap);
        LeadTriggerHandler.createRelatedTaskAndNote(tp.newList, (Map<Id, Lead>) tp.oldMap);
        LeadHelper.forsevaLeadAfterInsert(tp.newList);
        ULeadWeightedRoundRobin.leadWeightedRoundRobin(tp.newList, (Map<Id, Lead>) tp.oldMap);

    }

}