/*
Description:        controller for otrbocatoprospect
Test Classes:       OTRBOCAToProspectTest
Last Coverage:      98%
Revision History:   4/12/2019 Jason Arbegast IADJUDICAT-1085 limit program options to those related to the partner
TODO:               move logerror to utility method; can be used across classes and easier to test the individual method that way
                    move email sections to utility/class method; similar code is in place across methods
 */
public class OTRBOCAToProspectController {

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
            if (bocaToProspectId == null)
                return ApexPages.CurrentPage().getParameters().get('bocaToProspectId');
            return bocaToProspectId;
        }
        set;
    }

    public String bocaToProspectConfirm {
        get {
            if (bocaToProspectConfirm == null)
                return ApexPages.CurrentPage().getParameters().get('bocaToProspectConfirm');
            return bocaToProspectConfirm;
        }
        set;
    }

    public Boolean resend {
        get {
            if (!String.isEmpty(ApexPages.CurrentPage().getParameters().get('resend')))
                return Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('resend'));
            return false;
        }
    }

    public BOCA_To_Prospect__c bocaToProspect { get; set; }

    // The opportunity pulled in from the ID parameter
    public Opportunity opportunity { get; set; }

    // The primary role contact pulled from the opportunity
    public Contact contact { get; set; }

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

    public String customMessage { get; set; }

    public String ccEmail { get; set; }

    public String errorCodeDescription { get; set; }

    public String attachments { get; set; }

    public Id selectedProgram { get; set; }

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
            String uType = UserInfo.getUserType();

            //from user get contact then account then program then partner
            if(uType == 'Partner'){
                User u = [SELECT Contact.Account.Program__r.Partner__c FROM User WHERE Id = :uid LIMIT 1];
                partnerId = u.Contact.Account.Program__r.Partner__c;
            }

            //assemble the query for possible programs.
            String myQuery = 'SELECT Id, Name FROM Program__c WHERE BOCA_Type__c = \'OTR\' and Publish_BOCA__c = true';
            if(uType == 'Partner' || (uType != 'Partner' && partnerId != null))
                myQuery += ' AND Partner__c = :partnerId';
            myQuery += ' ORDER BY Name ASC';

            //if we have inside sales rep, or we have a partner AND a partnerid, add programs to drop down. if partner user but no partnerid, don't show anything
            if(uType != 'Partner' || (uType == 'Partner' && partnerId != null)){
                for (Program__c program : database.query(myQuery)) {
                    availablePrograms.add(new SelectOption(program.Id, program.Name));
                }
            }

            return availablePrograms;
        }
    }

    public Id selectedOffer { get; set; }

    public List<SelectOption> availableOffers {
        get {
            List<SelectOption> availableOffers = new List<SelectOption>();

            availableOffers.add(new SelectOption('', '-- Choose One --'));
            for (OnlineApplicationOffer__c offer : [SELECT Id, Name FROM OnlineApplicationOffer__c WHERE Program__c = :selectedProgram ORDER BY Name ASC]) {
                availableOffers.add(new SelectOption(offer.Id, offer.Name));
            }

            return availableOffers;
        }
    }

    public Map<String, String> associatedOffers {
        get {
            return null;
        }

    }

    public String selectedAdditionalContacts { get; set; }

    public List<OpportunityContactRole> additionalContacts { get; set; }

    public Boolean hasAdditionalContacts {
        get {
            if (additionalContacts != null && additionalContacts.size() > 0)
                return true;
            return false;
        }
    }

    public String bocaToProspectTemplateId {
        get {
            BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();
            return bocaToProspectSettings.OTR_Email_Template_ID__c;
        }
    }

    public String bocaToProspectResendTemplateId {
        get {
            BOCA_To_Prospect_Settings__c bocaToProspectSettings = BOCA_To_Prospect_Settings__c.getOrgDefaults();
            return bocaToProspectSettings.OTR_Resend_Template_ID__c;
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
            if (opportunityId == null)
                return ApexPages.CurrentPage().getParameters().get('id');
            return opportunityId;
        }
        set;
    }

    // Get the full URL for the page
    private String applicationURL {
        get {
            String hostVal = ApexPages.currentPage().getHeaders().get('Host');
            String urlVal = Apexpages.currentPage().getUrl();
            urlVal = EncodingUtil.urlEncode(urlVal, 'UTF-8');
            string[] urlValExtra = urlVal.split('%3F', 0);
            urlVal = urlValExtra[0];
            urlVal = EncodingUtil.urlDecode(urlVal, 'UTF-8');
            return 'https://' + hostVal + urlVal;
        }
    }

    public String errorCode { get; set; }

    public OTRBOCAToProspectController(ApexPages.StandardController ctrl) {

    }

    public void init() {

        try {

            if (bocaToProspectConfirm != null && !String.isEmpty(bocaToProspectConfirm)) {

                if (bocaToProspectConfirm.equals('true')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'BOCA To Prospect Sent!'));
                } else {
                    errorCode = ApexPages.CurrentPage().getParameters().get('errorCode');

                    if (errorCode != null) {
                        List<Internal_Application_Error__c> error = [SELECT Id, Error_Message__c FROM Internal_Application_Error__c WHERE Name = :errorCode];

                        if (error.size() > 0) {
                            errorCodeDescription = error[0].Error_Message__c;
                        } else {
                            errorCodeDescription = 'General Fault';
                        }
                    }

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorCodeDescription + '  <br><br>The support organization has been notified. Your error tracking number is: ' + errorCode));
                }

            } else {

                if (applicationId != null) {

                    List<OnlineApplication__c> onlineApplications = [SELECT Id, Opportunity__c, Program__c, Offer__c FROM OnlineApplication__c WHERE Id =: applicationId];

                    if(onlineApplications.size() > 0) {
                        opportunityId = onlineApplications[0].Opportunity__c;
                        selectedProgram = onlineApplications[0].Program__c;
                        selectedOffer = onlineApplications[0].Offer__c;
                    }

                    customMessage = 'Please click the link below to correct your application and re-submit.';

                }

                if (bocaToProspectId != null) {
                    List<BOCA_To_Prospect__c> bocaToProspects = [SELECT Id, Online_Application_Offer__c, WeFormObject__r.Program__c, Opportunity__c, WeFormObject__r.Program__r.BOCA_To_Prospect_Template__c, Additional_Programs__c, WeFormObject__r.Online_Application__r.External_Application_URL__c FROM BOCA_To_Prospect__c WHERE Id = :bocaToProspectId LIMIT 1];

                    if (bocaToProspects.size() > 0) {
                        bocaToProspect = bocaToProspects[0];
                        opportunityId = bocaToProspect.Opportunity__c;
                        selectedProgram = bocaToProspect.WeFormObject__r.Program__c;
                        selectedOffer = bocaToProspect.Online_Application_Offer__c;
                    }
                }

                if (bocaToProspect == null) {
                    bocaToProspect = new BOCA_To_Prospect__c();
                }

                System.debug('### Opportunity ID: ' + opportunityId);

                List<Opportunity> opportunities = [
                        SELECT Id, AccountId, Account.Name, Campaign_Program__r.Program__r.Name, Campaign_Program__r.Program__c, name, OwnerId, Application_Signer_City__c,
                                Application_Signer_Address__c, Application_Signer_First_Name__c, Application_Signer_Last_Name__c, Application_Signer_Email_Address__c,
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
                                Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode,
                                Promotional_Code__c, Coupon_Code2__c, Campaign_Program__r.Program__r.BOCA_To_Prospect_Template__c
                        FROM Opportunity
                        WHERE Id = :opportunityId
                ];

                if (opportunities.size() > 0) {

                    opportunity = opportunities[0];

                    if (opportunity.Account != null && opportunity.Account.Name != null && (opportunity.Account.Name).length() > 30) {

                        throw new bocaToProspectException('Account name is greater than 30 characters. Please shorten and try again.');

                    }

                    List<User> salesReps = [SELECT Id, Name, FirstName, LastName, Email, Phone, Territory_Code__c FROM User WHERE Id = :opportunity.OwnerId LIMIT 1];

                    if (salesReps.size() > 0) {

                        salesRep = salesReps[0];

                        List<OpportunityContactRole> contactIds = [SELECT Id, ContactId FROM OpportunityContactRole WHERE OpportunityId = :opportunity.Id and IsPrimary = true LIMIT 1];

                        if (contactIds.size() > 0) {

                            contact = [SELECT Id, FirstName, LastName, Email, Phone, Title FROM Contact WHERE Id = :contactIds[0].ContactId];

                            // Get the non-primary contacts and their roles for the additional contact section
                            additionalContacts = new List<OpportunityContactRole>();
                            for (OpportunityContactRole additionalContact : [SELECT ContactId, Contact.FirstName, Contact.LastName, Contact.Email, Role FROM OpportunityContactRole WHERE OpportunityId = :opportunity.Id and IsPrimary = false]) {
                                additionalContacts.add(additionalContact);
                            }

                        } else {
                            throw new bocaToProspectException('Please ensure you have a primary contact selected!');
                        }

                    }

                } else {
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

            if (contact != null && salesRep != null && opportunity != null) {

                Program__c program = WexBrandingController.getProgram(selectedProgram);

                // Insert the WeFormObject and map as many values from
                // the opportunity as possible..
                OnlineApplication__c onlineApplication = new OnlineApplication__c();

                // REQUIRED!!!!!
                onlineApplication.Application_Stage__c = 'Application';
                onlineApplication.Status__c = 'App-Incomplete';

                onlineApplication.Contact_First_Name__c = contact.FirstName;
                onlineApplication.Contact_Last_Name__c = contact.LastName;
                onlineApplication.Email__c = contact.Email;

                onlineApplication.Opportunity__c = opportunity.Id;
                onlineApplication.Account__c = opportunity.AccountId;
                onlineApplication.Offer__c = selectedOffer;
                onlineApplication.Program__c = selectedProgram;

                onlineApplication.Promotional_Code__c = opportunity.Coupon_Code2__c;
                onlineApplication.Legal_Business_Name__c = opportunity.Account.Name;
                onlineApplication.Business_Street_Address__c = opportunity.Account.ShippingStreet;
                onlineApplication.Business_Address_Line_2__c = (opportunity.Account != null && opportunity.Account.ShippingStreet != null && (opportunity.Account.ShippingStreet).contains(',')) ? (opportunity.Account.ShippingStreet).substringAfter(',') : '';
                onlineApplication.City__c = opportunity.Physical_City__c;
                onlineApplication.Country__c = 'US'; // hard coded country until CA address available on BOCAs
                onlineApplication.State__c = opportunity.Physical_State__c;
                onlineApplication.Zip_code__c = opportunity.Physical_Zip_Postal_Code__c;
                onlineApplication.Federal_Tax_ID__c = opportunity.Tax_Payer_ID__c;
                onlineApplication.Fax_Number__c = String.isEmpty(opportunity.Fax__c) ? '' : opportunity.Fax__c.replaceAll('[^0-9]', '');
                onlineApplication.Phone_Number__c = String.isEmpty(opportunity.Account_Phone__c) ? '' : opportunity.Account_Phone__c.replaceAll('[^0-9]', '');
                onlineApplication.Trade_Name__c = opportunity.Doing_Business_As__c;
                onlineApplication.Years_in_Business__c = String.valueOf(opportunity.Years_In_Business__c);
                onlineApplication.Type_of_Business__c = opportunity.Legal_Structure__c;
                onlineApplication.DUNS__c = opportunity.DUNS_Number__c;
                onlineApplication.Number_of_Trucks__c = opportunity.Fleet_Size__c;

                onlineApplication.AO_First_Name__c = opportunity.Guarantor_Name__c;
                onlineApplication.AO_Last_Name__c = opportunity.Guarantor_Last_Name__c;
                onlineApplication.AO_Address__c = opportunity.Guarantor_address_line_1__c;
                onlineApplication.AO_City__c = opportunity.Guarantor_City__c;
                onlineApplication.AO_Country__c = 'US'; // hard coded country until CA address available on BOCAs
                onlineApplication.AO_State__c = opportunity.Guarantor_State__c;
                onlineApplication.AO_Zip_Code__c = opportunity.Guarantor_Zip_code__c;
                onlineApplication.AO_Home_Phone_Number__c = opportunity.Guarantor_home_phone__c;

                onlineApplication.OwnerId = opportunity.OwnerId;
                onlineApplication.Program__c = selectedProgram;

                upsert onlineApplication;

                // Generating a security key and URL - need the resulting ID first..
                Datetime dt = Datetime.now();
                Long l = dt.getTime();

                String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                onlineApplication.Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));

                onlineApplication.External_Application_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/' + program.Form_Template__c + '?pgm=' + program.Brand_Short_Name__c + '&offer=' + selectedOffer + '&customer=' + onlineApplication.Id + '&key=' + onlineApplication.Application_Key__c;

                upsert onlineApplication;

                // Insert into our joiner object to enable tracking/etc
                bocaToProspect = new BOCA_To_Prospect__c();

                bocaToProspect.Opportunity__c = opportunity.Id;
                bocaToProspect.Online_Application__c = onlineApplication.Id;
                bocaToProspect.Contact__c = contact.Id;
                bocaToProspect.Sent__c = Date.today();
                bocaToProspect.Custom_Message__c = customMessage;
                bocaToProspect.Online_Application_Offer__c = selectedOffer;

                System.debug('TEMP boca to prospect online app: ' + onlineApplication.Id);

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

                redirect = Page.BOCAToProspect;
                redirect.getParameters().put('bocaToProspectConfirm', 'true');
                redirect.setRedirect(true);
                return redirect;

            } else {
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

    }

    public PageReference resendBOCAToProspect() {

        PageReference redirect = null;

        try {

            List<OnlineApplication__c> onlineApplications = [SELECT Id, Application_Key__c, External_Application_URL__c, Program__r.Brand_Short_Name__c, Program__r.Form_Template__c, Offer__c, Opportunity__c, Opportunity__r.Beneficial_Owner_Entity__c FROM OnlineApplication__c WHERE Id = :applicationId LIMIT 1];

            if (onlineApplications.size() > 0) {

                // Set an application key if it isn't there
                if (onlineApplications[0].Application_Key__c == null) {

                    Datetime dt = Datetime.now();
                    Long l = dt.getTime();

                    String salt = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

                    onlineApplications[0].Application_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(l + UserInfo.getSessionId() + salt.substring(0, 25))));
                }

                // Set the application URL, for ease of picking up in the e-mail
                //if (onlineApplications[0].External_Application_URL__c == null) {
                onlineApplications[0].External_Application_URL__c = 'https://' + Label.External_Instance_URL + '/creditapplication/' + onlineApplications[0].Program__r.Form_Template__c + '?pgm=' + onlineApplications[0].Program__r.Brand_Short_Name__c + '&offer=' + onlineApplications[0].Offer__c + '&customer=' + onlineApplications[0].Id + '&key=' + onlineApplications[0].Application_Key__c;
                //}

                // Kick the stage back to "Application/App-Incomplete"
                onlineApplications[0].Application_Stage__c = 'Application';
                onlineApplications[0].Status__c = 'App-Incomplete';

                upsert onlineApplications[0];

                if (onlineApplications[0].Opportunity__r.Beneficial_Owner_Entity__c != null) {

                    // Clone Beneficial Owner Entity
                    system.debug(onlineApplications[0]);
                    Id newBeneficialOwnerRecord = BeneficialOwnerUtilities.deepCloneBORecord(onlineApplications[0].Opportunity__r.Beneficial_Owner_Entity__c);

                    if (newBeneficialOwnerRecord != null) {

                        List<Beneficial_Owner_Entity__c> newBOEntity = [SELECT Id, Save_For_Later_Date__c, Save_For_Later_Key__c, Save_For_Later_URL__c FROM Beneficial_Owner_Entity__c WHERE Id = :newBeneficialOwnerRecord LIMIT 1];

                        if (newBOEntity.size() > 0) {

                            String cacheControl = String.valueOf(DateTime.Now().format('yyyyMMddHHmmssFFF'));

                            newBOEntity[0].Save_For_Later_URL__c = 'https://' + Label.External_Instance_URL + '/appl/BOCertification?applicationId=' + onlineApplications[0].Id + '&formKey=' + onlineApplications[0].Application_Key__c + '&entityId=' + newBOEntity[0].Id + '&cacheControl=' + cacheControl;
                            newBOEntity[0].Save_For_Later_Key__c = onlineApplications[0].Application_Key__c;
                            newBOEntity[0].Save_For_Later_Date__c = Date.Today();
                            newBOEntity[0].Record_Status__c = 'Awaiting Customer';

                            upsert(newBOEntity[0]);

                        }

                        // Can't forget the children
                        BeneficialOwnerUtilities.cloneProngsToNew(onlineApplications[0].Opportunity__r.Beneficial_Owner_Entity__c, newBeneficialOwnerRecord);

                    }

                }

            }


            bocaToProspect = new BOCA_To_Prospect__c();

            bocaToProspect.Opportunity__c = onlineApplications[0].Opportunity__c;
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

    public PageReference bocaToProspectReminder() {

        PageReference redirect = null;

        try {

            bocaToProspect.Last_Reminder_Sent__c = Date.today();
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
            reminderSentTask.Subject = 'BOCA Reminder was Sent';
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

    public void doNothing() {

    }

    public class bocaToProspectException extends Exception {
    }

    private String logError(Exception e) {

        try {

            Internal_Application_Error__c error = new Internal_Application_Error__c();

            String errorMessage = String.valueOf(e);

            if (errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                errorMessage = '[VALIDATION] ' + errorMessage.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ', ': ');
            } else if (errorMessage.contains('EMAIL_ADDRESS_BOUNCED')) {
                errorMessage = '[EMAIL] The primary contact e-mail address is currently marked as \"Bounced\". Please verify the e-mail address and try again.';
            } else if (errorMessage.contains('NO_MASS_MAIL_PERMISSION')) {
                errorMessage = '[EMAIL] Outbound e-mails are currently disabled for this Salesforce ORG. Please consult your Salesforce Admin.';
            } else if (errorMessage.contains('STRING_TOO_LONG')) {
                errorMessage = '[VALUE TOO LONG] ' + errorMessage.substringBetween('STRING_TOO_LONG, ', ': ');
            }

            error.Error_Message__c = errorMessage;
            error.Error_Location__c = String.valueOf(e.getStackTraceString());
            error.Application__c = 'OTRBOCAToProspect';
            error.Application_URL__c = applicationURL;

            insert error;

            List<Internal_Application_Error__c> errors = [SELECT Id, Name FROM Internal_Application_Error__c WHERE Id = :error.Id];

            if (!errors.isEmpty()) {
                return errors[0].Name;
            } else {
                return '';
            }

        } catch (Exception f) {

            System.debug('Error logging exception.. Skipping..');

            return '';

        }
    }

}