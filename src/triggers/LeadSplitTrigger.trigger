trigger LeadSplitTrigger on Lead (before insert, before update, after update) {
//    moved to LeadHelper 20/Mar/2020
//
//    ConvertLeadSettings__c convertLeadSettings = ConvertLeadSettings__c.getOrgDefaults();
//
//    if(convertLeadSettings.Enable_Lead_Development_Split__c == false && Test.isRunningTest() == false) {
//        return;
//    }
//
//    List<Lead_Development_Splits__c> leadDevelopmentSplitSettings = Lead_Development_Splits__c.getall().values();
//
//    Set<String> leadDevelopmentRoles = new Set<String>();
//    for(Lead_Development_Splits__c setting : leadDevelopmentSplitSettings) {
//		leadDevelopmentRoles.add(setting.Role_ID__c);
//	}
//
//    if(Trigger.isAfter && Trigger.isUpdate) {
//
//        System.debug('### LeadSplitTrigger: Entering after update');
//
//        for(Lead lead : Trigger.new) {
//
//            if(lead.IsConverted && lead.Previous_Owner__c != null && leadDevelopmentRoles != null && leadDevelopmentRoles.contains(lead.Previous_Owner_Role__c)) {
//
//                System.debug('### LeadSplitTrigger: Role matches - adding split to Opportunity');
//
//                List<OpportunitySplitType> otherSplitTypes = [SELECT Id, MasterLabel FROM OpportunitySplitType];
//
//                for(Lead_Development_Splits__c leadDevelopmentSplitSetting : leadDevelopmentSplitSettings) {
//
//                    if(leadDevelopmentSplitSetting.Role_Id__c == lead.Previous_Owner_Role__c) {
//
//                        OpportunitySplit opportunitySplit = new OpportunitySplit();
//
//                        opportunitySplit.OpportunityId = lead.ConvertedOpportunityId;
//
//                        opportunitySplit.SplitOwnerId = lead.Previous_Owner__c;
//
//                        opportunitySplit.Commission_Type__c = leadDevelopmentSplitSetting.Commission_Type__c;
//
//                        for(OpportunitySplitType otherSplitType : otherSplitTypes) {
//
//                            if((leadDevelopmentSplitSetting.Opportunity_Split_Type__c).equalsIgnoreCase(otherSplitType.MasterLabel)) {
//                                opportunitySplit.SplitTypeId = otherSplitType.Id;
//                            }
//
//                        }
//
//                        opportunitySplit.SplitPercentage = 100.00;
//
//                        insert opportunitySplit;
//
//                        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
//
//                        opportunityTeamMember.OpportunityId = lead.ConvertedOpportunityId;
//                        opportunityTeamMember.UserId = lead.Previous_Owner__c;
//                        opportunityTeamMember.TeamMemberRole = 'Lead Qualifier';
//
//                        insert opportunityTeamMember;
//
//                    }
//
//                }
//
//            }
//
//        }
//
//    }
//    else if(Trigger.isBefore && Trigger.isUpdate) {
//
//        System.debug('### LeadSplitTrigger: Entering before update');
//
//        for(Lead lead : Trigger.new){
//
//            if(lead.OwnerId != null && lead.OwnerId.getSObjectType() == User.SObjectType && leadDevelopmentRoles != null && leadDevelopmentRoles.contains(lead.Role_Id__c)) {
//
//				System.debug('### LeadSplitTrigger: Matches a role - setting to Previous Owner');
//
//                lead.Previous_Owner__c = lead.OwnerId;
//
//            }
//
//        }
//    } 
    
}