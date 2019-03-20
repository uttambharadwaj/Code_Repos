/*
    Created by: Phillip Southern (GearsCRM)
    Description: controller for i2isearchpage, searching i2i api and
    providing functionality.
    
    Modified by: Phillip Southern (GearsCRM)
    Description: request for code to run in system mode
    Date: 04/02/14

    Modified by: Phillip Southern (GearsCRM)
    Description: email added to searching
    Date: 09/25/14

*/

//public with sharing class i2iSearchController {
public class i2iSearchController {
    
    public String page {get; set;}
    public double mSecondsToExecute {get;set;}
    public double totalmSecondsToExecute{get;set;}
    
    public String programSelected{get;set;}
    public List<SelectOption> programValues {
        get
        {
            if(programValues==null)
            {

                Map<String,String> programNames = new Map<String,String>();
                programValues = new List<SelectOption>();
                programValues.add(new SelectOption('-None-','-None-'));
                for(Program__c pg : [Select Name from Program__c Order BY Name ASC])
                {
                    if(!programNames.containskey(pg.Name))
                    {
                        programNames.put(pg.Name,pg.Name);
                        programValues.add(new SelectOption(pg.Name,pg.Name));                       
                    }
                }
                
            }
            return programValues;
        }
        set;
    }

    public String phoneNumber{get;set;}
    public String promocode{get;set;}
    public String company{get;set;}
    public String zipcode{get;set;}
    public String email{get;set;}

    public boolean searchbyphone{get;set;}
    public String parentRedirectURL{get;set;}
    public boolean redirectParent{get;set;}
    public List<LeadWrapper> leadwrappers{get;set;}
    public List<ContactWrapper> contactwrappers{get;set;}
    public List<NoMatchi2i> nomatchrecordwrappers{get;set;}
    public string phonebuttoncolor{get;set;}
    public string companybuttoncolor{get;set;}
    
    private Map<String,String> programNamesbyCouponcode {get;set;}
    //public string testingvalue{get;set;}
    
    public string iframeurl{get;set;}
    public boolean iframeurlhit{get;set;}
    
    public i2iSearchController()
    {
        initPage();
    }
    
    public void initPage() 
    {
        system.debug('-----initPage() ' + system.now());
            
        PageReference currentPage = ApexPages.currentPage();    
        
        iframeurl='';
        iframeurlhit=false;
        
        if(currentPage.getParameters().get('leftnav')=='true')
        {
            this.company = currentPage.getParameters().get('company');
            this.phoneNumber = currentPage.getParameters().get('phonenumber');
            //**Have to make sure promo code is required.
            this.promocode = currentPage.getParameters().get('promocode');
            this.programSelected = currentpage.getParameters().get('program');
            this.zipcode = currentpage.getParameters().get('zipcode');
            this.email = currentpage.getParameters().get('email');
            
            searchi2i();
        }
    }
    public void clearForm()
    {
        programSelected='-None-';
        phoneNumber = '';
        promocode = '';
        company = '';
        zipcode = '';
        email = '';
        
        msecondstoexecute = 0;
        totalmsecondstoexecute = 0;
        
        leadWrappers = new List<LeadWrapper>();
        contactWrappers = new List<ContactWrapper>();
        nomatchrecordwrappers = new List<NoMatchi2i>();
        programnamesbycouponcode = new Map<string,string>();
    }
    public void initLeftNavPage()
    {
        searchbyphone=true;
        redirectParent=false;
        phonebuttoncolor = '#b5b5b5'; //selected gray
        companybuttoncolor='#e8e8e9'; //Default gray
    }
    
    public List<i2iGet.returnData> records {get;set;}
    
    public void searchi2i()
    {
        DateTime totalexecutionstart = system.now();
        
        leadWrappers = new List<LeadWrapper>();
        contactWrappers = new List<ContactWrapper>();
        nomatchrecordwrappers = new List<NoMatchi2i>();
        programnamesbycouponcode = new Map<string,string>();
        
        List<String> searchVars = new List<String>();
        
        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();

        //need prefix of leads and opps
        //iframeurl='https://cs1.salesforce.com/_ui/search/ui/UnifiedSearchResults?sen=00Q&sen=006&str=';
        iframeurl=gs.productionInstance__c+'/_ui/search/ui/UnifiedSearchResults?sen=00Q&sen=006&str=';
        iframeurlhit=false;
        
        try
        {

        
        /*
        if(promocode != null && promocode != '')
        {
            if(promocode.length() != 11 && promocode.length() != 13 && promocode.length() != 12)
            {
                
            }else
            {
                string temp1;
                string temp2;
                //string temp1 = (promocode.length()==11) ? promocode.substring(0,3) : promocode.substring(0,5);
                //string temp2 = (promocode.length()==11) ? promocode.substring(3) : promocode.substring(5);
                if(promocode.length()==11)
                {
                    temp1 = promocode.substring(0,3);
                    temp2 = promocode.substring(3);
                }
                else if(promocode.length()==12)
                {
                    temp1 = promocode.substring(0,4);
                    temp2 = promocode.substring(4);
                }
                else if(promocode.length()==13)
                {
                    temp1 = promocode.substring(0,5);
                    temp2 = promocode.substring(5);
                }
                
                
                promocode = temp1 + '-' + temp2;
            }
        }
        */
        
        string phonepass = (phoneNumber!=null && phoneNumber!='') ? phoneNumber.replaceall('\\D','') : '';

        if(phonepass!=null && phonepass!='')
        {
            if(phonepass.length()!=10 && phonepass.length()!=11
            ||(phonepass.length()==10 && (phonepass.substring(0,1)=='1' || phonepass.substring(0,1)=='0')))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'If searching by Phone, you must include a total of 10 or 11 digits.'));
                return;
            }else
            {
                //strip 1 if present
                if(phonepass.substring(0,1)=='1' || phonepass.substring(0,1)=='0') 
                {
                    string str = phonepass.substring(1);
                    phonepass = str;
                }

                string temp1 = phonepass.substring(0,3);
                string temp2 = phonepass.substring(3,6);
                string temp3 = phonepass.substring(6,10);
                
                phonepass = temp1+'-'+temp2+'-'+temp3;
                
                phoneNumber = phonepass;

            }
            
            searchvars.add(phonenumber);
        }
        
        if(company!=null && company!='') //&& !(company.endswith('*')))
        {
            if(!(company.endswith('*'))) company += '*';
            searchvars.add(company);
        }
        
        if(zipcode!=null && zipcode!='') searchvars.add(zipcode);

        if(email != null && email !='') searchvars.add(email);
        

        for(string s : searchvars)
        {
            if(iframeurlhit) iframeurl+=' ';
            iframeurl+=s;
            iframeurlhit=true;
        }
        
        records = new List<i2iGet.returnData>();
        DateTime startTime = system.now();
        if(programSelected=='-None-') programSelected = null;
        try
        {
            //records = i2iGet.executeCall (promocode,programSelected,phoneNumber,company,zipcode);
            records = i2iGet.executeCall (promocode,programSelected,phonepass,company,zipcode,email);
            
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            system.debug('....exception: ' + e.getmessage());
        }
            
        DateTime endTime = system.now();
        mSecondsToExecute = i2iGet.GetDifferenceInMilliSeconds(starttime, endtime);
        
        //customaddMessage('records size: ' + records.size().format());
        
        //if i2i has no results do a search into SF only
        if(records.size()==0 || records[0].returnDescription != 'Success')
        {
            system.debug('....no records');
            if(records.size()==0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No results from i2i.'));
                return; 
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error from i2i: ' + records[0].returnDescription));
            
            
        }else
        {
            
            //Single ids to pull campaign members...then scroll through return checking to see if match in campaign member match
            //then loop through data if hit in map, check prefix to see if its lead or campaign, add the wrappers
            
            Set<String> i2iIds = new Set<String>();
            Set<String> couponCodesReturned = new Set<String>();
            for(i2iget.returnData rd : records)
            {
                if(rd.i2iId!=null) i2iIds.add(rd.i2iId);
                if(rd.couponcode!=null) couponCodesReturned.add(rd.CouponCode);
            }
            
            Set<Id> whoIds = new Set<Id>();
            
            system.debug('---- i2iIds: ' + i2iids);
            system.debug('---- couponcodes: ' + couponcodesreturned);
            
            Date ninetydays = system.now().date().adddays(-90);

            //** This map may need to be by contactid and coupon code...it may be possible for a contact to be
            //on many opp/campaigns and coupon codes.
            //Map<Id,OpportunityContactRole> opportunityContacts = new Map<Id,OpportunityContactRole>();
            Map<String,OpportunityContactRole> opportunityContacts = new Map<String,OpportunityContactRole>();
            Set<Id> opportunityContactsContactIds = new Set<Id>();
            for(OpportunityContactRole ocr : [Select Id, ContactId, opportunityid, opportunity.coupon_code2__c, opportunity.StageName, opportunity.Product_Interest__c,
                                                Opportunity.CampaignId, Opportunity.Campaign.Coupon_Code__c
                                                from opportunitycontactrole 
                                                Where 
                                                //Opportunity.Coupon_Code2__c IN :couponCodesReturned 
                                                Opportunity.Campaign.Coupon_Code__c IN :couponCodesReturned
                                                AND Contact.i2i_ID__c IN :i2iIds
                                                //AND Opportunity.IsClosed=false
                                                AND Opportunity.CreatedDate >= :ninetydays
                                                ])
            {
                //opportunityContacts.put(ocr.contactid,ocr);
                string unqkey = (string)ocr.contactid + ocr.Opportunity.Campaign.Coupon_code__c; //ocr.opportunity.coupon_code2__c;
                opportunityContacts.put(unqkey,ocr);     
                opportunityContactsContactIds.add(ocr.contactid);   
                
                //whoIds.add(ocr.contactid);        
            }
            
            system.debug('--ocr: ' + opportunitycontacts);

            Map<String, CampaignMember> campaignMembersMapLead = new Map<String, CampaignMember>();
            Map<String, CampaignMember> campaignMembersMapContact = new Map<String, CampaignMember>();
            
            List<CampaignMember> campaignMembersLead = new List<CampaignMember>();
            //List<CampaignMember> campaignMembersContact = new List<CampaignMember>();
            
            for(CampaignMember cm : [Select leadid, contactid, lead.Status, lead.Product_Interest__c, lead.owner.name, contact.i2i_ID__c, lead.IsConverted,
                                    contact.owner.name, campaignid, campaign.Coupon_Code__c, campaign.Name, campaign.Marketing_Offer__c, lead.coupon_code_2__c,
                                    lead.parent_lead__c, lead.parent_lead__r.i2i_id__c, lead.createddate, campaign.default_program__r.name
                                    from CampaignMember 
                                    where campaign.Coupon_Code__c IN :couponCodesReturned 
                                    AND ((lead.IsConverted = false AND lead.Status!='Disqualified') OR contactId IN :opportunityContactsContactIds)
                                    AND (lead.parent_lead__r.i2i_id__c IN :i2iIds or Contact.i2i_id__c IN :i2iIDs)
                                    Order By CreatedDate ASC])
            {
                
                if(cm.contactId != null) 
                {
                    //campaignMembersMapContact.put(cm.contact.i2i_Id__c,cm);
                    campaignMembersMapContact.put(cm.contact.i2i_id__c+'-'+cm.campaign.coupon_code__c,cm);
                    whoIds.add(cm.contactid);   
                }
                
                if(cm.leadId != null) 
                {
                    //campaignMembersMapLead.put(cm.lead.parent_lead__r.i2i_Id__c,cm);
                    
                    campaignMembersLead.add(cm);
                    whoIds.add(cm.leadid);
                }
                
                programnamesbycouponcode.put(cm.campaign.coupon_code__c,cm.campaign.default_program__r.name);
                system.debug('-- cm: ' + cm);
            }
            
            //get the rest of the program names for non matches displaying
            for(Campaign c : [Select Id, Coupon_code__c, Default_Program__r.Name
                                from Campaign 
                                Where coupon_code__c IN :couponcodesreturned
                                AND coupon_code__c NOT IN :programnamesbycouponcode.keyset()])
            {
                programnamesbycouponcode.put(c.coupon_code__c,c.default_program__r.name);
            }


            Set<Id> salesProfileIDs = new Set<Id>();
            for(Sales_Activity_by_Profile__c spro : Sales_Activity_by_Profile__c.getall().values())
            {
                if(spro.ProfileID__c != null)
                {
                    try
                    {
                        salesProfileIds.add((Id)spro.profileid__c);
                    }catch(Exception e)
                    {   
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error pulling Sales Profiles from custom setting: ' + e.getMessage() + ' ' + e.getStackTraceString()));
                        
                        return;
                    }
                }
            }
            system.debug('---- profiles to check: ' + salesprofileids);
            
            Set<Id> activities90days = new Set<Id>();
            //Date ninetydays = system.now().date().adddays(-90);
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
            
            Integer recordcount = 0;
            Set<string> recordallocated = new set<string>();
            for(i2iget.returndata r : records)
            {
                
                system.debug('---- r: ' + r);
                
                if(campaignMembersMapLead.containskey(r.i2iId+'-'+r.couponcode))
                {
                    CampaignMember cm = campaignMembersMapLead.get(r.i2iId+'-'+r.couponcode);
                    if(cm.leadid!=null && cm.lead.isconverted==false && cm.lead.status!='Disqualified' && i2iIds.contains(cm.lead.parent_lead__r.i2i_id__c)) // && activities90days.contains(cm.leadid))
                    { //have to do a recheck of the lead, since a campaign member could be attached to contact and lead.
                        
                        leadwrappers.add(new LeadWrapper(cm,r,this));
                        recordallocated.add(r.i2iid+'-'+r.couponcode);
                    }
                    
                }
                if(campaignMembersMapContact.containskey(r.i2iId+'-'+r.couponcode))
                {
                    CampaignMember cmc = campaignMembersMapContact.get(r.i2iId+'-'+r.couponcode);
                    string unkey = (string)cmc.contactid + r.couponcode;
                    if(cmc.contactid!=null && opportunityContacts.containskey(unkey))// && activities90days.contains(cmc.contactid))//cmc.contactid))  //added check for key, just in case.
                    {
                        OpportunityContactRole ocr = opportunityContacts.get(unkey); //cmc.contactid);
                        contactwrappers.add(new ContactWrapper(cmc,r,ocr,this));
                        recordallocated.add(r.i2iid+'-'+r.couponcode);
                    }
                }
                if(!recordallocated.contains(r.i2iId+'-'+r.couponcode))//(!campaignMembersMapContact.containskey(r.i2iId) && !campaignMembersMapLead.containskey(r.i2iId)))
                {
                    nomatchrecordwrappers.add(new NoMatchi2i(r,this));
                    recordallocated.add(r.i2iid+'-'+r.couponcode);
                }
                
                //v1
                /*if(leadmap.containskey(r.sfdcchildleadid))
                {
                    //LeadWrapper lw = 
                    leadwrappers.add(new LeadWrapper(leadmap.get(r.sfdcchildleadid),r));
                    
                }else if(contactmap.containskey(r.sfdccontactid))
                {
                    //contactwrappers.add(new ContactWrapper(contactmap.get(r.sfdccontactid)));
                }else
                {
                    //no match
                    nomatchrecordwrappers.add(new NoMatchi2i(r));
                }*/
                //v1
                
                
                
                recordcount++;
                if(recordcount>19)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'More than 20 record returned. First 20 are shown.'));
                    //break;
                }
            }
        }
        
            
            }catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
            }
            DateTime totalexecutionend = system.now();
            this.totalmSecondsToExecute = i2iget.getDifferenceInMilliSeconds(totalexecutionstart, totalexecutionend);
    }
    public pagereference searchi2iLeftNav()
    {
        //** need to redirect parent
        PageReference pageref = new PageReference('/apex/i2iSearchPage');
        //pageref.getParameters().put('target','_parent');
        //**put parameters to pass to main search page.
        pageref.getParameters().put('company',this.company);
        pageref.getParameters().put('phonenumber',this.phoneNumber);
        pageref.getParameters().put('promocode',this.promocode);
        pageref.getParameters().put('zipcode',this.zipcode);
        pageref.getParameters().put('email',this.email);
        //pageref.getParameters().put('program',this.programSelected);
        pageref.getParameters().put('leftnav','true');
        
        //return pageref;
        
        redirectParent=true;
        parentRedirectURL = pageref.getUrl(); //'/apex/i2iSearchPage';
        return null;
        
    }
    public void customaddMessage(string msg)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msg));
    }
    public void findbyPhone()
    {
        searchbyphone=true;
        phonebuttoncolor = '#b5b5b5'; //selected gray
        companybuttoncolor='#e8e8e9'; //Default gray
    }
    public void findbyBusiness()
    {
        searchbyphone=false;
        phonebuttoncolor = '#e8e8e9'; //default gray
        companybuttoncolor='#b5b5b5'; //selected gray
    }
    

    //public with sharing class LeadWrapper
    public class LeadWrapper
    {
        public CampaignMember campaignmemberrecord{get;set;}
        public i2iget.returnData returndatarecord{get;set;}
        public string completeownername{get;set;}
        private string leadid{get;set;}
        public string programname{get;set;}
        private Lead l {get;set;}
        
        public LeadWrapper(CampaignMember c, i2iget.returnData rd, i2iSearchController i2icon)
        {
            campaignmemberrecord = c;
            returndatarecord = rd;
            leadid = c.leadid;
            
            programname = (i2icon.programnamesbycouponcode.containskey(rd.couponcode)) ? i2icon.programnamesbycouponcode.get(rd.couponcode) : '';
            
        }

        public pagereference openlead()
        {
            return new PageReference('/'+leadid);
        }
        public pagereference convertlead()
        {
            
            l = [Select Id, IsConverted, ConvertedOpportunityId, Parent_Lead__c,
                Parent_Lead__r.Related_Contact__c, RecordTypeId, Parent_Lead__r.i2i_id__c,
                Parent_Lead__r.Related_Contact__r.AccountId
                from Lead Where Id = :leadid];  /*Parent_lead__r.Related_Account__c,*/

            
            /*Set<Id> leadQueues = new Set<Id>();
            for(QueueSobject qso : [Select QueueId from QueueSobject 
                                        Where QueueId != null
                                        AND SobjectType = 'Lead'])
            {
                leadQueues.add(qso.QueueId);
            }*/
            
            if(l.isconverted)
            {
                PageReference pageRef = new PageReference('/'+l.ConvertedOpportunityId+'/e?retURL=/'+l.ConvertedOpportunityId);
                pageref.setredirect(true);
                return pageref;
            }else
            {
                /*if(leadQueues.contains(l.ownerid)){
                     
                }*/
                
                //**new calling describer to get correct converted status for recordtype
                List<String> statusValuesList =  new List<String>();
                if(test.isRunningTest())
                {
                    statusValuesList.add('Qualified');
                }else
                {
                    statusValuesList = picklistDescriber.describe('Lead',l.RecordTypeId,'Status');
                }
                
                List<leadstatus> cnvtStatus = [select Id, MasterLabel from LeadStatus where IsConverted = True AND MasterLabel IN :statusValuesList order by SortOrder ASC limit 1];
                if(cnvtStatus.size()==0)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: No converted status found for this recordtype.  Please contact Administrator.'));
                    return null;
                }

                String convertStatus = cnvtStatus[0].masterlabel;
                //convert lead
                //String convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1].MasterLabel;

                Database.Leadconvert lc = new Database.Leadconvert();
                lc.setLeadId(l.Id);
                lc.setConvertedStatus(convertStatus);
                lc.setownerid(UserInfo.getUserId());
                /*
                if(l.Parent_Lead__r.Related_Account__c!=null)
                {
                    lc.setaccountid(l.Parent_Lead__r.related_account__c);
                    if(l.Parent_Lead__r.Related_Contact__c!=null) lc.setcontactid(l.Parent_Lead__r.related_contact__c);
                }
                */
                if(l.Parent_Lead__r.Related_Contact__c != null && l.Parent_Lead__r.Related_Contact__r.AccountId!=null)
                {
                    lc.setaccountid(l.Parent_Lead__r.Related_Contact__r.AccountId);
                    lc.setContactId(l.Parent_Lead__r.Related_Contact__c);
                }
                
                
                try
                {
                    Database.Leadconvertresult lcr = database.convertlead(lc);
                    
                    //system.debug('-- lcr: ' + lcr);
                    system.debug('-- geterrors: ' + lcr.geterrors());
                    //system.debug('-- success: ' + lcr.success + ' ' + lcr.issuccess());
                    
                    
                    if(!(lcr.success))
                    {
                        string errorstr = '';
                        for(database.Error e : lcr.errors)
                        {
                            errorstr+=e.message;
                        }
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: ' + errorstr));
                        return null;
                    }
                    
                    updateContactRecord(lcr);
                    
                    PageReference pageRef = new PageReference('/'+lcr.opportunityid+'/e?retURL=/'+lcr.opportunityid);
                    pageref.setredirect(true);
                    return pageref;
                    
                }catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
                    
                }
                
            }
            
            return null;
        }
        private void updateContactRecord(Database.LeadConvertResult lcr)
        {
            //boolean success = true;
            
            Contact c = new Contact(id=lcr.getContactId());
            c.i2i_ID__c = l.Parent_Lead__r.i2i_id__c;
            
            
            try
            {
                //UGears.UDebug.printDebug('Contact Record Before Update: ' + c);
                
                update c;
            }catch(DmlException e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));
                
                System.debug('EXCEPTION: ' + e);
                
                return; // false;
            }
            
            //return success;
        }
    }
    //public with sharing class ContactWrapper
    public class ContactWrapper
    {

        string contacturl{get;set;}
        string opportunityurl{get;set;}
        public CampaignMember campaignmemberrecord{get;set;}
        public OpportunityContactRole opportunitycontactrecord{get;set;}
        public i2iget.returnData returndatarecord{get;set;}
        public string programname{get;set;}

        public ContactWrapper(CampaignMember c, i2iget.returnData rd, OpportunityContactRole ocr, i2iSearchController i2icon)
        {
            contacturl='/' + c.contactId;
            opportunityurl='/' + ocr.opportunityid;
            campaignmemberrecord = c;
            returndatarecord = rd;
            opportunitycontactrecord = ocr;
            
            programname = programname = (i2icon.programnamesbycouponcode.containskey(rd.couponcode)) ? i2icon.programnamesbycouponcode.get(rd.couponcode) : '';
        }
        
        public pagereference opencontact()
        {
            return new pagereference(contacturl);
        }
        
        public pagereference openopportunity()
        {
            return new pagereference(opportunityurl);
        }
    }

    //public with sharing class NoMatchi2i
    public class NoMatchi2i
    {
        public i2iget.returndata nomatchi2irecord{get;set;}
        public string programname{get;set;}
        //private string leadID{get;set;}
        private boolean createError{get;set;}
        private List<Lead> childLead {get;set;}
       
        public NoMatchi2i(i2iget.returndata i2idata, i2iSearchController i2icon)
        {
            nomatchi2irecord = i2idata;
            programname = (i2icon.programnamesbycouponcode.containskey(i2idata.couponcode)) ? i2icon.programnamesbycouponcode.get(i2idata.couponcode) : '';
            createError=false;
            
            system.debug('-- i2idata: ' + i2idata);
        }
        public pagereference createLeadRedirect()
        {
            createError=false;
            
            createLead();
            
            if(createError) return null;
            
            if(childLead==null || childLead.size()==0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Lead not found from Parent created/updated.'));
                return null;
            }  
            
            //Pagereference pageref = new PageReference('/'+leadid+'/e?retURL=/'+leadid);
            Pagereference pageref = new PageReference('/'+childLead[0].Id+'/e?retURL=/'+childLead[0].Id);
            pageref.setredirect(true);
            return pageref;
            
        }
        
        /* Updated by Trekbin to split the DML and Callout into different transactions, as per case requirement : 00022611
        called from "Create Opportunity" button and performs DML, oncomplete  trigger click event on "convertChildLead" button(hidden) just to call convertChildLead method 
        where Callout(getContent) takes place */
        
        public pagereference convertLead()
        {
            createError=false;
            createLead();
            if(createerror) return null;
            else
                return null;
            
            /*
            Lead l = [Select Id, IsConverted, ConvertedOpportunityId, Related_Account__c, Related_Contact__c,
                        Parent_Lead__c, Parent_Lead__r.Related_Account__c, Parent_Lead__r.Related_Contact__c
                        from Lead 
                        Where Parent_Lead__c = :leadid 
                        AND i2i_coupon_code_pass__c = :nomatchi2irecord.couponcode 
                        Order by CreatedDate DESC LIMIT 1];
                        
            system.debug('--i2isearch convertlead lead: ' + l);
            
            if(l==null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Lead not found from Parent created/updated.'));
                return null;
            }
            */
        }
        
        private void updateContactRecord(Database.LeadConvertResult lcr)
        {
            //boolean success = true;
            
            Contact c = new Contact(id=lcr.getContactId());
            c.i2i_ID__c = childLead[0].Parent_Lead__r.i2i_id__c;
            
            try
            {
                //UGears.UDebug.printDebug('Contact Record Before Update: ' + c);
                
                update c;
            }catch(DmlException e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));
                
                System.debug('EXCEPTION: ' + e);
                
                return; // false;
            }
            
            //return success;
        }
        
        public void createLead()
        {
            GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
            
            Lead newLead = new Lead();
            newLead.FirstName = nomatchi2irecord.firstname;
            newLead.LastName = nomatchi2irecord.lastname;
            newLead.Company = nomatchi2irecord.company;
            newLead.City = nomatchi2irecord.city;
            newLead.State = nomatchi2irecord.state;
            newLead.Street = nomatchi2irecord.address;
            newLead.PostalCode = nomatchi2irecord.zip;
            newlead.status = 'Working';
            //newlead.ownerid = UserInfo.getUserId();
            newlead.recordtypeid = setting.Parent_Lead_Record_Type_Id__c;
            newlead.i2i_id__c = nomatchi2irecord.i2iId;
            newlead.i2i_coupon_code_pass__c = nomatchi2irecord.couponcode;
            newlead.ownerid = setting.Parent_Lead_Queue__c;
            newLead.Phone = nomatchi2irecord.phone;
            newLead.Country = nomatchi2irecord.country;
            newLead.i2i_Contact_ID__c = nomatchi2irecord.i2icontactid;
            newLead.Email = nomatchi2irecord.Email;
            
            //product interest
            
            //Database.Dmloptions dmlo = new Database.Dmloptions();
            //AssignmentRule ar = new AssignmentRule();
            //ar = [Select Id from AssignmentRule Where SobjectType = 'Lead' and Active = true LIMIT 1];
            //if(ar!=null)
            //{
                //dmlo.assignmentRuleHeader.assignmentRuleId=ar.Id;
                //newlead.setoptions(dmlo);
            //}
            
            try
            {
                //insert newlead;
                upsert newlead i2i_id__c;
                //leadid = newlead.id;
            }catch (Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
                createError=true;
                return;
            }
            
             
            childLead = new List<Lead>();
            childLead = [Select Id, IsConverted, ConvertedOpportunityId, Related_Account__c, Related_Contact__c,
                        Parent_Lead__c, Parent_Lead__r.Related_Account__c, Parent_Lead__r.Related_Contact__c, Parent_Lead__r.i2i_Id__c
                        from Lead 
                        Where Parent_Lead__c = :newlead.Id 
                        AND RecordTypeId != :setting.Parent_Lead_Record_Type_Id__c
                        //AND i2i_coupon_code_pass__c = :nomatchi2irecord.couponcode 
                        AND Id IN (Select LeadId from CampaignMember where Campaign.Coupon_Code__c = :nomatchi2irecord.couponcode)
                        Order by CreatedDate DESC LIMIT 1];
            
           system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! childLead  ' + childLead );
                        
        }
        
         /* Updated by Trekbin to split the DML and Callout into different transactions, as per case requirement : 00022611 
         called from "convertChildLead" button just to execute DML and callout in differenent trasctions to avoid
          System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out*/
          
         public pagereference convertChildLead() {
                
            
             if(childLead==null || childLead.isEmpty())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Lead not found from Parent created/updated.'));
                return null;
            }
            
           
             if(childLead[0].isconverted) {
                
                PageReference pageRef = new PageReference('/'+childLead[0].ConvertedOpportunityId+'/e?retURL=/'+childLead[0].ConvertedOpportunityId);
                pageref.setredirect(true);
                return pageref;
            }else {
                //**new calling describer to get correct converted status for recordtype
                List<String> statusValuesList =  new List<String>();
                
                if(test.isRunningTest()) {
                    
                    statusValuesList.add('Qualified');
                }else {
                    
                    statusValuesList = picklistDescriber.describe('Lead',childlead[0].RecordTypeId,'Status');
                }
                
                List<leadstatus> cnvtStatus = [select Id, MasterLabel from LeadStatus where IsConverted = True AND MasterLabel IN :statusValuesList order by SortOrder ASC limit 1];
                if(cnvtStatus.size()==0) {
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: No converted status found for this recordtype.  Please contact Administrator.'));
                    return null;
                }
    
                String convertStatus = cnvtStatus[0].masterlabel;
                //convert lead
                //String convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1].MasterLabel;
                
                Database.Leadconvert lc = new Database.Leadconvert();
                lc.setLeadId(childLead[0].Id);
                lc.setownerid(UserInfo.getUserId());
                lc.setConvertedStatus(convertStatus);
                if(childLead[0].Parent_Lead__r.Related_Account__c!=null) {
                    
                    lc.setaccountid(childLead[0].Parent_Lead__r.Related_Account__c);
                    if(childLead[0].Parent_Lead__r.Related_Contact__c!=null) lc.setContactId(childLead[0].Parent_Lead__r.Related_Contact__c);
                }
                
                try {
                    
                    Database.LeadconvertResult lcr = database.convertlead(lc);
                    if(!(lcr.success)) {
                        
                        string errorstr = '';
                        for(database.Error e : lcr.errors)
                        {
                            errorstr+=e.message;
                        }
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: ' + errorstr));
                        return null;
                    }
                    
                    updateContactRecord(lcr);
                    
                    PageReference pageRef = new PageReference('/'+lcr.opportunityid+'/e?retURL=/'+lcr.opportunityid);
                    pageref.setredirect(true);
                    return pageref;
                    
                }catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
                    return null;
                }
            }
        }
    }
}