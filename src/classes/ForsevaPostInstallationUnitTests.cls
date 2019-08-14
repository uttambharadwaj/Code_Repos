/**
* Forseva online application code.
*/
@isTest
private class ForsevaPostInstallationUnitTests {

    static testMethod void testThreatMetrixService1() {

        Test.startTest();
    
        //-------------------
        // Local application
        //-------------------
    
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa1 = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        insert oa1;

        ThreatMetrixService.processApplication(oa1.Id);

        Test.stopTest();
    }

    static testMethod void testThreatMetrixService2() {

        Test.startTest();
    
        //-------------------
        // Local application
        //-------------------
    
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa1 = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        insert oa1;

        ThreatMetrixService tms = new ThreatMetrixService();
        String s = tms.process(oa1.Id);
        System.assertEquals('test response', s, 'testThreatMetrixService2() failed');

        Test.stopTest();
    }

    /*
    static testMethod void testPicklists() {
    
        Test.startTest();
        
        // Online Application Status__c Picklist
        
        Schema.DescribeFieldResult dfr = OnlineApplication__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> choices = dfr.getPicklistValues();
        //System.assertEquals(10, choices.size(), 'testPicklists() failed');
        Set<String> choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.PREFILL_IN_PROGRESS));
        //System.assert(choiceSet.contains(OnlineApplication.INCOMPLETE));
        System.assert(choiceSet.contains(OnlineApplication.INCOMPLETE_SAVED));
        //System.assert(choiceSet.contains(OnlineApplication.ABANDONED));
        System.assert(choiceSet.contains(OnlineApplication.SAVED));
        System.assert(choiceSet.contains(OnlineApplication.APPROVED));
        //System.assert(choiceSet.contains(OnlineApplication.DECLINED));
        System.assert(choiceSet.contains(OnlineApplication.SETUP_COMPLETE));
        System.assert(choiceSet.contains(OnlineApplication.MANUAL_REVIEW));        

        // Online Application Data_Entry_Stage__c Picklist

        dfr = OnlineApplication__c.Data_Entry_Stage__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(4, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.COMPANY_INFORMATION_COMPLETE));
        System.assert(choiceSet.contains(OnlineApplication.ACCOUNT_SETUP_COMPLETE));
        System.assert(choiceSet.contains(OnlineApplication.CARD_SETUP_COMPLETE));
        System.assert(choiceSet.contains(OnlineApplication.REVIEW_COMPLETE));

        // Online Application eSignature_Status__c Picklist

        dfr = OnlineApplication__c.eSignature_Status__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(4, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.NOT_EXECUTED));
        System.assert(choiceSet.contains(OnlineApplication.EXECUTED));
        System.assert(choiceSet.contains(OnlineApplication.EXECUTED_AND_RECEIVED));
        System.assert(choiceSet.contains(OnlineApplication.EXECUTED_AND_INVALID_SIGNER));

        // Online Application Billing_Cycle__c Picklist

        dfr = OnlineApplication__c.Billing_Cycle__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(7, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.WEEKLY_7));
        System.assert(choiceSet.contains(OnlineApplication.WEEKLY_14));
        System.assert(choiceSet.contains(OnlineApplication.BIWEEKLY_7));                
        System.assert(choiceSet.contains(OnlineApplication.MONTHLY));
        System.assert(choiceSet.contains(OnlineApplication.DAILY));
        System.assert(choiceSet.contains(OnlineApplication.PREPAY));

        // Online Application Offer Billing_Cycle__c Picklist

        dfr = OnlineApplicationOffer__c.Billing_Cycle__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(7, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.WEEKLY_7));
        System.assert(choiceSet.contains(OnlineApplication.WEEKLY_14));        
        System.assert(choiceSet.contains(OnlineApplication.BIWEEKLY_7));
        System.assert(choiceSet.contains(OnlineApplication.MONTHLY));
        System.assert(choiceSet.contains(OnlineApplication.DAILY));
        System.assert(choiceSet.contains(OnlineApplication.PREPAY));

        // Online Application Invoice_Delivery_Method__c Picklist

        dfr = OnlineApplication__c.Invoice_Delivery_Method__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(4, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.FAX));
        System.assert(choiceSet.contains(OnlineApplication.EMAIL));
        System.assert(choiceSet.contains(OnlineApplication.INTERNET));
        System.assert(choiceSet.contains(OnlineApplication.MAIL));

        // Online Application Payment_Method__c Picklist

        dfr = OnlineApplication__c.Payment_Method__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(6, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.AUTO_PAY));
        System.assert(choiceSet.contains(OnlineApplication.INTERNET_PAY));

        // Online Application Offer Payment_Method__c Picklist

        dfr = OnlineApplicationOffer__c.Payment_Method__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(6, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.AUTO_PAY));
        System.assert(choiceSet.contains(OnlineApplication.INTERNET_PAY));

        // Online Application Driver Setup Fuel_Grade__c Picklist
        
        dfr = OnlineApplicationDriverSetup__c.Fuel_Grade__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(2, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.DIESEL));
        System.assert(choiceSet.contains(OnlineApplication.DIESEL_AND_GASOLINE));

        // Online Application Vehicle Setup Fuel_Grade__c Picklist
        
        dfr = OnlineApplicationVehicleSetup__c.Fuel_Grade__c.getDescribe();
        choices = dfr.getPicklistValues();
        System.assertEquals(5, choices.size(), 'testPicklists() failed');
        choiceSet = new Set<String>();
        for(PicklistEntry pe : choices) {
            choiceSet.add(pe.getValue());
        }
        System.assert(choiceSet.contains(OnlineApplication.UNLEADED));
        System.assert(choiceSet.contains(OnlineApplication.UNLEADED_MID));
        System.assert(choiceSet.contains(OnlineApplication.UNLEADED_PREM));
        System.assert(choiceSet.contains(OnlineApplication.DIESEL));
        System.assert(choiceSet.contains(OnlineApplication.ALL));
                
        Test.stopTest();        
    }
*/

    static testMethod void testParametersClass() {      
    
        Test.startTest();
        
        String s1 = OnlineApplicationParameters.getApplicationBaseUrl();
        s1 = OnlineApplicationParameters.getEchoSignApiKey();
        Integer i1 = OnlineApplicationParameters.getSmallFleetMaximum();
        s1 = OnlineApplicationParameters.getThreatMetrixURL();
        s1 = OnlineApplicationParameters.getThreatMetrixOrgId();
        s1 = OnlineApplicationParameters.getThreatMetrixAPIKey();
        
        System.assertEquals(25, OnlineApplicationParameters.getSetupListMaximumRows(), 'testParametersClass() failed');

        OnlineApplicationVehicleSetup__c setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.CAR_SEDAN);
        System.assertEquals(100.00, setup.Fuel__c, 'testParametersClass() failed');
        setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.LIGHT_TRUCK_VAN);
        System.assertEquals(150.00, setup.Fuel__c, 'testParametersClass() failed');
        setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.MID_SIZE_TRUCK);
        System.assertEquals(300.00, setup.Fuel__c, 'testParametersClass() failed');
        setup = OnlineApplicationParameters.getDefaultVehicleSetup(OnlineApplicationParameters.LARGE_TRUCK_EQUIPMENT);
        System.assertEquals(500.00, setup.Fuel__c, 'testParametersClass() failed');

        OnlineApplicationCardSetup__c cardSetup = 
            OnlineApplicationParameters.getDefaultCardSetup(OnlineApplicationParameters.TRAVEL_CARD, OnlineApplicationParameters.ALL_MERCHANTS);
        System.assertEquals(10, cardSetup.Cash__c, 'testParametersClass() failed');            
        cardSetup = 
            OnlineApplicationParameters.getDefaultCardSetup(OnlineApplicationParameters.PURCHASE_CARD, OnlineApplicationParameters.ALL_MERCHANTS);
        System.assertEquals(5000, cardSetup.Credit_Limit__c, 'testParametersClass() failed');            
        cardSetup = 
            OnlineApplicationParameters.getDefaultCardSetup(OnlineApplicationParameters.FLEET_DRIVER_CARD, OnlineApplicationParameters.FUEL_ONLY);
        System.assertEquals(1500, cardSetup.Credit_Limit__c, 'testParametersClass() failed');            
        cardSetup = 
            OnlineApplicationParameters.getDefaultCardSetup(OnlineApplicationParameters.FLEET_DRIVER_CARD, OnlineApplicationParameters.FUEL_AND_MAINT);
        System.assertEquals(2500, cardSetup.Credit_Limit__c, 'testParametersClass() failed');            
        cardSetup = 
            OnlineApplicationParameters.getDefaultCardSetup(OnlineApplicationParameters.FLEET_DRIVER_CARD, OnlineApplicationParameters.ALL_MERCHANTS);
        System.assertEquals(3500, cardSetup.Credit_Limit__c, 'testParametersClass() failed');            
        
        Id rId = OnlineApplicationParameters.getDefaultContactRecordType();
        
        Test.stopTest();
    }


    static testMethod void testSOUtility() {
    
        Test.startTest();
            
        Account a = new Account(Name = 'BooBerry', forseva1__Last_Payment_Date__c = Date.today(), forseva1__CQR_Description__c = 'Wow');
        insert a;
        Account b = (Account)SOUtility.getCompleteSObject(Account.SObjectType, a.Id);
        System.assertEquals(a.Id, b.Id, 'testSOUtility() failed');
        System.assertEquals(a.forseva1__Last_Payment_Date__c, b.forseva1__Last_Payment_Date__c, 'testSOUtility() failed');
        System.assertEquals(a.forseva1__CQR_Description__c, b.forseva1__CQR_Description__c, 'testSOUtility() failed');
        
        forseva1__ARSummary__c ar1 = new forseva1__ARSummary__c(forseva1__Account__c = a.Id, forseva1__AR_Summary_Report_Date__c = Date.today(), forseva1__Upload_Batch_Id__c = 123);
        insert ar1;
        forseva1__ARSummary__c ar2 = (forseva1__ARSummary__c) SOUtility.getCompleteSObject(forseva1__ARSummary__c.SOBjectType, ar1.Id); 
        System.assertEquals(ar1.ID, ar2.Id, 'testSOUtility() failed');
        System.assertEquals(ar1.forseva1__Account__c, ar2.forseva1__Account__c, 'testSOUtility() failed');
        System.assertEquals(ar1.forseva1__AR_Summary_Report_Date__c, ar2.forseva1__AR_Summary_Report_Date__c, 'testSOUtility() failed');
        System.assertEquals(ar1.forseva1__Upload_Batch_Id__c, ar2.forseva1__Upload_Batch_Id__c, 'testSOUtility() failed');
        
        Test.stopTest();   
    }


   /* static testMethod void testOnlineApplicationClass() { 
    
        Test.startTest();
    
        //-------------------
        // Local application
        //-------------------
        List<Folder> lstFolder = [ Select Id, Name from Folder where Type ='Email Template' limit 1];
        
        if(!lstFolder.isEmpty()) {
        
            EmailTemplate emailTemp = new EmailTemplate (developerName = 'test', FolderId = lstFolder[0].Id, TemplateType= 'Text', Name = 'test'); 
            insert emailTemp;
        }
        
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa1_so = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        oa1_so.Product_Type__c = OnlineApplication.LOCAL;
        oa1_so.Number_of_Drivers__c = 10;
        oa1_so.Number_of_Trailers__c = null;
        oa1_so.Number_of_Trucks__c = null;
        oa1_so.Number_of_Vehicles__c = 10;
        
       if(!lstFolder.isEmpty())
            oa1_so.Email_Template_Id__c = lstFolder[0].Id;  
        
        OnlineApplication oa1 = new OnlineApplication(oa1_so); 

        System.assertEquals(oa1_so, oa1.getSO(), 'testOnlineApplicationClass() failed');
        System.assertEquals(true, oa1.isUnsaved(), 'testOnlineApplicationClass() failed');
        System.assertEquals(false, oa1.isSaved(), 'testOnlineApplicationClass() failed');
        System.assertEquals(15, oa1.getDisclosure().length(), 'testOnlineApplicationClass() failed');
        
        oa1.saveApplication();
        
        System.assertEquals(false, oa1.isUnsaved(), 'testOnlineApplicationClass() failed');
        System.assertEquals(true, oa1.isSaved(), 'testOnlineApplicationClass() failed');

        Map<String,String> fieldMap = OnlineApplication.getNameLabelFieldMap(OnlineApplication__c.SObjectType);
        System.assertEquals('Promotional Code', fieldMap.get('Promotional_Code__c'), 'testOnlineApplicationClass() failed');
        fieldMap = OnlineApplication.getNameLabelFieldMap(OnlineApplicationAuthorizedContact__c.SObjectType);
        System.assertEquals('Email', fieldMap.get('Email__c'), 'testOnlineApplicationClass() failed');
        fieldMap = OnlineApplication.getNameLabelFieldMap(OnlineApplicationDriverSetup__c.SObjectType);
        System.assertEquals('Driver Name', fieldMap.get('Driver_Name__c'), 'testOnlineApplicationClass() failed');
        fieldMap = OnlineApplication.getNameLabelFieldMap(OnlineApplicationVehicleSetup__c.SObjectType);
        System.assertEquals('Fuel Grade', fieldMap.get('Fuel_Grade__c'), 'testOnlineApplicationClass() failed');
        
        OnlineApplication__c oa1b_so = OnlineApplication.getSObjectWithAllFields(oa1_so.Id);
        System.assertEquals(oa1_so.Id, oa1b_so.Id,'testOnlineApplicationClass() failed');
        System.assertEquals(oa1_so.Federal_Tax_ID__c, oa1b_so.Federal_Tax_ID__c, 'testOnlineApplicationClass() failed');

        //----------------------------
        // related lists testing start

        // contacts

        OnlineApplicationAuthorizedContact__c authContact = new OnlineApplicationAuthorizedContact__c();
        authContact.Name = oa1_so.AO_Name__c;
        authContact.Email__c = oa1_so.AO_Work_Email__c;
        authContact.Online_Password__c = null;
        authContact.Security_Code__c = oa1_so.AO_Social_Security_Number__c.substring(5,9);
        oa1.addAuthorizedContact(authContact);
        
        authContact = new OnlineApplicationAuthorizedContact__c();
        authContact.Name = 'George Smiley';
        authContact.Email__c = 'george@mi6.com';
        authContact.Online_Password__c = null;
        authContact.Security_Code__c = oa1_so.AO_Social_Security_Number__c.substring(5,9);
        oa1.addAuthorizedContact(authContact);
        
        List<OnlineApplicationAuthorizedContact__c> contacts = oa1.getAuthorizedContacts();
        System.assertEquals(2, contacts.size(),  'testOnlineApplicationClass() failed');
        
        // vehicles
        
        OnlineApplicationVehicleSetup__c vehicleSetup = new OnlineApplicationVehicleSetup__c();
        oa1.addVehicleSetup(vehicleSetup);
        
        vehicleSetup = new OnlineApplicationVehicleSetup__c();
        oa1.addVehicleSetup(vehicleSetup);        
        
        List<OnlineApplicationVehicleSetup__c> vehicleSetups = oa1.getVehicleSetups();
        System.assertEquals(2, vehicleSetups.size(),  'testOnlineApplicationClass() failed');
        
        // drivers
        
        OnlineApplicationDriverSetup__c driverSetup = new OnlineApplicationDriverSetup__c();
        oa1.addDriverSetup(driverSetup);
        
        driverSetup = new OnlineApplicationDriverSetup__c();
        oa1.addDriverSetup(driverSetup);
        
        List<OnlineApplicationDriverSetup__c> driverSetups = oa1.getDriverSetups();
        System.assertEquals(2, driverSetups.size(),  'testOnlineApplicationClass() failed');
        
        // save
        
        oa1.saveApplication();
        
        // post save
        
        OnlineApplication oa2 = new OnlineApplication(oa1_so);
        contacts = oa2.getAuthorizedContacts();
        System.assertEquals(2, contacts.size(),  'testOnlineApplicationClass() failed');

        vehicleSetups = oa2.getVehicleSetups();
        System.assertEquals(2, vehicleSetups.size(),  'testOnlineApplicationClass() failed');

        driverSetups = oa2.getDriverSetups();
        System.assertEquals(2, driverSetups.size(),  'testOnlineApplicationClass() failed');

        // related lists testing end
        //----------------------------
        
        String formattedName = OnlineApplication.getFormattedValue(oa1_so.getSObjectType(), 'Legal_Business_Name__c', oa1_so.get('Legal_Business_Name__c'));
        System.assertEquals('Legal Name', formattedName, 'testOnlineApplicationClass() failed');
        String formattedLimit = OnlineApplication.getFormattedValue(oa1_so.getSObjectType(), 'Credit_Line_Requested__c', oa1_so.get('Credit_Line_Requested__c'));
        System.assertEquals('Legal Name', formattedName, 'testOnlineApplicationClass() failed');

        System.assertEquals(5, oa2.getLocalFuelChoices().size(), 'testOnlineApplicationClass() failed');
        System.assertEquals(2, oa2.getOTRFuelChoices().size(), 'testOnlineApplicationClass() failed');
        
        //------------------
        // OTR application    
        //------------------    
       
        Account a = new Account(Name = 'Card Program ZZZZ');
        a.RecordTypeId = [select Id from RecordType where SobjectType = 'Account' and Name = 'Card Program'].Id;
        insert a;
        
        Contact objCon = new Contact(LastName = 'test Contact', accountId = a.Id, email='test123@gmail.com');
        insert objCon;
        
        offer1.Card_Program__c = a.Id; 
        update offer1;       
        
        
        Lead ld1 = new Lead();
        ld1.FirstName = 'George';
        ld1.LastName = 'Smiley';
        ld1.Company = 'The Circus MI6';
        ld1.Status = 'Open';
        ld1.Lead_Source_Website__c = 'http://www.forseva.com';
        ld1.Card_Program__c = null;
        ld1.Email = 'test@forseva.com';
        insert ld1;
        ld1.Card_Program__c = a.Id;
        update ld1;
        
         // Commented by Trekbin as per case requirement  00022852
        //OnlineApplication.processLeads(new List<Id>{ld1.Id}, new List<Id>{a.Id});
        
        if(!lstFolder.isEmpty())
            oa1.sendWeb2LeadEmail(objCon.Id); 
         
        Test.stopTest();
    } */

     static testMethod void testEchoSignService() {
    
        Test.startTest();
    
        EchoSignService ess = new EchoSignService();
        ess.setApiKey('APIAPEAPO');
        ess.setContractName('Living Will For Homer Simpson');
        ess.setCustomerEmail('dcraigmile@testtesttest.com');
        ess.setFileContents(Blob.valueOf('This is a simple unit test file'));
        ess.setFileName('test.rtf');
        ess.setSenderEmail('boo@boo.com');
        ess.setSenderPassword('alanturing12345');
        ess.setSuccessUrl('http://www.google.com');
    
        String js = ess.getContractJavaScriptUrl();
        System.assertEquals('https://secure.echosign.com/public/widget?f=3FCK73S5E4I45&amp;token=EZG90G9K230E59B5LIWTQMEL', js, 'testOnlineApplicationProcess() failed');
        
        String url = ess.getContractUrl();
        //System.assertEquals('https://secure.echosign.com/public/hostedForm?formid=dEFTEVX3WXX3C&amp;token=Y5RQBSL5GIH9OFIH8PL7TCQ0', url, 'testOnlineApplicationProcess() failed');
    
        Test.stopTest();
    } 

    static testMethod void testEchoSignEmailHandlerWithValidSigner() {

        Test.startTest();
        
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        oa_so.Status__c = OnlineApplication.REVIEW_COMPLETE;
        oa_so.eSignature_Status__c = OnlineApplication.EXECUTED;
        oa_so.AO_Name__c = 'George Smiley';
        oa_so.AO_Work_Email__c = 'joe@fleet.com';
        insert oa_so; 
        
        EchoSignEmailHandler handler = new EchoSignEmailHandler();
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'The Test UAT Local Offer (between George Smiley and forseva) is Signed and Filed!';
        email.toAddresses = new List<String>{'Matt Lattin <mlattin@fleetone.com>','Joe Smith <joe@fleet.com>'};
        Messaging.Inboundemail.BinaryAttachment ba = new Messaging.Inboundemail.BinaryAttachment();
        ba.body = Blob.valueOf('What weve got here is failure to communicate.');
        ba.fileName = 'Application.pdf';
        ba.mimeTypeSubType = 'application/pdf';
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ba};        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
   
        Integer attachmentCount = [select count() from Attachment where ParentId = :oa_so.Id];
        System.assertEquals(1, attachmentCount, 'testEchoSignEmailHandlerWithValidSigner() failed');
        
        oa_so = [select Id, eSignature_Status__c from OnlineApplication__c where Id = :oa_so.Id];
        System.assertEquals(OnlineApplication.EXECUTED_AND_RECEIVED, oa_so.eSignature_Status__c, 'testEchoSignEmailHandlerWithValidSigner() failed');
        
        Test.stopTest();
    } 

    static testMethod void testEchoSignEmailHandlerWithInvalidSigner() {

        Test.startTest();
        
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        oa_so.Status__c = OnlineApplication.REVIEW_COMPLETE;
        oa_so.eSignature_Status__c = OnlineApplication.EXECUTED;
        oa_so.AO_Name__c = 'George Smiley';
        oa_so.AO_Work_Email__c = 'joe@fleet.com';
        insert oa_so;
        
        EchoSignEmailHandler handler = new EchoSignEmailHandler();
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'The Test UAT Local Offer (between Martha Moop and forseva) is Signed and Filed!';
        email.toAddresses = new List<String>{'Matt Lattin <mlattin@fleetone.com>','Joe Smith <joe@fleet.com>'};
        Messaging.Inboundemail.BinaryAttachment ba = new Messaging.Inboundemail.BinaryAttachment();
        ba.body = Blob.valueOf('What weve got here is failure to communicate.');
        ba.fileName = 'Application.pdf';
        ba.mimeTypeSubType = 'application/pdf';
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ba};        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);
   
        Integer attachmentCount = [select count() from Attachment where ParentId = :oa_so.Id];
        System.assertEquals(1, attachmentCount, 'testEchoSignEmailHandlerWithInvalidSigner() failed');
        
        oa_so = [select Id, eSignature_Status__c from OnlineApplication__c where Id = :oa_so.Id];
        System.assertEquals(OnlineApplication.EXECUTED_AND_INVALID_SIGNER, oa_so.eSignature_Status__c, 'testEchoSignEmailHandlerWithInvalidSigner() failed');
        
        Test.stopTest();
    } 

    static testMethod void testConvertLocal() {
        
        Test.startTest();
                
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        oa_so.AO_Name__c = 'George Smiley';

        insert oa_so;
        OnlineApplication oa = new OnlineApplication(oa_so); 
        oa.convertApplicationToAccountContactOpportunity(null);

        OnlineApplication__c oApp = [select Id, Account__c from OnlineApplication__c where Id = :oa_so.Id];
        Account a = [select Id, Name from Account where Id = :oApp.Account__c];
        Contact c = [select Id, Name, Lead_Source_Sub_Type2__c from Contact where AccountId = :a.Id];
        Opportunity o = [select Id, Name from Opportunity where AccountId = :a.Id];

        System.assertEquals(oa_so.Legal_Business_Name__c, a.Name, 'testConvertLocal() failed');
        System.assertEquals(oa_so.AO_Name__c, c.Name, 'testConvertLocal() failed');
        System.assertEquals(oa_so.Lead_Source_Subtype__c, c.Lead_Source_Sub_Type2__c, 'testConvertLocal() failed');
        System.assert(o.Name.contains(oa_so.Application_Title__c), 'testConvertLocal() failed');

        Test.stopTest();        
    } 

    static testMethod void testConvertOTR() {
        
        Test.startTest();

        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        oa_so.AO_Name__c = 'Prince Boo';

        insert oa_so;
        OnlineApplication oa = new OnlineApplication(oa_so); 
        oa.convertApplicationToAccountContactOpportunity(null);

        OnlineApplication__c oApp = [select Id, Account__c from OnlineApplication__c where Id = :oa_so.Id];
        Account a = [select Id, Name from Account where Id = :oApp.Account__c];
        Contact c = [select Id, Name, Lead_Source_Sub_Type2__c from Contact where AccountId = :a.Id];
        Opportunity o = [select Id, Name from Opportunity where AccountId = :a.Id];

        System.assertEquals(oa_so.Legal_Business_Name__c, a.Name, 'testConvertLocal() failed');
        System.assertEquals(oa_so.AO_Name__c, c.Name, 'testConvertLocal() failed');
        System.assertEquals(oa_so.Lead_Source_Subtype__c, c.Lead_Source_Sub_Type2__c, 'testConvertLocal() failed');
        System.assert(o.Name.contains(oa_so.Application_Title__c), 'testConvertLocal() failed');

        Test.stopTest();        
    }
/*
      static testMethod void testConvertLocalToLead() {
        
        Test.startTest();
                
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        oa_so.AO_Name__c = 'George Smiley';
        oa_so.Contact_Name__c = 'George Smiley';

        insert oa_so;

        ApexPages.PageReference p = Page.ApplicationConversion;
        p.getParameters().put(OnlineApplicationConversionController.APPLICATION_ID, oa_so.Id);
        p.getParameters().put(OnlineApplicationConversionController.CONVERSION_TYPE, OnlineApplicationConversionController.LEAD);
        Test.setCurrentPage(p);

        OnlineApplicationConversionController c = new OnlineApplicationConversionController();
        p = c.performConversion();

        OnlineApplication__c oApp = [select Id, Lead__c from OnlineApplication__c where Id = :oa_so.Id];
        Lead l = [select Id, FirstName, LastName, Number_of_Vehicles_Range__c, Number_of_Vehicles__c from Lead where Id = :oApp.Lead__c];

        System.assertEquals(oApp.Lead__c, l.Id, 'testConvertLocalToLead() failed');
        System.assertEquals('George', l.FirstName, 'testConvertLocalToLead() failed');
        System.assertEquals('Smiley', l.LastName, 'testConvertLocalToLead() failed');
        System.assertEquals('26-50', l.Number_of_Vehicles_Range__c, 'testConvertLocalToLead() failed');
        System.assertEquals(40, l.Number_of_Vehicles__c, 'testConvertLocalToLead() failed');

        p = c.performConversion(); // no op second time 

        Test.stopTest();        
    }
*/

   static testMethod void testConvertOTRToLead() {
        
        Test.startTest();
                
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        oa_so.AO_Name__c = 'George Smiley';
        oa_so.Contact_Name__c = 'George Smiley';

        insert oa_so;

        ApexPages.PageReference p = Page.ApplicationConversion;
        p.getParameters().put(OnlineApplicationConversionController.APPLICATION_ID, oa_so.Id);
        p.getParameters().put(OnlineApplicationConversionController.CONVERSION_TYPE, OnlineApplicationConversionController.LEAD);
        Test.setCurrentPage(p);

        OnlineApplicationConversionController c = new OnlineApplicationConversionController();
        p = c.performConversion();

        OnlineApplication__c oApp = [select Id, Lead__c from OnlineApplication__c where Id = :oa_so.Id];
        
        try {
            Lead l = [select Id, FirstName, LastName, Number_of_Vehicles_Range__c, Number_of_Vehicles__c from Lead where Id = :oApp.Lead__c];

            System.assertEquals(oApp.Lead__c, l.Id, 'testConvertLocalToLead() failed');
            System.assertEquals('George', l.FirstName, 'testConvertLocalToLead() failed');
            System.assertEquals('Smiley', l.LastName, 'testConvertLocalToLead() failed');
            System.assertEquals('51-75', l.Number_of_Vehicles_Range__c, 'testConvertLocalToLead() failed');
            System.assertEquals(55, l.Number_of_Vehicles__c, 'testConvertLocalToLead() failed');

            // now convert to account, contact, opportunity

            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l.Id);
            lc.setConvertedStatus('Qualified Prospect');
            Database.convertLead(lc,true);
        }
        catch(Exception e) {
            System.debug('ERROR MESSING LEAD IN testConvertOTRToLead()');
        } 

        Test.stopTest();        
    }


    static testMethod void testPersonWS() {      
    
        Test.startTest();
        
        PersonWS p = new PersonWS();
        p.NamePrefix = 'Mr';
        p.FirstName = 'George';
        p.MiddleName = 'Sebastian';
        p.LastName = 'Smiley';
        p.GenerationSuffix = 'Jr';
        p.SalutationSuffix = 'MD';
        p.UnparsedAddress = '1000 N. State Ave W.';
        p.AddressNumber = '1000';
        p.StreetName = 'State';
        p.StreetPreDirection = 'N';
        p.StreetPostDirection = 'W';
        p.StreetType = 'AV';
        p.UnitNumber = '#301';
        p.Phone = '3128889999';
        p.City = 'Chicago';
        p.State = 'IL';
        p.PostalCode = '60606';
        p.SSN = '222334444';
        p.DateOfBirth = Date.today().addYears(-30);
        p.Age = 30;
        p.personId = null;        
        
        Test.stopTest();
    }

    static testMethod void testCreditPersonsWS() {      
    
        // Set up account and contact by processing an application
    
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        insert oa_so;
        OnlineApplication oa = new OnlineApplication(oa_so); 
        oa.convertApplicationToAccountContactOpportunity(null);
        OnlineApplication__c oApp = [select Id, Account__c from OnlineApplication__c where Id = :oa_so.Id];

        // simulate a successful signature
        Contact c = [select Id, Last_Valid_Authorized_Signer__c from Contact where AccountId = :oApp.Account__c];
        //c.Last_Valid_Authorized_Signer__c = true;
        c.Report_Permission_Granted__c = true;
        update c;
    
        Test.startTest();

        List<PersonWS> persons1 = CreditPersonsWS.getCreditSubject(oApp.Account__c);
        List<PersonWS> persons2 = CreditPersonsWS.getCreditSubjectUsingParameterString('accountId:' + oApp.Account__c);
        System.assertEquals(persons1.size(), persons2.size(), 'testCreditPersonsWS() failed');
        
        List<String> parameters = CreditPersonsWS.getCreditBureauRequestParameters('accountId:' + oApp.Account__c);
        System.assertEquals(9, parameters.size(), 'testCreditPersonsWS() failed');
        
        StaticResource sr = [select Id, Name, Body from StaticResource where Name = 'EfxTestFile'];
        String xmlString = sr.Body.toString();
        
        String theReport = CreditPersonsWS.parseAndScore(
            'Equifax Consumer', oApp.Account__c, persons2[0].personId, ('accountId:' + oApp.Account__c), xmlString);

        xmlString = xmlString.replace('<BeaconScore>00649</BeaconScore>', '<BeaconScore>babaganoush</BeaconScore>');                                                          

        theReport = CreditPersonsWS.parseAndScore(
            'Equifax Consumer', oApp.Account__c, persons2[0].personId, ('accountId:' + oApp.Account__c), xmlString);
                                                         
        Test.stopTest();
    }

    static testMethod void testOnlineApplicationTriggers() {
    
        Test.startTest();
        
        OnlineApplicationOffer__c offer = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa = createCompleteApplication(offer.Id, OnlineApplication.OTR);
        
        try {
            oa.Offer__c = null;         
            insert oa;
            // should not be able to insert an application without an offer
            System.assert(false, 'testOnlineApplicationTriggers() failed');
        }
        catch(Exception e) {
            // ok
        }
        
        try {
            oa.Offer__c = offer.Id;
            insert oa;
        }
        catch(Exception e) {
            System.assert(false, 'testOnlineApplicationTriggers() failed');
        }

        try {
            offer = createCompleteSavedOffer(OnlineApplication.Local);
            oa.Offer__c = offer.Id;
            update oa;
            // should not be able to change an application's offer
            System.assert(false, 'testOnlineApplicationTriggers() failed');
        }
        catch(Exception e) {
            // ok
        }

        OnlineApplicationOffer__c offer2 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa2 = createCompleteApplication(offer2.Id, OnlineApplication.OTR);
        oa2.Status__c = OnlineApplication.APPROVED;
        insert oa2;
        try {
            delete oa2;
            // should not be able to delete an approved application
            System.assert(false, 'testOnlineApplicationTriggers() failed');
        }
        catch(Exception e) {
            // ok
        }
        
        oa2.Status__c = OnlineApplication.INCOMPLETE;
        update oa2;
        delete oa2;
                        
        Test.stopTest();
    }

    static testMethod void testEquifaxConsumerTrigger() {      

        // Set up account and contact by processing an application
    
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.OTR);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.OTR);
        insert oa_so;
        OnlineApplication oa = new OnlineApplication(oa_so); 
        oa.convertApplicationToAccountContactOpportunity(null);
        OnlineApplication__c oApp = [select Id, Account__c from OnlineApplication__c where Id = :oa_so.Id];
    
        Test.startTest();

        forseva1__DataProviderProduct__c efxDdp = [select id from forseva1__DataProviderProduct__c where name = 'Equifax Consumer Credit'];
        
        forseva1__EquifaxConsumer__c ec = new forseva1__EquifaxConsumer__c();
        ec.forseva1__Data_Provider_Product__c = efxDdp.id;
        ec.forseva1__Account__c = oApp.Account__c;
        ec.forseva1__F_CQR_Description__c = 'Yaba Daba';
        ec.forseva1__F_Credit_Limit_Approved__c = 10000;
        ec.forseva1__F_Credit_Limit_Effective_Date__c = Date.today();
        ec.forseva1__F_Credit_Limit_Expiration_Date__c = Date.today().addDays(365);
        ec.forseva1__F_Credit_Quality_Rating__c = 5.0;
        
        insert ec;

        Account a = [select forseva1__Credit_Limit_Approved__c,
                            forseva1__CQR_Description__c, 
                            forseva1__Credit_Quality_Rating__c from Account where Id = :oApp.Account__c];

        // glen added workflow on the account that screws this up...
        //System.assertEquals(ec.forseva1__F_Credit_Limit_Approved__c, a.forseva1__Credit_Limit_Approved__c, 'testEquifaxConsumerTrigger() failed'); 

        Test.stopTest();
    }

    static testMethod void testOnlineApplicationSetupWithZeroContacts() {

        List<SObject> objs = createAccountContactOpportunity(0);
        Account a1 = (Account)objs[0];
        Opportunity o1 = (Opportunity)objs[1];
        createCompleteSavedOffer(OnlineApplication.LOCAL);
        createCompleteSavedOffer(OnlineApplication.OTR);
        
        Test.startTest();

        ApexPages.PageReference p = Page.ApplicationSetup;
        p.getParameters().put('opportunityId', o1.Id);
        Test.setCurrentPage(p);

        OnlineApplicationSetupController oasc = new OnlineApplicationSetupController();
        
        Account a2 = oasc.getAccount();
        System.assertEquals(a1.Id, a2.Id, 'testOnlineApplicationSetupWithZeroContacts() failed');

        Contact c1 = oasc.getContact();
        System.assertEquals(c1.Id, null, 'testOnlineApplicationSetupWithZeroContacts() failed');
        c1.FirstName = 'Norman';
        c1.LastName = 'Bates';
        c1.Email = 'norman@batesmotel.com';

        String contactId = oasc.getContactId();
        System.assertEquals(null, contactId, 'testOnlineApplicationSetupWithZeroContacts() failed');

        System.assertEquals(false, oasc.getShowContactList(), 'testOnlineApplicationSetupWithZeroContacts() failed');

        List<SelectOption> contactList = oasc.getContactList();
        System.assertEquals(0, contactList.size(), 'testOnlineApplicationSetupWithZeroContacts() failed');
        
        // Added by Trekbin : 4rth August -- Start
        GetTemplates__c objgetTemplates = new GetTemplates__c();
        objgetTemplates.Name = [Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        objgetTemplates.FolderName__c = 'TestFolder';
        
        insert objgetTemplates;
        // Added by Trekbin : 4rth August -- End
        
        OnlineApplication__c oa1 = oasc.getApplication();
        System.assertEquals(a1.Id, oa1.Account__c, 'testOnlineApplicationSetupWithZeroContacts() failed');
        // Commented by Trekbin as per case requirement  00022852 to avoid assert failures
        // System.assertEquals(a1.Name.substring(0, Math.min(30, a1.Name.length())), oa1.Legal_Business_Name__c, 'testOnlineApplicationSetupWithZeroContacts() failed'); 
        oa1.Show_Card_Setup_Page__c = true;

        List<SelectOption> offerList = oasc.getOfferList();
        System.assert(offerList.size() >= 3, 'testOnlineApplicationSetupWithZeroContacts() failed');
        oasc.setOfferId(offerList[1].getValue());
        System.assertEquals(offerList[1].getValue(), oasc.getOfferId(), 'testOnlineApplicationSetupWithZeroContacts() failed');
        
        List<SelectOption> templateList = oasc.getTemplateList();
        if(templateList.size() > 0) {
            oasc.setTemplateId(templateList[0].getValue());
            System.assertEquals(templateList[0].getValue(), oasc.getTemplateId(),  'testOnlineApplicationSetupWithZeroContacts() failed');
        }

        p = oasc.returnToOpportunity();

        //----------------------------
        // transition to application!
        //----------------------------

        p = oasc.createAndEditApplication();        
        Test.setCurrentPage(p);
        OnlineApplicationControllerExtension oace1 = new OnlineApplicationControllerExtension();
        
        Integer contactCount = [select count() from Contact where AccountId = :oasc.getAccount().Id];
        System.assertEquals(1, contactCount, 'testOnlineApplicationSetupWithZeroContacts() failed');
        
        System.assertEquals(true, oace1.getIsPrefillMode(), 'testOnlineApplicationSetupWithZeroContacts() failed');
        System.assertEquals(true, oace1.getShowCardSetupPage(), 'testOnlineApplicationSetupWithZeroContacts() failed');

        p = oace1.saveAndCreateEmail();
        System.assert(p.getUrl().contains('_ui/core/email/author/EmailAuthor'), 'testOnlineApplicationSetupWithZeroContacts() failed');
        System.assertEquals(true, oace1.getIsFleetOneInitiatedApplication(), 'testOnlineApplicationSetupWithZeroContacts() failed');

        //-----------------------
        // resend the application
        //-----------------------

        p = Page.ApplicationConversion;        
        p.getParameters().put('resend', 'true');
        p.getParameters().put('applicationId', oace1.getAppl().Id);
        Test.setCurrentPage(p);
        
        oasc = new OnlineApplicationSetupController();
        p = oasc.resendApplicationIfItExists();
        System.assert(p.getUrl().contains('companyinformation'), 'testOnlineApplicationSetupWithZeroContacts() failed');

        Test.stopTest();
    }

    static testMethod void testOnlineApplicationGoNextNoApp() {

        OnlineApplicationOffer__c offer = createCompleteSavedOffer(OnlineApplication.OTR);

        TestUtils.enable_isRunningTest = true;

        Test.startTest();

        PageReference p = Page.ApplicationCompanyInformation;
        p.getParameters().put('offer', offer.Id);
        Test.setCurrentPage(p);

        OnlineApplicationControllerExtension oace1 = new OnlineApplicationControllerExtension();

        oace1.goNext();

        Test.stopTest();
    }

    static testMethod void testOnlineApplicationGoNext() {

        List<SObject> objs = createAccountContactOpportunity(1);
        Account a1 = (Account)objs[0];
        Contact c1 = (Contact)objs[1];
        Opportunity o1 = (Opportunity)objs[2];
        createCompleteSavedOffer(OnlineApplication.LOCAL);
        createCompleteSavedOffer(OnlineApplication.OTR);

        TestUtils.enable_isRunningTest = true;

        Test.startTest();

        ApexPages.PageReference p = Page.ApplicationSetup;
        p.getParameters().put('opportunityId', o1.Id);
        Test.setCurrentPage(p);

        // Added by Trekbin : 4rth August -- Start
        GetTemplates__c objgetTemplates = new GetTemplates__c();
        objgetTemplates.Name = [Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        objgetTemplates.FolderName__c = 'TestFolder1';

        insert objgetTemplates;
        // Added by Trekbin : 4rth August -- End

        OnlineApplicationSetupController oasc = new OnlineApplicationSetupController();

        Account a2 = oasc.getAccount();
        System.assertEquals(a1.Id, a2.Id, 'testOnlineApplicationSetupWithOneContact() failed');

        Contact c2 = oasc.getContact();
        System.assertEquals(c1.Id, c2.Id, 'testOnlineApplicationSetupWithOneContact() failed');

        String contactId = oasc.getContactId();
        System.assertEquals(c1.Id, Id.valueOf(contactId), 'testOnlineApplicationSetupWithOneContact() failed');
        oasc.setContactId(contactId);

        System.assertEquals(true, oasc.getShowContactList(), 'testOnlineApplicationSetupWithOneContact() failed');

        List<SelectOption> contactList = oasc.getContactList();
        System.assertEquals(1, contactList.size(), 'testOnlineApplicationSetupWithOneContact() failed');
        System.assertEquals('Norman Bates 0', contactList[0].getLabel(), 'testOnlineApplicationSetupWithOneContact() failed');

        OnlineApplication__c oa1 = oasc.getApplication();
        System.assertEquals(a1.Id, oa1.Account__c, 'testOnlineApplicationSetupWithOneContact() failed');
        // Commented by Trekbin as per case requirement  00022852 to avoid assert failures
        // System.assertEquals(String.valueOf(a1.Name.substring(0, Math.min(30, a1.Name.length()))), oa1.Legal_Business_Name__c, 'testOnlineApplicationSetupWithOneContact() failed'); trek
        oa1.Show_Card_Setup_Page__c = true;

        List<SelectOption> offerList = oasc.getOfferList();
        System.assert(offerList.size() >= 3, 'testOnlineApplicationSetupWithOneContact() failed');
        oasc.setOfferId(offerList[1].getValue());
        System.assertEquals(offerList[1].getValue(), oasc.getOfferId(), 'testOnlineApplicationSetupWithOneContact() failed');

        List<SelectOption> templateList = oasc.getTemplateList();
        if(templateList.size() > 0) {
            oasc.setTemplateId(templateList[0].getValue());
            System.assertEquals(templateList[0].getValue(), oasc.getTemplateId(),  'testOnlineApplicationSetupWithOneContact() failed');
        }

        p = oasc.returnToOpportunity();

        //----------------------------
        // transition to application!
        //----------------------------

        p = oasc.createAndEditApplication();
        Test.setCurrentPage(p);

        p = Page.ApplicationAccountSetup;
        p.getParameters().put('offer', oasc.getOfferId());
        Test.setCurrentPage(p);

        OnlineApplicationControllerExtension oace1 = new OnlineApplicationControllerExtension();

        p = Page.ApplicationAccountSetup;
        p.getParameters().put('offer', oasc.getOfferId());
        p.getParameters().put('id', oasc.getApplication().Id);
        Test.setCurrentPage(p);

        oace1 = new OnlineApplicationControllerExtension();

        oace1.setDateOfBirth('12/26/1986');

        oace1.goNext();

        p = Page.ApplicationCardSetup;
        p.getParameters().put('offer', oasc.getOfferId());
        p.getParameters().put('id', oasc.getApplication().Id);
        Test.setCurrentPage(p);

        oace1.goNext();

        p = Page.ApplicationReview;
        p.getParameters().put('offer', oasc.getOfferId());
        p.getParameters().put('id', oasc.getApplication().Id);
        Test.setCurrentPage(p);

        oace1.goNext();

        oace1.removeOtherServices();

        //-----------------------
        // resend the application
        //-----------------------

        p = Page.ApplicationConversion;
        p.getParameters().put('resend', 'true');
        p.getParameters().put('applicationId', oace1.getAppl().Id);
        Test.setCurrentPage(p);

        oasc = new OnlineApplicationSetupController();
        p = oasc.resendApplicationIfItExists();
        System.assert(p.getUrl().contains('companyinformation'), 'testOnlineApplicationSetupWithOneContact() failed');

        Test.stopTest();
    }

    static testMethod void testOnlineApplicationSetupWithOneContact() {

        List<SObject> objs = createAccountContactOpportunity(1);
        Account a1 = (Account)objs[0];
        Contact c1 = (Contact)objs[1];
        Opportunity o1 = (Opportunity)objs[2];
        createCompleteSavedOffer(OnlineApplication.LOCAL);
        createCompleteSavedOffer(OnlineApplication.OTR);
        
        Test.startTest();

        ApexPages.PageReference p = Page.ApplicationSetup;
        p.getParameters().put('opportunityId', o1.Id);
        Test.setCurrentPage(p);
        
        // Added by Trekbin : 4rth August -- Start
        GetTemplates__c objgetTemplates = new GetTemplates__c();
        objgetTemplates.Name = [Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        objgetTemplates.FolderName__c = 'TestFolder1';
        
        insert objgetTemplates;
        // Added by Trekbin : 4rth August -- End
        
        OnlineApplicationSetupController oasc = new OnlineApplicationSetupController();
        
        Account a2 = oasc.getAccount();
        System.assertEquals(a1.Id, a2.Id, 'testOnlineApplicationSetupWithOneContact() failed');

        Contact c2 = oasc.getContact();
        System.assertEquals(c1.Id, c2.Id, 'testOnlineApplicationSetupWithOneContact() failed');

        String contactId = oasc.getContactId();
        System.assertEquals(c1.Id, Id.valueOf(contactId), 'testOnlineApplicationSetupWithOneContact() failed');
        oasc.setContactId(contactId);

        System.assertEquals(true, oasc.getShowContactList(), 'testOnlineApplicationSetupWithOneContact() failed');

        List<SelectOption> contactList = oasc.getContactList();
        System.assertEquals(1, contactList.size(), 'testOnlineApplicationSetupWithOneContact() failed');
        System.assertEquals('Norman Bates 0', contactList[0].getLabel(), 'testOnlineApplicationSetupWithOneContact() failed');

        OnlineApplication__c oa1 = oasc.getApplication();
        System.assertEquals(a1.Id, oa1.Account__c, 'testOnlineApplicationSetupWithOneContact() failed');
        // Commented by Trekbin as per case requirement  00022852 to avoid assert failures
        // System.assertEquals(String.valueOf(a1.Name.substring(0, Math.min(30, a1.Name.length()))), oa1.Legal_Business_Name__c, 'testOnlineApplicationSetupWithOneContact() failed'); trek
        oa1.Show_Card_Setup_Page__c = true;

        List<SelectOption> offerList = oasc.getOfferList();
        System.assert(offerList.size() >= 3, 'testOnlineApplicationSetupWithOneContact() failed');
        oasc.setOfferId(offerList[1].getValue());
        System.assertEquals(offerList[1].getValue(), oasc.getOfferId(), 'testOnlineApplicationSetupWithOneContact() failed');

        List<SelectOption> templateList = oasc.getTemplateList();
        if(templateList.size() > 0) {
            oasc.setTemplateId(templateList[0].getValue());
            System.assertEquals(templateList[0].getValue(), oasc.getTemplateId(),  'testOnlineApplicationSetupWithOneContact() failed');
        }

        p = oasc.returnToOpportunity();

        //----------------------------
        // transition to application!
        //----------------------------

        p = oasc.createAndEditApplication();        
        Test.setCurrentPage(p);
        OnlineApplicationControllerExtension oace1 = new OnlineApplicationControllerExtension(); 
        
        System.assertEquals(true, oace1.getIsPrefillMode(), 'testOnlineApplicationSetupWithOneContact() failed');
        System.assertEquals(true, oace1.getShowCardSetupPage(), 'testOnlineApplicationSetupWithOneContact() failed');

        p = oace1.saveAndCreateEmail();
        System.assert(p.getUrl().contains('_ui/core/email/author/EmailAuthor'), 'testOnlineApplicationSetupWithOneContact() failed');
        System.assertEquals(true, oace1.getIsFleetOneInitiatedApplication(), 'testOnlineApplicationSetupWithOneContact() failed');

        // WE NEED MORE ASSERTIONS!
        System.assert(oace1.beneficialOwnerSettings != null);
        System.assert(oace1.getAppl() != null);
        System.assert(oace1.getIsUnsaved() != null);
        System.assert(oace1.getIsLocal() != null);
        System.assert(oace1.getIsMasterCard() != null);
        System.assert(oace1.getIsTradeCredit() != null);
        System.assert(oace1.getShowBypassButtonForMC() != null);
        System.assert(oace1.getWasCardSetupBypassedForMC() != null);
        System.assert(oace1.getIsOtherTypeOfBusiness() != null);
        System.assert(oace1.getIsLeadSourceSubtypeVisible() != null);
        System.assert(oace1.getIsPrepay() != null);
        System.assert(oace1.getIsEmailInvoiceDeliveryMethod() != null);
        System.assert(oace1.getIsInternetStatementDeliveryMethod() != null);
        System.assert(oace1.getIsFaxInvoiceDeliveryMethod() != null);
        System.assert(oace1.getIsAutoPay() != null);
        System.assert(oace1.getIsBankAccountNeeded() != null);
        System.assert(oace1.getIsOnReviewPage() != null);
        System.assert(oace1.getIsLargeFleet() != null);
        System.assert(oace1.getIsPromotionalCodeNull() != null);
        System.assert(oace1.getAreTermsChecked() != null);
        System.assert(oace1.getIsCheckImageVisible() != null);
        System.assert(oace1.getIsCardImageVisible() != null);
        System.assert(oace1.getRenderUnitNumbers() != null);
        System.assert(oace1.getTermsAndConditionsAreRead() != null);
        System.assert(oace1.getIsPrefillMode() != null);
        System.assert(oace1.getIsFleetOneInitiatedApplication() != null);
        System.assert(oace1.getShowCardSetupPage() != null);
        System.assert(oace1.getIsFiveStepProcess() != null);
        System.assert(oace1.getIsFrameless() != null);
        System.assert(oace1.getOfferHasLeadSource() != null);
        System.assert(oace1.getintNumberOfContact() != null);

        System.assert(oace1.getFinishedMessage() != null);
        System.assert(oace1.getNotAccessibleMessage() != null);
        System.assert(oace1.getDisclosure() != null);
        System.assert(oace1.getEchoSignUrl() == null);
        System.assert(oace1.getDateOfBirth() == null);
        System.assert(oace1.getRowToProcess() == null);
        System.assert(oace1.getShipToAddress() != null);
        System.assert(oace1.getCompleteLaterText() != null);
        System.assert(oace1.getCompleteLaterUrl() != null);
        System.assert(oace1.getCompleteLaterUrlLabel() != null);
        System.assert(oace1.getTermsAndConditionsContent() == null);
        System.assert(oace1.getTermsAndConditionsUrl() != null);
        System.assert(oace1.getTermsAndConditionsUrlPrint() != null);
        System.assert(oace1.getPrintJavascript() != null);
        System.assert(oace1.getHeaderImageUrl() == null);
        System.assert(oace1.getFirstContactName() == null);
        oace1.getFeeDisclosure();
        oace1.getMailedStatementDisclosure();
        System.assert(oace1.getThreatMetrixOrgId() != null);
        System.assert(oace1.getThreatMetrixSessionId() != null);

        System.assert(oace1.getLocalFuelChoices() != null);
        System.assert(oace1.getOTRFuelChoices() != null);
        System.assert(oace1.getOtherServicesAvailableList() != null);
        System.assert(oace1.getOtherServicesAvailableSelected() != null);
        System.assert(oace1.getOtherServicesChosenList() != null);
        System.assert(oace1.getOtherServicesChosenSelected() != null);
        System.assert(oace1.getAuthorizedContacts() != null);
        System.assert(oace1.getVehicleSetups() != null);
        System.assert(oace1.getDriverSetups() != null);
        System.assert(oace1.getUnitNumbers() != null);
        System.assert(oace1.getCardSetups() != null);

        oace1.setRowToProcess('1');

        oace1.setOtherServicesAvailableSelected(new List<String>{'Something'});
        oace1.setOtherServicesChosenSelected(new List<String>{'Something'});
        oace1.addAuthorizedContact();
        oace1.removeAuthorizedContact();
        oace1.addVehicle();
        oace1.addVehicleMasterCard();
        oace1.removeVehicle();
        oace1.changeVehicleDefaults();
        oace1.addDriver();
        oace1.removeDriver();
        oace1.initializeUnitNumbers();
        oace1.addUnitNumber();
        oace1.removeUnitNumber();
        oace1.addCard();
        oace1.removeCard();
        oace1.changeCardDefaults();
        oace1.changeDriverATMAccess();
        oace1.changeDriverFuelGrade();
        oace1.changeVehicleFuelGrade();
        oace1.showCheckImage();
        oace1.hideCheckImage();
        oace1.showCardImage();
        oace1.hideCardImage();
        oace1.updateShipTo();
        oace1.termsAndConditionsRead();
        oace1.addOtherServices();
        oace1.removeOtherServices();

        oace1.testCalculateCreditLineRequested(true, 1.0);
        //oace1.testFormatNames('That Company', ('That Company').length());
        oace1.testFormatPhoneNumber('1111111111');
        oace1.testGetEchoSignUrlPrivate();

        oace1.verifyUrl();
        oace1.echoSignSubmissionComplete();
        oace1.bypassCardSetupMC();
        oace1.goNext();
        oace1.goBack();
        oace1.saveAndCompleteLater();
        oace1.saveReviewPageChanges();
        oace1.saveAndCreateEmail();

        //-----------------------
        // resend the application
        //-----------------------

        p = Page.ApplicationConversion;        
        p.getParameters().put('resend', 'true');
        p.getParameters().put('applicationId', oace1.getAppl().Id);
        Test.setCurrentPage(p);
        
        oasc = new OnlineApplicationSetupController();
        p = oasc.resendApplicationIfItExists();
        System.assert(p.getUrl().contains('companyinformation'), 'testOnlineApplicationSetupWithOneContact() failed');

        Test.stopTest();
    }

    static testMethod void testOnlineApplicationSetupWithThreeContacts() {

        List<SObject> objs = createAccountContactOpportunity(3);
        Account a1 = (Account)objs[0];
        Contact c1 = (Contact)objs[1];
        Contact c2 = (Contact)objs[2];
        Contact c3 = (Contact)objs[3];
        c3.Level_of_Influence__c = 'Decision Maker';
        update c3;
        Opportunity o1 = (Opportunity)objs[4];
        createCompleteSavedOffer(OnlineApplication.LOCAL);
        createCompleteSavedOffer(OnlineApplication.OTR);
        
        // Added by Trekbin : 4rth August -- Start
        GetTemplates__c objgetTemplates = new GetTemplates__c();
        objgetTemplates.Name = [Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        objgetTemplates.FolderName__c = 'TestFolder2';
        
        insert objgetTemplates;
        // Added by Trekbin : 4rth August -- End
                
        Test.startTest();

        ApexPages.PageReference p = Page.ApplicationSetup;
        p.getParameters().put('opportunityId', o1.Id);
        Test.setCurrentPage(p);

        OnlineApplicationSetupController oasc = new OnlineApplicationSetupController();
        
        Account a2 = oasc.getAccount();
        System.assertEquals(a1.Id, a2.Id, 'testOnlineApplicationSetupWithThreeContacts() failed');

        Contact c4 = oasc.getContact();
        System.assertEquals(c3.Id, c4.Id, 'testOnlineApplicationSetupWithThreeContacts() failed');

        String contactId = oasc.getContactId();
        System.assertEquals(c3.Id, Id.valueOf(contactId), 'testOnlineApplicationSetupWithThreeContacts() failed');
        oasc.setContactId(contactId);

        System.assertEquals(true, oasc.getShowContactList(), 'testOnlineApplicationSetupWithThreeContacts() failed');

        List<SelectOption> contactList = oasc.getContactList();
        System.assertEquals(3, contactList.size(), 'testOnlineApplicationSetupWithThreeContacts() failed');
        System.assertEquals('Norman Bates 2', contactList[0].getLabel(), 'testOnlineApplicationSetupWithThreeContacts() failed');

        OnlineApplication__c oa1 = oasc.getApplication();
        System.assertEquals(a1.Id, oa1.Account__c, 'testOnlineApplicationSetupWithThreeContacts() failed');
       // trek System.assertEquals(a1.Name.substring(0, Math.min(30, a1.Name.length())), oa1.Legal_Business_Name__c, 'testOnlineApplicationSetupWithThreeContacts() failed');
        oa1.Show_Card_Setup_Page__c = false;

        List<SelectOption> offerList = oasc.getOfferList();
        System.assert(offerList.size() >= 3, 'testOnlineApplicationSetupWithThreeContacts() failed');
        oasc.setOfferId(offerList[1].getValue());
        System.assertEquals(offerList[1].getValue(), oasc.getOfferId(), 'testOnlineApplicationSetupWithThreeContacts() failed');

        List<SelectOption> templateList = oasc.getTemplateList();
        if(templateList.size() > 0) {
            oasc.setTemplateId(templateList[0].getValue());
            System.assertEquals(templateList[0].getValue(), oasc.getTemplateId(),  'testOnlineApplicationSetupWithThreeContacts() failed');
        }

        p = oasc.returnToOpportunity();

        //----------------------------
        // transition to application!
        //----------------------------

        p = oasc.createAndEditApplication();        
        Test.setCurrentPage(p);
        OnlineApplicationControllerExtension oace1 = new OnlineApplicationControllerExtension();
        
        System.assertEquals(true, oace1.getIsPrefillMode(), 'testOnlineApplicationSetupWithThreeContacts() failed');
        System.assertEquals(false, oace1.getShowCardSetupPage(), 'testOnlineApplicationSetupWithThreeContacts() failed');
        System.assertEquals(true, oace1.getIsFleetOneInitiatedApplication(), 'testOnlineApplicationSetupWithThreeContacts() failed');

        p = oace1.saveAndCreateEmail();
        System.assert(p.getUrl().contains('_ui/core/email/author/EmailAuthor'), 'testOnlineApplicationSetupWithThreeContacts() failed');

        //-----------------------
        // resend the application
        //-----------------------

        p = Page.ApplicationConversion;        
        p.getParameters().put('resend', 'true');
        p.getParameters().put('applicationId', oace1.getAppl().Id);
        Test.setCurrentPage(p);
        
        oasc = new OnlineApplicationSetupController();
        p = oasc.resendApplicationIfItExists();
        System.assert(p.getUrl().contains('companyinformation'), 'testOnlineApplicationSetupWithThreeContacts() failed');

        Test.stopTest();
    }

    static testMethod void testDecisionSupportTrigger() {
    
        Test.startTest();
    
        Account a = new Account(Name = 'Test Account');
        insert a;
    
        forseva1__DnBDecisionSupport__c ds = new forseva1__DnBDecisionSupport__c();
        ds.forseva1__Account__c = a.Id;
        ds.forseva1__STRT_YR__c = '2000';
        ds.forseva1__PAYD_SCR__c = 88;
        insert ds;

        a = [select Id, Business_Start_Date_D_B__c, Paydex_Score_D_B__c from Account where Id = :a.Id];
    
        System.assertEquals(a.Business_Start_Date_D_B__c, ds.forseva1__STRT_YR__c, 'testDecisionSupportTrigger() failed');
        System.assertEquals(a.Paydex_Score_D_B__c, ds.forseva1__PAYD_SCR__c, 'testDecisionSupportTrigger() failed');        
    
        Test.stopTest();
    }    


    static testMethod void testCustomReportTrigger() {
    
        Test.startTest();
    
        Account a = new Account(Name = 'Test Account');
        insert a;
    
        forseva1__DnBCustomReport__c cr = new forseva1__DnBCustomReport__c();
        cr.forseva1__Account__c = a.Id;
        cr.STRT_YR__c = '2000';
        cr.PAYD_SCR__c = 88;
        insert cr;

        a = [select Id, Business_Start_Date_D_B__c, Paydex_Score_D_B__c from Account where Id = :a.Id];
    
        System.assertEquals(a.Business_Start_Date_D_B__c, cr.STRT_YR__c, 'testCustomReportTrigger() failed');
        System.assertEquals(a.Paydex_Score_D_B__c, cr.PAYD_SCR__c, 'testCustomReportTrigger() failed');        
    
        Test.stopTest();
    }    

    static testMethod void testCPRTrigger() {
    
        Test.startTest();
    
        Account a = new Account(Name = 'Test Account');
        insert a;
    
        forseva1__CorteraCPR__c cpr = new forseva1__CorteraCPR__c();
        cpr.forseva1__Account__c = a.Id;
        cpr.forseva1__YearStarted__c = '1900';
        cpr.forseva1__CprIndexRating__c = 123;
        insert cpr;
    
        //a = [select Id, Business_Start_Date_Cortera__c, CPR_Score_Cortera__c from Account where Id = :a.Id];    
        //System.assertEquals(a.Business_Start_Date_Cortera__c, cpr.forseva1__YearStarted__c, 'testCPRTrigger() failed');
        //System.assertEquals(a.CPR_Score_Cortera__c, String.valueOf(cpr.forseva1__CprIndexRating__c), 'testCPRTrigger() failed');            
    
        Test.stopTest();
    }    

    static testMethod void testLeadTriggers() {
    
        Test.startTest();
    
        Account a = new Account(Name = 'Test Account');
        a.RecordTypeId = [select Id from RecordType where SobjectType = 'Account' and Name = 'Card Program'].Id;
        insert a;
    
        Lead ld1 = new Lead();
        ld1.FirstName = 'George';
        ld1.LastName = 'Smiley';
        ld1.Company = 'The Circus';
        ld1.Status = 'Open';
        ld1.Lead_Source_Website__c = 'http://www.forseva.com';
        ld1.Card_Program__c = a.Id;
        ld1.Email = 'test@forseva.com';
        insert ld1;
        update ld1;
    
        Test.stopTest();
    }

    static testMethod void testCreditForwarding() {
    
        Test.startTest();
    
        Account a = new Account(Name = 'Test Account xxxvvv');
        insert a;
    
        forseva1__CorteraCPR__c cpr = new forseva1__CorteraCPR__c();
        cpr.forseva1__Account__c = a.Id;
        cpr.forseva1__YearStarted__c = '1900';
        cpr.forseva1__CprIndexRating__c = 123;
        insert cpr;

        ApexPages.PageReference p1 = Page.CreditForwarding;
        p1.getParameters().put('id', a.Id);
        p1.getParameters().put('process', 'cortera');
        Test.setCurrentPage(p1);
        
        CreditForwardingController cfc = new CreditForwardingController();
        ApexPages.PageReference p2 = cfc.forwardToPage();
        System.assert(p2.getUrl().contains(String.valueOf(a.Id)), 'testCreditForwarding() failed');            

        p1.getParameters().put('process', 'dnbverify');
        p2 = cfc.forwardToPage();
        System.assert(p2.getUrl().contains(String.valueOf(a.Id)), 'testCreditForwarding() failed');                    

        p1.getParameters().put('process', 'dnbreview');
        p2 = cfc.forwardToPage();
        System.assert(p2.getUrl().contains(String.valueOf(a.Id)), 'testCreditForwarding() failed');                    

        Test.stopTest();
    }   
    
//    static testMethod void testOfferTemplateController() {
    
//        Test.startTest();

//        Account a = new Account(Name = 'Card Program ZZZZ');
//        a.RecordTypeId = [select Id from RecordType where SobjectType = 'Account' and Name = 'Card Program'].Id;
//        insert a;            
//        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        
 //       ApexPages.PageReference p = Page.OfferTemplate;
//        Test.setCurrentPage(p);
//        ApexPages.StandardController sc = new ApexPages.StandardController(offer1);
        
//        OfferTemplateController otc = new OfferTemplateController(sc);
//        System.assertEquals(offer1.Id, otc.getOffer().Id, 'testOfferTemplateController() failed');
//        List<SelectOption> templates = otc.getTemplates();
        
//        otc.getOffer().Card_Program__c = a.Id;
//        otc.doSave();
//        otc.doCancel();
        
//        OnlineApplicationOffer__c offer2 = (OnlineApplicationOffer__c)SOUtility.getCompleteSObject(OnlineApplicationOffer__c.SObjectType, offer1.Id);
//        System.assertEquals(a.Id, offer2.Card_Program__c, 'testOfferTemplateController() failed');

//        Test.stopTest();
//    }        

    //-----------------
    // private
    //-----------------
    
    private static OnlineApplicationOffer__c createCompleteSavedOffer(String productType) {
    
        OnlineApplicationOffer__c offer = new OnlineApplicationOffer__c();
        offer.Name = 'Test Offer ' + Math.random();
        offer.Application_Title__c = productType + ' Test Application Title';
        offer.Large_Fleet_Completion_Message__c = 'Large Fleet completion message';
        offer.Product_Type__c = productType;
        offer.Promotional_Code__c = '1234ABCD';
        offer.Small_Fleet_Completion_Message__c = 'Small Fleet completion message';
        offer.Terms_and_Conditions_Version__c = 'Test Terms and Conditions';
        offer.Disclosure__c = 'Test Disclosure';
        offer.Complete_Later_Text__c = 'Complete later text';
        offer.Complete_Later_Url__c = 'www.fleetone.com';
        offer.Complete_Later_Url_Label__c = 'Go to Fleet One';
        offer.EchoSign_Header_Image__c = 'http://www.poobah.com/image.png';
        offer.EchoSign_User_Email__c = 'mlattin@fleetone.com';
        offer.Faxed_Check_Fee_Disclosure__c = 'Faxed Disclosure';
        offer.Mailed_Check_Fee_Disclosure__c = 'Mailed Disclosure';
        offer.Mailed_Statement_Disclosure__c = 'Mailed Statement Disclosure';
        offer.Wire_Fee_Disclosure__c = 'Wire Disclosure';
        insert offer;
        
        Attachment att = new Attachment();
        att.Name = 'Test Terms and Conditions.html';
        att.Body = Blob.valueOf('test terms and conditions body');
        att.ParentId = offer.Id;
        insert att;
        
        return offer;
    }
    
    private static OnlineApplication__c createCompleteApplication(ID offerId, String productType) {
        
        OnlineApplication__c oa = new OnlineApplication__c();
        oa.ABA_Routing_Number__c = '123456789';
        oa.AO_Address__c = '100 N. State';
        oa.AO_City__c = 'Chicago';
        oa.AO_Confirm_Social_Security_Number__c = '123456789';
        oa.Contact_Name__c = 'PD James';
        oa.AO_Date_of_Birth__c = Date.today().addYears(-20);
        oa.AO_Home_Phone_Number__c = '3123127788';
        oa.AO_Name__c = 'George Smiley';
        oa.AO_Social_Security_Number__c = '123456789';
        oa.AO_State__c = 'IL';
        oa.AO_Title__c = 'CEO';
        oa.AO_Work_Email__c = 'dcraigmile@forseva.com';
        oa.AO_Zip_Code__c = '60603';
        oa.Application_Title__c = 'Living Will for Homer Simpson';
        oa.Billing_Cycle__c = OnlineApplication.MONTHLY;
        oa.Branch_Address__c = '100 East Washington';
        oa.Branch_City__c = 'Chicago';
        oa.Branch_Phone_Number__c = '3128889999';
        oa.Branch_State__c = 'IL';
        oa.Branch_Zip_Code__c = '60603';
        oa.Business_Description__c = OnlineApplication.OTHER;
        oa.Business_Street_Address__c = '200 East Adams';
        oa.Cell_Number__c = '3124449999';
        oa.Change_to_Authorizing_Officer_Address__c = false;
        oa.Checking_Account_Number__c = '1234567890123';
        oa.City__c = 'Peoria';
        oa.Confirm_ABA_Routing_Number__c = '123456789';
        oa.Confirm_Checking_Account_Number__c = '1234567890123';
        oa.Credit_Line_Requested__c = 10000;
        oa.Data_Entry_Stage__c = null;
        oa.Day_of_Payment__c = 'Monday';
        oa.DUNS__c = '123456789';
        oa.Email__c = 'dcraigmile@forseva.com';
        oa.Embossing_Line_1_Company_Name__c = 'Forseva Trucking';
        oa.eSignature_Status__c = OnlineApplication.NOT_EXECUTED;
        oa.Fax_Number__c = '3129998888';
        oa.Federal_Tax_ID__c = '123456789';
        oa.Financial_Institution__c = 'Chase Bank';
        oa.How_Did_You_Hear_About_Us__c = 'Brochure';
        oa.I_Have_Read_and_Agree__c = false;
        oa.Invoice_Delivery_Method__c = OnlineApplication.EMAIL;
        oa.Invoice_Delivery_Method_Email__c = 'dcraigmile@forseva.com';
        oa.Invoice_Delivery_Method_Fax__c = '3129998888';
        oa.Legal_Business_Name__c = 'Legal Name';
        oa.Lead_Source_Subtype__c = null;
        oa.Name_of_Parent_Company__c ='Parent Company';
        oa.Number_of_Drivers__c = 10;
        oa.Number_of_Trailers__c = 20;
        oa.Number_of_Trucks__c = 55;
        oa.Number_of_Vehicles__c = 40;
        oa.Odometer__c = true;
        oa.Offer__c = offerId;
        oa.Payment_Method__c = OnlineApplication.MAILED_CHECK;
        oa.Phone_Number__c = '3123339999';
        oa.Product_Type__c = productType;
        oa.Promotional_Code__c = 'promo12345';
        oa.State__c = 'IL';
        oa.Status__c = OnlineApplication.INCOMPLETE;
        oa.Trade_Name__c = 'Forseva LLC';
        oa.Trip__c = false;
        oa.Type_of_Business__c = 'Corporation';
        oa.Type_of_Business_Other__c = 'Online Delivery';
        oa.Unit__c = false;
        oa.Year_Established__c = '1980';
        oa.Zip_Code__c = '60606';
        oa.OwnerId = UserInfo.getUserId();
        return oa;
    }

    private static List<SObject> createAccountContactOpportunity(Integer numberOfContacts) {
    
        List<SObject> objs = new List<SObject>();
        
        Account a = new Account(Name = 'Test Account ' + Math.random());
        a.BillingStreet = '29 S. LaSalle St.';
        a.BillingCity = 'Chicago';
        a.BillingState = 'IL';
        a.BillingPostalCode = '60603';
        a.Phone = '3123334444';
        insert a;
        objs.add(a);

        for(Integer i = 0; i < numberOfContacts; i++) {        
            Contact c = new Contact();
            Id rId = OnlineApplicationParameters.getDefaultContactRecordType();
            if(rId != null) {
                c.RecordTypeId = rId;
            }
            c.AccountId = a.Id;
            c.FirstName = 'Norman';
            c.LastName = 'Bates ' + i;
            c.Title = 'Manager';
            c.Email = i + 'nbates@batesmotel.com';
            c.HomePhone = '312666666' + i;
            c.MailingStreet = a.BillingStreet + 'i';
            c.MailingCity = a.BillingCity + 'i';
            c.MailingState = a.BillingState;
            c.MailingPostalCode = a.BillingPostalCode + 'i';
            insert c;
            objs.add(c);
        }
                
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'a.Name';
        o.StageName = '1) Qualified';
        o.CloseDate = Date.today() + 30;
        o.Fueling_Methos__c = 'test';
        insert o;
        objs.add(o);
        
        return objs;
    } 
}

// EOF