/*
 * Description: Test coverage for SweepBatchService and SweepsBatch
 * Date: April 2020
 * Author: Lev
 */
@isTest
public class SweepsBathServiceTest {
    
    //Create test data
    @testSetup
    public static void createTestData() {
        //Create Partner
        Partner__c partner = TestDataFactory.createPartner(true, 'Wex Partner');
        
        //Create Program
        Program__c program = TestDataFactory.createProgram(false, 'Wex Sweep Program');
        program.Partner__c = partner.Id;
        insert program;
        
        //Create Account
        Account act = TestDataFactory.createAccount(false);
        act.Program__c = program.Id;
        insert act;
        
        //Create Contacts
        List<Contact> contacts = new List<Contact>();
        Integer batchLimit = Integer.valueOf(Label.SweepBatchLimit);
        for(Integer i = 0 ; i < batchLimit; i++){
            Contact c = TestDataFactory.createContact(false, act.Id, 'test1', '1234');
            contacts.add(c);
        }
        insert contacts;
        
        //Create Campaign
        Campaign campaign = TestDataFactory.createCampaign(true, 'Wex Camp', '123Wex');
        
        //Create Campaign Program
        Campaign_Program__c cmprogram = TestDataFactory.createCampaignProgram(true, campaign.Id, program.Id);

		//Create Lead
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0 ; i < batchLimit; i++){
            Lead l = TestDataFactory.createLead(false, null, '1234');
            l.Campaign_Program__c = cmprogram.Id;
            leads.add(l);
        }
        insert leads;
    }
    
    public static testmethod void testLeadUpdated() {
        List<Lead> lds = [SELECT Id, i2i_ID__c, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, 
            			  HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In__c, Mail_Opt_Out__c, Direct_Mail_Opt_In__c  FROM Lead WHERE i2i_ID__c = '1234'];
        
        lds[0].DoNotCall = true;
        lds[0].Email_Opt_In__c = false;
        lds[0].Mail_Opt_Out__c = true;
        lds[0].Direct_Mail_Opt_In__c = false;
        lds[0].HasOptedOutOfEmail = true;
        lds[0].Outbound_Call_Opt_In__c = false;
        lds[0].et4ae5__HasOptedOutOfMobile__c = true;
        lds[0].HasOptedInOfMobile__c = false;
        update lds[0];
        
        Test.startTest();
        SweepsBatchService.handleLeadUpdate(lds);

        //Assert all records match the record changed
        for(Integer i = 1; i < lds.size(); i++) {
            System.assert(lds[i].HasOptedOutOfEmail);
            System.assert(lds[i].DoNotCall);
            System.assert(!lds[i].Outbound_Call_Opt_In__c);
            System.assert(lds[i].et4ae5__HasOptedOutOfMobile__c);
            System.assert(!lds[i].HasOptedInOfMobile__c);
            System.assert(!lds[i].Email_Opt_In__c);
            System.assert(lds[i].Mail_Opt_Out__c);
            System.assert(!lds[i].Direct_Mail_Opt_In__c);
        }
        Test.stopTest();
        
    }
    public static testmethod void testContactUpdated() {
        List<Contact> conts = [SELECT Id, i2i_id__c, PartnerID__c, DoNotCall, Outbound_Call_Opt_In__c , et4ae5__HasOptedOutOfMobile__c, 
            				   HasOptedInOfMobile__c, HasOptedOutOfEmail, Email_Opt_In_Contact__c,
            				   Mail_Opt_Out__c, Direct_Mail_Opt_In__c FROM Contact WHERE i2i_ID__c = 'test1'];
        
        conts[0].DoNotCall = true;
        conts[0].Email_Opt_In_Contact__c = false;
        conts[0].Mail_Opt_Out__c = true;
        conts[0].Direct_Mail_Opt_In__c = false;
        conts[0].HasOptedOutOfEmail = true;
        conts[0].Outbound_Call_Opt_In__c = false;
        conts[0].et4ae5__HasOptedOutOfMobile__c = true;
        conts[0].HasOptedInOfMobile__c = false;
        update conts[0];
        
        Test.startTest();
        SweepsBatchService.handleContactUpdate(conts);

        //Assert all records match the record changed
        for(Integer i = 1; i < conts.size(); i++) {
            System.assert(conts[i].HasOptedOutOfEmail);
            System.assert(conts[i].DoNotCall);
            System.assert(!conts[i].Outbound_Call_Opt_In__c);
            System.assert(conts[i].et4ae5__HasOptedOutOfMobile__c);
            System.assert(!conts[i].HasOptedInOfMobile__c);
            System.assert(!conts[i].Email_Opt_In_Contact__c);
            System.assert(conts[i].Mail_Opt_Out__c);
            System.assert(!conts[i].Direct_Mail_Opt_In__c);
        }
        
        Test.stopTest();
    }
}