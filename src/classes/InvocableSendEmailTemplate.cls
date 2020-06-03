/*
Description:        Invocable class for adding attachments to email template
Test Classes:       InvocableSendEmailTemplateTest
Last Coverage:      100%
Revision History:   3/29/2019 Jason Arbegast IADJUDICAT-746 created class with method for sending email templates from dreaded process builder
                    20May2020   MFarrell    EAPT-1865   Added ability to look up contacts on an account and CC them on the final email
 */
public with sharing class InvocableSendEmailTemplate {


    public class EmailWrapper{
        /*TDOD: petition to change name of this EmailWrapper sub class to Eminem
                                        .
                                        .
                                        .
                                        .
                                        .
                                        .
                                    E male rapper

           complete gold right there
        */
        //if attachment is desired, this is required.
        @InvocableVariable(label='attachmentParentId' required=true)
        public String attachmentParentId; //id of attachment's parent

        //either this or attachment name must be filled out.
        @InvocableVariable(label='attachmentParentField')
        public String attachmentParentField; //api field name of field, on parent, that contains name of attachment

        //either this or attachment parent field must be filled out
        @InvocableVariable(label='attachmentName')
        public String attachmentName; //name of attachment, if known

        @InvocableVariable(label='saveAsActivity')
        public Boolean saveAsActivity = false; //do we want to save this email as an activity on the record?

        @InvocableVariable(label='templateId' required=true)
        public Id templateId; //id of desired email template

        @InvocableVariable(label='toRecipients' required=true)
        public String toRecipients;

        @InvocableVariable(label='ccRecipients')
        public String ccRecipients;

        @InvocableVariable(Label='contactTypes')
        public String contactTypes;

        @InvocableVariable(Label='AccountId')
        public Id accountId;

        @InvocableVariable(Label='TerritoryCode')
        public String territoryCode;

        @InvocableVariable(Label='SalesRepRoles')
        public String salesRepRoles;

        @InvocableVariable(label='whatId')
        public Id whatId; //id for merge field population

        @InvocableVariable(label='targetObjId' required=true)
        public Id targetObjId; //must be contact if we are using whatid;

        @InvocableVariable(label='sendToTarget')
        public Boolean sendToTarget = false; //do we want to send this to the targetObjectId email as well?

        @InvocableVariable(label='orgWideEmailId')
        public Id orgWideEmailId;
    }

    /*
      IADJUDICAT-746  auto-attach file to email template
      description:    given various parameters, attach file and send email
      known usage:    Online Application Created & Edited Process (process builder)
      test method:    InvocableSendEmailTemplateTest.testSendEmailTemplate
    */
    @InvocableMethod(label='Send Template With Attachment' description='sends email template with an attachment')
    public static void sendEmailTemplate(List<EmailWrapper> emailWrappers) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        //get attachment based on provided info
        Map<Id, String> parentIdToAttchName = getAttachmentMap(emailWrappers);
        //get contact emails from the account by contact type
        List<String> contactEmails = getContactEmailsByRole(emailWrappers);
        //get sales rep emails by territory code
        List<String> salesRepEmails = getSalesReps(emailWrappers);

        for(EmailWrapper ew : emailWrappers){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            List<String> toEmails = new List<String>();
            List<String> ccEmails = new List<String>();
            String targetId = ew.targetObjId;

            //turn recipients strings into list
            if(ew.toRecipients != null && ew.toRecipients.length()>0)
                toEmails = ew.toRecipients.split(',');
            if(ew.ccRecipients!= null && ew.ccRecipients.length()>0)
                ccEmails = ew.ccRecipients.split(',');

            if (contactEmails.size() > 0) {
                ccEmails.addAll(contactEmails);
            }
            if (salesRepEmails.size() > 0) {
                ccEmails.addAll(salesRepEmails);
            }

            email.setToAddresses(toEmails);
            email.setCcAddresses(ccEmails);

            //also need targetobject if template is populated
            if(ew.templateId != null && ew.targetObjId != null)
                email.setTemplateId(ew.templateId);

            //if whatid is populated, targetObjId must be populated as well, and it must be a contact.
            if(ew.whatId != null && ew.targetObjId.getSobjectType().getDescribe().getName() == 'Contact')
                email.setWhatId(ew.whatId);

            email.setTargetObjectId(ew.targetObjId); //required with template

            String theAttachment = parentIdToAttchName.get(ew.attachmentParentId);
            if(theAttachment != null)
                email.setEntityAttachments(new List<Id>{theAttachment}); // ids of any attachments to include...currently limited to only one

            email.setOrgWideEmailAddressId(ew.orgWideEmailId);
            email.setSaveAsActivity(ew.saveAsActivity);
            email.setTreatTargetObjectAsRecipient(ew.sendToTarget);

            emailsToSend.add(email);

        }

        Messaging.sendEmail(emailsToSend, false);

    }

    /*
      IADJUDICAT-746  auto-attach file to email template
      description:    find a specific attachment for each emailwrapper based attachment parent information
      known usage:    InvocableSendEmailTemplate.sendEmailTemplate
      test method:    InvocableSendEmailTemplateTest.testGetAttachmentMap
    */
    public static Map<Id,String> getAttachmentMap(List<EmailWrapper> emailWrappers){
        Map<Id, String> parentIdToFieldName = new Map<Id, String>();
        Map<Id, String> parentIdToAttchName = new Map<Id, String>();
        String oneParentId;

        //iterate over email wrapper thingy. we might need attachments. we might not.
        for(EmailWrapper ew : emailWrappers){
            if(ew.attachmentParentId != null){
                oneParentId = ew.attachmentParentId;
                if(ew.attachmentParentField != null)
                    parentIdToFieldName.put(ew.attachmentParentId, ew.attachmentParentField);
                if(ew.attachmentName != null)
                    parentIdToAttchName.put(ew.attachmentParentId, ew.attachmentName);
            }
        }

        //appears we are storing an attachment's name on a custom field. have to query it.
        if(parentIdToFieldName.size()>0){
            String objType = Id.valueOf(oneParentId).getSobjectType().getDescribe().getName();
            if(objType != null){
                Set<Id> theParentIds = new Set<Id>(parentIdToFieldName.keySet());
                Set<String> allFieldNames = new Set<String>(parentIdToFieldName.values());
                String allTheFields = String.join(new List<String>(allFieldNames), ',');
                String myQuery = 'SELECT Id, ' + allTheFields + ' FROM ' + objType + ' WHERE Id IN :theParentIds';
                for(SObject so : Database.query(myQuery)){
                    String thisAttachName = parentIdToFieldName.get(so.Id);
                    parentIdToAttchName.put(so.Id, (String)so.get(thisAttachName));
                }
            }
        }

        //get the ids for the attachments
        if(parentIdToAttchName.size()>0){
            Set<String> allAttachNames = new Set<String>(parentIdToAttchName.values());
            for(Attachment a : [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :parentIdToAttchName.keySet() AND Name IN :allAttachNames]){
                parentIdToAttchName.put(a.ParentId, a.Id);
            }
        }
        return parentIdToAttchName;
    }

    public static List<String> getContactEmailsByRole(List<EmailWrapper> emailWrappers) {
        List<String> contactEmails = new List<String>();
        List<Contact> contacts = new List<Contact>();
        Map<Id, List<String>> accountToContactRoleMap = new Map<Id, List<String>>();

        for (EmailWrapper ew : emailWrappers) {
            if (ew.contactTypes != null && ew.contactTypes != '' && ew.accountId != null) {
                accountToContactRoleMap.put(ew.accountId, ew.contactTypes.split(','));
            }

        }

        contacts = [SELECT Id, Email, AccountId, Contact_Type__c FROM Contact WHERE AccountId =: accountToContactRoleMap.keySet() AND Email != NULL AND Contact_Type__c != NULL];

        if (contacts.size() > 0) {
            for (Contact c : contacts) {
                for (String type : accountToContactRoleMap.get(c.AccountId)) {
                    if (c.Contact_Type__c == type) {
                        contactEmails.add(c.Email);
                    }
                }
            }
        }

        return contactEmails;
    }

    public static List<String> getSalesReps(List<EmailWrapper> emailWrappers) {
        List<String> salesRepEmails = new List<String>();
        List<User> salesReps = new List<User>();
        Map<String, List<String>> territoryCodeToSalesRepRole = new Map<String, List<String>>();

        for (EmailWrapper ew : emailWrappers) {
            if (ew.territoryCode != null && ew.territoryCode != '' && ew.salesRepRoles != null && ew.salesRepRoles != '') {
                 territoryCodeToSalesRepRole.put(ew.territoryCode, ew.salesRepRoles.split(','));
            }
        }
        salesReps = [SELECT Id, Email, Territory_Code__c, Role_Name__c FROM User WHERE Territory_Code__c =: territoryCodeToSalesRepRole.keySet() AND IsActive = TRUE];

        if (salesReps.size() > 0) {
            for (User u : salesReps) {
                for (String role : territoryCodeToSalesRepRole.get(u.Territory_Code__c)) {
                    if (u.Role_Name__c == role) {
                        salesRepEmails.add(u.Email);
                    }
                }
            }
        }

        return salesRepEmails;
    }

}