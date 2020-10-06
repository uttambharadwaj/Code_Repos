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
private class Test_ApplicationCardSetup {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }


    static testMethod void testConvertOTRToAccountContactOpportunity() {
        
        Test.startTest();
                
        OnlineApplicationOffer__c offer1 = createCompleteSavedOffer(OnlineApplication.LOCAL);
        OnlineApplication__c oa_so = createCompleteApplication(offer1.Id, OnlineApplication.LOCAL);
        oa_so.AO_Name__c = 'George Smiley';
        oa_so.Contact_Name__c = 'George Smiley';

        Integer contactCount1 = [select count() from Contact where Name = :oa_so.Contact_Name__c];

        insert oa_so;
  
        ApexPages.PageReference p = Page.ApplicationConversion;
        p.getParameters().put(OnlineApplicationConversionController.APPLICATION_ID, oa_so.Id);
        p.getParameters().put(OnlineApplicationConversionController.CONVERSION_TYPE, OnlineApplicationConversionController.NEW_ACCOUNT);
        Test.setCurrentPage(p);

        OnlineApplicationConversionController oacc = new OnlineApplicationConversionController();
        ApexPages.PageReference pc1 = oacc.performConversion(); // creates new records the first time

        OnlineApplication__c oApp = [select Id, Account__c from OnlineApplication__c where Id = :oa_so.Id];
        Account a = [select Id, Name from Account where Id = :oApp.Account__c];
        Contact c = [select Id, Name, Lead_Source_Sub_Type2__c from Contact where AccountId = :a.Id];
        Opportunity o = [select Id, Name from Opportunity where AccountId = :a.Id];
        Integer contactCount2 = [select count() from Contact where Name = :oa_so.Contact_Name__c]; 

        System.assertEquals(oa_so.Legal_Business_Name__c, a.Name, 'testConvertOTRToAccountContactOpportunity() failed');
        System.assertEquals(oa_so.AO_Name__c, c.Name, 'testConvertOTRToAccountContactOpportunity() failed');
        System.assertEquals(oa_so.Lead_Source_Subtype__c, c.Lead_Source_Sub_Type2__c, 'testConvertOTRToAccountContactOpportunity() failed');
        System.assert(o.Name.contains(oa_so.Application_Title__c), 'testConvertOTRToAccountContactOpportunity() failed');

        p = Page.ApplicationConversion;
        p.getParameters().put(OnlineApplicationConversionController.APPLICATION_ID, oa_so.Id);
        p.getParameters().put(OnlineApplicationConversionController.CONVERSION_TYPE, OnlineApplicationConversionController.EXISTING_ACCOUNT);
        Test.setCurrentPage(p);

        oacc = new OnlineApplicationConversionController();
       // ApexPages.PageReference pc2 = oacc.performConversion(); // updates existing records the second time 
         
       /*Integer contactCount3 = [select count() from Contact where Name = :oa_so.Contact_Name__c];
        
        System.assertEquals(contactCount1+1, contactCount2, 'testConvertOTRToAccountContactOpportunity() failed ' + c.Name + ':' + oa_so.Contact_Name__c);
        System.assertEquals(contactCount2, contactCount3, 'testConvertOTRToAccountContactOpportunity() failed');
        System.assertEquals(pc1.getUrl(), pc2.getUrl(), 'testConvertOTRToAccountContactOpportunity() failed');*/
        
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