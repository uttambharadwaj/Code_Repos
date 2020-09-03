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

	Modified by: Lev 
	Description: Change search to query Marketing Cloud
	Date: October 2019
*/

//public with sharing class i2iSearchController {
public class i2iSearchController {
    public List<Search_Tool_Source__mdt> searchToolSource = [SELECT Id, Active__c, Data_Source__c FROM Search_Tool_Source__mdt WHERE Active__c = true];
    public String page {get; set;}
    public double mSecondsToExecute {get;set;}
    public double totalmSecondsToExecute{get;set;}
    
    public String programSelected{get;set;}
    public List<SelectOption> programValues {
        get {
            if(programValues==null){
                Map<String,String> programNames = new Map<String,String>();
                programValues = new List<SelectOption>();
                programValues.add(new SelectOption('-None-','-None-'));
                for(Program__c pg : [Select Name from Program__c Order BY Name ASC]) {
                    if(!programNames.containskey(pg.Name)){
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
    
    @TestVisible private Map<String,String> programNamesbyCouponcode {get;set;}    
    public string iframeurl{get;set;}
    public boolean iframeurlhit{get;set;}
    
    public i2iSearchController() {
        initPage();
    }
    
    public void initPage() {
        PageReference currentPage = ApexPages.currentPage();    
        
        iframeurl='';
        iframeurlhit=false;
        
        if(currentPage.getParameters().get('leftnav')=='true') {
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
    
    public void clearForm() {
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
    
    public void initLeftNavPage() {
        searchbyphone=true;
        redirectParent=false;
        phonebuttoncolor = '#b5b5b5'; //selected gray
        companybuttoncolor='#e8e8e9'; //Default gray
    }
    
    public List<i2iGet.returnData> records {get;set;}
    public List<i2iGet.returnData> mcRecords {get;set;}
    
    public void searchi2i() {
        //Sources to search against
        Map<String, Boolean> sources = new Map<String, Boolean>();
        for(Search_Tool_Source__mdt tool: searchToolSource) {
            sources.put(tool.Data_Source__c, tool.Active__c);
        }
        
        DateTime totalexecutionstart = system.now();
        
        leadWrappers = new List<LeadWrapper>();
        contactWrappers = new List<ContactWrapper>();
        nomatchrecordwrappers = new List<NoMatchi2i>();
        programnamesbycouponcode = new Map<string,string>();
        
        List<String> searchVars = new List<String>();
        
        GlobalSettings__c gs = GlobalSettings__c.getorgdefaults();

        //need prefix of leads and opps
        //iframeurl='https://cs1.salesforce.com/_ui/search/ui/UnifiedSearchResults?sen=00Q&sen=006&str=';
        
        //Get SF instance baseURL for the iframe to load properly
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        iframeurl = baseUrl + '/_ui/search/ui/UnifiedSearchResults?sen=00Q&sen=006&str=';
        iframeurlhit=false;
        
        try {
            String phonepass = (phoneNumber!=null && phoneNumber!='') ? phoneNumber.replaceall('\\D','') : '';
            
            if(phonepass!=null && phonepass!='') {
                if(phonepass.length()!=10 && phonepass.length()!=11
                   ||(phonepass.length()==10 && (phonepass.substring(0,1)=='1' || phonepass.substring(0,1)=='0'))) {
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'If searching by Phone, you must include a total of 10 or 11 digits.'));
                       return;
                   } else {
                       //strip 1 if present
                       if(phonepass.substring(0,1)=='1' || phonepass.substring(0,1)=='0') {
                           string str = phonepass.substring(1);
                           phonepass = str;
                       }
                       
                       //If Phone has special characters, strip to just numbers prior to sending to Marketing Cloud
                       phonePass = phonePass.replaceAll('/[^a-zA-Z0-9 ]/g', '');
                       phoneNumber = phonepass;                       
                   }
                
                searchvars.add(phonenumber);
            }
            
            if(company!=null && company!='') { 
                if(!(company.endswith('*'))) company += '*';
                searchvars.add(company);
            }
            
            if(zipcode!=null && zipcode!='') searchvars.add(zipcode);
            
            if(email != null && email !='') searchvars.add(email);
            
            iframeurlhit=true;
            for(string s : searchvars) {
                System.debug('s ' + s);
                if(iframeurlhit) iframeurl+=' ';
                iframeurl+=s;
                iframeurlhit=true;
            }
            
            mcRecords = new List<i2iGet.returnData>();
            records = new List<i2iGet.returnData>();
            DateTime startTime = system.now();
            if(programSelected=='-None-') programSelected = null;
            try {
                String str;
                String couponCode;

                for(String dataSource : sources.keySet()) {
                    if(dataSource == Label.Quick_Pivot && sources.get(dataSource)) {
                        records = i2iGet.executeCall(promocode, programSelected, phonepass, company, zipcode, email);
                    } else if (sources.get(dataSource) && dataSource == Label.Marketing_Cloud && (searchvars.size() > 0 || String.isNotBlank(promocode))) {
                        // For MC, split promo code into coupon code and lead number
                        String leadNumber;
                        Boolean makeMcCall = true;

                        if (String.isNotBlank(promocode)) {
                            List<String> promoCodeSplit = promocode.split('-');
                            couponCode = promoCodeSplit[0];
                            if (promoCodeSplit.size() > 1) {
                                leadNumber = promoCodeSplit[1];
                            }
                            // Only search with promo code if there is a lead number
                            else {
                                makeMcCall = false;
                            }
                        }
                        
                        // Get records from MC
                        if (makeMcCall) {
                            mcRecords = i2iGetMC.sendTokenMC(promocode, couponcode, leadNumber, programSelected, phonepass, company, zipcode, email); 
                        } 
                        System.debug(mcRecords);
                    }
                }
                
                records.addAll(mcRecords);
                
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                system.debug('....exception: ' + e.getmessage());
            }
            
            DateTime endTime = system.now();
            mSecondsToExecute = i2iGet.GetDifferenceInMilliSeconds(starttime, endtime);
            
            //if i2i has no results do a search into SF only
            if(records.size()== 0) {
                system.debug('....no records');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No results from i2i.'));                    
            } else {
                //Single ids to pull campaign members...then scroll through return checking to see if match in campaign member match
                //then loop through data if hit in map, check prefix to see if its lead or campaign, add the wrappers
                
                Set<String> i2iIds = new Set<String>();
                Set<String> couponCodesReturned = new Set<String>();
                Set<String> leadNumbers = new Set<String>();
                Set<String> phones = new Set<String>();
                Set<String> emails = new Set<String>();

                for(i2iGet.returnData rd: records) {
                    if (rd.i2iId!=null && !String.isEmpty(rd.i2iId) ) i2iIds.add(rd.i2iId);
                    if (rd.couponcode!=null && !String.isEmpty(rd.couponcode) ) couponCodesReturned.add(rd.CouponCode);
                    if (rd.leadNumber != null && !String.isEmpty(rd.leadNumber) ) leadNumbers.add(rd.leadNumber);
                    if (rd.phone != null && !String.isEmpty(rd.phone) ) phones.add(rd.phone);
                    if (rd.email != null && !String.isEmpty(rd.email) ) emails.add(rd.email);
                }
                
                Set<Id> whoIds = new Set<Id>();
                Date ninetydays = system.now().date().adddays(-90);
                
                //** This map may need to be by contactid and coupon code...it may be possible for a contact to be
                //on many opp/campaigns and coupon codes.
                Map<String,OpportunityContactRole> opportunityContacts = new Map<String,OpportunityContactRole>();
                Set<Id> opportunityContactsContactIds = new Set<Id>();
                for(OpportunityContactRole ocr : [Select Id, ContactId, opportunityid, opportunity.coupon_code2__c, opportunity.StageName, opportunity.Product_Interest__c,
                                                  Opportunity.CampaignId, Opportunity.Campaign.Coupon_Code__c, Contact.Lead_Number__c
                                                  from opportunitycontactrole 
                                                  Where Opportunity.Campaign.Coupon_Code__c IN :couponCodesReturned
                                                  AND (Contact.Lead_Number__c IN :leadNumbers OR Contact.i2i_ID__c IN :i2iIds)
                                                  AND Opportunity.CreatedDate >= :ninetydays
                                                 ]) {
                                                     string unqkey = (string)ocr.contactid + ocr.Opportunity.Campaign.Coupon_code__c; 
                                                     opportunityContacts.put(unqkey,ocr);     
                                                     opportunityContactsContactIds.add(ocr.contactid);   
                                                 }
                
                Map<String, CampaignMember> campaignMembersMapLead = new Map<String, CampaignMember>();
                Map<String, CampaignMember> campaignMembersMapContact = new Map<String, CampaignMember>();
                List<CampaignMember> campaignMembersLead = new List<CampaignMember>();
                
                for(CampaignMember cm : [Select leadid, contactid, lead.Status, lead.Product_Interest__c, lead.owner.name, contact.i2i_ID__c, lead.IsConverted,
                                         contact.owner.name, campaignid, campaign.Coupon_Code__c, campaign.Name, campaign.Marketing_Offer__c, lead.coupon_code_2__c,
                                         lead.parent_lead__c, lead.parent_lead__r.i2i_id__c, lead.createddate, campaign.default_program__r.name, Contact.Lead_Number__c, 
                                         lead.parent_lead__r.rr_lead_number__c, lead.phone, contact.phone, lead.email, contact.email
                                         from CampaignMember 
                                         where campaign.Coupon_Code__c IN :couponCodesReturned 
                                         AND ((lead.IsConverted = false AND lead.Status!='Disqualified') 
                                            OR contactId IN :opportunityContactsContactIds)
                                         AND (lead.parent_lead__r.rr_lead_number__c IN :leadNumbers
                                            OR Contact.Lead_Number__c IN :leadNumbers
                                            OR lead.parent_lead__r.i2i_id__c IN :i2iIds 
                                            OR Contact.i2i_id__c IN :i2iIDs) 
                                          AND ( lead.INVOCA_FOR_SF__TextPhone__c  in :phones
                                            OR Contact.INVOCA_FOR_SF__TextPhone__c  in :phones ) 
                                         Order By CreatedDate ASC]) {
                                             

                                             if(cm.ContactId != null) {
                                                String mcKey = cm.Contact.Lead_Number__c + '-' + cm.Campaign.Coupon_Code__c;
                                                String qpKey = cm.Contact.i2i_ID__c + '-' + cm.Campaign.Coupon_Code__c;
                                                campaignMembersMapContact.put(mcKey, cm);
                                                campaignMembersMapContact.put(qpKey, cm);
                                                 whoIds.add(cm.contactid);   
                                             }
                                             
                                             if(cm.leadId != null)  {
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
                                  AND coupon_code__c NOT IN :programnamesbycouponcode.keyset()]) {
                                      programnamesbycouponcode.put(c.coupon_code__c,c.default_program__r.name);
                                  }
                
                
                Set<Id> salesProfileIDs = new Set<Id>();
                for(Sales_Activity_by_Profile__c spro : Sales_Activity_by_Profile__c.getall().values()) {
                    if(spro.ProfileID__c != null) {
                        try {
                            salesProfileIds.add((Id)spro.profileid__c);
                        } catch(Exception e) {   
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error pulling Sales Profiles from custom setting: ' + e.getMessage() + ' ' + e.getStackTraceString()));
                            
                            return;
                        }
                    }
                }
                
                Set<Id> activities90days = new Set<Id>();
                for (Task t : [Select WhoId from Task Where WhoId IN :whoIds
                               AND Status='Completed' AND ActivityDate >=:ninetydays
                               AND Owner.ProfileId IN :salesProfileIds]) {
                                   activities90days.add(t.whoid);
                               }
                
                //**loop through lead campaign members and build map by i2i id and coupon code.
                for(campaignmember cm : campaignMembersLead) {
                    if(cm.lead.createddate > ninetydays || activities90days.contains(cm.leadid)) {
                        String mcKey = cm.Lead.Parent_Lead__r.rr_lead_number__c + '-' + cm.Campaign.Coupon_Code__c;
                        String qpKey = cm.Lead.Parent_Lead__r.i2i_ID__c + '-' + cm.Campaign.Coupon_Code__c;
                        campaignMembersMapLead.put(mcKey, cm);
                        campaignMembersMapLead.put(qpKey, cm);
                    }
                }
                
                Integer recordcount = 0;
                Set<string> recordallocated = new set<string>();
                for(i2iget.returndata r : records){  
                    
                    // TODO: update this boolean in the IFs
                    Boolean noMatch = true;
                    String recordKey = r.leadNumber == null ? r.i2iId : r.LeadNumber;
                    recordKey += '-' + r.CouponCode;
                    
                    if (campaignMembersMapLead.containsKey(recordKey)) {
                        CampaignMember cm = campaignMembersMapLead.get(recordKey);

                        if (cm.LeadId != null 
                            && cm.Lead.IsConverted == false 
                            && cm.Lead.Status != 'Disqualified'
                            && (i2iIds.contains(cm.lead.parent_lead__r.i2i_id__c) || leadNumbers.contains(cm.Lead.Parent_Lead__r.rr_lead_number__c))) {
                            
                            //have to do a recheck of the lead, since a campaign member could be attached to contact and lead. 
                            leadwrappers.add(new LeadWrapper(cm, r, this));
                            recordallocated.add(recordKey);
                        } 
                    }
                    
                    if (campaignMembersMapContact.containsKey(recordKey)) {
                        CampaignMember cmc = campaignMembersMapContact.get(recordKey);
                        String unkey = (String) cmc.ContactId + r.CouponCode;

                        if (cmc.ContactId != null && opportunityContacts.containsKey(unkey)) {
                            OpportunityContactRole ocr = opportunityContacts.get(unkey); //cmc.contactid);
                            contactwrappers.add(new ContactWrapper(cmc,r, ocr,this));
                            recordallocated.add(recordKey);
                        }
                    }
                    
                    if (!recordallocated.contains(recordKey) && (r.leadNumber != null || r.couponcode != null || r.i2iId != null)) {
                        nomatchrecordwrappers.add(new NoMatchi2i(r, this));
                        recordallocated.add(recordKey);
                    }             

                    recordcount++;
                    if(recordcount>19)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'More than 20 record returned. First 20 are shown.'));
                        //break;
                    }
                }
            
            }
            
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
        }
        DateTime totalexecutionend = system.now();
        this.totalmSecondsToExecute = i2iget.getDifferenceInMilliSeconds(totalexecutionstart, totalexecutionend);
    }
    
    public pagereference searchi2iLeftNav() {
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
    
    public void customaddMessage(string msg) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msg));
    }
    
    public void findbyPhone() {
        searchbyphone=true;
        phonebuttoncolor = '#b5b5b5'; //selected gray
        companybuttoncolor='#e8e8e9'; //Default gray
    }
    
    public void findbyBusiness() {
        searchbyphone=false;
        phonebuttoncolor = '#e8e8e9'; //default gray
        companybuttoncolor='#b5b5b5'; //selected gray
    }
    
    public class LeadWrapper {
        public CampaignMember campaignmemberrecord{get;set;}
        public i2iget.returnData returndatarecord{get;set;}
        public string completeownername{get;set;}
        private string leadid{get;set;}
        public string programname{get;set;}
        private Lead l {get;set;}
        
		public LeadWrapper(CampaignMember c, i2iget.returnData rd, i2iSearchController i2icon){

            campaignmemberrecord = c;
            if(rd != null) {
                returndatarecord = rd;
                leadid = c.leadid;
            	programname = (i2icon.programnamesbycouponcode.containskey(rd.couponcode)) ? i2icon.programnamesbycouponcode.get(rd.couponcode) : '';   
            }

         }

        public pagereference openlead() {
            return new PageReference('/'+leadid);
        }
        
        public pagereference convertlead() {
            
            l = [Select Id, IsConverted, ConvertedOpportunityId, Parent_Lead__c,
                Parent_Lead__r.Related_Contact__c, RecordTypeId, Parent_Lead__r.i2i_id__c,
                Parent_Lead__r.Related_Contact__r.AccountId, Parent_Lead__r.rr_lead_number__c
                from Lead Where Id = :leadid];  /*Parent_lead__r.Related_Account__c,*/
            
            System.debug('l opp is ' + l.ConvertedOpportunityId);

            if(l.isconverted){
                
                PageReference pageRef = new PageReference('/'+l.ConvertedOpportunityId+'/e?retURL=/'+l.ConvertedOpportunityId);
                pageref.setredirect(true);
                return pageref;
            } else {
                //**new calling describer to get correct converted status for recordtype
                List<String> statusValuesList =  new List<String>();
                if(test.isRunningTest()) {
                    statusValuesList.add('Qualified');
                } else {
                    statusValuesList = picklistDescriber.describe('Lead',l.RecordTypeId,'Status');
                }
                
                List<leadstatus> cnvtStatus = [select Id, MasterLabel from LeadStatus where IsConverted = True AND MasterLabel IN :statusValuesList order by SortOrder ASC limit 1];
                if(cnvtStatus.size()==0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: No converted status found for this recordtype.  Please contact Administrator.'));
                    return null;
                }
                
                String convertStatus = cnvtStatus[0].masterlabel;
                Database.Leadconvert lc = new Database.Leadconvert();
                lc.setLeadId(l.Id);
                lc.setConvertedStatus(convertStatus);
                lc.setownerid(UserInfo.getUserId());

                if(l.Parent_Lead__r.Related_Contact__c != null && l.Parent_Lead__r.Related_Contact__r.AccountId!=null) {
                    lc.setaccountid(l.Parent_Lead__r.Related_Contact__r.AccountId);
                    lc.setContactId(l.Parent_Lead__r.Related_Contact__c);
                }
                
                try {
                    System.debug('####lc ' + lc);
                    Database.Leadconvertresult lcr = database.convertlead(lc);

                    system.debug('-- geterrors: ' + lcr.geterrors());
                    if(!(lcr.success)) {
                        string errorstr = '';
                        for(database.Error e : lcr.errors) {
                            errorstr+=e.message;
                        }
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: ' + errorstr));
                        return null;
                    }
                    
                    updateContactRecord(lcr);
                    
                    PageReference pageRef = new PageReference('/'+lcr.opportunityid+'/e?retURL=/'+lcr.opportunityid);
                    pageref.setredirect(true);
                    return pageref;
                    
                } catch(Exception e) {
                    System.debug('ERROR: ' + e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString())); 
                }
            }
            return null;
        }
        
        private void updateContactRecord(Database.LeadConvertResult lcr) {
            Contact c = new Contact(id=lcr.getContactId());
            c.i2i_ID__c = l.Parent_Lead__r.i2i_id__c;
            c.Lead_Number__c = l.Parent_Lead__r.rr_lead_number__c;

            try {
                update c;
            } catch(DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));                
                System.debug('EXCEPTION: ' + e);
                return;
            }
        }
    }
    
    public class ContactWrapper {
        string contacturl{get;set;}
        string opportunityurl{get;set;}
        public CampaignMember campaignmemberrecord{get;set;}
        public OpportunityContactRole opportunitycontactrecord{get;set;}
        public i2iget.returnData returndatarecord{get;set;}
        public string programname{get;set;}

        public ContactWrapper(CampaignMember c, i2iget.returnData rd, OpportunityContactRole ocr, i2iSearchController i2icon){            
        	contacturl='/' + c.contactId;
            opportunityurl='/' + ocr.opportunityid;
            campaignmemberrecord = c;
            if(rd != null) {
                returndatarecord = rd;
                opportunitycontactrecord = ocr;
                programname = programname = (i2icon.programnamesbycouponcode.containskey(rd.couponcode)) ? i2icon.programnamesbycouponcode.get(rd.couponcode) : '';
            }
        }
        
        public pagereference opencontact() {
            return new pagereference(contacturl);
        }
        
        public pagereference openopportunity() {
            return new pagereference(opportunityurl);
        }
    }

    public class NoMatchi2i {
        public i2iget.returndata nomatchi2irecord{get;set;}
        public string programname{get;set;}
        private boolean createError{get;set;}
        @TestVisible private List<Lead> childLead {get;set;}
       
        public NoMatchi2i(i2iget.returndata i2idata, i2iSearchController i2icon){
        	if(i2idata != null && i2idata.returnDescription != 'No records found') {
                nomatchi2irecord = i2idata;
                programname = (i2icon.programnamesbycouponcode.containskey(i2idata.couponcode)) ? i2icon.programnamesbycouponcode.get(i2idata.couponcode) : '';
                createError=false;               
            }

        }
        public pagereference createLeadRedirect() {
            createError=false;
            createLead();
            if(createError) return null;
            
            if(childLead==null || childLead.size()==0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Lead not found from Parent created/updated.'));
                return null;
            }  
           
            Pagereference pageref = new PageReference('/'+childLead[0].Id+'/e?retURL=/'+childLead[0].Id);
            pageref.setredirect(true);
            return pageref;
            
        }
        
        /* Updated by Trekbin to split the DML and Callout into different transactions, as per case requirement : 00022611
        called from "Create Opportunity" button and performs DML, oncomplete  trigger click event on "convertChildLead" button(hidden) just to call convertChildLead method 
        where Callout(getContent) takes place */
        
        public pagereference convertLead() {
            createError=false;
            createLead();
            if(createerror) return null;
            else
                return null;
        }
        
        private void updateContactRecord(Database.LeadConvertResult lcr) {
            Contact c = new Contact(id=lcr.getContactId());
            c.i2i_ID__c = childLead[0].Parent_Lead__r.i2i_id__c;
            
            try {
                update c;
            } catch(DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));
                return;
            }
        }
        
        public void createLead() {
            GlobalSettings__c setting = GlobalSettings__c.getOrgDefaults();
            
            Lead newLead = new Lead();
            if(nomatchi2irecord != null) {
                
                //Format Phone to be User friendly
                String phone = nomatchi2irecord.phone;
                if(phone.length() == 10) {
                    phone = phone.substring(0,3) + '-' + phone.substring(3,6) + '-' + phone.substring(6,10);
                }
                
                newLead.FirstName = nomatchi2irecord.firstname;
                newLead.LastName = nomatchi2irecord.lastname;
                newLead.Company = nomatchi2irecord.company;
                newLead.City = nomatchi2irecord.city;
                newLead.State = nomatchi2irecord.state;
                newLead.Street = nomatchi2irecord.address;
                newLead.PostalCode = nomatchi2irecord.zip;
                newlead.status = 'Working';
                newlead.recordtypeid = setting.Parent_Lead_Record_Type_Id__c;
                newlead.i2i_id__c = nomatchi2irecord.i2iId;
                newlead.i2i_coupon_code_pass__c = nomatchi2irecord.couponcode;
                newlead.ownerid = setting.Parent_Lead_Queue__c;
                newLead.Phone = phone;
                newLead.Country = nomatchi2irecord.country;
                newLead.i2i_Contact_ID__c = nomatchi2irecord.i2icontactid;
                newLead.Email = nomatchi2irecord.Email;
            }
            System.debug('new Lead ' + newLead);
            try {
                if (newLead.i2i_id__c != null && String.isNotEmpty(newLead.i2i_id__c)) {
                    upsert newlead i2i_id__c;
                } else {
                    Boolean isSuccessful = false;

                    if (nomatchi2irecord != null && nomatchi2irecord.leadNumber != null && String.isNotEmpty(nomatchi2irecord.leadNumber)) {

                       List<Lead> parentLead = [ SELECT Id FROM Lead WHERE rr_lead_number__c = :nomatchi2irecord.leadNumber ];
                        if (!parentLead.isEmpty()) {
                            newLead.Id = parentLead[0].Id;
                            update newLead;
                            isSuccessful = true;
                        }

                    }
                    if (!isSuccessful) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find parent lead number: ' + nomatchi2irecord.leadNumber));
                        createError = true;
                        return;
                    }
                }
            }catch (Exception e) {
                System.debug('ERROR: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
                createError=true;
                return;
            }

            childLead = new List<Lead>();
            System.debug('newlead.Id ' + newlead.Id);
            childLead = [Select Id, IsConverted, ConvertedOpportunityId, Related_Account__c, Related_Contact__c,
                        Parent_Lead__c, Parent_Lead__r.Related_Account__c, Parent_Lead__r.Related_Contact__c, Parent_Lead__r.i2i_Id__c
                        from Lead 
                        Where Parent_Lead__c = :newlead.Id 
                        //AND RecordTypeId != :setting.Parent_Lead_Record_Type_Id__c
                        AND Id IN (Select LeadId from CampaignMember where Campaign.Coupon_Code__c = :nomatchi2irecord.couponcode) 
                        Order by CreatedDate DESC LIMIT 1];
                        
        }
        
         /* Updated by Trekbin to split the DML and Callout into different transactions, as per case requirement : 00022611 
         called from "convertChildLead" button just to execute DML and callout in differenent trasctions to avoid
          System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out*/
          
         public pagereference convertChildLead() {
             if(childLead==null || childLead.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Lead not found from Parent created/updated.'));
                return null;
            }
            
             if(childLead[0].isconverted) {
                PageReference pageRef = new PageReference('/'+childLead[0].ConvertedOpportunityId+'/e?retURL=/'+childLead[0].ConvertedOpportunityId);
                pageref.setredirect(true);
                return pageref;
            } else {
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
                        for(database.Error e : lcr.errors) {
                            errorstr+=e.message;
                        }
                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error converting lead: ' + errorstr));
                        return null;
                    }
                    
                    updateContactRecord(lcr);
                    PageReference pageRef = new PageReference('/'+lcr.opportunityid+'/e?retURL=/'+lcr.opportunityid);
                    pageref.setredirect(true);
                    return pageref;
                    
                } catch(Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + ' ' + e.getStackTraceString()));
                    return null;
                }
            }
        }
    }
}