/*
*
*   Revision History:   26/AUG/2019     CJackson    LRC-86      Multiple changes to support implementation of CP BOCA.
*
*/

public class CPBOCAToProspectController {

    public String applicationId {
        get {
            if (applicationId == null)
                return ApexPages.CurrentPage().getParameters().get('applicationId');
            return applicationId;
        }
        set;
    }

    public String bocaToProspectId {
        get {
            if(bocaToProspectId == null) {
                return ApexPages.CurrentPage().getParameters().get('bocaToProspectId');
            }
            else {
                return bocaToProspectId;
            }
        }
        set;
    }

    public Boolean hideTNC {get; set;}

    public Account myAccount {get;set;}

    public Account myInitialAccount;

    public String bocaToProspectConfirm {
        get {
            if(bocaToProspectConfirm == null) {
                return ApexPages.CurrentPage().getParameters().get('bocaToProspectConfirm');
            }
            else {
                return bocaToProspectConfirm;
            }
        }
        set;
    }

    public BOCA_To_Prospect__c bocaToProspect { get; set; }

    // The opportunity pulled in from the ID parameter
    public Opportunity opportunity { get; set; }

    // The primary role contact pulled from the opportunity
    public Contact contact { get; set; }

    // The program
    public Id programId { get; set; }

    // The partner object
    public Id partnerId { get; set; }

    public Id contactId { get; set; }

    public User salesRep { get; set; }

    public String salesRepName {
        get {
            if (salesRep != null)
                return salesRep.Name;
            return null;
        }
        set;
    }

    public Boolean disablePG { get; set; }

    public Boolean alwaysRequirePG { get; set; }

    public Boolean disablePGToggle { get; set; }

    public String customMessage { get; set; }

    public String ccEmail { get; set; }

    public String errorCodeDescription { get; set; }

    // JSON representation of attachments
    public String attachments { get; set; }

    // JSON representation of selected additional programs
    public String selectedPrograms { get; set; }

    public List<SelectOption> availablePrograms {
        get {

            List<SelectOption> availablePrograms = new List<SelectOption>();
            availablePrograms.add(new SelectOption('', '-- Choose One--'));

            //IADJUDICAT-1085 restrict partners to only their programs
            Id partnerId = null;
            /* uncomment this block when campaign program is in use. it will limit the programs displayed for inside sales reps.
            //get partner from the program from the oppty
            Campaign_Program__c cp = [SELECT Program__r.Partner__c FROM Campaign_Program__c WHERE Id = :opportunity.Campaign_Program__c LIMIT 1];
            if(cp != null)
                partnerId = cp.Program__r.Partner__c;
            */

            //get user info
            Id uid = UserInfo.getUserId();

            //from user get contact then account then program then partner
            User u = [SELECT  profile.UserLicense.name, Contact.Account.Program__r.Partner__c FROM User WHERE Id = :uid LIMIT 1];
            Boolean isPartner = (u.profile.UserLicense.name == 'Partner Community') ? true : false;
            if(isPartner)
                partnerId = u.Contact.Account.Program__r.Partner__c;

            //assemble the query for possible programs.
            String myQuery = 'SELECT Id, Name FROM Program__c WHERE BOCA_Type__c = \'CPBOCA\' and Publish_BOCA__c = true';
            if(isPartner || (!isPartner && partnerId != null))
                myQuery += ' AND Partner__c = :partnerId';
            myQuery += ' ORDER BY Name ASC';
            //if we have inside sales rep, or we have a partner AND a partnerid, add programs to drop down. if partner user but no partnerid, don't show anything
            if(!isPartner || (isPartner && partnerId != null)){
                for (Program__c program : database.query(myQuery)) {
                    availablePrograms.add(new SelectOption(program.Id, program.Name));
                }
            }

            return availablePrograms;
        }
    }

    public Map<String, String> additionalPrograms {
        get {
            return null;
        }
    }

    public String selectedAdditionalContacts { get; set; }

    public List<OpportunityContactRole> additionalContacts { get; set; }

    public Boolean hasAdditionalContacts {
        get {
            if(additionalContacts != null && additionalContacts.size() > 0) {
                return true;
            }
            return false;
        }
    }

    public String bocaToProspectTemplateId {
        get {
            BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();

            return bocaToProspectSettings.CP_Email_Template_ID__c;
        }
    }

    public String bocaToProspectResendTemplateId {
        get {
            BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();
            return bocaToProspectSettings.CP_Resend_Template_ID__c;
        }
    }

    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }

    public String opportunityId {
        get {
            if(opportunityId == null) {
                return ApexPages.CurrentPage().getParameters().get('id');
            }
            else {
                return opportunityId;
            }
        }
        set;
    }

    // Get the full URL for the page
    public String applicationURL {
        get {
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            string[] urlValExtra = urlVal.split('%3F',0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    public String errorCode { get; set; }

    public CPBOCAToProspectController(ApexPages.StandardController ctrl) {

    }

    public void init() {

        try {
            hideTNC = false;
            if(bocaToProspectConfirm != null && !String.isEmpty(bocaToProspectConfirm)) {

                if(bocaToProspectConfirm.equals('true')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'BOCA To Prospect Sent!'));
                }
                else {
                    errorCode = ApexPages.CurrentPage().getParameters().get('errorCode');

                    if(errorCode != null) {
                        List<Internal_Application_Error__c> error = [SELECT Id, Error_Message__c FROM Internal_Application_Error__c WHERE Name =: errorCode];

                        if(error.size() > 0) {
                            errorCodeDescription = error[0].Error_Message__c;
                        }
                        else {
                            errorCodeDescription = 'General Fault';
                        }
                    }

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorCodeDescription + '  <br><br>The support organization has been notified. Your error tracking number is: ' + errorCode));
                }

            }
            else {

                if (applicationId != null) {

                    List<CP_Application_Request__c> CPApplications = [SELECT Id, Opportunity__c, Program__c FROM CP_Application_Request__c WHERE Id =: applicationId];

                    if(CPApplications.size() > 0) {
                        opportunityId = CPApplications[0].Opportunity__c;
                        selectedPrograms = CPApplications[0].Program__c;
                    }

                    customMessage = 'Please click the link below to correct your application and re-submit.';

                }

                if(bocaToProspectId != null) {
                    List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Opportunity__c, CorporatePayments_Application_Request__r.Program__r.BOCA_To_Prospect_Template__c, Additional_Programs__c, CorporatePayments_Application_Request__r.External_Application_URL__c FROM BOCA_To_Prospect__c WHERE Id =: bocaToProspectId LIMIT 1];

                    if(bocaToProspects.size() > 0) {
                        bocaToProspect = bocaToProspects[0];
                        selectedPrograms = bocaToProspect.Additional_Programs__c;
                        opportunityId = bocaToProspect.Opportunity__c;
                    }
                }

                if(bocaToProspect == null) {
                    bocaToProspect = new BOCA_To_Prospect__c();
                }

                System.debug('### Opportunity ID: ' + opportunityId);

                List<Opportunity> opportunities = [SELECT Id, Opportunity.AccountId, Campaign_Program__r.Program__r.Name, Campaign_Program__r.Program__c, name, Account.Industry,
                        OwnerId, Application_Signer_City__c, Application_Signer_Address__c, Application_Signer_First_Name__c, Application_Signer_Last_Name__c, Application_Signer_Email_Address__c,
                        Application_Signer_Phone__c, Application_Signer_Zip_Code__c, Application_Signer__c, Application_Signer_title__c, Billing_City__c, Billing_Cycle__c,
                        Billing_Contact_Email__c, Billing_Contact_Fax__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c, Credit_Limit__c,
                        Billing_Contact_Middle_Name__c, Billing_Contact_Phone__c, Annual_Income__c, Annual_Gross_Revenue__c, Average_Monthly_Fueling__c, Account_Phone__c,
                        Average_Monthly_Expenses__c, Billing_Contact__c, Billing_Country__c, Billing_Street__c, Billing_Street_Line_2__c, Billing_State__c, Billing_Zip_Postal_Code__c, City__c,
                        DUNS_Number__c, Doing_Business_As__c, Fiscal_Year_Starts__c, Fleet_Size__c, Legal_Structure__c, Number_Fleet_Vehicles__c, coupon_code__c, Tax_Payer_ID__c,
                        Physical_Street_Line_2__c, Physical_State__c, Physical_Country__c, Physical_City__c, Physical_Street__c, Physical_Zip_Postal_Code__c, fax__c, Guarantor_Email__c,
                        Primary_Contact_City__c, Primary_Contact_Fax__c, Primary_Contact_Email__c, Primary_Contact_Country__c, Primary_Contact_First_Name__c, Annual_revenue__c, How_did_you_hear_about_this_offer__c,
                        Primary_Contact_Last_Name__c, Primary_Contact_Middle_Name__c, Primary_Contact_State__c, Primary_Contact_ZIP_Code__c, Guarantor_Name__c, Exempt_from_Motor_Fuels_Tax__c,
                        Guarantor_Last_Name__c, Guarantor_City__c, Guarantor_State__c, Guarantor_Zip_code__c, Guarantor_home_phone__c, Guarantor_address_line_1__c, Guarantor_Annual_Income__c,
                        Primary_Contact_Work_Phone__c, Paperless_Billing_Flag__c, Primary_Contact_Street_Address__c, Years_In_Business__c,Primary_Contact_Street_Address_Line_2__c,
                        Promotional_Code__c, Coupon_Code2__c, Campaign_Program__r.Program__r.BOCA_To_Prospect_Template__c FROM Opportunity WHERE Id = :opportunityId];

                if(opportunities.size() > 0) {

                    opportunity = opportunities[0];

                    myAccount = [SELECT Id, Name, Industry, Customer_s_Primary_Location__c, Customer_s_Primary_Travel_Location__c, Other_Transaction_Currencies__c, Primary_Transaction_Currency__c FROM Account WHERE Id = :opportunity.AccountId LIMIT 1];
                    myInitialAccount = new Account();
                    myInitialAccount.Industry = myAccount.Industry;
                    myInitialAccount.Customer_s_Primary_Location__c = myAccount.Customer_s_Primary_Location__c;
                    myInitialAccount.Customer_s_Primary_Travel_Location__c = myAccount.Customer_s_Primary_Travel_Location__c;
                    myInitialAccount.Other_Transaction_Currencies__c = myAccount.Other_Transaction_Currencies__c;
                    myInitialAccount.Primary_Transaction_Currency__c = myAccount.Primary_Transaction_Currency__c;

                    // Get the partner programs for the multi
                    if(opportunity.Campaign_Program__c != null && opportunity.Campaign_Program__r.Program__c != null) {
                        List<Program__c> programs = [SELECT Id, Partner__c, Always_Require_PG__c FROM Program__c WHERE Id =: opportunity.Campaign_Program__r.Program__c and Publish_BOCA__c = true];

                        if(programs.size() > 0) {
                            programId = programs[0].Id;
                            partnerId = programs[0].Partner__c;
                            selectedPrograms = programs[0].Id;
                            if(programs[0].Always_Require_PG__c == true) {
                                disablePGToggle = true;
                            }
                        }
                        else {
                            throw new bocaToProspectException('The selected program is not configured for BOCA.');
                        }
                    }

                    List<User> salesReps = [SELECT Id, Name, FirstName, LastName, Email, Phone, Sales_Code__c FROM User WHERE Id =: opportunity.OwnerId LIMIT 1];

                    if(salesReps.size() > 0) {

                        salesRep = salesReps[0];

                        List<OpportunityContactRole> contactIds = [SELECT Id, ContactId FROM OpportunityContactRole WHERE OpportunityId =: opportunity.Id and IsPrimary = true LIMIT 1];

                        if(contactIds.size() > 0) {

                            contact = [SELECT Id, FirstName, LastName, Email, Phone, Title FROM Contact WHERE Id =: contactIds[0].ContactId];

                            // Get the non-primary contacts and their roles for the additional contact section
                            additionalContacts = new List<OpportunityContactRole>();
                            for(OpportunityContactRole additionalContact : [SELECT ContactId, Contact.FirstName, Contact.LastName, Contact.Email, Role FROM OpportunityContactRole WHERE OpportunityId =: opportunity.Id and IsPrimary = false]) {
                                additionalContacts.add(additionalContact);
                            }

                        }
                        else {
                            throw new bocaToProspectException('Please ensure you have a primary contact selected!');
                        }

                    }

                    disablePG = false;
                    alwaysRequirePG = false;

                }
                else {
                    throw new bocaToProspectException('Unable to find opportunity.');
                }

            }

        } catch (Exception e) {

            errorCode = logError(e);

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));

        }

    }

    public PageReference bocaToProspect() {

        PageReference redirect = null;

        try {

            if(contact != null && salesRep != null && opportunity != null) {

                if(myInitialAccount.Industry != myAccount.Industry ||
                        myInitialAccount.Customer_s_Primary_Location__c != myAccount.Customer_s_Primary_Location__c ||
                        myInitialAccount.Customer_s_Primary_Travel_Location__c != myAccount.Customer_s_Primary_Travel_Location__c ||
                        myInitialAccount.Other_Transaction_Currencies__c != myAccount.Other_Transaction_Currencies__c ||
                        myInitialAccount.Primary_Transaction_Currency__c != myAccount.Primary_Transaction_Currency__c) update myAccount;

                Program__c program = WexBrandingController.getProgram(selectedPrograms);

                CP_Application_Request__c creditApp = new CP_Application_Request__c();

                creditApp.Application_Stage__c = 'Application';
                creditApp.Status__c = 'Sent to Prospect';

                creditApp.First_Name__c = contact.FirstName;
                creditApp.Last_Name__c = contact.LastName;
                creditApp.Email__c = contact.Email;

                creditApp.Account__c = opportunity.AccountId;
                creditApp.Opportunity__c = opportunity.Id;
                creditApp.Program__c = opportunity.Campaign_Program__r.Program__c;
                creditApp.Sales_Rep__c = salesRep.Id;
                creditApp.OwnerId = opportunity.OwnerId;

                creditApp.Company_Legal_Name__c = opportunity.Name;
                creditApp.Doing_Business_As__c = opportunity.Doing_Business_As__c;

                creditApp.Legal_Structure__c = opportunity.Legal_Structure__c;
                //Convert to whole numbers because Opty uses two decimal places
                if(opportunity.Years_In_Business__c != null) creditApp.Years_in_Business__c = String.valueOf(opportunity.Years_In_Business__c).substringBefore('.');

//                creditApp.Billing_Address_Line_1__c = opportunity.Billing_Street__c;
//                creditApp.Billing_Address_Line_2__c = opportunity.Billing_Street_Line_2__c;
//                creditApp.Billing_City__c = opportunity.Billing_City__c;
//                creditApp.Billing_State__c = opportunity.Billing_State__c;
//                creditApp.Billing_Postal_Code__c = opportunity.Billing_Zip_Postal_Code__c;

                creditApp.Physical_Address_Line_1__c = opportunity.Physical_Street__c;
                creditApp.Physical_Address_Line_2__c = opportunity.Physical_Street_Line_2__c;
                creditApp.Physical_City__c = opportunity.Physical_City__c;
                creditApp.Physical_State_Province__c = opportunity.Physical_State__c;
                creditApp.Physical_Postal_Code__c = opportunity.Physical_Zip_Postal_Code__c;
                creditApp.Business_Phone__c = String.isEmpty(opportunity.Account_Phone__c) ? '' : opportunity.Account_Phone__c.replaceAll('[^0-9]', '');

                creditApp.Taxpayer_ID__c = opportunity.Tax_Payer_ID__c;
                creditApp.DUNS_Number__c = opportunity.DUNS_Number__c;
                creditApp.Industry__c = myAccount.Industry;
                creditApp.Projected_Monthly_Spend__c = opportunity.Credit_Limit__c;
                creditApp.Billing_Cycle__c = opportunity.Billing_Cycle__c;

                creditApp.Guarantor_First_Name__c = opportunity.Guarantor_Name__c;
                creditApp.Guarantor_Last_Name__c = opportunity.Guarantor_Last_Name__c;
                creditApp.Guarantor_Residential_Address__c = opportunity.Guarantor_address_line_1__c;
                creditApp.Guarantor_Residential_City__c = opportunity.Guarantor_City__c;
                creditApp.Guarantor_Country__c = 'US'; // hard coded country until CA address available on BOCAs
                creditApp.Guarantor_State_Province__c = opportunity.Guarantor_State__c;
                creditApp.Guarantor_Residential_Postal_Code__c = opportunity.Guarantor_Zip_code__c;
                creditApp.Guarantor_Residential_Phone__c = opportunity.Guarantor_home_phone__c;

                upsert creditApp;

                System.debug('### Disable PG: ' + disablePG);
                System.debug('### Always PG: ' + alwaysRequirePG);

                // Generating a security key and URL - need the resulting ID first..
                Datetime dt = Datetime.now();
                Long l = dt.getTime();

                String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                creditApp.Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));

                String myURL = 'https://' + Label.External_Instance_URL + '/creditapplication/' + program.Form_Template__c + '?pgm=' + program.Brand_Short_Name__c + '&customer=' + creditApp.Id + '&key=' + creditApp.Application_Key__c;
                if(hideTNC) myURL += '&tnc=000';
                creditApp.External_Application_URL__c = myURL;
                upsert creditApp;

                // Insert into our joiner object to enable tracking/etc
                bocaToProspect = new BOCA_To_Prospect__c();

                bocaToProspect.Opportunity__c = opportunity.Id;
                bocaToProspect.CorporatePayments_Application_Request__c = creditApp.Id;
                bocaToProspect.Contact__c = contact.Id;
                bocaToProspect.Sent__c = Date.today();
                bocaToProspect.Additional_Programs__c = selectedPrograms;
                bocaToProspect.Disable_PG__c = disablePG;
                bocaToProspect.Always_Require_PG__c = alwaysRequirePG;
                bocaToProspect.Custom_Message__c = customMessage;

                insert bocaToProspect;

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setTemplateId(bocaToProspectTemplateId);
                mail.setWhatId(bocaToProspect.Id);
                mail.setTargetObjectId(contact.Id);
                mail.SetSaveAsActivity(false);
                mail.setReplyTo(salesRep.Email);
                mail.setSenderDisplayName(salesRep.Name);

                System.debug('### ' + attachments);

                String[] additionalContacts = new List<String>();

                if(!String.isEmpty(selectedAdditionalContacts)) {
                    additionalContacts = (List<String>)JSON.deserialize(selectedAdditionalContacts, List<String>.class);
                }

                if(!String.isEmpty(ccEmail)) {
                    String[] ccAddresses = ccEmail.split(',');
                    for(Integer i = 0; i < ccAddresses.size(); i++) {
                        additionalContacts.add((String.valueOf(ccAddresses[i])).replaceAll('(\\s+)', ' '));
                    }
                }

                if(additionalContacts.size() > 0) {
                    mail.setCCAddresses(additionalContacts);
                }

                if(attachments != null && !String.isEmpty(attachments)) {

                    List<String> fileAttachments = (List<String>)JSON.deserialize(attachments, List<String>.class);

                    List<Messaging.Emailfileattachment> emailAttachments = new List<Messaging.Emailfileattachment>();

                    for(String fileId : fileAttachments) {
                        Document document = [SELECT Id, Name, Body, Type, IsInternalUseOnly FROM Document WHERE Id =: fileId];

                        if(document != null && document.IsInternalUseOnly == false) {
                            Messaging.Emailfileattachment emailFileAttachment = new Messaging.Emailfileattachment();
                            emailFileAttachment.setFileName(document.Name + '.' + document.Type);
                            emailFileAttachment.setBody(document.Body);
                            emailAttachments.add(emailFileAttachment);
                        }

                    }

                    if(emailAttachments.size() > 0) {
                        mail.setFileAttachments(emailAttachments);
                    }
                }

                if(!Test.isRunningTest() && mail != null) {
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    if (!results.get(0).isSuccess()) {
                        throw new bocaToProspectException(String.valueOf(results.get(0).getErrors()[0]));
                    }
                    else {
                        redirect = Page.BOCAToProspect;
                        redirect.getParameters().put('bocaToProspectConfirm', 'true');
                        redirect.setRedirect(true);
                        return redirect;
                    }
                }
            }
            else {
                throw new bocaToProspectException('General Fault');
            }

        } catch (Exception e) {

            errorCode = logError(e);

            redirect = Page.BOCAToProspect;
            redirect.getParameters().put('bocaToProspectConfirm', 'false');
            redirect.getParameters().put('errorCode', errorCode);
            redirect.setRedirect(true);
            return redirect;

        }

        return redirect;

    }

    public PageReference resendBOCAToProspect() {

        PageReference redirect = null;

        try {

            List<CP_Application_Request__c> cpApplications = [SELECT Id, Application_Key__c, External_Application_URL__c, Program__r.Brand_Short_Name__c, Program__r.Form_Template__c, Opportunity__c, Opportunity__r.Beneficial_Owner_Entity__c FROM CP_Application_Request__c WHERE Id = :applicationId LIMIT 1];

            if (cpApplications.size() > 0) {

                // Set an application key if it isn't there
                if (cpApplications[0].Application_Key__c == null) {

                    Datetime dt = Datetime.now();
                    Long l = dt.getTime();

                    String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                    cpApplications[0].Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));
                }

                // Set the application URL, for ease of picking up in the e-mail
                //if (onlineApplications[0].External_Application_URL__c == null) {
                String myURL = 'https://' + Label.External_Instance_URL + '/creditapplication/' + cpApplications[0].Program__r.Form_Template__c + '?customer=' + cpApplications[0].Id;
                if (cpApplications[0].Program__r.Brand_Short_Name__c != null) myURL += '&pgm=' + cpApplications[0].Program__r.Brand_Short_Name__c;
                if (cpApplications[0].Application_Key__c != null) myURL += '&key=' + cpApplications[0].Application_Key__c;

                cpApplications[0].External_Application_URL__c = myURL;

                //}

                // Kick the stage back to "Application/App-Incomplete"
                cpApplications[0].Application_Stage__c = 'Application';
                cpApplications[0].Status__c = 'App-Incomplete';

                upsert cpApplications[0];

                if (cpApplications[0].Opportunity__r.Beneficial_Owner_Entity__c != null) {

                    // Clone Beneficial Owner Entity
                    system.debug(cpApplications[0]);
                    Id newBeneficialOwnerRecord = BeneficialOwnerUtilities.deepCloneBORecord(cpApplications[0].Opportunity__r.Beneficial_Owner_Entity__c);

                    if (newBeneficialOwnerRecord != null) {

                        List<Beneficial_Owner_Entity__c> newBOEntity = [SELECT Id, Save_For_Later_Date__c, Save_For_Later_Key__c, Save_For_Later_URL__c FROM Beneficial_Owner_Entity__c WHERE Id = :newBeneficialOwnerRecord LIMIT 1];

                        if (newBOEntity.size() > 0) {

                            String cacheControl = String.valueOf(DateTime.Now().format('yyyyMMddHHmmssFFF'));

                            newBOEntity[0].Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/appl/BOCertification?applicationId=' + cpApplications[0].Id + '&formKey=' + cpApplications[0].Application_Key__c + '&entityId=' + newBOEntity[0].Id + '&cacheControl=' + cacheControl;
                            newBOEntity[0].Save_For_Later_Key__c = cpApplications[0].Application_Key__c;
                            newBOEntity[0].Save_For_Later_Date__c = Date.Today();
                            newBOEntity[0].Record_Status__c = 'Awaiting Customer';

                            upsert(newBOEntity[0]);

                        }

                        // Can't forget the children
                        BeneficialOwnerUtilities.cloneProngsToNew(cpApplications[0].Opportunity__r.Beneficial_Owner_Entity__c, newBeneficialOwnerRecord);

                    }

                }

            }


            bocaToProspect = new BOCA_To_Prospect__c();

            bocaToProspect.Opportunity__c = cpApplications[0].Opportunity__c;
            bocaToProspect.Online_Application__c = applicationId;
            bocaToProspect.Contact__c = contact.Id;

            bocaToProspect.Last_Reminder_Sent__c = Date.today();
            bocaToProspect.Custom_Message__c = customMessage;

            upsert bocaToProspect;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setTemplateId(bocaToProspectResendTemplateId);
            mail.setWhatId(bocaToProspect.Id);
            mail.setTargetObjectId(contact.Id);
            mail.SetSaveAsActivity(false);
            mail.setReplyTo(salesRep.Email);
            mail.setSenderDisplayName(salesRep.Name);

            String[] additionalContacts = new List<String>();

            if (!String.isEmpty(selectedAdditionalContacts)) {
                additionalContacts = (List<String>) JSON.deserialize(selectedAdditionalContacts, List<String>.class);
            }

            if (!String.isEmpty(ccEmail)) {
                String[] ccAddresses = ccEmail.split(',');
                for (Integer i = 0; i < ccAddresses.size(); i++) {
                    additionalContacts.add((String.valueOf(ccAddresses[i])).replaceAll('(\\s+)', ' '));
                }
            }

            if (additionalContacts.size() > 0) {
                mail.setCCAddresses(additionalContacts);
            }

            if (attachments != null && !String.isEmpty(attachments)) {

                List<String> fileAttachments = (List<String>) JSON.deserialize(attachments, List<String>.class);

                List<Messaging.Emailfileattachment> emailAttachments = new List<Messaging.Emailfileattachment>();

                for (String fileId : fileAttachments) {
                    Document document = [SELECT Id, Name, Body, Type, IsInternalUseOnly FROM Document WHERE Id = :fileId];

                    if (document != null && document.IsInternalUseOnly == false) {
                        Messaging.Emailfileattachment emailFileAttachment = new Messaging.Emailfileattachment();
                        emailFileAttachment.setFileName(document.Name + '.' + document.Type);
                        emailFileAttachment.setBody(document.Body);
                        emailAttachments.add(emailFileAttachment);
                    }

                }

                if (emailAttachments.size() > 0) {
                    mail.setFileAttachments(emailAttachments);
                }
            }

            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}, !Test.isRunningTest());
            if((!results.get(0).isSuccess() && !Test.isRunningTest()) || (Test.isRunningTest() && Limits.getEmailInvocations()<1)) throw new bocaToProspectException(String.valueOf(results.get(0).getErrors()[0]));

            Task reminderSentTask = new Task();

            reminderSentTask.WhatId = bocaToProspect.Opportunity__c;
            reminderSentTask.OwnerId = UserInfo.getUserId();
            reminderSentTask.Status = 'Completed';
            reminderSentTask.Subject = 'BOCA Re-sent To Prospect';
            reminderSentTask.ActivityDate = Date.today();
            reminderSentTask.Type = 'Email';
            reminderSentTask.Activity_Type__c = 'Email';

            insert reminderSentTask;

            bocaToProspect.Last_Reminder_Sent__c = Date.today();

            upsert bocaToProspect;


            redirect = Page.OTRBOCAToProspect;
            redirect.getParameters().put('bocaToProspectConfirm', 'true');
            redirect.setRedirect(true);
            return redirect;


        } catch (Exception e) {

            errorCode = logError(e);

            redirect = Page.OTRBOCAToProspect;
            redirect.getParameters().put('bocaToProspectConfirm', 'false');
            redirect.getParameters().put('errorCode', errorCode);
            redirect.setRedirect(true);
            return redirect;

        }

    }

    public PageReference bocaToProspectReminder(){

        PageReference redirect = null;

        try {

            bocaToProspect.Last_Reminder_Sent__c = Date.today();
            bocaToProspect.Additional_Programs__c = selectedPrograms;
            bocaToProspect.Disable_PG__c = disablePG;
            bocaToProspect.Always_Require_PG__c = alwaysRequirePG;
            bocaToProspect.Custom_Message__c = customMessage;

            upsert bocaToProspect;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setTemplateId(bocaToProspectTemplateId);
            mail.setWhatId(bocaToProspect.Id);
            mail.setTargetObjectId(contact.Id);
            mail.SetSaveAsActivity(false);
            mail.setReplyTo(salesRep.Email);
            mail.setSenderDisplayName(salesRep.Name);

            String[] additionalContacts = new List<String>();

            if(!String.isEmpty(selectedAdditionalContacts)) {
                additionalContacts = (List<String>)JSON.deserialize(selectedAdditionalContacts, List<String>.class);
            }

            if(!String.isEmpty(ccEmail)) {
                String[] ccAddresses = ccEmail.split(',');
                for(Integer i = 0; i < ccAddresses.size(); i++) {
                    additionalContacts.add((String.valueOf(ccAddresses[i])).replaceAll('(\\s+)', ' '));
                }
            }

            if(additionalContacts.size() > 0) {
                mail.setCCAddresses(additionalContacts);
            }

            if(attachments != null && !String.isEmpty(attachments)) {

                List<String> fileAttachments = (List<String>)JSON.deserialize(attachments, List<String>.class);

                List<Messaging.Emailfileattachment> emailAttachments = new List<Messaging.Emailfileattachment>();

                for(String fileId : fileAttachments) {
                    Document document = [SELECT Id, Name, Body, Type, IsInternalUseOnly FROM Document WHERE Id =: fileId];

                    if(document != null && document.IsInternalUseOnly == false) {
                        Messaging.Emailfileattachment emailFileAttachment = new Messaging.Emailfileattachment();
                        emailFileAttachment.setFileName(document.Name + '.' + document.Type);
                        emailFileAttachment.setBody(document.Body);
                        emailAttachments.add(emailFileAttachment);
                    }

                }

                if(emailAttachments.size() > 0) {
                    mail.setFileAttachments(emailAttachments);
                }
            }

            if(!Test.isRunningTest()) {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                if (!results.get(0).isSuccess()) {
                    throw new bocaToProspectException(String.valueOf(results.get(0).getErrors()[0]));
                }
            }

            Task reminderSentTask = new Task();

            reminderSentTask.WhatId = bocaToProspect.Opportunity__c;
            reminderSentTask.OwnerId = UserInfo.getUserId();
            reminderSentTask.Status = 'Completed';
            reminderSentTask.Subject = 'BOCA Reminder was Sent';
            reminderSentTask.ActivityDate = Date.today();
            reminderSentTask.Type = 'Email';
            reminderSentTask.Activity_Type__c = 'Email';

            insert reminderSentTask;

            bocaToProspect.Last_Reminder_Sent__c = Date.today();

            upsert bocaToProspect;

            redirect = Page.BOCAToProspect;
            redirect.getParameters().put('bocaToProspectConfirm', 'true');
            redirect.setRedirect(true);
            return redirect;


        } catch (Exception e) {

            errorCode = logError(e);

            redirect = Page.BOCAToProspect;
            redirect.getParameters().put('bocaToProspectConfirm', 'false');
            redirect.getParameters().put('errorCode', errorCode);
            redirect.setRedirect(true);
            return redirect;

        }

    }

    public class bocaToProspectException extends Exception {}

    public String logError(Exception e) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            String errorMessage = String.valueOf(e);

            if(errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                errorMessage = '[VALIDATION] ' + errorMessage.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ', ': ');
            }
            else if(errorMessage.contains('EMAIL_ADDRESS_BOUNCED')) {
                errorMessage = '[EMAIL] The primary contact e-mail address is currently marked as \"Bounced\". Please verify the e-mail address and try again.';
            }
            else if(errorMessage.contains('NO_MASS_MAIL_PERMISSION')) {
                errorMessage = '[EMAIL] Outbound e-mails are currently disabled for this Salesforce ORG. Please consult your Salesforce Admin.';
            }
            else if(errorMessage.contains('STRING_TOO_LONG')) {
                errorMessage = '[VALUE TOO LONG] ' + errorMessage.substringBetween('STRING_TOO_LONG, ', ': ');
            }

            error.Error_Message__c = errorMessage;
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'BOCAToProspect';
            error.Application_URL__c = applicationURL;

            insert error;

            List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id = :error.Id];

            if(!errors.isEmpty()) {
                return errors[0].Name;
            }
            else {
                return '';
            }

        }
        catch(Exception f) {

            System.debug('Error logging exception.. Skipping..');

            return '';

        }
    }

}