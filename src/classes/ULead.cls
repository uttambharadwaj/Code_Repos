/*
*	Created By: GearsCRM
*	Purpose: Utility class for run methods from lead trigger,etc.
*
*   Modified By: Phillip Southern
*   Modified Date: 08/01/14
*   Modified Reason:  Remove account linking to Parent Lead.
*
*   Modified By: Derek Gilbert (WEX)
*   Modified Date: 12/07/17
*   Modified Reason:  Assignment rules not firing when child lead is created by Salesforce Integration.
*
*   Modified By: Lev
*   Modified Date: 07/31/2019
*   Modified Reason: Updated decoupleChildLeadCheck method to include Marketable field when creating a parent lead reccord.
*/

public class ULead {
	
	//private static boolean hasRun = false;
	private static boolean hasRun_ParentInsert = false;
	//private static boolean hasRun_EloquaChildPass = false;
	private static boolean hasrun_Decouple = false;
	//private static boolean hasrun_i2iMerges = false;
	
	private static set<Id> parentsprocessed = new set<id>();
	private static set<Id> childrenprocessed = new set<id>();
	private static set<Id> parentsprocessedthroughMerge = new set<Id>();



    public static void setTotalVehicles (List <Lead> records, Map <id, Lead> oldMap)
    {
        boolean isInsert = (oldMap == null);
        
        for(Lead l : records)
        {
            if(isinsert == true   
               || (isinsert == false 
                   && (l.Number_of_tractors__c != oldMap.get(l.id).Number_of_tractors__c
                       || l.Number_of_Other_Fuel_Vehicles__c != oldMap.get(l.id).Number_of_Other_Fuel_Vehicles__c)))
            {
                if(l.Number_of_Tractors__c == null)
                {
                    l.Number_of_tractors__c = 0;
                }
                if(l.Number_of_Other_Fuel_Vehicles__c == null)
                {
                    l.Number_of_Other_Fuel_Vehicles__c = 0;
                }
                
                l.Number_of_Vehicles__c = l.Number_of_tractors__c + l.Number_of_Other_Fuel_Vehicles__c;
                
                // 9/12/2013 11:02 AM
                //l.Card_Product__c = 'Local';
                //if(l.Number_Of_Tractors__c >= l.Number_of_Other_Fuel_Vehicles__c)
                //{
                //    l.Card_Product__c = 'OTR';
                //}
            }   
        }
    }
    

    public static void setVehicleCount (List <Lead> records, Map <id, Lead> oldMap)
    {
        boolean isInsert = (oldMap == null);
        
        for(Lead l : records)
        {
            if(isinsert == true || (isinsert == false && l.Number_Of_Vehicles__c != oldMap.get(l.id).Number_Of_Vehicles__c))
            {
                if(l.Number_Of_Vehicles__c == null) 
                {
                    l.Number_Of_Vehicles__c = 0;
                }
                
                for(VehicleCount__c v : VehicleCount__c.getall().values())
                {
                    if(l.Number_Of_Vehicles__c >= v.start__c && l.Number_Of_Vehicles__c <= v.end__c)
                    {
                        l.Number_of_Vehicles_Range__c = v.name;
                    }
                }       
            }   
        }
    }

    // replace the V2 trigger V2SA_CreateCampaignMemberLeadUpload
    public static void createCampaignMember (List <Lead> leads)
    {
    	//if(hasRun || hasRun_ParentInsert) return;
    	
    	GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
    	
    	//**todo should I set recursion monitor here?
    	
        List <CampaignMember> CampaignMemberstoInsert = new List <CampaignMember> ();
        
        for(Lead l : leads)
        {
            if(l.Primary_Campaign__c !=null && l.sfcampaign_id__c == null
            && l.recordtypeid != setting.Parent_Lead_Record_Type_Id__c && l.parent_lead__c == null)
            {
                CampaignMember cm = new CampaignMember();
                cm.LeadId = l.Id;
                cm.CampaignId = l.Primary_Campaign__c;
                cm.Status = 'Sent';
                CampaignMemberstoInsert.add(cm);
            }
        }
        
        if(CampaignMemberstoInsert.size() > 0)
        {
            //insert CampaignMemberstoInsert;
            
            
            List<Database.Saveresult> insertResults = Database.insert(CampaignMemberstoInsert,false);
            List<CampaignMember> cmInsertReTry = new List<CampaignMember>();
            //for(SaveResult sr : insertResults)
            for(Integer x = 0; x < CampaignMemberstoInsert.size(); x++)
            {
            	Database.Saveresult sr = insertResults[x];
            	if(!sr.isSuccess())
            	{
            		for(Database.Error err : sr.getErrors())
            		{
            			//if(err.getStatusCode() == StatusCode.UNABLE_TO_LOCK_ROW)
            			//{
            				cmInsertReTry.add(CampaignMemberstoInsert[x]);
            				break;
            			//}
            		}
            	}
            }
            
            if(cmInsertReTry.size()>0) insert cmInsertReTry;
            

        }
    }
    
    
    public static void primaryCampaignChange(List<Lead> leads, Map<Id,Lead> oldmap)
	{
		boolean isinsert = (oldmap==null);
		//monitor for any flags?
		
		GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
		set<Id> leadids = new set<Id>();
		Map<Id,Set<Id>> campaignIdsbyLead = new Map<Id,set<Id>>();	
		List<CampaignMember> cmtoinsert = new List<CampaignMember>();
		
		for(Lead l : leads)
		{
			if(
			l.RecordTypeId!=gs.Parent_Lead_Record_Type_Id__c
			&& l.primary_campaign__c != null
			&& l.Primary_Campaign__c != oldmap.get(l.id).primary_campaign__c
			)
			{
				leadids.add(l.id);
			}
			
		}
		
		for(CampaignMember cm : [Select leadid, campaignid from campaignmember where leadid IN :leadids])
		{
			set<Id> cset = new set<Id>();
			if(campaignIdsbyLead.containskey(cm.leadid)) cset = campaignIdsbylead.get(cm.leadid);
			cset.add(cm.campaignid);
			campaignidsbylead.put(cm.leadid, cset);
		}
		
		for(Lead l2 : leads)
		{
			if(
			l2.RecordTypeId!=gs.Parent_Lead_Record_Type_Id__c
			&& l2.primary_campaign__c != null
			&& l2.Primary_Campaign__c != oldmap.get(l2.id).primary_campaign__c
			&& 
			(!campaignIdsbyLead.containskey(l2.id)
			|| !(campaignIdsbylead.get(l2.id).contains(l2.primary_campaign__c))
			))
			{
				CampaignMember cm = new CampaignMember();
                cm.LeadId = l2.Id;
                cm.CampaignId = l2.Primary_Campaign__c;
                cm.Status = 'Sent';
                cmtoinsert.add(cm);
			}
			
		}
		
		
		if(cmtoinsert.size() > 0)
        {
            //insert CampaignMemberstoInsert;
            
            
            List<Database.Saveresult> insertResults = Database.insert(cmtoinsert,false);
            List<CampaignMember> cmInsertReTry = new List<CampaignMember>();
            //for(SaveResult sr : insertResults)
            for(Integer x = 0; x < cmtoinsert.size(); x++)
            {
            	Database.Saveresult sr = insertResults[x];
            	if(!sr.isSuccess())
            	{
            		for(Database.Error err : sr.getErrors())
            		{
            			//if(err.getStatusCode() == StatusCode.UNABLE_TO_LOCK_ROW)
            			//{
            				cmInsertReTry.add(cmtoinsert[x]);
            				break;
            			//}
            		}
            	}
            }
            
            if(cmInsertReTry.size()>0) insert cmInsertReTry;
        }
		
	}
	
    public static void findCampaignByCouponCode(List <Lead> leads)
    {
    	GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
    	
        Map<string,string> couponcodesbyprofileid = new Map<String,String>();
        Map<String, String> couponcodesbyuserid = new Map<String,String>();
        Set<String> couponcodes = new Set<String>();

        for(Default_Campaigns__c dc : Default_Campaigns__c.getall().values())
        {
            if(dc.ProfileID__c != null && dc.Coupon_Code__c!=null)
            {
                couponcodesbyprofileid.put(dc.profileid__c,dc.Coupon_Code__c.touppercase());
                couponcodes.add(dc.Coupon_Code__c);
            }
            if(dc.UserId__c!=null && dc.Coupon_Code__c!=null)
            {
                couponcodesbyuserid.put(dc.userid__c,dc.Coupon_Code__c);
                couponcodes.add(dc.Coupon_Code__c);
            }
        }
        system.debug('-- findcampaign defaultcampaigns: ' + couponcodesbyprofileid);
        if(couponcodesbyprofileid.isempty()) return;
        

        //Map<String,Id> campaignsbycouponcode = new Map<String,Id>();
        Map<String,Campaign> campaignsbycouponcode = new Map<String,Campaign>();
        for(Campaign c: [Select Id, Coupon_code__c, Default_Campaign_Program__c 
                            from Campaign 
                            Where Coupon_Code__c IN :couponcodes]) //:couponcodesbyprofileid.values()])
        {
            //campaignsbycouponcode.put(c.coupon_code__c,c.Id);
            campaignsbycouponcode.put(c.coupon_code__c,c);
        }
        system.debug('-- findcampaign campaisngbycouponcode: ' + campaignsbycouponcode);
        system.debug('-- userprofileid: ' + UserInfo.getProfileId());
        
        if(campaignsbycouponcode.isempty()== true || 
            (!(couponcodesbyprofileid.containskey(UserInfo.getprofileid())) && !(couponcodesbyuserid.containskey(UserInfo.getUserId())))
            ) return;
        
        for(Lead l : leads)
        {
            if(l.Primary_Campaign__c == null && l.i2i_Coupon_Code_Pass__c == null && l.RecordTypeId != gs.Parent_Lead_Record_Type_Id__c)
            {
                if(couponcodesbyuserid.containskey(UserInfo.getUserId()))
                {
                    l.Primary_Campaign__c = campaignsbycouponcode.get(couponcodesbyuserid.get(Userinfo.getUserId())).Id;
                    l.Campaign_Program__c = campaignsbycouponcode.get(couponcodesbyuserid.get(Userinfo.getUserId())).Default_Campaign_Program__c;
                }
                else if(couponCodesByProfileId.containskey(UserInfo.getprofileid()))
                {
                    //l.Primary_Campaign__c = campaignsbycouponcode.get(couponcodesbyprofileid.get(Userinfo.getprofileid()));
                    l.Primary_Campaign__c = campaignsbycouponcode.get(couponcodesbyprofileid.get(Userinfo.getprofileid())).Id;
                    l.Campaign_Program__c = campaignsbycouponcode.get(couponcodesbyprofileid.get(Userinfo.getprofileid())).Default_Campaign_Program__c;
                }
            }
        }
    }
    
    public static void linktoContactAccount(List<Lead> records, Map<Id, Lead> oldmap)
    {
		system.debug('-* linkContactAccount start: ' + system.now());
		
        boolean isinsert = (oldmap==null);
        
        GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();

        Set<String> i2iIds = new Set<String>();
        Set<String> leademails = new Set<String>();
        
        Set<Id> relatedContactIds = new Set<ID>();
        for(lead l : records)
        {
            if(l.Related_Contact__c!=null) relatedContactIds.add(l.Related_Contact__c);
        }

        Map<Id,Contact> contacts = new Map<Id,Contact>([Select Id, i2i_Id__c from Contact 
                                                    Where Id IN :relatedContactIds]);
        /*
        for(Lead l : records)
        {
            if(l.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
            &&
            l.Related_Contact__c == null
            )
            {
                if(l.i2i_ID__c!=null) i2iIds.add(l.i2i_ID__c);
                if(l.Email!=null) leadEmails.add(l.Email);
            }
        }
        */

        Integer ldSize = records.size();
        for(Integer i = 0; i<ldSize; i++)
        {
            if(records[i].RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
            &&
            (records[i].Related_Contact__c == null
                ||
                (!isinsert && records[i].i2i_id__C != null && records[i].i2i_id__c != contacts.get(records[i].Related_Contact__c).i2i_Id__c)
                )
            )
            {
                if(records[i].i2i_ID__c!=null) i2iIds.add(records[i].i2i_ID__c);
                if(records[i].Email!=null) leadEmails.add(records[i].Email);
            }
        }


        if(i2iIds.isEmpty() && leademails.isEmpty()) return;

        system.debug('--- - i2iid: ' + i2iIds);
        system.debug('--- - emails: ' + leademails);

        Map<String,Contact> contactsbyI2I = new Map<String,Contact>();
        Map<String,Contact> contactsByEmail = new Map<string, Contact>();

        for(Contact c : [Select Id, Email, i2i_id__c, AccountId 
                        from Contact 
                        Where (i2i_Id__c IN :i2iIDs OR Email IN :leademails)
                        AND (i2i_Id__c != null OR Email != null)])
        {
            if(c.i2i_ID__c!=null) contactsbyi2i.put(c.i2i_ID__c,c);
            if(c.Email!=null) contactsbyemail.put(c.Email,c);
        }

        system.debug('--- - contacti2i: ' + contactsbyi2i);
        system.debug('--- - contactsbyemail: ' + contactsbyemail);

        /*
        for(Lead ld : records)
        {
            if(ld.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
                && ld.Related_Contact__c == null
                && (contactsbyi2i.containskey(ld.i2i_ID__c)
                    || (contactsbyemail.containskey(ld.Email) && ld.i2i_ID__c==null && ld.i2i_Contact_ID__c==null)
                )
            )
            {
                Contact cnt = contactsbyi2i.containskey(ld.i2i_id__c) ? contactsbyi2i.get(ld.i2i_id__c) : contactsbyemail.get(ld.email);
                ld.Related_Contact__c = cnt.Id;
            }
        }
        */

        for(Integer j = 0; j<ldSize; j++)
        {
            if(records[j].RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
                && 
                (records[j].Related_Contact__c == null
                    ||
                    (!isinsert && records[j].i2i_id__C != null && records[j].i2i_id__c != contacts.get(records[j].Related_Contact__c).i2i_Id__c)
                )
                /*&& (contactsbyi2i.containskey(records[j].i2i_ID__c)
                    || (contactsbyemail.containskey(records[j].Email) && records[j].i2i_ID__c==null && records[j].i2i_Contact_ID__c==null)
                )*/
            )
            {
                if(contactsbyi2i.containskey(records[j].i2i_ID__c)
                    || (contactsbyemail.containskey(records[j].Email) && records[j].i2i_ID__c==null && records[j].i2i_Contact_ID__c==null))
                {
                    Contact cnt = contactsbyi2i.containskey(records[j].i2i_id__c) ? contactsbyi2i.get(records[j].i2i_id__c) : contactsbyemail.get(records[j].email);
                    records[j].Related_Contact__c = cnt.Id;
                }else if(records[j].Related_Contact__c != null)  //mismatch
                {
                    records[j].Related_Contact__c = null;
                }

                //Contact cnt = contactsbyi2i.containskey(records[j].i2i_id__c) ? contactsbyi2i.get(records[j].i2i_id__c) : contactsbyemail.get(records[j].email);
                //records[j].Related_Contact__c = cnt.Id;
            }
        }

                
        system.debug('-* linkContactAccount end: ' + system.now());
    }

    public static void processParentLead(List<Lead> leads, map<id,lead> oldmap)
    {
        boolean isinsert= (oldmap==null);
        GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
        
        Set<Id> salesProfileIDs = new Set<Id>();
        set<string> parenti2iIds = new set<string>();
        set<string> parentCouponCodes = new set<string>();
        
        Set<Id> relatedContactIds = new Set<Id>();

        
        Map<string,Campaign> parenting_campaignsByCouponCode = new Map<string,Campaign>();
        Map<string,Id> parenting_programsbyCouponCode = new Map<string,Id>();
        
        for(Lead l : leads)
        {
            if(
            l.recordTypeId == setting.Parent_Lead_Record_Type_Id__c 
            && l.i2i_Coupon_Code_Pass__c != null
            && (isinsert || l.i2i_coupon_code_pass__c != oldmap.get(l.Id).i2i_coupon_code_pass__c))
            {
                if(l.i2i_ID__c != null)
                {
                    parenti2iIds.add(l.i2i_Id__c);
                }
                
                parentCouponCodes.add(l.i2i_Coupon_code_pass__c);
                
                if(l.Related_Contact__c != null)
                {
                    relatedContactIds.add(l.Related_Contact__c);
                }
                  
            }
            
        }

        //system.debug('---- isinsert: ' + isinsert);
        //system.debug('---- parentemails: ' + parentemails);
        //system.debug('---- parenti2iids: ' +  parenti2iIds);
        //system.debug('---- parentcouponcodes: ' + parentCouponCodes);
        //system.debug('---- relatedcontactids: ' + relatedContactIds);
        
        /*
        if(
        (parenti2iids.isempty() && UserInfo.getUserId() != setting.Web_to_Lead_creator__c) 
        || parentcouponcodes.isempty())
        {
            system.debug('-* processparent empty exit.' + system.now());
            return;
        }
        */
        if(parentcouponcodes.isempty()) return;
        
                
        /*
        Turn off, upserts could have insert run first
        then batch of update right after it.

        if(isinsert)
        {
            hasRun_ParentInsert=true;
        }else
        {
            if(hasRun_ParentInsert)
            {
                system.debug('-* processparent hasrunparent exit.' + system.now());
                return;
            }
        }
        */

        if(hasRun_Decouple){
            system.debug('-* processparent hasRun_Decouple exit.' + system.now());
            return;
        }

        
        //**********  Sales Profiles to qualify recent Lead task activity.
        
        for(Sales_Activity_by_Profile__c spro : Sales_Activity_by_Profile__c.getall().values())
        {
            if(spro.ProfileID__c != null && (spro.ProfileID__c InstanceOf Id))
            {
                salesProfileIds.add((Id)spro.ProfileID__c);

            }
        }
        //******************

        //********Queues
        /* Used to check for Task assignemtns, not doing task assignments anymore.
        Set<Id> lead_oppQueues = new Set<Id>();
        for(QueueSobject qso : [Select QueueId from QueueSobject 
                                    Where QueueId != null
                                    AND(SobjectType = 'Lead' OR SobjectType = 'Opportunity')])
        {
            lead_oppQueues.add(qso.QueueId);
        }
        */
        

        //***************
        //Recordtypes for Child Lead Assignemnts
        Map<String,String> childRecordTypesByProgram = new Map<String,String>();
        for(Lead_record_Type__c lrt : Lead_record_Type__c.getall().values())
        {
            if(lrt.Lead_Record_Type_ID__c!=null && lrt.ProgramID__c != null)
            {
                childRecordTypesByProgram.put(lrt.programid__c,lrt.lead_record_type_id__c);
            }
        }
        //**************
        
        //***********************************************
        //building campaign and program data
        
        Set<Id> programsFromCouponCodes = new Set<Id>();
        for(Campaign c : [Select Id, Default_Program__c, Default_Campaign_Program__c, Coupon_code__c, Offer__c 
                            from Campaign Where Coupon_Code__c IN :parentCouponCodes])
        {
            if(c.Default_Program__c!=null)
            {
                programsFromCouponCodes.add(c.Default_Program__c);
                parenting_programsbycouponcode.put(c.Coupon_code__c,c.Default_Program__c);
            }
            
            parenting_campaignsbyCouponCode.put(c.Coupon_code__c, c);
        }
        
                
        set<Id> campaignsUnderPrograms = new Set<Id>();
        for(Campaign_Program__c cp2 : [Select Campaign__c from Campaign_Program__c Where
                                        Program__c IN :programsfromcouponcodes
                                        AND Campaign__c != null])
        {
            campaignsUnderPrograms.add(cp2.Campaign__c);
        }
        

        system.debug('-- programsFromCouponCodes: ' + programsFromCouponCodes);
        system.debug('-- parenting_programsbycouponcode: ' + parenting_programsbycouponcode);
        system.debug('-- parenting_campaignsbyCouponCode: ' + parenting_campaignsbyCouponCode);
        system.debug('-- campaignsUnderPrograms: ' + campaignsUnderPrograms);

        //*************************************************
        
        //check dml limits
        //system.debug('-- in ulead2: ' + limits.getqueries() + ' :: ' + limits.getLimitQueries());
        //system.debug('-- in ulead row2: ' + limits.getQueryRows() + ' :: ' + limits.getLimitQueryRows());
        

        
        //**************************************************
        //building overhead to find contact/opp matches
        Map<string,OpportunityContactRole> i2iIdcontactOpportunityMap = new Map<string,OpportunityContactRole>();
          
        
        for(OpportunityContactRole ocr : [Select Id, ContactId, OpportunityId, Contact.i2i_ID__c, Opportunity.Campaign.Coupon_code__c,
                                        Contact.OwnerId, Opportunity.OwnerId, Opportunity.Campaign.Default_Program__c, Contact.Email
                                        from OpportunityContactRole
                                        Where Opportunity.IsClosed=false
                                        AND Contact.i2i_ID__c IN :parenti2iIds
                                        AND ContactId IN :relatedContactIds //new restricting contact ids
                                        AND Opportunity.Campaign.Default_Program__c IN :programsFromCouponCodes])
                                        //AND Opportunity.Campaign.Coupon_Code__c IN :parentcouponcodes])
        {
            i2iIdcontactOpportunityMap.put(ocr.Opportunity.Campaign.Default_Program__c+'-'+ocr.contact.i2i_Id__c,ocr);
        }
        
        system.debug('---- i2iIdcontactOpportunityMap: ' + i2iIdcontactOpportunityMap);


        //****************************************************
        //building overhead for finding child lead matches
        Map<string,CampaignMember> i2iChildLeadAndProgramAndActivity = new Map<string,CampaignMember>();

        
        List<CampaignMember> i2iChildLeadCMs = new List<CampaignMember>();
        Set<Id> leadsunderProgramMatch = new Set<Id>();

        Set<String> parenting_existingLeadsOnCampaigns = new Set<String>();
        for(CampaignMember cm : [Select LeadId, CampaignId, Lead.Email, Lead.i2i_ID__c, Lead.Parent_Lead__c, Lead.CreatedDate,
                                Lead.Parent_Lead__r.i2i_coupon_code_pass__c, Campaign.Default_Program__c, Lead.OwnerId, 
                                Lead.Parent_Lead__r.i2i_Id__c
                                from CampaignMember where 
                                LeadId != null 
                                AND Lead.Parent_Lead__c !=null
                                AND Lead.RecordTypeId != :setting.Parent_Lead_Record_Type_Id__c
                                AND Lead.IsConverted = false
                                AND Lead.Parent_Lead__r.i2i_Id__c IN :parenti2iIDs
                                AND CampaignId IN :campaignsUnderPrograms                                                             
                                ORDER By Lead.CreatedDate ASC])
        {
            leadsunderProgramMatch.add(cm.LeadId);
            i2iChildLeadCMs.add(cm);

            parenting_existingLeadsOnCampaigns.add(cm.LeadId+'-'+cm.CampaignId);
        }

        system.debug('---- i2iChildLeadCMs: ' + i2iChildLeadCMs);

        Date ninetydays = system.now().date().adddays(-90);
        Set<Id> leadIdsFromTasks = new Set<Id>();
        for(task t : [Select WhoId from Task Where Status = 'Completed'
                                AND ActivityDate >= :ninetydays
                                AND Who.Type = 'Lead'
                                AND Owner.ProfileId IN :salesProfileIds
                                AND WhoId IN :leadsUnderProgramMatch])
        {
            leadIdsFromTasks.add(t.WhoId);
        }
        
        
        system.debug('---- leadsidsfromtasks: ' + leadIdsFromTasks);

        for(CampaignMember i2icm : i2iChildLeadCMs)
        {
            if(leadIdsFromTasks.contains(i2icm.LeadId) || i2icm.Lead.CreatedDate >= ninetydays) 
            {i2iChildLeadAndProgramAndActivity.put(i2icm.Lead.Parent_Lead__c +'-'+i2icm.Campaign.Default_Program__c+'-'+i2icm.lead.parent_lead__r.i2i_id__c,i2icm);}
        }

        system.debug('---- i2iChildLeadAndProgramAndActivity: ' + i2iChildLeadAndProgramAndActivity);
        
        //******************************************************************************************************



        /*
        if(!isinsert)
        {
        system.debug('---- i2iIdcontactopportunitymap: ' + i2iIdcontactOpportunityMap);
        system.debug('---- i2iChildLeadAndProgramAndActivity: ' + i2iChildLeadAndProgramAndActivity);
        }
        */
        
        Database.Dmloptions dmlo = new Database.Dmloptions();
        
        AssignmentRule ar = new AssignmentRule();
        ar = [Select Id from AssignmentRule Where SobjectType = 'Lead' and Active = true LIMIT 1];
        if(ar!=null)
        {
            dmlo.assignmentRuleHeader.assignmentRuleId=ar.Id;
            dmlo.EmailHeader.triggerUserEmail = true;
        }
        
        Boolean integrationUser = (UserInfo.getUserId()==setting.Integration_User_ID__c||UserInfo.getUserId()==setting.Web_to_Lead_creator__c);
        
        //****End of overhead



        List<Lead> oppContactMatchCreateLead = new List<Lead>();
        List<Lead> programAcitivtyMatchAppendChildLead = new List<Lead>();
        List<Lead> eeCreateChildLeads = new List<Lead>();

        //Tasks not being created, turned off per client request.
        //Map<OpportunityContactRole,String> ocrsForTasks = new Map<OpportunityContactRole,String>();
        //List<Lead> leadsforTasks = new List<Lead>();

        Set<Id> contactIdsForCMCheck = new Set<Id>();


        //Start loop to categorize leads
        for(Lead ld : leads)
        {           
            if(
            ld.RecordTypeId==setting.Parent_Lead_Record_Type_Id__c 
            && ld.i2i_Coupon_Code_Pass__c != null
            && !(parentsprocessed.contains(ld.Id))
            && (isinsert || ld.i2i_Coupon_Code_Pass__c != oldmap.get(ld.id).i2i_coupon_code_pass__c)
            )
            {
                parentsprocessed.add(ld.Id);
                
                if(i2iIdcontactOpportunityMap.containskey(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)+'-'+ld.i2i_Id__c)
                && (i2iIdContactOpportunityMap.get(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)+'-'+ld.i2i_id__c).ContactId == ld.Related_Contact__c))
                {
                    /*
                    Lead l_child = ld.clone();
                    l_child.Parent_Lead__c = ld.Id;
                    l_child.i2i_id__c = '';
                    l_child.Related_Account__c = null;
                    l_child.Related_Contact__c = null;
                    l_child.Jigsaw = null;
                    */

                    Lead l_child = createChildLead(ld);
                    l_child.RecordtypeId = childRecordTypesByProgram.containskey(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)) ? childRecordTypesByProgram.get(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c))
                                            : setting.Default_Lead_Record_Type__c;
                    
                    //if(!(parenting_campaignsbycouponcode.containskey(ld.i2i_coupon_code_pass__c)) || !(parenting_programsbycouponcode.containskey(ld.i2i_coupon_code_pass__c))) l_child.No_campaign__c=true;
                    
                    
                    
                    if(parenting_campaignsbycouponcode.containskey(ld.i2i_coupon_code_pass__c))
                    {
                        l_child.primary_campaign__c = parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).Id;
                        if(parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c !=null) l_child.campaign_program__c = parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c;

                    }
                    else if(!(parenting_programsbycouponcode.containskey(ld.i2i_coupon_code_pass__c)))
                    {
                        l_child.No_campaign__c=true;
                    }
                    
                    
                    if(ar!=null && integrationUser)
                    {
                        l_child.setoptions(dmlo);
                    }else
                    {
                        l_child.OwnerId = UserInfo.getUserId();
                    }
                    
                    oppContactMatchCreateLead.add(l_child);
                    
                    //ocrsForTasks.put(i2iIdcontactOpportunityMap.get(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)+'-'+ld.i2i_id__c),ld.i2i_Coupon_Code_Pass__c);
                    
                    if(ld.Related_Contact__c!=null) contactIdsForCMCheck.add(ld.Related_Contact__c);
                    

                    system.debug('---- i2iOCRmatch: ' + ld.id);

                }else if(i2ichildleadandprogramandactivity.containskey(ld.Id+'-'+parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)+'-'+ld.i2i_Id__c))
                {
                    CampaignMember cm = i2ichildleadandprogramandactivity.get(ld.Id+'-'+parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)+'-'+ld.i2i_Id__c);
                    Lead l = new lead(id=cm.leadid, parent_lead__c = cm.lead.parent_lead__c, i2i_coupon_code_pass__c = ld.i2i_coupon_code_pass__c, ownerid=cm.lead.ownerid);
                    programAcitivtyMatchAppendChildLead.add(l);
                    
                    system.debug('---- i2i programActivitymatch: ' + ld.id);
                       
                }else 
                //if(ld.i2i_ID__c != null || (isinsert && UserInfo.getUserId() == setting.Web_to_Lead_creator__c))
                //New requirement 071714, all parent leads should create a child lead.
                {
                   
                    /*
                    Lead l_child = ld.clone();
                    l_child.parent_lead__c = ld.id;
                    l_child.i2i_id__c = '';
                    l_child.Related_Account__c = null;
                    l_child.Related_Contact__c = null;
                    l_child.Jigsaw = null;
                    */

                    Lead l_child = createChildLead(ld);
                    l_child.RecordtypeId = childRecordTypesByProgram.containskey(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c)) ? childRecordTypesByProgram.get(parenting_programsbycouponcode.get(ld.i2i_coupon_code_pass__c))
                                            : setting.Default_Lead_Record_Type__c;


                    
                    //if(!(parenting_campaignsbycouponcode.containskey(ld.i2i_coupon_code_pass__c)) || !(parenting_programsbycouponcode.containskey(ld.i2i_coupon_code_pass__c))) l_child.No_campaign__c=true;
                   
                    
                    if(parenting_campaignsbycouponcode.containskey(ld.i2i_coupon_code_pass__c))
                    {
                        l_child.primary_campaign__c = parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).Id;
                        if(parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c !=null) l_child.campaign_program__c = parenting_campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c;

                    }
                    else if(!(parenting_programsbycouponcode.containskey(ld.i2i_coupon_code_pass__c)))
                    {
                        l_child.No_campaign__c=true;
                    }
                    

                    if(ar!=null && integrationUser)
                    {
                        l_child.setoptions(dmlo);
                    }else
                    {
                        l_child.OwnerId = UserInfo.getUserId();
                    }

                    eeCreateChildLeads.add(l_child);




                    system.debug('-- i2i ee_match: ' + ld.id);
                    
                }
            }
        } //end lead loop

        system.debug(' ---- container checks for insert=' +isinsert);
        system.debug(' ---- oppcontactmatchcreatelead: ' + oppcontactmatchcreatelead);
        system.debug(' ---- programAcitivtyMatchAppendChildLead: ' + programAcitivtyMatchAppendChildLead);
        system.debug(' ---- eeCreateChildLeads: ' +eeCreateChildLeads);

        //Based on the categorization, either create lead/convert with cm, create CM only, or create lead and cm.
        Map<Id,CampaignMember> cmtoInsertByLeadId = new Map<Id,CampaignMember>();
        List<Task> tasksToInsert = new List<Task>();
        List<Database.Leadconvert> leadsToConvert = new List<Database.Leadconvert>();
        
        String convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1].MasterLabel;
         
        if(oppContactMatchCreateLead.size()>0)
        {
            insert oppContactMatchCreateLead;

            Set<String> existingcontactCMs = new Set<String>();
            for(CampaignMember cm_c : [Select Id, ContactId, CampaignId from CampaignMember Where ContactId IN :contactIdsForCMCheck])
            {
                existingcontactCMs.add(cm_c.ContactId+'-'+cm_c.CampaignId);
            }
            
            for(Lead oppMatchLead : oppContactMatchCreateLead)
            {
                if(!(existingcontactCMs.contains(oppMatchLead.Related_Contact__c+'-'+(parenting_campaignsByCouponCode.get(oppmatchlead.i2i_coupon_code_pass__c).Id)))
                && parenting_campaignsbycouponcode.containskey(oppmatchlead.i2i_coupon_code_pass__c))
                {
                    CampaignMember childcm = new CampaignMember();
                    childcm.leadid = oppmatchlead.id;
                    childcm.CampaignId = parenting_campaignsbycouponcode.get(oppmatchlead.i2i_coupon_code_pass__c).Id;
                    childcm.status = 'Sent';
    
                    cmtoInsertByLeadId.put(childcm.leadid,childcm);
                }
                
                
                Database.Leadconvert lc = new Database.Leadconvert();
                lc.setLeadId(oppMatchLead.Id);
                lc.setConvertedStatus(convertStatus);
                system.debug('---- parenting lead convert check: ' + oppmatchlead.OwnerId + ' '+ userinfo.getUserId());
               
                lc.setOwnerId(UserInfo.getUserId());
                if(oppmatchlead.related_account__c!=null) lc.setaccountid(oppmatchlead.related_account__c);
                if(oppmatchlead.related_contact__c!=null && oppmatchlead.Related_Account__c!=null) lc.setcontactid(oppmatchlead.related_contact__c);
                lc.setDoNotCreateOpportunity(true);
                
                leadstoconvert.add(lc);             
            }
        }
       
        if(programAcitivtyMatchAppendChildLead.size()>0)
        {
            cmtoinsertbyleadid.putall(buildCampaignMemberByCouponCode(programAcitivtyMatchAppendChildLead,parenting_campaignsbycouponcode,parenting_existingLeadsOnCampaigns)); //parenting_programsbycouponcode));
            //leadsfortasks.addall(programAcitivtyMatchAppendChildLead);
        }
        
        if(eeCreateChildLeads.size()>0)
        {
            system.debug('---- eeCreatedChildLeads before insert: ' + eeCreateChildLeads);
            insert eeCreateChildLeads;

            //leadsfortasks.addall(eeCreateChildLeads);
            cmtoinsertbyleadid.putall(buildcampaignmemberbycouponcode(eeCreateChildLeads,parenting_campaignsbycouponcode,parenting_existingLeadsOnCampaigns));
        }

        //**Turning off per client request 03/27/14
        //if(ocrsForTasks.size()>0) leadParentingTaskCreation(null,ocrsfortasks,parenting_campaignsbycouponcode,lead_oppQueues,setting.Default_Activity_Owner__c);
        //if(leadsfortasks.size()>0) leadParentingTaskCreation(leadsfortasks,null,parenting_campaignsbycouponcode, lead_oppQueues, setting.Default_Activity_Owner__c);

        
        system.debug(' ---- cmtoinsertbyleadid: ' + cmtoinsertbyleadid);

        if(cmtoInsertByLeadId.size()>0)
        {
            insert cmtoInsertByLeadId.values();
        }
        
        if(leadsToConvert.size()>0)
        {
            system.debug('-* leadconvert start: ' + system.now());
            List<Database.Leadconvertresult> lcr = database.convertlead(leadstoconvert);
            system.debug('-* leadconvert end: ' + system.now());
        }
        
        system.debug('-* processParent end: ' + system.now());

    }



    
    public static Map<Id,CampaignMember> buildCampaignMemberByCouponCode(List<Lead> leads, Map<string,Campaign> campaigns, Set<String> existingLeadsOnCampaigns)
    {
    	system.debug('-* buildcampaignmemberbycouponcode start: ' + system.now());
    	
        Map<Id,CampaignMember> members = new Map<Id,CampaignMember>();
        
        for(lead l : leads)
        {
        	//if(!(existingLeadsonCampaigns.contains(l.id+'-'+(campaigns.get(l.i2i_coupon_code_pass__c).Id)))
        	//&& campaigns.containskey(l.i2i_coupon_code_pass__c))
        	if(campaigns.containskey(l.i2i_coupon_code_pass__c)
        	&& !(existingLeadsOnCampaigns.contains(l.id+'-'+(campaigns.get(l.i2i_coupon_code_pass__c).Id))))
        	{
        		CampaignMember childcm = new CampaignMember();
	            childcm.LeadId = l.Id;
	            childcm.status = 'Sent';
	            childcm.campaignid = campaigns.get(l.i2i_coupon_code_pass__c).Id;
	            members.put(l.id,childcm);
        	}
        }
        
        system.debug('-* buildcampaignmemberbycouponcode end: ' + system.now());
        
        return members;
        
        
    }

    //Not being used, turned off for client request 03/27/14
    /*
    public static void leadParentingTaskCreation(List<Lead> leads, Map<OpportunityContactRole,String> ocrs, Map<String,Campaign> campaigns, Set<Id> queueIDs, String defaultActivityOwner)//List<sobject> objects, Boolean opp)
    {
    	system.debug('-* leadparentingtask start: ' + system.now());
    	
        List<Task> tasksToInsert = new List<Task>();

        if(leads!=null)
        {
        	for(lead l : leads)
        	{
        		Task t = new Task();
	        	t.ownerid = queueIds.contains(l.ownerid) ? defaultActivityOwner : l.ownerid;
	        	t.subject = 'WEX Marketing Notification: Lead Has Been Updated';
	        	t.whoId = l.id;
	        	t.Type='WEX Marketing Notification';
            	t.Activity_Type__c='WEX Marketing Notification';
            	t.ActivityDate = system.now().date();
	        	t.Description = (campaigns.containskey(l.i2i_coupon_code_pass__c)) ? campaigns.get(l.i2i_coupon_code_pass__c).Offer__c : '';
	        	
	        	taskstoinsert.add(t);
        	}
        	
        }
        
        if(ocrs!=null)
        {
        	for(OpportunityContactRole oc : ocrs.keyset())
        	{
        		Task t = new Task();
	        	t.ownerid = queueIds.contains(oc.opportunity.ownerid) ? defaultActivityOwner : oc.opportunity.ownerid;
	        	t.subject = 'WEX Marketing Notification: Oppty Has Been Updated';
	        	t.whatId = oc.opportunityid;
	        	t.Type='WEX Marketing Notification';
            	t.Activity_Type__c='WEX Marketing Notification';
            	t.ActivityDate = system.now().date();
	        	t.Description = (campaigns.containskey(ocrs.get(oc))) ? campaigns.get(ocrs.get(oc)).Offer__c : '';
	        	
	        	taskstoinsert.add(t);
        	}
        }
        
        if(taskstoinsert.size()>0) insert taskstoinsert;
        
        system.debug('-* leadparentingtask end: ' + system.now());
            
    }
    */


    public static void decoupleChildLeadCheck(List<Lead> records, Map<Id,Lead> oldmap)
    {
        Boolean isinsert = (oldmap==null);
        GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();

        List<Lead> childrentoupdate = new List<Lead>();
        Map<Id,Lead> parentstoinsert = new Map<Id,Lead>();

        //Set<string> emailscope = new Set<String>();
        Set<Id> parentIds = new Set<Id>();
        for(Lead l : records)
        {
            if(!isinsert && l.Email != 'none@none.com'
            && !(childrenprocessed.contains(l.Id))
            && l.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c
            && l.email!=null && l.email != oldmap.get(l.Id).Email 
            && l.Parent_Lead__c!=null
            )
            {
                //emailScope.add(l.email);
                parentIds.add(l.Parent_Lead__c);
            }
        }

        Map<Id, string> parentIdandEmail = new Map<Id,string>();
        for(Lead ld : [Select Id, Email from Lead Where RecordTypeId = :setting.Parent_Lead_Record_Type_Id__c
                        AND Id IN :parentIds])
                        //AND Email IN :emailscope])
        {
            parentIdandEmail.put(ld.Id, ld.Email);
        }

        for(Lead l2 : records)
        {

            if(
            l2.Email != 'none@none.com'
            && !(childrenprocessed.contains(l2.Id))
            && l2.RecordTypeId != setting.Parent_Lead_Record_Type_Id__c
            &&((isinsert && l2.Parent_Lead__c==null)
            ||(!isinsert && l2.email!=null && l2.email != oldmap.get(l2.Id).Email && l2.Parent_Lead__c!=null
                && parentIdandEmail.containskey(l2.Parent_Lead__c) && l2.Email != parentIdandEmail.get(l2.Parent_Lead__c)
             //&& l2.Email != parentleads.get(l2.Parent_lead__c).Email //&& parentleads.containskey(l2.parent_lead__c)
            ))
            )
            {
                Lead pLead = new Lead();
                pLead.firstname = l2.firstname;
                plead.lastname = l2.lastname;
                plead.company = l2.company;
                plead.phone = l2.phone;
                plead.email = l2.email;
                plead.ownerid = setting.Parent_Lead_Queue__c;
                plead.recordtypeid = setting.Parent_Lead_Record_Type_Id__c;

                parentstoinsert.put(l2.Id,plead);
                childrentoupdate.add(l2);

                hasRun_Decouple = true;
            }
        }

        //Bail out on tests here, because causing issues with existing WEX test class.
        if(test.isRunningTest() && (setting == null || setting.Parent_Lead_Queue__c == null)) return;

        if(parentstoinsert.size()>0) insert parentstoinsert.values();
        else return;

        if(childrentoupdate.isEmpty()) return;

        List<Lead> updateChildren = new List<Lead>();
        for(Lead childl : childrentoupdate)
        {
            Lead c_lead = new Lead(id=childl.Id, Parent_Lead__c=parentstoinsert.get(childl.Id).Id);
            //childl.Parent_Lead__c = parentstoinsert.get(childl.Id).Id;

            updateChildren.add(c_lead);
        }

        if(updateChildren.size()>0) update updateChildren;


    }

    // Update parent Lead Marketable value on child Lead update
    public static void setMarketable(List<Lead> records, Map<Id, Lead> oldMap) {
        // Only pull child Leads that have just been assigned a parent Lead and have a primary campaign
        System.debug('Marketable:' + records);
        Map<Id, Id> parentIdToCampaignIdMap = new Map<Id, Id>();
        for (Lead l : records) {
            if (l.Parent_Lead__c != null &&
                    //oldMap.get(l.Id).Parent_Lead__c != l.Parent_Lead__c &&
                    l.Primary_Campaign__c != null) {
                parentIdToCampaignIdMap.put(l.Parent_Lead__c, l.Primary_Campaign__c);
            }
        }

        // Query only for parent Leads that don't have Marketable already set
        Map<Id, Lead> parentLeadMap = new Map<Id, Lead>([
                SELECT Id, Marketable__c
                FROM Lead
                WHERE Id IN :parentIdToCampaignIdMap.keySet()

        ]);

        // Filter out parent Leads with Marketable value already set
        for (Id parentId : parentIdToCampaignIdMap.keySet()) {
            if (!parentLeadMap.keySet().contains(parentId)) {
                parentIdToCampaignIdMap.remove(parentId);
            }
        }

        // Query for primary campaign records to determine if they are marketable to all
        Map<Id, Campaign> primaryCampaignMap = new Map<Id, Campaign>([
                SELECT Id,
                        Campaign_Program_Marketable_to__c
                FROM Campaign
                WHERE Id IN :parentIdToCampaignIdMap.values()
        ]);
        System.debug('primaryCampaignMap:' + primaryCampaignMap);

        // Set Marketable on parent Leads
        for (Lead parentLead : parentLeadMap.values()) {
            // Determine marketable value based on primary campaign of child Lead
            Id campaignId = parentIdToCampaignIdMap.get(parentLead.Id);
            String marketable = primaryCampaignMap.get(campaignId).Campaign_Program_Marketable_to__c;
            //If the  parent lead has Marketable set to Partners, but a child lead is created that is associated with a Wex program, flip the parent lead's marketable to All
            if (parentLead.Marketable__c != 'All' && String.isNotBlank(marketable) && String.isNotEmpty(marketable)) {
                parentLead.Marketable__c = marketable;
            }

        }
        System.debug('parentLeadMap:' + parentLeadMap.values());
        // Update parent Leads
        update parentLeadMap.values();
    }

    public static void eloquaPassParent(List<Lead> records, Map<Id,Lead> oldMap)
    {
        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
        
        for(Lead l : records)
        {
            if(l.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
                && l.Most_Recent_Response__c != oldmap.get(l.Id).Most_Recent_Response__c
                && oldmap.get(l.Id).Most_Recent_Response__c!=null
                && oldmap.get(l.Id).Most_Recent_Response_Date__c != null)
            {
                String responseSummary = (l.Response_Summary__c==null) ? '' : l.Response_Summary__c;
                l.Response_Summary__c = responseSummary + '\r\n' + oldmap.get(l.Id).Most_Recent_Response_Date__c.format() + ' ' +
                                        oldmap.get(l.Id).Most_Recent_Response__c;
            }
        }


    }
    public static void eloquaPass(List<Lead> records, Map<Id,Lead> oldmap)
    {
        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
        Boolean isinsert = (oldmap ==null);

        Set<String> i2iIds = new Set<String>();
        Set<String> parentCouponCodes = new Set<String>();
        
        for(Lead L : records)
        {
            if(l.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
                && l.Most_Recent_Response__c != null
                && l.i2i_Coupon_Code_Pass__c != null
                && (isinsert || l.Most_Recent_Response__c != oldmap.get(l.Id).Most_Recent_Response__c)
                && l.i2i_id__c != null)
            {
                i2iIds.add(l.i2i_id__c);
                parentCouponCodes.add(l.i2i_coupon_code_pass__c);
            }

        }

        if(i2iIds.isEmpty() || parentCouponCodes.isEmpty()) return;


        //*** General Overhead

        Database.Dmloptions dmlo = new Database.Dmloptions();
        AssignmentRule ar = new AssignmentRule();
        ar = [Select Id from AssignmentRule Where SobjectType = 'Lead' and Active = true LIMIT 1];
        if(ar!=null)
        {
            dmlo.assignmentRuleHeader.assignmentRuleId=ar.Id;
        }
        Boolean integrationUser = (UserInfo.getUserId()==gs.Integration_User_ID__c);

        //Recordtypes for Child Lead Assignemnts
        Map<String,String> childRecordTypesByProgram = new Map<String,String>();
        for(Lead_record_Type__c lrt : Lead_record_Type__c.getall().values())
        {
            if(lrt.Lead_Record_Type_ID__c!=null && lrt.ProgramID__c != null)
            {
                childRecordTypesByProgram.put(lrt.programid__c,lrt.lead_record_type_id__c);
            }
        }

        //coupon code, campaigns, and program data needed for child lead insert
        Map<string,Campaign> campaignsByCouponCode = new Map<string,Campaign>();
        Map<string,Id> programsbyCouponCode = new Map<string,Id>();

        for(Campaign c : [Select Id, Default_Program__c, Default_Campaign_Program__c, Coupon_code__c, Offer__c 
                            from Campaign Where Coupon_Code__c IN :parentCouponCodes])
        {
            if(c.Default_Program__c!=null)
            {
                //programsFromCouponCodes.add(c.Default_Program__c);
                programsbycouponcode.put(c.Coupon_code__c,c.Default_Program__c);
            }
            
            campaignsbyCouponCode.put(c.Coupon_code__c, c);
        }

        //dynamic field pass through
        Set<String> passthroughLeadFields = new Set<String>();
        Set<String> passthroughOppFields = new Set<String>();

        for(EloquaPassThroughFields__c ep : EloquaPassThroughFields__c.getall().values())
        {
            if(ep.Object__c != null && ep.Object__c.toLowerCase() == 'opportunity'
                && ep.Parent_API_Name__c !=null 
                && ep.Destination_Field_API_Name__c != null) passthroughOppFields.add(ep.Parent_API_Name__c+'-'+ep.Destination_Field_API_Name__c);

            if(ep.Object__c != null && ep.Object__c.toLowerCase() == 'lead'
                && ep.Parent_API_Name__c !=null 
                && ep.Destination_Field_API_Name__c != null) passthroughLeadFields.add(ep.Parent_API_Name__c+'-'+ep.Destination_Field_API_Name__c);
            
        }

        //*** General Overhead end

        //**Overhead to find who to pass eloqua updates to
        Set<Id> whoIds = new Set<Id>();
        Date ninetydays = system.now().date().adddays(-90);

        Map<String,OpportunityContactRole> opportunityContacts = new Map<String,OpportunityContactRole>();
        Set<Id> opportunityContactsContactIds = new Set<Id>();
        for(OpportunityContactRole ocr : [Select Id, ContactId, OpportunityId,
                                            Opportunity.CampaignId, Opportunity.Campaign.Coupon_Code__c,
                                            Opportunity.Most_Recent_Response__c, Opportunity.Most_Recent_Response_Date__c,
                                            Opportunity.Response_Summary__c
                                            from OpportunityContactRole 
                                            Where 
                                            Opportunity.Campaign.Coupon_Code__c IN :parentCouponCodes
                                            AND Contact.i2i_ID__c IN :i2iIds
                                            AND Opportunity.CreatedDate >= :ninetydays
                                            ])
        {
            string unqkey = (string)ocr.contactid + ocr.Opportunity.Campaign.Coupon_code__c; //ocr.opportunity.coupon_code2__c;
            opportunityContacts.put(unqkey,ocr);     
            opportunityContactsContactIds.add(ocr.contactid);

        }

        system.debug('--ocr: ' + opportunitycontacts);

        Map<String, CampaignMember> campaignMembersMapLead = new Map<String, CampaignMember>();
        Map<String, CampaignMember> campaignMembersMapContact = new Map<String, CampaignMember>();
        
        List<CampaignMember> campaignMembersLead = new List<CampaignMember>();
        //List<CampaignMember> campaignMembersContact = new List<CampaignMember>();
        Set<String> existingLeadsOnCampaigns = new Set<String>();
        for(CampaignMember cm : [Select LeadId, ContactId, Contact.i2i_Id__c, lead.IsConverted, Lead.Status,
                                CampaignId, campaign.Coupon_Code__c,
                                Lead.Parent_Lead__c, Lead.Parent_Lead__r.i2i_id__c, Lead.CreatedDate,
                                Lead.Most_Recent_Response__c, Lead.Most_Recent_Response_Date__c,
                                Lead.Response_Summary__c
                                from CampaignMember 
                                where campaign.Coupon_Code__c IN :parentcouponcodes 
                                AND ((lead.IsConverted = false AND lead.Status!='Disqualified') OR contactId IN :opportunityContactsContactIds)
                                AND (lead.parent_lead__r.i2i_id__c IN :i2iIds or Contact.i2i_id__c IN :i2iIDs)
                                Order By CreatedDate ASC])
        {
            
            if(cm.contactId != null) 
            {
                campaignMembersMapContact.put(cm.contact.i2i_id__c+'-'+cm.campaign.coupon_code__c,cm);
                whoIds.add(cm.contactid);   
            }
            
            if(cm.leadId != null) 
            {
                campaignMembersLead.add(cm);
                whoIds.add(cm.leadid);

                existingLeadsOnCampaigns.add(cm.LeadId+'-'+cm.CampaignId);
            }
            
            //programnamesbycouponcode.put(cm.campaign.coupon_code__c,cm.campaign.default_program__r.name);
            system.debug('-- cm: ' + cm);
        }

        Set<Id> salesProfileIDs = new Set<Id>();
        for(Sales_Activity_by_Profile__c spro : Sales_Activity_by_Profile__c.getall().values())
        {
            if(spro.ProfileID__c != null && spro.ProfileID__c InstanceOf Id)
            {
                salesProfileIds.add((Id)spro.profileid__c);
            }
        }

        Set<Id> activities90days = new Set<Id>();
        for (Task t : [Select WhoId from Task Where WhoId IN :whoIds
                        AND Status='Completed' AND ActivityDate >=:ninetydays
                        AND Owner.ProfileId IN :salesProfileIds])
        {
            activities90days.add(t.whoid);
        }
        
        system.debug('---- activities: ' + activities90days);
        
        //**loop through lead campaign members and build map by i2i id and coupon code.
        for(campaignmember cm : campaignMembersLead)
        {
            if(cm.lead.createddate > ninetydays || activities90days.contains(cm.leadid))
            {
                campaignMembersMapLead.put(cm.lead.parent_lead__r.i2i_id__c+'-'+cm.campaign.coupon_code__c,cm);
            }
        }


        //**********************************************Overhead end



        //List<Opportunity> oppsToupdate = new List<Opportunity>();
        List<sobject> oppsToupdate = new List<sobject>();
        //List<Lead> childLeadsToUpdate = new List<Lead>();
        List<sobject> childLeadsToUpdate = new List<sobject>();
        List<Lead> childLeadstoInsert = new List<Lead>();

        for(Lead ld : records)
        {


            if(ld.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c
                && ld.Most_Recent_Response__c != null
                && ld.i2i_Coupon_Code_Pass__c != null
                && (isinsert || ld.Most_Recent_Response__c != oldmap.get(ld.Id).Most_Recent_Response__c)
                && ld.i2i_id__c != null)
            {


                if(campaignMembersMapContact.containskey(ld.i2i_ID__c+'-'+ld.i2i_Coupon_Code_Pass__c))
                {
                    CampaignMember cmc = campaignMembersMapContact.get(ld.i2i_ID__c+'-'+ld.i2i_Coupon_Code_Pass__c);
                    string unkey = (string)cmc.contactid + ld.i2i_Coupon_Code_Pass__c;
                    if(cmc.contactid!=null && opportunityContacts.containskey(unkey))
                    {
                        OpportunityContactRole ocr = opportunityContacts.get(unkey);
                        Opportunity o = new Opportunity(Id=ocr.OpportunityId);

                        String responseSummary = (ocr.Opportunity.Response_Summary__c == null) ? '' : ocr.Opportunity.Response_Summary__c;
                        
                        if(ld.Most_Recent_Response__c != null && ocr.Opportunity.Most_Recent_Response__c != null && ocr.Opportunity.Most_Recent_Response_Date__c != null)
                        {
                            o.Response_Summary__c = ocr.Opportunity.Most_Recent_Response_Date__c.format() + ' ' +
                                ocr.Opportunity.Most_Recent_Response__c + '\r\n' + responseSummary;
                        }

                        //o.Most_Recent_Response__c = ld.Most_Recent_Response__c;
                        //o.Most_Recent_Response_Date__c = ld.Most_Recent_Response_Date__c;

                        sobject leadsobject = ld;
                        sobject oppsobject = o;

                        for(String s : passthroughOppFields)
                        {
                            string[] params = s.split('-');
                            if(leadsobject.get(params[0]) != null)
                            {
                                 oppsobject.put(params[1],leadsobject.get(params[0]));
                            }
                        }


                        //oppsToupdate.add(o);
                        oppstoupdate.add(oppsobject);
                        continue;
                    }
                }

                if(campaignMembersMapLead.containskey(ld.i2i_Id__c+'-'+ld.i2i_Coupon_Code_Pass__c))
                {
                    CampaignMember cm = campaignMembersMapLead.get(ld.i2i_Id__c+'-'+ld.i2i_Coupon_Code_Pass__c);
                    if(cm.leadid!=null && cm.lead.isconverted==false && cm.lead.status!='Disqualified' && i2iIds.contains(cm.lead.parent_lead__r.i2i_id__c))
                    { //have to do a recheck of the lead, since a campaign member could be attached to contact and lead.
                        
                        Lead l_update = new Lead(Id=cm.LeadId);
                        String responseSummary = (cm.Lead.Response_Summary__c==null) ? '' : cm.Lead.Response_Summary__c;
                        
                        if(ld.Most_Recent_Response__c != null && cm.Lead.Most_Recent_Response__c != null && cm.Lead.Most_Recent_Response_Date__c !=null)
                        {
                            l_update.Response_Summary__c = cm.Lead.Most_Recent_Response_Date__c.format() + ' ' +
                                        cm.Lead.Most_Recent_Response__c   + '\r\n' + responseSummary; 
                        }

                        //l_update.Most_Recent_Response__c = ld.Most_Recent_Response__c;
                        //l_update.Most_Recent_Response_Date__c = ld.Most_Recent_Response_Date__c;

                        //childLeadsToUpdate.add(l_update);

                        sobject ldsobject = ld;
                        sobject childlead = l_update;

                        for(String s : passthroughLeadFields)
                        {
                            string[] params = s.split('-');
                            if(ldsobject.get(params[0])!=null)
                            {
                                childlead.put(params[1],ldsobject.get(params[0]));
                            }
                        }

                        childLeadsToUpdate.add(childlead);
                        continue;
                    }
                    
                }


                //**Else create the lead, clone, etc.
                //Clone will pick up the most recent responses.
                
                Lead child_l = createChildLead(ld);
                
                child_l.RecordtypeId = childRecordTypesByProgram.containskey(programsbycouponcode.get(ld.i2i_coupon_code_pass__c)) ? childRecordTypesByProgram.get(programsbycouponcode.get(ld.i2i_coupon_code_pass__c))
                                                : gs.Default_Lead_Record_Type__c;

         
                if(campaignsbycouponcode.containskey(ld.i2i_coupon_code_pass__c))
                {
                    child_l.primary_campaign__c = campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).Id;
                    if(campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c !=null) child_l.campaign_program__c = campaignsbycouponcode.get(ld.i2i_coupon_code_pass__c).default_campaign_program__c;

                }
                else if(!(programsbycouponcode.containskey(ld.i2i_coupon_code_pass__c)))
                {
                    child_l.No_campaign__c=true;
                }
                

                if(ar!=null && integrationUser)
                {
                    child_l.setoptions(dmlo);
                }else
                {
                    child_l.OwnerId = UserInfo.getUserId();
                }

                childLeadstoInsert.add(child_l);
            }


        }

        if(!oppsToupdate.isEmpty()) update oppsToupdate;
        if(!childLeadsToUpdate.isEmpty()) update childLeadsToUpdate;

        Map<Id,CampaignMember> cmtoInsertByLeadId = new Map<Id,CampaignMember>();
        if(!childLeadstoInsert.isEmpty())
        {
            insert childLeadstoInsert;

            cmtoinsertbyleadid.putall(buildcampaignmemberbycouponcode(childLeadstoInsert,campaignsbycouponcode,existingLeadsOnCampaigns));
        } 

        if(cmtoInsertByLeadId.size()>0)
        {
            insert cmtoInsertByLeadId.values();
        }


    }

    public static Lead createChildLead(Lead parentLead)
    {
        Lead child = parentLead.clone(false,true,false,false);
        child.parent_lead__c = parentLead.id;
        child.i2i_id__c = '';
        child.Related_Account__c = null;
        child.Related_Contact__c = null;
        child.Jigsaw = null;
        child.Response_Summary__c = null;
        //child.Product_Interest__c = null;
        //child.description = null;

        return child;
    }


	
	public static void mergei2iParentDuplicates(List<Lead> records, map<id,Lead>oldmap)
    {
        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();
        boolean isinsert = (oldmap==null);
        
        Set<string> i2iIds = new Set<string>();
        //Set<string> emails = new Set<String>();
        //Set<string> i2iContactIds = new Set<String>();

        //Map<String,Lead> runningLeadstoCheck = new Map<String,Lead>();
        //Map<String,Set<Id>> leadsinloopByi2iID = new Map<String,Set<Id>>();
        
        for(Lead scope : records)
        {
            //system.debug('-- merge leadcheck: ' + scope.i2i_ID__c + ' ' + oldmap.get(scope.id).i2i_id__c);
            
            if(
            //!(parentsprocessedthroughMerge.contains(scope.Id))
            //&&
            scope.RecordTypeId == gs.Parent_Lead_Record_Type_Id__c 
            && 
            (scope.i2i_ID__c !=null && scope.i2i_ID__c != '0'
            && (isinsert || scope.i2i_ID__c != oldmap.get(scope.id).i2i_id__c))
            //||
            //(scope.email!=null && scope.Email!='none@none.com'
            //&& (isinsert || scope.email!=oldmap.get(scope.id).email))
            //||
            //(scope.i2i_Contact_ID__c!=null
            //&& (isInsert || scope.i2i_Contact_ID__c!= oldmap.get(scope.Id).i2i_Contact_ID__c))

            )
            {
                //parentsprocessedthroughMerge.add(scope.Id);
                
                if(scope.i2i_ID__c!=null && scope.i2i_ID__c!='0') i2iIds.add(scope.i2i_id__c);
                //if(scope.email!=null && scope.email != 'none@none.com') emails.add(scope.email);
                //if(scope.i2i_Contact_ID__c!=null && scope.i2i_Contact_ID__c!='0') i2iContactIds.add(scope.i2i_Contact_ID__c);
                
                //runningLeadstoCheck.put(scope.id+'-'+scope.i2i_ID__c,scope);
            }
        }
        
        system.debug('---- merge i2iids: ' + i2iids);
        //system.debug('---- merge emails: ' + emails);
        
        if(i2iIds.isempty()) return; //&& emails.isempty() && i2iContactIds.isEmpty()) return; 
        
        
        //if(!test.isRunningTest())
        //{
            //if(hasrun_i2imerges) return;
            //hasrun_i2imerges = true;
        //}
        
        
        Map<String,Map<Id,Lead>> leadsByi2iIds = new Map<String,Map<Id,Lead>>();
        Set<String> i2iIdsWithDups = new Set<String>();
        Map<String,Lead> i2iIdWinningLead = new Map<String,Lead>();
        
        
        //Map<String,Map<Id,Lead>> leadsbyemail = new Map<string,Map<Id,Lead>>();
        //set<string> emailswithdups = new Set<String>();
        //Map<String,Lead> emailWinningLead = new Map<String,Lead>();
        

        
        //Map<String,Map<Id,Lead>> leadsbyi2iContactId = new Map<string,Map<Id,Lead>>();
        //Set<string> i2iContactIdswithdups = new Set<String>();
        //Map<String,Lead> i2iContactIdWinningLead = new Map<String,Lead>();
        

        set <string> leadFields = new set <string>();
        string leadFieldString = 'id, i2i_id__c, email, createddate, i2i_Contact_ID__c';
        
        //custom setting that defines the fields to merge when source is not null and destination is null
        for(Merge_Record_Mapping__c m : Merge_Record_Mapping__c.getAll().values())
        {
            if(m.Object_Name__c.toLowerCase() == 'lead')
            {
                leadFields.add(m.API_Field_Name__c);
                leadFieldString += ', ' + m.API_Field_Name__c;
            }
        }
        
        string recId = gs.Parent_Lead_Record_Type_Id__c;
        string leadQuery = 'select ' + leadFieldString + ', (Select Id from Child_Leads__r where isConverted = false) ';
        //leadQuery += 'from lead where (i2i_id__c in :i2iIds OR email in :emails) and isConverted = false and RecordTypeId = :recId';
        //leadQuery += 'from lead where (i2i_id__c in :i2iIds OR i2i_Contact_ID__c in :i2iContactIds) and isConverted = false and RecordTypeId = :recId';
        leadQuery += 'from lead where i2i_id__c in :i2iIds and isConverted = false and RecordTypeId = :recId';
        
        system.debug('---- merge leadquery: ' + leadquery);
        
        for(Lead ld : database.query(leadQuery))
        {
            //compile i2i id structure
            
            if(leadsbyi2iIds.containskey(ld.i2i_id__c))
            {
                Map<Id,Lead> leads = leadsbyi2iids.get(ld.i2i_id__c);
                leads.put(ld.id,ld);
                leadsbyi2iids.put(ld.i2i_id__c,leads);
                
                i2iIdsWithDups.add(ld.i2i_id__c);

            }else if(ld.i2i_id__c !=null && ld.i2i_ID__c != '0')
            {
                Map<Id, Lead> leads = new Map<Id,Lead>();
                leads.put(ld.id, ld);
                leadsbyi2iids.put(ld.i2i_id__c,leads);
            }
            
            if(ld.i2i_id__c!=null 
            && ld.i2i_id__c!='0'
            && (!(i2iIdWinningLead.containskey(ld.i2i_id__c)) || (i2iIdWinningLead.get(ld.i2i_id__c).createddate < ld.createddate)))
            {
                i2iIdWinningLead.put(ld.i2i_id__c,ld);
            }

            //*********compile i2i Contact Id structure
            /*
            if(leadsbyi2iContactId.containskey(ld.i2i_Contact_ID__c))
            {
                Map<Id,Lead> leads = leadsbyi2iContactId.get(ld.i2i_Contact_ID__c);
                leads.put(ld.id,ld);
                leadsbyi2iContactId.put(ld.i2i_Contact_ID__c,leads);
                
                i2iContactIdswithdups.add(ld.i2i_Contact_ID__c);
            }else if(ld.i2i_Contact_ID__c!=null && ld.i2i_Contact_ID__c != '0')
            {
                map<id,lead> leads = new Map<id,Lead>();
                leads.put(ld.id,ld);
                leadsbyi2iContactId.put(ld.i2i_Contact_ID__c,leads);
            }
            
            if(ld.i2i_Contact_ID__c!=null 
            && ld.i2i_Contact_ID__c!='0'
            && (!(i2icontactidwinninglead.containskey(ld.i2i_Contact_ID__c)) 
                || (i2icontactidwinninglead.get(ld.i2i_Contact_ID__c).createddate < ld.createddate))
            )
            {
                i2icontactidwinninglead.put(ld.i2i_Contact_ID__c,ld);
            }
            */
            //**********************************************

            //compile email structure - deprecated
            /*
            if(leadsbyemail.containskey(ld.email))
            {
                Map<Id,Lead> leads = leadsbyemail.get(ld.email);
                leads.put(ld.id,ld);
                leadsbyemail.put(ld.email,leads);
                
                emailswithdups.add(ld.email);
            }else if(ld.email!=null && ld.email != 'none@none.com')
            {
                map<id,lead> leads = new Map<id,Lead>();
                leads.put(ld.id,ld);
                leadsbyemail.put(ld.email,leads);
            }
            
            if(ld.email!=null 
            && ld.email!='none@none.com'
            && (!(emailwinninglead.containskey(ld.email)) || (emailwinninglead.get(ld.email).createddate < ld.createddate)))
            {
                emailwinninglead.put(ld.email,ld);
            }
            */

        }
        
        //system.debug('---- merge leadsbyi2iids: ' + leadsbyi2iids);
        //system.debug('---- merge winninglead: ' + i2iidwinninglead);
        system.debug('---- merge i2iidswithdups: ' + i2iidswithdups);
        
        //system.debug('---- merge leadsbyemail: ' + leadsbyemail);
        //system.debug('---- merge emailwinninglead: ' + emailwinninglead);
        //system.debug('---- merge emailswithdups: ' + emailswithdups);
        
        if(leadsbyi2iids.isempty() || i2iIdswithdups.isempty()) return;
            //&& 
            /*(leadsbyemail.isempty() || emailswithdups.isempty())*/
            //(leadsbyi2iContactId.isempty() || i2iContactIdswithdups.isEmpty())
            //) return;
        
        List<Lead> leadstoupdate = new List<Lead>();
        Map<Id,Lead> parentleadstoupdate = new Map<Id,Lead>();
        //List<Lead> leadstodelete = new List<Lead>();
        Map<Id,Lead> leadstodelete = new Map<Id,Lead>();
        //Set<Id> leadsprocessed = new Set<Id>();
        
        //Process i2i IDs
        for(String i2i : i2iIdswithdups)
        {
            if(leadsByi2iIds.containskey(i2i) && i2iIdWinningLead.containskey(i2i))
            {
                Lead winningLead = i2iIdWinningLead.get(i2i);
                Boolean hasupdate = false;
                
                for(Lead l : leadsbyi2iIds.get(i2i).values())
                {
                    if(l.id!=winningLead.id)
                    {
                        //loop through children and set parent to the winning lead, add to list
                        for(lead childLead : l.Child_Leads__r)
                        {
                            Lead childL = new Lead(id=childlead.id,parent_lead__c=winninglead.Id);
                            leadstoupdate.add(childL);
                        }
                        
                        //process through additional parent lead checks
                        
                        for(String fieldname : leadfields)
                        {
                            if(winninglead.get(fieldname) == null && l.get(fieldname)!= null)
                            {
                                winninglead.put(fieldname,l.get(fieldname));
                                hasupdate = true;
                            }
                        }
                        
                        //add l to delete list
                        //leadstodelete.add(l);
                        leadstodelete.put(l.id,l);

                        DeletedRecordsStageClass.deletedRecordsReasons.put(l.Id,'Parent Lead Duplicate i2i Id');

                        //leadsprocessed.add(l.id);
                    }
                }
                
                if(hasupdate) parentleadstoupdate.put(winninglead.id,winninglead);
                //leadsprocessed.add(winninglead.id);
            }
        }


        //Process i2i contact matching
        /*
        for(String i2icontact : i2iContactIdswithdups)
        {
            if(leadsbyi2iContactId.containskey(i2icontact) && i2iContactIdWinningLead.containskey(i2icontact))
            {
                Lead winningLead = (parentleadstoupdate.containskey(i2icontactidwinninglead.get(i2icontact).Id)) ? parentleadstoupdate.get(i2icontactidwinninglead.get(i2icontact).Id) : i2icontactidwinninglead.get(i2icontact);
                if(leadstodelete.containskey(winninglead.id)) continue;
                boolean hasupdate = false;
                
                for(lead l : leadsbyi2icontactid.get(i2icontact).values())
                {
                    if(l.id!=winninglead.id && !(leadstodelete.containskey(l.id)))
                    {
                        for( lead childlead : l.child_leads__r)
                        {
                            Lead childL = new Lead(id=childlead.id, parent_lead__c=winninglead.id);
                            leadstoupdate.add(childl);
                        }
                        for(string fieldname : leadfields)
                        {
                            if(winninglead.get(fieldname)==null && l.get(fieldname)!=null)
                            {
                                winninglead.put(fieldname,l.get(fieldname));
                                hasupdate = true;
                            }
                        }
                        
                        leadstodelete.put(l.id,l);
                        
                    }
                }
                
                
                if(hasupdate) parentleadstoupdate.put(winninglead.id,winninglead);
            }
        }
        */
        /*    Email matching deprecated
        for(string em : emailswithdups)
        {
            if(leadsbyemail.containskey(em) && emailwinninglead.containskey(em))
            {
                Lead winningLead = (parentleadstoupdate.containskey(emailwinninglead.get(em).Id)) ? parentleadstoupdate.get(emailwinninglead.get(em).Id) : emailwinninglead.get(em);
                if(leadstodelete.containskey(winninglead.id)) continue;
                boolean hasupdate = false;
                
                for(lead l : leadsbyemail.get(em).values())
                {
                    if(l.id!=winninglead.id && !(leadstodelete.containskey(l.id)))
                    {
                        for( lead childlead : l.child_leads__r)
                        {
                            Lead childL = new Lead(id=childlead.id, parent_lead__c=winninglead.id);
                            leadstoupdate.add(childl);
                        }
                        for(string fieldname : leadfields)
                        {
                            if(winninglead.get(fieldname)==null && l.get(fieldname)!=null)
                            {
                                winninglead.put(fieldname,l.get(fieldname));
                                hasupdate = true;
                            }
                        }
                        
                        leadstodelete.put(l.id,l);
                        
                    }
                }
                
                
                if(hasupdate) parentleadstoupdate.put(winninglead.id,winninglead);

            }
        }
        */
        
        system.debug('---- merge leadstoupdate: ' + leadstoupdate);
        system.debug('---- merge leadtodelete: ' + leadstodelete);
        system.debug('---- merge parentleadstoupdate: ' + parentleadstoupdate);
        
        if(leadstoupdate.size()>0) update leadstoupdate;
        if(leadstodelete.size()>0) delete leadstodelete.values();
        if(parentleadstoupdate.size()>0) update parentleadstoupdate.values();
        
    }

    //turned back on (Phillip - 12/17/2013)
    public static void leadReparented (List <Lead> leads, map <id, Lead> oldMap)
    {
        system.debug('-* leadreparented start: ' + system.now());
        //system.debug('---------------------leadReparented start');
        
        set <id> parentLeadIds = new set <id>();
        
        for(Lead l : leads)
        {
            
            system.debug('-----Parent ' + l.parent_lead__c + ' Old Parent ' + oldMap.get(l.id).parent_lead__c);
        
            
            if(l.parent_lead__c != oldMap.get(l.id).parent_lead__c)
            {
                if(l.parent_lead__c != null)
                {
                    parentLeadIds.add(l.parent_lead__c);
                    system.debug('---reevaluate lead: ' + l.parent_lead__c);        
                }
                if(oldMap.get(l.id).parent_lead__c != null)
                {
                    parentLeadIds.add(oldMap.get(l.id).parent_lead__c);
                    system.debug('---reevaluate lead: ' + oldMap.get(l.id).parent_lead__c);
                }
            }
        }
        
        if(parentLeadIds.size() > 0)
        {
            //** turning off due to locking error 02/26/14
            //may need to push this to batch
            
            //UCampaignMember.reevaluateAssociations(parentLeadIds);
        }
        
        system.debug('-* leadrepartend end: ' + system.now());
        
    }

    
    public static void communityUserStampData(List<lead> records)
    {   //currently only for before insert of leads

        String userId = UserInfo.getUserId();
        List<User> userRecord = [Select id, UserType, ContactId, AccountId, Profile.UserLicense.Name from User where id=:userId LIMIT 1];
            
        //if (userRecord.size() == 0 || userRecord == null || !UGears.UUser.ispartnerportaluser(userRecord[0])) return;
        if (userRecord.size() == 0 || userRecord == null || !UGears.UUser.isPartnerCommunityUser(userRecord[0])) return;

        //if(!UGears.UUser.ispartnerportaluser((Id)UserInfo.getUserId())) return;

        //Id uId = UserInfo.getUserId();
        //User u = [Select Id, ContactId, AccountId from User where Id = :uId];
        User u = userRecord[0];

        if(u.ContactId == null || u.AccountId == null) return;

        for(Lead l : records)
        {
            l.External_Referred_By__c = u.AccountId;
            l.Referred_by_External_Account__c = u.AccountId;
            l.EReferred_By__c = u.ContactId;
            l.Referred_by_External__c = u.ContactId;
        }
        

    }
    
}