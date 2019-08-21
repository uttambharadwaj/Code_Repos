public class CPBOCAToProspectController {

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
            return salesRep.Name;
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

                if(bocaToProspectId != null) {
                    List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Opportunity__c, WeFormObject__r.Program__r.BOCA_To_Prospect_Template__c, Additional_Programs__c FROM BOCA_To_Prospect__c WHERE Id =: bocaToProspectId LIMIT 1];

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
                        Application_Signer_Phone__c, Application_Signer_Zip_Code__c, Application_Signer__c, Application_Signer_title__c, Billing_City__c,
                        Billing_Contact_Email__c, Billing_Contact_Fax__c, Billing_Contact_First_Name__c, Billing_Contact_Last_Name__c,
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

                CP_Application_Request__c creditApp = new CP_Application_Request__c();

                creditApp.Application_Stage__c = 'Application';
                creditApp.Status__c = 'Sent to Prospect';

                creditApp.Account__c = opportunity.AccountId;
                creditApp.Opportunity__c = opportunity.Id;
                creditApp.Program__c = opportunity.Campaign_Program__r.Program__c;
                creditApp.Sales_Rep__c = salesRep.Id;
                creditApp.OwnerId = opportunity.OwnerId;

                creditApp.Company_Legal_Name__c = opportunity.Name;
                creditApp.Doing_Business_As__c = opportunity.Doing_Business_As__c;

                creditApp.Legal_Structure__c = opportunity.Legal_Structure__c;
                creditApp.Years_in_Business__c = String.valueOf(opportunity.Years_In_Business__c);

                creditApp.First_Name__c = contact.FirstName;
                creditApp.Last_Name__c = contact.LastName;
                creditApp.Email__c = contact.Email;

//                creditApp.Billing_Address_Line_1__c = opportunity.Billing_Street__c;
//                creditApp.Billing_Address_Line_2__c = opportunity.Billing_Street_Line_2__c;
//                creditApp.Billing_City__c = opportunity.Billing_City__c;
//                creditApp.Billing_State__c = opportunity.Billing_State__c;
//                creditApp.Billing_Postal_Code__c = opportunity.Billing_Zip_Postal_Code__c;

                creditApp.Physical_Address_Line_1__c = opportunity.Physical_Street__c;
                creditApp.Physical_Address_Line_2__c = opportunity.Physical_Street_Line_2__c;
                creditApp.Physical_City__c = opportunity.Physical_City__c;
                creditApp.Physical_State__c = opportunity.Physical_State__c;
                creditApp.Physical_Postal_Code__c = opportunity.Physical_Zip_Postal_Code__c;

                creditApp.Taxpayer_ID__c = opportunity.Tax_Payer_ID__c;
                creditApp.DUNS_Number__c = opportunity.DUNS_Number__c;
                creditApp.Industry__c = myAccount.Industry;

                upsert creditApp;

                System.debug('### Disable PG: ' + disablePG);
                System.debug('### Always PG: ' + alwaysRequirePG);

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
                    /*List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    if (!results.get(0).isSuccess()) {
                        throw new bocaToProspectException(String.valueOf(results.get(0).getErrors()[0]));
                    }
                    else {*/
                        redirect = Page.BOCAToProspect;
                        redirect.getParameters().put('bocaToProspectConfirm', 'true');
                        redirect.setRedirect(true);
                        return redirect;
                    //}
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