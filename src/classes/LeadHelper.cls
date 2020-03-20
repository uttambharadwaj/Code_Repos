/**
 * Created by mfarrell on 3/20/20.
 */

public class LeadHelper {
    
    public static void setOpptyContractRolePrimaryAfterUpdate (List<Lead> triggerLeads) {

        Set<String> AU_Lead_RTs = auLeadRecordTypes();
        List<OpportunityContactRole> opptyContactRolesUpdate = new List<OpportunityContactRole>();
        Map<Id, Lead> leadToOpptyIdMap = new Map<Id, Lead>();
        Map<Id, Lead> leadToContactIdMap = new Map<Id, Lead>();

        for (Lead l : triggerLeads) {
            if(!AU_Lead_RTs.contains(l.RecordTypeId) && l.IsConverted) {

                if (l.ConvertedOpportunityId != null && l.ConvertedContactId != null) {
                    leadToOpptyIdMap.put(l.ConvertedOpportunityId, l);
                    leadToContactIdMap.put(l.ConvertedContactId, l);
                }
            }
        }

        for (OpportunityContactRole ocr : [SELECT Id, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :leadToOpptyIdMap.keySet() AND ContactId = :leadToContactIdMap.keySet()]) {
            ocr.IsPrimary = true;
            opptyContactRolesUpdate.add(ocr);
        }

        update opptyContactRolesUpdate;

    }
    
    public static void auValidateSuburbPostcode (List<Lead> triggerLeads) {
        
        // trigger should fire only for Leads with Australian record types
        Set<String> AU_Lead_RTs = auLeadRecordTypes();

        Set<String> suburbs = new Set<String>();
        Set<String> postcodes = new Set<String>();

        for (Lead l : triggerLeads) {
            if (AU_Lead_RTs.contains(l.RecordTypeId)) {
                // add suburb and postal codes to sets

                if (l.City != null && l.City != '')
                    suburbs.add(l.City);

                if (l.AU_Postal_City__c != null && l.AU_Postal_City__c != '')
                    suburbs.add(l.AU_Postal_City__c);

                if (l.PostalCode != null && l.PostalCode != '')
                    postcodes.add(l.PostalCode);

                if (l.AU_Postal_Postcode__c != null && l.AU_Postal_Postcode__c != '')
                    postcodes.add(l.AU_Postal_Postcode__c);
            }
        }

        List<Postcode__c> postcodesList = new List<Postcode__c>();

        if (!suburbs.isEmpty() || !postcodes.isEmpty()) {
            // Query Postcode records that contain valid suburb and postal codes
            postcodesList = [SELECT Id, Postcode__c, Suburb__c FROM Postcode__c WHERE Suburb__c IN :suburbs OR Postcode__c IN :postcodes];

            for (Lead l : triggerLeads) {
                if (l.City != null && l.City != '' && l.PostalCode != null && l.PostalCode != '') {
                    Boolean isValid = false;

                    // check if a postcode record exists for the given suburb and postcode
                    for (Postcode__c p : postcodesList) {
                        if (p.Suburb__c.equalsIgnoreCase(l.City) && p.Postcode__c == l.PostalCode) {
                            isValid = true;
                            break;
                        }
                    }

                    // throw error if invalid
                    if (!isValid) {
                        l.addError('Incorrect suburb and postcode');
                        return;
                    }
                }

                if (l.AU_Postal_City__c != null && l.AU_Postal_City__c != '' && l.AU_Postal_Postcode__c != null && l.AU_Postal_Postcode__c != '') {
                    Boolean isValid = false;

                    for (Postcode__c p : postcodesList) {
                        // check if a postcode record exists for the given suburb and postcode
                        if (p.Suburb__c.equalsIgnoreCase(l.AU_Postal_City__c) && p.Postcode__c == l.AU_Postal_Postcode__c) {
                            isValid = true;
                            break;
                        }
                    }

                    // throw error if invalid
                    if (!isValid) {
                        l.addError('Incorrect postal suburb and postcode');
                        return;
                    }
                }
            }
        }
        
    }
    
    public static void V2SA_UpdatePrimaryCampaignLeadUpload (List<Lead> triggerLeads) {

        Set<String> AU_Lead_RTs = auLeadRecordTypes();

        for (Integer i = 0; i < triggerLeads.size(); i++) {
            if (!AU_Lead_RTs.contains(triggerLeads[i].RecordTypeId)) {
                if (triggerLeads[i].Primary_Campaign__c == null && triggerLeads[i].SFCampaign_ID__c != null) {
                    triggerLeads[i].Primary_Campaign__c = triggerLeads[i].SFCampaign_ID__c;
                }
            }
        }

    }

    public static void sfIdtoCardId (List<Lead> triggerLeads) {
        Set<String> AU_Lead_RTs = auLeadRecordTypes();

        List<String> SfIDs = new List<String>();
        for(Lead  L : triggerLeads) {
            if(!AU_Lead_RTs.contains(L.RecordTypeId)) {
                if(L.Card_Program_ID__c != null && L.Card_Program_ID__c != '') {
                    SfIDs.add( L.Card_Program_ID__c);
                }
            }
        }

        Map<String,Schema.RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Account> AllRequiredAcc = new  Map<String,Account>();
        if(recordTypes.containsKey('Card Program')) {
            List <Account> accList = [SELECT Id FROM Account WHERE RecordTypeId =: recordTypes.get('Card Program').getRecordTypeId() AND Id IN : SfIDs ];
            for(Account acc: accList ) {
                AllRequiredAcc.put(acc.Id,acc);
                String ACcID= acc.Id;
                AllRequiredAcc.put(ACcID.substring(0,ACcID.length() - 3),acc);
            }
        }

        for(Lead  L : triggerLeads) {
            if(!AU_Lead_RTs.contains(L.RecordTypeId)) {
                if(L.Card_Program_ID__c != null && L.Card_Program_ID__c != '') {
                    if(AllRequiredAcc.containsKey(L.Card_Program_ID__c)) {
                        L.Card_Program__c = L.Card_Program_ID__c ;
                    }
                }
            }
        }

    }

    public static void forsevaLeadAfterInsert (List<Lead> triggerLeads) {
        List<Id> leadList = new List<Id>();
        List<Id> cardProgramList = new List<Id>();

        for(Lead ld : triggerLeads) {

            if((ld.Card_Program__c != null || ld.Card_Program_ID__c != null) && ld.Lead_Source_Website__c != null && ld.Email != null) {
                leadList.add(ld.Id);
                cardProgramList.add(ld.Card_Program_ID__c != null ? ld.Card_Program_ID__c : ld.Card_Program__c);
            }

            if(leadList.size() == 20) {
                OnlineApplication.processLeads(leadList,cardProgramList);  // only do 20 at a time as governors can crush us downstream...
                leadList.clear();
                cardProgramList.clear();
            }
        }

        if(leadList.size() > 0) {
            OnlineApplication.processLeads(leadList,cardProgramList);
        }
    }

    public static void forsevaLeadAfterUpdate (List<Lead> triggerLeadList, Map<Id, Lead> oldMap) {
        Set<String> AU_Lead_RTs = auLeadRecordTypes();

        List<Id> leadIds = new List<Id>();
        for(Lead l : triggerLeadList) {
            if(!AU_Lead_RTs.contains(l.RecordTypeId)) {
                leadIds.add(l.Id);
            }
        }

        if(!leadIds.isEmpty()) {

            List<OnlineApplication__c> oaList = [SELECT Id, Account__c, Opportunity__c, Lead__c FROM OnlineApplication__c WHERE Lead__c IN :leadIds];

            Map<Id,OnlineApplication__c> oaMapByLead = new Map<Id,OnlineApplication__c>();
            for(OnlineApplication__c oa : oaList) {
                oaMapByLead.put(oa.Lead__c, oa);
            }
            oaList.clear();

            for(Lead l : triggerLeadList) {
                // we just care about newly-converted Leads
                if(l.IsConverted == true && oldMap.get(l.Id).IsConverted == false) {
                    OnlineApplication__c oa = oaMapByLead.get(l.Id);
                    if(oa != null) {
                        oa.Account__c = l.ConvertedAccountId;
                        oa.Opportunity__c = l.ConvertedOpportunityId;
                        oaList.add(oa);
                    }
                }
            }

            update oaList;
        }
    }

    public static void auLeadRecordTypesAfterUpdate (List<Lead> triggerLeadList, Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        // trigger should fire only for Leads with Australian record types

        Set<String> AU_Lead_RTs = auLeadRecordTypes();

        Set<Id> leadIds = new Set<Id>();
        for (Lead l : triggerLeadList) {
            if (AU_Lead_RTs.contains(l.RecordTypeId)) {
                // check if lead is converted
                if (l.IsConverted && !oldMap.get(l.Id).IsConverted) {
                    leadIds.add(l.Id);
                }
            }
        }

        if(!leadIds.isEmpty()) {
            List<AU_Card_Details__c> cardDetailList = new List<AU_Card_Details__c>();

            // Query all card detail records against the Lead
            cardDetailList = [SELECT Id, Lead__c FROM AU_Card_Details__c WHERE Lead__c IN :leadIds];
            for(AU_Card_Details__c CardDetail : cardDetailList)
            {
                // assign the Converted Opportunity and Account to Card detail
                Lead l = newMap.get(CardDetail.Lead__c);
                CardDetail.Opportunity__c = l.ConvertedOpportunityId;
                CardDetail.Account__c = l.ConvertedAccountId;
            }

            update cardDetailList;

            List<AU_Vehicle__c> vehicleDetailList = new List<AU_Vehicle__c>();

            vehicleDetailList = [SELECT Id, Lead__c FROM AU_Vehicle__c WHERE Lead__c in :leadIds];
            for(AU_Vehicle__c vehicleDetail : vehicleDetailList) {
                Lead l = newMap.get(vehicleDetail.Lead__c);
                vehicleDetail.Opportunity__c = l.ConvertedOpportunityId;
            }

            update vehicleDetailList;

            List<Contact> contactList = new List<Contact>();

            contactList = [SELECT Id, Lead__c FROM Contact WHERE Lead__c in :leadIds];
            for(Contact contact : contactList) {
                Lead l = newMap.get(contact.Lead__c);
                contact.AccountId = l.ConvertedAccountId;
            }

            update contactList;
        }
    }

    public static void leadSplitsBeforeUpdate (List<Lead> triggerLeads) {

        ConvertLeadSettings__c convertLeadSettings = ConvertLeadSettings__c.getOrgDefaults();

        if(convertLeadSettings.Enable_Lead_Development_Split__c == false && Test.isRunningTest() == false) {
            return;
        }

        Set<String> leadDevelopmentRoles = leadDevelopmentSplits();

        for(Lead lead : triggerLeads){

            if(lead.OwnerId != null && lead.OwnerId.getSObjectType() == User.SObjectType && leadDevelopmentRoles != null && leadDevelopmentRoles.contains(lead.Role_Id__c)) {

                System.debug('### LeadSplitTrigger: Matches a role - setting to Previous Owner');

                lead.Previous_Owner__c = lead.OwnerId;

            }

        }
    }

    public static void leadSplitAfterUpdate (List<Lead> triggerLeads) {
        ConvertLeadSettings__c convertLeadSettings = ConvertLeadSettings__c.getOrgDefaults();

        if(convertLeadSettings.Enable_Lead_Development_Split__c == false && Test.isRunningTest() == false) {
            return;
        }

        List<Lead_Development_Splits__c> leadDevelopmentSplitSettings = Lead_Development_Splits__c.getall().values();
        Set<String> leadDevelopmentRoles = leadDevelopmentSplits();

        List<OpportunityTeamMember> opptyTeamMembersInsert = new List<OpportunityTeamMember>();
        List<OpportunitySplit> opptySplitsInsert = new List<OpportunitySplit>();

        for(Lead lead : triggerLeads) {

            if(lead.IsConverted && lead.Previous_Owner__c != null && leadDevelopmentRoles != null && leadDevelopmentRoles.contains(lead.Previous_Owner_Role__c)) {

                System.debug('### LeadSplitTrigger: Role matches - adding split to Opportunity');

                List<OpportunitySplitType> otherSplitTypes = [SELECT Id, MasterLabel FROM OpportunitySplitType];

                for(Lead_Development_Splits__c leadDevelopmentSplitSetting : leadDevelopmentSplitSettings) {

                    if(leadDevelopmentSplitSetting.Role_Id__c == lead.Previous_Owner_Role__c) {

                        OpportunitySplit opportunitySplit = new OpportunitySplit();

                        opportunitySplit.OpportunityId = lead.ConvertedOpportunityId;

                        opportunitySplit.SplitOwnerId = lead.Previous_Owner__c;

                        opportunitySplit.Commission_Type__c = leadDevelopmentSplitSetting.Commission_Type__c;

                        for(OpportunitySplitType otherSplitType : otherSplitTypes) {

                            if((leadDevelopmentSplitSetting.Opportunity_Split_Type__c).equalsIgnoreCase(otherSplitType.MasterLabel)) {
                                opportunitySplit.SplitTypeId = otherSplitType.Id;
                            }

                        }

                        opportunitySplit.SplitPercentage = 100.00;

                        opptySplitsInsert.add(opportunitySplit);

                        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();

                        opportunityTeamMember.OpportunityId = lead.ConvertedOpportunityId;
                        opportunityTeamMember.UserId = lead.Previous_Owner__c;
                        opportunityTeamMember.TeamMemberRole = 'Lead Qualifier';

                        opptyTeamMembersInsert.add(opportunityTeamMember);

                    }

                }

            }

        }

        insert opptySplitsInsert;
        insert opptyTeamMembersInsert;

    }

    private static Set<String> auLeadRecordTypes () {
        Set<String> AU_Lead_RTs = new Set<String>();
        Map<String, AULeadRecordTypes__c> mapAU_Lead_RTs = AULeadRecordTypes__c.getAll();
        AU_Lead_RTs.addAll(mapAU_Lead_RTs.keySet());

        return AU_Lead_RTs;
    }

    private static Set<String> leadDevelopmentSplits () {

        List<Lead_Development_Splits__c> leadDevelopmentSplitSettings = Lead_Development_Splits__c.getall().values();

        Set<String> leadDevelopmentRoles = new Set<String>();
        for(Lead_Development_Splits__c setting : leadDevelopmentSplitSettings) {
            leadDevelopmentRoles.add(setting.Role_ID__c);
        }

        return leadDevelopmentRoles;
    }

}