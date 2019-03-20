/**
* Forseva online application code.
*/
public with sharing class OnlineApplicationSetupController extends ForsevaControllerBase {

    public OnlineApplicationSetupController() {
    
        String opp = ApexPages.currentPage().getParameters().get('opportunityId');
        m_application = new OnlineApplication(new OnlineApplication__c());
        
        if(opp != null) {
            
            m_opportunity = (Opportunity)SOUtility.getCompleteSObject(Opportunity.SObjectType, Id.valueOf(opp));
            m_account = (Account)SOUtility.getCompleteSObject(Account.SObjectType, m_opportunity.AccountId);
            
            // auto pre-fill (more in action method later)
            
            /*Added by Trekbin regarding Case :00022569 Start */
            
            m_application.getSO().Legal_Business_Name__c = formatAllNames(m_account.Name, 30);
			
			/*Added by Trekbin regarding Case :00022569 End */
			
            //m_application.getSO().Legal_Business_Name__c = rep_name; m_account.Name.substring(0, Math.min(30, m_account.Name.length()));
            m_application.getSO().Account__c = m_account.Id;
            m_application.getSO().Opportunity__c = m_opportunity.Id;
            m_application.getSO().Fleet_One_Initiated_Application__c = true;
            m_application.getSO().Status__c = OnlineApplication.PREFILL_IN_PROGRESS;
            m_application.getSO().eSignature_Status__c = OnlineApplication.NOT_EXECUTED;
            m_application.getSO().Application_Key__c = String.valueOf(Math.abs(Crypto.getRandomLong()));
            
            // contact staging
            
            for(Contact c : [select Name, Id from Contact where AccountId = :m_account.Id order by Level_of_Influence__c desc nulls last]) {
                m_contactList.add(new SelectOption(c.Id, c.Name));
            }
            if(m_contactList.size() > 0) {
                m_contact = (Contact)SOUtility.getCompleteSObject(Contact.SObjectType, Id.valueOf(m_contactList[0].getValue()));
            }
            else {
                m_contact = new Contact();
                Id rId = OnlineApplicationParameters.getDefaultContactRecordType();
                if(rId != null) {
                    m_contact.RecordTypeId = rId;
                }                
                m_contact.AccountId = m_account.Id;
            }

            // offer staging
            
            m_offerList.add(new SelectOption('', Label.SelectAnOffer));
            for(OnlineApplicationOffer__c o : [select Name, Id from OnlineApplicationOffer__c order by Name]) {
                m_offerList.add(new SelectOption(o.Id, o.Name));
            }
            //if(m_offerList.size() > 0) {
            //    m_offer = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, Id.valueOf(m_offerList[0].getValue()));
            //}
        }
    }

    // account methods

    public Account getAccount() {
        return m_account;
    }

    // contact methods

    public Contact getContact() {
        return m_contact;
    }

    public String getContactId() {
        return String.valueOf(m_contact.Id);
    }
    public void setContactId(String contactId) {
        if(Id.valueOf(contactId) != m_contact.Id) {
            m_contact = (Contact)SOUtility.getCompleteSObject(Contact.SObjectType, Id.valueOf(contactId));
        }
    }

    public List<SelectOption> getContactList() {
        return m_contactList;       
    }

    public Boolean getShowContactList() {
        return m_contactList.size() > 0;
    }

    // application methods

    public OnlineApplication__c getApplication() {
        return m_application.getSO();
    }

    // email template methods

    public String getTemplateId() {
        return m_application.getSO().Email_Template_Id__c;    
    }
    public void setTemplateId(String templateId) {
        m_application.getSO().Email_Template_id__c = templateId;
    }

    public List<SelectOption> getTemplateList() {
    
        List<SelectOption> options = new List<SelectOption>{new SelectOption('',Label.SelectATemplate)};
        
        String profileName = [select Name from Profile where Id = :UserInfo.getProfileId()].Name;
        String folderName = null;
        
        /*  Added By Trekbin : 4rth August --- Start*/
        
        GetTemplates__c getTemplates = GetTemplates__c.getInstance(profileName);
		
		if(getTemplates != null) {
			
			folderName = getTemplates.FolderName__c;
		}
		
 		/*  Added By Trekbin : 4rth August --- End*/
 		
        if(folderName == null) {
            for(EmailTemplate temp : [select Id, Name, Subject 
                                      from   EmailTemplate 
                                      where  IsActive = true 
                                      order  by Name]) {
                if(temp.Subject.contains('OnlineApplication__c')) {
                    options.add(new SelectOption(temp.Id, temp.Name));
                }
            }
        }
        else {
            for(EmailTemplate temp : [select Id, Name, Subject 
                                      from   EmailTemplate 
                                      where  IsActive = true
                                      and    Folder.Name = :folderName 
                                      order  by Name]) {
                if(temp.Subject.contains('OnlineApplication__c')) {
                    options.add(new SelectOption(temp.Id, temp.Name));
                }
            }        
        }
        
        return options;        
    }

    // offer methods

    public String getOfferId() {
        return m_offer != null ? m_offer.Id : null;
    }
    public void setOfferId(String offerId) {
        if(offerId != null) {
            m_offer = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, Id.valueOf(offerId));
        }
    }

    public List<SelectOption> getOfferList() {
        return m_offerList;
    }

    //----------------
    // action methods
    //----------------

    // this method is called in the ApplicationSetup page tag "action" attribue
    public ApexPages.PageReference resendApplicationIfItExists() {
    
        String resend = ApexPages.currentPage().getParameters().get('resend');
        String applicationId = ApexPages.currentPage().getParameters().get('applicationId');
        
        // pass over intial setup page and go right to application
        if(resend != null && resend == 'true' && applicationId != null) {
                        
            OnlineApplication__c oa = OnlineApplication.getSObjectWithAllFields(Id.valueOf(applicationId));
            
            // do not send Approved or Setup Complete applications again...
            if(oa.Status__c == OnlineApplication.APPROVED || oa.Status__c == OnlineApplication.SETUP_COMPLETE) {
                ApexPages.PageReference p1 = new PageReference('/' + oa.Id);
                return p1;
            }
            
            // reset key fields as we are trying again...
            oa.Status__c = OnlineApplication.PREFILL_IN_PROGRESS;
            oa.eSignature_Status__c = OnlineApplication.NOT_EXECUTED;
            oa.I_Have_Read_and_Agree__c = false;
            update oa;

            ApexPages.PageReference p2 = Page.ApplicationCompanyInformation;
            p2.setRedirect(true);
            p2.getParameters().put('id', oa.Id);
            p2.getParameters().put('ak', oa.Application_Key__c);
            return p2;
        }
        // continue to setup page
        else {          
            return null;  
        }
    }

    public ApexPages.PageReference createAndEditApplication() {

        if(m_offer == null) {
            addErrorMessage(Label.YouMustSelectAnOffer);
            return ApexPages.currentPage();
        }
        if(m_application.getSO().Email_Template_id__c == null) {        
            addErrorMessage(Label.YouMustSelectATemplate);
            return ApexPages.currentPage();
        }
    
        OnlineApplication__c oa = m_application.getSO();
    
        // selected offer prefill
    
        oa.Offer__c = m_offer.Id;
        oa.Product_Type__c = m_offer.Product_Type__c;
        if(OnlineApplication.OTR == oa.Product_Type__c) {
            oa.Odometer__c = true;
        }
        oa.Application_Title__c = m_offer.Application_Title__c;
        oa.How_Did_You_Hear_About_Us__c = m_offer.Lead_Source__c;
        oa.Promotional_Code__c = m_offer.Promotional_Code__c;
        oa.Hide_Card_Setup_Page__c = m_offer.Hide_Card_Setup_Page__c;
        oa.Billing_Cycle__c = m_offer.Billing_Cycle__c;
        if(OnlineApplication.DAILY == oa.Billing_Cycle__c) {
            //oa.Day_of_Payment__c = 'Tuesday';
        }
        oa.Payment_Method__c = m_offer.Payment_Method__c;
    
        // selected contact prefill
        
        oa.AO_Address__c = m_contact.MailingStreet;
        oa.AO_City__c = m_contact.MailingCity;
        oa.AO_State__c = m_contact.MailingState;
        oa.AO_Zip_Code__c = m_contact.MailingPostalCode;
        oa.AO_Date_of_Birth__c = m_contact.Birthdate;
        oa.AO_Home_Phone_Number__c = m_contact.HomePhone;
        oa.AO_Name__c = m_contact.FirstName + ' ' + m_contact.LastName;
        oa.AO_First_Name__c = m_contact.FirstName;
        oa.AO_Last_Name__c = m_contact.LastName;
        
       /*Added by Trekbin regarding Case :00022569 Start */
                
        String strFirst_LastName = m_contact.FirstName + ' ' + m_contact.LastName;
        oa.Contact_Name__c = formatAllNames(strFirst_LastName, 79);
        /*Added by Trekbin regarding Case :00022569 End */
        
        oa.Contact_Name__c = m_contact.FirstName + ' ' + m_contact.LastName;
        oa.Email__c = m_contact.Email;
        oa.AO_Social_Security_Number__c = m_contact.Social_Security_Number__c;
        oa.AO_Confirm_Social_Security_Number__c = m_contact.Social_Security_Number__c;
        oa.AO_Title__c = m_contact.Title;
        oa.AO_Work_Email__c = m_contact.Email;
    
        // account prefill

        oa.Financial_Institution__c = m_account.Financial_Institution__c;
        oa.Branch_Address__c = m_account.Branch_Address__c;
        oa.Branch_City__c = m_account.Branch_City__c;
        oa.Branch_State__c = m_account.Branch_State__c;
        oa.Branch_Zip_Code__c = m_account.Branch_Zip_Code__c;
        oa.Branch_Phone_Number__c = m_account.Branch_Phone_Number__c;
        oa.ABA_Routing_Number__c = m_account.ABA_Routing_Number__c;
        oa.Confirm_ABA_Routing_Number__c = m_account.ABA_Routing_Number__c;
        oa.Checking_Account_Number__c = m_account.Checking_Account_Number__c;
        oa.Confirm_Checking_Account_Number__c = m_account.Checking_Account_Number__c;
        
        /*Added by Trekbin regarding Case :00022569 Start */
        
        oa.Business_Street_Address__c = m_account.BillingStreet != null ?  formatAllNames(m_account.BillingStreet, 39) : '';
        /*Added by Trekbin regarding Case :00022569 End */
        
        oa.City__c = m_account.BillingCity != null ? formatAllNames(m_account.BillingCity, 30) : '';
        oa.State__c = m_account.BillingState;
        oa.Zip_Code__c = m_account.BillingPostalCode;
        oa.Phone_Number__c = m_account.Phone;
        oa.Fax_Number__c = m_account.Fax;
        
        oa.DUNS__c = m_account.forseva1__DUNS_Number__c;
        oa.Federal_Tax_ID__c = m_account.EIN__c;

        oa.Number_of_Trucks__c = m_account.Number_of_Tractors__c;  // OTR
        oa.Number_of_Vehicles__c = m_account.Number_of_Other_Fuel_Vehicles__c;  // Local and OTR

        // create the application and upsert contact 
        // as we may have overwitten name or email, or created new one
    
        m_application.saveApplication();
        upsert m_contact;

        // onward to the same page the customer will see

        ApexPages.PageReference p = Page.ApplicationCompanyInformation;
        p.setRedirect(true);
        p.getParameters().put('id', oa.Id);
        p.getParameters().put('ak', oa.Application_Key__c);
        return p;
    }

    public ApexPages.PageReference returnToOpportunity() {
        return (new ApexPages.StandardController(m_opportunity)).view();
    }

    //----------------
    // private
    //----------------

    private Account m_account;
    private Contact m_contact;
    private Opportunity m_opportunity;
    private OnlineApplication m_application;
    private OnlineApplicationOffer__c m_offer;
    
    private List<SelectOption> m_contactList = new List<SelectOption>();
    private List<SelectOption> m_offerList = new List<SelectOption>();
    
    
    //Added by Trekbin on 21th July
    private String formatAllNames(String strName, Integer intSize) {
    	
    	String strNameReturn = strName.substring(0,Math.min(intSize, strName.length()));
        List<String> elems = strNameReturn.split(' ');
        strNameReturn = '';
        for (String x : elems){
           
           	x = x.trim();
           	x = x.replaceAll('(\\s+)', ' ');
           	
            if(x.length() == 1) {
                
                strNameReturn += x.toUpperCase()+ ' ';
            }
            else if(x.length() > 1){
               
                strNameReturn += x.substring(0,1).toUpperCase()+x.substring(1,x.length()) + ' ';
            } 
            
        }
    	return strNameReturn;
    }
    
    
}

// EOF