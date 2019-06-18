/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_OnlineApplicationCls {

     @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testOnlineApplicationClass() {
    
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
    }
    
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
}