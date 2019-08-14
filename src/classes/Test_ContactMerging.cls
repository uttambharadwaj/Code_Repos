/**
 * Created by: Phillip Southern (GearsCRM)
 *	Date: 03/13/2014
 *
 */
@isTest
private class Test_ContactMerging {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void mergeContactsi2iId() {
        
        test.startTest();
        
        List<Account> accounts = utestdata.getAccounts(2);
        insert accounts;
        List<Contact> contacts = utestdata.getContacts(accounts);
        contacts[0].i2i_ID__c = '1';
        insert contacts;
        
        List<Opportunity> opps = utestdata.getOpportunities(accounts);
        insert opps;

        Campaign c = new Campaign(name='test');
        insert c;
        CampaignMember cm = new CampaignMember(campaignid=c.Id, contactid=contacts[1].Id);
        insert cm;
        
        Task t = utestdata.getopentask('test',contacts[1].Id,null);
        insert t;
        
        Contact_Merge_Settings__c cms = new Contact_Merge_Settings__c();
        cms.name='Task';
        cms.object__c='Task';
        cms.active__c = true;
        cms.field__c='WhoId';
        //cms.relationship__c='Who';
        insert cms;
        
        Contact_Merge_Settings__c cms2 = new Contact_Merge_Settings__c();
        cms2.name='OpportunityContactRole';
        cms2.field__c='ContactId';
        //cms2.relationship__c='Contact';
        insert cms2;

        Contact_Merge_Settings__c cms3 = new Contact_Merge_Settings__c();
        cms3.name='CampaignMember';
        cms3.object__c='CampaignMember';
        cms3.active__c = true;
        cms3.field__c='ContactId';
        //cms3.relationship__c='Contact';
        insert cms3;
        
        test.stopTest();

        contacts[1].i2i_ID__c = '1';
        update contacts;


        system.assertEquals([Select Id from Contact].size(),1);
    }

    static testMethod void mergeContactsi2iIdWithExcludes() {

   		Id rectypeid = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Truckers_Contacts' LIMIT 1].Id;

        List<Account> accounts = utestdata.getAccounts(2);
        insert accounts;
        List<Contact> contacts = utestdata.getContacts(accounts);
        contacts[0].i2i_ID__c = '1';
        contacts[0].RecordTypeId = rectypeid;
        contacts[1].RecordTypeId = rectypeid;
        insert contacts;

        test.startTest();
        contacts[1].i2i_ID__c = '1';
        update contacts;
        test.stopTest();

        system.assertEquals(2,[Select Id from Contact].size());
    }    

    static testMethod void mergeContactsi2iIdWithoutExcludes() {

        List<Account> accounts = utestdata.getAccounts(2);
        insert accounts;
        List<Contact> contacts = utestdata.getContacts(accounts);
        contacts[0].i2i_ID__c = '1';
        insert contacts;

        test.startTest();
        contacts[1].i2i_ID__c = '1';
        update contacts;
        test.stopTest();

        system.assertEquals(1,[Select Id from Contact].size());
    }    
}