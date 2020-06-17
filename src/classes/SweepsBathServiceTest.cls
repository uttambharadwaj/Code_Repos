///*
// * Description: Test coverage for SweepBatchService and SweepsBatch
// * Date: April 2020
// * Author: Lev
// */
@isTest
public class SweepsBathServiceTest {
//
//    //Create test data
//    @testSetup
//    public static void createTestData() {
//        //Create Partner
//        Partner__c partner = TestDataFactory.createPartner(true, 'Wex Partner');
//
//        //Create Program
//        Program__c program = TestDataFactory.createProgram(false, 'Wex Sweep Program');
//        program.Partner__c = partner.Id;
//        insert program;
//
//        //Create Account
//        Account act = TestDataFactory.createAccount(false);
//        act.Program__c = program.Id;
//        insert act;
//
//        //Create Contacts
//        List<Contact> contacts = new List<Contact>();
//        for(Integer i = 0 ; i < 5; i++){
//            Contact c = TestDataFactory.createContact(false, act.Id, 'test1', '1234');
//            c.DoNotCall = true;
//            c.Outbound_Call_Opt_In__c = false;
//            c.HasOptedInOfMobile__c = true;
//            c.et4ae5__HasOptedOutOfMobile__c = false;
//            c.Email_Opt_In_Contact__c = true;
//            c.HasOptedOutOfEmail = false;
//            c.Direct_Mail_Opt_In__c = false;
//            c.Mail_Opt_Out__c = true;
//            contacts.add(c);
//        }
//        insert contacts;
//
//        //Create Campaign
//        Campaign campaign = TestDataFactory.createCampaign(true, 'Wex Camp', '123Wex');
//
//        //Create Campaign Program
//        Campaign_Program__c cmprogram = TestDataFactory.createCampaignProgram(true, campaign.Id, program.Id);
//
//		//Create Lead
//        List<Lead> leads = new List<Lead>();
//        for(Integer i = 0 ; i < 5; i++){
//            Lead l = TestDataFactory.createLead(false, null, '1234');
//            l.DoNotCall = true;
//            l.Outbound_Call_Opt_In__c = false;
//            l.HasOptedInOfMobile__c = true;
//            l.et4ae5__HasOptedOutOfMobile__c = false;
//            l.Email_Opt_In__c = true;
//            l.HasOptedOutOfEmail = false;
//            l.Direct_Mail_Opt_In__c = false;
//            l.Mail_Opt_Out__c = true;
//            l.Campaign_Program__c = cmprogram.Id;
//            leads.add(l);
//        }
//        insert leads;
//    }
//
//    public static testmethod void testLeadUpdated() {
//        List<Lead> lds = [SELECT Id, Email, Phone, MobilePhone, Street, City, State, PostalCode, i2i_ID__c, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c,
//            			  HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In__c, Mail_Opt_Out__c, Direct_Mail_Opt_In__c  FROM Lead WHERE i2i_ID__c = '1234'];
//        Map<Id, Lead> oldMap = new Map<Id, Lead>();
//        for(Lead l : lds) {
//            l.DoNotCall = false;
//            l.Outbound_Call_Opt_In__c = true;
//            l.HasOptedInOfMobile__c = false;
//            l.et4ae5__HasOptedOutOfMobile__c = true;
//            l.Email_Opt_In__c = false;
//            l.HasOptedOutOfEmail = true;
//            l.Direct_Mail_Opt_In__c = true;
//            l.Mail_Opt_Out__c = false;
//            oldMap.put(l.Id, l);
//        }
//
//        Test.startTest();
//        SweepsBatchService.handleLeadUpdate(lds, oldMap);
//
//        //Assert all records match the record changed
//        for(Integer i = 1; i < lds.size(); i++) {
//            System.debug('### lds[i]' + lds[i]);
//            System.assert(!lds[i].HasOptedOutOfEmail);
//            System.assert(lds[i].DoNotCall);
//            System.assert(lds[i].Outbound_Call_Opt_In__c);
//            System.assert(lds[i].et4ae5__HasOptedOutOfMobile__c);
//            System.assert(lds[i].HasOptedInOfMobile__c);
//            System.assert(!lds[i].Email_Opt_In__c);
//            System.assert(!lds[i].Mail_Opt_Out__c);
//            System.assert(!lds[i].Direct_Mail_Opt_In__c);
//        }
//        Test.stopTest();
//
//    }
//
//    public static testmethod void testContactUpdated() {
//        List<Contact> conts = [SELECT Id, Email, Phone, MobilePhone, MailingStreet, MailingCity, MailingState, MailingPostalCode, i2i_id__c, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c,
//            				   HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In_Contact__c,
//            				   Mail_Opt_Out__c, Direct_Mail_Opt_In__c FROM Contact WHERE i2i_ID__c = 'test1'];
//        Map<Id, Contact> oldMap = new Map<Id, Contact>();
//        for(Contact c: conts) {
//            c.DoNotCall = false;
//            c.Outbound_Call_Opt_In__c = true;
//            c.HasOptedInOfMobile__c = false;
//            c.et4ae5__HasOptedOutOfMobile__c = true;
//            c.Email_Opt_In_Contact__c = false;
//            c.HasOptedOutOfEmail = true;
//            c.Direct_Mail_Opt_In__c = true;
//            c.Mail_Opt_Out__c = false;
//            oldMap.put(c.Id, c);
//        }
//
//        Test.startTest();
//        SweepsBatchService.handleContactUpdate(conts, oldMap);
//
//        //Assert all records match the record changed
//        for(Integer i = 1; i < conts.size(); i++) {
//            System.assert(!conts[i].HasOptedOutOfEmail);
//            System.assert(conts[i].DoNotCall);
//            System.assert(conts[i].Outbound_Call_Opt_In__c);
//            System.assert(conts[i].et4ae5__HasOptedOutOfMobile__c);
//            System.assert(conts[i].HasOptedInOfMobile__c);
//            System.assert(!conts[i].Email_Opt_In_Contact__c);
//            System.assert(!conts[i].Mail_Opt_Out__c);
//            System.assert(!conts[i].Direct_Mail_Opt_In__c);
//        }
//
//        Test.stopTest();
//    }
}