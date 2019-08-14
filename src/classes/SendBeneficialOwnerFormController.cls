public class SendBeneficialOwnerFormController {
    
    public Id boEntityId { 
        get {
            if(ApexPages.CurrentPage().getParameters().get('id') != null) {
                return ApexPages.CurrentPage().getParameters().get('id');  
            }
            return null;
        }
    }
    
    public String formSentConfirm { 
        get {
            if(formSentConfirm == null) {
                return ApexPages.CurrentPage().getParameters().get('formSentConfirm');
            }
            return formSentConfirm;
        }
        set;
    }
    
    public User boEntityRecordOwner { get; set; }
    
    public Beneficial_Owner_Entity__c boEntity { get; set; }
    
    public String selectedAdditionalContacts { get; set; }
    
    public List<OpportunityContactRole> contacts { get; set; }
    
    public String ccEmail { get; set; }
    
    public String selectedContactId { get; set; }
    
    public NewContact newContact { get; set; }
    
    public class NewContact {
        
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String emailAddress { get; set; }
        
    }
    
    public Boolean hasContacts {
        get {
            if(contacts != null && contacts.size() > 0) {
                return true;
            }
            return false;
        }
    }
    
    public Boolean hasError {
        get {
            if (ApexPages.hasMessages()) return true;
            return false;
        }
    }
    
    public String errorMessage { get; set; }
    
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
    
    public String errorCodeDescription { get; set; }

    public BOCA_res__c brandingUtility { 
        get {
            
            if(boEntity != null && boEntity.Program__c != null) {
                
                List<BOCA_res__c> brandingUtility = new List<BOCA_res__c>();
                
                if(boEntity.Language_Preference__c != null && (boEntity.Language_Preference__c).equalsIgnoreCase('French')) {
					brandingUtility = [SELECT Id, ISO_code__c, Program_Name__c FROM BOCA_res__c WHERE Program__c =: boEntity.Program__c and ISO_code__c = 'fr_ca'];
                    
                    if(brandingUtility.size() > 0) {
                        return brandingUtility[0];
                    }
                } 
                
                brandingUtility = [SELECT Id, ISO_Code__c, Program_Name__c FROM BOCA_res__c WHERE Program__c =: boEntity.Program__c and (ISO_code__c = 'en_ca' or ISO_code__c = 'en_us')];
                
				if(brandingUtility.size() > 0) {
                	return brandingUtility[0];                                                                                                                
                }                                                                                                        
                                                                                                                            
            }
            
            return null;
            
        }
    }
    
    public SendBeneficialOwnerFormController() {
        
    }
    
    public SendBeneficialOwnerFormController(ApexPages.StandardController controller) {
        
    }
    
    public void init() {
        
        if(formSentConfirm != null && !String.isEmpty(formSentConfirm)) {
            
            if(formSentConfirm.equals('true')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Form Sent!'));
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
            
            if(boEntityId != null) {
                
                List<Beneficial_Owner_Entity__c> boEntities = [SELECT Id, Program__c, Brand_Name__c, Correspondence_Contact__c, Save_For_Later_Key__c, Save_For_Later_Date__c, OwnerId, Opportunity__c, Language_Preference__c FROM Beneficial_Owner_Entity__c WHERE Id =: boEntityId and Verification_Status__c = 'Pending Lexis/Nexis'];
                
                if(boEntities.size() > 0) {
                    
                    boEntity = boEntities[0];
                    
                    if(boEntity.OwnerId == UserInfo.getUserId()) { 
                        
                        List<User> users = [SELECT Id, Name, FirstName, LastName, Email, Phone, Sales_Code__c FROM User WHERE Id =: boEntity.OwnerId LIMIT 1];
                        
                        if(users.size() > 0) {
                            
                            boEntityRecordOwner = users [0];
                            
                        }
                        
                        
                        // Get the non-primary contacts and their roles for the additional contact section
                        contacts = new List<OpportunityContactRole>();
                        for(OpportunityContactRole contact : [SELECT ContactId, Contact.FirstName, Contact.LastName, Contact.Email, Role FROM OpportunityContactRole WHERE OpportunityId =: boEntity.Opportunity__c]) {
                            contacts.add(contact);
                        }
                        
                        if(contacts.size() == 0) {
                            newContact = new NewContact();
                        }

                        String salt = EncodingUtil.convertToHex(crypto.generateAesKey(128));
                        
                        boEntity.Save_For_Later_Key__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(salt.substring(0, 25))));

                        boEntity.Save_For_Later_Date__c = Date.today();
                        
                        boEntity.Record_Status__c = 'Awaiting Customer';
                        
                        if(brandingUtility != null) {
                            
                        	boEntity.Brand_Name__c = brandingUtility.Program_Name__c;
                        
                        	boEntity.Language_Code__c = brandingUtility.ISO_Code__c;
                            
                        }
                        
                        upsert boEntity;
                        
                    }
                    else {
                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please take ownership of the Beneficial Owner record before sending the form.')); 
                        
                    }
                    
                }
                else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot send form if record has already run verification or record is exempted.')); 
                }
                
            }
            
        }
        
    }
    
    public void throwErrorFromPage() {
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
        
        errorMessage = '';
        
    }
    
    public PageReference sendForm() {
        
        PageReference redirect = null;
        
        try {
            
            Map<String, BOCA_IDs__c> bocaIdMap = new Map<String, BOCA_IDs__c>();
            
            bocaIdMap = BOCA_IDs__c.getAll();
            
            BOCA_IDs__c singleBocaId = new BOCA_IDs__c();
            
            String replyTo = '';
            
            if(!bocaIdMap.isEmpty()){
                singleBocaId = bocaIdMap.get('BOCA IDS');
                replyTo = String.valueOf(singleBocaId.get('Email_Address_Noreply__c'));
            }
            
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage confirmation = new Messaging.SingleEmailMessage();
            
            //confirmation.setTemplateId(brandingUtility.Email_Template_ID__c);
            confirmation.setWhatId(boEntity.Id);
            
            List<RecordType> contactRecordTypes = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('F1_Contact')];
            
            Contact temporaryContact = null;
            
            if(newContact != null) {
                
                temporaryContact = new Contact();
                
                temporaryContact.FirstName = newContact.firstName;
                temporaryContact.LastName = newContact.lastName;
                temporaryContact.Email = newContact.emailAddress;
                temporaryContact.RecordTypeId = contactRecordTypes[0].Id;
                
                insert temporaryContact;
                
                confirmation.setTargetObjectId(temporaryContact.id);  
                
                boEntity.Correspondence_Contact__c = temporaryContact.Id;
            
            	upsert boEntity;
                
            }
            else {
                
                confirmation.setTargetObjectId(Id.valueOf(selectedContactId));
                
                boEntity.Correspondence_Contact__c = selectedContactId;
            
            	upsert boEntity;
                
            }
            
            confirmation.setSaveAsActivity(false);
            confirmation.setReplyTo(replyTo);
            
            Beneficial_Owner_Settings__c boSettings = Beneficial_Owner_Settings__c.getOrgDefaults();
            
            if(boEntity != null && boEntity.Language_Preference__c != null && (boEntity.Language_Preference__c).equalsIgnoreCase('French')) {
                confirmation.setTemplateId(boSettings.Send_Form_E_mail_Template_FR__c);
            }
            else {
            	confirmation.setTemplateId(boSettings.Send_Form_E_mail_Template__c);
            }
            
            for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
            {
                if(owa.Address.contains(replyTo)) {
                    confirmation.setOrgWideEmailAddressId(owa.id);                 
                }
            }
            
            if(!Test.isRunningTest()){
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { confirmation });
                if (!results.get(0).isSuccess()) {
                    throw new boFormToProspectException(String.valueOf(results.get(0).getErrors()[0]));
                }
                else {
                    redirect = Page.SendBeneficialOwnerForm;
                    redirect.getParameters().put('formSentconfirm', 'true');
                    redirect.setRedirect(true);
                    return redirect; 
                }
            }
            
            

        }
        catch(Exception e) {
            
            errorCode = logError(e);
            
            redirect = Page.SendBeneficialOwnerForm;
            redirect.getParameters().put('formSentConfirm', 'false');
            redirect.getParameters().put('errorCode', errorCode);
            redirect.setRedirect(true);
            return redirect;
            
        }
        
        return redirect;
        
    }
    
    public class boFormToProspectException extends Exception {}
    
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