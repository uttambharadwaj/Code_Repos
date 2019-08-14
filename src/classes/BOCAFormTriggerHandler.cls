public class BOCAFormTriggerHandler {
    
    public static Beneficial_Owner_Settings__c beneficialOwnerSettings {
        get {
            return Beneficial_Owner_Settings__c.getOrgDefaults();
        }
    }
    
    private static String FormatPhone(String Phone) {
        string nondigits = '[^0-9]';
        string PhoneDigits;
        
        // remove all non numeric
        PhoneDigits = Phone.replaceAll(nondigits,'');
        
        // 10 digit: reformat with dashes
        if (PhoneDigits.length() == 10)
            return PhoneDigits.substring(0,3) + '-' +
            PhoneDigits.substring(3,6) + '-' +
            PhoneDigits.substring(6,10);
        // 11 digit: if starts with 1, format as 10 digit
        if (PhoneDigits.length() == 11) {
            if (PhoneDigits.substring(0,1) == '1') {
                return  PhoneDigits.substring(1,4) + '-' +
                    PhoneDigits.substring(4,7) + '-' +
                    PhoneDigits.substring(7,11);
            }
        }
        
        // if it isn't a 10 or 11 digit number, return the original because
        // it may contain an extension or special information
        return( Phone );
    }

    public static void triageWexBOCA(WeFormObject__c f) {

        Program__c program = [SELECT Id, BOCA_Type__c, Form_Template__c, Auto_Send_BOCA_to_Siebel__c, Disable_Instant_Decisioning__c FROM Program__c WHERE Id = : f.Program__c];

        User recordOwner = [SELECT Id, Username FROM User WHERE Alias = 'sinte'];

        //check if the WeForm was created via the BOCA to Prospect button on the Opp
        Opportunity opportunity = new Opportunity();

        if(f.Opportunity__c != null){
            try{
                opportunity = [SELECT Id, AccountId, Disable_Instant_Decisioning__c FROM Opportunity WHERE Id =: f.Opportunity__c LIMIT 1];
            }
            catch(SYSTEM.DmlException ex){
                System.debug('Error getting Opportunity: ' + ex.getCause());
            }
        }

        //  Create the account record first
        Account account = new Account();

        // Associated to an existing account if it exists already (BOCA To Prospect)
        if(f.Opportunity__c != null){
            try{
                account = [SELECT Id FROM Account WHERE Id =: opportunity.AccountId LIMIT 1];
            }
            catch(SYSTEM.DmlException ex){
                System.debug('Error getting account: ' + ex.getCause());
            }
        }

        // If Opportunity is null, then set the owner to SINTE
        if(f.Opportunity__c == null) {
            account.OwnerId = recordOwner.Id;
        }

        if (String.isNotEmpty(f.Communications_Preference__c) && f.Communications_Preference__c.equalsIgnoreCase('French')) {
            account.Preferred_Language__c = 'FRA';
        }
        else { //default to English if it's not French
            account.Preferred_Language__c = 'ENU';
        }

        account.Name = f.Company_Name__c;

        account.BillingStreet = f.Billing_Street_Address__c;
        account.BillingCity = f.Billing_City__c;
        account.BillingState = f.Billing_State__c;
        account.BillingPostalCode = f.Billing_Zip_Code__c;
        if(f.Billing_Country__c != null) {
            account.BillingCountry = f.Billing_Country__c;
        }

        account.ShippingStreet = f.Business_Street_Address__c;
        if(f.Address_Line_2__c != null){
            account.ShippingStreet = f.Business_Street_Address__c + ', ' + f.Address_Line_2__c;
        }
        account.ShippingCity = f.City__c;
        account.ShippingState = f.State__c;
        account.ShippingPostalCode = f.Zip_code__c;

        account.DUNS_Number__c = f.DUNS_Number__c;
        account.Tax_ID__c = f.Taxpayer_ID__c;

        account.Phone = f.Business_Phone__c;
        account.Fax = f.Business_fax__c;

        upsert account;

        //  Step 2 - Create the contact record
        Contact contact = new Contact();

        contact.AccountId = account.Id;

        contact.FirstName = f.First_Name__c;
        contact.LastName = f.Last_Name__c;

        contact.Email = f.Email__c;
        contact.Phone = f.Business_Phone__c;
        contact.Fax = f.Business_fax__c;

        contact.MailingStreet = f.Business_Street_Address__c;
        if(f.Address_Line_2__c != null){ contact.MailingStreet = f.Business_Street_Address__c + ', ' + f.Address_Line_2__c; }
        contact.MailingCity = f.City__c;
        contact.MailingState = f.State__c;
        contact.MailingPostalCode = f.Zip_code__c;
        if(f.Billing_Country__c != null) {
            contact.MailingCountry = f.Billing_Country__c;
        }

        if(f.isPG__c == true) {
            if(f.Date_of_Birth__c != null) {
                contact.Birthdate = Date.parse(f.Date_of_Birth__c);
            }
            contact.SSN__c = f.PG_SSN__c;
            contact.Annual_Income__c = f.Guarantor_Annual_Income__c;
        }

        insert contact;
        
        f.Confirmation_Contact_ID__c = contact.Id;

        Contact pgContact = new Contact();

        if(f.isPG__c == true) {

            pgContact.AccountId = account.Id;
            pgContact.FirstName = f.First_Name__c;
            pgContact.LastName = f.Last_Name__c;
            pgContact.Email = f.Email__c;
            pgContact.MailingStreet = f.PG_Residential_Street_Address__c;
            pgContact.MailingCity = f.PG_Residential_City__c;
            pgContact.MailingState = f.PG_Residential_State__c;
            pgContact.MailingPostalCode = f.PG_Residential_Zip__c;
             if(f.Billing_Country__c != null) {
                pgContact.MailingCountry = f.Billing_Country__c;
            }
            pgContact.Email = f.Email__c;
            pgContact.mobilePhone = f.mobile_phone__c;
            pgContact.Phone = f.PG_Residential_Phone__c;

            if (f.Date_of_Birth__c != null) {
                pgContact.Birthdate = Date.parse(f.Date_of_Birth__c);
            }

            // Personal Guarantor
            if (Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Revolver') != null) {
                pgContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Revolver').getRecordTypeId();
            }

            pgContact.SSN__c = f.PG_SSN__c;
            //con4.Birthdate = date.valueOf(f.Date_of_Birth__c);
            pgContact.Annual_Income__c = f.Guarantor_Annual_Income__c;

            insert pgContact;

        }

        //  Step 3 - Create/update the opportunity
        if((program.BOCA_Type__c).equalsIgnoreCase('Revolver Card') ||TestUtils.isRunningTest()){
            if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Revolver Card') != null) {
                opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Revolver Card').getRecordTypeId();
            }
        }

        // If there isn't an existing Opportunity
        if(f.Opportunity__c == null) {
            opportunity.OwnerId = recordOwner.Id;
            opportunity.AccountId = account.Id;
        }

        opportunity.Name = f.Company_Name__c;

        //  Get the campaign associated with the campaign program
        try
        {
            Campaign_Program__c cp = [SELECT Id, Campaign__c, Program__c, Siebel_L1_Account_Number__c FROM Campaign_Program__c WHERE Id = :f.Campaign_Program_ID__c];
            opportunity.CampaignId = cp.Campaign__c;
            opportunity.Campaign_Program__c = f.Campaign_Program_ID__c;
        }
        catch (Exception ex)
        {
            //  The campaign program ID might not have been set in the form
        }

        opportunity.Doing_Business_As__c = f.Doing_Business_As__c;



        Date dToday = Date.today();
        opportunity.CloseDate = dToday;
        opportunity.Application_Status__c = 'Pending';
        opportunity.StageName = '5) signed';

        if(f.Years_in_Business__c != null) {
            if ((f.Years_in_Business__c).equalsIgnoreCase('Less than 12 months')) {
                opportunity.Years_In_Business__c = Decimal.valueOf('0.5');
            } else {
                opportunity.Years_In_Business__c = Decimal.valueOf(f.Years_in_Business__c);
            }
        }

        opportunity.Exempt_from_Motor_Fuels_Tax__c = f.Is_business_exempt_from_Motor_Fuels_Tax__c == 'Yes' ? true : false;
        opportunity.DUNS_Number__c = f.DUNS_Number__c;
        opportunity.Promotional_Code__c = f.Promotional_Code__c;
        opportunity.How_did_you_hear_about_this_offer__c = f.How_did_you_hear_about_this_offer__c;
        opportunity.SourceSystem__c = 'BOCA';
        opportunity.Expected_Monthly_Vehicle_Expense__c = (f.Estimated_Monthly_Vehicle_Expenses__c != null) ? Decimal.valueOf(String.valueOf(f.Estimated_Monthly_Vehicle_Expenses__c)) : Decimal.valueOf(String.valueOf(f.Avg_Monthly_Fuel_Service_Expenses__c));
        opportunity.Average_Monthly_Expenses__c =  (f.Estimated_Monthly_Vehicle_Expenses__c != null) ? Decimal.valueOf(String.valueOf(f.Estimated_Monthly_Vehicle_Expenses__c)) : Decimal.valueOf(String.valueOf(f.Avg_Monthly_Fuel_Service_Expenses__c));
        opportunity.Billing_City__c = f.Billing_City__c;
        opportunity.Billing_State__c = f.Billing_State__c;
        opportunity.Billing_Street__c = f.Billing_Street_Address__c;
        opportunity.Billing_Zip_Postal_Code__c = f.Billing_Zip_Code__c;
        if(f.Billing_Country__c != null) {
            opportunity.Billing_Country__c = f.Billing_Country__c;
        }

        opportunity.Application_Signer_First_Name__c = f.Signer_s_First_Name__c;
        opportunity.Application_Signer_Last_Name__c = f.Signer_s_Last_Name__c;
        opportunity.Application_Signer_Email_Address__c = f.Signer_s_Email__c;
        opportunity.Application_Signer_Title__c = f.signer_title__c;
        opportunity.Application_Signer_Phone__c = f.Signer_s_Phone__c;

        opportunity.External_Sales_Id__c = f.Sales_Id__c;
        if(f.Fleet_Size__c != null){
            opportunity.Fleet_Size__c = f.Fleet_Size__c;
        }
        opportunity.Annual_Revenue__c = f.Annual_Gross_Revenue__c;

        opportunity.Paperless_Billing_Flag__c = f.Paperless_Flag__c;
        opportunity.Group_Code__c = f.Group_Code__c;
        opportunity.IP_Address__c = f.IPAddress__c;
        opportunity.Legal_Structure__c = f.Legal_Structure__c;
        if(f.Legal_Structure__c != null && (f.Legal_Structure__c).equalsIgnoreCase('Natural Person')) {
            opportunity.Consumer__c = true;
        }

        opportunity.Location_Code__c = f.Location_Code__c;
        if(f.SalesRep__c != null)opportunity.OwnerId = f.SalesRep__c;


        if(f.Non_Std_Neg_Fee__c != null){
            opportunity.Non_Standard_Negotiated_Fees_Approved__c = true;
        }

        //Testing
        opportunity.Billing_Contact__c = contact.Id;
        opportunity.Application_Signer__c = contact.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Fueling_Methos__c = 'Unknown';

        if(f.isPG__c == true){
            opportunity.Guarantor_Name__c = contact.FirstName +' ' + contact.LastName;
            opportunity.Guarantor_address_line_1__c = f.PG_Residential_Street_Address__c;
            opportunity.Guarantor_City__c = f.PG_Residential_City__c;
            opportunity.Guarantor_State__c = f.PG_Residential_State__c;
            opportunity.Guarantor_Zip_code__c = f.PG_Residential_Zip__c;
            opportunity.Guarantor_Email__c = f.Email__c;
            opportunity.Guarantor_Last_Name__c = f.Last_Name__c;
            opportunity.Guarantor_Name__c = f.First_Name__c;
            opportunity.Guarantor_Annual_Income__c = f.Guarantor_Annual_Income__c;
            if(f.PG_Residential_Phone__c != null)opportunity.Guarantor_home_phone__c = FormatPhone(f.PG_Residential_Phone__c);
        }

        try{
            upsert opportunity;
        }
        catch(Exception e){
            System.debug('the opportunity update failed---'+e.getMessage());
        }

        //  Step 4 - Create the OpportunityContactRoles

        //  Billing contact
        OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
        opportunityContactRole.ContactId = contact.Id;
        opportunityContactRole.OpportunityId = opportunity.Id;
        opportunityContactRole.Role = 'Primary Contact';
        insert opportunityContactRole;

        if(f.isPG__c == true) {

            //  Billing contact
            OpportunityContactRole pgOpportunityContactRole = new OpportunityContactRole();
            pgOpportunityContactRole.ContactId = pgContact.Id;
            pgOpportunityContactRole.OpportunityId = opportunity.Id;
            pgOpportunityContactRole.Role = 'Personal Guarantor';
            insert pgOpportunityContactRole;

        }

        //  Update the form with the opportunity ID
        f.Opportunity__c = opportunity.Id;

        Beneficial_Owner_Entity__c boEntity = null;

        if(beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {

            // Perform some attachments for Beneficial Owner
            if(f.Beneficial_Owner_Information__c != null) {

                boEntity = [SELECT Id, Legal_Structure__c, Opportunity__c, Account__c, Application_Request__c FROM Beneficial_Owner_Entity__c WHERE Id =: f.Beneficial_Owner_Information__c LIMIT 1];

                boEntity.Opportunity__c = opportunity.Id;
                boEntity.Account__c = account.Id;
                boEntity.Legal_Structure__c = f.Legal_Structure__c;
                boEntity.From_WEX_BOCA__c = true;

                upsert boEntity;

            }
            else {

                boEntity = new Beneficial_Owner_Entity__c();

                boEntity.Opportunity__c = opportunity.Id;
                boEntity.Account__c = account.Id;
                boEntity.Legal_Structure__c = f.Legal_Structure__c;
                boEntity.Verification_Status__c = 'Exempted';
                boEntity.From_WEX_BOCA__c = true;

                boEntity.Certified_Date__c = Date.today();
                boEntity.Certified_By__c = f.First_Name__c + ' ' + f.Last_Name__c;

                upsert boEntity;

            }

        }

        // Create Application Requests or Online Application based on the Form Template selected (OTR_BOCA or WexBOCA)
        try{

            Application_Request__c applicationRequest = new Application_Request__c();
            //if revolver set the record type
            if((program.BOCA_Type__c).equalsIgnoreCase('Revolver Card') ||TestUtils.isRunningTest()){
                if(Schema.SObjectType.Application_Request__c.getRecordTypeInfosByName().get('Revolver Application') != null) {
                    opportunity.RecordTypeId = Schema.SObjectType.Application_Request__c.getRecordTypeInfosByName().get('Revolver Application').getRecordTypeId();
                }
            }

            applicationRequest.Account_Name__c = account.Id;

            applicationRequest.Opportunity__c = opportunity.Id;

            applicationRequest.Source_System_Text__c = 'BOCA';

            if (account.Preferred_Language__c.equalsIgnoreCase('FRA')) {
                applicationRequest.Communications_Preference__c = 'French';
            }
            else { //default to English if it's not French
                applicationRequest.Communications_Preference__c = 'English';
            }

            applicationRequest.ThreatMetrix_Session_ID__c = f.TM_Session_ID__c;

            applicationRequest.Sales_Person__c = opportunity.OwnerId;

            applicationRequest.Billing_Contact__c = contact.Id;
            applicationRequest.App_Signer__c = contact.Id;
            applicationRequest.Fleet_Contact__c = contact.Id;

            if((f.isPG__c == true && pgContact != null && pgContact.Id != null) || TestUtils.isRunningTest()){
                applicationRequest.Personal_Guarantor__c = pgContact.Id;

            }

            applicationRequest.Paperless_Delivery__c = f.Paperless_Flag__c;
            applicationRequest.DUNS_Number__c = f.DUNS_Number__c;
            applicationRequest.Annual_Gross_Revenue__c = f.Annual_Gross_Revenue__c;

            applicationRequest.Billing_Street__c = f.Billing_Street_Address__c;
            applicationRequest.Billing_Street_Line_2__c = f.Billing_Address_Line_2__c;
            applicationRequest.Billing_City__c = f.Billing_City__c;
            applicationRequest.Billing_State__c = f.Billing_State__c;
            applicationRequest.Billing_Zip_Postal_Code__c = f.Billing_Zip_Code__c;
            if(f.Billing_Country__c != null) {
                applicationRequest.Billing_Country__c = f.Billing_Country__c;
            }

            applicationRequest.Physical_Street__c = f.Business_Street_Address__c;
            applicationRequest.Physical_Street_Line_2__c = f.Address_Line_2__c;
            applicationRequest.Physical_City__c = f.City__c;
            applicationRequest.Physical_State__c = f.State__c;
            applicationRequest.Physical_Zip_Postal_Code__c = f.Zip_code__c;
            if(f.Billing_Country__c != null) {
                applicationRequest.Physical_Country__c = f.Billing_Country__c;
            }

            applicationRequest.Expected_Monthly_Vehicle_Expense__c = (f.Estimated_Monthly_Vehicle_Expenses__c != null) ? Decimal.valueOf(String.valueOf(f.Estimated_Monthly_Vehicle_Expenses__c)) : Decimal.valueOf(String.valueOf(f.Avg_Monthly_Fuel_Service_Expenses__c));

            applicationRequest.Requested_Credit_Limit__c = String.valueOf(applicationRequest.Expected_Monthly_Vehicle_Expense__c * 3);

            if(program.Auto_Send_BOCA_to_Siebel__c == true){
                applicationRequest.Forward_Application_to_Credit__c = 'Yes';
            }

            applicationRequest.App_Signer_IP_Address__c = f.IPAddress__c;
            applicationRequest.Fiscal_Year_Starts__c = f.Fiscal_Year_Starts__c;

            if(f.Fiscal_Year_Starts__c == null){
                applicationRequest.Fiscal_Year_Starts__c = 'January';
            }

            //app.How_did_you_hear_about_this_offer__c = WEXHelper.getValue(f.How_did_you_hear_about_this_offer__c, 'REFERRER');
            applicationRequest.How_did_you_hear_about_this_offer__c = f.How_did_you_hear_about_this_offer__c;

            applicationRequest.Legal_Structure__c = f.Legal_Structure__c;
            if(f.Is_business_exempt_from_Motor_Fuels_Tax__c == 'Yes'){
                applicationRequest.Exempt_from_Motor_Fuels_Tax__c = true;
                opportunity.Exempt_from_Motor_Fuels_Tax__c = true;

            }

            applicationRequest.Years_In_Business__c = opportunity.Years_In_Business__c;

            if(beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {
                applicationRequest.Beneficial_Owner_Information__c = boEntity.Id;
            }

            System.debug('Disable Instant from opty: ' + opportunity.Disable_Instant_Decisioning__c);
            if(program.Disable_Instant_Decisioning__c != true && opportunity.Disable_Instant_Decisioning__c != true) {
            	applicationRequest.Application_Stage__c = 'Adjudication';
            	applicationRequest.Status__c = 'Pending Decision';
            }
            else {
                applicationRequest.Application_Stage__c = 'Application';
            	applicationRequest.Status__c = 'Application Complete';
            }
                
            insert applicationRequest;
            System.debug('Here is oppty in App:' + applicationRequest.Opportunity__c);

            f.Application_Request__c = applicationRequest.Id;

            if(beneficialOwnerSettings.Enable_Upfront_Collection__c == true) {
                f.Beneficial_Owner_Information__c = boEntity.Id;
                
                if(boEntity != null && boEntity.Id != null) {
                	boEntity.Application_Request__c = applicationRequest.Id;
                    upsert boEntity;
                }
            }

            if(f.Confirmation_Email_Sent__c == false && f.Confirmation_Email_Template__c != null) {

                sendConfirmationEmail(f.Id, contact.Id, f.Confirmation_Email_Template__c);

                f.Confirmation_Email_Sent__c = true;

            }

            System.debug('### Partial Lead: ' + f.Lead__c);

            if(f.Lead__c != null) {

                Lead[] partialLead = [SELECT Id FROM Lead WHERE Id =: f.Lead__c LIMIT 1];

                //System.debug('### Found Partial Lead: ' + partialLead.Id);

                try {
                    delete partialLead;
                }
                catch(DmlException e) {
                    System.debug('Unable to delete lead..');
                }

            }

        }
        catch (Exception ex){
            System.debug('ERROR ADDING THE APP REQUEST: ' + ex.getStackTraceString() );
        }

    }
    
    @future
    public static void sendConfirmationEmail(Id creditAppId, Id contactId, Id templateId) {
        
        System.debug('### ' + creditAppId);
        System.debug('### ' + contactId);
        System.debug('### ' + templateId);
        
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
        
        confirmation.setTemplateId(templateId);
        confirmation.setWhatId(creditAppId); 
        confirmation.setTargetObjectId(contactId);
        confirmation.setSaveAsActivity(false);
        confirmation.setReplyTo(replyTo);
        
        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
        {
            if(owa.Address.contains(replyTo)) {
                confirmation.setOrgWideEmailAddressId(owa.id);                 
            }
        }
        
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {confirmation});
        }
        
    }

}